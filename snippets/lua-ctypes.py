import ctypes

lua = ctypes.CDLL(r"E:\\Games\\DCS World\\bin-mt\\lua.dll")

lua.luaL_newstate.restype = ctypes.c_void_p
lua.luaL_openlibs.argtypes = [ctypes.c_void_p]
lua.luaL_loadstring.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
lua.luaL_loadstring.restype = ctypes.c_int
lua.lua_pcall.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_int, ctypes.c_int]
lua.lua_pcall.restype = ctypes.c_int
lua.lua_tolstring.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.POINTER(ctypes.c_size_t)]
lua.lua_tolstring.restype = ctypes.c_char_p

lua_state = lua.luaL_newstate()
lua.luaL_openlibs(lua_state)

def execute_lua_code(lua_code):
    result = lua.luaL_loadstring(lua_state, lua_code.encode('utf-8'))
    if result != 0:
        print(f"Error loading Lua code: {result}")
        return
    result = lua.lua_pcall(lua_state, 0, 0, 0)
    if result != 0:
        print(f"Error running Lua code: {result}")
        return

lua_code = "x = 5"
execute_lua_code(lua_code)

lua_code = "print(x)"
execute_lua_code(lua_code)
