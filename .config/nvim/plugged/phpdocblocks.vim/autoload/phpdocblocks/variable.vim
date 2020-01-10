" Return a vim dictionary of php variables
function! phpdocblocks#variable#parse(codeBlock)

    let l:variablePartsRegex = ''

    " Match a valid variable declaration
    if matchstr(a:codeBlock, '\v\${1}\w+\s*[=]\s*.{-}[;]') != ""
        let l:variablePartsRegex = '\v\s*(\w{-})\s*\$([^=|^ ]+|^\s+)\s*[=]\s*(.{-})[;]'
    elseif matchstr(a:codeBlock,'\v\${1}\w+\s*.{-}[;]') != ""
        let l:variablePartsRegex = '\v\s*(\w{-})\s*\$([^=|^,|^ ]+|^\s+)*\s*(.{-})[;]'
    endif

    if l:variablePartsRegex != ''
        let l:variablePart = matchlist(a:codeBlock, l:variablePartsRegex)
        let l:multipleVariables = s:multipleVariables(l:variablePart)
        if type(l:multipleVariables) == v:t_list
            return {'variable': l:multipleVariables}
        endif
        return {'variable': s:singleVariable(l:variablePart)}
    endif

    return ["error", "Invalid PHP variable declaration"]

endfunction


" Return a single variable
function! s:singleVariable(variablePart)
    " Use declared type if available
    if a:variablePart[1] != "" && matchstr(a:variablePart[1], '\v\cstatic|public|protected|private') == ""
        let l:variable = phpdocblocks#setTypeAbbreviation(a:variablePart[1])." $".a:variablePart[2]
    else
        " Get variable type from value
        let l:variableType = phpdocblocks#getPhpType(a:variablePart[3])
        if l:variableType != ""
            let l:variable = l:variableType." $".a:variablePart[2]
        else
            let l:variable = "$".a:variablePart[2]
        endif
    endif
    return l:variable
endfunction


" Return a list of variables
function! s:multipleVariables(variablePart)
    let l:multipleVariables = split(substitute(a:variablePart[3], '\v\s*', "", "g"), '\v(,|\=)')
    if len(l:multipleVariables) > 1
        let l:multipleVariables = ["$".a:variablePart[2]] + l:multipleVariables
        let l:i = 0
        let l:variables = []
        " Get variable type from value
        let l:multipleVariableType = phpdocblocks#getPhpType(l:multipleVariables[len(l:multipleVariables)-1])
        if l:multipleVariableType != ""
            call remove(l:multipleVariables, len(l:multipleVariables)-1)
        endif
        " Use declared type if available
        if a:variablePart[1] != "" && matchstr(a:variablePart[1], '\v\cstatic|public|protected|private') == ""
            let l:multipleVariableType = phpdocblocks#setTypeAbbreviation(a:variablePart[1])
        endif
        while l:i < len(l:multipleVariables)
            if l:multipleVariableType != ""
                let l:variables += [l:multipleVariableType." ".l:multipleVariables[l:i]]
            else
                let l:variables += [l:multipleVariables[l:i]]
            endif
            let l:i += 1
        endwhile
        return l:variables
    else
        return 0
    endif
endfunction
