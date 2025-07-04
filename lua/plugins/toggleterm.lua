return {
  "akinsho/toggleterm.nvim",
  opts = function(_, opts)
    local os_name = require("utils").get_os_name()
    if os_name == "macos" or os_name == "linux" then
      opts.shell = "fish"
    elseif os_name == "windows" then
      vim.opt.shell = "pwsh"
      vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
      vim.opt.shellquote = ""
      vim.opt.shellxquote = ""
      opts.shell = "pwsh"
    end
    opts.autochdir = true
    -- HACK: Press <Leader> when there is output in the terminal will result in no response
    -- Close auto scroll fix it
    opts.auto_scroll = false
  end,
}
