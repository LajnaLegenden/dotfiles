return {
  'axkirillov/easypick.nvim',
  dependencies = 'nvim-telescope/telescope.nvim',
  config = function()
    local easypick = require("easypick")

    -- only required for the example to work
    local get_default_branch = "git rev-parse --abbrev-ref origin/HEAD | sed 's@^origin/@@'"
    local base_branch = vim.fn.system(get_default_branch) or "main"

    easypick.setup({
      pickers = {
        -- add your custom pickers here
        -- below you can find some examples of what those can look like

        -- list files inside current folder with default previewer
        {
          -- name for your custom picker, that can be invoked using :Easypick <name> (supports tab completion)
          name = "ls",
          -- the command to execute, output has to be a list of plain text entries
          command = "ls",
          -- specify your custom previwer, or use one of the easypick.previewers
          previewer = easypick.previewers.default()
        },

        -- diff current branch with base_branch and show files that changed with respective diffs in preview
        {
          name = "changed_files",
          command = "git diff --name-only $(git merge-base origin/master HEAD) && git ls-files --others --exclude-standard",
          previewer = easypick.previewers.branch_diff({ base_branch = base_branch })
        },

        -- list files that have conflicts with diffs in preview
        {
          name = "conflicts",
          command = "git diff --name-only --diff-filter=U --relative",
          previewer = easypick.previewers.file_diff()
        },
      }
    })

    vim.keymap.set('n', '<leader>fs', ':Easypick changed_files<CR>', { desc = 'Easy picker changed files' })
  end
}
