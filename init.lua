-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--settings:
vim.opt.guicursor = ""

vim.opt.nu = true

-- enable relative line numbers next to absolute line numbers.
-- vim.opt.relativenumber = true
-- vim.o.statuscolumn = "%s %l %=%r "

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

vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 5

-- enables colorcolumn plugin virt-column.nvim:
vim.opt.colorcolumn = ""

-- ufo.nvim
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- auto-session.nvim
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- change diagnostic signs and display the most severe one in the sign gutter on the left.
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local filter_diagnostics = function(diagnostics)
  if not diagnostics then
    return {}
  end

  -- find the "worst" diagnostic per line
  local most_severe = {}
  for _, cur in pairs(diagnostics) do
    local max = most_severe[cur.lnum]

    -- higher severity has lower value (`:h diagnostic-severity`)
    if not max or cur.severity < max.severity then
      most_severe[cur.lnum] = cur
    end
  end

  -- return list of diagnostics
  return vim.tbl_values(most_severe)
end

---custom namespace
local ns = vim.api.nvim_create_namespace('severe-diagnostics')

---reference to the original handler
local orig_signs_handler = vim.diagnostic.handlers.signs

---Overriden diagnostics signs helper to only show the single most relevant sign
---:h diagnostic-handlers
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    -- get all diagnostics from the whole buffer rather
    -- than just the diagnostics passed to the handler
    local diagnostics = vim.diagnostic.get(bufnr)

    local filtered_diagnostics = filter_diagnostics(diagnostics)

    -- pass the filtered diagnostics (with the
    -- custom namespace) to the original handler
    orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
  end,

  hide = function(_, bufnr)
    orig_signs_handler.hide(ns, bufnr)
  end,
}


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
      {
        'j-hui/fidget.nvim',
        opts = {
          -- display = {
          --   render_limit = 5,          -- How many LSP messages to show at once
          --   done_ttl = 1,
          --   progress_ttl = 3,
          --   },
          notification = {
            poll_rate = 1, -- How frequently to update and render notifications
            override_vim_notify = true,
          },
          integration = {
            ["nvim-tree"] = {
              enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
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
          ["<S-Tab>"] = cmp_prev,
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
          { name = 'calc',                    group_index = 1, max_item_count = 5 },
          { name = 'gitmoji',                 group_index = 1, max_item_count = 5 },
          { name = 'emoji',                   group_index = 1, max_item_count = 5 },
          { name = 'nerdfont',                group_index = 1, max_item_count = 5 },
          { name = 'greek',                   group_index = 1, max_item_count = 5 },
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
          { "fancy_cwd",   substitute_home = true },
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
  {
    -- Use your language server to automatically format your code on save.
    -- Adds additional commands as well to manage the behavior
    'neovim/nvim-lspconfig',
    config = function()
      -- Switch for controlling whether you want autoformatting.
      --  Use :FormatToggle to toggle autoformatting on or off
      local format_is_enabled = true
      vim.api.nvim_create_user_command('FormatToggle', function()
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

          -- only in neovim 0.10-nightly
          -- if client.server_capabilities.inlayHintProvider then
          --   vim.lsp.buf.inlay_hint(bufnr, true)
          -- end

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
  },
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
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        desc = "Prevent colorscheme clearing self-defined DAP marker colors",
        callback = function()
          -- Reuse current SignColumn background (except for DapStoppedLine)
          local sign_column_hl = vim.api.nvim_get_hl(0, { name = 'SignColumn' })
          -- if bg or ctermbg aren't found, use bg = 'bg' (which means current Normal) and ctermbg = 'Black'
          -- convert to 6 digit hex value starting with #
          local sign_column_bg = (sign_column_hl.bg ~= nil) and ('#%06x'):format(sign_column_hl.bg) or 'bg'
          local sign_column_ctermbg = (sign_column_hl.ctermbg ~= nil) and sign_column_hl.ctermbg or 'Black'

          vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#00ff00', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
          vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2e4d3d', ctermbg = 'Green' })
          vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#c23127', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
          vim.api.nvim_set_hl(0, 'DapBreakpointRejected',
            { fg = '#888ca6', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
          vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
        end
      })

      -- reload current color scheme to pick up colors override if it was set up in a lazy plugin definition fashion
      vim.cmd.colorscheme(vim.g.colors_name)

      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint' })
      vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped' })

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
          'netcoredbg',
          -- Update this to ensure that you have the debuggers for the langs you want
          --'delve',
        },
      }
      dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.adapters.netcoredbg = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/src/", "file")
          end,
        },
      }

      vim.o.noshellslash = true

      -- Basic debugging keymaps, feel free to change to your liking!
      vim.keymap.set('n', '<leader>Bc', dap.continue, { desc = '[B]ug: Start/[C]ontinue' })
      vim.keymap.set('n', '<leader>Bi', dap.step_into, { desc = '[B]ug: Step [I]nto' })
      vim.keymap.set('n', '<leader>Bo', dap.step_over, { desc = '[B]ug: Step [O]ver' })
      vim.keymap.set('n', '<leader>Bu', dap.step_out, { desc = '[B]ug: Step O[u]t' })
      vim.keymap.set('n', '<leader>Bp', dap.toggle_breakpoint, { desc = '[B]ug: Toggle [B]reakpoint' })
      vim.keymap.set('n', '<leader>BP', function()
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
      vim.keymap.set('n', '<leader>Bb', dapui.toggle, { desc = 'De[b]ug: Toggle UI' })

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
  'RRethy/vim-illuminate',
  'brenoprata10/nvim-highlight-colors',
  'petertriho/nvim-scrollbar',
  'mbbill/undotree',
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
  {
    "tpope/vim-dadbod",
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
      { "<leader>Dd", "<cmd>DBUIToggle<cr>",        desc = "Toggle UI" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>",    desc = "Find Buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>",  desc = "Rename Buffer" },
      { "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
    },
  },
  'simrat39/symbols-outline.nvim',
  'm4xshen/autoclose.nvim',
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  'benfowler/telescope-luasnip.nvim',
  'm-demare/hlargs.nvim',
  'nvim-tree/nvim-tree.lua',
  'nvim-treesitter/nvim-treesitter-context',
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      require('actions-preview').setup {
        telescope = {
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
        },
        vim.keymap.set({ "v", "n" }, "<leader>c", require("actions-preview").code_actions, { desc = "Code Action (Preview)" })
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
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
        --@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
        use_default_keymaps = false,
        max_join_length = 1000,
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "luukvbaal/statuscol.nvim",
    },
    event = "BufReadPost",
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },

    init = function()
      vim.keymap.set("n", "zO", function()
        require("ufo").openAllFolds()
      end)
      vim.keymap.set("n", "zC", function()
        require("ufo").closeAllFolds()
      end)
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "VimEnter",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        segments = {
          {
            sign = {
              name = {
                "Diagnostic",
              },
              maxwidth = 1,
              colwidth = 1,
              auto = true,
            },
            click = "v:lua.ScSa",
          },
          {
            sign = {
              namespace = { "gitsign" },
              maxwidth = 1,
              colwidth = 1,
              auto = true,
              fillchar = " ",
              fillcharhl = "StatusColumnSeparator",
            },
            click = "v:lua.ScSa",
          },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          {
            sign = {
              name = {
                "Dap",
                "neotest",
              },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
            },
            click = "v:lua.ScSa",
          },
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        },
      })
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Issafalcon/neotest-dotnet",
    }
  },
  { "lukas-reineke/virt-column.nvim", opts = {} },
  { "Dynge/gitmoji.nvim",             dependencies = { "hrsh7th/nvim-cmp" }, opts = {} },
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
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
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
  { 'akinsho/toggleterm.nvim',          version = "*", config = true },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  'cshuaimin/ssr.nvim',
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        manual_mode = true,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },
  {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_enable_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
      }
    end
  },
  { 'ojroques/nvim-bufdel' },
  { 'IMOKURI/line-number-interval.nvim' },
  { 'LunarVim/bigfile.nvim' },
  {
    "tiagovla/scope.nvim",
    config = function()
      require('scope').setup()
    end,
  },
  { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
  {
    'abecodes/tabout.nvim',
    lazy = false,
    config = function()
      require('tabout').setup {
        tabkey = '<Tab>',             -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true,            -- shift content if tab out is not possible
        act_as_shift_tab = false,     -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = '<C-t>',        -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = '<C-d>',  -- reverse shift default action,
        enable_backwards = true,      -- well ...
        completion = false,           -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = '`', close = '`' },
          { open = '(', close = ')' },
          { open = '[', close = ']' },
          { open = '{', close = '}' }
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {} -- tabout will ignore these filetypes
      }
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "L3MON4D3/LuaSnip",
      "hrsh7th/nvim-cmp"
    },
    event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
    priority = 1000,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      debug = false,                                              -- set to true to enable debug logging
      log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
      -- default is  ~/.cache/nvim/lsp_signature.log
      verbose = false,                                            -- show debug line number

      bind = true,                                                -- This is mandatory, otherwise border config won't get registered.
      -- If you want to hook lspsaga or other signature handler, pls set to false
      doc_lines = 100,                                            -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
      -- set to 0 if you DO NOT want any API comments be shown
      -- This setting only take effect in insert mode, it does not affect signature help in normal
      -- mode, 10 by default

      max_height = 25,                       -- max height of signature floating_window
      max_width = 80,                        -- max_width of signature floating_window, line will be wrapped if exceed max_width
      -- the value need >= 40
      wrap = true,                           -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
      floating_window = true,                -- show hint in a floating window, set to false for virtual text only mode

      floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
      -- will set to true when fully tested, set to false will use whichever side has more space
      -- this setting will be helpful if you do not want the PUM and floating win overlap

      floating_window_off_x = 1, -- adjust float windows x position.
      -- can be either a number or function
      floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
      -- can be either number or function, see examples

      close_timeout = 4000,                      -- close floating window after ms when laster parameter is entered
      fix_pos = false,                           -- set to true, the floating window will not auto-close until finish all parameters
      hint_enable = false,                       -- virtual hint enable
      hint_prefix = "",                          -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
      hint_scheme = "String",
      hint_inline = function() return false end, -- should the hint be inline(nvim 0.10 only)?  default false
      -- return true | 'inline' to show hint inline, return 'eol' to show hint at end of line, return false to disable
      -- return 'right_align' to display hint right aligned in the current line
      hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
      handler_opts = {
        border = "none"                             -- double, rounded, single, shadow, none, or a table of borders
      },

      always_trigger = false,                  -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

      auto_close_after = nil,                  -- autoclose signature float win after x sec, disabled if nil.
      extra_trigger_chars = {},                -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
      zindex = 200,                            -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

      padding = '',                            -- character to pad on left and right of signature can be ' ', or '|'  etc

      transparency = nil,                      -- disabled by default, allow floating win transparent value 1~100
      shadow_blend = 36,                       -- if you using shadow as border use this set the opacity
      shadow_guibg = 'Black',                  -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
      timer_interval = 200,                    -- default timer check interval set to lower value if you want to reduce latency
      toggle_key = '<C-s>',                    -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
      toggle_key_flip_floatwin_setting = true, -- true: toggle floating_windows: true|false setting after toggle key pressed
      -- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
      -- may not popup when typing depends on floating_window setting

      select_signature_key = '<C-j>', -- cycle to next signature, e.g. '<M-n>' function overloading
      move_cursor_key = '<C-k>',      -- imap, use nvim_set_current_win to move cursor between current win and floating
    },
    config = function(_, opts) require 'lsp_signature'.setup(opts) end
  },
  {
    "soulis-1256/eagle.nvim",
    config = function()
      require("eagle").setup({
        -- override the default values found in config.lua
        border = 'none'
      })
      -- make sure mousemoveevent is enabled
      vim.o.mousemoveevent = true
    end,
    enabled = false, -- set to true to get mouseover lsp hints and diagnostics. (rightclick menu doesnt work!)
  },
  {
    "iabdelkareem/csharp.nvim",
    dependencies = {
      "williamboman/mason.nvim", -- Required, automatically installs omnisharp
      "mfussenegger/nvim-dap",
      "Tastyep/structlog.nvim",  -- Optional, but highly recommended for debugging
    },
    config = function()
      require("mason").setup() -- Mason setup must run before csharp
      require("csharp").setup()
    end
  },
  { 'HiPhish/rainbow-delimiters.nvim' },
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    enabled = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gx").setup {
        open_browser_app = "powershell.exe", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
        open_browser_args = {},            -- specify any arguments, such as --background for macOS' "open".
        handlers = {
          plugin = true,                   -- open plugin links in lua (e.g. packer, lazy, ..)
          github = true,                   -- open github issues
          brewfile = true,                 -- open Homebrew formulaes and casks
          package_json = true,             -- open dependencies from package.json
          search = true,                   -- search the web/selection on the web if nothing else is found
          go = true,                       -- open pkg.go.dev from an import statement (uses treesitter)
          jira = {                         -- custom handler to open Jira tickets (these have higher precedence than builtin handlers)
            name = "jira",                 -- set name of handler
            handle = function(mode, line, _)
              local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
              if ticket and #ticket < 20 then
                return "http://jira.company.com/browse/" .. ticket
              end
            end,
          },
          rust = {                   -- custom handler to open rust's cargo packages
            name = "rust",           -- set name of handler
            filetype = { "toml" },   -- you can also set the required filetype for this handler
            filename = "Cargo.toml", -- or the necessary filename
            handle = function(mode, line, _)
              local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")

              if crate then
                return "https://crates.io/crates/" .. crate
              end
            end,
          },
        },
        handler_options = {
          search_engine = "google",               -- you can select between google, bing, duckduckgo, and ecosia
          -- search_engine = "https://search.brave.com/search?q=", -- or you can pass in a custom search engine
          select_for_search = false,              -- if your cursor is e.g. on a link, the pattern for the link AND for the word will always match. This disables this behaviour for default so that the link is opened without the select option for the word AND link

          git_remotes = { "upstream", "origin" }, -- list of git remotes to search for git issue linking, in priority
          -- git_remotes = function(fname)                       -- you can also pass in a function
          --   if fname:match("myproject") then
          --     return { "mygit" }
          --   end
          --   return { "upstream", "origin" }
          -- end,

          git_remote_push = true, -- use the push url for git issue linking,
          -- git_remote_push = function(fname) -- you can also pass in a function
          --   return fname:match("myproject")
          -- end,
        },
      }
    end,
  },
}, {})

