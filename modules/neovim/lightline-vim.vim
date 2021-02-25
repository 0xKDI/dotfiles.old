function! LightlineReadonly()
	return &readonly ? "" : ""
endfunction

function! LightlineFugitive()
	if exists("*FugitiveHead")
		let branch = FugitiveHead()
		return branch !=# "" ? " ".branch : ""
	endif
	return ""
endfunction

let g:lightline = {
			\ "colorscheme": "dracula",
			\ "active": {
			\   "left": [ [ "mode", "paste" ], [ "readonly", "fugitive", "truncatepath", "modified" ] ]
			\ },
			\ "component_function": {
			\   "readonly": "LightlineReadonly",
			\   "fugitive": "LightlineFugitive"
			\ },
			\ "component" : {
			\   "truncatepath": "%<%F"
			\ }
			\ }
