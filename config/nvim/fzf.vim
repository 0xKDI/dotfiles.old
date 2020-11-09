let g:fzf_layout = { "window": { "width": 0.8, "height": 0.6 } }


nnoremap <silent> <leader>q :Files<CR>
nnoremap <silent> <leader>fh :History<CR>
nnoremap <silent> <leader><leader>; :History:<CR>

nnoremap <silent> <leader>, :Windows<CR>
nnoremap <silent> <leader>w :Buffers<CR>

" TODO: add fzf function for cd
nnoremap <leader>p :cd %:h<CR>


nnoremap <silent> <leader>/ :BLines<CR>
nnoremap <silent> <leader>? :Lines<CR>
nnoremap <silent> <leader><leader>/ :History/<CR>
nnoremap <silent> <leader>; :Commands<CR>
nnoremap <silent> <leader><CR> :Marks<CR>
nnoremap <leader>r :Rg 
nnoremap <leader>gg :G
nnoremap <leader>gf :GFiles
nnoremap <leader>gc :Commits
nnoremap <leader>bc :BCommits


