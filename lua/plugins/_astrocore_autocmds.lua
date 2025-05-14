return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      -- first key is the `augroup` (:h augroup)
      highlighturl = {
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "VimEnter", "FileType", "BufEnter", "WinEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "URL Highlighting",
          callback = function() require("astrocore").set_url_match() end,
        },
      },
      auto_turnoff_paste = {
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "auto turnoff paste",
          callback = function() vim.cmd "set nopaste" end,
        },
      },
      disable_auto_comment = {
        {
          desc = "disbale auto comment",
          event = { "FileType" },
          callback = function()
            vim.opt_local.formatoptions:remove "c"
            vim.opt_local.formatoptions:remove "r"
            vim.opt_local.formatoptions:remove "o"
          end,
        },
      },
    },
  },
}
