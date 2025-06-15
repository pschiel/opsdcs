#define LUA_COMPAT_5_1

#include <windows.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

static int l_run(lua_State *L) {
    const char *cmd = luaL_checkstring(L, 1);
    const char *args = luaL_optstring(L, 2, NULL);
    ShellExecuteA(NULL, "open", cmd, args, NULL, SW_HIDE);
    return 0;
}

static const struct luaL_Reg les[] = {
    {"run", l_run},
    {NULL, NULL}
};

__declspec(dllexport) int luaopen_les(lua_State *L) {
    luaL_register(L, "les", les);
    return 1;
}
