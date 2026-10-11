local example = {}
example.title = "Canvas"
example.category = "Object Demonstrations"

function example.func(loveframes, centerarea)
    local rectX = 0
    local rectY = 0
    local speedX = 20.5
    local speedY = 20.5

    local frame = loveframes.Create("frame")
    frame:SetName("Canvas")
    frame:SetWidth(600)
    frame:SetHeight(400)
    frame:CenterWithinArea(unpack(centerarea))

    local canvas = loveframes.Create("canvas")
    canvas:SetParent(frame)
    canvas:SetSize(frame:GetWidth(), frame:GetHeight())
    canvas.DrawOnCanvas = function(obj)
        love.graphics.clear(0, 0, 0, 1)
        love.graphics.setColor(0.4, 0.6, 1, 1)
        love.graphics.rectangle("fill", rectX, rectX, 32, 32)
        love.graphics.setColor(1, 1, 1, 1)
    end

    frame.Update = function(obj, elapsed)
        if (rectX + 32 >= frame:GetWidth()) or (rectX <= 0) then
            speedX = -speedX
        end

        if (rectY + 32 >= frame:GetHeight()) or (rectY <= 0) then
            speedY = -speedY
        end

        rectX = rectX + speedX * elapsed
        rectY = rectY + speedY * elapsed
    end
end

return example