-- [[Setup Custom Plugins ]]

require("oil").setup({
  -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
  -- Set to false if you still want to use netrw.
  default_file_explorer = false,
  -- Id is automatically added at the beginning, and name at the end
  -- See :help oil-columns
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  -- Buffer-local options to use for oil buffers
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  -- Window-local options to use for oil buffers
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
  -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
  delete_to_trash = false,
  -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
  skip_confirm_for_simple_edits = false,
  -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
  -- (:help prompt_save_on_select_new_entry)
  prompt_save_on_select_new_entry = true,
  -- Oil will automatically delete hidden buffers after this delay
  -- You can set the delay to false to disable cleanup entirely
  -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
  cleanup_delay_ms = 2000,
  lsp_file_methods = {
    -- Time to wait for LSP file operations to complete before skipping
    timeout_ms = 1000,
    -- Set to true to autosave buffers that are updated with LSP willRenameFiles
    -- Set to "unmodified" to only save unmodified buffers
    autosave_changes = false,
  },
  -- Constrain the cursor to the editable parts of the oil buffer
  -- Set to `false` to disable, or "name" to keep it on the file names
  constrain_cursor = "editable",
  -- Set to true to watch the filesystem for changes and reload oil
  experimental_watch_for_changes = false,
  -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
  -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
  -- Additionally, if it is a string that matches "actions.<name>",
  -- it will use the mapping at require("oil.actions").<name>
  -- Set to `false` to remove a keymap
  -- See :help oil-actions for a list of all available actions
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-h>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
  -- Set to false to disable all of the above keymaps
  use_default_keymaps = true,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
    -- This function defines what is considered a "hidden" file
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, ".")
    end,
    -- This function defines what will never be shown, even when `show_hidden` is set
    is_always_hidden = function(name, bufnr)
      return false
    end,
    -- Sort file names in a more intuitive order for humans. Is less performant,
    -- so you may want to set to false if you work with large directories.
    natural_order = true,
    sort = {
      -- sort order can be "asc" or "desc"
      -- see :help oil-columns to see which columns are sortable
      { "type", "asc" },
      { "name", "asc" },
    },
  },
  -- Extra arguments to pass to SCP when moving/copying files over SSH
  extra_scp_args = {},
  -- EXPERIMENTAL support for performing file operations with git
  git = {
    -- Return true to automatically git add/mv/rm files
    add = function(path)
      return true
    end,
    mv = function(src_path, dest_path)
      return true
    end,
    rm = function(path)
      return true
    end,
  },
  -- Configuration for the floating window in oil.open_float
  float = {
    -- Padding around the floating window
    padding = 2,
    max_width = 0,
    max_height = 0,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
    -- This is the config that will be passed to nvim_open_win.
    -- Change values here to customize the layout
    override = function(conf)
      return conf
    end,
  },
  -- Configuration for the actions floating preview window
  preview = {
    -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a single value or a list of mixed integer/float types.
    -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
    max_width = 0.9,
    -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
    min_width = { 40, 0.4 },
    -- optionally define an integer/float for the exact width of the preview window
    width = nil,
    -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_height and max_height can be a single value or a list of mixed integer/float types.
    -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
    max_height = 0.9,
    -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
    min_height = { 5, 0.1 },
    -- optionally define an integer/float for the exact height of the preview window
    height = nil,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
    -- Whether the preview window is automatically updated when the cursor is moved
    update_on_cursor_moved = true,
  },
  -- Configuration for the floating progress window
  progress = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    width = nil,
    max_height = { 10, 0.9 },
    min_height = { 5, 0.1 },
    height = nil,
    border = "rounded",
    minimized_border = "none",
    win_options = {
      winblend = 0,
    },
  },
  -- Configuration for the floating SSH window
  ssh = {
    border = "rounded",
  },
  -- Configuration for the floating keymaps help window
  keymaps_help = {
    border = "rounded",
  },
})


