-- TODO: Find better methods to detect workspace type
local M = {}

local json = require "helper.json"
local file = require "helper.file"

function M.is_vue_project(bufnr)
  local lsp_rooter
  if type(bufnr) ~= "number" then bufnr = vim.api.nvim_get_current_buf() end
  local rooter = require "astrocore.rooter"
  if not lsp_rooter then
    lsp_rooter = rooter.resolve("lsp", {
      ignore = {
        servers = function(client)
          return not vim.tbl_contains({ "vtsls", "typescript-tools", "volar", "eslint", "tsserver" }, client.name)
        end,
      },
    })
  end

  local vue_dependency = false
  for _, root in ipairs(require("astrocore").list_insert_unique(lsp_rooter(bufnr), { vim.fn.getcwd() })) do
    local package_json = json.decode_json(root .. "/package.json")
    if
      package_json
      and (
        json.check_json_key_exists(package_json, "dependencies", "vue")
        or json.check_json_key_exists(package_json, "devDependencies", "vue")
      )
    then
      vue_dependency = true
      break
    end
  end

  return vue_dependency
end

---@brief Copy template file to current workspace
---@param workspace_type string
function M.workspace_template_files_copy(workspace_type)
  local dotfiles_path = vim.fn.stdpath "config" .. "/dotfiles"
  local cwd = vim.fn.getcwd()
  file.copy_files_in_dir(dotfiles_path .. "/" .. workspace_type, cwd)
end

function M.ensure_workspace_dotfiles(workspace_type)
  -- Check all dotfiles in the current workspace
  local dotfiles_needed = file.scan_dir(vim.fn.stdpath "config" .. "/dotfiles/" .. workspace_type)
  if not file.ensure_files_exsist(dotfiles_needed, vim.fn.getcwd()) then
    vim.notify("copying dotfiles:" .. vim.inspect(dotfiles_needed), vim.log.levels.INFO)
    M.workspace_template_files_copy(workspace_type)
  else
    vim.notify("all dotfiles satisfied", vim.log.levels.INFO)
  end
end

function M.detect_workspace_type()
  local cwd = vim.fn.getcwd()
  if file.file_exists(cwd .. "./CMakeLists.txt") then
    return "c_cpp"
  elseif file.file_exists(cwd .. "/Cargo.toml") then
    return "rust"
  elseif vim.fn.isdirectory(cwd .. "/node_modules") == 1 or file.file_exists(cwd .. "/package.json") then
    return "vue"
  elseif file.file_exists(cwd .. "/requirements.txt") or file.file_exists(cwd .. "/setup.py") then
    return "python"
  else
    return "unknown"
  end
end

return M
