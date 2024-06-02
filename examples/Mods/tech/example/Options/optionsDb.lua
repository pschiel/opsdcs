local DbOption = require('Options.DbOption')

return {
	examplePluginCheckboxOption = DbOption.new():setValue(false):checkbox(),
	examplePluginEditboxOption = DbOption.new():setValue('somevalue'):editbox(),
	examplePluginSliderOption = DbOption.new():setValue(50):slider(DbOption.Range(1,100)),
}
