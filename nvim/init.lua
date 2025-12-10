--Basic Neovim settingvim.g.mapleader = ‘;s in Lua
vim.g.mapleader = ','

-- Enable line numbers and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Set tab settings
vim.opt.tabstop = 4            -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4         -- Number of spaces to use for autoindent
vim.opt.softtabstop = 4       -- Convert tabs to spaces
vim.opt.expandtab = true       -- Convert tabs to spaces

-- Enable cursorline to highlight the current line
vim.opt.cursorline = true

-- Enable system clipboard
vim.opt.clipboard = 'unnamedplus'

-- Searching settings
vim.opt.ignorecase = true      -- Case-insensitive searching
vim.opt.smartcase = true       -- Case-sensitive if search contains uppercase
vim.opt.hlsearch = true        -- Highlight search matches
vim.opt.incsearch = true       -- Incremental search

-- Enable mouse support
vim.o.mouse = 'a'

-- Disable swap files
vim.opt.swapfile = false

-- Set split behavior
vim.opt.splitright = true      -- Open new vertical splits to the right
vim.opt.splitbelow = true      -- Open new horizontal splits below

-- Enable true colors in terminal
vim.opt.termguicolors = true

-- Set timeout length for key mappings
vim.opt.timeoutlen = 300

-- Key mappings
-- Set multiple column limits at 80 and 120 characters
vim.opt.colorcolumn = "80,120"
-- Set color of the column limit line
vim.api.nvim_set_hl(0, 'ColorColumn', { ctermbg=0, bg='#2E3440' })  -- Customize the background color

-- Disable the banner in netrw
vim.g.netrw_banner = 0

-- Set the list style (3 for tree view)
vim.g.netrw_liststyle = 3

-- Open files in a new split window
vim.g.netrw_browse_split = 4

-- Use the alternate vertical window layout
vim.g.netrw_altv = 1

-- Set the size of the netrw window to 25%
vim.g.netrw_winsize = 25

vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000


vim.api.nvim_set_keymap('n', '<S-e>', ':Lexplore <cr>', { noremap = true, silent = true })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command


local latex_group = augroup("AutoLaTeX",{clear = true})

autocmd("BufWritePost", {
  pattern = "*.tex",
  command = "silent! !pdflatex -interaction=nonstopmode -halt-on-error %:p",
  group = latex_group
})

-- 1️⃣ Cursor position on file reopen
autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end
})


function OpenPWshInCwd()
  local cwd = vim.fn.expand('%:p:h')
  if cwd == "" then
    cwd = vim.fn.getcwd()
  end
  cwd = cwd:gsub("\\", "/")

  -- abre vsplit y muévete a él
  vim.cmd('vsplit')
  vim.cmd('wincmd l')

  -- reemplaza ese split con la terminal
  vim.cmd('enew')  -- asegura buffer limpio
  vim.fn.termopen({"pwsh.exe", "-NoExit", "-Command", "Set-Location -LiteralPath '" .. cwd .. "'"})

  -- modo insert automático
  vim.cmd('startinsert')
end
usercmd('PWshTerm', OpenPWshInCwd, {})

vim.opt.undofile = true
-- Set undo directory
vim.opt.undodir = { vim.fn.stdpath('data') .. '/undo' }

-- Make directory if it doesn't exist
local undodir = vim.opt.undodir:get()[1]
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, 'p')
end

vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

-- 3️⃣ Auto-save on buffer leave or exit
vim.opt.autowrite = true

-- 4️⃣ History of commands and searches
vim.opt.history = 1000
vim.opt.shada = "!,'1000,<50,s10,h"


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "folke/lazy.nvim" }, -- lazy.nvim can manage itself
    { "sainnhe/everforest", priority=1000 },

    { "junegunn/fzf", run = './install --bin' },
    { "junegunn/fzf.vim", dependencies = { "junegunn/fzf" } },

    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/nvim-cmp" },

    { "L3MON4D3/LuaSnip" } ,
    { "saadparwaiz1/cmp_luasnip" },

    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/nvim-treesitter-context" },
  },
  checker = { enabled = true },
})



vim.api.nvim_set_keymap('n', '<C-p>', ':Files<CR>', { noremap = true, silent = true })

vim.o.background = "dark"  -- O "light" si prefieres la versión clara
vim.g.everforest_background = "hard"   -- 'soft', 'medium' o 'hard'
vim.cmd([[colorscheme everforest]])


require("mason").setup()
require("mason-lspconfig").setup()


-- Function to set keybindings for LSP
local on_attach = function(_, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.api.nvim_buf_set_option(bufnr, 'fileencoding', 'utf-8')
  -- Mapeos comunes de LSP
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)       -- Ir a la definición
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)      -- Ir a la declaración
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)   -- Ir a la implementación
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)       -- Buscar referencias
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)             -- Mostrar información flotante
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)-- Ayuda de firma
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)    -- Renombrar símbolo
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)-- Acciones de código
  vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format({ async = true })                           -- Formatear código
  end, bufopts)

  -- Otros comandos opcionales
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, bufopts) -- Mostrar diagnóstico
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)         -- Ir al diagnóstico anterior
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)         -- Ir al siguiente diagnóstico
end






local cmp = require'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
    }, {
            { name = 'buffer' },
        })
})
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
            { name = 'cmdline' }
        }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local util = require("lspconfig.util")

vim.lsp.config("clangd", {
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = vim.fs.dirname(
        vim.fs.find({ "compile_commands.json", ".git", "CMakeLists.txt" }, 
        { upward = true })[1]
    ),
    capabilities = capabilities,
    on_attach = on_attach,
})

vim.lsp.config("pyright", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        pyright = { autoImportCompletion = true },
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "off",
                useLibraryCodeForTypes = true,
            }
        }
    }
})

vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },  -- <-- ¡IMPORTANTE! Esto falta
    settings = {
        Lua = {
            codeLens = { enable = true },
            hint = { enable = true, semicolon = "Disable" },
        }
    },
    on_attach = on_attach,
    capabilities = capabilities
})

-- Configuración de gopls (LSP para Go)
vim.lsp.config("gopls", {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = vim.fs.dirname(
        vim.fs.find({ "go.mod", ".git", "go.work" }, 
        { upward = true })[1]
    ),
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
                unusedparams = true,
            },

        }
    }
})

require("nvim-treesitter.configs").setup({
    -- A list of parser names
    ensure_installed = {
        "vimdoc",
        "javascript",
        "typescript",
        "c",
        "lua",
        "rust",
        "jsdoc",
        "bash",
        "go",
        "python",  -- Añadido para Python
        "cpp",     -- Añadido para C++
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    indent = {
        enable = true,
    },

    highlight = {
        -- `false` will disable the whole extension
        enable = true,
        disable = function(lang, buf)
            if lang == "html" then
                return true
            end

            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                vim.notify(
                    "File larger than 100KB treesitter disabled for performance",
                    vim.log.levels.WARN,
                    { title = "Treesitter" }
                )
                return true
            end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        additional_vim_regex_highlighting = false,
    },
})


local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
treesitter_parser_config.templ = {
    install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
    },
}
vim.treesitter.language.register("templ", "templ")

-- Configuración de treesitter-context
require("treesitter-context").setup({
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false, -- Enable multiwindow support.
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20, -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
})


vim.opt.grepprg="rg --vimgrep -uu --no-hidden --no-heading --smart-case"
vim.opt.grepformat= "%f:%l:%c:%m"

vim.keymap.set('n', '<leader>ps', function()
    vim.cmd('grep! ' .. vim.fn.input("grep > "))
    vim.cmd('copen')
end)
