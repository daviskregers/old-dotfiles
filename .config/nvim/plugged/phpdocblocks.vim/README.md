# PHPDocBlocks.vim

This Vim plug-in lets you generate PHP doc blocks quickly. It will fill in literal and hinted types as well as names automatically. You can also edit templates for each doc block type to fit your needs.


## Installation

Add it using your favorite Vim plug-in manager.

**[Vundle:](https://github.com/VundleVim/Vundle.vim)** Add the following code between `call vundle#begin()` and `call vundle#end()` in your `.vimrc`. Then run `:PluginInstall` and restart Vim.
	
    Plugin 'brett-griffin/phpdocblocks.vim'


## Usage

Run the `:PHPDocBlocks` command while your cursor is on the line that you want documented.  
You can map the command in your `.vimrc` as shown below:

    nnoremap <leader>pd :PHPDocBlocks<cr>
    
    
## Templates

This plug-in uses a simple template system.

* Templates are stored in the `PHPDocBlocks.vim/templates` directory.
* Blank lines and lines starting with a `#` symbol will be ignored.
  
##### Template Variables
* Variables are inserted using the syntax: `{{variable}}`
* You may only use one `{{variable}}` per line.
* `{{newline}}` will insert a blank line.


## Global Variables

Set these variables in your `.vimrc`

**let g:phpdocblocks_return_void = 0 or 1 (Default: 1)**  
Will add `@return void` to the doc block if the function has no return statement defined.
###

**let g:phpdocblocks_abbreviate_types = 0 or 1 (Default: 1)**  
This will toggle between using int/integer and bool/boolean in your doc blocks.
###

**let g:phpdocblocks_move_cursor = 0 or 1 (Default: 0)**  
Will automatically move the cursor to the end of the closest line that begins with `@` and change to insert mode.  
###

**let g:phpdocblocks_templates_directory = PATH (Default: Automatically set)**  
This is automatically set in `PHPDocBlocks.vim/plugin/phpdocblocks.vim` but if it is not working for you or if you want to set a custom directory, set it manually using this command.
