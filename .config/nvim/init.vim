let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

let s:dein_cache_dir = g:cache_home . '/dein'
augroup MyAutoCmd autocmd!
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

let mapleader = "\<SPACE>"

if dein#load_state(s:dein_cache_dir)
    call dein#begin(s:dein_cache_dir)
    call dein#add('Shougo/dein.vim')
    call dein#add('Shougo/neocomplcache.vim')
    call dein#add('Shougo/neocomplete.vim')
    call dein#add('Shougo/neosnippet.vim')
    call dein#add('Shougo/neosnippet-snippets')
    let s:toml_dir = g:config_home . '/dein'

    call dein#load_toml(s:toml_dir . '/plugins.toml', {'lazy': 0})
    call dein#load_toml(s:toml_dir . '/neovim.toml', {'lazy': 0})
    call dein#load_toml(s:toml_dir . '/neovim_lazy.toml', {'lazy': 1})

    call dein#end()
endif

if has('vim_starting') && dein#check_install()
    call dein#install()
endif

"migrate insert to normal with esc esc
tnoremap <Esc><ESC> <C-\><C-n>
"disable highlight
nnoremap <ESC><ESC> :noh<CR>
"close current buffer
nnoremap <Space>q :bd<CR>

filetype plugin indent on

syntax on
syntax enable
set encoding=UTF-8

nmap / /\v


autocmd QuickFixCmdPost *grep* cwindow

" Digfile read as yaml and set yaml index keys
autocmd BufNewFile,BufRead *.dig set filetype=yaml
autocmd Syntax yaml setl indentkeys-=<:>

au BufNewFile,BufRead *.erl setf erlang
au BufRead,BufNewFile *.ex,*.exs set filetype=elixir

augroup QfAutoCommands
  autocmd!
  " Auto-close quickfix window
  autocmd WinEnter * if (winnr('$') == 1) && (getbufvar(winbufnr(0), '&buftype')) == 'quickfix' | quit | endif
augroup END

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

" improve replace
set inccommand=split
set hlsearch

highlight SpecialKey ctermfg=1
set list
"autocmd BufRead,BufNewFile *.ruby set listchars=tab:T>

set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

set mouse=a
set clipboard=unnamed

set cursorline
set ruler
set number

set noswapfile
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
colorscheme iceberg

set pumblend=30

highlight CursorLine ctermfg=black
highlight NERDTreeFile ctermfg=black
highlight VertSplit ctermfg=bg ctermbg=bg guifg=bg guibg=bg

set fileformats=unix,dos,mac


lua << EOF
   local on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    local set = vim.keymap.set
     set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
     set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
     set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
     set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
     set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
     set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
     set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
     set('n', 'gx', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
     set('n', 'g[', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
     set('n', 'g]', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
     set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
     end
   vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
   vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })

   require("mason").setup()
   require("mason-lspconfig").setup()
   require("mason-lspconfig").setup_handlers {
     function(server_name) -- default handler (optional)
       require("lspconfig")[server_name].setup {
         on_attach = on_attach,
       }
     end
   }
EOF
