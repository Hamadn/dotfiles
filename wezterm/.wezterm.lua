local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("Iosevka Nerd Font Mono")
config.font_size = 20
config.window_padding = {
	left = 7,
	right = 7,
	top = 0,
	bottom = 0,
}

config.enable_kitty_graphics = true
config.audible_bell = "Disabled"
config.enable_tab_bar = false

config.color_scheme = "Hemisu Dark (Gogh)"

config.unix_domains = {
	{ name = "shared" },
}
config.default_domain = "shared"

local project_dirs = {
	wezterm.home_dir .. "/dotfiles",
}

local projects_path = wezterm.home_dir .. "/Projects"
local ok, entries = pcall(wezterm.glob, projects_path .. "/*")
if ok and entries then
	for _, dir in ipairs(entries) do
		table.insert(project_dirs, dir)
	end
end

local function choose_project()
	local choices = {}
	for _, dir in ipairs(project_dirs) do
		local name = dir:match("/([^/]+)$")
		table.insert(choices, { label = name, id = dir })
	end
	table.sort(choices, function(a, b)
		return a.label < b.label
	end)

	return wezterm.action.InputSelector({
		title = "Open Project",
		fuzzy = true,
		choices = choices,
		action = wezterm.action_callback(function(win, pane, id)
			if not id then
				return
			end
			win:perform_action(
				wezterm.action.SwitchToWorkspace({
					name = id:match("([^/]+)$"),
					spawn = { cwd = id },
				}),
				pane
			)
		end),
	})
end

config.keys = {
	{
		key = "p",
		mods = "CTRL|SHIFT",
		action = choose_project(),
	},
	{
		key = "f",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
}

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

--config.colors = {
--	foreground = "#CBE0F0",
--	background = "#000000",
--	cursor_bg = "#47FF9C",
--	cursor_border = "#47FF9C",
--	cursor_fg = "#011423",
--	selection_bg = "#033259",
--	selection_fg = "#CBE0F0",
--	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277FF", "#24EAF7", "#24EAF7" },
--	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#A277FF", "#24EAF7", "#24EAF7" },
--}

config.window_decorations = "NONE"

config.window_background_opacity = 0.85

return config
