-- Development hook loader for opsdcs-crew-hook (to run from different directory)
-- make sure basedir has a trailing slash

_G.OpsdcsCrewBasedir = "E:/Work/dcs/opsdcs/opsdcs-crew/Scripts/opsdcs-crew/"
dofile(OpsdcsCrewBasedir .. "../Hooks/opsdcs-crew-hook.lua")
