-- run snippet in gui env

package.cpath = package.cpath .. ";E:\\Work\\dcs\\opsdcs\\lua-python-bridge\\build\\?.dll"
lpb = require("lpb")

-- call init() only once
lpb.init()

-- a_out_picture caches images, so we need a new filename everytime
idx = idx and idx + 1 or 1

local x = {1, 2, 3, 4, 5, 6, 7, 8}
local y = {5, 5, 6, 3, 3, 5, 6, 1}

lpb.run([[
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import linregress
x = np.array([]] .. table.concat(x, ",") .. [[])
y = np.array([]] .. table.concat(y, ",") .. [[])
slope, intercept, _, _, _ = linregress(x, y)
y_fit = slope * x + intercept
plt.clf()
plt.plot(x, y, 'bo-', label="Data")
plt.plot(x, y_fit, 'r-', label="Linear Fit")
plt.title("blabla")
plt.legend()
plt.savefig("E:\\plot_]] .. idx .. [[.png")
]])
net.dostring_in("mission", 'a_out_picture("E:/plot_' .. idx .. '", 20, false, 0, "0", "0", 100, "0")')
