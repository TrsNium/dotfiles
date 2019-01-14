let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

" dein {{{
let s:dein_cache_dir = g:cache_home . '/dein'

" reset augroup
augroup MyAutoCmd
    autocmd!
augroup END

if &runtimepath !~# '/dein.vim'
    let s:dein_repo_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'

    " Auto Download
    if !isdirectory(s:dein_repo_dir)
        call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
    endif

    " dein.vim をプラグインとして読み込む
    execute 'set runtimepath^=' . s:dein_repo_dir
endif

" dein.vim settings
let g:dein#install_max_processes = 16
let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let g:dein#enable_notification = 1

if dein#load_state(s:dein_cache_dir)
    call dein#begin(s:dein_cache_dir)
    call dein#add('Shougo/dein.vim')
    call dein#add('Shougo/neocomplcache.vim')
    call dein#add('Shougo/neocomplete.vim')
    call dein#add('Shougo/neosnippet.vim')
    call dein#add('Shougo/neosnippet-snippets')
    let s:toml_dir = g:config_home . '/dein'
  
    call dein#load_toml(s:toml_dir . '/plugins.toml', {'lazy': 0})
    call dein#load_toml(s:toml_dir . '/lazy.toml', {'lazy': 1})	
    call dein#load_toml(s:toml_dir . '/neovim.toml', {'lazy': 1})

    "let g:alduin_Shout_Fire_Breath = 1
    let g:neosnippet#snippets_directory='~/.config/snippets'
    "imap <expr><C-m> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
    "smap <C-m> <Plug>(neocomplcache_snippets_expand)
 
    let g:airline#extensions#tabline#enabled = 1
    nmap <C-p> <Plug>AirlineSelectPrevTab
    nmap <C-n> <Plug>AirlineSelectNextTab
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    if !exists('g:airline_symbols')
	    	let g:airline_symbols = {}
    endif
	 
    let g:airline_right_sep = '⮂'
    let g:airline_right_alt_sep = '⮃'
    let g:airline_symbols.crypt = '🔒'		"暗号化されたファイル
    let g:airline_symbols.linenr = '¶'			"行
    let g:airline_symbols.maxlinenr = '㏑'		"最大行
    let g:airline_symbols.branch = '⭠'		"gitブランチ
    let g:airline_symbols.paste = 'ρ'			"ペーストモード
    let g:airline_symbols.spell = 'Ꞩ'			"スペルチェック
    let g:airline_symbols.notexists = '∄'		"gitで管理されていない場合
    let g:airline_symbols.whitespace = 'Ξ'	"空白の警告(余分な空白など)
    let g:airline_solarized_bg='dark'
    call dein#end()
    "call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
    call dein#install()
endif
" }}}

if dein#tap('deoplete.nvim')
    let g:deoplete#enable_at_startup = 1
endif


nnoremap <C-h> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <C-k> :split<CR> :exe("tjump ".expand('<cword>'))<CR>

filetype plugin indent on
set number
syntax on
autocmd VimEnter * execute 'NERDTree'
set background=dark
colorscheme sierra
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE

set expandtab
set tabstop=2
set shiftwidth=2

set mouse=a

set autoindent
set noswapfile
set ruler
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=2
"}}}
"
