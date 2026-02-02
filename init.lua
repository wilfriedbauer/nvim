vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.guicursor = "n:blinkwait100-blinkon100-blinkoff100,i:ver25-blinkwait100-blinkon100-blinkoff100,v:blinkwait100-blinkon100-blinkoff100"
vim.o.number = true
vim.o.relativenumber = false
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.virtualedit = "all"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmode = false
vim.o.cmdheight = 0
vim.wo.signcolumn = "auto:5"
vim.o.updatetime = 100
vim.o.timeoutlen = 300
vim.o.title = true
vim.o.titlestring = [[%{fnamemodify(getcwd(), ':t')} ❯ %t %m — %{luaeval("require('dap').status()")} (]] .. [[%{len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))}]] .. [[ bufs) (%{tabpagenr()} of %{tabpagenr('$')} tabs)]]
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.statuscolumn = "%s %l %C "
vim.opt.path:append(",**")
vim.o.list = true
vim.opt.listchars = {
  tab = "«-»",
  trail = "·",
  nbsp = "␣",
  leadmultispace = " │",
  extends = "→",
  precedes = "←",
  -- eol = '↵',
}
vim.o.foldmethod = "indent"
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.fillchars = {
    eob = ' ',
    fold = ' ',
    foldopen = '',
    foldclose = '',
    foldsep = ' ',
    foldinner = ' ',
    msgsep = '─',
}
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.cursorcolumn = false
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.wrap = true
vim.o.textwidth = 0
vim.o.wrapmargin = 0
vim.o.breakindent = true
vim.o.breakindentopt= "shift:8"
vim.o.showbreak = "  ↪  "
vim.o.linebreak = true
vim.o.jumpoptions = "stack,view"
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.inccommand = "split"
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.scrolloff = 2
vim.o.sidescrolloff = 5
vim.o.colorcolumn = "80"
vim.o.sessionoptions = "blank,buffers,tabpages,curdir,help,localoptions,winsize,winpos,terminal"
vim.o.iskeyword = '@,48-57,192-255,_,-'

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then -- Windows-specific configurations.  vim.fn.has("unix") vim.fn.has("mac")
  vim.o.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  vim.o.shellxquote = ""
  vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
  vim.o.shellquote = ""
  vim.o.shellpipe = "| Out-File -Encoding UTF8 %s"
  vim.o.shellredir = "| Out-File -Encoding UTF8 %s"
end

vim.keymap.set('n', '<leader>q', function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end
end, { desc = 'Toggle quickfix list' })
vim.keymap.set("n", "<leader>b", ":ls<CR>:b ", { desc = "Buffer Navigation" })
vim.keymap.set('n', '<Space>e', ':30vs %:p:h/<CR>', { noremap = true })
vim.keymap.set('n', 'Y', 'y$', { noremap = true })
vim.keymap.set('n', ']a', ':next<CR>:arg<CR>', { desc = "Next and display Arglist", noremap = true })
vim.keymap.set('n', '[a', ':previous<CR>:arg<CR>', { desc = "Previous and display Arglist", noremap = true })
vim.keymap.set("n", "<leader>a", ":argadd%<CR>:argdedupe<CR>:arg<CR>", { desc = "Add current file to Arglist"})
vim.keymap.set("n", "<leader>x", ":argdelete%<CR>:arg<CR>", { desc = "Remove current file from Arglist"})
vim.keymap.set({ "n", "x" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "ycc", '"yy" . v:count1 . "gcc\']p"', { remap = true, expr = true })
vim.keymap.set("x", "<C-/>", "<Esc>/\\%V")
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<leader>p", ":cd %:p:h<CR>", { desc = "Find Project Root Automatically" })

vim.keymap.set("n", "zh", "zH", { desc = "Scroll right" })
vim.keymap.set("n", "zl", "zL", { desc = "Scroll left" })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

vim.keymap.set("n", "<Up>", "<cmd>resize -5<CR>", { desc = "Resize Down" })
vim.keymap.set("n", "<Down>", "<cmd>resize +5<CR>", { desc = "Resize Up" })
vim.keymap.set("n", "<Left>", "<cmd>vertical resize +5<CR>", { desc = "Resize Left" })
vim.keymap.set("n", "<Right>", "<cmd>vertical resize -5<CR>", { desc = "Resize Right" })

vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, { desc = "Show diagnostic Error messages" })
vim.keymap.set("n", "<leader>K", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

vim.g.relops_active = true

local function refresh_line_numbers()
    if not vim.bo.modifiable or vim.bo.buftype ~= "" or vim.bo.filetype == "help" then
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        return
    end

    local mode = vim.api.nvim_get_mode().mode
    if vim.g.relops_active then -- MODERN RELOPS LOGIC
        local targeting_modes = {
          ['no'] = true, -- Operator-pending (pressed d, c, y)
          ['v'] = true, -- Visual
          ['V'] = true, -- Visual Line
          ['\22'] = true, -- Visual Block (CTRL-V)
          ['c'] = true, -- Command-line (typing :)
          ['niI'] = true, -- Operator-pending in Insert mode (rare)
        }
        vim.opt_local.relativenumber = targeting_modes[mode] or false
    else -- STANDARD HYBRID LOGIC
        if mode == 'i' then
            vim.opt_local.relativenumber = false
        else
            vim.opt_local.relativenumber = true
        end
    end
    vim.opt_local.number = true
end

vim.keymap.set("n", "<leader>l", function()
    vim.g.relops_active = not vim.g.relops_active
    refresh_line_numbers()
    print("ModernRelOps: " .. (vim.g.relops_active and "ON" or "OFF"))
end, { desc = "Toggle Numbering Profile" })

vim.api.nvim_create_autocmd({ "ModeChanged", "CursorMoved", "BufEnter", "BufWinEnter", "TermOpen"}, {
    group = vim.api.nvim_create_augroup("DynamicLineNumbers", { clear = true }),
    callback = refresh_line_numbers,
})

for i = 1, 9 do
    vim.keymap.set("n", tostring(i), function()
        if vim.g.relops_active then
            vim.opt_local.relativenumber = true
        end
        return tostring(i)
    end, { expr = true, silent = true })
end

vim.keymap.set("n", "<Esc>", function()
    vim.cmd("nohlsearch")
    if vim.g.relops_active then
        vim.opt_local.relativenumber = false
    end
    return "<Esc>"
end, { expr = true, silent = true, desc = "Clear highlights and reset relativenumber" })

vim.keymap.set("n", "<leader>i", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  print("InlayHint Enabled: ", vim.lsp.inlay_hint.is_enabled())
end, { desc = "Inlay Hints Toggle" })

local codelens_enabled = false
vim.keymap.set("n", "<leader>L", function()
  codelens_enabled = not codelens_enabled
  if codelens_enabled then
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("CodelensToggle", { clear = true }),
      callback = vim.lsp.codelens.refresh,
    })
  else
    vim.lsp.codelens.clear()
    vim.api.nvim_clear_autocmds({ group = "CodelensToggle" })
  end
  print("CodeLens Enabled:", codelens_enabled)
