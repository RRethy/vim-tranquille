" Vim plugin for searching without moving the cursor
" Last Change:	2018 Nov 1
" Maintainer:	Adam P. Regasz-Rethy  <rethy.spud@gmail.com>
" License:	This file is placed in the public domain.

if exists('g:loaded_tranquille')
  finish
endif
let g:loaded_tranquille = 1

let s:save_cpo = &cpo
set cpo&vim

if mapcheck("g/") == "" && !hasmapto(":TranquilleSearch<CR>")
  nnoremap g/ :TranquilleSearch<CR>
endif

command! TranquilleSearch set hls | call <SID>tranquille_search()

if has("autocmd")
  augroup tranquille_autocmds
    autocmd!
    autocmd CmdlineLeave * try | call matchdelete(s:tranquille_id) | catch /\v(E802|E803)/ | endtry
  augroup END
endif

let s:tranquille_id = 67

fun! s:tranquille_search() abort
  nohls
  let Highlight_cb = function("s:highlight_cb")
  let search = input({'prompt': '/', 'highlight': Highlight_cb})
  let @/ = search
endf

fun! s:highlight_cb(cmdline) abort
  try
    call matchdelete(s:tranquille_id)
  catch /\v(E802|E803)/
  endtry

  let pattern = ''
  if !&magic
    let pattern .= '\M'
  endif
  if &ignorecase
    let pattern .= '\c'
  endif
  let pattern .= a:cmdline
  call matchadd('Search', pattern, 0, s:tranquille_id)
  redraw

  return []
endf

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et foldlevel=1 sw=2 foldmethod=expr foldexpr=getline(v\:lnum)=~'^\"\ Section\:'?'>1'\:getline(v\:lnum)=~#'^fu'?'a1'\:getline(v\:lnum)=~#'^endf'?'s1'\:'=':
