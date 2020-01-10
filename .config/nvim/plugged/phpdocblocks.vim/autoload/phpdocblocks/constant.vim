" Return a vim dictionary of PHP constant(s)
function! phpdocblocks#constant#parse(code)
    let l:constantParts = ''
    " Match a valid constant declaration
    " Single constant - const
    if matchstr(a:code, '\v\cconst\s*\w{-}\s*[^,]*[;]') != ""
        let l:constantParts = matchlist(a:code, '\v\cconst\s*(\w{-})\s*[=]\s*(.{-})[;]')
        return {'constant': s:singleConstant(l:constantParts)}
    " Single constant - define()
    elseif matchstr(a:code, '\v\cdefine\s*\(\s*%(''|"){1}\w{-}%(''|"){1}\s*[,]\s*.{-}\s*\)[;]') != ""
        let l:constantParts = matchlist(a:code, '\v\cdefine\s*\(\s*%(''|"){1}(\w{-})%(''|"){1}\s*[,]\s*(.{-})\s*\)[;]')
        return {'constant': s:singleConstant(l:constantParts)}
    " Multiple constants - const
    elseif matchstr(a:code, '\v\cconst\s*\w{-}\s*.{-}[,].{-}[;]') != ""
        let l:constantParts = matchlist(a:code, '\v\cconst\s*(.{-})[;]')
        return {'constant': s:multipleConstants(l:constantParts)}
    endif
    return ["error", "Invalid PHP constant declaration"]
endfunction


" Return a single constant name and its PHP type
function! s:singleConstant(constantPart)
    " Get PHP type from the constants value
    let l:constantType = phpdocblocks#getPhpType(a:constantPart[2])
    if l:constantType != ""
        let l:constant = l:constantType." ".a:constantPart[1]
    else
        let l:constant = a:constantPart[1]
    endif
    return l:constant
endfunction


" Return a list of constant names and their PHP types
function! s:multipleConstants(constantPart)
    let l:constantDeclarations = split(substitute(a:constantPart[1], '\v\s*', "", "g"), '\v,')
    if len(l:constantDeclarations) <= 1
        return 0
    endif
    let l:constants = []
    for l:constant in l:constantDeclarations
        let l:constant = split(l:constant, '\v\=')
        " Get PHP type from the constants value
        let l:constantType = phpdocblocks#getPhpType(l:constant[1])
        if l:constantType != ""
            let l:constants += [l:constantType." ".l:constant[0]]
        else
            let l:constants += [l:constant[0]]
        endif
    endfor
    return l:constants
endfunction
