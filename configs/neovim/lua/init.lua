
-- Add some aliases for Neovim Lua API
local o = vim.o
local wo = vim.wo
local g = vim.g
local cmd = vim.cmd


o.scrolloff  = 10   -- start scrolling when cursor is within 5 lines of the ledge
o.linebreak  = true -- soft wraps on words not individual chars
o.mouse      = 'a'  -- enable mouse support in all modes
o.updatetime = 300
o.autochdir  = true
o.exrc       = true -- allow project specific config in .nvimrc or .exrc files

-- Search and replace
o.ignorecase = true      -- make searches with lower case characters case insensative
o.smartcase  = true      -- search is case sensitive only if it contains uppercase chars
o.inccommand = 'nosplit' -- show preview in buffer while doing find and replace

-- Tab key behavior
o.expandtab  = true      -- Convert tabs to spaces
o.tabstop    = 2         -- Width of tab character
o.shiftwidth = o.tabstop -- Width of auto-indents

-- Set where splits open
o.splitbelow = true -- open horizontal splits below instead of above which is the default
o.splitright = true -- open vertical splits to the right instead of the left with is the default

-- Some basic autocommands
if g.vscode == nil then
end

- UI ----------------------------------------------------------------------------------------------

-- Set UI related options
o.termguicolors   = true
o.showmode        = false    -- don't show -- INSERT -- etc.
wo.colorcolumn    = '100'    -- show column boarder
wo.number         = true     -- display numberline
wo.relativenumber = true     -- relative line numbers
wo.cursorline     = true     -- highlight current line
wo.cursorlineopt  = 'number' -- only highlight the number of the cursorline
wo.signcolumn     = 'yes'    -- always have signcolumn open to avoid thing shifting around all the time
o.fillchars       = 'stl: ,stlnc: ,vert:·,eob: ' -- No '~' on lines after end of file, other stuff
