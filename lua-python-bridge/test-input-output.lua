package.cpath = package.cpath .. ";E:\\Work\\dcs\\opsdcs\\lua-python-bridge\\build\\?.dll"
lpb = require("lpb")

function dbg(x, lv)
    lv = lv or 0
    local indent = string.rep("  ", lv)
    if type(x) == "table" then
        -- recursive
        for k, v in pairs(x) do
            if type(v) == "table" then
                print(indent .. k .. ":")
                dbg(v, lv + 1)
            else
                print(indent .. k .. ": " .. tostring(v))
            end
        end
    else
        print(indent .. tostring(x))
    end
end

-- call init() only once
lpb.init()

-- test return from python to lua
print("TEST1")
dbg(lpb.run("ret=42"))

print("TEST2")
dbg(lpb.run("ret='hello'"))

print("TEST3")
dbg(lpb.run("ret=[1, 2, 3, 4]"))

print("TEST4")
dbg(lpb.run("ret={'a': 1, 'b': 2, 'c': 3}"))

print("TEST5")
dbg(lpb.run("ret={'numbers': [1, 2, 3], 'info': {'name': 'test', 'value': 42}}"))

print("TEST6")
dbg(lpb.run("ret=[[1, 2], [3, 4], {'x': 5, 'y': 6}]"))

-- test passing args to python

print("TEST7")
dbg(lpb.run("ret=args", 4))

print("TEST8")
dbg(lpb.run("ret=args", "hello"))

print("TEST9")
dbg(lpb.run("ret=args", { 1, 2, 3 }))

print("TEST10")
dbg(lpb.run("ret=args", { x = 2, y = 3 }))

print("TEST11")
dbg(lpb.run("ret=args", { x = 2, y = 3, z = { 4, 5, 6, { hen = "lo" } } }))

print("TEST12")
dbg(lpb.run("ret=args['z'][3]['hen']", { x = 2, y = 3, z = { 4, 5, 6, { hen = "lo" } } }))

print("TEST13")
dbg(lpb.run("ret=args[0]", { { 1, 2, 3 }, { 4, 5, 6 } }))

print("TEST14")
dbg(lpb.run([[
x=3
ret='hello'
y=5
]]))
