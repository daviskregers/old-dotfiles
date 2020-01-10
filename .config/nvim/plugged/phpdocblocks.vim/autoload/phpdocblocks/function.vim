" Return a list of lines that make up the doc block
function! phpdocblocks#function#parse(codeBlock)
    " Match a valid function syntax, capture the name and parameters
    let l:functionPartsRegex = '\vfunction%(\s|\n)+(\S+)%(\s|\n)*\((.{-})\)%(\s|\n)*[:]{0,1}%(\s|\n)*%(\w*|[?]\w*)%(\s|\n)*\{'
    let l:functionParts = matchlist(a:codeBlock, l:functionPartsRegex)
    if l:functionParts != []
        let l:parameters = l:functionParts[2]
        let l:name = l:functionParts[1]
    else
        return ["error","Invalid PHP function declaration on this line."]
    endif
    " Parameters
    let l:parameters = s:parseFunctionParameters(l:parameters)
    " Exceptions
    let l:throws = s:parseFunctionThrows(a:codeBlock)
    " Return type
    let l:return = s:parseFunctionReturn(a:codeBlock)
    return {'name': l:name, 'param': l:parameters, 'throws': l:throws, 'return': l:return,}
endfunction


" Returns the return type
function! s:parseFunctionReturn(codeBlock)

    let l:declaredReturnRegex = '\vfunction%(\s|\n)+%(\S+)%(\s|\n)*\(%(.{-})\)%(\s|\n)*[:]{0,1}%(\s|\n)*(\w*|[?]\w*)%(\s|\n)*\{'
    let l:declaredReturn = matchlist(a:codeBlock, l:declaredReturnRegex)
    if l:declaredReturn[1] != ""
        let l:declaredReturn[1] = phpdocblocks#setTypeAbbreviation(l:declaredReturn[1])
        " Return type nullable?
        if l:declaredReturn[1][0] == "?"
            return l:declaredReturn[1][1:]."|null"
        endif
        return l:declaredReturn[1]
    endif

    let l:matchPosition = ["",0,0]
    let l:returnRegex = '\vreturn%(\s|\n)+(.{-})%(\s|\n)*[;]'
    let l:returnTypes = []

    if matchstr(a:codeBlock, l:returnRegex) != ""

        while 1
            " Start matching from the end of the last match
            let l:matchPosition = matchstrpos(a:codeBlock, l:returnRegex, l:matchPosition[2])
            if l:matchPosition[2] != -1
                let l:returnValue = matchlist(l:matchPosition[0], l:returnRegex)
                if len(l:returnValue) > 1
                    let l:returnType = phpdocblocks#getPhpType(l:returnValue[1])
                endif
                call add(l:returnTypes, l:returnType)
                continue
            endif
            break
        endwhile

        let l:sameReturnTypes = 1
        for l:rt in l:returnTypes
            if l:rt != l:returnTypes[0]
                let l:sameReturnTypes = 0
            endif
        endfor

        let l:explicitlyNotSameReturnTypes = 1
        for l:rt in l:returnTypes
            if l:rt == ""
                let l:explicitlyNotSameReturnTypes = 0
            endif
        endfor

        if l:sameReturnTypes
            let l:returnType = l:returnTypes[0]
        elseif l:explicitlyNotSameReturnTypes
            let l:uniqueReturnTypes = s:removeDuplicateListElements(l:returnTypes)
            let l:returnType = ""
            for l:rt in l:uniqueReturnTypes
                let l:returnType .= l:rt."|"
            endfor
            let l:returnType = substitute(l:returnType, '\v\|$', "", "")
        endif

        return l:returnType

    endif

    if g:phpdocblocks_return_void
        return "void"
    endif

    return ""

endfunction


