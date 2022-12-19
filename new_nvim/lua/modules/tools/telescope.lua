local cmd = vim.api.nvim_command
cmd([[packadd sqlite.lua]])
cmd([[packadd project.nvim]])
cmd([[packadd telescope-fzf-native.nvim]])
cmd([[packadd telescope-frecency.nvim]])
cmd([[packadd telescope-zoxide]])
cmd([[packadd telescope-env.nvim]])
cmd([[packadd dir-telescope.nvim]])
cmd([[packadd git-worktree.nvim]])
cmd([[packadd nvim-notify]])
cmd([[packadd nvim-neoclip.lua]])
cmd([[packadd telescope-live-grep-args.nvim]])

local icons = { ui = require("modules.ui.icons").get("ui", true) }

local actions = require("telescope.actions.set")
local fixfolds = {
	hidden = true,
	attach_mappings = function(_)
		actions.select:enhance({
			post = function()
				vim.api.nvim_command(":normal! zx")
			end,
		})
		return true
	end,
}
local lga_actions = require("telescope-live-grep-args.actions")

require("telescope").setup({
	defaults = {
		initial_mode = "insert",
		prompt_prefix = " " .. icons.ui.Telescope,
		selection_caret = icons.ui.ChevronRight,
		entry_prefix = " ",
		scroll_strategy = "limit",
		set_env = { ["COLORTERM"] = "truecolor" },
		results_title = false,
		borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		layout_strategy = "horizontal",
		path_display = { "smart" }, -- absolute
		dynamic_preview_title = true,
		file_ignore_patterns = {
			".git/",
			".cache",
			"%.class",
			"%.pdf",
			"%.mkv",
			"%.mp4",
			"%.zip",
			"node_modules/",
			"target/",
			"docs/",
			".settings/",
		},
		layout_config = {
			-- prompt_position = "bottom",
			horizontal = {
				preview_width = 0.5,
			},
		},
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		mappings = {
			i = {
				["<C-x>"] = false,
				["<C-u>"] = false,
				["<C-d>"] = false,
				["<Esc>"] = require("telescope.actions").close,
				["<C-c>"] = require("telescope.actions").close,
				["<C-s>"] = require("telescope.actions").select_horizontal,
				["<C-v>"] = require("telescope.actions").select_vertical,
				["<C-t>"] = require("telescope.actions").select_tab,
				["<C-j>"] = require("telescope.actions").move_selection_next,
				["<C-k>"] = require("telescope.actions").move_selection_previous,
				["<C-/>"] = "which_key",
			},
			n = {
				["<Esc>"] = require("telescope.actions").close,
				["j"] = require("telescope.actions").move_selection_next,
				["k"] = require("telescope.actions").move_selection_previous,
				["H"] = require("telescope.actions").move_to_top,
				["M"] = require("telescope.actions").move_to_middle,
				["L"] = require("telescope.actions").move_to_bottom,
				["?"] = require("telescope.actions").which_key,
			},
		},
	},
	extensions = {
		-- conda = {
		-- 	home = "$HOME/tools/anaconda",
		-- },
		fzf = {
			fuzzy = false,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		frecency = {
			show_scores = true,
			show_unindexed = true,
			ignore_patterns = { "*.git/*", "*/tmp/*" },
			disable_devicons = false,
			workspaces = {
				-- ["conf"] = "/home/my_username/.config",
				-- ["data"] = "/home/my_username/.local/share",
				-- ["project"] = "/home/my_username/projects",
				-- ["wiki"] = "/home/my_username/wiki"
			},
		},
		live_grep_args = {
			auto_quoting = true, -- enable/disable auto-quoting
			-- define mappings, e.g.
			mappings = { -- extend mappings
				i = {
					["<C-k>"] = lga_actions.quote_prompt(),
					["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
				},
			},
		},
	},
	pickers = {
		buffers = fixfolds,
		find_files = fixfolds,
		git_files = fixfolds,
		grep_string = fixfolds,
		live_grep = fixfolds,
		oldfiles = fixfolds,
	},
})

-- zoxide config
local z_utils = require("telescope._extensions.zoxide.utils")
local builtin = require("telescope.builtin")

require("telescope._extensions.zoxide.config").setup({
	prompt_title = "[ Zoxide List ]",

	-- Zoxide list command with score
	list_command = "zoxide query -ls",
	mappings = {
		default = {
			action = function(selection)
				vim.api.nvim_command("cd " .. selection.path)
			end,
			after_action = function(selection)
				print("Directory changed to " .. selection.path)
			end,
		},
		["<C-s>"] = { action = z_utils.create_basic_command("split") },
		["<C-v>"] = { action = z_utils.create_basic_command("vsplit") },
		["<C-e>"] = { action = z_utils.create_basic_command("edit") },
		["<C-b>"] = {
			keepinsert = true,
			action = function(selection)
				builtin.file_browser({ cwd = selection.path })
			end,
		},
		["<C-f>"] = {
			keepinsert = true,
			action = function(selection)
				builtin.find_files({ cwd = selection.path })
			end,
		},
	},
})

-- dir-telescope config
-- this plugins are useful for big project, your can select a dir first and search within the dir,
--   instead of searching the whole project.
require("dir-telescope").setup({
	hidden = true,
	respect_gitignore = true,
})
-- INFO: <C-q> will save your queries in a quickfix list. this is the default binding for telescope.nvim

-- plugins should load after setup function
-- require("telescope").load_extension("dap")
require("telescope").load_extension("env")
require("telescope").load_extension("frecency")
require("telescope").load_extension("fzf")
require("telescope").load_extension("projects")
require("telescope").load_extension("zoxide")
require("telescope").load_extension("dir")
require("telescope").load_extension("notify")
require("telescope").load_extension("neoclip")
require("telescope").load_extension("git_worktree")
require("telescope").load_extension("live_grep_args")