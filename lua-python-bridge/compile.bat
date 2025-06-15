set VCVARS="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
set LUA_INC="C:\dev\lua\lua5.1\include"
set LUA_LIB="C:\dev\lua\lua5.1"
set PYTHON_INC="C:\dev\Python311\include"
set PYTHON_LIB="C:\dev\Python311\libs"

call %VCVARS%

mkdir build 2>nul

cl /LD /I%LUA_INC% /I%PYTHON_INC% lpb.c ^
    /Fo"build/" /Fe"build/" /Fd"build/" ^
    /link /LIBPATH:%LUA_LIB% /LIBPATH:%PYTHON_LIB% ^
    lua5.1.lib python311.lib /OUT:"build/lpb.dll" /MACHINE:X64 ^
    /NODEFAULTLIB:LIBCMT /DEFAULTLIB:legacy_stdio_definitions.lib /DEFAULTLIB:msvcrt.lib
