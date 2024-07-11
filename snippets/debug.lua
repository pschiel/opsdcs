package.cpath = package.cpath .. ';C:/Users/ops/.vscode/extensions/tangzx.emmylua-0.6.18/debugger/emmy/windows/x64/?.dll'
local dbg = require('emmy_core')
dbg.tcpConnect('localhost', 9966)

dofile('E:/Work/dcs/opsdcs/snippets/inspect-globals.lua')
