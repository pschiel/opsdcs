--- Adds a slingable cargo object
--- @param params table @unit parameters
local function add_cargo(params)
    -- shape table data
    params.shape_table_data = {
        {
            file = params.ShapeName,
            life = params.Life,
            username = params.Name,
            desrt = params.ShapeNameDestr,
        }
    }
    -- destruction shape
    if params.ShapeNameDestr then
        params.shape_table_data[2] = {
            name = params.ShapeName,
            file = params.ShapeNameDestr,    
        }
    end
    -- icon on the map
    params.mapclasskey = params.mapclasskey or "P0091000352";

    -- attribute and category for cargo
    params.attribute = params.attribute or { "Cargos" }
    params.category = pararms.category or "Cargo"
    params.couldCargo = params.couldCargo or true

    -- misc params
    params.Rate = params.Rate or 100
    params.canExplode = params.canExplode or false
    params.topdown_view = params.topdown_view or topdown_view

    -- add the unit
    add_surface_unit(params)
end
