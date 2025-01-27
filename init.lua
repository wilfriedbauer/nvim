-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_node_provider = 0

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
vim.opt.guicursor = ""

-- Make line numbers default
vim.wo.number = true

-- Windows-specific configurations
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  vim.o.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  vim.o.shellxquote = ""
  vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
  vim.o.shellquote = ""
  vim.o.shellpipe = "| Out-File -Encoding UTF8 %s"
  vim.o.shellredir = "| Out-File -Encoding UTF8 %s"
  -- Set FC as windows diff equivalent to fix undotree, if its broken.
  -- vim.g.undotree_DiffCommand = "FC"
end

-- Unix-specific configurations
-- if vim.fn.has("unix") then
-- end

-- macOS-specific configurations
-- if vim.fn.has("mac") then
-- end

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 50
vim.o.timeoutlen = 500

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- enable relative line numbers next to absolute line numbers.
-- vim.opt.relativenumber = true
-- vim.o.statuscolumn = "%s %l %=%r "

-- -- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  -- eol = '↵',
}

-- Show which line your cursor is on
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.cursorcolumn = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.inccommand = "split"
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.textwidth = 0
vim.opt.wrapmargin = 0
vim.opt.breakindent = true
vim.opt.showbreak = string.rep(" ", 2) .. "↪  " -- Make it so that long lines wrap smartly
vim.opt.linebreak = true
vim.opt.wrap = true

vim.opt.smartindent = true
vim.opt.jumpoptions = "stack,view"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set({ "n", "x", "o" }, "H", "^")
vim.keymap.set({ "n", "x", "o" }, "L", "$")

vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 5

vim.opt.colorcolumn = ""

-- auto-session.nvim
vim.o.sessionoptions = "blank,buffers,tabpages,curdir,help,localoptions,winsize,winpos,terminal"

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
local ns = vim.api.nvim_create_namespace("severe-diagnostics")

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "checkhealth",
    "fugitive*",
    "git",
    "help",
    "lspinfo",
    "netrw",
    "notify",
    "qf",
    "query",
  },
  callback = function()
    vim.keymap.set("n", "q", vim.cmd.close, { desc = "Close the current buffer", buffer = true })
  end,
})

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- move visual selection up or down a line with <s-j> and <s-k>
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- INFO:
-- Instead of pressing ^ you can press _(underscore) to jump to the first non-whitespace character on the same line the cursor is on.
-- + and - jump to the first non-whitespace character on the next / previous line.
-- (These commands only work in normal mode, not in insert mode.)
--
-- In visual mode press 'o' to switch the side of the selection the cursor is on.

