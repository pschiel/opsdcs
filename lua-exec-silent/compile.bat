set VCVARS="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
set LUA_INC="C:\Dev\lua\lua5.1\include"
set LUA_LIB="C:\Dev\lua\lua5.1"

call %VCVARS%

mkdir build 2>nul

lib /def:lua.def /out:build/lua.lib /machine:x64

cl /LD /I%LUA_INC% les.c ^
  /Fo"build/" /Fe"build/les.dll" /Fd"build/" ^
  /link /LIBPATH:build build/lua.lib /OUT:"build/les.dll" /MACHINE:X64 ^
  /NODEFAULTLIB:LIBCMT /DEFAULTLIB:legacy_stdio_definitions.lib /DEFAULTLIB:msvcrt.lib /DEFAULTLIB:Shell32.lib
