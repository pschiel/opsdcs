return function(_, id)
    local result = Export.LoGetObjectById(id)
    return 200, result
end
