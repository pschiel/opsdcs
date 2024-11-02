_  = function(p) return p; end;
name = 'Triple Screen Bezel 6040x1080';
Description = 'Triple Screen Bezel 6040x1080';

Viewports = {
     Center = {
          x = 1920+140,
          y = 0,
          width = 1920,
          height = 1080,
          aspect = 1920/1080,
		useAbsoluteFOV = false,
		useAbsoluteAnglesShift = true,
          viewDx = 0,
          viewDy = 0,
     },
     Left = {
          x = 0,
          y = 0,
          width = 1920,
          height = 1080,
          aspect = 1920/1080,
		useAbsoluteFOV = false,
		useAbsoluteAnglesShift = true,
          viewDx = 1.13,
          viewDy = 0,
     },
     Right = {
          x = 1920+140+1920+140,
          y = 0,
          width = 1920,
          height = 1080,
          aspect = 1920/1080,
		useAbsoluteFOV = false,
		useAbsoluteAnglesShift = true,
          viewDx = -1.13,
          viewDy = 0,
     }
}

GUI = {
	x = 1920+140,
	y = 0,
	width = 1920,
	height = 1080,
}

UIMainView = GUI
GU_MAIN_VIEWPORT = Viewports.Center
