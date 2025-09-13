vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.guicursor = ""
vim.o.number = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.virtualedit = "all"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmode = false
vim.wo.signcolumn = "yes"
vim.o.updatetime = 50
vim.o.timeoutlen = 500
vim.o.completeopt = "menuone,noselect"
vim.o.termguicolors = true
vim.opt.relativenumber = false
-- vim.o.statuscolumn = "%s %l %=%r "  -- enable relative line numbers next to absolute line numbers.
vim.opt.list = true
vim.opt.path:append(",**")
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  -- eol = '↵',
}
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
vim.o.sessionoptions = "blank,buffers,tabpages,curdir,help,localoptions,winsize,winpos,terminal" -- auto-session.nvim

-- change diagnostic signs and display the most severe one in the sign gutter on the left.
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

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move visual selection up a line with <s-j>
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- move visual selection down a line with <s-k>
-- INFO:
-- Instead of pressing ^ you can press _(underscore) to jump to the first non-whitespace character on the same line the cursor is on.
-- + and - jump to the first non-whitespace character on the next / previous line.
-- In visual mode press 'o' to switch the side of the selection the cursor is on.
-- While searching with / or ? press CTRL-g and CTRL-t to go to next/previous occurence without leaving search.
vim.keymap.set("n", "ycc", '"yy" . v:count1 . "gcc\']p"', { remap = true, expr = true }) --Duplicate line and comment the line(takes count)
vim.keymap.set("x", "/", "<Esc>/\\%V")                                                   --search within visual selection
vim.keymap.set("v", "p", '"_dP')                                                         -- paste without overwriting paste register while in visual mode
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })    -- Remap for dealing with word wrap
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })    -- Remap for dealing with word wrap

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

-- diff visual selection or current file with clipboard in scratchbuffer
vim.keymap.set({ "n", "v" }, "<leader>dd", function()
  local clipboard = vim.fn.getreg("+") -- or "*" for primary selection
  local mode = vim.fn.mode()
  local buf = vim.api.nvim_create_buf(false, true)
  -- Insert clipboard into new buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(clipboard, "\n"))
  -- Save current window
  local curr_win = vim.api.nvim_get_current_win()
  -- Handle visual selection or entire buffer
  local lines
  if mode == "v" or mode == "V" then
    -- Get visual range
    local start_pos = vim.fn.getpos("'<")[2]
    local end_pos = vim.fn.getpos("'>")[2]
    lines = vim.api.nvim_buf_get_lines(0, start_pos - 1, end_pos, false)
  else
    -- Use entire buffer
    lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  end
  -- Create new scratch buffer and insert selected lines
  local buf2 = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf2, 0, -1, false, lines)
  -- Split and load buffers
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(curr_win, buf2)
  vim.api.nvim_set_current_buf(buf)
  -- Enable diff mode
  vim.cmd("wincmd l")
  vim.cmd("diffthis")
  vim.cmd("wincmd h")
  vim.cmd("diffthis")
end, { desc = "Compare clipboard with selection or file" })
vim.keymap.set("n", "<leader>dc", function()
  vim.cmd("diffoff!")
  vim.cmd("bd!") -- Close the scratch buffer
end, { desc = "Exit diff mode and close scratch buffers" })

-- Terminal
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

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then -- Windows-specific configurations.  vim.fn.has("unix") vim.fn.has("mac")
  vim.o.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  vim.o.shellxquote = ""
  vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
  vim.o.shellquote = ""
  vim.o.shellpipe = "| Out-File -Encoding UTF8 %s"
  vim.o.shellredir = "| Out-File -Encoding UTF8 %s"
  -- vim.g.undotree_DiffCommand = "FC" -- Set FC as windows diff equivalent to fix undotree, if its broken.
end

-- have to set <C-_> instead of <C-/> for terminal toggle on CTRL-/.
-- ESC cant be used for leaving terminal if vi keybinds are set in terminal.
vim.keymap.set("n", "<C-_>", function()
  ToggleTerminal()
end, { desc = "Toggle Terminal", noremap = true })

vim.keymap.set("n", "<C-/>", function()
  ToggleTerminal()
end, { desc = "Toggle Terminal", noremap = true })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<C-_>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-/>", [[<C-\><C-n>]], opts)
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
    print("Diagnostics Enabled: ", vim.g.diagnostics_visible)
  else
    vim.g.diagnostics_visible = true
    vim.diagnostic.enable()
    print("Diagnostics Enabled: ", vim.g.diagnostics_visible)
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
    print("Virtual Text Enabled: ", vim.g.virtual_text_visible)
  else
    vim.g.virtual_text_visible = true
    vim.diagnostic.config({ virtual_text = true })
    print("Virtual Text Enabled: ", vim.g.virtual_text_visible)
  end
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>dh",
  ":call v:lua.toggle_virtual_text()<CR>",
  { desc = "[D]iagnostics - Toggle [H]ide Virtual Text", noremap = true, silent = true }
)

