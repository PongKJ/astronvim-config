---@type LazySpec
return {
  {
    "AstroNvim/astroui",
    lazy = false, -- disable lazy loading
    priority = 10000, -- load AstroUI first
    ---@type AstroUIOpts
    opts = {
      colorscheme = "onedark",
      highlights = {
        -- set highlights for all themes
        -- use a function override to let us use lua to retrieve
        -- colors from highlight group there is no default table
        -- so we don't need to put a parameter for this function
        init = function()
          local get_hlgroup = require("astroui").get_hlgroup
          -- get highlights from highlight groups
          local normal = get_hlgroup "Normal"
          local fg, bg = normal.fg, normal.bg
          local bg_alt = get_hlgroup("WinBar").bg
          local green = get_hlgroup("String").fg
          local red = get_hlgroup("Error").fg
          -- return a table of highlights for telescope based on
          -- colors gotten from highlight groups
          return {
            TelescopeBorder = { fg = bg_alt, bg = bg },
            TelescopeNormal = { bg = bg },
            TelescopePreviewBorder = { fg = bg_alt, bg = bg },
            TelescopePreviewNormal = { bg = bg },
            TelescopePreviewTitle = { fg = bg, bg = green },
            TelescopePromptBorder = { fg = bg_alt, bg = bg_alt },
            TelescopePromptNormal = { fg = fg, bg = bg_alt },
            TelescopePromptPrefix = { fg = red, bg = bg_alt },
            TelescopePromptTitle = { fg = bg, bg = red },
            TelescopeResultsBorder = { fg = bg_alt, bg = bg },
            TelescopeResultsNormal = { bg = bg },
            TelescopeResultsTitle = { fg = bg, bg = bg },

            DapBreakpoint = { fg = "#ea49de", bg = bg },
            DapLogPoint = { fg = "yellow", bg = bg },
            DapBreakpointCondition = { fg = "blue", bg = bg },
            DapBreakpointRejected = { fg = "red", bg = bg },
            DapStopped = { fg = "#21de94", bg = "#0e3c00" },
          }
        end,
      },
      icons = {
        ActiveLSP = "",
        ActiveTS = "",
        ArrowLeft = "",
        ArrowRight = "",
        Bookmarks = "",
        BufferClose = "",
        DapBreakpoint = "",
        DapBreakpointCondition = "",
        DapBreakpointRejected = "",
        DapLogPoint = "",
        DapStopped = "",
        Debugger = "",
        DefaultFile = "",
        Diagnostic = "",
        DiagnosticError = "",
        DiagnosticHint = "",
        DiagnosticInfo = "",
        DiagnosticWarn = "",
        Ellipsis = "",
        FileNew = "",
        FileModified = "",
        FileReadOnly = "",
        FoldClosed = "",
        FoldOpened = "",
        FolderClosed = "",
        FolderEmpty = "",
        FolderOpen = "",
        Git = "",
        GitAdd = "",
        GitBranch = "",
        GitChange = "",
        GitConflict = "",
        GitDelete = "",
        GitIgnored = "",
        GitRenamed = "",
        GitStaged = "",
        GitUnstaged = "*",
        GitUntracked = "",
        LSPLoaded = "",
        LSPLoading1 = "",
        LSPLoading2 = "",
        LSPLoading3 = "",
        MacroRecording = "",
        Package = "",
        Paste = "",
        Refresh = "",
        Search = "",
        Selected = "",
        Session = "",
        Sort = "",
        Spellcheck = "",
        TabClose = "",
        Terminal = "",
        Window = "",
        WordFile = "",
      },
      status = {
        icon_highlights = {
          breadcrumbs = true,
        },
        setup_colors = nil,
      },
    },
  },
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      if not opts.signs then opts.signs = require("astrocore").empty_map_table() end
      local get_icon = require("astroui").get_icon
      opts.signs.DapBreakpoint = { text = get_icon "DapBreakpoint", texthl = "DapBreakpoint", linehl = "DapBreakpoint" }
      opts.signs.DapBreakpointCondition = {
        text = get_icon "DapBreakpointCondition",
        texthl = "DapBreakpointCondition",
        numhl = "DapBreakpointCondition",
      }
      opts.signs.DapBreakpointRejected = {
        text = get_icon "DapBreakpointRejected",
        texthl = "DapBreakpointRejected",
        numhl = "DapBreakpointRejected",
      }
      opts.signs.DapLogPoint = {
        text = get_icon "DapLogPoint",
        texthl = "DapLogPoint",
        numhl = "DapLogPoint",
      }
      opts.signs.DapStopped = {
        text = get_icon "DapStopped",
        texthl = "DapStopped",
        numhl = "DapStopped",
      }
    end,
  },
  {
    "echasnovski/mini.icons",
    opts = {
      -- Icon style: 'glyph' or 'ascii'
      style = "glyph",

      -- Customize per category. See `:h MiniIcons.config` for details.
      default = {},
      directory = {},
      extension = {},
      file = {},
      filetype = {},
      lsp = {
        array = { glyph = "", hl = "MiniIconsOrange" },
        boolean = { glyph = "", hl = "MiniIconsOrange" },
        class = { glyph = "󰠱", hl = "MiniIconsPurple" },
        color = { glyph = "", hl = "MiniIconsRed" },
        constant = { glyph = "󰏿", hl = "MiniIconsOrange" },
        constructor = { glyph = "", hl = "MiniIconsAzure" },
        enum = { glyph = "", hl = "MiniIconsPurple" },
        enummember = { glyph = "", hl = "MiniIconsYellow" },
        event = { glyph = "", hl = "MiniIconsRed" },
        field = { glyph = "󰜢", hl = "MiniIconsYellow" },
        file = { glyph = "", hl = "MiniIconsBlue" },
        folder = { glyph = "", hl = "MiniIconsBlue" },
        ["function"] = { glyph = "󰊕", hl = "MiniIconsAzure" },
        interface = { glyph = "", hl = "MiniIconsPurple" },
        key = { glyph = "", hl = "MiniIconsYellow" },
        keyword = { glyph = "", hl = "MiniIconsCyan" },
        method = { glyph = "", hl = "MiniIconsAzure" },
        module = { glyph = "", hl = "MiniIconsPurple" },
        namespace = { glyph = "", hl = "MiniIconsRed" },
        null = { glyph = "", hl = "MiniIconsGrey" },
        number = { glyph = "", hl = "MiniIconsOrange" },
        object = { glyph = "", hl = "MiniIconsGrey" },
        operator = { glyph = "", hl = "MiniIconsCyan" },
        package = { glyph = "", hl = "MiniIconsPurple" },
        property = { glyph = "", hl = "MiniIconsYellow" },
        reference = { glyph = "", hl = "MiniIconsCyan" },
        snippet = { glyph = "", hl = "MiniIconsGreen" },
        string = { glyph = "", hl = "MiniIconsGreen" },
        struct = { glyph = "󰙅", hl = "MiniIconsPurple" },
        text = { glyph = "󰉿", hl = "MiniIconsGreen" },
        typeparameter = { glyph = "", hl = "MiniIconsCyan" },
        unit = { glyph = "󰑭", hl = "MiniIconsCyan" },
        value = { glyph = "󰎠", hl = "MiniIconsBlue" },
        variable = { glyph = "󰀫", hl = "MiniIconsCyan" },
      },
      os = {},

      -- Control which extensions will be considered during "file" resolution
      use_file_extension = function(ext, file) return true end,
    },
  },
}