end, { desc = "Toggle CodeLens" })

vim.keymap.set("n", "<leader>dH", function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
  print("Diagnostics Enabled:", not enabled)
end, { desc = "[D]iagnostics - Toggle [H]ide all Diagnostics" })

vim.keymap.set("n", "<leader>dh", function()
  local config = vim.diagnostic.config()
  local enabled = config.virtual_text ~= false
  vim.diagnostic.config({ virtual_text = not enabled })
  print("Virtual Text Enabled:", not enabled)
end, { desc = "[D]iagnostics - Toggle [H]ide Virtual Text" })

vim.keymap.set("n", "<leader>dl", function()
  local config = vim.diagnostic.config()
  local enabled = config.virtual_lines ~= nil and config.virtual_lines ~= false
  vim.diagnostic.config({
    virtual_lines = not enabled and { only_current_line = true } or false
  })
  print("Virtual Lines on current line enabled:", not enabled)
end, { desc = "[D]iagnostics - Toggle Virtual Lines on current line" })

vim.keymap.set("n", "<leader>z", function()
  local centered = vim.opt.scrolloff:get() == 999
  vim.opt.scrolloff = centered and 2 or 999
  vim.cmd("normal! zz")
  print("Keep Cursor Centered Enabled:", not centered)
end, { desc = "Toggle keep cursor centered (auto zz)" })

vim.lsp.inline_completion.enable(true)

vim.keymap.set("n", "<leader>C", function()
vim.lsp.inline_completion.enable(not vim.lsp.inline_completion.is_enabled())
end, { desc = "Toggle LSP Inline Completion" })

vim.keymap.set("i", "<C-CR>", function()
    if not vim.lsp.inline_completion.get() then
        return "<C-CR>"
    end
end, { expr = true, desc = "Accept the current inline completion" })

vim.keymap.set("i", "<M-CR>", function()
    if not vim.lsp.inline_completion.get() then
        return "<M-CR>"
    end
end, { expr = true, desc = "Accept the current inline completion" })

 -- Next suggestion
vim.keymap.set("i", "<M-]>", function()
  vim.lsp.inline_completion.select({ count = 1 })
end, { desc = "Next inline completion" })

-- Previous suggestion
vim.keymap.set("i", "<M-[>", function()
  vim.lsp.inline_completion.select({ count = -1 })
end, { desc = "Previous inline completion" })

vim.keymap.set("t", "<C-_>", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-/>", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]])
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]])

local keys = { "!", "@", "#", "$", "%", "^", "&", "*", "(" }
for i, key in ipairs(keys) do
  vim.keymap.set("n", "<leader>" .. key, function()
    local args = vim.fn.argv()
    if i <= #args then
      vim.cmd("argument " .. i)
      vim.cmd("arg")
    else
      print("No arglist entry #" .. i)
    end
  end, {
    noremap = true,
    silent = true,
    desc = "Go to arg " .. i
  })
end

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    if i <= #bufs then
      vim.cmd('buffer ' .. bufs[i].bufnr)
    else
      print("No buffer #" .. i)
    end
  end, { silent = true, noremap = true })
end

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    numhl = {
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
    },
    text = {
      [vim.diagnostic.severity.HINT]  = "󰌶 ",
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.INFO]  = " ",
      [vim.diagnostic.severity.WARN]  = "󰀪 ",
    }
  },
  underline = false,
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_create_autocmd('TextYankPost', { -- yank-ring
    callback = function()
        if vim.v.event.operator == 'y' then
            for i = 9, 1, -1 do -- Shift all numbered registers.
                vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
            end
        end
    end,
})

vim.g.SCHEME = "default"

vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    pcall(vim.cmd.colorscheme, vim.g.SCHEME)
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(params)
    vim.g.SCHEME = params.match
  end,
})

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
    "nvim-undotree"
  },
  callback = function()
    vim.keymap.set("n", "q", vim.cmd.close, { desc = "Close the current buffer", buffer = true })
  end,
})

-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    pattern = "*",
    desc = "highlight selection on yank",
    callback = function()
        vim.highlight.on_yank({ timeout = 200, visual = true })
    end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    command = "wincmd L",
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
    command = "wincmd =",
})

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Setup custom right-click contextual menu",
  callback = function()
    vim.api.nvim_command([[menu PopUp.-3- <NOP>]])
    vim.api.nvim_command([[menu PopUp.-4- <NOP>]])
    vim.api.nvim_command([[menu PopUp.Definition <cmd>lua vim.lsp.buf.definition()<CR>]])
    vim.api.nvim_command([[menu PopUp.References <cmd>lua vim.lsp.buf.references()<CR>]])
    vim.api.nvim_command([[menu PopUp.URL gx]])
    vim.api.nvim_command([[menu PopUp.-5- <NOP>]])
    vim.api.nvim_command([[menu PopUp.Back <C-t>]])
    vim.api.nvim_command([[menu PopUp.-6- <NOP>]])
    vim.api.nvim_command([[menu PopUp.Toggle\ \Breakpoint <cmd>:lua require('dap').toggle_breakpoint()<CR>]])
    vim.api.nvim_command([[menu PopUp.Start\ \Debugger <cmd>:DapContinue<CR>]])
    vim.api.nvim_command([[menu PopUp.Run\ \Test <cmd>lua require("neotest").run.run()<CR>]])
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd.packadd('cfilter') --add quickfix filter builtin
    vim.cmd.packadd('termdebug') --add gdb debug command
    vim.cmd.packadd('nvim.difftool')
    vim.cmd.packadd('nvim.undotree')
  end
})

