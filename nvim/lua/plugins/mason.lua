return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    ensure_installed = {
      "lua_ls",
      "rust_analyzer",
      "vtsls",
    },
  },
  dependencies = {
    { 
      "mason-org/mason.nvim", 
      opts = {
        ensure_installed = {
          -- Formatters
          "stylua",
          "prettier",
          "eslint_d",
          "biome",
          "black",
          "isort",
          -- Linters (eslint_d already listed above)
          -- Note: biomejs is the same as biome for Mason
        },
      }
    },
    "neovim/nvim-lspconfig",
  },
}
