-- https://github.com/LunarVim/LunarVim/issues/2986
vim.opt.title = false

vim.opt.timeoutlen = 200
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.spell = false
vim.opt.spelllang = "en"

lvim.log.level = "warn"
lvim.format_on_save.enabled = true

local function close_floating()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

lvim.lsp.buffer_mappings.normal_mode["K"] = nil
vim.diagnostic.config({
  virtual_text = false
})

lvim.keys.normal_mode["<Esc><Esc>"] = close_floating

lvim.keys.normal_mode["o"] = "o<ESC>"
lvim.keys.normal_mode["O"] = "O<ESC>"
lvim.keys.normal_mode["<C-]>"] = ":bnext<cr>"
lvim.keys.visual_mode["p"] = "\"_dP"
lvim.keys.normal_mode["|"] = ":vsplit<cr>"
lvim.keys.normal_mode["-"] = ":split<cr>"

lvim.keys.visual_mode[",s"] = ":sort<cr>"
lvim.keys.normal_mode[",s"] = ":SymbolsOutline<cr>"
lvim.keys.normal_mode[",d"] = ":Bdelete<cr>"

lvim.lsp.buffer_mappings.normal_mode[",b"] = { vim.lsp.buf.hover, "Show hover" }
lvim.lsp.buffer_mappings.normal_mode[",B"] = { vim.lsp.buf.declaration, "Goto declaration" }
lvim.lsp.buffer_mappings.normal_mode[",r"] = { vim.lsp.buf.declaration, "Goto references" }
lvim.lsp.buffer_mappings.normal_mode[",,"] = { vim.lsp.buf.rename, "Rename" }
lvim.lsp.buffer_mappings.normal_mode[",w"] = { ':lua vim.diagnostic.goto_prev({float = false})<cr>',
  "Goto next diagnostic" }
lvim.lsp.buffer_mappings.normal_mode[",w"] = { ':lua vim.diagnostic.goto_next({float = false})<cr>',
  "Goto prev diagnostic" }

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

lvim.builtin.terminal.open_mapping = [[<C-t>]]
lvim.builtin.terminal.shell = "zsh"
-- To get into normal mode from the terminal to copy and paste
vim.keymap.set('t', "<Esc>", "<C-\\><C-n>")

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.cmp.formatting.max_width = 30
lvim.builtin.cmp.sources = {
  { name = "nvim_lsp" },
  { name = "path" },
  { name = "crates" },
  { name = "treesitter" },
  { name = "nvim_lua" },
  { name = "calc" },
}

lvim.builtin.treesitter.auto_install = true;
-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "comment",
  "c",
  "cpp",
  "dockerfile",
  "dot",
  "css",
  "go",
  "gomod",
  "hcl",
  "hjson",
  "html",
  "http",
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "lua",
  "make",
  "markdown",
  "nix",
  "python",
  "regex",
  "rust",
  "scss",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "yaml",
}
-- ---@usage disable automatic installation of servers
lvim.lsp.installer.setup.automatic_installation = false

lvim.builtin.treesitter.highlight.enable = true

-- -- nil is better than rnix for .nix files but needs to be manually configured
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "nil_ls" })
require("lvim.lsp.manager").setup("nil_ls", {})


local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "alejandra",
    filetypes = { "nix" }
  },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "statix",  filetypes = { "nix" } },
  { command = "deadnix", filetypes = { "nix" } },
}

vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require("lsp-inlayhints").on_attach(client, bufnr)
  end,
})

lvim.plugins = {
  { "tpope/vim-surround" },

  { "tpope/vim-repeat" },

  { 'famiu/bufdelete.nvim' },

  { 'NoahTheDuke/vim-just' },

  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = {
          -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            'class',
            'function',
            'method',
          },
        },
      }
    end
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },

  {
    "ruifm/gitlinker.nvim",
    event = "BufRead",
    config = function()
      require("gitlinker").setup {
        opts = {
          add_current_line_on_normal_mode = true,
          action_callback = require("gitlinker.actions").open_in_browser,
          print_true,
          mappings = "<leader>gy",
        },
      }
    end,
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function() require('crates').setup() end,
  },

  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit",
        },
        lastplace_open_folds = true,
      })
    end,
  },

  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },

  {
    "itchyny/vim-cursorword",
    event = { "BufEnter", "BufNewFile" },
    config = function()
      vim.api.nvim_command("augroup user_plugin_cursorword")
      vim.api.nvim_command("autocmd!")
      vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
      vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
      vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
      vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
      vim.api.nvim_command("augroup END")
    end
  },

  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require('symbols-outline').setup()
    end
  },

  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end,
  },

  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      require("lsp-inlayhints").setup({
        inlayHints = {
          typeHints = {
            prefix = "=> "
          },
        }
      })
    end,
  },

}
