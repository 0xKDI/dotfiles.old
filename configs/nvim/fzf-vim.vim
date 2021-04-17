" TODO: add fzf function for cd
" https://github.com/junegunn/fzf/wiki/Examples-(vim)
let g:fzf_layout = { "window": { "width": 0.8, "height": 0.6 } }

autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

nnoremap <leader>ff :Files!<CR>
nnoremap <leader>fh :History!<CR>
nnoremap <leader><leader>; :History:!<CR>

nnoremap <leader>, :Windows!<CR>
nnoremap <leader>w :Buffers!<CR>

nnoremap <leader>p :cd %:h<CR>

nnoremap <leader>/ :BLines!<CR>
nnoremap <leader>? :Lines!<CR>
nnoremap <leader><leader>/ :History/!<CR>
nnoremap <leader>; :Commands!<CR>
nnoremap <leader><CR> :Marks!<CR>
nnoremap <leader>r :Rg!
nnoremap <leader>gf :GFiles!<CR>
nnoremap <leader>gc :Commits!<CR>
nnoremap <leader>gbc :BCommits!<CR>
