" Return a vimscript dictionary of the class name,
" the parent class name and the interfaces it implements
function! phpdocblocks#class#parse(code)

    " Match a valid class syntax
    " Capture the class name, the inherited class name and the interfaces it implements
    let l:classNameRegex = 'class%(\s|\n)+(\w+)%(\s|\n)*'
    let l:extendsRegex = '%(%(extends)%(\s|\n)*(\w*)%(\s|\n)*){0,1}'
    let l:implementsRegex = '%(%(implements)%(\s|\n)*(.{-})%(\s|\n)*){0,1}'
    let l:parts = matchlist(a:code, '\v' . l:classNameRegex . l:extendsRegex . l:implementsRegex . '\{')

    " Invalid class syntax
    if l:parts == []
        return ["error", "Invalid PHP class declaration on this line."]
    endif

    " Remove whitespace from the parent class name
    let l:parent = substitute(l:parts[2], '\v%(\s|\n)*', "", "g")

    " No parent class (empty list will omit the entire template line)
    if l:parent == ""
        let l:parent = []
    endif

    " Remove whitespace from the interface name(s)
    let l:interface = substitute(l:parts[3], '\v%(\s|\n)*', "", "g")

    " No interfaces (empty list will omit the entire template line)
    if l:interface == ""
        let l:interface = []
    endif

    " Multiple interfaces
    if matchstr(l:interface, ",") != ""
        let l:interface = split(l:interface, ",")
    endif

    return {'name': l:parts[1], 'parent': l:parent, 'interface': l:interface}

endfunction
