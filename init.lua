--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you edjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)

Uninstall and reinstall repo from git https://github.com/wilfriedbauer/nvim:
# Linux / Macos (unix)
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

# Windows
rd -r ~\AppData\Local\nvim
rd -r ~\AppData\Local\nvim-data

--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--settings:

vim.opt.guicursor = ""

vim.opt.nu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 10
vim.opt.sidescrolloff= 25
vim.opt.colorcolumn = "80"

vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true


-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
print(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'sindrets/diffview.nvim',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {
        -- display = {
        --   render_limit = 5,          -- How many LSP messages to show at once
        --   done_ttl = 1,
        --   progress_ttl = 3,
        --   },
        notification = {
          poll_rate = 1,             -- How frequently to update and render notifications
          override_vim_notify = true,
          },
          integration = {
            ["nvim-tree"] = {
              enable = true,         -- Integrate with nvim-tree/nvim-tree.lua (if installed)
            },
          },
        }
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  -- [[ Configure nvim-cmp ]]
  -- See `:help cmp`
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-emoji',
      'max397574/cmp-greek',
      'chrisgrieser/cmp-nerdfont',
      'hrsh7th/cmp-cmdline',
      "saadparwaiz1/cmp_luasnip",
      'hrsh7th/cmp-nvim-lua',
      'windwp/nvim-autopairs',
      'onsails/lspkind-nvim',
      { 'roobert/tailwindcss-colorizer-cmp.nvim', config = true }
    },
    config = function()
      local cmp = require("cmp")
      local lsp_kind = require("lspkind")
      local cmp_next = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        else
          fallback()
        end
      end
      local cmp_prev = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
        else
          fallback()
        end
      end

      lsp_kind.init()
      ---@diagnostic disable-next-line
      cmp.setup({
        enabled = true,
        preselect = cmp.PreselectMode.None,
        window = {
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
          col_offset = -3,
          side_padding = 0,
          -- completion = cmp.config.window.bordered({
          --   winhighlight = "Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None",
          -- }),
          -- documentation = cmp.config.window.bordered({
          --   winhighlight = "Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None",
          -- }),
        },
        --@diagnostic disable-next-line
        -- view = {
        --   entries = "bordered",
        -- },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({
              mode = "symbol_text",
              maxwidth = 50,
            })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"

            return kind
          end,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<S-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp_next,
          ["<down>"] = cmp_next,
          ["<C-n>"] = cmp_next,
          ["<C-j>"] = cmp_next,
          ["<S-Tab>"] = cmp_prev,
          ["<C-k>"] = cmp_prev,
          ["<C-p>"] = cmp_prev,
          ["<up>"] = cmp_prev,
        },
        sources = {
          { name = "nvim_lsp_signature_help", group_index = 1 },
          { name = "luasnip",                 group_index = 1, max_item_count = 5 },
          { name = "nvim_lsp",                group_index = 1, max_item_count = 20 },
          { name = "nvim_lua",                group_index = 1 },
          { name = "vim-dadbod-completion",   group_index = 1 },
          { name = "path",                    group_index = 1 },
          { name = "buffer",                  group_index = 1, max_item_count = 5, keyword_length = 2 },
          { name = "git" ,                    group_index = 1, max_item_count = 5 },
          { name = 'calc' ,                   group_index = 1, max_item_count = 5 },
          { name = 'gitmoji' ,                group_index = 1, max_item_count = 5 },
          { name = 'emoji' ,                  group_index = 1, max_item_count = 5 },
          { name = 'nerdfont',                group_index = 1, max_item_count = 5 },
          { name = 'greek' ,                  group_index = 1, max_item_count = 5 },
          { name = "cmp_tabnine",             group_index = 2, max_item_count = 5 },
        },
      })
      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        },
        {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            }
          }
        })
      })
      local presentAutopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      if not presentAutopairs then
        return
      end
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
    end,
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to next hunk' })

        map({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to previous hunk' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
        map('n', '<leader>hb', function()
          gs.blame_line { full = false }
        end, { desc = 'git blame line' })
        map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, { desc = 'git diff against last commit' })

        -- Toggles
        map('n', '<leader>gb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
        --map('n', '<leader>gd', gs.toggle_deleted, { desc = 'toggle git show deleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
      end,
    },
    config =
      function(_, opts)
        require('gitsigns').setup(opts)
        require("scrollbar.handlers.gitsigns").setup()
      end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    name = "tokyonight",
    priority = 1000,
    opts = {},
  },
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {},
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    name = "kanagawa",
    priority = 1000,
    opts = {},
  },
  'arkav/lualine-lsp-progress',
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
     dependencies = {
        "nvim-tree/nvim-web-devicons",
        "meuter/lualine-so-fancy.nvim",
    },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = '',
        globalstatus = true,
          refresh = {
              statusline = 100,
          },
      },
      sections = {
        lualine_a = {
            { "fancy_mode", width = 1 }
        },
        lualine_b = {
            { "fancy_branch" },
            { "fancy_diff" },
        },
        lualine_c = {
            { "fancy_cwd", substitute_home = true },
            { 'lsp_progress' }
        },
        lualine_x = {
            { "fancy_macro" },
            { "fancy_diagnostics" },
            { "fancy_searchcount" },
            { "fancy_location" },
        },
        lualine_y = {
            { "fancy_filetype", ts_icon = "" }
        },
        lualine_z = {
            { "fancy_lsp_servers" }
        },
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  --
  -- autoformat.lua
  --
  -- Use your language server to automatically format your code on save.
  -- Adds additional commands as well to manage the behavior
  'neovim/nvim-lspconfig',
  config = function()
    -- Switch for controlling whether you want autoformatting.
    --  Use :KickstartFormatToggle to toggle autoformatting on or off
    local format_is_enabled = true
    vim.api.nvim_create_user_command('KickstartFormatToggle', function()
      format_is_enabled = not format_is_enabled
      print('Setting autoformatting to: ' .. tostring(format_is_enabled))
    end, {})

    -- Create an augroup that is used for managing our formatting autocmds.
    --      We need one augroup per client to make sure that multiple clients
    --      can attach to the same buffer without interfering with each other.
    local _augroups = {}
    local get_augroup = function(client)
      if not _augroups[client.id] then
        local group_name = 'kickstart-lsp-format-' .. client.name
        local id = vim.api.nvim_create_augroup(group_name, { clear = true })
        _augroups[client.id] = id
      end

      return _augroups[client.id]
    end

    -- Whenever an LSP attaches to a buffer, we will run this function.
    --
    -- See `:help LspAttach` for more information about this autocmd event.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
      -- This is where we attach the autoformatting for reasonable clients
      callback = function(args)
        local client_id = args.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local bufnr = args.buf

        -- Only attach to clients that support document formatting
        if not client.server_capabilities.documentFormattingProvider then
          return
        end

        -- Tsserver usually works poorly. Sorry you work with bad languages
        -- You can remove this line if you know what you're doing :)
        if client.name == 'tsserver' then
          return
        end

        -- Create an autocmd that will run *before* we save the buffer.
        --  Run the formatting command for the LSP that has just attached.
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = get_augroup(client),
          buffer = bufnr,
          callback = function()
            if not format_is_enabled then
              return
            end

            vim.lsp.buf.format {
              async = false,
              filter = function(c)
                return c.id == client.id
              end,
            }
          end,
        })
      end,
    })
  end,

  -- require 'kickstart.plugins.debug',
  --
  -- NOTE: Yes, you can install new plugins here!
  {
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'theHamsta/nvim-dap-virtual-text',

    -- Add your own debuggers here
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require("mason").setup()
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        'python'
        -- Update this to ensure that you have the debuggers for the langs you want
        --'delve',
      },
    }


    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<leader>bc', dap.continue, { desc = '[B]ug: Start/[C]ontinue' })
    vim.keymap.set('n', '<leader>bi', dap.step_into, { desc = '[B]ug: Step [I]nto' })
    vim.keymap.set('n', '<leader>bo', dap.step_over, { desc = '[B]ug: Step [O]ver' })
    vim.keymap.set('n', '<leader>bu', dap.step_out, { desc = '[B]ug: Step O[u]t' })
    vim.keymap.set('n', '<leader>bp', dap.toggle_breakpoint, { desc = '[B]ug: Toggle [B]reakpoint' })
    vim.keymap.set('n', '<leader>bP', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = '[B]ug: Set [c]onditional Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<leader>bb', dapui.toggle, { desc = 'De[b]ug: Toggle UI' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
  end,
  },
  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
  'ryanoasis/vim-devicons',
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
        keymaps = {
          insert = "<c-g>s",
          insert_line = "<c-g>S",
          normal = "s",
          normal_cur = "S",
          normal_line = "gS",
          normal_cur_line = "gs",
          visual = "s",
          visual_line = "S",
          delete = "ds",
          change = "cs",
          change_line = "cS",
        },
      })
    end
  },
  'windwp/nvim-ts-autotag',
  'monkoose/matchparen.nvim',
  'nvim-pack/nvim-spectre',
  'RRethy/vim-illuminate',
  'brenoprata10/nvim-highlight-colors',
  'petertriho/nvim-scrollbar',
  'mbbill/undotree',
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  },
  { "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    opts = {
      db_competion = function()
        ---@diagnostic disable-next-line
        require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
      end,
    },
    config = function(_, opts)
      vim.g.db_ui_save_location = vim.fn.stdpath "config" .. require("plenary.path").path.sep .. "db_ui"

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "sql",
        },
        command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "sql",
          "mysql",
          "plsql",
        },
        callback = function()
          vim.schedule(opts.db_completion)
        end,
      })
    end,
    keys = {
      { "<leader>dd", "<cmd>DBUIToggle<cr>",        desc = "Toggle UI" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>",    desc = "Find Buffer" },
      { "<leader>dr", "<cmd>DBUIRenameBuffer<cr>",  desc = "Rename Buffer" },
      { "<leader>dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
    },
  },
  'simrat39/symbols-outline.nvim',
  'm4xshen/autoclose.nvim',
  {
    'declancm/cinnamon.nvim',
    config = function() require('cinnamon').setup() end
  },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  'benfowler/telescope-luasnip.nvim',
  'ThePrimeagen/harpoon',
  'm-demare/hlargs.nvim',
  'nvim-tree/nvim-tree.lua',
  'nvim-treesitter/nvim-treesitter-context',
  {
  'ErichDonGubler/lsp_lines.nvim',
  config = function()
    vim.diagnostic.config({
      virtual_text = false,
    })
    require("lsp_lines").setup()
  end,
  },
  {
  "aznhe21/actions-preview.nvim",
  config = function()
    require('actions-preview').setup{
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
      },
      vim.keymap.set({ "v", "n" }, "<leader>c", require("actions-preview").code_actions, { desc = "Code Action" })
    }
    end,
  },
  {
  'zegervdv/nrpattern.nvim',
  config = function()
    -- Basic setup
    -- See below for more options
    require("nrpattern").setup()
  end,
  },
  {
    "rbong/vim-flog",
    lazy = true,
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup()
    end,
  },
  {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesj').setup({
      --@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
      use_default_keymaps = false,
      max_join_length = 1000,})
  end,
  },
  {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function ()
    -- Change '<C-g>' here to any keycode you like.
    vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<C-h>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<C-l>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  end
  },
  { 'codota/tabnine-nvim', build = "./dl_binaries.sh" },
  {
     'tzachar/cmp-tabnine',
     build = './install.sh',
     dependencies = 'hrsh7th/nvim-cmp',
  },
  {'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async'},
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter"
    }
  },
  'lvimuser/lsp-inlayhints.nvim',
  { "lukas-reineke/virt-column.nvim", opts = {} },
  { "Dynge/gitmoji.nvim", dependencies = { "hrsh7th/nvim-cmp" }, opts = {} },
  { "petertriho/cmp-git", dependencies = { "nvim-lua/plenary.nvim" }, opts = {}},
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true
  },
  {
    "Zeioth/compiler.nvim",
    cmd = {"CompilerOpen", "CompilerToggleResults", "CompilerRedo"},
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},
  },
  {
    "stevearc/overseer.nvim",
    commit = "400e762648b70397d0d315e5acaf0ff3597f2d8b",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1
      },
    },
  },
  {'akinsho/toggleterm.nvim', version = "*", config = true},
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
}, {})

