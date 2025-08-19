require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "eslint_d", "prettier", "biome" },
      typescript = { "eslint_d", "prettier", "biome" },
      javascriptreact = { "eslint_d", "prettier", "biome" },
      typescriptreact = { "eslint_d", "prettier", "biome" },
      json = { "prettier", "biome" },
      jsonc = { "prettier", "biome" },
      css = { "prettier", "biome" },
      scss = { "prettier", "biome" },
      html = { "prettier", "biome" },
      markdown = { "prettier", "biome" },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Set up format-on-save
    format_on_save = { timeout_ms = 500 },
    -- Customize formatters with conditional detection
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
      eslint_d = {
        require_cwd = true,
        cwd = require("conform.util").root_file({
            ".eslintrc",
            ".eslintrc.json",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            "eslint.config.js",
            "eslint.config.mjs",
            "eslint.config.cjs",
          }),
      },
      
      prettier = {
        require_cwd = true,
        cwd = require("conform.util").root_file({
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.yaml",
            ".prettierrc.yml",
            ".prettierrc.json5",
            ".prettierrc.mjs",
            ".prettierrc.toml",
            "prettier.config.js",
            "prettier.config.cjs",
            "prettier.config.mjs",
            })
        },
      biome = {
        require_cwd = true,
        cwd = require("conform.util").root_file({
            "biome.json",
            "biome.jsonc",
          })
      },
    },
  })

--bind leader lf to format
vim.keymap.set("n", "<leader>lf", function()
  require("conform").format({ async = true })
end)