return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {},
  },
  keys = {
    -- Top Pickers & Explorer
    { "<leader>t",   function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
    { "<leader>fg",  function() Snacks.picker.grep() end,                                    desc = "Grep" },
    -- find
    { "<leader>fc",  function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff",  function() Snacks.picker.files() end,                                   desc = "Find Files" },
    { "<leader>s",   function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { "<leader>fkm", function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
    { "<leader>fq",  function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
    { "<leader>uC",  function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
  }
}
