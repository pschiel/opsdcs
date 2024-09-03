---------------------------------------------------------------------------
--- no-swing-messages
---
--- Example tech mod replacing cargo director message sounds
---------------------------------------------------------------------------

local self_ID = "no-swing-messages"

declare_plugin(self_ID, {
    installed = true,
    dirName = current_mod_path,
    displayName = _(self_ID),
    shortName = _(self_ID),
    version = "1.0.0",
    state = "installed",
    developerName = "ops",
    info = _("no swing messages"),
})

plugin_done()
