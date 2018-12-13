let s:search_word = 'five'

fun! s:setup_test_buffer() abort
  tabnew
  exe 'edit ' . resolve(expand('<sfile>:p:h')) . '/buffer.txt'
  call feedkeys("g/" . s:search_word . "\<CR>")
endf

fun! s:tear_down_test_buffer() abort
  bd
endf

fun! s:run_tests() abort
  call s:setup_test_buffer()
  call assert_match(@/, s:search_word)
  call s:tear_down_test_buffer()

  call s:setup_test_buffer()
  call assert_equal(line('.'), 1)
  call s:tear_down_test_buffer()

  if !empty(v:errors)
    echoerr string(v:errors)
  endif
endf

call s:run_tests()
