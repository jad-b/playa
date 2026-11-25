return {
  {
    "susliko/tla.nvim",
    config = function()
      require("tla").setup({
        tla2tools = os.getenv("HOME") .. "/.local/opt/tlaplus/tla2tools.jar",
      })
    end,
    keys = {
      -- { "<D-r>", "<Plug>MarkdownPreview", ft = "markdown" }
      -- change a keymap { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>ct", "<cmd>TlaTranslate<CR>", desc = "Translate TLA+" },
      { "<leader>cc", "<cmd>TlaCheck<CR>", desc = "Check TLA+" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
          "tlaplus",
        })
      end,
    },
  },
  -- { "tlaplus-community/tlaplus-nvim-plugin" },
}
