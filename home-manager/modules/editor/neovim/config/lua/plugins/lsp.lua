return {
	-- configuring lsp
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			-- lua is already configured
			-- pyright = {}, -- python
			-- nil_ls = {}, -- nix
			rust_analyzer = { -- rust
				settings = {
					["rust_analyzer"] = {
						imports = {
							granularity = {
								group = "module",
							},
							prefix = "self",
						},
						cargo = {
							buildScripts = {
								enable = true,
							},
						},
						procMacro = {
							enable = true,
						},
					},
				},
			},
			-- clangd = {}, -- c/c++
			-- cmake = {}, -- cmake
			fish_lsp = {}, -- fish
			bashls = {}, -- bash
			-- marksman = {}, -- markdown
			-- yamlls = {}, -- yaml
			hyprls = {}, -- hyprlang
		},
	},
}