require('vim._extui').enable { enable = true, msg = { target = 'msg' } }

-- Plugins
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
require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
      "folke/tokyonight.nvim",
      name = "tokyonight",
      lazy = false,
      priority = 1000,
      config = function()
          -- vim.cmd.colorscheme("tokyonight-night")
      end,
  },
  {
      "rebelot/kanagawa.nvim",
      name = "kanagawa",
      lazy = false,
      priority = 1000,
      config = function()
          -- vim.cmd.colorscheme("kanagawa-wave")
      end,
  },
  {
      "rose-pine/neovim",
      name = "rose-pine",
      lazy = false,
      priority = 1000,
      config = function()
          vim.cmd("colorscheme rose-pine")
      end
  },
  {
      "EdenEast/nightfox.nvim",
      name = "nightfox",
      lazy = false,
      priority = 1000,
      config = function()
          -- vim.cmd("colorscheme nightfox")
          -- vim.cmd("colorscheme nordfox")
      end,
  },
  {
      "navarasu/onedark.nvim",
      name = "onedark",
      lazy = false,
      priority = 1000,
      config = function()
          -- require('onedark').setup {
          --     style = 'darker'
          -- }
          -- require('onedark').load()
      end
  },
  {
      "sainnhe/gruvbox-material",
      name = "gruvbox-material",
      lazy = false,
      priority = 1000,
      config = function()
        -- vim.g.gruvbox_material_enable_italic = true
        -- vim.g.gruvbox_material_background = 'soft'
        -- vim.cmd("colorscheme gruvbox-material")
      end,
  }, 
  {
      'projekt0n/github-nvim-theme',
      name = 'github-theme',
      lazy = false,
      priority = 1000,
      config = function()
          -- vim.cmd('colorscheme github_dark')
      end,
  },
  {
      "sainnhe/everforest",
      name = "everforest",
      lazy = false,
      priority = 1000,
      config = function()
          -- vim.g.everforest_background = 'medium'
          -- vim.cmd("colorscheme everforest")
      end,
  },
  {
      "Mofiqul/vscode.nvim",
      name = "vscode",
      lazy = false,
      priority = 1000,
      config = function()
          -- vim.cmd("colorscheme vscode")
      end,
  },
  {
      "shaunsingh/nord.nvim",
      name = "nord",
      lazy = false,
      priority = 1000,
      config = function()
          -- vim.cmd("colorscheme nord")
      end,
  },
  {
      "eldritch-theme/eldritch.nvim",
      name = "eldritch",
      lazy = false,
      priority = 1000,
      config = function()
          -- vim.cmd("colorscheme eldritch")
      end,
  },
  {
      "jnz/studio98",
      name = "studio98",
      lazy = false,
      priority = 1000,
      config = function()
          -- vim.cmd("colorscheme studio98")
      end,
  },
  {
      "nyoom-engineering/oxocarbon.nvim",
      name = "oxocarbon",
      lazy = false,
      priority = 1000,
      config = function()
          -- vim.opt.background = "dark"
          -- vim.cmd("colorscheme oxocarbon")
      end,
  },
  {
      "wtfox/jellybeans.nvim",
      name = "jellybeans",
      lazy = false,
      priority = 1000,
      config = function()
          -- vim.cmd("colorscheme jellybeans")
      end,
  },
  {
      "oskarnurm/koda.nvim",
      name = "koda",
      lazy = false,
      priority = 1000,
      config = function()
          -- require("koda").setup({ transparent = true })
          -- vim.cmd("colorscheme koda")
      end,
  },
  {
    "tpope/vim-fugitive", -- Git related plugins
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
  },
  { -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",
  },
  { "ryanoasis/vim-devicons", event = "UIEnter" },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = {
        enabled = true,
      },
      indent = { enabled = false },
      input = { enabled = false },
      notifier = {
        enabled = false,
        timeout = 3000,
      },
      picker = {
        hidden = true,
        ignored = true,
        enabled = true,
        sources = {
          files = {
            hidden = true,
            ignored = true,
          },
          explorer = {
            layout = { layout = { position = "right" } },
          }
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = true },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        }
      }
    },
    keys = {
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>.",       function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>/",       function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>?",       function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>:",       function() Snacks.picker.command_history() end, desc = "Command History" },
      { '<leader>"',       function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>N",       function() Snacks.picker.notifications() end, desc = "Notification History" },
      { "<leader>n",       function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader>P",       function() Snacks.picker.projects() end, desc = "Projects" },
      -- find
      { '<leader>f/',      function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>f:",      function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>ff",      function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fa",      function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>fB",      function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>fd",      function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>fb",      function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>fw",      function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      { "<leader>fD",      function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>fh",      function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>fH",      function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>fi",      function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>fj",      function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>fk",      function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>fl",      function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>fm",      function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>fM",      function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>fp",      function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>fq",      function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>fr",      function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>fu",      function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>fs",      function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>fS",      function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- git
      { "<leader>gf",      function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>gb",      function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl",      function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL",      function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs",      function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS",      function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd",      function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gF",      function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      { "<leader>gB",      function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      -- { "<leader>gg",      function() Snacks.lazygit() end, desc = "Lazygit" },
      -- gh
      { "<leader>gi",      function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>gI",      function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      { "<leader>gp",      function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { "<leader>gP",      function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
      -- LSP
      { "gd",              function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD",              function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gR",              function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI",              function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy",              function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "gai",             function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
      { "gao",             function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
      { "grN",             function() Snacks.rename.rename_file() end, desc = "Rename File" },
      -- Other
      { "<leader>uz",       function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>uZ",       function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>us",       function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>uS",       function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>un",       function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>uc",       function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- { "<leader>bd",      function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>uN",       function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<c-/>",            function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<c-_>",            function() Snacks.terminal() end, desc = "which_key_ignore" },
      { "]]",               function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[",               function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end

          -- Override print to use snacks for `:=` command
          if vim.fn.has("nvim-0.11") == 1 then
            vim._print = function(_, ...)
              dd(...)
            end
          else
            vim.print = _G.dd
          end

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>uT")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
          "<leader>uC")
          Snacks.toggle.treesitter():map("<leader>ut")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'xzbdmw/colorful-menu.nvim',
      'onsails/lspkind.nvim'
    },
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<C-y>'] = { 'select_and_accept', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then return cmp.accept()
            else return cmp.select_and_accept() end
          end,
          'snippet_forward',
          'fallback'
        },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        -- ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },
      appearance = { nerd_font_variant = 'mono' },
      -- cmdline = { completion = { ghost_text = { enabled = true } } },
      completion = {
        trigger = { show_in_snippet = false },
        -- ghost_text = { enabled = true },
        documentation = { auto_show = true },
        menu = {
          draw = {
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
              kind_icon = {
                  text = function(ctx)
                      return require('lspkind').symbol_map[ctx.kind] or ''
                  end,
              },
            },
          },
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          max_lines = '15%',
          multiline_threshold = 15,
          trim_scope = 'outer',
          mode = 'topline',
        },
      },
    },
    config = function()
      local ts = require('nvim-treesitter')

      -- State tracking for async parser loading
      local parsers_loaded = {}
      local parsers_pending = {}
      local parsers_failed = {}

      local ns = vim.api.nvim_create_namespace('treesitter.async')

      -- Helper to start highlighting and indentation
      local function start(buf, lang)
        local ok = pcall(vim.treesitter.start, buf, lang)
        if ok then
          -- vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
        return ok
      end

      -- Install core parsers after lazy.nvim finishes loading all plugins
      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyDone',
        once = true,
        callback = function()
          ts.install({
            'angular',
            'asm',
            'awk',
            'bash',
            'comment',
            'c',
            'cpp',
            'css',
            'c_sharp',
            'css',
            'csv',
            'cuda',
            'diff',
            'dockerfile',
            'editorconfig',
            'fortran',
            'git_config',
            'git_rebase',
            'gitcommit',
            'gitignore',
            'go',
            'graphql',
            'haskell',
            'html',
            'http',
            'java',
            'javascript',
            'json',
            'json5',
            'kotlin',
            'latex',
            'llvm',
            'lua',
            'luadoc',
            'make',
            'markdown',
            'markdown_inline',
            'nginx',
            'nix',
            'objdump',
            'ocaml',
            'odin',
            'passwd',
            'perl',
            'php',
            'powershell',
            'prolog',
            'python',
            'query',
            'r',
            'regex',
            'ruby',
            'rust',
            'scala',
            'scss',
            'sql',
            'strace',
            'svelte',
            'swift',
            'systemverilog',
            'terraform',
            'toml',
            'tsx',
            'typescript',
            'typst',
            'vim',
            'vimdoc',
            'vue',
            'xml',
            'yaml',
            'zsh',
          }, {
            max_jobs = 8,
          })
        end,
      })

      -- Decoration provider for async parser loading
      vim.api.nvim_set_decoration_provider(ns, {
        on_start = vim.schedule_wrap(function()
          if #parsers_pending == 0 then
            return false
          end
          for _, data in ipairs(parsers_pending) do
            if vim.api.nvim_buf_is_valid(data.buf) then
              if start(data.buf, data.lang) then
                parsers_loaded[data.lang] = true
              else
                parsers_failed[data.lang] = true
              end
            end
          end
          parsers_pending = {}
        end),
      })

      local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })

      local ignore_filetypes = {
        'checkhealth',
        'lazy',
        'mason',
        'snacks_dashboard',
        'snacks_notif',
        'snacks_win',
        'norg',
        'cmd',
        'dialog',
        'msg',
        'pager',
        'snacks_layout_box',
        'snacks_win_backdrop',
        'snacks_layout_box',
        'snacks_picker_input',
        'snacks_picker_list',
        'snacks_picker_preview',
        'blink-cmp-menu'
      }



      -- Auto-install parsers and enable highlighting on FileType
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        desc = 'Enable treesitter highlighting and indentation (non-blocking)',
        callback = function(event)
          if vim.tbl_contains(ignore_filetypes, event.match) then
            return
          end

          local lang = vim.treesitter.language.get_lang(event.match) or event.match
          local buf = event.buf

          if parsers_failed[lang] then
            return
          end

          if parsers_loaded[lang] then
            -- Parser already loaded, start immediately (fast path)
            start(buf, lang)
          else
            -- Queue for async loading
            table.insert(parsers_pending, { buf = buf, lang = lang })
          end

          -- Auto-install missing parsers (async, no-op if already installed)
          ts.install({ lang })
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({
          select = {
              lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          },
      })
      local select = require("nvim-treesitter-textobjects.select")
      local function sel(key, capture)
        vim.keymap.set({ "x", "o" }, "a" .. key, function()
          select.select_textobject(capture .. ".outer", "textobjects")
        end, { desc = "around " .. capture })
        vim.keymap.set({ "x", "o" }, "i" .. key, function()
          select.select_textobject(capture .. ".inner", "textobjects")
        end, { desc = "inner " .. capture })
      end

      sel("f", "@function")
      sel("c", "@class")
      sel("o", "@block")
      sel("l", "@loop")
      sel("g", "@conditional")
      sel("s", "@statement") -- outer only, inner will no-op
      sel("r", "@return")
      sel("p", "@parameter")
      sel("a", "@assignment")
      sel("n", "@number")
      sel("x", "@regex")
      sel("k", "@comment")
      sel("C", "@call")
      sel("A", "@attribute")
      sel("F", "@frame")
      sel("S", "@scopename")

      vim.keymap.set({ "x", "o" }, "iL", function()
        select.select_textobject("@assignment.lhs", "textobjects")
      end, { desc = "inner assignment lhs" })
      vim.keymap.set({ "x", "o" }, "iR", function()
        select.select_textobject("@assignment.rhs", "textobjects")
      end, { desc = "inner assignment rhs" })

      local move = require("nvim-treesitter-textobjects.move")
      local function mov(key, capture)
        -- next
        vim.keymap.set({ "n", "x", "o" }, "]" .. key:upper(), function()
          move.goto_next_end(capture .. ".outer", "textobjects")
        end, { desc = "Next " .. capture .. " end" })
        vim.keymap.set({ "n", "x", "o" }, "]" .. key, function()
          move.goto_next_start(capture .. ".outer", "textobjects")
        end, { desc = "Next " .. capture .. " start" })
        -- previous
        vim.keymap.set({ "n", "x", "o" }, "[" .. key:upper(), function()
          move.goto_previous_end(capture .. ".outer", "textobjects")
        end, { desc = "Previous " .. capture .. " end" })
        vim.keymap.set({ "n", "x", "o" }, "[" .. key, function()
          move.goto_previous_start(capture .. ".outer", "textobjects")
        end, { desc = "Previous " .. capture .. " start" })
      end

      mov("f", "@function")
      mov("o", "@block")
      mov("l", "@loop")
      mov("g", "@conditional")
      mov("r", "@return")
      mov("a", "@assignment")
      mov("C", "@call")
      mov("p", "@parameter")
      mov("A", "@attribute")
      mov("F", "@frame")
      mov("S", "@scopename")
      mov("k", "@comment")

      vim.keymap.set({ "n", "x", "o" }, "]}", function()
        move.goto_next_end("@class.outer", "textobjects")
      end, { desc = "Next " .. "@class.outer" .. " end" })
      vim.keymap.set({ "n", "x", "o" }, "]{", function()
        move.goto_next_start("@class.outer", "textobjects")
      end, { desc = "Next " .. "@class.outer" .. " start" })
      -- previous
      vim.keymap.set({ "n", "x", "o" }, "[}", function()
        move.goto_previous_end("@class.outer", "textobjects")
      end, { desc = "Previous " .. "@class.outer" .. " end" })
      vim.keymap.set({ "n", "x", "o" }, "[{", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end, { desc = "Previous " .. "@class.outer" .. " start" })

      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

      vim.keymap.set("n", "<leader>>", function()
          require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
      end, { desc = "Swap next parameter" })
      vim.keymap.set("n", "<leader><", function()
          require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
      end, { desc = "Swap previous parameter" })
    end,
  },
  {
    'aaronik/treewalker.nvim',
    config = function()
      require('treewalker').setup{}
      -- movement
      vim.keymap.set({ 'n', 'v' }, '<A-k>', '<cmd>Treewalker Up<cr>', { silent = true })
      vim.keymap.set({ 'n', 'v' }, '<A-j>', '<cmd>Treewalker Down<cr>', { silent = true })
      vim.keymap.set({ 'n', 'v' }, '<A-h>', '<cmd>Treewalker Left<cr>', { silent = true })
      vim.keymap.set({ 'n', 'v' }, '<A-l>', '<cmd>Treewalker Right<cr>', { silent = true })
      -- swapping
      vim.keymap.set('n', '<A-S-k>', '<cmd>Treewalker SwapUp<cr>', { silent = true })
      vim.keymap.set('n', '<A-S-j>', '<cmd>Treewalker SwapDown<cr>', { silent = true })
      vim.keymap.set('n', '<A-S-h>', '<cmd>Treewalker SwapLeft<cr>', { silent = true })
      vim.keymap.set('n', '<A-S-l>', '<cmd>Treewalker SwapRight<cr>', { silent = true })
    end,
  },
  {
    -- LSP CONFIG
    "neovim/nvim-lspconfig",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      { "mason-org/mason-lspconfig.nvim" },
      { "mason-org/mason.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { "mfussenegger/nvim-lint" },
      {
          "pmizio/typescript-tools.nvim",
          dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
          opts = {},
      },
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- JavaScript / TypeScript
          "typescript-language-server", -- LSP
          "prettierd", -- formatter
          "prettier", -- formatter
          "eslint_d", -- linter

          -- HTML
          "html",     -- LSP
          "prettier", -- linter

          -- CSS
          "cssls",    -- LSP
          "prettier", -- linter

          -- SQL
          "sqlls",    -- LSP
          "sqlfluff", -- linter
          "sqlfmt",   -- formatter

          -- Python
          "pyright",                  -- LSP
          "black", "isort",           -- formatter
          "flake8", "ruff", "pylint", -- linters

          -- Bash / Shell
          "bashls",     -- LSP
          "shfmt",      -- formatter
          "shellcheck", -- linter

          -- Java
          "jdtls", -- LSP
          "google-java-format", --formatter

          -- C#
          "csharpier", -- formatter

          -- C / C++
          "clangd",       -- LSP
          "clang-format", -- formatter
          "cpplint",   -- linter

          -- PowerShell
          "powershell_es", -- LSP

          -- PHP
          "phpactor", -- LSP
          "phpcbf",   -- formatter
          "phpcs",    -- linter

          -- Go
          "gopls",         -- LSP
          "goimports",     -- formatter
          "golangci-lint", -- linter

          -- Rust
          "rust_analyzer", -- LSP
          "rustfmt",       -- formatter
          "bacon",        -- linter

          -- Kotlin
          "kotlin_language_server", -- LSP
          "ktfmt",                  -- formatter
          "ktlint",                 -- linter

          -- Lua
          "lua_ls", -- LSP
          "stylua", -- formatter

          -- Assembly
          "asm_lsp", -- LSP

          -- JSON
          "jsonls", -- LSP

          -- YAML
          "yamlls",   -- LSP
          "yamlfmt",  -- formatter
          "yamllint", -- linter

          -- TOML
          "taplo", -- LSP

          -- XML
          "lemminx", -- LSP
          "xmlformatter", -- formatter

          -- Dockerfile
          "dockerls", -- LSP
          "hadolint", -- linter

          -- Markdown
          "marksman",     -- LSP
          "markdownlint", -- linter / formatter
        },
        auto_update = false,
        run_on_start = true,
      })

      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "flake8", "ruff", "pylint" },
        go = { "golangci-lint" },
        php = { "phpcs" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        sql = { "sqlfluff" },
        yaml = { "yamllint" },
        json = { "jq" },
        toml = { "taplo" },
        xml = { "xmllint" },
        dockerfile = { "hadolint" },
        markdown = { "markdownlint" },
        c = { "cpplint" },
        cpp = { "cpplint" },
        rust = { "bacon" },
        kotlin = { "detekt" },
      }

      vim.keymap.set("n", "<leader>FL", function() require("lint").try_lint() end, { buffer = bufnr, desc = "[L]int" })

      -- Keymaps only set when an LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          -- Only activate if server supports it
          if not client.server_capabilities.documentHighlightProvider then
            return
          end

          local group = vim.api.nvim_create_augroup("LspDocumentHighlight" .. bufnr, { clear = true })

          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,
            { buffer = bufnr, desc = "[W]orkspace [A]dd Folder" })
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,
            { buffer = bufnr, desc = "[W]orkspace [R]emove Folder" })
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, { buffer = bufnr, desc = "[W]orkspace [L]ist Folders" })

          vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
            require("conform").format({ async = false, lsp_fallback = true })
            vim.cmd("retab")
          end, { desc = "Format current buffer with LSP" })


          vim.keymap.set({ "n", "x" }, "grf", function()
              local mode = vim.fn.mode()

              if mode == "v" or mode == "V" or mode == "\22" then
                  vim.lsp.buf.format({ range = true, async = true })
              else
                  vim.lsp.buf.format({ async = true })
              end
          end, { desc = "LSP format (buffer or selection)" })

          -- Jump to next error
          vim.keymap.set("n", "]e", function()
            vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
          end, { desc = "Next Error" })
          -- Jump to previous error
          vim.keymap.set("n", "[e", function()
            vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
          end, { desc = "Previous Error" })

        end,
      })
    end,
  },
  {
    "GustavEikaas/easy-dotnet.nvim",
    ft = { "cs" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    config = function()
      require("easy-dotnet").setup({
        debugger = {
          bin_path = "netcoredbg",
        },
      })
    end
  },
  {
    "folke/which-key.nvim",
    event = "UIEnter",
    config = function()
      require("which-key").setup({
        preset = "helix",
        sort = { "group", "alphanum", "mod" },
      })
      require("which-key").add({
        { "<leader>B",  group = "[B]ug" },
        { "<leader>B_", hidden = true },
        { "<leader>R",  group = "[R]un HTTP" },
        { "<leader>R_", hidden = true },
        { "<leader>T",  group = "[T]est" },
        { "<leader>T_", hidden = true },
        { "<leader>d",  group = "[D]iagnostics" },
        { "<leader>d_", hidden = true },
        { "<leader>f",  group = "[F]ind" },
        { "<leader>f_", hidden = true },
        { "<leader>s",  group = "[S]earch" },
        { "<leader>s_", hidden = true },
        { "<leader>F",  group = "[F]ormat / Lint" },
        { "<leader>F_", hidden = true },
        { "<leader>g",  group = "[G]it" },
        { "<leader>g_", hidden = true },
        { "<leader>h",  group = "[H]unk Git" },
        { "<leader>h_", hidden = true },
        { "<leader>t",  group = "[T]rouble" },
        { "<leader>t_", hidden = true },
        { "<leader>w",  group = "[W]orkspace" },
        { "<leader>w_", hidden = true },
        { "<leader>A",  group = "[A]I Assistant" },
        { "<leader>A_", hidden = true },
        { "<leader>u",  group = "[U]I Toggles"},
        { "<leader>u_", hidden = true },
        { "<leader>1",  hidden = true },
        { "<leader>2",  hidden = true },
        { "<leader>3",  hidden = true },
        { "<leader>4",  hidden = true },
        { "<leader>5",  hidden = true },
        { "<leader>6",  hidden = true },
        { "<leader>7",  hidden = true },
        { "<leader>8",  hidden = true },
        { "<leader>9",  hidden = true },
        { "<leader>!",  hidden = true },
        { "<leader>@",  hidden = true },
        { "<leader>#",  hidden = true },
        { "<leader>$",  hidden = true },
        { "<leader>%",  hidden = true },
        { "<leader>^",  hidden = true },
        { "<leader>&",  hidden = true },
        { "<leader>*",  hidden = true },
        { "<leader>(",  hidden = true },
      }, {
        { "<leader>",  group = "VISUAL <leader>", mode = "x" },
        { "<leader>h", desc = "Git [H]unk",       mode = "x" },
      })
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ "n", "x" }, "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Jump to next hunk" })

        map({ "n", "x" }, "[c", function()
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
        map("x", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "stage git hunk" })
        map("x", "<leader>hr", function()
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
    end,
  },
  {                              -- Set lualine as statusline
    "nvim-lualine/lualine.nvim", -- See `:help lualine.txt`
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "meuter/lualine-so-fancy.nvim",
    },
    opts = {
      options = {
        icons_enabled = true,
        theme = "ayu_mirage",
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
          { "filename" },
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
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mason-org/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup()
        end,
      },
    },
    keys = {
      { "<leader>BC", function() require("dap").continue() end,          desc = "Debug: Start/Continue" },
      { "<leader>BI", function() require("dap").step_into() end,         desc = "Debug: Step Into" },
      { "<leader>BO", function() require("dap").step_over() end,         desc = "Debug: Step Over" },
      { "<leader>BU", function() require("dap").step_out() end,          desc = "Debug: Step Out" },
      { "<leader>BP", function() require("dap").toggle_breakpoint() end, desc = "Code Debug: Toggle Breakpoint" },
      {
        "<leader>Bp",
        function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        desc = "Code Debug: Set conditional Breakpoint"
      },
      { "<leader>BB", function() require("dapui").toggle() end,      desc = "Debug: Toggle UI & See last session result." },
      { "<leader>Bc", function() require("dap").run_to_cursor() end, desc = "Debug: Run to Cursor" },
      { "<leader>BR", function() require("dap").repl.toggle() end,   desc = "Debug: Toggle REPL" },
      { "<leader>BJ", function() require("dap").down() end,          desc = "Debug: Go Down Stack Frame" },
      { "<leader>BK", function() require("dap").up() end,            desc = "Debug: Go Up Stack Frame" },
      {
        "<leader>BQ",
        function()
          require("dap").terminate()
          require("dap").clear_breakpoints()
        end,
        desc = "Debug: Terminate and Clear Breakpoints"
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      vim.api.nvim_set_hl(0, "DapBreakpoint",            { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition",   { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "DapLogPoint",              { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "DapBreakpointRejected",    { fg = "#BE5046" })
      vim.api.nvim_set_hl(0, "DapStopped",               { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "DapStoppedLine",           { bg = "#2c313c" })

      vim.fn.sign_define("DapBreakpoint", {
        text = "●",
        texthl = "DapBreakpoint",
        numhl = "DapBreakpoint",
      })

      vim.fn.sign_define("DapBreakpointCondition", {
        text = "",
        texthl = "DapBreakpointCondition",
        numhl = "DapBreakpointCondition",
      })

      vim.fn.sign_define("DapLogPoint", {
        text = "",
        texthl = "DapLogPoint",
        numhl = "DapLogPoint",
      })

      vim.fn.sign_define("DapBreakpointRejected", {
        text = "",
        texthl = "DapBreakpointRejected",
        numhl = "DapBreakpointRejected",
      })

      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
        numhl = "DapStopped",
      })

      require("mason").setup()
      require("mason-nvim-dap").setup({
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          "netcoredbg",
          "coreclr"
        },
      })

      dapui.setup({
        icons = {
          expanded = "▾",
          collapsed = "▸",
          current_frame = "●",
        },
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "↳",
            step_over = "↷",
            step_out = "↰",
            step_back = "↶",
            run_last = "⟳",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      })
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
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
      "nsidorenco/neotest-vstest",
    },
    keys = {
      { "<leader>TS", "<cmd>Neotest summary toggle<CR>",                             mode = "", desc = "[T]est: [S]ummary toggle" },
      { "<leader>Tt", "<cmd>Neotest output toggle<CR>",                              mode = "", desc = "[T]est: Output line toggle" },
      { "<leader>TT", "<cmd>Neotest output-panel toggle<CR>",                        mode = "", desc = "[T]est: Output panel toggle" },
      { "<leader>TN", '<cmd>lua require("neotest").run.run()<CR>',                   mode = "", desc = "[T]est: Run [N]earest Test" },
      { "<leader>TF", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', mode = "", desc = "[T]est: Run [F]ile" },
      { "<leader>TA", '<cmd>lua require("neotest").run.attach()<CR>',                mode = "", desc = "[T]est: [A]ttach to nearest [T]est" },
      { "<leader>TB", '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>', mode = "", desc = "[T]est: De[b]ug nearest Test" },
      { "<leader>Ts", '<cmd>lua require("neotest").run.stop()<CR>',                  mode = "", desc = "[T]est: [S]top" },
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
        require("neotest-vstest")
      })
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    keys = {
      { "<leader>Rs", desc = "Send request" },
      { "<leader>Ra", desc = "Send all requests" },
      { "<leader>Rb", desc = "Open scratchpad" },
    },
    ft = { "http", "rest" },
    opts = {
      global_keymaps = true,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    },
  },
  {
    "DamianVCechov/hexview.nvim",
    config = function()
      require("hexview").setup()
    end
  },
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      {
        "<leader>ss",
        function() require("grug-far").open() end,
        desc = "grug-far: Search in project",
        mode = "n",
      },
      {
        "<leader>sf",
        function() require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } }) end,
        desc = "grug-far: Search in current file",
        mode = "n",
      },
      {
        "<leader>sw",
        function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end,
        desc = "grug-far: Search using word under cursor",
        mode = "n",
      },
      {
        "<leader>s/",
        function()
          local search = vim.fn.getreg("/")
          -- surround with \b if "word" search (such as when pressing `*`)
          if search and vim.startswith(search, "\\<") and vim.endswith(search, "\\>") then
            search = "\\b" .. search:sub(3, -3) .. "\\b"
          end
          require("grug-far").open({
            prefills = {
              search = search,
            },
          })
        end,
        desc = "grug-far: Search using @/ register value or visual selection",
        mode = { "n", "x" },
      },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>",                        mode = "", desc = "[T]rouble [T]oggle" },
      { "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>",                mode = "", desc = "[T]rouble [S]ymbols" },
      { "<leader>td", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           mode = "", desc = "[T]rouble [D]ocument Diagnostics" },
      { "<leader>tq", "<cmd>Trouble qflist toggle<cr>",                             mode = "", desc = "[T]rouble [Q]uickfix" },
      { "<leader>tl", "<cmd>Trouble loclist toggle<cr>",                            mode = "", desc = "[T]rouble [L]ocation List" },
      { "<leader>tr", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", mode = "", desc = "[T]rouble LSP [R]eferences" },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "BufEnter",
    config = function()
      require("nvim-surround").setup({
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
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<C-S-CR>",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>AA",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>AS",
        function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>AD",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>AT",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>AF",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>AV",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>AP",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>AC",
        function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
        desc = "Sidekick Toggle Claude",
      },
    },
  },
  { "brenoprata10/nvim-highlight-colors", event = "BufEnter", config = function() require("nvim-highlight-colors").setup() end },
  {
    "windwp/nvim-ts-autotag",
    event = "BufEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,          -- Auto close tags
          enable_rename = true,         -- Auto rename pairs of tags
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
      {
        "folke/snacks.nvim",
        opts = {
          terminal = {},
        }
      }
    },
    config = function()
      require("tiny-code-action").setup()
      vim.keymap.set( { "n", "x" }, "<leader>c", function()
        require("tiny-code-action").code_action()
      end, { desc = "LSP: Code Action (Preview)", noremap = true, silent = true })
    end,
  },
  {
    "zegervdv/nrpattern.nvim",
    event = "BufEnter",
    config = function()
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
    },
    keys = { { "<leader>gg", function() require("gitgraph").draw({}, { all = true, max_count = 5000 }) end, desc = "GitGraph - Draw" } },
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
    "OXY2DEV/markview.nvim",
    lazy = false,
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
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufEnter",
    config = function()
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
    end
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({})
      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "[E]dit Filetree with vim keymaps" })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("bufferline").setup({
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
    end,
  },
  { -- Autoformat
    "stevearc/conform.nvim",
    event = "BufEnter",
    keys = {
      {
        "<leader>FF",
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
          lua             = { "stylua" },
          csharp          = { "csharpier" },
          python          = { "isort", "black" },
          javascript      = { "prettierd", "prettier" },
          javascriptreact = { "prettierd", "prettier" },
          typescript      = { "prettierd", "prettier" },
          typescriptreact = { "prettierd", "prettier" },
          graphql         = { "prettierd", "prettier" },
          html            = { "prettierd", "prettier" },
          css             = { "prettierd", "prettier" },
          sh              = { "shfmt" },
          bash            = { "shfmt" },
          go              = { "gofmt" },
          php             = { "phpcbf" },
          rust            = { "rustfmt" },
          kotlin          = { "ktfmt" },
          java            = { "google-java-format" },
          c               = { "clang-format" },
          cpp             = { "clang-format" },
          sql             = { "sqlfmt" },
          json            = { "prettierd", "prettier" },
          yaml            = { "yamlfmt" },
          toml            = { "taplo" },
          xml             = { "xmlformat" },
          markdown        = { "prettierd", "prettier" },
        },
      },
    },
}, {})

