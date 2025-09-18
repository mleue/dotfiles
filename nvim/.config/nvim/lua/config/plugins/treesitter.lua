return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "lua", "vim", "python", "rust", "typescript" },
        sync_install = false,  -- Install parsers synchronously (only applied to `ensure_installed`)
        auto_install = false,  -- Don't automatically install missing parsers
        highlight = { enable = true },
      }
    end,
  },
}
