return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      vim.list_extend(opts.cmd, {
        "--java-executable",
        "/home/jedobbin/.sdkman/candidates/java/25/bin/java",
      })
      opts.jdtls = function(cfg)
        cfg.settings = {
          java = {
            autobuild = {
              enabled = false,
            },
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-25",
                  path = "/home/jedobbin/.sdkman/candidates/java/25",
                },
                {
                  name = "JavaSE-17",
                  path = "/home/jedobbin/.sdkman/candidates/java/17",
                  default = true,
                },
              },
            },
            format = {
              enabled = false,
            },
          },
        }
        -- next. read through this
        local excluded = {
          ["com.microsoft.java.test.plugin.jar"] = true, -- duplicate plugin alias
          ["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
          ["jacocoagent.jar"] = true,
        }

        cfg.init_options.bundles = vim.tbl_filter(function(path)
          local name = vim.fs.basename(path)
          return not excluded[name] and not name:match("^org%.objectweb%.asm")
        end, cfg.init_options.bundles)

        return cfg
      end
    end,
  },
  {
    "rcasia/neotest-java",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap", -- for debugging (optional)
      "rcarriga/nvim-dap-ui", -- recommended
      "theHamsta/nvim-dap-virtual-text", -- recommended
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-java")({
            -- Optional configuration here
          }),
        },
      })
    end,
  },
}