-- INFO:
-- :.!date  Replace line with date output
-- !ip sort Sort paragraph
-- !ap jq . Format JSON in paragraph
-- :%!column -t Align entire file
-- Instead of pressing ^ you can press _(underscore) to jump to the first non-whitespace character on the same line the cursor is on.
-- + and - jump to the first non-whitespace character on the next / previous line.
-- In visual mode press 'o' to switch the side of the selection the cursor is on.
-- or press 'O' to switch the corner of the block selection.
-- :t and :m to copy/move lines. E.g. :3t. to copy line 3 below the current line.
-- :m-2 to move the current line above line 2.
-- :t0 or :t$ to copy line to start/end of file.
-- :g/error/t$ to copy all lines containing 'error' to the end of the file.
-- g; and g, to go to the next/previous change in the undo history. (:changes)
-- :'<,'>norm A; to append a semicolon to all selected lines in visual mode.
-- :'<,'>norm I// to insert '//' at the beginning of all selected lines in visual mode.
-- gU to uppercase, gu to lowercase, g~ to toggle case.
-- gUU to uppercase the entire line, guu to lowercase the entire line, g~~ to toggle case of the entire line.
-- In insert mode press CTRL-o to execute one normal mode command and go back to insertmode.
-- While searching with / or ? press CTRL-g and CTRL-t to go to next/previous occurence without leaving search.
-- with :u[ndo]0 you can go to the first change in the undo history. with :e[dit]! you can revert the buffer to the last saved state.

