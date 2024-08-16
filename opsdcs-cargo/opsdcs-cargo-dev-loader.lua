-- Development hook loader for opsdcs-cargo-hook
-- make sure basedir has a trailing slash

_G.OpsdcsCargoBasedir = "E:/Work/dcs/opsdcs/opsdcs-cargo/Scripts/opsdcs-cargo/"
dofile(OpsdcsCargoBasedir .. "../Hooks/opsdcs-cargo-hook.lua")
