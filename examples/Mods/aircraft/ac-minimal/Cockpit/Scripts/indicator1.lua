-- package.cpath = package.cpath .. ';C:/Users/ops/.vscode/extensions/tangzx.emmylua-0.8.18-win32-x64/debugger/emmy/windows/x64/?.dll'
-- local dbg = require('emmy_core')
-- dbg.tcpConnect('localhost', 9966)
-- local x = 5

dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
indicator_type = indicator_types.COMMON
purposes = { render_purpose.SCREENSPACE_INSIDE_COCKPIT, render_purpose.HUD_ONLY_VIEW }
screenspace_scale = 4;
init_pageID = 0

page_subsets = {
    [0] = LockOn_Options.script_path .. "indicator1page.lua",
}

pages = {
    [0] = { 0 }
}

need_to_be_closed = true -- close lua state after initialization 
