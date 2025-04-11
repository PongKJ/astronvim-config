-- TODO: setup for blink.cmp
-- {
--   "hrsh7th/nvim-cmp",
--   optional = true,
--   dependencies = {
--     { "js-everts/cmp-tailwind-colors", opts = {} },
--   },
--   opts = function(_, opts)
--     local format_kinds = opts.formatting.format
--     opts.formatting.format = function(entry, item)
--       if item.kind == "Color" then
--         item = require("cmp-tailwind-colors").format(entry, item)
--         if item.kind == "Color" then return format_kinds(entry, item) end
--         return item
--       end
--       return format_kinds(entry, item)
--     end
--   end,
-- },
---@type LazySpec
return {
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = "*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    -- override blink.cmp plugin
    "Saghen/blink.cmp",
    -- dependencies = {
    --   { "js-everts/cmp-tailwind-colors", opts = {} },
    -- },
    opts = {
      sources = {
        min_keyword_length = function() return vim.bo.filetype == "markdown" and 2 or 0 end,
        providers = {
          path = {
            opts = {
              get_cwd = function(_) return vim.fn.getcwd() end,
            },
            score_offset = 3,
          },
        },
      },
      keymap = {
        preset = "default",
        ["<Tab>"] = {
          "accept",
          "fallback",
        },
        ["<C-N>"] = {
          "snippet_forward",
        },
        ["<C-P>"] = {
          "snippet_backward",
        },
        ["<S-Tab>"] = {
          "fallback",
        },
        ["<CR>"] = { "fallback" },
      },
      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
      },
      snippets = {
        -- Function to use when expanding LSP provided snippets
        expand = function(snippet) vim.snippet.expand(snippet) end,
        -- Function to use when checking if a snippet is active
        active = function(filter) return vim.snippet.active(filter) end,
        -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
        jump = function(direction) vim.snippet.jump(direction) end,
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        prebuilt_binaries = {
          force_version = "v1.1.1",
        },
      },
      signature = {
        enabled = false,
        window = {
          show_documentation = true,
        },
      },
      cmdline = {
        keymap = {
          preset = "inherit",
        },
        completion = {
          menu = {
            auto_show = true,
          },
        },
      },
    },
  },
}
