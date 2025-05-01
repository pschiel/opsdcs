-- Name of the livery
name = "example livery"

-- List of texture replacements
-- A template of this table with all available model sections can be created with model viewer "Generate livery file"
-- Note: for best upwards compatibility, only specify textures that are actually replaced (used with "false")
livery = {
    {
        -- Name of section in model
        "pilot_F18C_helmet",
        
        -- Layer
        -- DIFFUSE            0    Base Color
        -- NORMAL             1    Normals/Depth and Depth Affects (ie Rain/Scratches on Glass, Panel Lines and Rivets.
        -- SPECULAR           2    (Replaced by RoughMet Map w/ DCS 2.5) Surface Properties for Surface Flare Intensity, Width and Reflection
        -- DECAL              3    Decal Layer, a opacity layer for adding Decals w/ out changing the base color layer.
        -- DIRT               4    Layer used for Dirty Build Up on an Object
        -- DAMAGE             5    Layer Used for Procedural Damage Volumetric (Small Scuffs -> Bullet Holes -> Large Holes -> Removed Surfaces)
        -- PUDDLES            6    Used to Place Water/Puddles on Surfaces (Puddles on Runways etc)
        -- SNOW               7    Used to Place Snow on Surfaces (Snow on Buildings/Bunkers/Runways etc)
        -- SELF_ILLUMINATION  8    Used to Make a Texture Self Illuminated (Diffuse = Color, Alpha = Strength)
        -- AMBIENT OCCLUSION  9    (Replaced w/ RoughMet Map w/ DCS 2.5) Used to Place Ambient Occlusions on Models
        -- DAMAGE             10   Used to Place Damage Diffuse Color (Appearance of Dirt/Burn Marks)
        -- ROUGHMET           13   Used for PBR Surface Properties, (R = AO dark/light, G = Roughness shiny/dull, B = Metalness nometal/metal)
        -- OPACITY            14   Used for Surface Opacity (Mainly for Glass Material, or Textures for Meshes) 
        DIFFUSE,
        
        -- texture file
        "NameOfTexture",
        
        -- true:  loads texture file from VFS (can use everything mounted with mount_vfs_texture_path)
        -- false: loads texture from this livery folder
        false
    }

}

-- Available countries
countries = {"USA", "ISR"}

-- Order in livery list
order = 1000

-- Argument settings (example: F18)
-- Can be viewed in model viewer
custom_args = 
{
    [323] = 1.0,  -- ladder
    [115] = 1.0,  -- some door
    [38] = 0.8,   -- canopy position
    [24] = 1.0,   -- engine cover
    [224] = 1.0,  -- left wing damage
}
