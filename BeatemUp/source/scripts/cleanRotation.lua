-- cleanRotation
-- Little set of functions to generate flipbook of clean image rotation

cleanRotation = {}

-- Return an upscaled version of the image
-- See https://en.wikipedia.org/wiki/Pixel-art_scaling_algorithms#EPX/Scale2×/AdvMAME2×
function cleanRotation.scale2X(image)
    if not image then return end

    local ow, oh = image:getSize()
    local nw, nh = ow * 2, oh * 2

    local scaled_image = playdate.graphics.image.new(nw, nh)
    playdate.graphics.pushContext(scaled_image)

    for y = 0, oh - 1 do
        local pixel = image:sample(0, y)
        local left = nil
        local right = image:sample(1, y)

        for x = 0, ow - 1 do
            local top = image:sample(x, y - 1)
            local bottom = image:sample(x, y + 1)

            local tl, tr, bl, br = pixel

            if left == top and left ~= bottom and top ~= right then
                tl = top
            end

            if top == right and top ~= left and right ~= bottom then
                tr = right
            end

            if bottom == left and bottom ~= right and left ~= top then
                bl = left
            end

            if right == bottom and right ~= topt and bottom ~= left then
                br = bottom
            end

            playdate.graphics.setColor(tl or pixel)
            playdate.graphics.drawPixel(x * 2, y * 2)

            playdate.graphics.setColor(tr or pixel)
            playdate.graphics.drawPixel(x * 2 + 1, y * 2)

            playdate.graphics.setColor(bl or pixel)
            playdate.graphics.drawPixel(x * 2, y * 2 + 1)

            playdate.graphics.setColor(br or pixel)
            playdate.graphics.drawPixel(x * 2 + 1, y * 2 + 1)

            left = pixel
            pixel = right
            right = image:sample(x + 2, y)
        end
    end

    playdate.graphics.popContext()

    return scaled_image
end

-- Return an upscaled version (x8) of the image
function cleanRotation.scale8X(image)
    local scale2X = cleanRotation.scale2X
    return scale2X(scale2X(scale2X(image)))
end

function cleanRotation.shearx(image, shear)
    if not image then return end

    local shear_abs = math.abs(shear)
    local ow, oh = image:getSize()
    local shear_delta = shear_abs * oh
    local rw, rh = ow + math.ceil(shear_delta), oh

    local result_image = playdate.graphics.image.new(rw, rh)
    playdate.graphics.pushContext(result_image)

    local x = 0
    if shear < 0 then x = shear_delta end

    for y = 0, oh - 1 do
        image:draw(x, y, playdate.graphics.kImageUnflipped, 0, y, ow + 1, 1)
        x = x + shear
    end

    playdate.graphics.popContext()

    return result_image
end

function cleanRotation.sheary(image, shear)
    if not image then return end

    local shear_abs = math.abs(shear)
    local ow, oh = image:getSize()
    local shear_delta = shear_abs * ow
    local rw, rh = ow, oh + math.ceil(shear_delta)

    local result_image = playdate.graphics.image.new(rw, rh)
    playdate.graphics.pushContext(result_image)

    local y = 0
    if shear < 0 then y = shear_delta end

    for x = 0, ow - 1 do
        image:draw(x, y, playdate.graphics.kImageUnflipped, x, 0, 1, oh + 1)
        y = y + shear
    end

    playdate.graphics.popContext()

    return result_image
end

-- return the size of image that can include any rotated image for any angle
function cleanRotation.get_360image_size(image)
    local ow, oh = image:getSize()

    local top_left = playdate.geometry.point.new(0, 0)
    local bottom_right = playdate.geometry.point.new(image:getSize())
    local widest = math.ceil(top_left:distanceToPoint(bottom_right))

    return widest, widest
end

-- Return a clean rotated version of the image
-- scaled_image (optional but recommended): upscaled version of the image. Can be used to not have to recalculate a scaled version each time or to use an image upscaled with a different mean
--
-- Clean Rotation principle is based on RotSprite
-- 1. Upscale the image x8 with an upscaler algorithm like scale2X
-- 2. Rotate and Downscale the Upscaled image
-- 3. Profit
function cleanRotation.rotate_clean(image, angle, scaled_image)
    if not image then return end

    angle = angle or 0

    local input_width, input_height = image:getSize()
    local output_width, output_height = cleanRotation.get_360image_size(image)
    local output_image = playdate.graphics.image.new(output_width, output_height)
    print(output_width, output_height, " / ", output_image:getSize())

    playdate.graphics.pushContext(output_image)
    playdate.graphics.clear(playdate.graphics.kColorClear)

    if angle == 0 then
        image:drawAnchored(output_width / 2, output_height / 2, 0.5, 0.5)
    else
        if not scaled_image then
            scaled_image = cleanRotation.scale8X(image)
        end
        local scaled_width, scaled_height = scaled_image:getSize()

        scaled_image:drawRotated(output_width / 2, output_height / 2, angle, input_width / scaled_width,
            input_height / scaled_height)
    end

    playdate.graphics.popContext()

    return output_image
