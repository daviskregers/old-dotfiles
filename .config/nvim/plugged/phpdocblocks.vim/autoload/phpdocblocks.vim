" Add '@return void' to procedures 
let g:phpdocblocks_return_void = 1

" Move cursor automatically
let g:phpdocblocks_move_cursor = 0

" Use abbreviated type names (bool/boolean and int/integer)
let g:phpdocblocks_abbreviate_types = 1

" g:phpdocblocks_templates_directory is set in plugin/phpdocblocks.vim


" Inserts a doc block
function! phpdocblocks#insert(...)

    let l:declarationLines = s:getUntilCharacter( ["{",";"] )
    let l:cursorLineNum = line('.')
    let l:output = []
    "let l:output += [l:declarationLines]
    let l:code = ""
    let l:outputBelowCursor = 0

    " TODO: Refactor this section
    " Function
    if matchstr(l:declarationLines, '\vfunction\s+') != ""
        let l:code = s:getCode("block")
        let l:docData = phpdocblocks#function#parse(l:code)
        if type(l:docData) == v:t_dict
            let l:output += s:docTemplate(l:docData, "function")
        elseif type(l:docData) == v:t_list
            let l:output += l:docData
        endif
    " Class
    elseif matchstr(l:declarationLines, '\vclass\s+') != ""
        let l:code = s:getCode("block")
        let l:docData = phpdocblocks#class#parse(l:code)
        if type(l:docData) == v:t_dict
            let l:output += s:docTemplate(l:docData, "class")
        elseif type(l:docData) == v:t_list
            let l:output += l:docData
        endif
    " Interface
    elseif matchstr(l:declarationLines, '\vinterface\s+') != ""
        let l:code = s:getCode("block")
        let l:docData = phpdocblocks#interface#parse(l:code)
        if type(l:docData) == v:t_dict
            let l:output += s:docTemplate(l:docData, "interface")
        elseif type(l:docData) == v:t_list
            let l:output += l:docData
        endif
    " Trait
    elseif matchstr(l:declarationLines, '\vtrait\s+') != ""
        let l:code = s:getCode("block")
        let l:docData = phpdocblocks#trait#parse(l:code)
        if type(l:docData) == v:t_dict
            let l:output += s:docTemplate(l:docData, "trait")
        elseif type(l:docData) == v:t_list
            let l:output += l:docData
        endif
    " Variable
    elseif matchstr(l:declarationLines, '\v\${1}\w+%(;|\s)+') != ""
        let l:code = s:getCode("variable")
        let l:code = s:removeParenthesesContents(l:code)
        let l:docData = phpdocblocks#variable#parse(l:code)
        if type(l:docData) == v:t_dict && type(l:docData["variable"]) == v:t_string
            let l:output += s:docTemplate(l:docData, "variable")
        elseif type(l:docData) == v:t_dict && type(l:docData["variable"]) == v:t_list
            let l:output += s:docTemplate(l:docData, "multiple-variables")
        elseif type(l:docData) == v:t_list
            let l:output += l:docData
        endif
    " Constant
    elseif matchstr(l:declarationLines, '\vconst\s+|define\(') != ""
        let l:code = s:getCode("variable")
        let l:docData = phpdocblocks#constant#parse(l:code)
        if type(l:docData) == v:t_dict && type(l:docData["constant"]) == v:t_string
            let l:output += s:docTemplate(l:docData, "constant")
        elseif type(l:docData) == v:t_dict && type(l:docData["constant"]) == v:t_list
            let l:output += s:docTemplate(l:docData, "multiple-constants")
        elseif type(l:docData) == v:t_list
            let l:output += l:docData
        endif
    " File
    elseif matchstr(getline('.'), '\v%^\s*\<\?php') != ""
        let l:output += s:docTemplate([], "file")
        let l:outputBelowCursor = 1
    else
        let l:output = ['error', 'Can''t find anything to document. (Move cursor to a line with a keyword)']
    endif

    if l:output != [] && l:output[0] == "error"
        " Errors while testing need to be output to the buffer
        if a:0 > 0 && a:1 == "test"
            call append((l:cursorLineNum-1), "====== ERROR ======")
            call append((l:cursorLineNum), l:output[1])
            call append((l:cursorLineNum+1), "===================")
            call append((l:cursorLineNum-1), l:code)
        else
             execute "echohl Error | echon 'PHPDocBlocks: '.l:output[1] | echohl Normal"
        endif
   elseif len(l:output) > 0
        " Add indent
        let l:indent = matchstr(l:code, '\v^\s*')
        let l:indentedOutput = []
        for l:o in l:output
            let l:indentedOutput += [l:indent.l:o]
        endfor
        if l:outputBelowCursor == 1
            call append((l:cursorLineNum), l:indentedOutput)
        else
            call append((l:cursorLineNum-1), l:indentedOutput)
        endif
        "call append((l:cursorLineNum-1), l:code)
        if g:phpdocblocks_move_cursor == 1
            call cursor(l:cursorLineNum, 0)
            call search('\v\@.{-}([^(*/)]*|$)', 'e', l:cursorLineNum+10)
            execute ":startinsert"
            call cursor(line('.'), col('.')+1)
        endif
    endif

