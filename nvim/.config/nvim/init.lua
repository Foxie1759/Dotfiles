-- my neovim config uwu

-- functionality setup
local set = vim.opt
set.number=true
set.relativenumber=true
set.shiftwidth=8
set.termguicolors = true

--plugin setup
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use 'https://gitlab.com/__tpb/monokai-pro.nvim'
    use { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig", }
    --use { 'AlphaTechnolog/pywal.nvim', as = 'pywal' }
    use {
	"windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
}
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'norcalli/nvim-colorizer.lua'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use "rafamadriz/friendly-snippets"
    use 'andweeb/presence.nvim'
    use { "catppuccin/nvim", as = "catppuccin" }
    use 'echasnovski/mini.nvim'
if packer_bootstrap then
    require('packer').sync()
  end
end)

--lspserver Setup
require("mason").setup {
    ui = {
        icons = {
            package_installed = "✓",
	    package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
}
require("mason-lspconfig").setup {
    ensure_installed = { "sumneko_lua" },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'bashls', 'pyright', 'sumneko_lua', 'clangd', 'html','cssls'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

--theme setup
--require'colorizer'.setup{
--    '*';
--    css = { rgb_fn = true;RRGGBBAA = true; };
--}
--require('pywal').setup()
--require('lualine').setup {
--  options = {
--    theme = 'monokaipro',
--    --theme = 'pywal',
--  }
--}
require("presence"):setup({
	 auto_update         = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
    neovim_image_text   = "NEOVIM", -- Text displayed when hovered over the Neovim image
    main_image          = "neovim",                   -- Main image display (either "neovim" or "file")
    client_id           = "793271441293967371",       -- Use your own Discord application client id (not recommended)
    log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
    enable_line_number  = false,                      -- Displays the current line number instead of the current project
    blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
    buttons             = true,                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
    file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
    show_time           = true,                       -- Show the timer

    -- Rich Presence text options
    editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
})

require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false,
    term_colors = false,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        mini = false,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})
vim.cmd.colorscheme "catppuccin"

require('mini.starter').setup({
  -- Whether to open starter buffer on VimEnter. Not opened if Neovim was
  -- started with intent to show something else.
  autoopen = true,

  -- Whether to evaluate action of single active item
  evaluate_single = false,

  -- Items to be displayed. Should be an array with the following elements:
  -- - Item: table with <action>, <name>, and <section> keys.
  -- - Function: should return one of these three categories.
  -- - Array: elements of these three types (i.e. item, array, function).
  -- If `nil` (default), default items will be used (see |mini.starter|).
  items = nil,

  -- Header to be displayed before items. Converted to single string via
  -- `tostring` (use `\n` to display several lines). If function, it is
  -- evaluated first. If `nil` (default), polite greeting will be used.
  header = nil,

  -- Footer to be displayed after items. Converted to single string via
  -- `tostring` (use `\n` to display several lines). If function, it is
  -- evaluated first. If `nil` (default), default usage help will be shown.
  footer = nil,

  -- Array  of functions to be applied consecutively to initial content.
  -- Each function should take and return content for 'Starter' buffer (see
  -- |mini.starter| and |MiniStarter.content| for more details).
  content_hooks = nil,

  -- Characters to update query. Each character will have special buffer
  -- mapping overriding your global ones. Be careful to not add `:` as it
  -- allows you to go into command mode.
  query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
})



-- setup must be called before loading
--vim.cmd[[hi Normal ctermbg=none guibg=none]]
--vim.cmd[[hi NormalNC ctermbg=none guibg=none]]
--vim.cmd[[hi Comment ctermbg=none guibg=none]]
--vim.cmd[[hi Constant ctermbg=none guibg=none]]
--vim.cmd[[hi Special ctermbg=none guibg=none]]
--vim.cmd[[hi Identifier ctermbg=none guibg=none]]
--vim.cmd[[hi Statement ctermbg=none guibg=none]]
--vim.cmd[[hi PreProc ctermbg=none guibg=none]]
--vim.cmd[[hi Type ctermbg=none guibg=none]]
--vim.cmd[[hi Underlined ctermbg=none guibg=none]]
--vim.cmd[[hi Todo ctermbg=none guibg=none]]
--vim.cmd[[hi String ctermbg=none guibg=none]]
--vim.cmd[[hi Function ctermbg=none guibg=none]]
--vim.cmd[[hi Conditional ctermbg=none guibg=none]]
--vim.cmd[[hi Repeat ctermbg=none guibg=none]]
--vim.cmd[[hi Operator ctermbg=none guibg=none]]
--vim.cmd[[hi Structure ctermbg=none guibg=none]]
--vim.cmd[[hi LineNr ctermbg=none guibg=none]]
--vim.cmd[[hi NonText ctermbg=none guibg=none]]
--vim.cmd[[hi SignColumn ctermbg=none guibg=none]]
--vim.cmd[[hi CursorLineNr ctermbg=none guibg=none]]
--vim.cmd[[hi EndOfBuffer ctermbg=none guibg=none]]
