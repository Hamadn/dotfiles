return {
	"theprimeagen/harpoon",

	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		local keymap = vim.keymap

		keymap.set("n", "<leader>a", mark.add_file, { desc = "Add file to harpoon" })
		keymap.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "Toggle harpoon" })

		keymap.set("n", "<C-b>", function()
			ui.nav_file(1)
		end, { desc = "Navigate to file 1 in harpoon menu" })

		keymap.set("n", "<C-t>", function()
			ui.nav_file(2)
		end, { desc = "Navigate to file 2 in harpoon menu" })

		keymap.set("n", "<C-n>", function()
			ui.nav_file(3)
		end, { desc = "Navigate to file 3 in harpoon menu" })

		keymap.set("n", "<C-s>", function()
			ui.nav_file(4)
		end, { desc = "Navigate to file 4 in harpoon menu" })
	end,
}
