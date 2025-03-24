# DCS LUA coding setup


## Prepare VSCode

1. Install [VSCode](https://code.visualstudio.com/download)

2. Install [tangzx.emmylua](https://marketplace.visualstudio.com/items?itemName=tangzx.emmylua) extension (debugging and stubs)

3. Install [omltcat.dcs-lua-runner](https://marketplace.visualstudio.com/items?itemName=omltcat.dcs-lua-runner) extension (inject code at runtime)

4. Install [dcs-fiddle-server.lua](https://github.com/omltcat/dcs-snippets/blob/master/Scripts/Hooks/dcs-fiddle-server.lua) into `Saved Games/DCS/Scripts/Hooks` folder (required for lua runner)

5. Create a [launch.json](launch.json) debug config (emmylua debugger setup)


## Injecting code at runtime

For mission and gui environments, just send the code (snippet) to the DCS LUA Runner extension (^k ^s to setup hotkey).


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


## Get a shell

Install https://www.msys2.org/

Add to VSCode terminals:
```json
"terminal.integrated.profiles.windows": {
    "MINGW64": {
        "path": "C:\\Dev\\msys64\\usr\\bin\\bash.exe",
        "args": ["--login", "-i"],
        "env": {
            "MSYSTEM": "MINGW64",
            "CHERE_INVOKING": "1"
        }
    }
}
```

Add to Windows Terminal:
```json
{
    "guid": "{a0a1a2a3-a4a5-a6a7-a8a9-aaabacadaeaf}",
    "name": "MSYS2 MinGW64",
    "commandline": "C:\\Dev\\msys64\\usr\\bin\\bash.exe -l -c \"/mingw64.sh\"",
    "startingDirectory": "%USERPROFILE%",
    "icon": "C:\\Dev\\msys64\\msys2.exe"
}
```

Start script ming64.sh (in `C:/Dev/msys64`)
```bash
#!/usr/bin/env bash
export MSYSTEM=MINGW64
export CHERE_INVOKING=1
exec /usr/bin/bash -l
```

Useful commands:

- Find files with "pilot" and "edm" in name

  ```bash
  find /e/Games/DCS\ World -iname "*pilot*edm"
  ```

- Log file realtime viewing with filter

  ```bash
  tail -f /c/Users/user/Saved\ Games/DCS/Logs/dcs.log | grep -i a4e
  ```

- Update mingw64

  ```bash
  pacman -Syu
  ```

- Some packages

  ```bash
  pacman -S neovim
  pacman -S tmux
  pacman -S git
  pacman -S python
  pacman -S python-pip
  ```
