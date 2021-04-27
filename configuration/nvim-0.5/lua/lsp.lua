-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local nvim_lsp = require('lspconfig')
local lsp_plugins = {
    pyright = {

    },
    bashls = {},
    dockerls = {},
    graphql = {},
    gopls = {},
    phpactor = {
        cmd = { "phpactor", "language-server" },
        filetypes = { "php" },
        root_dir = nvim_lsp.util.root_pattern("composer.json", ".git"),
    },
    intelephense = {
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php" },
        root_dir = nvim_lsp.util.root_pattern("composer.json", ".git"),
    },
    tsserver = {},
    vimls = {},
    vuels = {},
    yamlls = {},
    jsonls = {},
    cssls = {},
    html = {},
    elixirls = {
        filetypes = { "elixir", "eelixir", "ex", "exs"},
        cmd = { "~/.helpers/elixir-ls/language_server.sh" };
    },
}

local on_attach = function(client, bufnr)
  -- print('onattch called!', client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  -- https://oroques.dev/notes/neovim-init/
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', ',wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', ',wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', ',wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', ',D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', ',rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', ',ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', ',e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', ',q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', ',rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", ",f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", ",f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

for plugin, plugin_options in pairs(lsp_plugins) do
    local options = { capabilities = capabilities, autostart = true, on_attach = on_attach }
    for option_key, option_value in pairs(plugin_options) do 
        options[option_key] = option_value
    end

    -- print('plugin registered!', plugin)
    nvim_lsp[plugin].setup(options)
end

require('lspkind').init({
    -- with_text = true,
    -- symbol_map = {
    --   Text = '?',
    --   Method = '?',
    --   Function = '?',
    --   Constructor = '?',
    --   Variable = '?',
    --   Class = '?',
    --   Interface = '?',
    --   Module = '?',
    --   Property = '?',
    --   Unit = '?',
    --   Value = '?',
    --   Enum = '?',
    --   Keyword = '?',
    --   Snippet = '?',
    --   Color = '?',
    --   File = '?',
    --   Folder = '?',
    --   EnumMember = '?',
    --   Constant = '?',
    --   Struct = '?'
    -- },
})