-- [[Setup Custom Plugins ]]

-- colorscheme
vim.cmd[[colorscheme catppuccin-mocha]]

require('lsp-inlayhints').setup()

vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require("lsp-inlayhints").on_attach(client, bufnr)
  end,
})

require('virt-column').setup()

require('nvim-highlight-colors').setup()

require("luasnip.loaders.from_vscode").lazy_load()

require("nvim-dap-virtual-text").setup()

require('cinnamon').setup {
  -- KEYMAPS:
  default_keymaps = true,   -- Create default keymaps.
  -- Smooth scrolling for ...
  -- Half-window movements:      <C-U> and <C-D>
  -- Page movements:             <C-B>, <C-F>, <PageUp> and <PageDown>
  extra_keymaps = true,    -- Create extra keymaps.
  -- Smooth scrolling for ...
  -- Start/end of file:          gg and G
  -- Line number:                [count]G
  -- Start/end of line:          0, ^ and $
  -- Paragraph movements:        { and }
  -- Prev/next search result:    n, N, *, #, g* and g#
  -- Prev/next cursor location:  <C-O> and <C-I>
  -- Screen scrolling:           zz, zt, zb, z., z<CR>, z-, z^, z+, <C-Y> and <C-E>
  -- Horizontal scrolling:       zH, zL, zs, ze, zh and zl
  extended_keymaps = true, -- Create extended keymaps.
  -- Smooth scrolling for ...
  -- Up/down movements:          j, k, <Up> and <Down>
  -- Left/right movements:       h, l, <Left> and <Right>
  override_keymaps = true, -- The plugin keymaps will override any existing keymaps.

  -- OPTIONS:
  always_scroll = true,    -- Scroll the cursor even when the window hasn't scrolled.
  centered = true,          -- Keep cursor centered in window when using window scrolling.
  disabled = false,         -- Disables the plugin.
  default_delay = 5,        -- The default delay (in ms) between each line when scrolling.
  hide_cursor = false,      -- Hide the cursor while scrolling. Requires enabling termguicolors!
  horizontal_scroll = true, -- Enable smooth horizontal scrolling when view shifts left or right.
  max_length = -1,          -- Maximum length (in ms) of a command. The line delay will be
                            -- re-calculated. Setting to -1 will disable this option.
  scroll_limit = 50,       -- Max number of lines moved before scrolling is skipped. Setting
                            -- to -1 will disable this option.
}