-- paste without overwriting paste register while in visual mode
vim.keymap.set("v", "p", '"_dP')

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Install `lazy.nvim` plugin manager ]]
-- https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
-- You can configure plugins using the `config` key.
--
-- You can also configure plugins after the setup call,
-- as they will be available in your neovim runtime.
require("lazy").setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  {
    "tpope/vim-fugitive",
    event = "BufEnter",
    config = function()
      vim.api.nvim_create_user_command("Browse", function(args)
        vim.ui.open(args.args)
      end, {
        desc = "Enables using GBrowse without netrw",
        force = true,
        nargs = 1,
      })
    end,
  },
  {
    "tpope/vim-rhubarb",
    event = "BufEnter",
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose" },
    keys = {
      {
        "<leader>gdd",
        ":DiffviewOpen<cr>",
        mode = "",
        desc = "[G]it [D]iff View",
      },
      {
        "<leader>gdo",
        ":DiffviewOpen ",
        mode = "",
        desc = "[G]it [D]iff View [O]pen",
      },
      {
        "<leader>gdc",
        ":DiffviewClose<cr>",
        mode = "",
        desc = "[G]it [D]iff View [C]lose",
      },
    },
  },

  -- Detect tabstop and shiftwidth automatically
  {
    "tpope/vim-sleuth",
    event = "BufEnter",
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    event = "BufEnter",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        "j-hui/fidget.nvim",
        event = "UIEnter",
        opts = {
          -- display = {
          --   render_limit = 5, -- How many LSP messages to show at once
          --   done_ttl = 1,
          --   progress_ttl = 3,
          -- },
          notification = {
            poll_rate = 10, -- How frequently to update and render notifications
            override_vim_notify = false,
            -- Options related to the notification window and buffer
            window = {
              normal_hl = "Comment", -- Base highlight group in the notification window
              winblend = 0, -- Background color opacity in the notification window
              border = "none", -- Border around the notification window
              zindex = 45, -- Stacking priority of the notification window
              max_width = 0, -- Maximum width of the notification window
              max_height = 0, -- Maximum height of the notification window
              x_padding = 1, -- Padding from right edge of window boundary
              y_padding = 0, -- Padding from bottom edge of window boundary
              align = "bottom", -- How to align the notification window
              relative = "editor", -- What the notification window position is relative to
            },
          },
          integration = {
            ["nvim-tree"] = {
              enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
            },
          },
        },
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
  },

  -- [[ Configure nvim-cmp ]]
  -- See `:help cmp`
  {
    "hrsh7th/nvim-cmp",
    event = "UIEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "max397574/cmp-greek",
      "chrisgrieser/cmp-nerdfont",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "xzbdmw/colorful-menu.nvim",
      {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
        opts = {
          fast_wrap = {
            map = "<C-e>",
          },
        },
      },
      "onsails/lspkind-nvim",
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    config = function()
      local cmp = require("cmp")
      local lsp_kind = require("lspkind")
      local cmp_next = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(
            vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
            ""
          )
        else
          fallback()
        end
      end
      local cmp_prev = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
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
          completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None",
          }),
        },
        ---@diagnostic disable-next-line
        view = {
          entries = "bordered",
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local highlights_info = require("colorful-menu").cmp_highlights(entry)

            -- if highlight_info==nil, which means missing ts parser, let's fallback to use default `vim_item.abbr`.
            -- What this plugin offers is two fields: `vim_item.abbr_hl_group` and `vim_item.abbr`.
            if highlights_info ~= nil then
              vim_item.abbr_hl_group = highlights_info.highlights
              vim_item.abbr = highlights_info.text
            end

            local kind = require("lspkind").cmp_format({
              mode = "symbol_text",
              maxwidth = 50,
            })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "" --[[ "    (" .. (strings[2] or "") .. ")" ]]

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
          ["<up>"] = cmp_prev,
          ["<C-p>"] = cmp_prev,
          ["<C-k>"] = cmp_prev,
        },
        sources = {
          { name = "nvim_lsp_signature_help", group_index = 1 },
          { name = "luasnip", group_index = 3 },
          { name = "nvim_lsp", group_index = 1 },
          { name = "nvim_lua", group_index = 2 },
          { name = "path", group_index = 2 },
          { name = "buffer", group_index = 2, keyword_length = 2 },
          { name = "calc", group_index = 2, max_item_count = 5 },
          { name = "emoji", group_index = 2, max_item_count = 5 },
          { name = "nerdfont", group_index = 2, max_item_count = 5 },
          { name = "greek", group_index = 2, max_item_count = 5 },
        },
      })
      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
      local presentAutopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      if not presentAutopairs then
        return
      end
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
    end,
  },
  -- Useful plugin to show you pending keybinds.
  {
    "folke/which-key.nvim",
    event = "UIEnter",
    opts = {
      -- false | "classic" | "modern" | "helix"
      preset = "modern",
      --- Mappings are sorted using configured sorters and natural sort of the keys
      --- Available sorters:
      --- * local: buffer-local mappings first
      --- * order: order of the items (Used by plugins like marks / registers)
      --- * group: groups last
      --- * alphanum: alpha-numerical first
      --- * mod: special modifier keys last
      --- * manual: the order the mappings were added
      --- * case: lower-case first
      sort = {
        "group",
        "alphanum",
        "mod",
      },
    },
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ "n", "v" }, "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Jump to next hunk" })

        map({ "n", "v" }, "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Jump to previous hunk" })

        -- Actions
        -- visual mode
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "stage git hunk" })
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "reset git hunk" })
        -- normal mode
        map("n", "<leader>hs", gs.stage_hunk, { desc = "git stage hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "git reset hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "git Stage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "git Reset buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "preview git hunk" })
        map("n", "<leader>hb", function()
          gs.blame_line({ full = false })
        end, { desc = "git blame line" })
        map("n", "<leader>hd", gs.diffthis, { desc = "git diff against index" })
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, { desc = "git diff against last commit" })

        -- Toggles
        map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
        map("n", "<leader>gD", gs.toggle_deleted, { desc = "toggle git show deleted" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          diffview = true,
          fidget = true,
          mason = true,
          neotest = true,
          nvim_surround = true,
          lsp_trouble = true,
          which_key = true,
        },
      })
      vim.cmd([[colorscheme catppuccin-mocha]])
    end,
  },
  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    -- See `:help lualine.txt`
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "meuter/lualine-so-fancy.nvim",
    },
    opts = {
      options = {
        icons_enabled = true,
        theme = "catppuccin",
        component_separators = "|",
        section_separators = { left = "", right = "" },
        globalstatus = true,
        refresh = {
          statusline = 100,
        },
      },
      sections = {
        lualine_a = {
          { "fancy_mode", width = 1 },
        },
        lualine_b = {
          { "fancy_branch" },
          { "fancy_diff" },
        },
        lualine_c = {
          { "fancy_cwd", substitute_home = true },
        },
        lualine_x = {
          { "fancy_macro" },
          { "fancy_diagnostics" },
          { "fancy_searchcount" },
          { "fancy_location" },
        },
        lualine_y = {
          { "fancy_filetype", ts_icon = "" },
        },
        lualine_z = {
          { "fancy_lsp_servers" },
        },
      },
      -- tabline = {
      --   lualine_a = { 'buffers' },
      --   lualine_b = {},
      --   lualine_c = {},
      --   lualine_x = {},
      --   lualine_y = {},
      --   lualine_z = { 'tabs' }
      -- }
    },
  },
  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = "ibl",
    opts = {},
  },
  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    event = "UIEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    event = "UIEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
  },
  {
    -- Use your language server to automatically format your code on save.
    -- Adds additional commands as well to manage the behavior
    "neovim/nvim-lspconfig",
    event = "BufEnter",
    config = function()
      -- Switch for controlling whether you want autoformatting.
      -- Use :FormatToggle to toggle autoformatting on or off
      local format_is_enabled = false
      vim.api.nvim_create_user_command("FormatToggle", function()
        format_is_enabled = not format_is_enabled
        print("Setting autoformatting to: " .. tostring(format_is_enabled))
      end, {})

      -- Create an augroup that is used for managing our formatting autocmds.
      -- We need one augroup per client to make sure that multiple clients
      -- can attach to the same buffer without interfering with each other.
      local _augroups = {}
      local get_augroup = function(client)
        if not _augroups[client.id] then
          local group_name = "kickstart-lsp-format-" .. client.name
          local id = vim.api.nvim_create_augroup(group_name, { clear = true })
          _augroups[client.id] = id
        end

        return _augroups[client.id]
      end

      -- Whenever an LSP attaches to a buffer, we will run this function.
      -- See `:help LspAttach` for more information about this autocmd event.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach-format", { clear = true }),
        -- This is where we attach the autoformatting for reasonable clients
        callback = function(args)
          local client_id = args.data.client_id
          local client = vim.lsp.get_client_by_id(client_id)
          local bufnr = args.buf

          if client.server_capabilities.inlayHintProvider then
            vim.g.inlay_hints_visible = true
            vim.lsp.inlay_hint.enable(false)
          end

          -- if client.server_capabilities.codeLensProvider then
          --   vim.lsp.codelens.display(vim.lsp.codelens.get(0), 0, client_id)
          --   vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
          --     buffer = bufnr,
          --     callback = function()
          --       vim.lsp.codelens.refresh({ buffer = bufnr, client = client })
          --     end,
          --   })
          -- end

          -- Only attach to clients that support document formatting
          if not client.server_capabilities.documentFormattingProvider then
            return
          end

          -- Create an autocmd that will run *before* we save the buffer.
          -- Run the formatting command for the LSP that has just attached.
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = get_augroup(client),
            buffer = bufnr,
            callback = function(args)
              if not format_is_enabled then
                return
              end

              require("conform").format({ bufnr = args.buf, async = false, lsp_fallback = true })
              vim.cmd("retab")

              -- vim.lsp.buf.format({
              --  async = false,
              --  filter = function(c)
              --    return c.id == client.id
              --  end,
              -- })
            end,
          })
        end,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    -- NOTE: And you can specify dependencies as well
    dependencies = {
      -- Creates a beautiful debugger UI
      "rcarriga/nvim-dap-ui",

      -- Installs the debug adapters for you
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup()
        end,
      },

      -- Add your own debuggers here
    },
    keys = {
      {
        "<leader>BC",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Start/Continue",
      },
      {
        "<leader>BI",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },
      {
        "<leader>BO",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over",
      },
      {
        "<leader>BU",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },
      {
        "<leader>BP",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Code Debug: Toggle Breakpoint",
      },
      {
        "<leader>Bp",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Code Debug: Set conditional Breakpoint",
      },
      {
        "<leader>BB",
        function()
          require("dapui").toggle()
        end,
        desc = "Debug: See last session result.",
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        desc = "Prevent colorscheme clearing self-defined DAP marker colors",
        callback = function()
          -- Reuse current SignColumn background (except for DapStoppedLine)
          local sign_column_hl = vim.api.nvim_get_hl(0, { name = "SignColumn" })
          -- if bg or ctermbg aren't found, use bg = 'bg' (which means current Normal) and ctermbg = 'Black'
          -- convert to 6 digit hex value starting with #
          local sign_column_bg = (sign_column_hl.bg ~= nil) and ("#%06x"):format(sign_column_hl.bg) or "bg"
          local sign_column_ctermbg = (sign_column_hl.ctermbg ~= nil) and sign_column_hl.ctermbg or "Black"

          vim.api.nvim_set_hl(
            0,
            "DapStopped",
            { fg = "#00ff00", bg = sign_column_bg, ctermbg = sign_column_ctermbg }
          )
          vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d3d", ctermbg = "Green" })
          vim.api.nvim_set_hl(
            0,
            "DapBreakpoint",
            { fg = "#c23127", bg = sign_column_bg, ctermbg = sign_column_ctermbg }
          )
          vim.api.nvim_set_hl(
            0,
            "DapBreakpointRejected",
            { fg = "#888ca6", bg = sign_column_bg, ctermbg = sign_column_ctermbg }
          )
          vim.api.nvim_set_hl(
            0,
            "DapLogPoint",
            { fg = "#61afef", bg = sign_column_bg, ctermbg = sign_column_ctermbg }
          )
        end,
      })

      -- reload current color scheme to pick up colors override if it was set up in a lazy plugin definition fashion
      vim.cmd.colorscheme(vim.g.colors_name)

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped" })

      local dap = require("dap")
      local dapui = require("dapui")

      require("mason").setup()
      require("mason-nvim-dap").setup({
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_setup = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          "netcoredbg",
          -- Update this to ensure that you have the debuggers for the langs you want
          --'delve',
        },
      })
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

      -- -- Basic debugging keymaps, feel free to change to your liking!
      -- vim.keymap.set("n", "<leader>BC", dap.continue, { desc = "[B]ug: Start/[C]ontinue" })
      -- vim.keymap.set("n", "<leader>BI", dap.step_into, { desc = "[B]ug: Step [I]nto" })
      -- vim.keymap.set("n", "<leader>BO", dap.step_over, { desc = "[B]ug: Step [O]ver" })
      -- vim.keymap.set("n", "<leader>BU", dap.step_out, { desc = "[B]ug: Step O[u]t" })
      -- vim.keymap.set("n", "<leader>BP", dap.toggle_breakpoint, { desc = "[B]ug: Toggle Break[P]oint" })
      -- vim.keymap.set("n", "<leader>Bp", function()
      --   dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      -- end, { desc = "[B]ug: Set conditional Break[p]oint" })

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup({
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      })

      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      -- vim.keymap.set("n", "<leader>BB", dapui.toggle, { desc = "De[b]ug: Toggle UI" })

      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
    end,
  },
  {
    "ryanoasis/vim-devicons",
    event = "UIEnter",
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle<cr>",
        mode = "",
        desc = "[T]rouble [T]oggle",
      },
      {
        "<leader>ts",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        mode = "",
        desc = "[T]rouble [S]ymbols",
      },
      {
        "<leader>td",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        mode = "",
        desc = "[T]rouble [D]ocument Diagnostics",
      },
      {
        "<leader>tq",
        "<cmd>Trouble qflist toggle<cr>",
        mode = "",
        desc = "[T]rouble [Q]uickfix",
      },
      {
        "<leader>tl",
        "<cmd>Trouble loclist toggle<cr>",
        mode = "",
        desc = "[T]rouble [L]ocation List",
      },
      {
        "<leader>tr",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        mode = "",
        desc = "[T]rouble LSP [R]eferences",
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "BufEnter",
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
    end,
  },
  {
    "andymass/vim-matchup",
    lazy = false,
    config = function()
      vim.g.loaded_matchit = 1
    end,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufEnter",
    config = function()
      require("nvim-highlight-colors").setup()
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    event = "UIEnter",
    config = function()
      local colors = require("catppuccin.palettes").get_palette("mocha")

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
    end,
  },
  {
    "mbbill/undotree",
    keys = {
      {
        "<leader>u",
        vim.cmd.UndotreeToggle,
        mode = "",
        desc = "[U]ndotree Toggle",
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    -- follow latest release.
    version = "*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  {
    "benfowler/telescope-luasnip.nvim",
    event = "BufEnter",
  },
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      {
        "<leader>n",
        ":NvimTreeToggle<cr>",
        mode = "",
        desc = "[N] Filetree Toggle",
      },
    },
    config = function()
      local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function edit_or_open()
          local node = api.tree.get_node_under_cursor()

          if node.nodes ~= nil then
            -- expand or collapse folder
            api.node.open.edit()
          else
            -- open file
            api.node.open.edit()
            -- Close the tree if file was opened
            api.tree.close()
          end
        end

        -- open as vsplit on current node
        local function vsplit_preview()
          local node = api.tree.get_node_under_cursor()

          if node.nodes ~= nil then
            -- expand or collapse folder
            api.node.open.edit()
          else
            -- open file as vsplit
            api.node.open.vertical()
          end

          -- Finally refocus on tree if it was lost
          api.tree.focus()
        end

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- on_attach
        vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
        vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
        vim.keymap.set("n", "h", api.tree.close, opts("Close"))
        vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
      end

      -- vim.g.loaded_netrw = 1
      -- vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        on_attach = my_on_attach,
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          side = "right",
          preserve_window_proportions = true,
        },
        actions = {
          open_file = {
            resize_window = false,
          },
        },
        renderer = {
          group_empty = true,
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = true,
          debounce_delay = 50,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = false,
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufEnter",
    config = function()
      vim.cmd("TSContextDisable")
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "BufEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = true, -- Auto close on trailing </
        },
      })
    end,
  },
  {
    "rachartier/tiny-code-action.nvim",
    event = "LspAttach",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("tiny-code-action").setup()

      vim.keymap.set("n", "<leader>c", function()
        require("tiny-code-action").code_action()
      end, { desc = "LSP: Code Action (Preview)", noremap = true, silent = true })
    end,
  },
  {
    "zegervdv/nrpattern.nvim",
    event = "BufEnter",
    config = function()
      -- Basic setup
      -- See below for more options
      require("nrpattern").setup()
    end,
  },
  {
    "isakbm/gitgraph.nvim",
    ---@type I.GGConfig
    opts = {
      symbols = {
        merge_commit = "M",
        commit = "*",
      },
      format = {
        timestamp = "%H:%M:%S %d-%m-%Y",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        -- Check diff of a commit
        on_select_commit = function(commit)
          vim.notify("DiffviewOpen " .. commit.hash .. "^!")
          vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
        end,
        -- Check diff from commit a -> commit b
        on_select_range_commit = function(from, to)
          vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
          vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        end,
      },
    },
    keys = {
      {
        "<leader>gg",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph - Draw",
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    end,
  },
  {
    "Wansmer/treesj",
    event = "BufEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        --@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
        use_default_keymaps = false,
        max_join_length = 1000,
      })
      vim.keymap.set("n", "<leader>j", require("treesj").toggle, { desc = "Toggle Join/Split of Code Block" })
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    lazy = false,
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        segments = {
          {
            sign = {
              namespace = { "diagnostic/signs" },
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
    "kevinhwang91/nvim-ufo",
    event = "UIEnter",
    dependencies = {
      "kevinhwang91/promise-async",
      "luukvbaal/statuscol.nvim",
    },
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      require("ufo").setup({
        fold_virt_text_handler = handler,
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
      })
      vim.keymap.set("n", "zo", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "zO", require("ufo").openAllFolds)
      vim.keymap.set("n", "zc", require("ufo").closeFoldsWith)
      vim.keymap.set("n", "zC", require("ufo").closeAllFolds)
      -- ufo.nvim
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
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
    },
    keys = {
      {
        "<leader>TS",
        "<cmd>Neotest summary toggle<CR>",
        mode = "",
        desc = "[T]est: [S]ummary toggle",
      },
      {
        "<leader>Tt",
        "<cmd>Neotest output toggle<CR>",
        mode = "",
        desc = "[T]est: Output line toggle",
      },
      {
        "<leader>TT",
        "<cmd>Neotest output-panel toggle<CR>",
        mode = "",
        desc = "[T]est: Output panel toggle",
      },
      {
        "<leader>TN",
        '<cmd>lua require("neotest").run.run()<CR>',
        mode = "",
        desc = "[T]est: Run [N]earest Test",
      },
      {
        "<leader>TF",
        '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
        mode = "",
        desc = "[T]est: Run [F]ile",
      },
      {
        "<leader>TA",
        '<cmd>lua require("neotest").run.attach()<CR>',
        mode = "",
        desc = "[T]est: [A]ttach to nearest [T]est",
      },
      {
        "<leader>TB",
        '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>',
        mode = "",
        desc = "[T]est: De[b]ug nearest Test",
      },
      {
        "<leader>Ts",
        '<cmd>lua require("neotest").run.stop()<CR>',
        mode = "",
        desc = "[T]est: [S]top",
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-dotnet")({
            dap = {
              -- Extra arguments for nvim-dap configuration
              -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
              args = { justMyCode = false },
              -- Enter the name of your dap adapter, the default value is netcoredbg
              adapter_name = "netcoredbg",
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
              "--verbosity detailed",
            },
            -- Tell neotest-dotnet to use either solution (requires .sln file) or project (requires .csproj or .fsproj file) as project root
            -- Note: If neovim is opened from the solution root, using the 'project' setting may sometimes find all nested projects, however,
            --       to locate all test projects in the solution more reliably (if a .sln file is present) then 'solution' is better.
            discovery_root = "project", -- Default
          }),
        },
      })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    event = "BufEnter",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "cshuaimin/ssr.nvim",
    event = "BufEnter",
    config = function()
      vim.keymap.set({ "n", "x" }, "<leader>s", function()
        require("ssr").open()
      end, { desc = "Structural Replace" })
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    event = "UIEnter",
    config = function()
      require("project_nvim").setup({
        manual_mode = true,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      local function change_nvim_tree_dir()
        local nvim_tree = require("nvim-tree")
        nvim_tree.change_dir(vim.fn.getcwd())
      end

      require("auto-session").setup({
        log_level = "error",
        auto_restore = true,
        post_restore_cmds = {
          change_nvim_tree_dir,
          -- "ProjectRoot",
        },
        pre_save_cmds = { "NvimTreeClose" },
      })
    end,
  },
  {
    "ojroques/nvim-bufdel",
    event = "UIEnter",
    config = function()
      require("bufdel").setup({
        next = "tabs",
        quit = false, -- quit Neovim when last buffer is closed
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({

        -- a list of all tools you want to ensure are installed upon
        -- start
        ensure_installed = {

          -- you can pin a tool to a particular version
          -- { 'golangci-lint', version = 'v1.47.0' },

          -- you can turn off/on auto_update per tool
          -- { 'bash-language-server', auto_update = true },
          "debugpy",
          "python-lsp-server",
          "lua-language-server",
          "angular-language-server",
          "csharpier",
          "omnisharp",
          "netcoredbg",
          "clangd",
          "typescript-language-server",
          "bash-language-server",
          "lua-language-server",
          "vim-language-server",
          "stylua",
          "isort",
          "black",
          "prettierd",
          "prettier",
          "shfmt",
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
        debounce_hours = 5, -- at least 5 hours between attempts to install/update
      })
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufEnter",
  },
  {
    "stevearc/oil.nvim",
    event = "UIEnter",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
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
          add = function()
            return true
          end,
          mv = function()
            return true
          end,
          rm = function()
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
      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "[E]dit Filetree with vim keymaps" })
    end,
  },
  {
    "arsham/indent-tools.nvim",
    event = "UIEnter",
    dependencies = {
      "arsham/arshlib.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = true,
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "catppuccin",
    },
    config = function()
      require("bufferline").setup({
        highlights = require("catppuccin.groups.integrations.bufferline").get(),
        options = {
          themable = false,
          indicator = {
            style = "underline",
          },
          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          diagnostics = "nvim_lsp",
          -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = " Files:",
              -- text = function()
              --   return vim.fn.getcwd()
              -- end,
              text_align = "left",
              separator = true,
            },
          },
          separator_style = "slant",
        },
      })
      vim.keymap.set("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", { desc = "Go to Buffer 1" })
      vim.keymap.set("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", { desc = "Go to Buffer 2" })
      vim.keymap.set("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", { desc = "Go to Buffer 3" })
      vim.keymap.set("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", { desc = "Go to Buffer 4" })
      vim.keymap.set("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", { desc = "Go to Buffer 5" })
      vim.keymap.set("n", "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", { desc = "Go to Buffer 6" })
      vim.keymap.set("n", "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", { desc = "Go to Buffer 7" })
      vim.keymap.set("n", "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", { desc = "Go to Buffer 8" })
      vim.keymap.set("n", "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", { desc = "Go to Buffer 9" })
      vim.keymap.set(
        "n",
        "<leader>$",
        "<Cmd>BufferLineGoToBuffer -1<CR>",
        { desc = "Go to last Buffer (<leader>number -> switch to buffer)" }
      )
    end,
  },
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    event = "UIEnter",
    config = function()
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = { "*.cs" },
        callback = function()
          vim.keymap.set("n", "gd", function()
            require("omnisharp_extended").telescope_lsp_definition()
          end, { desc = "[LSP] Omnisharp go to Definition", buffer = true })
          vim.keymap.set("n", "gD", function()
            require("omnisharp_extended").telescope_lsp_type_definition()
          end, { desc = "[LSP] Omnisharp go to Type Definition", buffer = true })
          vim.keymap.set("n", "gr", function()
            require("omnisharp_extended").telescope_lsp_references()
          end, { desc = "[LSP] Omnisharp go to References", buffer = true })
          vim.keymap.set("n", "gI", function()
            require("omnisharp_extended").telescope_lsp_implementation()
          end, { desc = "[LSP] Omnisharp go to Implementation", buffer = true })
        end,
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "BufEnter",
    opts = {},
  },
  { -- Autoformat
    "stevearc/conform.nvim",
    event = "BufEnter",
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format({ async = false, lsp_fallback = true })
          vim.cmd("retab")
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      stop_after_first = true,
      format_on_save = nil,
      -- format_on_save = function(bufnr)
      --   -- Disable "format_on_save lsp_fallback" for languages that don't
      --   -- have a well standardized coding style. You can add additional
      --   -- languages here or re-enable it for the disabled ones.
      --   local disable_filetypes = { --[[  c = true, cpp = true  ]]
      --   }
      --   return {
      --     timeout_ms = 500,
      --     lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      --   }
      -- end,
      formatters_by_ft = {
        lua = { "stylua" },
        csharp = { "csharpier" },

        -- Conform can also run multiple formatters sequentially
        python = { "isort", "black" },

        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        javascript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        graphql = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        sh = { "shfmt" },
      },
    },
  },
}, {})

