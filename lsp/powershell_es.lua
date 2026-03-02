local catUtils = require 'nixCatsUtils'
local settings = {
  enabled = nixCats 'powershell',
}
if catUtils.isNixCats then
  settings.bundle_path = catUtils.getCatOrDefault('powershell_es', '') .. '/lib/powershell-editor-services'
end
return settings