require("neotest").setup({
  adapters = {
    require("neotest-dotnet")({
      dap = {
        -- Extra arguments for nvim-dap configuration
        -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
        args = { justMyCode = false },
        -- Enter the name of your dap adapter, the default value is netcoredbg
        adapter_name = "netcoredbg"
      },
      -- Let the test-discovery know about your custom attributes (otherwise tests will not be picked up)
      -- Note: Only custom attributes for non-parameterized tests should be added here. See the support note about parameterized tests
      custom_attributes = {
        -- xunit = { "MyCustomFactAttribute" },
        -- nunit = { "MyCustomTestAttribute" },
        -- mstest = { "MyCustomTestMethodAttribute" }
      },
      -- Provide any additional "dotnet test" CLI commands here. These will be applied to ALL test runs performed via neotest. These need to be a table of strings, ideally with one key-value pair per item.
      dotnet_additional_args = {
        "--verbosity detailed"
      },
      -- Tell neotest-dotnet to use either solution (requires .sln file) or project (requires .csproj or .fsproj file) as project root
      -- Note: If neovim is opened from the solution root, using the 'project' setting may sometimes find all nested projects, however,
      --       to locate all test projects in the solution more reliably (if a .sln file is present) then 'solution' is better.
      discovery_root = "project" -- Default
    })
  }
})


