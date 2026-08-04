return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- custom configuration
    spec = {
      { "<leader>m", group = "Markdown", icon = "" }, -- <leader>m のグループ名を設定
      { "<leader>a", group = "Avante", icon = "" },
      { "<leader>e", group = "(File)Explorer", icon = "" },
      { "<leader>f", group = "Finder(Search)", icon = "" },
      { "<leader>t", group = "Tab" },
      { "<leader>s", group = "Split", icon = "" },
      { "<leader>w", group = "Session", icon = "󰦛" },
      { "<leader>h", group = "Hunk(gitsign)", icon = "" },

      -- （おまけ）もし他にもグループ化したいものがあれば、ここに並べていけます
      -- { "<leader>f", group = "Find/File" },
      -- { "<leader>g", group = "Git" },
    },
    -- or leave it empty to use default settings
  },
}
