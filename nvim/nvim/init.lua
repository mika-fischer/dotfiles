--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------
vim.opt.compatible = false
vim.cmd.syntax("on")

-- Use space bar as leader (needs to be set before loading lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd.filetype("plugin indent on")

-- Override non-UTF-8 locale
-- vim.cmd.scriptencoding("utf-8")
vim.opt.encoding = "utf-8"

-- Listchars
vim.opt.list = true
vim.opt.listchars = { tab = "»·", trail = "·" }

-- Always keep n lines visible above and below the cursor
vim.opt.scrolloff = 3

-- Enable auto-indentation
vim.opt.autoindent = true

-- Show incomplete commands
vim.opt.showmode = true

-- Indicate matching brackets
vim.opt.showmatch = true

-- Hide buffers
vim.opt.hidden = true

-- Nicer completion
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"

-- Highlight cursor line
vim.opt.cursorline = true

-- Show current position
vim.opt.ruler = true

-- Make backspace more powerful
vim.opt.backspace = "indent,eol,start"

-- Always display status line
vim.opt.laststatus = 2

-- Don't make backups
vim.opt.backup = false

-- Remember more recent commands
vim.opt.history = 50

-- Enable incremental search
vim.opt.incsearch = true

-- Enable search match highlighting
vim.opt.hlsearch = true

-- Display line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Terminal mouse support
-- vim.opt.ttymouse = "xterm"
vim.opt.mouse = "a"

-- Use existing windows when jumping to errors etc.
vim.opt.switchbuf = "useopen"

-- Tab settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smarttab = true

-- Insert mode completion behavior
vim.opt.completeopt = "menuone,menu,longest,preview"

-- Use rg instead of grep
vim.opt.grepprg = "rg"

-- Go to last position in file
--au BufReadPost *
            --\ if line("'\"") > 0 && line("'\"") <= line("$") |
            --\   exe "normal g`\"" |
            --\ endif

--------------------------------------------------------------------------------
-- Appearance
--------------------------------------------------------------------------------
vim.opt.background = dark
--if has("gui_running")
    --set guioptions+=c
    --set guioptions-=m
    --set guioptions-=L
    --set guioptions-=r
    --set guioptions-=T
    --if has("gui_gtk2")
        --set guifont=Monospace\ 8
    --elseif has("gui_win32")
        --set guifont=Consolas:h10
    --endif
--else
vim.opt.titlestring = "[%t]%(\\%m%r%)"
vim.opt.titlelen = 15
vim.opt.title = true
    --if &term =~ '^screen'
        --set t_ts=k
        --set t_fs=\
        --" let &titleold = fnamemodify(&shell, ":t")
    --endif
--endif
vim.g.have_nerd_font = true

-- Lazy
require("config.lazy")

vim.cmd.colorscheme("onedark_vivid")

--------------------------------------------------------------------------------
-- Key bindings
--------------------------------------------------------------------------------

-- Disable arrow keys and navigation keys
for _, key in ipairs({'<up>', '<down>', '<left>', '<right>', '<pageup>', '<pagedown>', '<home>', '<end>', '<insert>', '<delete>', '<f1>'}) do
    for _, mode in ipairs({'n', 'i', 'v'}) do
        vim.keymap.set(mode, key, '<nop>')
    end
end

-- Mappings
vim.keymap.set('n', '<C-j>', '<nop>')
vim.keymap.set('n', '<C-k>', '<nop>')
vim.keymap.set('n', '<C-h>', '<C-w>w')
vim.keymap.set('n', '<C-l>', '<C-w>W')
vim.keymap.set('n', '<C-d>', '<C-w>q')

vim.keymap.set('n', '<leader>h', ":noh<cr>")
vim.keymap.set('n', '<leader>r', ":redraw!<cr>")
-- vim.keymap.set('n', '<leader>f', "zA<cr>")
-- vim.keymap.set('n', '<silent><leader>w :if &fo=~'t' | setl fo-=t | else | setl fo+=t | endif<cr>

vim.keymap.set('n', '<silent><leader><leader>', ":CtrlP<cr>")

vim.keymap.set('n', '<leader>u', ":GundoToggle<cr>")

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
-- Disable matchparen, as it's often slow
loaded_matchparen = 1

require('lualine').setup {
    options = { theme = 'onedark' }
}

require('gitsigns').setup()

