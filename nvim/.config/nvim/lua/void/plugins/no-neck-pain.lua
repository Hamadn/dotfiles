return {
	"shortcuts/no-neck-pain.nvim",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features

	config = function()
		local neck = require("no-neck-pain")

		neck.setup({
			mappings = {
				enabled = true,
			},
			integrations = {
				outline = {
					position = "right",
				},
			},
		})
	end,
}
