if true then
	return {}
end
return {
	-- configuring linters
	"mfussenegger/nvim-lint",
	opts = {
		linters_by_ft = {
			-- fish is already configured
			lua = { "luacheck" },
			python = { "pylint" },
			nix = { "statix" },
			rust = { "clippy" },
			cpp = { "clangtidy" },
			c = { "clangtidy" },
			cmake = { "cmakelint" },
			sh = { "bash" },
			make = { "checkmake" },
			markdown = { "vale" },
		},
	},
}