-- colorscheme
vim.cmd [[colorscheme catppuccin-mocha]]

-- Config for line-number-interval.nvim:
-- Enable line number interval at startup. (default: 0(disable))
vim.g.line_number_interval_enable_at_startup = 1

-- Set interval to highlight line number. (default: 10)
vim.g["line_number_interval"] = 999999999999999999

-- Enable to use custom interval. (default: 0(disable))
-- If this option is enabled, highlight for relative position of cursor position.
vim.g["line_number_interval#use_custom"] = 1

-- Set custom interval list.
-- (default: fibonacci sequence ([1, 2, 3, 5, 8, 13, 21, 34, 55, ...]))
-- Relative position to highlight.
vim.g["line_number_interval#custom_interval"] = { 5, 10, 15, 20, 25, 30, 35, 40, 45 }

-- Set color to highlight and dim.
-- (default: HighlightedLineNr use LineNr color,
--           DimLineNr use same as background color (it seems hide).)
vim.cmd("highlight HighlightedLineNr guifg=#a2a3ac ctermfg=7")
vim.cmd("highlight DimLineNr guifg=#4e455a ctermfg=5")

-- Tints of #4e455a for fade out effect on line number intervals:
-- #45475a #57596a #6a6b7a #7c7e8b #8f909c #a2a3ac #b4b5bd #c7c7cd #d9dade #ececee #ffffff