endfunction


" Return the code as a string
function! s:getCode(type)
    let l:code = ""
    let l:blockDepth = 0
    let l:lineNumber = line('.')
    let l:totalLinesInDocument = line('$')
    let l:isDoubleQuoteString = 0
    let l:isSingleQuoteString = 0
    while l:lineNumber <= l:totalLinesInDocument
        let l:line = s:removeStringContent(l:lineNumber)
        if a:type == "block"
            " Find the closing brace for the code block
            let l:openingBraceCount = len(split(l:line, '\v\{', 1)) - 1
            if l:openingBraceCount > 0
                let l:blockDepth += l:openingBraceCount
            endif
            let l:closingBraceCount = len(split(l:line, '\v\}', 1)) - 1
            if l:closingBraceCount > 0
                let l:blockDepth -= l:closingBraceCount
            endif
            " Add the line to the code block with a space instead of a new line
            let l:code .= l:line . " "
            if l:blockDepth == 0 && l:closingBraceCount > 0
                break
            endif
        elseif a:type == "variable"
            let l:semicolonPosition = matchstrpos(l:line, ";")
            if l:semicolonPosition[2] == -1
                let l:code .= l:line
            else
                let l:code .= l:line[0:l:semicolonPosition[2]]
                break
            endif
        endif
        let l:lineNumber += 1
    endwhile
    let l:code = s:removeArrayContents(l:code)
    return l:code
endfunction


" Script scope variables allow the content of multiple line PHP strings to be cleared
let s:isDoubleQuoteString = 0
let s:isSingleQuoteString = 0
" Remove PHP string content
function! s:removeStringContent(lineNumber)
    let l:line = getline(a:lineNumber)
    " Remove escaped quotes
    let l:line = substitute(l:line, '\v\\"|\\''', "", "g")
    " Remove all string content over multiple lines
    let l:chars = split(l:line, '\zs')
    let l:line = ""
    for l:char in l:chars
        if s:isSingleQuoteString == 0 && s:isDoubleQuoteString == 0
            if l:char == "'"
                let s:isSingleQuoteString = 1
                let l:line .= "'"
            elseif l:char == '"'
                let s:isDoubleQuoteString = 1
                let l:line .= '"'
            else
                let l:line .= l:char
            endif
        elseif s:isSingleQuoteString == 1
            if l:char == "'"
                let s:isSingleQuoteString = 0
                let l:line .= "'"
            " Keep \w characters for PHP define() constant names, it is
            " important to not keep spaces though, as PHP keywords may get
            " detected
            elseif matchstr(l:char, '\v\w') != ""
                let l:line .= l:char
            endif
        elseif s:isDoubleQuoteString == 1
            if l:char == '"'
                let s:isDoubleQuoteString = 0
                let l:line .= '"'
            " Keep \w characters for PHP define() constant names, it is
            " important to not keep spaces though, as PHP keywords may get
            " detected
            elseif matchstr(l:char, '\v\w') != ""
                let l:line .= l:char
            endif
        endif
    endfor
    " Avoid concatenating PHP keywords directly together by adding a space
    return l:line . " "
endfunction


" Get code starting from the line the cursor is on until a certain character is reached
function! s:getUntilCharacter(characters)
    let l:lineNumber = line('.')
    let l:totalLinesInDocument = line('$')
    let l:code = ""
    let l:line = ""
    while l:lineNumber <= l:totalLinesInDocument
        let l:line = s:removeStringContent(l:lineNumber)
        let l:code .= l:line
        for l:character in a:characters
            if matchstr(l:line, l:character) != ""
                let l:lineNumber = line('$')
            endif
        endfor
        let l:lineNumber += 1
    endwhile
    return l:code
endfunction


" Use full type name or abbreviated type name (int/integer, bool/boolean)
function! phpdocblocks#setTypeAbbreviation(type)
    let l:type = a:type
    if g:phpdocblocks_abbreviate_types
        let l:type = substitute(l:type,  '\v^integer$', 'int', "")
        let l:type = substitute(l:type, '\v^boolean$', 'bool', "")
    else
        let l:type = substitute(l:type,  '\v^int$', 'integer', "")
        let l:type = substitute(l:type, '\v^bool$', 'boolean', "")
    endif
    return l:type
