function OpsdcsApi:handleCamera()
    if self.targetCamera then
        local camera = Export.LoGetCameraPosition()
        if not self:cameraEquals(camera, self.targetCamera, 0.01) then
            Export.LoSetCameraPosition(self:lerpCamera(camera, self.targetCamera, 0.05))
        else
            self.targetCamera = nil
        end
    end
end

function OpsdcsApi:lerpCamera(cam1, cam2, t)
    for _, vec in ipairs({"x", "y", "z", "p"}) do
        for _, coord in ipairs({"x", "y", "z"}) do
            cam1[vec][coord] = cam1[vec][coord] + (cam2[vec][coord] - cam1[vec][coord]) * t
        end
    end
    return cam1
end

function OpsdcsApi:cameraEquals(cam1, cam2, precision)
    for _, vec in ipairs({"x", "y", "z", "p"}) do
        for _, coord in ipairs({"x", "y", "z"}) do
            if math.abs(cam1[vec][coord] - cam2[vec][coord]) >= precision then
                return false
            end
        end
    end
    return true
end