require('refactoring').setup()

require('hlargs').setup()

require("bufferline").setup()

require("symbols-outline").setup()

require "lsp_signature".setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded"
  },
  select_signature_key = "<C-s>",
  hint_prefix = "",
  hint_inline = function() return true end,
  toggle_key = "<C-l>", -- toggle signature on and off in insert mode,
  move_cursor_key ="<C-k>",
})

require'nvim-treesitter.configs'.setup {
  autotag = {
    enable = true,
  }
}

require('tabnine').setup({
  disable_auto_comment=true,
  accept_keymap="<Tab>",
  dismiss_keymap = "<C-]>",
  debounce_ms = 800,
  suggestion_color = {gui = "#808080", cterm = 244},
  exclude_filetypes = {"TelescopePrompt", "NvimTree"},
  log_file_path = nil, -- absolute path to Tabnine log file
})

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})

require("autoclose").setup()

require('matchparen').setup()

local colors = require("catppuccin.palettes").get_palette "mocha"

require("scrollbar").setup({
  handle = {
    color = colors.surface2,
  },
  marks = {
    Search = { color = colors.green },
    Error = { color = colors.red },
    Warn = { color = colors.yellow },
    Info = { color = colors.blue },
    Hint = { color = colors.peach },
    Misc = { color = colors.teal },
  },
})

