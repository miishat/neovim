-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

-- add list of plugins to install
return packer.startup(function(use)
	-- packer can manage itself
	use("wbthomason/packer.nvim")

	use("nvim-lua/plenary.nvim") -- lua functions that many plugins use

	use("bluz71/vim-nightfly-guicolors") -- preferred colorscheme

	use("christoomey/vim-tmux-navigator") -- tmux & split window navigation

	use("szw/vim-maximizer") -- maximizes and restores current window

	-- essential plugins
	use("tpope/vim-surround") -- add, delete, change surroundings (it's awesome)
	use("vim-scripts/ReplaceWithRegister") -- replace with register contents using motion (gr + motion)

	-- commenting with gc
	use("numToStr/Comment.nvim")

	-- vs-code like icons
	use("kyazdani42/nvim-web-devicons")

	-- file explorer
	use("nvim-tree/nvim-tree.lua")
    use({
        "akinsho/bufferline.nvim",
        requires = "nvim-tree/nvim-web-devicons"
    })

	-- statusline
	use("nvim-lualine/lualine.nvim")

	-- fuzzy finding w/ telescope
    use("kkharji/sqlite.lua")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
    use ({
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
            require"telescope".load_extension("frecency")
        end,
        requires = {"kkharji/sqlite.lua"}
    })
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder

	-- autocompletion
	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-buffer") -- source for text in buffer
	use("hrsh7th/cmp-path") -- source for file system paths

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- managing & installing lsp
    use("neovim/nvim-lspconfig")
    use("williamboman/mason-lspconfig.nvim")
    use("williamboman/mason.nvim")
    use("hrsh7th/cmp-nvim-lsp")
    use({"glepnir/lspsaga.nvim", branch = "main"})
    use("onsails/lspkind.nvim")

    -- formatting & linting
    use("jose-elias-alvarez/null-ls.nvim")
    use("jayp0521/mason-null-ls.nvim")
    use("lukas-reineke/indent-blankline.nvim")
    use({
        "mcauley-penney/tidy.nvim",
        config = function()
            require("tidy").setup()
        end
    })

	-- treesitter configuration
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
    use("p00f/nvim-ts-rainbow")
    use 'nvim-treesitter/nvim-treesitter-context'

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

    -- easymotion
    use({
        "ggandor/leap.nvim",
        config = function()
            local leap = require "leap"
            leap.set_default_keymaps()
        end,
    })
    use("karb94/neoscroll.nvim")

    -- git integration
	use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

	if packer_bootstrap then
		require("packer").sync()
	end
end)
