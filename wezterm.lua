local Config = require('config')

require('utils.backdrops')
   -- :set_focus('#000000')
   -- :set_images_dir(require('wezterm').home_dir .. '/Pictures/Wallpapers/')
   :set_images()
   :random()

require('events.left-status').setup()
require('events.right-status').setup({ date_format = '%a %H:%M:%S' })
require('events.tab-title').setup({ hide_active_tab_unseen = false, unseen_icon = 'circle' })
require('events.new-tab-button').setup()

return Config:init()
   :append('appearance')
   :append('bindings')
   :append('domains')
   :append('fonts')
   :append('general')
   :append('launch')
   :finish()
