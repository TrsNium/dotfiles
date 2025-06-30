-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.opt.encoding = "UTF-8"
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.opt.syntax = "on"
vim.opt.filetype = "on"
vim.opt.filetype.indent = true
vim.opt.filetype.plugin = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"

-- Indentation
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true

-- UI settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.cursorline = true
vim.opt.laststatus = 2
vim.opt.showtabline = 2
vim.opt.showmode = false
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", trail = "·", extends = "»", precedes = "«" }
vim.opt.termguicolors = true
vim.opt.pumblend = 30

-- Mouse and clipboard
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- Other settings
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Keymaps
local keymap = vim.keymap

-- Terminal mode escape
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Clear search highlight
keymap.set("n", "<Esc><Esc>", ":noh<CR>", { desc = "Clear search highlight", silent = true })

-- Close buffer
keymap.set("n", "<Space>q", ":bd<CR>", { desc = "Close buffer" })

-- Better search
keymap.set("n", "/", "/\\v", { desc = "Search with very magic" })

-- Buffer navigation
keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer", silent = true })
keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })
keymap.set("n", "<leader>1", ":b1<CR>", { desc = "Go to buffer 1", silent = true })
keymap.set("n", "<leader>2", ":b2<CR>", { desc = "Go to buffer 2", silent = true })
keymap.set("n", "<leader>3", ":b3<CR>", { desc = "Go to buffer 3", silent = true })
keymap.set("n", "<leader>4", ":b4<CR>", { desc = "Go to buffer 4", silent = true })
keymap.set("n", "<leader>5", ":b5<CR>", { desc = "Go to buffer 5", silent = true })

-- Autocommands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Quickfix auto-open
autocmd("QuickFixCmdPost", {
  pattern = "*grep*",
  command = "cwindow",
})

-- Auto-close quickfix window
local qf_group = augroup("QfAutoCommands", { clear = true })
autocmd("WinEnter", {
  group = qf_group,
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.bo.buftype == "quickfix" then
      vim.cmd("quit")
    end
  end,
})

-- Filetype specific settings
autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.dig",
  command = "set filetype=yaml",
})

autocmd("Syntax", {
  pattern = "yaml",
  command = "setl indentkeys-=<:>",
})

autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.erl",
  command = "setf erlang",
})

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.ex", "*.exs" },
  command = "set filetype=elixir",
})

-- Plugin setup
require("lazy").setup({
  -- Iceberg colorscheme
  {
    "cocopon/iceberg.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme iceberg")
    end,
  },

  -- NERDTree file explorer
  {
    "preservim/nerdtree",
    cmd = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" },
    keys = {
      { "<leader>e", ":NERDTreeToggle<CR>", desc = "Toggle NERDTree" },
      { "<leader>nf", ":NERDTreeFind<CR>", desc = "Find current file in NERDTree" },
    },
    config = function()
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeMinimalUI = 1
      vim.g.NERDTreeDirArrows = 1
    end,
  },

  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>f.", "<cmd>Telescope find_files cwd=%:p:h<cr>", desc = "Find files (current dir)" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
            cwd = vim.fn.getcwd(),
          },
        },
      })
    end,
  },

  -- Bufferline for better buffer visualization
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "ordinal",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            icon = "▎",
            style = "icon",
          },
          buffer_close_icon = "✕",
          modified_icon = "●",
          close_icon = "✕",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 18,
          max_prefix_length = 15,
          tab_size = 18,
          diagnostics = false,
          offsets = {
            {
              filetype = "NERDTree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
            }
          },
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          separator_style = "thin",
          enforce_regular_tabs = false,
          always_show_bufferline = true,
        },
      })
    end,
  },

  -- Vim-airline for statusline
  {
    "vim-airline/vim-airline",
    dependencies = {
      "vim-airline/vim-airline-themes",
    },
    event = "VeryLazy",
    config = function()
      vim.g.airline_powerline_fonts = 0
      vim.g["airline#extensions#tabline#enabled"] = 0
      vim.g.airline_theme = "iceberg"
    end,
  },

  -- Better buffer deletion (keeps window layout)
  {
    "moll/vim-bbye",
    cmd = { "Bdelete", "Bwipeout" },
    keys = {
      { "<leader>bd", ":Bdelete<CR>", desc = "Delete buffer (keep window)" },
      { "<leader>bD", ":Bdelete!<CR>", desc = "Force delete buffer" },
    },
  },

  -- Toggle terminal for better workflow
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-\\>", desc = "Toggle terminal" },
    },
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
        },
      })
    end,
  },

  -- Indent visualization
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
          highlight = { "Function", "Label" },
        },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "NvimTree",
            "Trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
        },
      })
    end,
  },

  -- coc.nvim for code completion
  {
    "neoclide/coc.nvim",
    branch = "release",
    build = "npm ci",
    lazy = false,
    config = function()
      -- Some servers have issues with backup files
      vim.opt.backup = false
      vim.opt.writebackup = false

      -- Having longer updatetime leads to noticeable delays
      vim.opt.updatetime = 300

      -- Always show the signcolumn
      vim.opt.signcolumn = "yes"

      -- Use Tab for trigger completion
      local keyset = vim.keymap.set
      local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
      
      keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
      keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
      keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      -- Use <c-space> to trigger completion
      keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

      -- Use `[g` and `]g` to navigate diagnostics
      keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
      keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

      -- GoTo code navigation
      keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
      keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
      keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
      keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

      -- Use K to show documentation in preview window
      function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
          vim.fn.CocActionAsync('doHover')
        else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
      end
      keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

      -- Highlight the symbol and its references on a CursorHold event
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold"
      })

      -- Symbol renaming
      keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

      -- Formatting selected code
      keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
      keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})

      -- Apply codeAction to the selected region
      keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", {silent = true})
      keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", {silent = true})

      -- Remap keys for apply code actions at the cursor position
      keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", {silent = true})
      keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", {silent = true})
      keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", {silent = true, nowait = true})

      -- Remap keys for apply refactor code actions
      keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
      keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
      keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

      -- Run the Code Lens actions on the current line
      keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", {silent = true})

      -- Map function and class text objects
      keyset("x", "if", "<Plug>(coc-funcobj-i)", {silent = true})
      keyset("o", "if", "<Plug>(coc-funcobj-i)", {silent = true})
      keyset("x", "af", "<Plug>(coc-funcobj-a)", {silent = true})
      keyset("o", "af", "<Plug>(coc-funcobj-a)", {silent = true})
      keyset("x", "ic", "<Plug>(coc-classobj-i)", {silent = true})
      keyset("o", "ic", "<Plug>(coc-classobj-i)", {silent = true})
      keyset("x", "ac", "<Plug>(coc-classobj-a)", {silent = true})
      keyset("o", "ac", "<Plug>(coc-classobj-a)", {silent = true})

      -- Remap <C-f> and <C-b> to scroll float windows/popups
      keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', {silent = true, nowait = true, expr = true})
      keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', {silent = true, nowait = true, expr = true})
      keyset("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', {silent = true, nowait = true, expr = true})
      keyset("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', {silent = true, nowait = true, expr = true})
      keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', {silent = true, nowait = true, expr = true})
      keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', {silent = true, nowait = true, expr = true})

      -- Use CTRL-S for selections ranges
      keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
      keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})

      -- Add `:Format` command to format current buffer
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

      -- Add `:Fold` command to fold current buffer
      vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

      -- Add (Neo)Vim's native statusline support
      vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

      -- Helper function for check_back_space
      function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end
    end,
  },
})