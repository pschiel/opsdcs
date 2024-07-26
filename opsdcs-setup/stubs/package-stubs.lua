---------------------------------------------------------------------------
--- Various packages
---------------------------------------------------------------------------

------------------------------------------------------------------------------
--- lfs
------------------------------------------------------------------------------

--- @class lfs
--- @field add_location fun()
--- @field attributes fun(path:string, attribute:string):table @returns a table of file attributes (mode = file/directory, modification, size)
--- @field chdir fun(path:string) @changes the current directory.
--- @field create_lockfile fun()
--- @field currentdir fun():string @returns install directory.
--- @field del_location fun()
--- @field dir fun(path:string):table @returns a table of files and directories in the specified path.
--- @field locations fun():table @returns drives.
--- @field md5sum fun(path:string):string @returns the MD5 hash of a file.
--- @field mkdir fun(path:string) @creates a directory.
--- @field normpath fun(path:string):string @returns the normalized path.
--- @field realpath fun(path:string):string @returns the absolute path of a file.
--- @field rmdir fun(path:string) @removes a directory.
--- @field tempdir fun():string @returns the temporary directory.
--- @field writedir fun():string @returns the path to the saved games directory.

------------------------------------------------------------------------------
--- log
------------------------------------------------------------------------------

--- @class log
--- @field alert fun(message:string) @Logs an alert message.
--- @field debug fun(message:string) @Logs a debug message.
--- @field error fun(message:string) @Logs an error message.
--- @field info fun(message:string) @Logs an info message.
--- @field set_output fun()
--- @field set_output_rules fun()
--- @field warning fun(message:string) @Logs a warning message.
--- @field write fun()

------------------------------------------------------------------------------
--- dictionary
------------------------------------------------------------------------------

--- @class dictionary
--- @field addKeyToDict fun()
--- @field addNewLang fun()
--- @field clearDict fun()
--- @field clearResourceExceptDEFAULT fun()
--- @field copyFileInMission fun()
--- @field CopyKeysToNewDict fun()
--- @field deleteLang fun()
--- @field exchangeValue fun()
--- @field extractFirstDir fun()
--- @field extractSecondDir fun()
--- @field findDir fun()
--- @field fixDict fun()
--- @field fixValueToResource fun()
--- @field getBriefingData fun()
--- @field getCampaignData fun()
--- @field getCopyDictionary fun()
--- @field getCurDictionary fun()
--- @field getDictionary fun()
--- @field getFullPath fun()
--- @field getLangs fun()
--- @field getMapResource fun()
--- @field getMaxDictId fun()
--- @field getMissionDescription fun()
--- @field getNewDictId fun()
--- @field getNewResourceId fun()
--- @field getResourceCounter fun()
--- @field getValueDict fun()
--- @field getValueDictDEFAULT fun()
--- @field getValueResource fun()
--- @field getValueResourceDEFAULT fun()
--- @field intertFileIntoMission fun()
--- @field isLang fun()
--- @field isSignedMission fun()
--- @field loadDict fun()
--- @field loadDictionary fun()
--- @field packMissionResources fun()
--- @field removeFileFromMission fun()
--- @field removeKey fun()
--- @field removeResource fun()
--- @field removeResourceOnlyDict fun()
--- @field resetDictionary fun()
--- @field resourceExists fun()
--- @field setCurDictionary fun()
--- @field setMaxDictId fun()
--- @field setValueToDict fun()
--- @field setValueToDictEx fun()
--- @field setValueToResource fun()
--- @field showWarningMessageBox fun()
--- @field textToME fun()
--- @field textToMis fun()
--- @field unpackFiles fun()