require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set("n", "<leader>l", function()
  vim.o.relativenumber = not vim.o.relativenumber
  print("Relative Numbers Enabled: ", vim.o.relativenumber)
end, { desc = "Toggle Relative Line Numbers" })

vim.keymap.set("n", "<leader>i", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  print("InlayHint Enabled: ", vim.lsp.inlay_hint.is_enabled())
end, { desc = "Inlay Hints Toggle" })

vim.keymap.set("n", "<leader>L", function()
  vim.lsp.codelens.refresh()
  vim.lsp.codelens.run()
end, { desc = "Codelens Toggle" })

-- [[ Terminal ]]:
local te_buf = nil
local te_win_id = nil

local v = vim
local fun = v.fn
local cmd = v.api.nvim_command
local gotoid = fun.win_gotoid
local getid = fun.win_getid

local function openTerminal()
  if fun.bufexists(te_buf) ~= 1 then
    cmd("au TermOpen * setlocal nonumber norelativenumber signcolumn=no")
    cmd("sp | winc J | res 10 | te")
    te_win_id = getid()
    te_buf = fun.bufnr("%")
  elseif gotoid(te_win_id) ~= 1 then
    cmd("sb " .. te_buf .. "| winc J | res 10")
    te_win_id = getid()
  end
  cmd("startinsert")
