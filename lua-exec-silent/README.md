# lua-exec-silent

Executes a shell command, in background, and without cmd window popping up.

## example (tts output)

Install python and edge-tts: `pip install edge-tts`

LUA code for DCS:
```lua
package.cpath = package.cpath .. ";E:\\Work\\dcs\\opsdcs\\lua-exec-silent\\build\\?.dll"
les = require("les")
les.run("edge-playback", '--text "Hello pilot! DCS version is ' .. __DCS_VERSION__ .. '"')
```

## compile

- [LUA 5.1 dynamic libs](https://sourceforge.net/projects/luabinaries/files/5.1.4/Windows%20Libraries/lua-5.1.4_Win32_dll12_lib.zip)
- MSVC 2022, Desktop development with C++
  - MSVC v143 - VS 2022 C++ x64/x86 build tools
  - Windows 11 SDK
- edit and use `compile.bat`

## lua.def

made from: dumpbin /exports "DCS World\bin\lua.dll" > lua.exports.txt
