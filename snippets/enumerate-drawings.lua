for _, l in ipairs(env.mission.drawings.layers) do
    local name = l.name -- Red, Blue, Neutral, Common, Author
    local mapX = l.mapX -- position x
    local mapY = l.mapY -- position y
    for _, o in ipairs(l.objects) do
        local thickness = o.thickness
        local colorString = o.colorString
        local fillColorString = o.fillColorString
        local angle = o.angle
        if o.primitiveType == "Polygon" then
            local style = o.style
            if o.polygonMode == "rect" then
                local width = o.width
                local height = o.height
                -- create rect..
            elseif o.polygonMode == "free" then
                local points = o.points -- x/y
                -- create poly..
            elseif o.polygonMode == "circle" then
                local radius = o.radius
                -- create circle..
            elseif o.polygonMode == "oval" then
                local r1 = o.r1
                local r2 = o.r2
                -- create oval..
            elseif o.polygonMode == "arrow" then
                local length = o.length
                local points = o.points -- x/y
                -- create arrow..
            end
        elseif o.primitiveType == "Line" then
            if o.lineMode == "segments" then
                local points = o.points -- x/y
                -- create line segments..
            end
        elseif o.primitiveType == "TextBox" then
            local text = o.text
            local font = o.font
            local fontSize = o.fontSize
            local borderThickness = o.borderThickness
            -- create text box..
        elseif o.primitiveType == "Icon" then
            local scale = o.scale
            local file = o.file
            -- create icon..
        end
    end
end