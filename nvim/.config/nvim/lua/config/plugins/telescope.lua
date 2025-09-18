return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = "Telescope",
    keys = {
      -- File finding (same as your current setup)
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      -- Search sources (same as your current setup)
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Search command history" },
      { "<leader>ss", "<cmd>Telescope search_history<cr>", desc = "Search search history" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Search commands" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Search keymaps" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Search marks" },
    },
  },
}
