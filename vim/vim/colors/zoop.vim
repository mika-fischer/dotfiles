" Vim color file

set background=light
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="zoop"

if &t_Co == 88 || &t_Co == 256 || has("gui_running")
    " functions {{{
    " returns an approximate grey index for the given grey level
    fun! <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    fun! <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    fun! <SID>grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    fun! <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    fun! <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    fun! <SID>rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    fun! <SID>color(r, g, b)
        " get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " get the closest color
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return <SID>grey_color(l:gx)
            else
                " use the color
                return <SID>rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    fun! <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    fun! <SID>X(group, fg, bg, attr)
        " Foreground
        if a:fg =~ "^[0-9a-fA-F]\\{6\\}$"
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        elseif a:fg != ""
            exec "hi " . a:group . " guifg=" . a:fg . " ctermfg=" . a:fg
        endif

        " Background
        if a:bg =~ "^[0-9a-fA-F]\\{6\\}$"
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        elseif a:bg != ""
            exec "hi " . a:group . " guibg=" . a:bg . " ctermbg=" . a:bg
        endif

        " Attributes
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
    endfun
    " }}}
    " Don't set normal color for terminal, since it will interfere with
    " transparency
    hi Normal guifg=#000000 guibg=#f0f0d0
    hi Cursor guifg=bg      guibg=fg
    call <SID>X('CursorIM',         '000000',   'ff0000',   'NONE')

    " Vim UI elements
    call <SID>X('ColorColumn',      'NONE',     'ff8700',   'NONE')
    call <SID>X('Conceal',          '',         '',         '')
    call <SID>X('CursorColumn',     'NONE',     'e5e5e5',   'NONE')
    call <SID>X('CursorLine',       'NONE',     'e5e5e5',   'NONE')
    call <SID>X('Directory',        'blue',     '',         'bold')
    call <SID>X('ErrorMsg',         'ffffff',   'ff0000',   'NONE')
    call <SID>X('LineNr',           'b0b0b0',   'NONE',     'NONE')
    call <SID>X('MatchParen',       'NONE',     '00ffff',   'bold')
    call <SID>X('ModeMsg',          'NONE',     'NONE',     'bold')
    call <SID>X('MoreMsg',          'ffff00',   'NONE',     'bold')
    call <SID>X('NonText',          '626262',   'NONE',     'bold')
    call <SID>X('Question',         'ffff00',   'NONE',     'bold')
    call <SID>X('SignColumn',       'NONE',     'NONE',     'NONE')
    call <SID>X('SpecialKey',       '3a3a3a',   'NONE',     'NONE')
    call <SID>X('StatusLine',       '000000',   'f0b050',   'NONE')
    call <SID>X('StatusLineNC',     'NONE',     'c0c0c0',   'NONE')
    call <SID>X('TabLine',          'NONE',     'c0c0c0',   'NONE')
    call <SID>X('TabLineSel',       '000000',   'f0b050',   'NONE')
    call <SID>X('TabLineFill',      'NONE',     'c0c0c0',   'NONE')
    call <SID>X('Title',            'ff00ff',   'NONE',     'bold')
    call <SID>X('VertSplit',        'c0c0c0',   'c0c0c0',   'NONE')
    call <SID>X('Visual',           'NONE',     'e0e0e0',   'NONE')
    call <SID>X('VisualNOS',        'NONE',     'e0e0e0',   'underline')
    call <SID>X('WarningMsg',       'ff0000',   'NONE',     'NONE')
    call <SID>X('WildMenu',         '000000',   'ffff00',   'NONE')

    " Folding
    call <SID>X('Folded',           'NONE',     'e0e0e0',   'NONE')
    call <SID>X('FoldColumn',       'NONE',     'e0e0e0',   'NONE')

    " Completion
    call <SID>X('Pmenu',            'ffffff',   '444444',   'NONE')
    call <SID>X('PmenuSbar',        '585858',   '585858',   'NONE')
    call <SID>X('PmenuSel',         '000000',   '9e9e9e',   'NONE')
    call <SID>X('PmenuThumb',       'c6c6c6',   'c6c6c6',   'NONE')

    " Diff
    call <SID>X('DiffAdd',          'NONE',     'afffaf',   'NONE')
    call <SID>X('DiffChange',       'NONE',     'd7ffff',   'NONE')
    call <SID>X('DiffDelete',       '000000',   'ffa0a0',   'bold')
    call <SID>X('DiffText',         'NONE',     '87ffff',   'bold')

    " Search
    call <SID>X('IncSearch',        'NONE',     'cfff80',   'NONE')
    call <SID>X('Search',           'NONE',     'ffff00',   'NONE')

    " Spelling
    " TODO
    call <SID>X('SpellBad',         'NONE',     'f0c0c0',   'undercurl')
    call <SID>X('SpellCap',         'NONE',     '0000ff',   'undercurl')
    call <SID>X('SpellLocal',       'NONE',     '008b8b',   'undercurl')
    call <SID>X('SpellRare',        'NONE',     'ff00ff',   'undercurl')

    " Generic syntax highlight groups
    call <SID>X('Comment',          'b0b0b0',   'NONE',     'NONE')
    call <SID>X('Constant',         '0000af',   'NONE',     'NONE')
    call <SID>X('Identifier',       '5f8700',   'NONE',     'NONE')
    call <SID>X('Statement',        'ff005f',   'NONE',     'NONE')
    call <SID>X('PreProc',          'a020f0',   'NONE',     'NONE')
    call <SID>X('Type',             '2e8b57',   'NONE',     'NONE')
    call <SID>X('Special',          '6a5acd',   'NONE',     'NONE')
    call <SID>X('Underlined',       'NONE',     'NONE',     'underline')
    call <SID>X('Ignore',           '262626',   'NONE',     'NONE')
    call <SID>X('Error',            'ffffff',   'd70000',   'NONE')
    call <SID>X('Todo',             '0000ff',   'ffff00',   'NONE')

    " Constant specializations
    call <SID>X('String',           '',         '',         '')
    call <SID>X('Character',        '',         '',         '')
    call <SID>X('Number',           '',         '',         '')
    call <SID>X('Boolean',          '',         '',         '')
    call <SID>X('Float',            '',         '',         '')

    " Identifier specializations
    call <SID>X('Function',         'ff5f00',   '',         'NONE')

    " Statement specializations
    call <SID>X('Conditional',      '',         '',         '')
    call <SID>X('Repeat',           '',         '',         '')
    call <SID>X('Label',            '',         '',         '')
    call <SID>X('Operator',         '',         '',         '')
    call <SID>X('Keyword',          '',         '',         '')
    call <SID>X('Exception',        '',         '',         '')

    " PreProc specializations
    call <SID>X('Include',          '',         '',         '')
    call <SID>X('Define',           '',         '',         '')
    call <SID>X('Macro',            '',         '',         '')
    call <SID>X('PreCondit',        '',         '',         '')

    " Type specializations
    call <SID>X('StorageClass',     '',         '',         '')
    call <SID>X('Structure',        '',         '',         '')
    call <SID>X('Typedef',          '',         '',         '')

    " Special specializations
    call <SID>X('SpecialChar',      '',         '',         '')
    call <SID>X('Tag',              '',         '',         '')
    call <SID>X('Delimiter',        '',         '',         '')
    call <SID>X('SpeicalComment',   '',         '',         '')
    call <SID>X('Debug',            '',         '',         '')

    " delete functions {{{
    delf <SID>X
    delf <SID>rgb
    delf <SID>color
    delf <SID>rgb_color
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_color
    delf <SID>grey_level
    delf <SID>grey_number
    " }}}
else
endif

" vim: set fdl=0 fdm=marker:
