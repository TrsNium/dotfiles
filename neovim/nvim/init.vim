let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

let s:dein_cache_dir = g:cache_home . '/dein'
augroup MyAutoCmd
    autocmd!
augroup END

if &runtimepath !~# '/dein.vim'
    let s:dein_repo_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'

    if !isdirectory(s:dein_repo_dir)
        call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
    endif

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

    call dein#end()
endif

if has('vim_starting') && dein#check_install()
    call dein#install()
endif

if dein#tap('deoplete.nvim')
    let g:deoplete#enable_at_startup = 1
endif

nnoremap <C-h> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <C-k> :split<CR> :exe("tjump ".expand('<cword>'))<CR>

filetype plugin indent on

syntax on
syntax enable

set t_Co=256

autocmd VimEnter * execute 'NERDTree'
autocmd QuickFixCmdPost *grep* cwindow
autocmd BufNewFile,BufRead *.dig set filetype=yaml
autocmd Syntax yaml setl indentkeys-=<:>

colorscheme nord

hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE

set wrapscan
set ignorecase
set smartcase

set autoindent
set expandtab
set noexpandtab
set copyindent
set preserveindent
set softtabstop=0
set tabstop=2
set shiftwidth=2
set expandtab ts=2 sw=2 ai

highlight SpecialKey ctermfg=1
set list
set listchars=tab:T>

set mouse=a

set cursorline
set ruler
set number

highlight CursorLine ctermbg=Black
hi CursorLineNr term=bold cterm=NONE ctermbg=NONE

set noswapfile
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=2