-- Additional highlight
-- Use those colors for Nth (1st ~ 9th) element of custom interval.
vim.cmd("highlight HighlightedLineNr1 guifg=#b4b5bd ctermfg=3")
vim.cmd("highlight HighlightedLineNr2 guifg=#a2a3ac ctermfg=3")
vim.cmd("highlight HighlightedLineNr3 guifg=#8f909c ctermfg=3")
vim.cmd("highlight HighlightedLineNr4 guifg=#7c7e8b ctermfg=5")
vim.cmd("highlight HighlightedLineNr5 guifg=#6a6b7a ctermfg=4")
vim.cmd("highlight HighlightedLineNr6 guifg=#6a6b7a ctermfg=6")
vim.cmd("highlight HighlightedLineNr7 guifg=#57596a ctermfg=2")
vim.cmd("highlight HighlightedLineNr8 guifg=#57596a ctermfg=3")
vim.cmd("highlight HighlightedLineNr9 guifg=#57596a ctermfg=3")

-- Enable line number interval.
vim.cmd("LineNumberIntervalEnable")

require('virt-column').setup()

require('nvim-highlight-colors').setup()

require("luasnip.loaders.from_vscode").lazy_load()

require("nvim-dap-virtual-text").setup()

require('hlargs').setup()

require("bufferline").setup()

