command! -bang ProjectFiles call fzf#vim#files('~/prj', <bang>0)
command! -bang Configs call fzf#vim#files('/etc/nixos', <bang>0)
let g:fzf_layout = { "window": { "width": 0.8, "height": 0.6 } }


nnoremap <silent> <leader>q :Files<CR>
nnoremap <silent> <leader>fp :Configs<CR>

nnoremap <silent> <leader>, :Windows<CR>
nnoremap <silent> <leader>w :Buffers<CR>

" TODO: add fzf function for cd
nnoremap <leader>p :cd %:h<CR>

" @help
" nnoremap <silent> <leader>Hh :Helptags<CR>
" nnoremap <silent> <leader>Hm :Maps<CR>

" @lines
nnoremap <silent> <leader>/ :BLines<CR>
nnoremap <silent> <leader>? :Lines<CR>
nnoremap <silent> <leader>; :Commands<CR>
nnoremap <silent> <leader><CR> :Marks<CR>
nnoremap <leader>r :Rg 
