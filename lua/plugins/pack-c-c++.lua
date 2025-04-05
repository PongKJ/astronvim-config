local utils = require "astrocore"

---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "c", "cpp", "cmake" })
      end
    end,
  },
  {
    "AstroNvim/astrolsp",
    ft = { "c", "cpp", "cmake" },
    optional = true,
    opts = function(_, opts)
      local extra_args = {
        "--clang-tidy",
        "--background-index",
        "-j=12",
        "--completion-style=detailed",
        "--header-insertion=never",
        "--pch-storage=disk",
        "--all-scopes-completion",
        "--header-insertion-decorators",
        "--experimental-modules-support",
        "--function-arg-placeholders=false",
      }

      if require("utils").detect_workspace_type() == "c/c++" then
        local compile_commands =
          require("helper.file").detect_file_in_paths("compile_commands.json", { vim.fn.getcwd() })
        if compile_commands then
          utils.list_insert_unique(extra_args, { "--compile-commands-dir", compile_commands })
        end
      end
      opts.config = vim.tbl_deep_extend("keep", opts.config, {
        clangd = {
          extra_args = extra_args,
          capabilities = {
            offsetEncoding = "utf-8",
          },
        },
        neocmake = {
          single_file_support = true,
          init_options = {
            format = {
              enable = false,
            },
            lint = {
              enable = false,
            },
          },
        },
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(
        opts.ensure_installed,
        { "clang-format", "cmakelang", "clangd", "neocmakelsp", "cortex-debug", "codelldb" }
      )
    end,
  },
  -- {
  --   "CWndpkj/none-ls.nvim",
  --   optional = true,
  --   ft = { "c", "cpp", "cmake" },
  --   opts = function(_, opts)
  --     opts.debug = true
  --     local null_ls = require "null-ls"
  --     local global_config = vim.fn.stdpath "config" .. "/templates"
  --     local user_config = vim.fn.getcwd()
  --     local clang_format_args = {}
  --     local clazy_args = {}
  --     local cmake_format_args = {}
  --     local cmake_lint_args = {}
  --
  --     local path = require("helper.file").detect_file_in_paths(".clang-format" , { user_config, global_config })
  --     -- Since we know that the file exists, we can safely use it without checking
  --     utils.list_insert_unique(clang_format_args, { "-style=file:" .. path })
  --     path = require("utils").detect_files_in_paths({ ".clazy.yaml" }, { user_config, global_config })
  --     local checks = io.popen("cat /home/pkj/.config/nvim/templates/.clazy.yaml | tr -d ' ' | tr '\n' ','"):read "*a"
  --     checks = checks:gsub("%s+", "") -- Remove any remaining whitespace
  --     utils.list_insert_unique(clazy_args, { "-checks=" .. checks })
  --     path = require("utils").detect_files_in_paths(
  --       { ".cmake-format.yaml", "cmake-format.py" },
  --       { user_config, global_config }
  --     )
  --     utils.list_insert_unique(cmake_format_args, { "-c", path })
  --     -- HACK: cmake_format need '-l error' to work?,and it must be append
  --     -- after '-c' option, otherwise it has no effect
  --     utils.list_insert_unique(cmake_format_args, { "-l", "error" })
  --     path = require("utils").detect_files_in_paths({ ".cmakelintrc" }, { user_config, global_config })
  --     utils.list_insert_unique(cmake_lint_args, { "--config=" .. path })
  --
  --     if require("utils").detect_workspace_type() == "c/c++" then
  --       -- TODO: Add more possible paths to search for compile_commands.json
  --       path = require("utils").detect_files_in_paths(
  --         { "compile_commands.json" },
  --         { user_config .. "/build", user_config }
  --       )
  --       if path then utils.list_insert_unique(clazy_args, { "-p", path }) end
  --     end
  --
  --     if not opts.sources then opts.sources = {} end
  --     opts.sources = vim.list_extend(opts.sources, {
  --       null_ls.builtins.formatting.clang_format.with {
  --         extra_args = clang_format_args,
  --       },
  --       -- NOTE: clazy-standalone need be installed manually
  --       null_ls.builtins.diagnostics.clazy.with {
  --         extra_args = clazy_args,
  --       },
  --       null_ls.builtins.formatting.cmake_format.with {
  --         extra_args = cmake_format_args,
  --       },
  --       null_ls.builtins.diagnostics.cmake_lint.with {
  --         extra_args = cmake_lint_args,
  --       },
  --     })
  --   end,
  -- },
  {
    "jedrzejboczar/nvim-dap-cortex-debug",
    config = function()
      require("dap-cortex-debug").setup {
        debug = true, -- log debug messages
        -- path to cortex-debug extension, supports vim.fn.glob
        -- by default tries to guess: mason.nvim or VSCode extensions
        extension_path = nil,
        lib_extension = nil, -- shared libraries extension, tries auto-detecting, e.g. 'so' on unix
        node_path = "node", -- path to node.js executable
        dapui_rtt = true, -- register nvim-dap-ui RTT element
        -- make :DapLoadLaunchJSON register cortex-debug for C/C++, set false to disable
        dap_vscode_filetypes = { "c", "cpp" },
      }
    end,
    requires = {
      "mfussenegger/nvim-dap",
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "alfaix/neotest-gtest",
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    opts = {
      inlay_hints = {
        inline = vim.fn.has "nvim-0.10" == 1,
        -- Options other than `highlight' and `priority' only work
        -- if `inline' is disabled
        -- Only show inlay hints for the current line
        only_current_line = false,
        -- Event which triggers a refresh of the inlay hints.
        -- You can make this { "CursorMoved" } or { "CursorMoved,CursorMovedI" } but
        -- note that this may cause higher CPU usage.
        -- This option is only respected when only_current_line is true.
        only_current_line_autocmd = { "CursorHold" },
        -- whether to show parameter hints with the inlay hints or not
        show_parameter_hints = true,
        -- prefix for parameter hints
        parameter_hints_prefix = "<- ",
        -- prefix for all the other hints (type, chaining)
        other_hints_prefix = "=> ",
        -- whether to align to the length of the longest line in the file
        max_len_align = false,
        -- padding from the left if max_len_align is true
        max_len_align_padding = 1,
        -- whether to align to the extreme right or not
        right_align = false,
        -- padding from the right if right_align is true
        right_align_padding = 7,
        -- The color of the hints
        highlight = "Comment",
        -- The highlight group priority for extmark
        priority = 100,
      },
      ast = {
        --[[ These are unicode, should be available in any font
        role_icons = {
          type = "🄣",
          declaration = "🄓",
          expression = "🄔",
          statement = ";",
          specifier = "🄢",
          ["template argument"] = "🆃",
        },
        kind_icons = {
          Compound = "🄲",
          Recovery = "🅁",
          TranslationUnit = "🅄",
          PackExpansion = "🄿",
          TemplateTypeParm = "🅃",
          TemplateTemplateParm = "🅃",
          TemplateParamObject = "🅃",
        },]]

        --[[ These require codicons (https://github.com/microsoft/vscode-codicons)]]
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },

        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },

        highlights = {
          detail = "Comment",
        },
      },
      memory_usage = {
        border = "none",
      },
      symbol_info = {
        border = "none",
      },
    },
  },
}