" Returns a list of exceptions
function! s:parseFunctionThrows(codeBlock)

    " Match catch(Exception $var), capture exception name
    let l:catchRegex = '\v\}%(\s|\n)*catch%(\s|\n)*\(%(\s|\n)*([\\]{0,1}%(\w|\d)+)%(\s|\n)+[\$]%(\w|\d)+%(\s|\n)*\)%(\s|\n)*[{]'

    " Match throw new statement, capture the exception name
    let l:throwRegex = '\vthrow%(\s|\n)+new%(\s|\n)+(\\\u.{-}|\u.{-})%(\s|\n)*\(.{-}\)%(\s|\n)*[;]'

    let l:throws = []
    let l:exceptionsWithPosition = []
    let l:nestedThrowCode = []
    let l:matchPosition = ["",0,0]

    " Get catches that have no throw
    while l:matchPosition[2] != -1
        " Get the catch code block
        let l:matchPosition = matchstrpos(a:codeBlock, l:catchRegex, l:matchPosition[2])
        let l:i = l:matchPosition[2]-1
        let l:blockDepth = 0
        let l:catchBlock = ""
        while 1
            if a:codeBlock[l:i] == "{"
                let l:blockDepth += 1
            elseif a:codeBlock[l:i] == "}"
                let l:blockDepth -= 1
            endif
            let l:catchBlock .= a:codeBlock[l:i]
            let l:i += 1
            if l:blockDepth == 0
                break
            endif
        endwhile
        " Get exception names from catches without throws
        let l:exceptionNames = []
        let l:matchThrowInCatch = matchlist(l:catchBlock, l:throwRegex)
        if len(l:matchThrowInCatch) == 0
            let l:exceptionNames = matchlist(l:matchPosition, l:catchRegex)
            if len(l:exceptionNames) > 0 && l:matchPosition[2] != -1
                call add(l:exceptionsWithPosition, [l:exceptionNames[1], l:matchPosition[1]])
            endif
        endif
    endwhile

    " Get all throw statements
    let l:matchPosition = ["",0,0]
    while l:matchPosition[2] != -1
        let l:matchPosition = matchstrpos(a:codeBlock, l:throwRegex, l:matchPosition[2])
        let l:exceptionNames = matchlist(l:matchPosition, l:throwRegex)
        if len(l:exceptionNames) > 0 && l:matchPosition[2] != -1
            call add(l:exceptionsWithPosition, [l:exceptionNames[1], l:matchPosition[1]])
        endif
    endwhile

    " Order the exceptions as they appear in the code block
    let l:sorting = 1
    while l:sorting == 1
        let l:sorting = 0
        let l:i = 0
        let l:exceptionToSwap = []
        while l:i < len(l:exceptionsWithPosition)-1
            if l:exceptionsWithPosition[l:i][1] > l:exceptionsWithPosition[l:i+1][1]
                let l:exceptionToSwap = l:exceptionsWithPosition[l:i]
                let l:exceptionsWithPosition[l:i] = l:exceptionsWithPosition[l:i+1]
                let l:exceptionsWithPosition[l:i+1] = l:exceptionToSwap
                let l:sorting = 1
            endif
            let l:i += 1
        endwhile
    endwhile

    for exception in l:exceptionsWithPosition
        call add(l:throws, exception[0])
    endfor

    return l:throws

endfunction


" Returns a list of parameters
function! s:parseFunctionParameters(parameters)

    " Empty parameter declaration?
    if matchstr(a:parameters, '\v^%(\s|\n)*$') != ""
        return []
    endif

    " Transform each parameter into a line to be used as a doc block
    let l:paramsList = split(a:parameters, ",")

    let l:params = []
    for i in l:paramsList

        " Convert all whitespace and new lines to a single space globally
        let i = substitute(i, '\v(\s|\n)+', " ", "g")
        " Strip leading and trailing spaces
        let i = substitute(i, '\v^[ ]*(.{-})[ ]*$', '\1', "")
        " If has no type hint and has a '=' use the default value as the type
        if matchstr(i, '\v^[&]{0,1}\$\w+[ ]*[=][ ]*') != ""
            " Get the parameter value
            let l:paramValue = matchlist(i, '\v^[&]{0,1}\$\w+[ ]*[=][ ]*(.*)')
            let l:paramType = phpdocblocks#getPhpType(l:paramValue[1])
            if l:paramType != ""
                let i = l:paramType." ".i
            endif
        endif

        " Determine if the parameter is nullable and not defined as nullable
        " with a ? in front of the type hint
        if matchstr(i, '\v\c^[&]{0,1}\w+[ ]*[$]\w+[ ]*[=][ ]*null[ ]*$') != ""
            let i = "?".i
        endif

        " Remove everything from '=' to the end of line
        let i = substitute(i, '\v[ ]*[=][ ]*(.{-})[ ]*$', "", "")

        " Get the type hint and the parameter name
        let l:paramParts = matchlist(i, '\v(^[?]{0,1}[&]{0,1}\w+)\s*([$]\w*)')
        if l:paramParts != []
            " Set abbreviation for type when a type hint is declared
            let i = phpdocblocks#setTypeAbbreviation(l:paramParts[1]) . " " . l:paramParts[2]
            " If ? on front of the typehint it is a nullable parameter
            if i[0] == "?"
                if l:paramParts[1] != "?null"
                    let i = l:paramParts[1][1:]."|null ".l:paramParts[2]
                else
                    let i = i[1:]
                endif
            endif
        endif

        " Function contains variable arguments (...$args)
        if matchstr(i, '\v\.\.\.\$') != ""
            " Remove ... from start then add to end with a comma
            let i = substitute(i, '\v\.\.\.', "", "")
            let i = i.",..."
            " No type hint for this parameter
            if matchstr(i, '\v^\$') != ""
                let i = "mixed ".i
            endif
        endif
        call add(l:params, i)
    endfor

    return l:params

endfunction


function! s:removeDuplicateListElements(list)
    " if an element appears more than once in the list,
    " remove it, then continue to the next element and repeat
    return filter(a:list, 'count(a:list, v:val) == 1')
endfunction