vim.g.virtual_lines_on_current_line_visible = false
function _G.toggle_virtual_lines_on_current_line_visible()
  if vim.g.virtual_lines_on_current_line_visible then
    vim.g.virtual_lines_on_current_line_visible = false
    vim.diagnostic.config({ virtual_lines = false })
    print("Virtual Lines on current line enabled: ", vim.g.virtual_lines_on_current_line_visible)
  else
    vim.g.virtual_lines_on_current_line_visible = true
    vim.diagnostic.config({ virtual_lines = { current_line = true } })
    print("Virtual Lines on current line enabled: ", vim.g.virtual_lines_on_current_line_visible)
  end
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>dl",
  ":call v:lua.toggle_virtual_lines_on_current_line_visible()<CR>",
  { desc = "[D]iagnostics - Toggle [H]ide Virtual Lines on current line", noremap = true, silent = true }
)

vim.g.keep_cursor_centered = true
function _G.toggle_keep_cursor_centered()
  if vim.g.keep_cursor_centered then
    vim.opt.scrolloff = 999
    print("Keep Cursor Centered Enabled: ", vim.g.keep_cursor_centered)
    vim.g.keep_cursor_centered = false
  else
    vim.opt.scrolloff = 2
    print("Keep Cursor Centered Enabled: ", vim.g.keep_cursor_centered)
    vim.g.keep_cursor_centered = true
  end
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>z",
  ":call v:lua.toggle_keep_cursor_centered()<CR> :norm zz<cr>",
  { desc = "Toggle keep cursor centered (auto zz)", noremap = true, silent = true }
)

vim.keymap.set("n", "<leader>p", ":cd %:p:h<CR> :pwd<CR>", { desc = "Find Project Root Automatically" })

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

-- NOTE: Some terminals have coliding keymaps or are not able to send distinct keycodes
vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

vim.keymap.set("n", "<leader>gs", "<cmd>G status<cr>", { desc = "[G]it [S]tatus" })
vim.keymap.set("n", "<leader>gl", "<cmd>Gclog<cr>", { desc = "[G]it [L]og" })

vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit (:q)" })
vim.keymap.set("n", "<leader>Q", "<cmd>bd<CR>", { desc = "Close Buffer" })

-- Diagnostic keymaps
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

-- Jump to Visual Studio at the same file (line doesnt work)
function JumpToVisualStudio()
  local file_path, line_number = get_current_file_info()
  local command = string.format("start devenv /Edit %s", file_path)
  os.execute(command)
end

-- Keymaps
vim.keymap.set("n", "<leader>x", JumpToVSCode, { noremap = true, silent = true, desc = "Open current file in VSCode" })
vim.keymap.set("n", "<leader>X", JumpToVisualStudio,
  { noremap = true, silent = true, desc = "Open current file in Visual Studio" })

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

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Setup custom right-click contextual menu",
  callback = function()
    vim.api.nvim_command([[menu PopUp.-3- <NOP>]])
    vim.api.nvim_command([[menu PopUp.-4- <NOP>]])
    vim.api.nvim_command([[menu PopUp.Definition <cmd>Telescope lsp_definitions<CR>]])
    vim.api.nvim_command([[menu PopUp.References <cmd>Telescope lsp_references<CR>]])
    vim.api.nvim_command([[menu PopUp.URL gx]])
    vim.api.nvim_command([[menu PopUp.-5- <NOP>]])
    vim.api.nvim_command([[menu PopUp.Back <C-t>]])
    vim.api.nvim_command([[menu PopUp.-6- <NOP>]])
    vim.api.nvim_command([[menu PopUp.Toggle\ \Breakpoint <cmd>:lua require('dap').toggle_breakpoint()<CR>]])
    vim.api.nvim_command([[menu PopUp.Start\ \Debugger <cmd>:DapContinue<CR>]])
    vim.api.nvim_command([[menu PopUp.Run\ \Test <cmd>:Neotest run<CR>]])
  end,
})

