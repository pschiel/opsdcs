# DCS LUA coding setup


## Prepare VSCode

1. Install [VSCode](https://code.visualstudio.com/download)

2. Install [tangzx.emmylua](https://marketplace.visualstudio.com/items?itemName=tangzx.emmylua) extension (debugging and stubs)

3. Install [omltcat.dcs-lua-runner](https://marketplace.visualstudio.com/items?itemName=omltcat.dcs-lua-runner) extension (inject code at runtime)

4. Install [dcs-fiddle-server.lua](https://github.com/omltcat/dcs-snippets/blob/master/Scripts/Hooks/dcs-fiddle-server.lua) into `Saved Games/DCS/Scripts/Hooks` folder (required for lua runner)

5. Create a [launch.json](launch.json) debug config (emmylua debugger setup)


## Injecting code at runtime

For the Mission Scripting environment, just send the code (snippet) to the DCS LUA Runner extension (^k ^s to setup hotkey).


## Enable debugging

1. Run following code snippet in the env you want to debug (by either injecting, or insert in any script)

    ```lua
    package.cpath = package.cpath .. ';C:/Users/USERNAME/.vscode/extensions/tangzx.emmylua-0.8.18-win32-x64/debugger/emmy/windows/x64/?.dll'
    local dbg = require('emmy_core')
    dbg.tcpConnect('localhost', 9966) end)
    ```

2. Desanitize `DCS World/Scripts/MissionScripting.lua` to enable mission scripting debugging and fiddle server (for DCS LUA Runner)

    ```lua
    sanitizeModule('os')
	sanitizeModule('io')
	sanitizeModule('lfs')
	-- _G['require'] = nil
	_G['loadlib'] = nil
	-- _G['package'] = nil
    ```

3. Start the VSCode debug config

4. Start DCS


## Auto-completion via LUA stubs

Create `.emmyrc.json` in root directory of your project, and set path to stubs in workspace library, see [.emmyrc.json](../.emmyrc.json)


## Notes on debugging

1. Hooks are loaded only once on game/server start, so you need a restart on change, when debugging hooks

2. While working in the ME, scripts are in a temporary folder, so the debugger can't match the file path

3. You can workaround in both cases by using `dofile('/path/to/script.lua')` (either within a hook callback, or within a "DO SCRIPT" action) to force correct path

4. To debug other scripts besides mission script, put the debug snippet in the any file (Export.lua, entry.lua, ...) where package/require is available
