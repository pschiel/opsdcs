name = "example livery"

livery = {
	{
		-- Name of section in model
		"f18c1",
		
		-- Layer
		-- DIFFUSE  0 	BASE COLOR
		-- NORMAL 	1 	Normals/Depth and Depth Affects (ie Rain/Scratches on Glass, Panel Lines and Rivets.
		-- SPECULAR 2 	Surface Properties for Surface Flare Intensity, Width and Reflection (Replaced by RoughMet Map w/ DCS 2.5)
		-- DECAL 	3 	Decal Layer, a opacity layer for adding Decals w/ out changing the base color layer.
		-- DIRT 	4 	Layer used for Dirty Build Up on an Object
		-- DAMAGE 	5 	Layer Used for Procedural Damage Volumetric (Small Scuffs -> Bullet Holes -> Large Holes -> Removed Surfaces)
		-- PUDDLES 	6 	Used to Place Water/Puddles on Surfaces (Puddles on Runways etc)
		-- SNOW 	7 	Used to Place Snow on Surfaces (Snow on Buildings/Bunkers/Runways etc)
		-- SELF_ILLUMINATION 	8 	Used to Make a Texture Self Illuminated (Diffuse = Color, Alpha = Strength)
		-- AMBIENT OCCLUSION 	9 	Used to Place Ambient Occlusions on Models (Replaced w/ RoughMet Map w/ DCS 2.5)
		-- DAMAGE 	10 	Used to Place Damage Diffuse Color (Appearance of Dirt/Burn Marks around
		-- ROUGHMET 13 	Used for PBR Surface Properties, (Ambient Occlusion, Microsurface, Reflectivity)
		-- OPACITY 	14 	Used for Surface Opacity (Mainly for Glass Material, or Textures for Meshes) 
		0,
		
		-- texture file
		"NameOfTexture",
		
		-- false: in livery folder
		-- true:  somewhere else (mounted)
		false
	}

}

-- available countries
countries = {"USA", "ISR"}

-- order in livery list
order = 1000

-- argument settings (ex: f18)
-- can be viewed in model viewer
custom_args = 
{
	[323] = 1.0, -- ladder
	[115] = 1.0, -- some door
	[38] = 0.8, -- canopy position
	[24] = 1.0, -- engine cover
	[224] = 1.0, -- left wing damage
}
