return {
    'mfussenegger/nvim-lint',
    config = function()
        local lint = require('lint')
        
        -- Function to find config files by searching upward from current file
        local function find_config_upward(config_files, tool_name)
            local current_file = vim.api.nvim_buf_get_name(0)
            local current_dir = vim.fn.fnamemodify(current_file, ":h")
            local cwd = vim.fn.getcwd()
            local found_files = {}
            local search_path = current_dir
            
            -- Search upward from current file directory to project root
            while search_path and (search_path == cwd or search_path:find(cwd, 1, true) == 1) do
                for _, config_file in ipairs(config_files) do
                    local full_path = search_path .. '/' .. config_file
                    local exists = vim.fn.filereadable(full_path) == 1
                    
                    if exists then
                        local relative_path = search_path == cwd and config_file or 
                                            vim.fn.fnamemodify(full_path, ":.")
                        table.insert(found_files, relative_path)
                    end
                end
                
                -- Move up one directory
                local parent = vim.fn.fnamemodify(search_path, ":h")
                if parent == search_path or parent == "/" then
                    break
                end
                search_path = parent
                
                -- Stop if we've reached above the project root
                if not search_path:find(cwd, 1, true) then
                    break
                end
            end
            
            return #found_files > 0, found_files
        end
        
        -- Function to get available linters for JavaScript/TypeScript
        local function get_js_linters()
            local linters = {}
            
            -- Check for ESLint config
            local eslint_found, eslint_files = find_config_upward({
                ".eslintrc",
                ".eslintrc.json",
                ".eslintrc.js",
                ".eslintrc.cjs",
                ".eslintrc.yaml",
                ".eslintrc.yml",
                "eslint.config.js",
                "eslint.config.mjs",
                "eslint.config.cjs"
            }, "ESLint")
            
            if eslint_found then
                table.insert(linters, "eslint_d")
            end
            
            -- Check for Biome config
            local biome_found, biome_files = find_config_upward({
                "biome.json",
                "biome.jsonc"
            }, "Biome")
            
            if biome_found then
                table.insert(linters, "biomejs")
            end
            
            return linters
        end
        
        -- Set up linters by filetype
        lint.linters_by_ft = {
            javascript = get_js_linters(),
            typescript = get_js_linters(),
            javascriptreact = get_js_linters(),
            typescriptreact = get_js_linters(),
        }

        vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "CursorHold"}, {
            callback = function()
                local ft = vim.bo.filetype
                
                if ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
                    local available_linters = get_js_linters()
                    if #available_linters > 0 then
                        lint.try_lint(available_linters)
                    end
                else
                    lint.try_lint()
                end
            end,
        })
        

    end,
}