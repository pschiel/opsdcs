#define LUA_COMPAT_5_1
#define _CRT_SECURE_NO_WARNINGS

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <Python.h>
#include <stdio.h>

#ifdef _WIN32
    #define LUA_API __declspec(dllexport)
#else
    #define LUA_API
#endif

static int l_init(lua_State *L) {
    Py_Initialize();
    return 0;
}

static int l_close(lua_State *L) {
    Py_FinalizeEx();
    return 0;
}

static void py_to_lua(lua_State *L, PyObject *value) {
    if (PyUnicode_Check(value)) {
        lua_pushstring(L, PyUnicode_AsUTF8(value));
    } else if (PyLong_Check(value)) {
        lua_pushinteger(L, PyLong_AsLong(value));
    } else if (PyFloat_Check(value)) {
        lua_pushnumber(L, PyFloat_AsDouble(value));
    } else if (PyList_Check(value)) {
        lua_newtable(L);
        Py_ssize_t size = PyList_Size(value);
        for (Py_ssize_t i = 0; i < size; i++) {
            PyObject *item = PyList_GetItem(value, i);
            py_to_lua(L, item);
            lua_rawseti(L, -2, i + 1);
        }
    } else if (PyDict_Check(value)) {
        lua_newtable(L);
        PyObject *key, *val;
        Py_ssize_t pos = 0;
        while (PyDict_Next(value, &pos, &key, &val)) {
            lua_pushstring(L, PyUnicode_AsUTF8(key));
            py_to_lua(L, val);
            lua_settable(L, -3);
        }
    } else {
        lua_pushnil(L);
    }
}

static PyObject* lua_to_py(lua_State *L, int index) {
    if (lua_isnumber(L, index)) {
        return PyFloat_FromDouble(lua_tonumber(L, index));
    } else if (lua_isstring(L, index)) {
        return PyUnicode_FromString(lua_tostring(L, index));
    } else if (lua_istable(L, index)) {
        PyObject *py_dict = PyDict_New();
        PyObject *py_list = PyList_New(0);
        int is_list = 1;
        lua_pushnil(L);
        while (lua_next(L, index) != 0) {
            if (lua_isnumber(L, -2)) {
                // numeric key
            } else if (lua_isstring(L, -2)) {
                is_list = 0;
            } else {
                lua_pop(L, 1);
                continue;
            }
            PyObject *key = lua_isnumber(L, -2) ?
                PyLong_FromLong(lua_tointeger(L, -2)) : PyUnicode_FromString(lua_tostring(L, -2));
            PyObject *value = lua_to_py(L, lua_gettop(L));
            if (is_list && PyLong_Check(key)) {
                Py_ssize_t idx = PyLong_AsSsize_t(key) - 1;
                if (idx >= PyList_Size(py_list)) {
                    PyList_Append(py_list, value);
                } else {
                    PyList_SetItem(py_list, idx, value);
                }
            } else {
                PyDict_SetItem(py_dict, key, value);
            }
            Py_DECREF(key);
            Py_DECREF(value);
            lua_pop(L, 1);
        }
        return is_list ? py_list : py_dict;
    }
    Py_RETURN_NONE;
}

static int l_run(lua_State *L) {
    const char *code = luaL_checkstring(L, 1);
    PyObject *py_args = NULL;
    if (lua_gettop(L) >= 2) {
        if (lua_istable(L, 2)) {
            py_args = lua_to_py(L, 2);
        } else {
            py_args = lua_to_py(L, 2);
        }
    } else {
        Py_INCREF(Py_None);
        py_args = Py_None;
    }
    PyObject *main_dict = PyModule_GetDict(PyImport_AddModule("__main__"));
    PyDict_SetItemString(main_dict, "args", py_args);
    Py_DECREF(py_args);
    PyObject *result = PyRun_String(code, Py_file_input, main_dict, main_dict);
    if (result) {
        PyObject *ret_value = PyDict_GetItemString(main_dict, "ret");
        if (ret_value) {
            py_to_lua(L, ret_value);
            return 1;
        }
    }
    lua_pushnil(L);
    return 1;
}

static const struct luaL_Reg lpb[] = {
    {"init", l_init},
    {"close", l_close},
    {"run", l_run},
    {NULL, NULL}
};

LUA_API int luaopen_lpb(lua_State *L) {
    lua_newtable(L);
    luaL_register(L, NULL, lpb);
    return 1;
}
