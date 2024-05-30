return function(_, id)
    local properties = {}
    for i = 1, 18 do
        properties[tostring(i)] = DCS.getUnitProperty(id, i)
    end
    local response = {
        id = DCS.getUnitProperty(id, 2),
        name = DCS.getUnitProperty(id, 3),
        type = DCS.getUnitProperty(id, 4),
        category = DCS.getUnitProperty(id, 5),
        group_name = DCS.getUnitProperty(id, 7),
        object_category = DCS.getUnitProperty(id, 8),
        tail_nr = DCS.getUnitProperty(id, 9),
        coalition = DCS.getUnitProperty(id, 11),
        country = DCS.getUnitProperty(id, 12),
        task = DCS.getUnitProperty(id, 13),
        pilot = DCS.getUnitProperty(id, 15),
        skill = DCS.getUnitProperty(id, 17),
        unknown = {
            [6] = DCS.getUnitProperty(id, 6),
            [10] = DCS.getUnitProperty(id, 10),
            [14] = DCS.getUnitProperty(id, 14),
            [15] = DCS.getUnitProperty(id, 16),
            [18] = DCS.getUnitProperty(id, 18),
        }
    }
    response.display_name = DCS.getUnitTypeAttribute(response.type, "DisplayName")
    local unitTypeDesc = me_db.unit_by_type[response.type]
    if unitTypeDesc and unitTypeDesc.attribute then
        response.attribute = unitTypeDesc.attribute
    end
    return OpsdcsApi:response200(response)
end