end

local function hideTerminal()
  if gotoid(te_win_id) == 1 then
    cmd("hide")
  end
end

function ToggleTerminal()
  if gotoid(te_win_id) == 1 then
    hideTerminal()
  else
    openTerminal()
  end
end

-- have to set <C-_> instead of <C-/> for terminal toggle on CTRL-/.
-- same hotkey for leaving terminal as ESC cant be used for vi keybinds in terminal.
vim.keymap.set("n", "<C-_>", function()
  ToggleTerminal()
end, { desc = "Toggle Terminal", noremap = true })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<C-_>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_visible then
    vim.g.diagnostics_visible = false
    vim.diagnostic.enable(false)
  else
    vim.g.diagnostics_visible = true
    vim.diagnostic.enable()
  end
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>dH",
  ":call v:lua.toggle_diagnostics()<CR>",
  { desc = "[D]iagnostics - Toggle [H]ide all Diagnostics", noremap = true, silent = true }
)

vim.g.virtual_text_visible = true
function _G.toggle_virtual_text()
  if vim.g.virtual_text_visible then
    vim.g.virtual_text_visible = false
    vim.diagnostic.config({ virtual_text = false })
  else
    vim.g.virtual_text_visible = true
    vim.diagnostic.config({ virtual_text = true })
  end
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>dh",
  ":call v:lua.toggle_virtual_text()<CR>",
  { desc = "[D]iagnostics - Toggle [H]ide Virtual Text", noremap = true, silent = true }
)

