local global = vim.o

-- Theme
vim.g.nb_style = "night"
require('colorbuddy').colorscheme('nightbuddy')

local Color, colors, Group, groups, styles = require('colorbuddy').setup()

-- Use Color.new(<name>, <#rrggbb>) to create new colors
-- They can be accessed through colors.<name>
Color.new('background',  '#282c34')
Color.new('red',         '#cc6666')
Color.new('green',       '#99cc99')
Color.new('yellow',      '#f0c674')
Color.new('white',       '#ffffff')
Color.new('black',       '#000000')
Color.new('teal',        '#008080')
Color.new('grey',        '#808080')
Color.new('grey27',      '#444444')
Color.new('darkgrey',    '#3a3a3a')
Color.new('silver',      '#c0c0c0')

-- Define highlights in terms of `colors` and `groups`
Group.new('Function'        , colors.yellow      , colors.background , styles.bold)
Group.new('luaFunctionCall' , groups.Function    , groups.Function   , groups.Function)

-- Define highlights in relative terms of other colors
Group.new('Error', colors.red, nil, styles.bold)
Group.new('Comment', colors.red, nil, styles.bold)
Group.new('ColorColumn', colors.white, colors.red, styles.bold)

Group.new('PrimaryBlock', colors.white, colors.teal, styles.bold)
Group.new('SecondaryBlock', colors.white, colors.grey, styles.bold)
Group.new('Blanks', colors.white, colors.silver, styles.bold)
Group.new('StatusLine', colors.black, colors.white, styles.bold)

-- red comments and errors
-- vim.cmd("hi Comment ctermfg=darkred")
-- vim.cmd("hi SyntasticError ctermfg=144 ctermbg=9")
-- vim.cmd("hi SyntasticStyleError ctermfg=144 ctermbg=9")
-- vim.cmd("hi SyntasticStyleWarning ctermfg=144 ctermbg=9")
-- vim.cmd("hi SyntasticWarning ctermfg=144 ctermbg=9")

-- transparent background
vim.cmd("hi! NonText ctermbg=NONE guibg=NONE")
vim.cmd("hi! Normal ctermbg=NONE guibg=NONE")

-- indent line
Group.new('IndentBlanklineChar', colors.darkgrey, colors.black)

-- blame line
Group.new('BlameLine', colors.grey27)
