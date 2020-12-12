" TODO: add fzf function for cd
let g:fzf_layout = { "window": { "width": 0.8, "height": 0.6 } }


nnoremap <silent> <leader>q :Files<CR>
nnoremap <silent> <leader>fh :History<CR>
nnoremap <silent> <leader><leader>; :History:<CR>

nnoremap <silent> <leader>, :Windows<CR>
nnoremap <silent> <leader>w :Buffers<CR>

nnoremap <leader>p :cd %:h<CR>

nnoremap <silent> <leader>/ :BLines<CR>
nnoremap <silent> <leader>? :Lines<CR>
nnoremap <silent> <leader><leader>/ :History/<CR>
nnoremap <silent> <leader>; :Commands<CR>
nnoremap <silent> <leader><CR> :Marks<CR>
nnoremap <leader>r :Rg 
nnoremap <leader>gf :GFiles<CR>
nnoremap <leader>gc :Commits<CR>
" nnoremap <leader>gC :BCommits<CR>
