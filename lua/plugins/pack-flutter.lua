return {
  { import = "astrocommunity.pack.yaml" },
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type AstroLSPOpts
    opts = {
      ---@diagnostic disable: missing-fields
      handlers = { dartls = false },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "dart" })
      end

      -- HACK: Disables the select treesitter textobjects because the Dart treesitter parser is very inefficient. Hopefully this gets fixed and this block can be removed in the future.
      -- Reference: https://github.com/AstroNvim/AstroNvim/issues/2707
      local select = vim.tbl_get(opts, "textobjects", "select")
      if select then select.disable = require("astrocore").list_insert_unique(select.disable, { "dart" }) end
    end,
  },
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    opts = function(_, opts)
      local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
      if astrolsp_avail then opts.lsp = astrolsp.lsp_opts "dartls" end
      opts.lsp.settings = {
        showTodos = true,
        completeFunctionCalls = false,
        renameFilesWithClasses = "prompt", -- "always"
        enableSnippets = true,
        updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
      }
      opts.fvm = true
      opts.widget_guides = {
        enabled = true,
      }
      opts.closing_tags = {
        highlight = "Comment", -- highlight for the closing tag
        prefix = "> ", -- character to use for close tag e.g. > Widget
        priority = 10, -- priority of virtual text in current line
        -- consider to configure this when there is a possibility of multiple virtual text items in one line
        -- see `priority` option in |:help nvim_buf_set_extmark| for more info
        enabled = true, -- set to false to disable
      }
      opts.dev_log = {
        enabled = true,
        filter = nil, -- optional callback to filter the log
        -- takes a log_line as string argument; returns a boolean or nil;
        -- the log_line is only added to the output if the function returns true
        notify_errors = false, -- if there is an error whilst running then notify the user
        open_cmd = "6split", -- command to use to open the log buffer
        focus_on_open = false, -- focus on the newly opened log window
      }
      opts.dev_tools = {
        autostart = true, -- autostart devtools server if not detected
        auto_open_browser = true, -- Automatically opens devtools in the browser
      }
    end,
    config = function(_, opts)
      local flutter_tools = require "flutter-tools"
      flutter_tools.setup(opts)
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    specs = {
      -- Add "flutter" extension to "telescope"
      {
        "nvim-telescope/telescope.nvim",
        optional = true,
        opts = function() require("telescope").load_extension "flutter" end,
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "dart-debug-adapter" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "dart" })
    end,
  },
}
