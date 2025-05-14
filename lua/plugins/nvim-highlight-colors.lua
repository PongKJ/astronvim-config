-- WARNING:https://github.com/AstroNvim/AstroNvim/issues/2593
return {
  {
    "brenoprata10/nvim-highlight-colors",
    event = "User AstroFile",
    cmd = "HighlightColors",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>uz"] = { function() vim.cmd.HighlightColors "Toggle" end, desc = "Toggle color highlight" }
        end,
      },
    },
    opts = {
      enabled_named_colors = true,
      render = "virtual",
      virtual_symbol_position = "inline",
      enable_tailwind = true,
      virtual_symbol = "󱓻",
      virtual_symbol_suffix = " ",
      enable_short_hex = false,
      enable_hex = true,
    },
  },
}