vim.api.nvim_create_user_command("Messages", function()
  -- Capture :messages output
  local messages = vim.api.nvim_exec2("messages", { output = true }).output

  -- Create horizontal split at bottom with height 10
  vim.cmd("botright 10split")
  local msg_buf = vim.api.nvim_create_buf(false, true) -- [listed=false, scratch=true]
  vim.api.nvim_win_set_buf(0, msg_buf)

  -- Set buffer options
  vim.bo[msg_buf].buftype = "nofile"
  vim.bo[msg_buf].bufhidden = "wipe"
  vim.bo[msg_buf].swapfile = false
  vim.bo[msg_buf].modifiable = true

  -- Fill buffer
  vim.api.nvim_buf_set_lines(msg_buf, 0, -1, false, vim.split(messages, "\n"))

  -- Make buffer read-only
  vim.bo[msg_buf].modifiable = false
end, {})

local colors = {
  rosewater = "#f5e0dc",
  flamingo  = "#f2cdcd",
  pink      = "#f5c2e7",
  mauve     = "#cba6f7",
  red       = "#f38ba8",
  maroon    = "#eba0ac",
  peach     = "#fab387",
  yellow    = "#f9e2af",
  green     = "#a6e3a1",
  teal      = "#94e2d5",
  sky       = "#89dceb",
  sapphire  = "#74c7ec",
  blue      = "#89b4fa",
  lavender  = "#b4befe",

  text      = "#cdd6f4",
  subtext1  = "#bac2de",
  subtext0  = "#a6adc8",
  overlay2  = "#9399b2",
  overlay1  = "#7f849c",
  overlay0  = "#6c7086",
  surface2  = "#585b70",
  surface1  = "#45475a",
  surface0  = "#313244",

  base      = "#1e1e2e",
  mantle    = "#181825",
  crust     = "#11111b",
}
-- basic editor UI
vim.api.nvim_set_hl(0, "Normal", { fg = colors.text, bg = colors.base })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.text, bg = colors.mantle })
vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.surface0 })
vim.api.nvim_set_hl(0, "Visual", { bg = colors.surface1 })
vim.api.nvim_set_hl(0, "LineNr", { fg = colors.overlay0 })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.yellow, bold = true })
vim.api.nvim_set_hl(0, "Comment", { fg = colors.overlay1, italic = true })
vim.api.nvim_set_hl(0, "String", { fg = colors.green })
vim.api.nvim_set_hl(0, "Function", { fg = colors.blue, bold = true })
vim.api.nvim_set_hl(0, "Keyword", { fg = colors.mauve, italic = true })
vim.api.nvim_set_hl(0, "WinBar", { fg = colors.text, bg = colors.mantle, bold = true })
vim.api.nvim_set_hl(0, "WinBarNC", { fg = colors.overlay1, bg = colors.mantle })

