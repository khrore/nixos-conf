return {
	"hkupty/iron.nvim",
	config = function()
		local iron = require("iron.core")

		iron.setup({
			config = {
				-- Whether a repl should be discarded or not
				scratch_repl = true,
				-- Your repl definitions come here
				repl_definition = {
					sh = {
						-- Can be a table or a function that
						-- returns a table (see below)
						command = { "zsh" },
					},
				},
				-- How the repl window will be displayed
				-- See below for more information
				repl_open_cmd = require("iron.view").right(80),
			},
			-- Iron doesn't set keymaps by default anymore.
			-- You can set them here or manually add keymaps to the functions in iron.core
			keymaps = {
				send_motion = "<leader>rs",
				visual_send = "<leader>rt",
				send_file = "<leader>rf",
				send_line = "<leader>rl",
				send_mark = "<leader>rmm",
				mark_motion = "<leader>rmc",
				mark_visual = "<leader>rmc",
				remove_mark = "<leader>rmd",
				cr = "<leader>r<cr>",
				interrupt = "<leader>r<leader>",
				exit = "<leader>rq",
				clear = "<leader>rc",
			},
			-- If the highlight is on, you can change how it looks
			-- For the available options, check nvim_set_hl
			highlight = {
				italic = true,
			},
			ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
		})

		-- iron also has a list of commands, see :h iron-commands for all available commands
		vim.keymap.set("n", "<leader>rcs", "<cmd>IronRepl<cr>")
		vim.keymap.set("n", "<leader>rcr", "<cmd>IronRestart<cr>")
		vim.keymap.set("n", "<leader>rcf", "<cmd>IronFocus<cr>")
		vim.keymap.set("n", "<leader>rch", "<cmd>IronHide<cr>")
	end,
}