endfunction


" Return PHP type based on the syntax of a string
function! phpdocblocks#getPhpType(syntax)
    " Remove whitespace - not used for Object types
    let l:syntax = substitute(a:syntax, '\v\s*', "", "g")
    " Starts and ends with ' or " (string)
    if matchstr(l:syntax, '\v^''|"$') != ""
        return "string"
    " A whole number
    elseif matchstr(l:syntax, '\v^[-+]{0,1}[0-9]+$') != ""
        return phpdocblocks#setTypeAbbreviation("int")
    " A number with a decimal
    elseif matchstr(l:syntax, '\v^[-+]{0,1}[0-9]+\.[0-9]+$') != ""
        return "float"
    " Is boolean - case insensitive
    elseif matchstr(l:syntax, '\v\c^true|false$') != ""
        return phpdocblocks#setTypeAbbreviation("bool")
    " Matches [] or array() - case insensitive
    elseif matchstr(l:syntax, '\v\c^\[\]|array\(\)$') != ""
        return "array"
    " Null - case insensitive
    elseif matchstr(l:syntax, '\v\c^null$') != ""
        return "null"
    " Object instantiation - case insensitive - no whitespace removed
    elseif matchstr(a:syntax, '\v\c^new \w+') != ""
        let l:instantiation = matchlist(a:syntax, '\v\c^new (\w+)')
        return l:instantiation[1]
    endif
    return ""
endfunction


" Remove everything inside array declarations
function! s:removeArrayContents(string)
    let l:chars = split(a:string, '\zs')
    let l:string = ""
    let l:squareDepth = 0
    let l:roundDepth = 0
    let l:i = -1
    for l:char in l:chars
        let l:i += 1
        if l:char == "["
            if l:squareDepth == 0 && l:roundDepth == 0
                let l:string .= l:char
            endif
            let l:squareDepth += 1
            continue
        elseif l:char == "]" && l:squareDepth != 0
            if l:squareDepth == 1 && l:roundDepth ==0
                let l:string .= l:char
            endif
            let l:squareDepth -= 1
            continue
        elseif l:char == "(" && a:string[l:i-5:l:i-1] == "array"
            if l:roundDepth == 0 && l:squareDepth == 0
                let l:string .= l:char
            endif
            let l:roundDepth += 1
            continue
        elseif l:char == ")" && l:roundDepth != 0
            if l:roundDepth == 1 && l:squareDepth == 0
                let l:string .= l:char
            endif
            let l:roundDepth -= 1
            continue
        endif
        if l:squareDepth == 0 && l:roundDepth == 0
            let l:string .= l:char
        endif
    endfor
    return l:string
endfunction


" Remove everything inside parentheses
function! s:removeParenthesesContents(string)
    let l:chars = split(a:string, '\zs')
    let l:string = ""
    let l:depth = 0
    for l:char in l:chars
        if l:char == "("
            if l:depth == 0
                let l:string .= l:char
            endif
            let l:depth += 1
            continue
        elseif l:char == ")"
            if l:depth == 1
                let l:string .= l:char
            endif
            let l:depth -= 1
            continue
        endif
        if l:depth == 0
            let l:string .= l:char
        endif
    endfor
    return l:string
endfunction


" Compose a doc block from a template
function! s:docTemplate(docData, docType)
    let l:templateLines = readfile(g:phpdocblocks_templates_directory . a:docType . ".tpl")
    let l:output = []
    for l:templateLine in l:templateLines
        if l:templateLine[0] != "#" && l:templateLine != ""
            let l:tagName = matchlist(l:templateLine, '\v\c\{\{[ ]*(.{-})[ ]*\}\}')
            if l:tagName != []
                let l:output += s:transformTemplateLine(a:docData, l:tagName[1], l:templateLine)
            else
                call add(l:output, l:templateLine)
            endif
        endif
    endfor
    return l:output
endfunction


" Convert template tags to documentation data
function! s:transformTemplateLine(docData, tagName, templateLine)
    let l:output = []
    if a:tagName == "newline"
        call add(l:output, "")
    endif
    if type(a:docData) == v:t_dict && has_key(a:docData, a:tagName)
        let l:lineRegex = '\v^(.{-})\{\{[ ]*'.a:tagName.'[ ]*\}\}(.{-})$'
        let l:linePart = matchlist(a:templateLine, l:lineRegex)
        if type(a:docData[a:tagName]) == v:t_list
            " Will not write template lines which have empty lists for tag data
            for l:data in a:docData[a:tagName]
                call add(l:output, l:linePart[1].l:data.l:linePart[2])
            endfor
        else
            call add(l:output, l:linePart[1].a:docData[a:tagName].l:linePart[2])
        endif
    endif
    return l:output
endfunction