require("harpoon").setup({
	global_settings = { save_on_toggle = false, save_on_change = true, enter_on_sendcmd = false },
	menu = { width = 50, height = 8, borderchars = { "", "", "", "", "", "", "", "" } },
})

vim.api.nvim_set_keymap(
	"n",
	"''",
	'<Cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>',
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"n",
	"'a",
	'<Cmd>lua require("harpoon.mark").add_file()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"'1",
	'<Cmd>lua require("harpoon.ui").nav_file(1)<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"'2",
	'<Cmd>lua require("harpoon.ui").nav_file(2)<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"'3",
	'<Cmd>lua require("harpoon.ui").nav_file(3)<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"'4",
	'<Cmd>lua require("harpoon.ui").nav_file(4)<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"'5",
	'<Cmd>lua require("harpoon.ui").nav_file(5)<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"'6",
	'<Cmd>lua require("harpoon.ui").nav_file(6)<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"'7",
	'<Cmd>lua require("harpoon.ui").nav_file(7)<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"'8",
	'<Cmd>lua require("harpoon.ui").nav_file(8)<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"'9",
	'<Cmd>lua require("harpoon.ui").nav_file(9)<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"'0",
	'<Cmd>lua require("harpoon.ui").nav_file(0)<CR>',
	{ noremap = true, silent = true }
)
vim.cmd([[
highlight HarpoonBorder guibg=#282828 guifg=white
highlight HarpoonWindow guibg=#282828 guifg=white
augroup vimrc_harpoon
  autocmd!
  autocmd Filetype harpoon nnoremap <buffer><silent> <Esc> <Cmd>lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>
augroup END
]])

