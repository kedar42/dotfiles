# TODO

## General

- [ ] Look into zoxide for fish shell

## Some random stuff from past todo

### This is a list of things that I had in my todo list, but I don't remember too much about them, so I will just leave them here for now, might not be relevant anymore

- [ ] Add fzf tab completion (like zsh with box preview)
- [ ] Add unpack function to copy files one dir up
- [ ] Look into fisher and its plugins
- [ ] Autoinstall fisher and its plugins inside install script

```bash
source <(kubectl completion zsh)  # set up autocomplete in zsh into the current shell
echo '[[ $commands[kubectl] ]] && source <(kubectl completion zsh)' >> ~/.zshrc # add autocomplete permanently to your zsh shell
```
