" Formats
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_MultipleCompileFormats = 'dvi,pdf'

" Viewers
let g:Tex_ViewRuleComplete_pdf = 'zathura $*.pdf >/dev/null 2>&1 &'
let g:Tex_ViewRuleComplete_dvi = 'zathura $*.dvi >/dev/null 2>&1 &'
let g:Tex_ViewRuleComplete_ps  = 'zathura $*.ps  >/dev/null 2>&1 &'

" Error handling
let g:Tex_GotoError = 0
let g:Tex_CompileRule_dvi = 'latex -interaction=nonstopmode -file-line-error $*'
let g:Tex_CompileRule_pdf = 'pdflatex -interaction=nonstopmode -file-line-error $*'

" Cosmetics
let g:Imap_PlaceHolderStart = '«'
let g:Imap_PlaceHolderEnd   = '»'