-- [[ Setting Custom Plugins Keymaps ]]
vim.keymap.set(
  "n",
  "<leader>rr",
  function() return ":IncRename " .. vim.fn.expand("<cword>") end,
  { desc = "Rename word under cursor" }
)

vim.keymap.set("n", "<leader>a", ":SymbolsOutline<CR>")

-- have to set <C-_> instead of <C-/> for terminal toggle on CTRL-/. 
-- same hotkey for leaving terminal as ESC cant be used for vi keybinds in terminal.
vim.keymap.set('n', '<C-_>', '<cmd>ToggleTerm size=15 dir=git_dir direction=horizontal name=TERMINAL<CR>', {desc = 'Toggle Terminal', noremap = true})

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<C-_>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end
-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

vim.keymap.set("n", "<leader>RR", "<cmd>CompilerOpen<cr>")
vim.keymap.set("n", "<leader>RS", "<cmd>CompilerStop<cr>")
vim.keymap.set("n", "<leader>RT", "<cmd>CompilerToggleResults<cr>")

vim.keymap.set('n', 'zO', require('ufo').openAllFolds)
vim.keymap.set('n', 'zC', require('ufo').closeAllFolds)

vim.keymap.set('n', 'zh', 'zH', { desc = 'Scroll right' })
vim.keymap.set('n', 'zl', 'zL', { desc = 'Scroll left' })

vim.keymap.set('n', '<Up>', ':resize -2<CR>', { desc = 'Resize Down' })
vim.keymap.set('n', '<Down>', ':resize +2<CR>', { desc = 'Resize Up' })
vim.keymap.set('n', '<Left>', ':vertical resize +2<CR>', { desc = 'Resize Left' })
vim.keymap.set('n', '<Right>', ':vertical resize -2<CR>', { desc = 'Resize Right' })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set('n', '<leader>j', require('treesj').toggle, { desc = "Toggle Join/Split of Code Block" })
vim.keymap.set('n', '<C-p>', ':BufferLineCyclePrev<CR>', { desc = 'Previous Tab' })
vim.keymap.set('n', '<C-n>', ':BufferLineCycleNext<CR>', { desc = 'Next Tab' })
vim.keymap.set('n', '<leader>Q', ':BufferLinePickClose<CR>', { desc = 'Pick Tabs to close' })

vim.keymap.set('n', '<leader>TT', '<cmd>lua require("neotest").run.run()<CR>', {desc = '[T]est: Run nearest [T]est'})
vim.keymap.set('n', '<leader>TF', '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', {desc = '[T]est: Run [F]ile'})
vim.keymap.set('n', '<leader>TS', '<cmd>lua require("neotest").run.stop()<CR>', {desc = '[T]est: [S]top'})

vim.keymap.set('n', '<leader>s', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })

