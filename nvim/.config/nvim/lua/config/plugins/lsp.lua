return {
  -- Mason for installing LSP servers
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { 
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- Setup mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "ruff", "lua_ls" },
        automatic_installation = true,
      })
      
      -- Setup LSP servers
      local lspconfig = require('lspconfig')
      local capabilities = nil
      
      -- Try to get blink.cmp capabilities if available
      local ok, blink = pcall(require, 'blink.cmp')
      if ok then
        capabilities = blink.get_lsp_capabilities()
      end
      
      -- Setup function for keymaps
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>cf', function()
          vim.lsp.buf.format { async = true }
        end, opts)
      end
      
      -- Get list of servers installed by mason
      local mason_lspconfig = require("mason-lspconfig")
      local installed_servers = mason_lspconfig.get_installed_servers()
      
      -- Setup each server
      for _, server_name in ipairs(installed_servers) do
        if server_name == "lua_ls" then
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              Lua = {
                diagnostics = { globals = {'vim'} },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
              },
            },
          })
        else
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        end
      end
      
      -- Auto-setup servers when they're installed
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsInstallPost",
        callback = function()
          -- Restart LSP servers after new installations
          vim.cmd("LspStop")
          vim.cmd("LspStart")
        end,
      })
    end,
  },
}
