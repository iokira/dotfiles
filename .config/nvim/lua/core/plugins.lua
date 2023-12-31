vim.api.nvim_create_user_command("PackerInstall", [[packadd packer.nvim | lua require("core.packers").install()]], { bang = true })
vim.api.nvim_create_user_command("PackerUpdate", [[packadd packer.nvim | lua require("core.packers").update()]], { bang = true })
vim.api.nvim_create_user_command("PackerSync", [[packadd packer.nvim | lua require("core.packers").sync()]], { bang = true })
vim.api.nvim_create_user_command("PackerClean", [[packadd packer.nvim | lua require("core.packers").clean()]], { bang = true })
vim.api.nvim_create_user_command("PackerCompile", [[packadd packer.nvim | lua require("core.packers").compile()]], { bang = true })
vim.api.nvim_create_user_command("PackerStatus", [[packadd packer.nvim | lua require("core.packers").status()]], { bang = true })