vim.keymap.set('n', '<leader>gdd', ':DiffviewOpen<cr>', { desc = '[G]it [D]iff View' })
vim.keymap.set('n', '<leader>gdo', ':DiffviewOpen ', { desc = '[G]it [D]iff View [O]pen' })
vim.keymap.set('n', '<leader>gdc', ':DiffviewClose<cr>', { desc = '[G]it [D]iff View [C]lose' })
vim.keymap.set('n', '<leader>gg', ':Neogit<cr>', { desc = 'Neo [G]it' })
vim.keymap.set('n', '<leader>gs', ':G status<cr>', { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gl', ':Gclog<cr>', { desc = '[G]it [L]og' })
vim.keymap.set("n", "<leader>gf", ":Flog<CR>", { desc = '[G]it [F]log' })

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>', { desc = '[N]vim [T]ree Toggle' })
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<cr>', { desc = '[N]vim [T]ree Toggle' })

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[U]ndotree Toggle' })

-- make y behave like d or c. shift-y copy whole line
vim.keymap.set("n", "Y", "y$")

-- move visual selection up or down a line with <s-j> and <s-k>
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- INFO:
-- Instead of pressing ^ you can press _(underscore) to jump to the first non-whitespace character on the same line the cursor is on.
--
-- + and - jump to the first non-whitespace character on the next / previous line.
--
-- (These commands only work in normal mode, not in insert mode.)


-- paste without overwriting paste register
vim.keymap.set("v", "p", '"_dP')

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 50
vim.o.timeoutlen = 100

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Close Buffer' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>K', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Trouble keymaps
vim.keymap.set("n", "<leader>tt", function() require("trouble").toggle() end, { desc = '[T]rouble [T]oggle' })
vim.keymap.set("n", "<leader>tw", function() require("trouble").toggle("workspace_diagnostics") end,
  { desc = '[T]rouble [W]orkspace Diagnostics' })
vim.keymap.set("n", "<leader>td", function() require("trouble").toggle("document_diagnostics") end,
  { desc = '[T]rouble [D]ocument Diagnostics' })
vim.keymap.set("n", "<leader>tq", function() require("trouble").toggle("quickfix") end, { desc = '[T]rouble [Q]uickfix' })
vim.keymap.set("n", "<leader>tl", function() require("trouble").toggle("loclist") end, { desc = '[T]rouble [L]ocation List' })
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end, { desc = '[T]rouble LSP [R]eferences' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
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
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { shorten = { len = 5, exclude = {-3, -2, -1} }, 'truncate' },
    winblend = 0,
    border = {},
    borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      -- for input mode
      i = {
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<C-k>"] = require("telescope.actions").move_selection_previous,
        ["<C-n>"] = require("telescope.actions").cycle_history_next,
        ["<C-p>"] = require("telescope.actions").cycle_history_prev,
      },
      -- for normal mode
      n = {
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<C-k>"] = require("telescope.actions").move_selection_previous,
        ["q"] = require("telescope.actions").close
      },
    },
  },
}
pcall(require('telescope').load_extension('luasnip'))

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set(
  'n',
  '<leader>?',
  require('telescope.builtin').oldfiles,
  { desc = '[?] Find recently opened files' }
)
vim.keymap.set(
  'n',
  '<leader><space>',
  require('telescope.builtin').buffers,
  { desc = '[ ] Find existing buffers' }
)
vim.keymap.set(
  'n',
  '<leader>/',
  require('telescope.builtin').current_buffer_fuzzy_find,
  { desc = '[/] Fuzzily search in current buffer' }
)

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
vim.keymap.set('n', '<leader>f/', telescope_live_grep_open_files, { desc = '[F]ind [/] in Open Files' })
vim.keymap.set('n', '<leader>ft', require('telescope.builtin').builtin, { desc = '[F]ind [T]elescope' })
vim.keymap.set('n', '<leader>fs', ':Telescope luasnip<CR>', { desc = '[F]ind [S]nippets' })
vim.keymap.set('n', '<leader>fgf', require('telescope.builtin').git_files, { desc = '[F]ind [G]it [F]iles' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fG', require('telescope.builtin').live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fgr', ':LiveGrepGitRoot<cr>', { desc = '[F]ind by Grep on [G]it [R]oot' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').resume, { desc = '[F]ind [R]esume Last Search' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      'c',
      'cpp',
      'c_sharp',
      'go',
      'lua',
      'python',
      'tsx',
      'http',
      'json',
      'json5',
      'html',
      'scss',
      'yaml',
      'xml',
      'sql',
      'diff',
      'dockerfile',
      'terraform',
      'angular',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'bash',
      'git_config',
      'git_rebase',
      'gitattributes',
      'gitcommit',
      'gitignore'
    },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']['] = '@function.outer',
          [']{'] = '@class.outer',
        },
        goto_next_end = {
          [']]'] = '@function.outer',
          [']}'] = '@class.outer',
        },
        goto_previous_start = {
          ['[['] = '@function.outer',
          ['[{'] = '@class.outer',
        },
        goto_previous_end = {
          ['[]'] = '@function.outer',
          ['[}'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>x'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>z'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  -- nmap('<leader>c', vim.lsp.buf.code_action, '[C]ode Action')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('gl', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('gL', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('L', function() require('lsp_signature').toggle_float_win() end, 'Toggle Signature Documentation')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Lesser used LSP functionality
  nmap('<leader>wd', require('telescope.builtin').lsp_document_symbols, '[D]ocument Symbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
require('which-key').register {
  ['<leader>b'] = { name = '[B]ug', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>fg'] = { name = '[F]ind [G]it', _ = 'which_key_ignore' },
  ['<leader>gd'] = { name = '[G]it [D]iff', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]rouble', _ = 'which_key_ignore' },
  ['<leader>T'] = { name = '[T]est', _ = 'which_key_ignore' },
  ['<leader>R'] = { name = '[R]un', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]atabase', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
  ['<leader>'] = { name = 'VISUAL <leader>' },
  ['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = true,
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
