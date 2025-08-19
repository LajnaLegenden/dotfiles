return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      "lua_ls",
      "rust_analyzer",
      "tsserver",
      "eslint-lsp"
    },
  },
  dependencies = {
    "neovim/nvim-lspconfig",
  },
}
