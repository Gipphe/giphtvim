local settings = {
  enabled = nixCats 'powershell',
}
if require('nixCatsUtils').isNixCats then
  settings.bundle_path = require('nixCatsUtils').getCatOrDefault('powershell_es', '') .. '/lib/powershell-editor-services'
end
return settings