require("symbols-outline").setup()

require 'nvim-treesitter.configs'.setup {
  autotag = {
    enable = true,
  }
}

require('bufdel').setup {
  next = 'tabs',
  quit = false, -- quit Neovim when last buffer is closed
}

require('mason-tool-installer').setup {

  -- a list of all tools you want to ensure are installed upon
  -- start
  ensure_installed = {

    -- you can pin a tool to a particular version
    -- { 'golangci-lint', version = 'v1.47.0' },

    -- you can turn off/on auto_update per tool
    -- { 'bash-language-server', auto_update = true },
    'csharpier',
    'debugpy',
    'eslint-lsp',
    'eslint',
    'python-lsp-server',
    'eslint',
    'lua-language-server',
    'lua_ls',
    'netcoredbg',
    'omnisharp',
    'prettier',
    'selene',
    'stylua',
    'typescript-language-server',
    'tsserver',
    'tsserver',
    'bash-language-server',
    'lua-language-server',
    'vim-language-server',
  },

  -- if set to true this will check each tool for updates. If updates
  -- are available the tool will be updated. This setting does not
  -- affect :MasonToolsUpdate or :MasonToolsInstall.
  -- Default: false
  auto_update = true,

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use :MasonToolsInstall or
  -- :MasonToolsUpdate to install tools and check for updates.
  -- Default: true
  run_on_start = true,

  -- set a delay (in ms) before the installation starts. This is only
  -- effective if run_on_start is set to true.
  -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
  -- Default: 0
  start_delay = 3000, -- 3 second delay

  -- Only attempt to install if 'debounce_hours' number of hours has
  -- elapsed since the last time Neovim was started. This stores a
  -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
  -- This is only relevant when you are using 'run_on_start'. It has no
  -- effect when running manually via ':MasonToolsInstall' etc....
  -- Default: nil
  debounce_hours = nil, -- at least 5 hours between attempts to install/update
}

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    side = "right",
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  -- update_focused_file = {
  --   enable = true,
  --   update_root = true
  -- },
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

-- [[ Setting Custom Plugins Keymaps ]]
vim.keymap.set({ "n", "x" }, "<leader>s", function() require("ssr").open() end, { desc = "Structural Replace" })

vim.keymap.set("n", "<leader>a", ":SymbolsOutline<CR>", { desc = "Symbols Outline (Code Aerial View)" })
vim.keymap.set("n", "<leader>p", ":Telescope projects<CR>", { desc = "Projects" })
vim.keymap.set("n", "<leader>P", ":ProjectRoot<CR>", { desc = " Find Project Root Automatically" })
vim.keymap.set("n", "<leader>S", require("auto-session.session-lens").search_session,
  { noremap = true, desc = "Sessions" })

-- create new lines in Normal mode
vim.keymap.set('n', '<leader>o', "o<Esc>^Da<Esc>k", { desc = 'Newline Below', silent = true })
vim.keymap.set('n', '<leader>O', "O<Esc>^Da<Esc>j", { desc = 'Newline Above', silent = true })

