name = "MFD Example"
Description = "MFD Example"

Viewports = {
    Center = {
        x = 0,
        y = 0,
        width = 1920,
        height = 1080,
        viewDx = 0,
        viewDy = 0,
        aspect = 1920/1080,
    }
}

LEFT_MFCD = {
    x = 1920+384*0,
    y = 0,
    width = 384,
    height = 512,
}

LEFT_MFCD2 = {
    x = 1920+384*1,
    y = 0,
    width = 384,
    height = 512,
}

CENTER_MFCD = {
    x = 1920+384*2,
    y = 0,
    width = 384,
    height = 512,
}

RIGHT_MFCD2 = {
    x = 1920+384*3,
    y = 0,
    width = 384,
    height = 512,
}

RIGHT_MFCD = {
    x = 1920+384*4,
    y = 0,
    width = 384,
    height = 512,
}


LEFT_SFD = {
    x = 1920+384*0,
    y = 512,
    width = 384,
    height = 384,
}

RIGHT_SFD = {
    x = 1920+384*1,
    y = 512,
    width = 384,
    height = 384,
}

LEFT_CDU = {
    x = 1920+384*2,
    y = 512,
    width = 384,
    height = 384,
}

RIGHT_CDU = {
    x = 1920+384*3,
    y = 512,
    width = 384,
    height = 384,
}

APR39 = {
    x = 1920+384*4,
    y = 512,
    width = 384,
    height = 384,
}

GUI = {
    x = 0,
    y = 0,
    width = 1920,
    height = 1080,
}

UIMainView = GUI
GU_MAIN_VIEWPORT = Viewports.Center
