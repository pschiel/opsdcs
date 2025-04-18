-- debug snippet

pcall(function()
    package.cpath = package.cpath .. ';C:/Users/ops/.vscode/extensions/tangzx.emmylua-0.8.20-win32-x64/debugger/emmy/windows/x64/?.dll'
    local dbg = require('emmy_core')
    dbg.tcpConnect('localhost', 9966)
end)

dofile([[E:\Work\dcs\opsdcs\scratch\todebug.lua]])