vim.keymap.set("n", "<leader>P", ":Telescope projects<CR>", { desc = "Projects" })
vim.keymap.set(
  "n",
  "<leader>p",
  ":cd %:p:h<CR> :ProjectRoot<CR> :pwd<CR>",
  { desc = "Find Project Root Automatically" }
)
vim.keymap.set(
  "n",
  "<leader>S",
  require("auto-session.session-lens").search_session,
  { noremap = true, desc = "Sessions" }
)

-- create new lines in Normal mode
vim.keymap.set("n", "<leader>o", "m`o<Esc>^Da<Esc>``", { desc = "Newline Below", silent = true })
vim.keymap.set("n", "<leader>O", "m`O<Esc>^Da<Esc>``", { desc = "Newline Above", silent = true })

vim.keymap.set("n", "zh", "zH", { desc = "Scroll right" })
vim.keymap.set("n", "zl", "zL", { desc = "Scroll left" })

vim.keymap.set("n", "<Up>", "<cmd>resize -5<CR>", { desc = "Resize Down" })
vim.keymap.set("n", "<Down>", "<cmd>resize +5<CR>", { desc = "Resize Up" })
vim.keymap.set("n", "<Left>", "<cmd>vertical resize +5<CR>", { desc = "Resize Left" })
vim.keymap.set("n", "<Right>", "<cmd>vertical resize -5<CR>", { desc = "Resize Right" })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<leader>gs", "<cmd>G status<cr>", { desc = "[G]it [S]tatus" })
vim.keymap.set("n", "<leader>gl", "<cmd>Gclog<cr>", { desc = "[G]it [L]og" })

