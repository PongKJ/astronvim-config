local M = {}

function M.get_os_name()
  local sysname = vim.loop.os_uname().sysname
  if sysname == "Linux" then
    return "linux"
  elseif sysname == "Windows_NT" then
    return "windows"
  elseif sysname == "Darwin" then
    return "macos"
  else
    return "unknown"
  end
end

function M.get_global_npm_path()
  local os_name = M.get_os_name()
  if os_name == "windows" then
    return vim.fn.system "cmd.exe /c npm root -g"
  else
    return vim.fn.system "npm root -g"
  end
end

return M
