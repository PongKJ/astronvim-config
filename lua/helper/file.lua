local M = {}

local Path = require "plenary.path"

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if opts.warn and not vim.loop.fs_stat(ret) and not require("lazy.core.config").headless() then
    vim.schedule(
      function()
        vim.notify(
          ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(
            pkg,
            path
          ),
          vim.log.levels.WARN
        )
      end
    )
  end
  return ret
end

function M.get_filename_with_extension_from_path(path) return string.match(path, "([^/]+)$") end

function M.get_parent_dir(path) return path:match "(.+)/" end

function M.file_exists(path)
  local file = Path:new(path)
  return file:exists()
end

function M.write_to_file(content, file_path)
  local file = io.open(file_path, "a")
  if not file then
    vim.notify("Unable to open file: " .. file_path, vim.log.levels.ERROR)
    return
  end
  file:write(vim.inspect(content))
  file:write "\n"
  file:close()
end

function M.copy_file_or_dir(src, dest)
  local src_path = Path:new(src)
  src_path:copy { destnation = dest, make_dirs = true, recursive = true, interactive = true }
end

function M.copy_files_in_dir(src_dir, dest_dir)
  local src_path = Path:new(src_dir)

  if not src_path:exists() or not src_path:is_dir() then
    vim.notify("Source directory does not exist or is not a directory: " .. src_dir, vim.log.levels.ERROR)
    return
  end

  local scandir = require "plenary.scandir"

  for _, file in ipairs(scandir.scan_dir(src_dir, { hidden = true, add_dirs = true })) do
    local src_file_path = Path:new(file)
    local dest_file_path = Path:new(dest_dir, Path:new(file):make_relative(src_dir))
    if src_file_path:is_dir() then
      dest_file_path:mkdir { parents = true }
    else
      src_file_path:copy { destination = dest_file_path.filename, recursive = true, parents = true, interactive = true }
    end
  end
end

--- Detect file in specified path
--- return the file path if been found
--- @param filename string
--- @param path string[]
--- WARN: Not tested yet
function M.detect_file_in_paths(filename, path)
  local scandir = require "plenary.scandir"

  for _, file in ipairs(scandir.scan_dir(path, { hidden = true, add_dirs = true })) do
    if M.get_filename_with_extension_from_path(file) == filename then return file end
  end
end

function M.scan_dir(dir)
  local scandir = require "plenary.scandir"
  local files = {}
  for _, file in ipairs(scandir.scan_dir(dir, { hidden = true, add_dirs = true })) do
    table.insert(files, Path:new(file):make_relative(dir))
  end
  return files
end

function M.ensure_files_exsist(files, path)
  for _, file in ipairs(files) do
    if not M.file_exists(path .. "/" .. file) then return false end
  end
  return true
end

function M.is_file_binary_pre_read()
  -- stylua: ignore
  local binary_ext = {
    "out","bin","jpeg","pak","gz","rar","exe","bz2","tar","xz","Z","rpm","zip","a","so","o","jar",
    "dll","lib","deb","I","png","jpg","mp3","mp4","m4a","flv","mkv","rmvb","avi","pcap","pdf","docx",
    "xlsx","pptx","ram","mid","dwg","dtb","elf",
  }
  -- only work on normal buffers
  -- Is this working?
  if vim.bo.ft ~= "" then return false end
  -- check -b flag
  if vim.bo.bin then return true end
  -- check ext within binary_ext
  local filename = vim.fn.expand "%:p"
  local ext = vim.fn.expand "%:e"
  if vim.tbl_contains(binary_ext, ext) then return true end
  local binary_file_header_tbl = {
    "\x7f\x45\x4c\x46", -- ELF,
    "\x50\x4b\x03\x04", --Archive
    "\x00\x00\xa0\xe1", --zImage
  }
  local file = io.open(filename, "rb")
  if file then
    local chunk = file:read(4)
    if vim.tbl_contains(binary_file_header_tbl, chunk) then return true end
  end
  -- none of the above
  return false
end

function M.is_file_binary_post_read()
  local encoding = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
  if encoding ~= "utf-8" then return true end
  return false
end

return M
