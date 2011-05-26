" Set compiler for correct handling of error messages
compiler gcc

" MyMake
function! MyMake()
    ccl
    setlocal makeprg=~/bin/mymake
    silent make!
    redraw!
    for i in getqflist()
        if i['valid']
            cwin
            winc p
            return
        endif
    endfor
endfunction

cabbrev mymake call MyMake()
nnoremap <silent> <Leader>m :call MyMake()<CR>
