-- Name of the livery
name = "example livery"

-- List of texture replacements
-- A template of this table with all available model sections can be created with model viewer "Generate livery file"
-- Note: for best upwards compatibility, only specify textures that are actually replaced (used with "false")
livery = {
    {
        -- Name of section in model
        "pilot_F18C_helmet",
        
        -- Texture channel/type
        -- DIFFUSE            0    Diffuse layer pre PBR, Base Color layer for PBR 
        -- NORMAL             1    Normals/depth (ie. rain/scratches on glass, panel lines, rivets)
        -- DECAL              3    Decal layer, a opacity layer for adding decals without changing the base color layer
        -- DIRT               4    Layer used for dirt buildup on an object
        -- DAMAGE             5    Layer used for procedural damage volumetric (small scuffs -> bullet holes -> large holes -> removed surfaces)
        -- PUDDLES            6    Used to place water/puddles on surfaces (puddles on runways etc)
        -- SNOW               7    Used to place snow on surfaces (snow on buildings/bunkers/runways etc)
        -- SELF_ILLUMINATION  8    Used to make a texture self illuminated (diffuse = color, alpha = strength)
        -- DAMAGE             10   Used to place damage diffuse color (appearance of dirt/burn marks around)
        -- ROUGHMET           13   Used for PBR surface properties
        --                         Red   = ambient occlusion level (black = 100%, white = 0%)
        --                         Green = microsurface, roughness/smoothness (black = smooth/shiny, white = rough/dull)
        --                         Blue  = reflectivity, metal/dielectric (black = dielectric, white = metal)
        -- OPACITY            14   Used for surface opacity (mainly for glass material, or textures for meshes) 
        DIFFUSE,
        
        -- texture filename (with or without extension)
        "NameOfTexture",
        
        -- true:  loads texture file from VFS (everything mounted with mount_vfs_texture_path)
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