vim.keymap.set("n", "<c-p>", "<cmd>bp<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<c-n>", "<cmd>bn<cr>", { desc = "Next Buffer" })

vim.keymap.set("n", "<leader>Q", "<cmd>BufDel<CR>", { desc = "Close Buffer (smart)" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Close Buffer (:q)" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, { desc = "Show diagnostic Error messages" })
vim.keymap.set("n", "<leader>K", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

--- IDE Jump Keymaps for Neovim
-- Function to get the current buffer's file path and line number
local function get_current_file_info()
  local file_path = vim.fn.expand("%:p")
  local line_number = vim.fn.line(".")
  return file_path, line_number
end

-- Jump to VSCode at the same file and line
function JumpToVSCode()
  local file_path, line_number = get_current_file_info()
  local command = string.format('code --goto "%s":%d', file_path, line_number)
  os.execute(command)
end

-- Jump to Visual Studio at the same file and line
function JumpToVisualStudio()
  local file_path, line_number = get_current_file_info()
  local command = string.format("start devenv /Edit %s", file_path)
  os.execute(command)
end

-- Keymaps
vim.keymap.set("n", "<leader>x", JumpToVSCode, { noremap = true, silent = true, desc = "Open current file in VSCode" })

vim.keymap.set(
  "n",
  "<leader>X",
  JumpToVisualStudio,
  { noremap = true, silent = true, desc = "Open current file in Visual Studio" }
)

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
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
    path_display = { "filename_first", "truncate" },
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
        ["<c-f>"] = require("telescope.actions").to_fuzzy_refine,
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<C-k>"] = require("telescope.actions").move_selection_previous,
        ["<C-n>"] = require("telescope.actions").cycle_history_next,
        ["<C-p>"] = require("telescope.actions").cycle_history_prev,
      },
      -- for normal mode
      n = {
        ["<c-f>"] = require("telescope.actions").to_fuzzy_refine,
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<C-k>"] = require("telescope.actions").move_selection_previous,
        ["<C-n>"] = require("telescope.actions").cycle_history_next,
        ["<C-p>"] = require("telescope.actions").cycle_history_prev,
        ["q"] = require("telescope.actions").close,
      },
    },
  },
})
pcall(require("telescope").load_extension("luasnip"))

