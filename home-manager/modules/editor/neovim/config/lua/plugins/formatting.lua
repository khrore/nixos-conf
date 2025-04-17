return {
	-- configuring formatters
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			-- lua, fish and bash is already configured
			-- python = { "yapf" },
			-- nix = { "alejandra" },
			-- rust = { "rustfmt", lsp_format = "fallback" },
			-- c = { "clang-format" },
			-- cpp = { "clang-format" },
			-- cmake = { "cmake_format" },
			-- markdown = { "mdformat" },
		},
	},
}
