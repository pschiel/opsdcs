return function(_, id)
    local response = Export.LoGetObjectById(id)
    return OpsdcsApi:response200(response)
end
