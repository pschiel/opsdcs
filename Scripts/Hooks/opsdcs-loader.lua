-- for debugging
pcall(function()
    package.cpath = package.cpath .. ';C:/Users/ops/.vscode/extensions/tangzx.emmylua-0.6.18/debugger/emmy/windows/x64/?.dll'
    local dbg = require('emmy_core')
    dbg.tcpConnect('localhost', 9966)
end)

--dofile(lfs.writedir() .. 'Scripts/dcs-fiddle-server.lua')
--dofile(lfs.writedir() .. 'Scripts/dcs-web-editor-gui-server.lua')
dofile(lfs.writedir() .. 'Scripts/opsdcs-api/api.lua')