-- have to set <C-_> instead of <C-/> for terminal toggle on CTRL-/.
-- same hotkey for leaving terminal as ESC cant be used for vi keybinds in terminal.
vim.keymap.set('n', '<C-_>', '<cmd>ToggleTerm size=15 dir=git_dir direction=horizontal name=TERMINAL<CR>',
  { desc = 'Toggle Terminal', noremap = true })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
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

vim.keymap.set('n', 'zh', 'zH', { desc = 'Scroll right' })
vim.keymap.set('n', 'zl', 'zL', { desc = 'Scroll left' })

vim.keymap.set('n', '<Up>', ':resize -5<CR>', { desc = 'Resize Down' })
vim.keymap.set('n', '<Down>', ':resize +5<CR>', { desc = 'Resize Up' })
vim.keymap.set('n', '<Left>', ':vertical resize +5<CR>', { desc = 'Resize Left' })
vim.keymap.set('n', '<Right>', ':vertical resize -5<CR>', { desc = 'Resize Right' })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set('n', '<leader>j', require('treesj').toggle, { desc = "Toggle Join/Split of Code Block" })

vim.keymap.set('n', '<C-p>', ':BufferLineCyclePrev<CR>', { desc = 'Previous Tab' })
vim.keymap.set('n', '<C-n>', ':BufferLineCycleNext<CR>', { desc = 'Next Tab' })

vim.keymap.set('n', '<leader>TS', '<cmd>Neotest summary toggle<CR>', { desc = '[T]est: [S]ummary toggle' })
vim.keymap.set('n', '<leader>TT', '<cmd>Neotest output toggle<CR>', { desc = '[T]est: Output line toggle' })
vim.keymap.set('n', '<leader>Tt', '<cmd>Neotest output-panel toggle<CR>', { desc = '[T]est: Output panel toggle' })
vim.keymap.set('n', '<leader>Tn', '<cmd>lua require("neotest").run.run()<CR>', { desc = '[T]est: Run [N]earest Test' })
vim.keymap.set('n', '<leader>Tf', '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
  { desc = '[T]est: Run [F]ile' })
vim.keymap.set('n', '<leader>Ta', '<cmd>lua require("neotest").run.attach()<CR>',
  { desc = '[T]est: [A]ttach to nearest [T]est' })
vim.keymap.set('n', '<leader>Tb', '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>',
  { desc = '[T]est: De[b]ug nearest Test' })
vim.keymap.set('n', '<leader>Ts', '<cmd>lua require("neotest").run.stop()<CR>', { desc = '[T]est: [S]top' })

