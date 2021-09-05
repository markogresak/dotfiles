# Dotfiles

### zsh

Using [oh-my-zsh][oh-my-zsh], because it's awesome! Accompanied by `.zshrc`, which is mostly just fine-tuning `oh-my-zsh`, with addition of some custom aliases to be faster at common tasks, e.g. a roll-my-own [`wd`][wd] for a primitive working dir aliases and global variables (might not be the best idea, but it works for me).

### git

Global `.gitconfig` and `.gitignore` ignoring common OS and editor files.

### editor

[EditorConfig][editorconfig] file, shared between editors.

[Prettier][prettier] config for pretty code across supported files.

A very basic Vim config using native vim 8 package manager (see `:help packages`). Configured for use here and there, with the goal of fast open time, for example for use with git (commit, rebase, etc.). Using [`vim-sensible`][vim-sensible], [`vim-git`][vim-git] and some custom config for spell checking and better search.

### packages

Lists of packages and apps installed via [Homebrew][brew] and [npm][npm]. Also a reference list of Homebrew taps added, to enable automatic packages restore.

## Notes

~~Install `ffmpeg` using `brew install ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-libass --with-libquvi --with-libvorbis --with-libvpx --with-opus --with-x265`~~
Not supported in brew v2.0. Best option is to hope for sensible defaults.

[zsh]: http://www.zsh.org/
[wd]: https://github.com/mfaerevaag/wd
[oh-my-zsh]: https://github.com/robbyrussell/oh-my-zsh
[papercolor]: https://github.com/NLKNguyen/papercolor-theme
[editorconfig]: http://editorconfig.org/
[prettier]: https://prettier.io
[vim-sensible]: https://github.com/tpope/vim-sensible
[vim-git]: https://github.com/tpope/vim-git
[brew]: http://brew.sh/
[npm]: https://www.npmjs.com/
