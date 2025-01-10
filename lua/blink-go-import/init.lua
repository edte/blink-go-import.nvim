-- blink.cmp provider
-- https://github.com/Saghen/blink.cmp/blob/main/lua/blink/cmp/sources/lib/provider/init.lua

local M = {}

local items = {}

M.new = function()
    local self = setmetatable({}, { __index = M })
    return self
end

function M:enabled()
    local function check_if_inside_imports()
        local cur_node = require("nvim-treesitter.ts_utils").get_node_at_cursor()

        local func = cur_node
        local flag = false

        while func do
            if func:type() == "import_declaration" then
                flag = true
                break
            end

            func = func:parent()
        end

        return flag
    end

    if vim.bo.filetype ~= "go" then
        return
    end

    return check_if_inside_imports()
end

function M:get_completions(context, callback)
    local bufnr = vim.api.nvim_get_current_buf()

    if next(items) == nil or items[bufnr] == nil then
        callback()
        return
    end

    callback({ items = items[bufnr], is_incomplete_forward = false })
end

local init_items = function(a)
    local client = vim.lsp.get_client_by_id(a.data.client_id)
    local bufnr = vim.api.nvim_get_current_buf()

    if client == nil then
        return
    end

    -- https://pkg.go.dev/golang.org/x/tools/gopls/internal/protocol#ExecuteCommandParams
    local method = "workspace/executeCommand"

    local params = {
        command = "gopls.list_known_packages",
        arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
    }

    local handler = function(result, context, _)
        if context == nil and result ~= nil then
            return
        end

        if result == nil and context == nil then
            return
        end

        local tmp = {}

        for _, v in ipairs(context.Packages) do
            table.insert(tmp, {
                label = string.format('"%s"', v),
                kind = 9,
                insertText = string.format('"%s"', v),
            })
        end

        items[bufnr] = tmp
    end

    local ok, id = client:request(method, params, handler, bufnr)
end

function M.setup()
    vim.api.nvim_create_autocmd({ "LspAttach" }, {
        group = vim.api.nvim_create_augroup("go_pkgs", { clear = true }),

        pattern = { "*.go" },
        callback = init_items,
    })
end

return M