-- Set telescope Highlights. Something like NVChad.
local colors = require("catppuccin.palettes").get_palette()
local TelescopeColor = {
  TelescopeMatching = { fg = colors.red },
  TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },

  TelescopePromptPrefix = { bg = colors.surface0 },
  TelescopePromptNormal = { bg = colors.surface0 },
  TelescopeResultsNormal = { bg = colors.mantle },
  TelescopePreviewNormal = { bg = colors.mantle },
  TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
  TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
  TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
  TelescopePromptTitle = { bg = colors.red, fg = colors.mantle },
  TelescopeResultsTitle = { fg = colors.mantle },
  TelescopePreviewTitle = { bg = colors.blue, fg = colors.mantle },
}

for hl, col in pairs(TelescopeColor) do
  vim.api.nvim_set_hl(0, hl, col)
end

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require("telescope.builtin").live_grep({
      search_dirs = { git_root },
    })
  end
end

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set(
  "n",
  "<leader>/",
  require("telescope.builtin").current_buffer_fuzzy_find,
  { desc = "[/] Fuzzily search in current buffer" }
)

local function telescope_live_grep_open_files()
  require("telescope.builtin").live_grep({
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  })
end
vim.keymap.set("n", "<leader>f/", telescope_live_grep_open_files, { desc = "[F]ind [/] in Open Files" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").builtin, { desc = "[F]ind Telescope [B]uiltin" })
vim.keymap.set("n", "<leader>fs", ":Telescope luasnip<CR>", { desc = "[F]ind [S]nippets" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").git_files, { desc = "[F]ind [G]it Files" })
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>ft", require("telescope.builtin").live_grep, { desc = "[F]ind [T]ext by Grep" })
vim.keymap.set("n", "<leader>fG", ":LiveGrepGitRoot<cr>", { desc = "[F]ind by Grep on [G]it Root" })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fr", require("telescope.builtin").resume, { desc = "[F]ind [R]esume Last Search" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require("nvim-treesitter.configs").setup({
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      "c",
      "cpp",
      "c_sharp",
      "go",
      "lua",
      "python",
      "tsx",
      "http",
      "json",
      "json5",
      "html",
      "scss",
      "yaml",
      "xml",
      "sql",
      "diff",
      "dockerfile",
      "terraform",
      "angular",
      "javascript",
      "typescript",
      "vimdoc",
      "vim",
      "bash",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "markdown",
      "markdown_inline",
    },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,

    matchup = {
      enable = true, -- mandatory, false will disable the whole extension
    },

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<leader>v",
        node_incremental = "<leader>v",
        scope_incremental = "<leader>V",
        node_decremental = "<backspace>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]{"] = "@class.outer",
        },
        goto_next_end = {
          ["]F"] = "@function.outer",
          ["]}"] = "@class.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[{"] = "@class.outer",
        },
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[}"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>>"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader><lt>"] = "@parameter.inner",
        },
      },
    },
  })
