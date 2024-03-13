-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local nmap = function(keys, func, desc, bufnr)
  if desc then
    desc = 'LSP: ' .. desc
  end

  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

local on_attach_base = function(_, bufnr)
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame', bufnr)
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', bufnr)

  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition', bufnr)
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols', bufnr)
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols', bufnr)

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation', bufnr)
  nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation', bufnr)

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', bufnr)
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder', bufnr)
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder', bufnr)
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders', bufnr)

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local on_attach = function(_, bufnr)
  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition', bufnr)
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences', bufnr)
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation', bufnr)
  on_attach_base(_, bufnr)
end

local on_attach_omnisharp = function(_, bufnr)
  vim.api.nvim_set_keymap('n', 'gr', "<cmd>lua require('omnisharp_extended').telescope_lsp_references()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gd', "<cmd>lua require('omnisharp_extended').telescope_lsp_definition()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gI', "<cmd>lua require('omnisharp_extended').telescope_lsp_implementation()<CR>", { noremap = true, silent = true })
  on_attach_base(_, bufnr)
end

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
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
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
  ['omnisharp'] = function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach_omnisharp,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
      organize_imports_on_format = true,
      enable_import_completion = true,
    }
  end,
}
