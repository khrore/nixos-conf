return {
	-- configuring formatters
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			-- lua, fish, bash and nix is already configured
			python = { "ruff_format" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			rust = { "rustfmt", lsp_format = "fallback" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			cmake = { "cmake_format" },
			markdown = { "mdformat" },
			-- nu = { "nufmt" }, -- so buggy
		},
	},
}
