-- run snippet in gui env

package.cpath = package.cpath .. ";E:\\Work\\dcs\\opsdcs\\lua-python-bridge\\build\\?.dll"
lpb = require("lpb")

-- call init() only once
lpb.init()

-- a_out_picture caches images, so we need a new filename everytime
idx = idx and idx + 1 or 1

local x = {1, 2, 3, 4, 5, 6, 7, 8}
local y = {1, 5, 6, 3, 3, 5, 6, 10}

-- set return value in "ret"
local code = [[
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import linregress
x = np.array(args[0])
y = np.array(args[1])
idx = int(args[2])
slope, intercept, _, _, _ = linregress(x, y)
y_fit = slope * x + intercept
plt.clf()
plt.plot(x, y, 'bo-', label="Data")
plt.plot(x, y_fit, 'r-', label="Linear Fit")
plt.title("blabla")
plt.legend()
file_path = f"E:/plot_{idx}.png"
plt.savefig(file_path)
ret = file_path
]]
local ret = lpb.run(code, { x, y, idx })

net.dostring_in("mission", [[a_out_text_delay("]] .. ret ..  [[", 10, 0, 0)]])
net.dostring_in("mission", [[a_out_picture("]] .. ret .. [[", 20, false, 0, "0", "0", 100, "0")]])
