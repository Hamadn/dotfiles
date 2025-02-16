return {
	"folke/zen-mode.nvim",
	config = function()
		local zen = require("zen-mode")

		zen.setup({
			plugins = {
				tmux = {
					enabled = true,
				},
				wezterm = {
					enabled = true,
				},

				options = {
					enabled = true,
					signcolumn = "no",
				},
			},
			window = {
				backdrop = 1,
			},
		})

		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Toggle ZenMode" })
	end,
}
