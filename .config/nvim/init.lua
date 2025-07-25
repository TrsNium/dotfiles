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

-- Auto-reload files
vim.opt.autoread = true

-- Other settings
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Ensure newline at end of file
vim.opt.fixendofline = true

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

-- Auto-reload files when changed outside of Neovim
local autoreload_group = augroup("AutoReload", { clear = true })
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = autoreload_group,
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
})

-- Notification when file is changed
autocmd("FileChangedShellPost", {
  group = autoreload_group,
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
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

  -- Alpha-nvim for dashboard/startup screen
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')
      
      -- Configure dashboard
      alpha.setup(dashboard.config)
      
      -- Fix statusline/laststatus for alpha
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.opt.laststatus = 0
          vim.opt.showtabline = 0
        end,
      })
      
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaClosed",
        callback = function()
          vim.opt.laststatus = 2
          vim.opt.showtabline = 2
        end,
      })
    end,
  },

  -- Feather.nvim file explorer
  {
    "TrsNium/feather.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,  -- Load immediately to ensure proper setup
    keys = {
      { "<leader>e", "<cmd>Feather<cr>", desc = "Toggle Feather file explorer" },
      { "<leader>fo", "<cmd>FeatherOpen<cr>", desc = "Open Feather file explorer" },
      { "<leader>fc", "<cmd>FeatherClose<cr>", desc = "Close Feather file explorer" },
      { "<leader>fe", "<cmd>FeatherCurrent<cr>", desc = "Open Feather in current file's directory" },
    },
    config = function()
      require("feather").setup({
        window = {
          width = 0.42,  -- 42% width for better center split
          height = 0.8,
          border = "rounded",  -- Changed from "rounded" to "single" for square borders
          position = "center",
        },
        icons = {
          enabled = true,
          folder = "",
          default_file = "",
        },
        features = {
          show_hidden = true,
          auto_close = true,
          split_view = true,  -- Set to true to enable split view mode
          max_columns = 4,
          column_separator = false,  -- Disable column separators by default
        },
        preview = {
          enabled = true,
          position = "auto",
          border = "rounded",  -- Border style for preview window (rounded, single, double, etc.)
          max_lines = 100,
          min_width = 30,
          min_height = 5,
        },
        keymaps = {
          quit = { "q", "<Esc>" },
          open = { "<CR>", "l" },
          parent = { "h" },
          down = { "j" },
          up = { "k" },
          toggle_hidden = { "." },
          toggle_icons = { "i" },
          toggle_preview = { "p" },
          preview_scroll_down = { "<C-d>" },
          preview_scroll_up = { "<C-u>" },
          home = { "~" },
          search = { "/" },
          help = { "?" },
        },
      })
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

  -- Statusline.lua for statusline
  {
    "beauwilliams/statusline.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('statusline').setup({
        match_colorscheme = true,
        tabline = false,
        lsp_diagnostics = true,
        style = "default",
      })
      
      -- Ensure statusline is shown properly
      vim.opt.laststatus = 2
      
      -- Customize statusline colors for iceberg theme
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "iceberg",
        callback = function()
          -- Set statusline filename color to match iceberg theme better
          vim.api.nvim_set_hl(0, "StatuslineFilename", { fg = "#84a0c6", bg = "#161821" })
          vim.api.nvim_set_hl(0, "StatuslineFilenameInactive", { fg = "#6b7089", bg = "#161821" })
          vim.api.nvim_set_hl(0, "StatusLine", { fg = "#84a0c6", bg = "#161821" })
          vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#6b7089", bg = "#161821" })
        end,
      })
      
      -- Apply colors immediately if iceberg is already loaded
      if vim.g.colors_name == "iceberg" then
        vim.api.nvim_set_hl(0, "StatuslineFilename", { fg = "#84a0c6", bg = "#161821" })
        vim.api.nvim_set_hl(0, "StatuslineFilenameInactive", { fg = "#6b7089", bg = "#161821" })
        vim.api.nvim_set_hl(0, "StatusLine", { fg = "#84a0c6", bg = "#161821" })
        vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#6b7089", bg = "#161821" })
      end
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

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- List of parsers to install
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "css",
          "dockerfile",
          "elixir",
          "erlang",
          "go",
          "hcl",  -- For Terraform
          "html",
          "java",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "ruby",
          "rust",
          "terraform",  -- Terraform syntax highlighting
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },

        -- Install parsers synchronously
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        highlight = {
          enable = true,
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },

        indent = {
          enable = true,
        },

        -- Enable incremental selection
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },

        -- Enable text objects
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })

      -- Treesitter folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false  -- Disable folding at startup
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

      -- Helper function for check_back_space
      function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end
    end,
  },

  -- Claude Code plugin for AI assistance
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("claude-code").setup({
        -- You can configure options here if needed
      })
    end,
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Open Claude Code" },
      { "<leader>ca", "<cmd>ClaudeCodeAsk<cr>", desc = "Ask Claude" },
      { "<leader>cr", "<cmd>ClaudeCodeReview<cr>", desc = "Review with Claude" },
    },
  },

  -- Git signs for showing git diff in the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          interval = 1000,
          follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true, desc = "Next git hunk"})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true, desc = "Previous git hunk"})

          -- Actions
          map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage hunk" })
          map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset hunk" })
          map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Stage selected hunk" })
          map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Reset selected hunk" })
          map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage buffer" })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset buffer" })
          map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview hunk" })
          map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = "Blame line" })
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "Toggle blame line" })
          map('n', '<leader>hd', gs.diffthis, { desc = "Diff this" })
          map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff this ~" })
          map('n', '<leader>td', gs.toggle_deleted, { desc = "Toggle deleted" })

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select hunk" })
        end
      })
    end,
  },

  -- Resonance.nvim for TidalCycles live coding
  {
    "TrsNium/resonance.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("resonance").setup({
        -- You can configure options here if needed
      })
    end,
    ft = { "tidal" }, -- Only load for .tidal files
    cmd = { "TidalStart", "TidalStop", "TidalEval", "TidalHush" },
    keys = {
      { "<leader>ts", "<cmd>TidalStart<cr>", desc = "Start Tidal REPL" },
      { "<leader>tq", "<cmd>TidalStop<cr>", desc = "Stop Tidal REPL" },
      { "<leader>te", "<cmd>TidalEval<cr>", desc = "Evaluate Tidal code" },
      { "<leader>th", "<cmd>TidalHush<cr>", desc = "Hush all patterns" },
    },
  },
})
