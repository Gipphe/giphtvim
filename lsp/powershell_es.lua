local settings = {
  enabled = nixInfo(false, 'settings', 'cats', 'powershell'),
}
if nixInfo.isNix then
  settings.bundle_path = nixInfo('', 'info', 'powershell_es') .. '/lib/powershell-editor-services'
end
return settings
