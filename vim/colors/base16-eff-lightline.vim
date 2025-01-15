" lightline theme designed to play nice with base16-eff
" no inactive styles since I'm using laststatus=3 for a global window status
" bar

" base16 theme background (gui00)
let s:window_bg = '#212121'

" grays
let s:gray_dark = '#303030'
let s:gray_medium = '#444444'

" tabline colors
let s:tab_fg_inactive = s:gray_medium
let s:tab_bg_inactive = s:window_bg
let s:tab_fg_active = '#F9F8F5'
let s:tab_bg_active = s:tab_fg_inactive
let s:tab_middle_bg = s:window_bg

" statusline colors
let s:fg_primary = '#A59F85'
let s:fg_secondary = '#808080'
let s:bg_outer = '#949494'
let s:bg_inner = s:gray_medium

" Accent Colors
let s:yellow = '#D5C973'
let s:orange = '#B0674B'
let s:red = '#C96067'
let s:magenta = '#875FD7'
let s:green = '#7D9E61'

let s:p = {'normal': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

" tabline palette
let s:p.tabline.left = [ [ s:tab_fg_inactive, s:tab_bg_inactive ] ]
let s:p.tabline.tabsel = [ [ s:tab_fg_active, s:tab_bg_active ] ]
let s:p.tabline.middle = [ [ s:tab_middle_bg, s:tab_middle_bg ] ]
let s:p.tabline.right = copy(s:p.tabline.middle)

" normal mode
let s:p.normal.left = [ [ s:gray_dark, s:green ], [ s:fg_primary, s:bg_inner ] ]
let s:p.normal.middle = [ [ s:fg_secondary, s:gray_dark ] ]
" let s:p.normal.right = [ [ s:gray_dark, s:bg_outer ], [ s:fg_primary, s:bg_inner ] ]
let s:p.normal.right = [ [ s:gray_dark, s:green ], [ s:fg_primary, s:bg_inner ] ]
let s:p.normal.error = [ [ s:red, s:gray_dark ] ]
let s:p.normal.warning = [ [ s:yellow, s:gray_medium ] ]

" insert mode
let s:p.insert.left = [ [ s:gray_dark, s:orange ], [ s:fg_primary, s:bg_inner ] ]
let s:p.insert.right = [ [ s:gray_dark, s:orange ], [ s:fg_primary, s:bg_inner ] ]

" replace mode
let s:p.replace.left = [ [ s:gray_dark, s:red ], [ s:fg_primary, s:bg_inner ] ]
let s:p.replace.right = [ [ s:gray_dark, s:red ], [ s:fg_primary, s:bg_inner ] ]

" visual mode
let s:p.visual.left = [ [ s:gray_dark, s:magenta ], [ s:fg_primary, s:bg_inner ] ]
let s:p.visual.right = [ [ s:gray_dark, s:magenta ], [ s:fg_primary, s:bg_inner ] ]

" Assign to Lightline
let g:lightline#colorscheme#eff#palette = lightline#colorscheme#fill(s:p)
"