-- When in search (/) you can press CTRL-l to insert the next character of the current match. CTRL-g and CTRL-t to go to next/previous occurence/match without leaving search.

-- https://vimregex.com/
-- https://blog.sanctum.geek.nz/series/unix-as-ide/

-- Uninstall and reinstall repo from https://github.com/wilfriedbauer/nvim:
-- # Linux or MacOS (unix)
-- rm -rf ~/.config/nvim
-- rm -rf ~/.local/share/nvim

-- # Windows
-- rd -r ~\AppData\Local\nvim
-- rd -r ~\AppData\Local\nvim-data

-- Append .gitconfig to use nvim for diffs and merges (and other goodies):
-- [user]
--  name = REPLACE_PLACEHOLDER
--  email = REPLACE_PLACEHOLDER
-- [credential]
--  helper = store
-- [push]
--  autoSetupRemote = true
--  followTags = true
-- [pull]
--  rebase = true
-- [fetch]
--  prune = true
--  pruneTags = true
-- [core]
--  editor = nvim
--  autocrlf = input
-- [branch]
--  sort = -committerdate
-- [commit]
--  verbose = true
-- [diff]
--  tool = nvimdiff
--  algorithm = histogram
--  indentHeuristic = true
--  colorMoved = default
--  colorMovedWS = ignore-all-space
-- [merge]
--  tool = nvimdiff
--  conflictstyle = zdiff3
--  stat = true
-- [mergetool "vimdiff"]
--  layout = BASE,MERGED + BASE,LOCAL + BASE,REMOTE
-- [color]
--  ui = auto
-- [column]
--  ui = auto
-- [tag]
--  sort = version:refname
-- [rerere]
--  enabled = true
--  autoupdate = true
-- [help]
--  autocorrect = prompt
-- [alias]
--  st = status -sb
--  co = checkout
--  br = branch
--  rb = rebase -i HEAD~
--  d = diff --color-moved
--  df = diff --minimal
--  lg = log --graph --oneline --decorate --all
--  graph = log --graph --decorate --pretty=format:'%C(auto)%h %Cgreen%ad%Creset %C(bold blue)%an%Creset %s' --date=short
--  amend = commit --amend --no-edit
--  unstage = reset HEAD --
--  last = log -1 HEAD
--  undo = reset --soft HEAD~1
--  wipe = reset --hard HEAD
--  changes = diff HEAD~1 HEAD
