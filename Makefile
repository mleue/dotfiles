# --restow unstows all "packages" first to remove any dead links
# */ means all directories in the current directory (excluding e.g. the Makefile)
# --target $(HOME) is unnecessary (since the default is "one level up"), but I like to be explicit
all:
	stow --verbose --target $(HOME) */
delete:
	stow --verbose --target $(HOME) --delete */
pipx-install:
	@echo "Installing pipx tools..."
	pipx install ./scripts/python/llm_cli/ --force
	@echo "Done!"
pipx-clean:
	@echo "Removing pipx tools..."
	pipx uninstall llm_cli 2>/dev/null || true