-- Plugins
local lazypath = vim.fn.stdpath("data") ..
"/lazy/lazy.nvim"                                            -- Install `lazy.nvim` plugin manager https://github.com/folke/lazy.nvim `:help lazy.nvim.txt` for more info
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
  { -- Git related plugins
    "tpope/vim-fugitive",
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
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose" },
    keys = {
      { "<leader>gd", ":DiffviewOpen<cr>",        mode = "", desc = "[G]it [D]iff View" },
      { "<leader>go", ":DiffviewOpen ",           mode = "", desc = "[G]it Diff View [O]pen" },
      { "<leader>gh", ":DiffviewFileHistory<cr>", mode = "", desc = "[G]it Diff View File [H]istory" },
      { "<leader>gc", ":DiffviewClose<cr>",       mode = "", desc = "[G]it Diff View [C]lose" },
    },
  },
  { -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",
  },
  { -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "benfowler/telescope-luasnip.nvim", event = "BufEnter" },
    },
    config = function()
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
        local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")
        [1]
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
      vim.keymap.set("n", "<leader>fc",
        function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Class" }, prompt_title =
          "Search Classes" }) end, { desc = "[F]ind [C]lass" })
      vim.keymap.set("n", "<leader>fd",
        function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Function", "Method" }, prompt_title =
          "Search Functions" }) end, { desc = "[F]ind Function [D]efinition" })
      vim.keymap.set("n", "<leader>fv",
        function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Variable", "Constant" }, prompt_title =
          "Search Variables" }) end, { desc = "[F]ind [V]ariable" })
    end
  },
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
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
    end
  },
  {
    -- LSP CONFIG
    "neovim/nvim-lspconfig",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "seblyng/roslyn.nvim" },
      { "mason-org/mason-lspconfig.nvim" },
      { "mason-org/mason.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { "mfussenegger/nvim-lint" },
      {
        'Issafalcon/lsp-overloads.nvim',
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
      require("mason").setup({
        registries = { "github:crashdummyy/mason-registry", "github:mason-org/mason-registry" },
      })
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
          "roslyn",    -- LSP
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

      require("roslyn").setup()
      -- Keymaps only set when an LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local bufnr = ev.buf

          vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr, desc = "[R]ename" })
          vim.keymap.set("n", "<leader>C", vim.lsp.buf.code_action,
            { buffer = bufnr, desc = "Code Action (Builtin LSP)" })
          vim.keymap.set('n', '<leader>Ff', vim.lsp.buf.format,
            { noremap = true, silent = true, desc = 'Format buffer with LSP' })

          vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions,
            { buffer = bufnr, desc = "[G]oto [D]efinition" })
          vim.keymap.set("n", "gr", "<Nop>", { noremap = true })
          vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references,
            { buffer = bufnr, desc = "[G]oto [R]eferences", nowait = true })

          vim.keymap.set("n", "gI", require("telescope.builtin").lsp_implementations,
            { buffer = bufnr, desc = "[G]oto [I]mplementation" })
          vim.keymap.set("n", "gD", require("telescope.builtin").lsp_type_definitions,
            { buffer = bufnr, desc = "Type [D]efinition" })
          vim.keymap.set("n", "gR", vim.lsp.buf.declaration, { buffer = bufnr, desc = "[G]oto [D]eclaration" })

          vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Documentation" })

          vim.keymap.set("n", "<leader>wd", require("telescope.builtin").lsp_document_symbols,
            { buffer = bufnr, desc = "[D]ocument Symbols" })
          vim.keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols,
            { buffer = bufnr, desc = "[W]orkspace [S]ymbols" })

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

          vim.keymap.set("i", "<A-s>", "<cmd>LspOverloadsSignature<CR>",
            { desc = "Lsp Overloads Signature", noremap = true, silent = true, buffer = bufnr })
          vim.keymap.set("n", "<A-s>", "<cmd>LspOverloadsSignature<CR>",
            { desc = "Lsp Overloads Signature", noremap = true, silent = true, buffer = bufnr })

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
    dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
    config = function()
      require("easy-dotnet").setup()
    end
  },
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
        enabled = function()
          local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
          if buftype == "prompt" then return false end
          return true
        end,
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
          ["<C-u>"] = cmp.mapping.scroll_docs(4),
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
          { name = "luasnip",                 group_index = 3 },
          { name = "nvim_lsp",                group_index = 1 },
          { name = "nvim_lua",                group_index = 2 },
          { name = "path",                    group_index = 2 },
          { name = "buffer",                  group_index = 2, keyword_length = 2 },
          { name = "calc",                    group_index = 2, max_item_count = 5 },
          { name = "emoji",                   group_index = 2, max_item_count = 5 },
          { name = "nerdfont",                group_index = 2, max_item_count = 5 },
          { name = "greek",                   group_index = 2, max_item_count = 5 },
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
  {
    "folke/which-key.nvim",
    event = "UIEnter",
    config = function()
      require("which-key").setup({
        preset = "modern",
        sort = { "group", "alphanum", "mod" },
      })
      require("which-key").add({
        { "<leader>B",  group = "[B]ug" },
        { "<leader>B_", hidden = true },
        { "<leader>R",  group = "[R]un" },
        { "<leader>R_", hidden = true },
        { "<leader>T",  group = "[T]est" },
        { "<leader>T_", hidden = true },
        { "<leader>d",  group = "[D]iagnostics" },
        { "<leader>d_", hidden = true },
        { "<leader>f",  group = "[F]ind" },
        { "<leader>f_", hidden = true },
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
        { "<leader>1",  hidden = true },
        { "<leader>2",  hidden = true },
        { "<leader>3",  hidden = true },
        { "<leader>4",  hidden = true },
        { "<leader>5",  hidden = true },
        { "<leader>6",  hidden = true },
        { "<leader>7",  hidden = true },
        { "<leader>8",  hidden = true },
        { "<leader>9",  hidden = true },
      }, {
        { "<leader>",  group = "VISUAL <leader>", mode = "v" },
        { "<leader>h", desc = "Git [H]unk",       mode = "v" },
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
    "lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
    lazy = false,
    main = "ibl",
    opts = {},
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
      { "<leader>BB", function() require("dapui").toggle() end,                                      desc = "Debug: See last session result." },
      { "<leader>Bc", function() require("dap").run_to_cursor() end,                                 desc = "Debug: Run to Cursor" },
      { "<leader>BR", function() require("dap").repl.toggle() end,                                   desc = "Debug: Toggle REPL" },
      { "<leader>BJ", function() require("dap").down() end,                                          desc = "Debug: Go Down Stack Frame" },
      { "<leader>BK", function() require("dap").up() end,                                            desc = "Debug: Go Up Stack Frame" },
      { "<leader>BQ", function()
        require("dap").terminate(); require("dap").clear_breakpoints()
      end,                                                                                           desc = "Debug: Terminate and Clear Breakpoints" },
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
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          "netcoredbg",
          "coreclr"
        },
      })
      -- dap.adapters.coreclr = {
      --   type = "executable",
      --   command = "netcoredbg",
      --   args = { "--interpreter=vscode" },
      -- }

      -- .NET specific setup using `easy-dotnet`
      local function rebuild_project(co, path)
        local spinner = require("easy-dotnet.ui-modules.spinner").new()
        spinner:start_spinner "Building"
        vim.fn.jobstart(string.format("dotnet build %s", path), {
          on_exit = function(_, return_code)
            if return_code == 0 then
              spinner:stop_spinner "Built successfully"
            else
              spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
              error "Build failed"
            end
            coroutine.resume(co)
          end,
        })
        coroutine.yield()
      end

      require("easy-dotnet.netcoredbg").register_dap_variables_viewer() -- special variables viewer specific for .NET
      local dotnet = require("easy-dotnet")
      local debug_dll = nil

      local function ensure_dll()
        if debug_dll ~= nil then
          return debug_dll
        end
        local dll = dotnet.get_debug_dll(true)
        debug_dll = dll
        return dll
      end

      for _, value in ipairs({ "cs", "fsharp" }) do
        dap.configurations[value] = {
          {
            type = "coreclr",
            name = "Program",
            request = "launch",
            env = function()
              local dll = ensure_dll()
              local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
              return vars or nil
            end,
            program = function()
              local dll = ensure_dll()
              local co = coroutine.running()
              rebuild_project(co, dll.project_path)
              return dll.relative_dll_path
            end,
            cwd = function()
              local dll = ensure_dll()
              return dll.relative_project_path
            end
          },
          {
            type = "coreclr",
            name = "Test",
            request = "attach",
            processId = function()
              local res = require("easy-dotnet").experimental.start_debugging_test_project()
              return res.process_id
            end
          }
        }
      end

      -- Reset debug_dll after each terminated session
      dap.listeners.before['event_terminated']['easy-dotnet'] = function()
        debug_dll = nil
      end

      dap.adapters.coreclr = {
        type = "executable",
        -- command = "netcoredbg",
        command = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe",
        args = { "--interpreter=vscode" },
      }

      -- dap.adapters.netcoredbg = {
      --   type = "executable",
      --   command = "netcoredbg",
      --   args = { "--interpreter=vscode" },
      -- }

      -- dap.configurations.cs = {
      --   {
      --     type = "coreclr",
      --     name = "launch - netcoredbg",
      --     request = "launch",
      --     program = function()
      --       return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/src/", "file")
      --     end,
      --   },
      -- }
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
  { "ryanoasis/vim-devicons",             event = "UIEnter" },
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
  { "andymass/vim-matchup",               lazy = false,       config = function() vim.g.loaded_matchit = 1 end },
  { "brenoprata10/nvim-highlight-colors", event = "BufEnter", config = function() require("nvim-highlight-colors").setup() end },
  {
    "petertriho/nvim-scrollbar",
    event = "UIEnter",
    config = function()
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
  { "mbbill/undotree",       keys = { { "<leader>u", vim.cmd.UndotreeToggle, mode = "", desc = "[U]ndotree Toggle" } } },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    -- follow latest release.
    version = "*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    keys = { { "<leader>n", ":NvimTreeToggle<cr>", mode = "", desc = "[N] Filetree Toggle" } },
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
        vim.keymap.set('n', 'A', function()
          local node = api.tree.get_node_under_cursor()
          local path = node.type == "directory" and node.absolute_path or vim.fs.dirname(node.absolute_path)
          require("easy-dotnet").create_new_item(path)
        end, opts('Create file from dotnet template'))
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
    "luukvbaal/statuscol.nvim",
    lazy = false,
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        segments = {
          {
            sign = {
              namespace = { "gitsigns" },
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
          {
            sign = {
              namespace = { "diagnostic*" },
              maxwidth = 1,
              colwidth = 1,
              auto = true,
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
    lazy = false,
    dependencies = {
      "kevinhwang91/promise-async",
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
      vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
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
  { "numToStr/Comment.nvim", event = "BufEnter", opts = {} },
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

-- Uninstall and reinstall repo from https://github.com/wilfriedbauer/nvim:
-- # Linux or MacOS (unix)
-- rm -rf ~/.config/nvim
-- rm -rf ~/.local/share/nvim
--
-- # Windows
-- rd -r ~\AppData\Local\nvim
-- rd -r ~\AppData\Local\nvim-data
