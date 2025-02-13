return {
   default_prog = { 'zsh', '-l' },
   launch_menu = {
      { label = 'Bash', args = { 'bash', '-l' } },
      { label = 'Fish', args = { 'fish', '-l' } },
      { label = 'Zsh', args = { 'zsh', '-l' } },
   },
   ['platform:windows'] = {
      default_prog = { 'pwsh', '-NoLogo' },
      launch_menu = {
         { label = 'PowerShell Core', args = { 'pwsh', '-NoLogo' } },
         { label = 'PowerShell Desktop', args = { 'powershell' } },
         { label = 'Command Prompt', args = { 'cmd' } },
         { label = 'Nushell', args = { 'nu' } },
         { label = 'Msys2', args = { 'ucrt64.cmd' } },
         {
            label = 'Git Bash',
            args = { 'C:\\Users\\kevin\\scoop\\apps\\git\\current\\bin\\bash.exe' },
         },
      },
   },
}
