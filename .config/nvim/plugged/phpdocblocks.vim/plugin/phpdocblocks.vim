" :PHPDocBlocks command
command! -nargs=0 PHPDocBlocks :call phpdocblocks#insert()

" Automatically get templates directory
let s:removeFilename = substitute(resolve(expand('<sfile>:p')), 'phpdocblocks.vim$', "", "")
let g:phpdocblocks_templates_directory = substitute(s:removeFilename, "plugin", "templates", "g")