end, 0)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>r", vim.lsp.buf.rename, "[R]ename")

  nmap("<leader>C", vim.lsp.buf.code_action, "Code Action (Builtin LSP)")

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

  -- Find references for the word under your cursor.
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  nmap("gD", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  nmap("gR", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

  nmap("<C-s>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Standard Neovim Mappings:
  -- nmap("gR", function() vim.lsp.buf.declaration() end, "Declaration")
  -- nmap("gd", function() vim.lsp.buf.definition() end, "Definition")
  -- nmap("gr", function() vim.lsp.buf.references() end, "References")
  -- nmap("gI", function() vim.lsp.buf.implementation() end, "Implementation")
  -- nmap("gD", function() vim.lsp.buf.type_definition() end, "Type Definition")

  -- Lesser used LSP functionality
  nmap("<leader>wd", require("telescope.builtin").lsp_document_symbols, "[D]ocument Symbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    require("conform").format({ async = false, lsp_fallback = true })
    vim.cmd("retab")
    -- vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

require("which-key").add({
  { "<leader>B", group = "[B]ug" },
  { "<leader>B_", hidden = true },
  { "<leader>R", group = "[R]un" },
  { "<leader>R_", hidden = true },
  { "<leader>T", group = "[T]est" },
  { "<leader>T_", hidden = true },
  { "<leader>d", group = "[D]iagnostics" },
  { "<leader>d_", hidden = true },
  { "<leader>f", group = "[F]ind" },
  { "<leader>f_", hidden = true },
  { "<leader>g", group = "[G]it" },
  { "<leader>g_", hidden = true },
  { "<leader>gd", group = "[G]it [D]iff" },
  { "<leader>gd_", hidden = true },
  { "<leader>h", group = "[H]unk Git" },
  { "<leader>h_", hidden = true },
  { "<leader>t", group = "[T]rouble" },
  { "<leader>t_", hidden = true },
  { "<leader>w", group = "[W]orkspace" },
  { "<leader>w_", hidden = true },
  { "<leader>1", hidden = true },
  { "<leader>2", hidden = true },
  { "<leader>3", hidden = true },
  { "<leader>4", hidden = true },
  { "<leader>5", hidden = true },
  { "<leader>6", hidden = true },
  { "<leader>7", hidden = true },
  { "<leader>8", hidden = true },
  { "<leader>9", hidden = true },
}, {
  { "<leader>", group = "VISUAL <leader>", mode = "v" },
  { "<leader>h", desc = "Git [H]unk", mode = "v" },
})

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()

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

  omnisharp = {
    cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    FormattingOptions = {
      -- Enables support for reading code style, naming convention and analyzer
      -- settings from .editorconfig.
      EnableEditorConfigSupport = true,
      -- Specifies whether 'using' directives should be grouped and sorted during
      -- document formatting.
      OrganizeImports = true,
    },
    MsBuild = {
      -- If true, MSBuild project system will only load projects for files that
      -- were opened in the editor. This setting is useful for big C# codebases
      -- and allows for faster initialization of code navigation features only
      -- for projects that are relevant to code that is being edited. With this
      -- setting enabled OmniSharp may load fewer projects and may thus display
      -- incomplete reference lists for symbols.
      LoadProjectsOnDemand = false,
    },
    RoslynExtensionsOptions = {
      -- Enables support for roslyn analyzers, code fixes and rulesets.
      EnableAnalyzersSupport = true,
      -- Enables support for showing unimported types and unimported extension
      -- methods in completion lists. When committed, the appropriate using
      -- directive will be added at the top of the current file. This option can
      -- have a negative impact on initial completion responsiveness,
      -- particularly for the first few completion sessions after opening a
      -- solution.
      EnableImportCompletion = true,
      -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
      -- true
      AnalyzeOpenDocumentsOnly = false,
    },
    Sdk = {
      -- Specifies whether to include preview versions of the .NET SDK when
      -- determining which version to use for project loading.
      IncludePrereleases = true,
    },
  },

  lua_ls = {
    Lua = {
      hint = { enable = true },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = { disable = { "missing-fields" } },
    },
  },
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = true,
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
      cmd = (servers[server_name] or {}).cmd,
    })
  end,
})

-- Customize right click contextual menu.
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Disable right contextual menu warning message",
  callback = function()
    -- Disable right click message
    vim.api.nvim_command([[aunmenu PopUp]])
    vim.api.nvim_command([[menu PopUp.Definition <cmd>lua vim.lsp.buf.definition()<CR>]])
    vim.api.nvim_command([[menu PopUp.References <cmd>Telescope lsp_references<CR>]])
    vim.api.nvim_command([[menu PopUp.Back <C-t>]])
    vim.api.nvim_command([[menu PopUp.URL gx]])
    vim.api.nvim_command([[menu PopUp.-2- <NOP>]])
    vim.api.nvim_command([[menu PopUp.Toggle\ \Breakpoint <cmd>:lua require('dap').toggle_breakpoint()<CR>]])
    vim.api.nvim_command([[menu PopUp.Start\ \Debugger <cmd>:DapContinue<CR>]])
    vim.api.nvim_command([[menu PopUp.Run\ \Test <cmd>:Neotest run<CR>]])
  end,
})

-- This module contains a number of default definitions
local rainbow_delimiters = require("rainbow-delimiters")

---@type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
  strategy = {
    [""] = rainbow_delimiters.strategy["global"],
    -- vim = rainbow_delimiters.strategy["local"],
  },
  query = {
    [""] = "rainbow-delimiters",
    -- lua = "rainbow-delimiters",
  },
  priority = {
    [""] = 110,
    -- lua = 110,
  },
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
  },
}

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