vim.keymap.set('n', '<leader>gdd', ':DiffviewOpen<cr>', { desc = '[G]it [D]iff View' })
vim.keymap.set('n', '<leader>gdo', ':DiffviewOpen ', { desc = '[G]it [D]iff View [O]pen' })
vim.keymap.set('n', '<leader>gdc', ':DiffviewClose<cr>', { desc = '[G]it [D]iff View [C]lose' })
vim.keymap.set('n', '<leader>gg', ':Neogit<cr>', { desc = 'Neo [G]it' })
vim.keymap.set('n', '<leader>gs', ':G status<cr>', { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gl', ':Gclog<cr>', { desc = '[G]it [L]og' })
vim.keymap.set("n", "<leader>gf", ":Flog<CR>", { desc = '[G]it [F]log' })

vim.keymap.set("n", '<leader>e', "<CMD>Oil<CR>", { desc = "[E]dit Filetree with vim keymaps" })
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<cr>', { desc = '[N] Filetree Toggle' })

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


-- paste without overwriting paste register while in visual mode
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
vim.o.timeoutlen = 500

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set('n', '<leader>Q', ':BufDel<CR>', { desc = 'Close Buffer (smart)' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Close Buffer (:q)' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Show diagnostic Error messages' })
vim.keymap.set('n', '<leader>K', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Trouble keymaps
vim.keymap.set("n", "<leader>tt", function() require("trouble").toggle() end, { desc = '[T]rouble [T]oggle' })
vim.keymap.set("n", "<leader>tw", function() require("trouble").toggle("workspace_diagnostics") end,
  { desc = '[T]rouble [W]orkspace Diagnostics' })
vim.keymap.set("n", "<leader>td", function() require("trouble").toggle("document_diagnostics") end,
  { desc = '[T]rouble [D]ocument Diagnostics' })
vim.keymap.set("n", "<leader>tq", function() require("trouble").toggle("quickfix") end, { desc = '[T]rouble [Q]uickfix' })
vim.keymap.set("n", "<leader>tl", function() require("trouble").toggle("loclist") end,
  { desc = '[T]rouble [L]ocation List' })
vim.keymap.set("n", "<leader>tr", function() require("trouble").toggle("lsp_references") end,
  { desc = '[T]rouble LSP [R]eferences' })

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
    path_display = { "truncate" },
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
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').builtin, { desc = '[F]ind Telescope [B]uiltin' })
vim.keymap.set('n', '<leader>fs', ':Telescope luasnip<CR>', { desc = '[F]ind [S]nippets' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = '[F]ind [G]it Files' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>ft', require('telescope.builtin').live_grep, { desc = '[F]ind [T]ext by Grep' })
vim.keymap.set('n', '<leader>fG', ':LiveGrepGitRoot<cr>', { desc = '[F]ind by Grep on [G]it Root' })
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
      'gitignore',
      'markdown',
      'markdown_inline',
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
        scope_incremental = '<M-space>',
        node_decremental = '<backspace>',
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
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>r', vim.lsp.buf.rename, '[R]ename')
  nmap('<leader>C', vim.lsp.buf.code_action, 'Code Action (Builtin LSP)')

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  -- csharp.nvim settings
  if vim.bo.filetype == 'cs' then
    -- replaces vim.lsp.buf.definition()
    vim.keymap.set('n', 'gd', function() require("csharp").go_to_definition() end,
      { buffer = bufnr, desc = '[LSP] OMNI Definition' })

    vim.keymap.set('n', '<leader>Bn', function() require("csharp").debug_project() end,
      { buffer = bufnr, desc = '[B]ug: [DOTNET] Start' })

    vim.keymap.set('n', '<leader>Rn', function() require("csharp").run_project() end,
      { buffer = bufnr, desc = '[R]un: [DOTNET] Run' })
  end

  -- Find references for the word under your cursor.
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  nmap('gD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  nmap('gR', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('<C-s>', function() require('lsp_signature').toggle_float_win() end, 'Signature Documentation')


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
  ['<leader>B'] = { name = '[B]ug', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>gd'] = { name = '[G]it [D]iff', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = '[H]unk Git', _ = 'which_key_ignore' },
  ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]rouble', _ = 'which_key_ignore' },
  ['<leader>T'] = { name = '[T]est', _ = 'which_key_ignore' },
  ['<leader>R'] = { name = '[R]un', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
  ['<leader>D'] = { name = '[D]atabase', _ = 'which_key_ignore' },
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

-- Customize right click contextual menu.
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Disable right contextual menu warning message",
  callback = function()
    -- Disable right click message
    vim.api.nvim_command [[aunmenu PopUp.How-to\ disable\ mouse]]
    -- vim.api.nvim_command [[aunmenu PopUp.-1-]] -- You can remode a separator like this.
    vim.api.nvim_command [[menu PopUp.Toggle\ \Breakpoint <cmd>:lua require('dap').toggle_breakpoint()<CR>]]
    vim.api.nvim_command [[menu PopUp.-2- <Nop>]]
    vim.api.nvim_command [[menu PopUp.Start\ \Compiler <cmd>:CompilerOpen<CR>]]
    vim.api.nvim_command [[menu PopUp.Start\ \Debugger <cmd>:DapContinue<CR>]]
    vim.api.nvim_command [[menu PopUp.Run\ \Test <cmd>:Neotest run<CR>]]
  end,
})

--[[
If you don't know anything about Lua, I recommend taking some time to read through
a guide. One possible example:
- https://learnxinyminutes.com/docs/lua/


And then you can explore or search through `:help lua-guide`
- https://neovim.io/doc/user/lua-guide.html

Uninstall and reinstall repo from git https://github.com/wilfriedbauer/nvim:
# Linux / Macos (unix)
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

# Windows
rd -r ~\AppData\Local\nvim
rd -r ~\AppData\Local\nvim-data

--]]

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
