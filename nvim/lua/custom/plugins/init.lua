-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	{
		"gioele/vim-autoswap",
		config = function()
			-- Enable tmux support if you use tmux
			vim.g.autoswap_detect_tmux = 1
		end,
	},
	{
		"okuuva/auto-save.nvim",
		version = "^1.0.0",
		cmd = "ASToggle",
		event = { "InsertLeave", "TextChanged" },
		opts = {
			-- Your config goes here or leave it empty
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					-- numbers = "buffer_id", -- display buffer IDs
					diagnostics = "nvim_lsp", -- show lsp diagnostics in the bufferline
					separator_style = "slant",
					show_close_icon = false,
					show_buffer_close_icons = false, -- Add this to disable close icons on buffers
					offsets = {
						filetype = "NvimTree",
						text = "File Explorer",
						highlight = "Directory",
						text_align = "left",
					},
				},
			})
		end,
	},
}
