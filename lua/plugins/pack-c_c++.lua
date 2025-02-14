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
      -- local clang_format_config
      -- local global_clang_format_config = vim.fn.stdpath "config" .. "/dotfiles/.clang-format"
      -- local user_clang_format_config = vim.fn.getcwd() .. "/.clang-format"
      -- if require("utils").file_exists(user_clang_format_config) then
      --   clang_format_config = user_clang_format_config
      -- else
      --   clang_format_config = global_clang_format_config
      -- end
      local extra_args = {
        "--clang-tidy",
        "--background-index",
        "-j=12",
        "--completion-style=detailed",
        "--header-insertion=never",
        "--pch-storage=disk",
        "--all-scopes-completion",
        "--header-insertion-decorators",
        -- INFO:Clangd will supports this option soon,bu not yet,currently we use
        -- clang-format
        -- "-style=file:" .. clang_format_config,
      }

      if require("utils").detect_workspace_type() == "c/c++" then
        local cwd = vim.fn.getcwd()
        -- TODO: Add more possible paths to search for compile_commands.json
        local compile_commands = require("utils").detect_files_in_paths(
          { "compile_commands.json" },
          { cwd .. "/build", cwd }
        )
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
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "clang-format", "cmakelang" })
    end,
  },
  {
    "CWndpkj/none-ls.nvim",
    optional = true,
    ft = { "c", "cpp", "cmake" },
    opts = function(_, opts)
      opts.debug = true
      local null_ls = require "null-ls"
      local global_config = vim.fn.stdpath "config" .. "/dotfiles"
      local user_config = vim.fn.getcwd()
      local clang_format_args = {}
      local clazy_args = {}
      local cmake_format_args = {}
      local cmake_lint_args = {}

      local path = require("utils").detect_files_in_paths({ ".clang-format" }, { user_config, global_config })
      -- Since we know that the file exists, we can safely use it without checking
      utils.list_insert_unique(clang_format_args, { "-style=file:" .. path })
      path = require("utils").detect_files_in_paths({ ".clazy.yaml" }, { user_config, global_config })
      local checks = io.popen("cat /home/pkj/.config/nvim/dotfiles/.clazy.yaml | tr -d ' ' | tr '\n' ','"):read "*a"
      checks = checks:gsub("%s+", "") -- Remove any remaining whitespace
      utils.list_insert_unique(clazy_args, { "-checks=" .. checks })
      path = require("utils").detect_files_in_paths(
        { ".cmake-format.yaml", "cmake-format.py" },
        { user_config, global_config }
      )
      utils.list_insert_unique(cmake_format_args, { "-c", path })
      -- HACK: cmake_format need '-l error' to work?,and it must be append
      -- after '-c' option, otherwise it has no effect
      utils.list_insert_unique(cmake_format_args, { "-l", "error" })
      path = require("utils").detect_files_in_paths({ ".cmakelintrc" }, { user_config, global_config })
      utils.list_insert_unique(cmake_lint_args, { "--config=" .. path })

      if require("utils").detect_workspace_type() == "c/c++" then
        -- TODO: Add more possible paths to search for compile_commands.json
        path = require("utils").detect_files_in_paths(
          { "compile_commands.json" },
          { user_config .. "/build", user_config }
        )
        if path then utils.list_insert_unique(clazy_args, { "-p", path }) end
      end

      if not opts.sources then opts.sources = {} end
      opts.sources = vim.list_extend(opts.sources, {
        null_ls.builtins.formatting.clang_format.with {
          extra_args = clang_format_args,
        },
        -- NOTE: clazy-standalone need be installed manually
        null_ls.builtins.diagnostics.clazy.with {
          extra_args = clazy_args,
        },
        null_ls.builtins.formatting.cmake_format.with {
          extra_args = cmake_format_args,
        },
        null_ls.builtins.diagnostics.cmake_lint.with {
          extra_args = cmake_lint_args,
        },
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      -- dap
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "codelldb" })
    end,
  },
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
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      -- lsp
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "clangd", "neocmake" })
    end,
  },
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_command = "cmake", -- this is used to specify cmake command path
      ctest_command = "ctest", -- this is used to specify ctest command path
      cmake_use_preset = true,
      cmake_regenerate_on_save = false, -- auto generate when save CMakeLists.txt
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1", "-G Ninja" }, -- this will be passed when invoke `CMakeGenerate`
      cmake_build_options = { "-j10" }, -- this will be passed when invoke `CMakeBuild`
      -- support macro expansion:
      --       ${kit}
      --       ${kitGenerator}
      --       ${variant:xx}
      cmake_build_directory = function()
        local osys = require "cmake-tools.osys"
        if osys.iswin32 then return "out\\${variant:buildType}" end
        return "out/${variant:buildType}"
      end, -- this is used to specify generate directory for cmake, allows macro expansion, can be a string or a function returning the string, relative to cwd.
      cmake_soft_link_compile_commands = true, -- this will automatically make a soft link from compile commands file to project root dir
      cmake_compile_commands_from_lsp = false, -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
      cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
      cmake_variants_message = {
        short = { show = true }, -- whether to show short message
        long = { show = true, max_length = 40 }, -- whether to show long message
      },
      cmake_dap_configuration = { -- debug settings for cmake
        name = "cpp",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
      },
      cmake_executor = { -- executor to use
        name = "toggleterm", -- name of the executor
        opts = {}, -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
        default_opts = { -- a list of default and possible values for executors
          quickfix = {
            show = "always", -- "always", "only_on_error"
            position = "horizontal", -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
            size = 10,
            encoding = "utf-8", -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
            auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
          },
          toggleterm = {
            direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float'
            close_on_exit = false, -- whether close the terminal when exit
            auto_scroll = true, -- whether auto scroll to the bottom
            singleton = true, -- single instance, autocloses the opened one, if present
          },
          overseer = {
            new_task_opts = {
              strategy = {
                "toggleterm",
                direction = "horizontal",
                autos_croll = true,
                quit_on_exit = "success",
              },
            }, -- options to pass into the `overseer.new_task` command
            on_new_task = function(task) require("overseer").open { enter = false, direction = "right" } end, -- a function that gets overseer.Task when it is created, before calling `task:start`
          },
          terminal = {
            name = "Main Terminal",
            prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
            split_direction = "horizontal", -- "horizontal", "vertical"
            split_size = 11,

            -- Window handling
            single_terminal_per_instance = true, -- Single viewport, multiple windows
            single_terminal_per_tab = true, -- Single viewport per tab
            keep_terminal_static_location = true, -- Static location of the viewport if avialable

            -- Running Tasks
            start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
            focus = false, -- Focus on terminal when cmake task is launched.
            do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
          }, -- terminal executor uses the values in cmake_terminal
        },
      },
      cmake_runner = { -- runner to use
        name = "toggleterm", -- name of the runner
        opts = {}, -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
        default_opts = { -- a list of default and possible values for runners
          quickfix = {
            show = "always", -- "always", "only_on_error"
            position = "horizontal", -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright",
            size = 15,
            encoding = "utf-8",
            auto_close_when_success = false, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
          },
          toggleterm = {
            direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float'
            close_on_exit = false, -- whether close the terminal when exit
            auto_scroll = true, -- whether auto scroll to the bottom
            singleton = true, -- single instance, autocloses the opened one, if present
          },
          overseer = {
            new_task_opts = {
              strategy = {
                "toggleterm",
                direction = "horizontal",
                autos_croll = true,
                quit_on_exit = "success",
              },
            }, -- options to pass into the `overseer.new_task` command
            on_new_task = function(task) end, -- a function that gets overseer.Task when it is created, before calling `task:start`
          },
          terminal = {
            name = "Main Terminal",
            prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
            split_direction = "horizontal", -- "horizontal", "vertical"
            split_size = 11,

            -- Window handling
            single_terminal_per_instance = true, -- Single viewport, multiple windows
            single_terminal_per_tab = true, -- Single viewport per tab
            keep_terminal_static_location = true, -- Static location of the viewport if avialable

            -- Running Tasks
            start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
            focus = false, -- Focus on terminal when cmake task is launched.
            do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
          },
        },
      },
      cmake_notifications = {
        runner = { enabled = false },
        executor = { enabled = true },
        spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
        refresh_rate_ms = 100, -- how often to iterate icons
      },
      cmake_virtual_text_support = true, -- Show the target related to current file using virtual text (at right corner)
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
