return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      sources = {
        git_changed_files = {
          finder = function(opts, ctx)
            local items = {}
            local cwd = opts.cwd or vim.fn.getcwd()
            
            -- Execute the git command
            local cmd = "cd " .. vim.fn.shellescape(cwd) .. " && " ..
                        "git diff --name-only $(git merge-base origin/master HEAD) && " ..
                        "git ls-files --others --exclude-standard"
            
            local handle = io.popen(cmd)
            if not handle then
              return {}
            end
            
            local output = handle:read("*a")
            handle:close()
            
            -- Process each file
            for file in output:gmatch("[^\r\n]+") do
              if file and file ~= "" then
                local full_path = vim.fn.fnamemodify(cwd .. "/" .. file, ":p")
                
                -- Check if file exists (it might be deleted)
                if vim.fn.filereadable(full_path) == 1 then
                  table.insert(items, {
                    text = file,  -- relative path for display
                    file = full_path,  -- absolute path for opening
                    pos = {1, 1},  -- start at beginning of file
                  })
                end
              end
            end
            
            return items
          end,
          format = "file",  -- Use built-in file formatter
          preview = "file", -- Use built-in file previewer
          title = "Git Changed Files",
          win = {
            input = {
              keys = {
                ["<c-s>"] = { "edit_split", mode = { "n", "i" } },    -- Split horizontally
                ["<c-v>"] = { "edit_vsplit", mode = { "n", "i" } },  -- Split vertically
                ["<c-t>"] = { "tab", mode = { "n", "i" } },          -- Open in new tab
              },
            },
          },
        },
      },
    },
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
    -- Custom git changed files picker
    { "<leader>gc",  function() Snacks.picker.git_changed_files() end,                       desc = "Git Changed Files" },
  }
}
