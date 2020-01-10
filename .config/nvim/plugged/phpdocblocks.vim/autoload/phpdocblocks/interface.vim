" Return a vimscript dictionary of the interface name
" and the names of the parent interfaces
function! phpdocblocks#interface#parse(code)

    " Match a valid interface syntax
    " Capture the interface name and the inherited interfaces
    let l:parts = matchlist(a:code, '\vinterface%(\s|\n)+(\w+)%(\s|\n)*%(extends){0,1}%(\s|\n)*(.{-})\{')

    " Invalid interface syntax
    if l:parts == []
        return ["error", "Invalid PHP interface declaration on this line."]
    endif

    " Remove whitespace from the parent interface name
    let l:parent = substitute(l:parts[2], '\v%(\s|\n)*', "", "g")

    " No parent interface (empty list will omit the entire template line)
    if l:parent == ""
        let l:parent = []
    endif

    " Multiple parent interfaces
    if matchstr(l:parent, ",") != ""
        let l:parent = split(l:parent, ",")
    endif

    return {'name': l:parts[1], 'parent': l:parent}

endfunction
