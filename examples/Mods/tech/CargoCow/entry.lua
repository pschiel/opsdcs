declare_plugin("CargoCow", {
    dirName	= current_mod_path,
    displayName = _("CargoCow"),
    shortName = "CargoCow",
    version = __DCS_VERSION__,
    state = "installed",
    developerName = "ops",
    info = localized,
})

local function add_cargo(f)
	f.shape_table_data = {
		{
			file = f.ShapeName,
			life = f.Life,
			username = f.Name,
			desrt = f.ShapeNameDestr or "self",
            fire = { 60, 2 },
			-- classname = f.classname or "lLandVehicle",
			-- positioning = f.positioning or "ONLYHEIGTH"	--available: {"BYNORMAL", "ONLYHEIGTH", "BY_XZ", "ADD_HEIGTH"}
		},
		{
			name = f.ShapeName,
			file = f.ShapeNameDestr,
            life = 0,
            fire = { 0, 2 },
		}
	}
	add_surface_unit(f)
	GT = nil;
end

local f = {
    Name = "CargoCow",
	DisplayName = _("CargoCow"),
	ShapeName = "Cow",
	ShapeNameDestr = "Cow_d",
    Life = 2500,
	Rate = 100,
	mapclasskey = "P_COW",
	attribute = { "Cargos" },
    category = "Cargo",
	desrt = "self",
	canExplode = false,
	mass = 700,
    minMass = 400,
	maxMass = 2000,
	couldCargo = true,
    topdown_view = topdown_view,
	sound = "Animals/Cow",
	sound_interval = { 10, 60 },
    -- SeaObject = false,
    -- isPutToWater = false,
}

add_cargo(f)

plugin_done()
