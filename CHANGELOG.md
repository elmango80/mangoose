# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-12-05

### Changed - BREAKING CHANGES

- **Reorganized project structure into modular folders**
  - `core/` - Base functions (colors, print, utils, spinners)
  - `git/` - Git-related functions
  - `productivity/` - Productivity tools
  - `deployment/` - Deployment system
  - `testing/` - WireMock and testing
  - `aliases/` - All aliases
  - `docs/` - Complete documentation

- **File paths have changed** - Users need to update their `.zshrc` imports
  - Old: `source ~/.config/zsh/functions/*.zsh`
  - New: Module-based imports (see README.md)

### Added

- **Automated installer script** (`install.sh`)
  - One-command installation
  - Handles updates and reinstalls
  - Automatic `.zshrc` backup
  - Smart configuration detection

- **Module-specific READMEs**
  - Each folder now has its own README
  - Quick reference for module contents
  - Usage examples and dependencies

- **Comprehensive documentation**
  - 9 detailed documentation files in `docs/`
  - Updated main README with new structure
  - Installation instructions for all scenarios
  - Dependency order clearly documented

### Improved

- **Code organization** - Better maintainability
- **Dependency management** - Clear load order
- **Module discovery** - Easier to find functions
- **Documentation navigation** - Structured and linked

## [1.0.0] - 2024-12-05

### Added

- Initial release with comprehensive Zsh functions
- **Core utilities**
  - Color system (ANSI, 256, RGB)
  - Message system with icons
  - Spinner animations
  - Utility functions

- **Git functions**
  - `clean_repository` - Clean stale branches
  - `update_master_repo` - Update main branch
  - Batch operations for multiple repos

- **Productivity tools**
  - `phoenix` - Restart Node.js projects
  - `goto` - Interactive directory navigator
  - `seek_and_destroy` - Recursive directory cleanup

- **Deployment system**
  - Multi-environment deployment to Quicksilver
  - Interactive version selector
  - Dry-run mode
  - Error handling and reporting

- **Testing utilities**
  - WireMock server management
  - Admin API support

- **90+ aliases**
  - NPM and Yarn shortcuts
  - Git aliases
  - Navigation shortcuts
  - Cleanup aliases

- **Complete documentation**
  - Main README
  - Per-module documentation
  - Examples and use cases
  - Best practices

---

## Migration Guide v1.x → v2.0

### What Changed

File locations have moved to module folders. Your existing `.zshrc` configuration will no longer work.

### How to Migrate

#### Option 1: Use the installer (Recommended)

```bash
# The installer will handle everything
curl -fsSL https://raw.githubusercontent.com/elmango80/zsh-functions/master/install.sh | zsh
```

#### Option 2: Manual migration

1. **Backup your current .zshrc**
   ```bash
   cp ~/.zshrc ~/.zshrc.backup
   ```

2. **Remove old imports**
   Delete or comment out old lines like:
   ```bash
   source ~/.config/zsh/functions/*.zsh
   source ~/.config/zsh/functions/colors.zsh
   # etc.
   ```

3. **Add new module-based imports**
   ```bash
   # Core (required first)
   source ~/.config/zsh/functions/core/colors.zsh
   source ~/.config/zsh/functions/core/utils.zsh
   source ~/.config/zsh/functions/core/print.zsh
   source ~/.config/zsh/functions/core/spinners.zsh
   
   # Feature modules
   source ~/.config/zsh/functions/git/git.zsh
   source ~/.config/zsh/functions/productivity/productivity.zsh
   source ~/.config/zsh/functions/deployment/deploy.zsh
   source ~/.config/zsh/functions/testing/wiremock.zsh
   source ~/.config/zsh/functions/aliases/aliases.zsh
   ```

4. **Update the repository**
   ```bash
   cd ~/.config/zsh/functions
   git pull
   ```

5. **Reload your shell**
   ```bash
   source ~/.zshrc
   ```

### Verify Migration

Test that functions work:

```bash
phoenix --help      # Should show help
deploy --help       # Should show help
msg "Test" --success  # Should show green message
```

### Rollback (if needed)

```bash
# Restore backup
cp ~/.zshrc.backup ~/.zshrc
source ~/.zshrc

# Or checkout previous version
cd ~/.config/zsh/functions
git checkout v1.0.0
```

---

## Support

- **Issues**: [GitHub Issues](https://github.com/elmango80/zsh-functions/issues)
- **Docs**: [README.md](./README.md)
- **Modules**: See individual module READMEs
