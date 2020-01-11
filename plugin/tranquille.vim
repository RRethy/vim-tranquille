" Vim plugin for searching without moving the cursor
" Last Change:	2018 Nov 2
" Maintainer:	Adam P. Regasz-Rethy  <rethy.spud@gmail.com>
" License:	This file is placed in the public domain.

if exists('g:loaded_tranquille') || !has('autocmd')
    finish
endif
let g:loaded_tranquille = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

if mapcheck('g/') ==# '' && !hasmapto('<Plug>(tranquille_search)')
    nmap <unique> g/ <Plug>(tranquille_search)
endif

nnoremap <silent> <Plug>(tranquille_search) :TranquilleSearch<Return>

command! -nargs=0 TranquilleSearch
            \ let result = <SID>tranquille_search()
            \ | if result
                \ | set hls
                \ | endif

augroup tranquille_autocmds
    autocmd!
    autocmd CmdlineLeave * try | call matchdelete(s:tranquille_id) | catch /\v(E802|E803)/ | endtry
augroup END

let s:tranquille_id = 67

fun! s:tranquille_search() abort
    nohls
    augroup tranquille_textwatcher
        autocmd!
        autocmd CmdlineChanged * call s:update_hl()
    augroup END
    let search = input('/')
    augroup tranquille_textwatcher
        autocmd!
    augroup END
    if search !=# ''
        let @/ = search
        if search(search, 'n') == 0
            redraw
            echohl ErrorMsg | echo 'E486: Pattern not found: '.search | echohl None
        endif
        return 1
    else
        return 0
    endif
endf

fun! s:update_hl() abort
    try
        call matchdelete(s:tranquille_id)
    catch /\v(E802|E803)/
    endtry

    let l:pattern = ''
    if !&magic
        let l:pattern .= '\M'
    endif
    if &ignorecase
        let l:pattern .= '\c'
    endif
    let l:cmdline = getcmdline()
    if l:cmdline !=# ''
        let l:pattern .= l:cmdline
        call matchadd('Search', l:pattern, 0, s:tranquille_id)
    endif
    redraw
endf

let &cpoptions = s:save_cpo
unlet s:save_cpo