end

-- Return a rotated version of the image while keeping dithering effect
--
-- Dithering optimization is based on doing rotation with shearing just by shifting pixels
-- https://cohost.org/tomforsyth/post/891823-rotation-with-three
-- https://www.ocf.berkeley.edu/~fricke/projects/israel/paeth/rotation_by_shearing.html
function cleanRotation.rotate_shear(image, angle)
    if not image then return end

    angle = angle % 360
    if angle > 90 and angle < 270 then
        local flipped_image = playdate.graphics.image.new(image:getSize())

        playdate.graphics.pushContext(flipped_image)
        image:draw(0, 0, playdate.graphics.kImageFlippedXY)
        playdate.graphics.popContext()

        angle = (angle + 180) % 360
        image = flipped_image
    end

    rad_angle = math.rad(angle)
    local step1 = cleanRotation.shearx(image, -math.tan(rad_angle / 2))
    local step2 = cleanRotation.sheary(step1, math.sin(rad_angle))
    local step3 = cleanRotation.shearx(step2, -math.tan(rad_angle / 2))

    local output_width, output_height = cleanRotation.get_360image_size(image)
    local output_image = playdate.graphics.image.new(output_width, output_height)
    playdate.graphics.pushContext(output_image)
    step3:drawAnchored(output_width / 2, output_height / 2, 0.5, 0.5)
    playdate.graphics.popContext()

    return output_image
end

-- Generate an image table of all clean rotation angles for an image
-- frame_count: How many image the image table should contain
-- optimization_type:
--		"outline" (default): create cleaner outline with less fuziness
--		"dithering": try to keep the dithering effect with less moire pattern
--		"none": use default image rotation from the sdk
function cleanRotation.generate_imagetable(image, frame_count, optimization_type)
    if not playdate.isSimulator then
        print(
        "cleanRotation.generate_imagetable() should probably not be called on the playdate device and only in the simulator.")
    end

    optimization_type = optimization_type or "outline"
    frame_count = frame_count or 90
    if frame_count <= 0 then
        return
    end

    if not (optimization_type == "outline" or optimization_type == "dithering" or optimization_type == "none") then
        print("cleanRotation.generate_imagetable() the argument optimization_type is not valid:", optimization_type)
        return
    end

    local angle = 0
    local angle_step = 360 / frame_count

    local scaled_image
    if optimization_type == "outline" then
        scaled_image = cleanRotation.scale8X(image)
    end

    local output_imagetable = playdate.graphics.imagetable.new(frame_count)

    for frame_index = 1, frame_count do
        local rotated_image

        if optimization_type == "outline" then
            rotated_image = cleanRotation.rotate_clean(image, angle, scaled_image)
        elseif optimization_type == "dithering" then
            rotated_image = cleanRotation.rotate_shear(image, angle)
        else
            local w, h = cleanRotation.get_360image_size(image)
            rotated_image = playdate.graphics.image.new(w, h)
            playdate.graphics.pushContext(rotated_image)
            image:drawRotated(w / 2, h / 2, angle)
            playdate.graphics.popContext()
        end

        output_imagetable:setImage(frame_index, rotated_image)

        angle = angle + angle_step
    end

    return output_imagetable
end

-- Save the image table in the Data folder
-- the exported file can be use in the project and loaded as an imagetable directly
function cleanRotation.export_imagetable(image_table, export_filename)
    export_filename = export_filename or 'cleanRotationExport'

    local frame_count = #image_table
    local angle_step = 360 / frame_count
    local image_width, image_height = image_table[1]:getSize()

    export_filename = export_filename .. "-table-" .. image_width .. "-" .. image_height
    local export_image = playdate.graphics.image.new(image_width * frame_count, image_height)

    playdate.graphics.pushContext(export_image)

    local x = 0
    for frame_index = 1, frame_count do
        image_table[frame_index]:draw(x, 0)
        x = x + image_width
    end

    playdate.graphics.popContext()
    playdate.datastore.writeImage(export_image, export_filename .. ".gif")
end

-- Return the image corresponding to an angle in an image table (ideally exported with cleanRotation)
function cleanRotation.get_image_from_angle(image_table, angle)
    if not image_table then return end

    local frame_count = #image_table
    local angle_step = 360 / frame_count
    local index0 = (angle + angle_step / 2) // angle_step

    return image_table[index0 % frame_count + 1]
end
