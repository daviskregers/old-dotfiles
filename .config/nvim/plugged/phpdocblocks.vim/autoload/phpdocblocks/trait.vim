" Return a vimscript dictionary of the trait name
function! phpdocblocks#trait#parse(code)

    " Match a valid trait syntax
    " Capture the trait name
    let l:parts = matchlist(a:code, '\vtrait%(\s|\n)+(\w+)%(\s|\n)*\{')

    " Invalid syntax
    if l:parts == []
        return ["error", "Invalid PHP trait declaration on this line."]
    endif

    return {'name': l:parts[1]}

endfunction
