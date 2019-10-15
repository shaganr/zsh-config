# zsh-config
Make that terminal look 🔥. An example of my current .zshrc is included but feel free to install what you like. 

## Download + Install these

1. Download and install (iTerm2)[https://iterm2.com/] 
2. Install zsh using `brew install zsh` ( Note: MacOS Catalina's default is zsh )
    a. Switch shells to zsh by running this `chsh -s /bin/zsh`
    b. Create a file called `.zshrc` on your root directory i.e `/Users/Shagan`
    c. Create an easy shortcut to edit/apply changes to your zshrc
        - `alias changez="code ~/.zshrc"`
        - `alias updatez="source ~/.zshrc"`
3. Install spaceship prompt `npm install -g spaceship-prompt`
![Spaceship Prompt](/assets/spaceship-prompt.png)
4. Install zsh-syntax-highlighting
    a. `cd /usr/local/share/zsh` ( Create this dir if does not exist )
    b. `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git`
    c. `echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc`
    d. Run `updatez`
5. Install `z` for dir navigation
    a. `mkdir -p /usr/local/etc/profile.d`
    b. `cd /usr/local/etc/profile.d`
    c. `touch z.sh`
    d. Copy the contents of z.sh from this repo https://github.com/rupa/z
6. Colorful `ls`
    a. Follow instructions from here https://github.com/athityakumar/colorls
    b. Add ` alias ls='colorls --group-directories-first --almost-all' ` and ` alias ll='colorls --group-directories-first --almost-all --long' ` to your .zshrc
7. Automatically switch to the correct node version if a .nvmrc file exists
    a. Add the following to your .zshrc 
    ` # Automatically switch node versions when a directory has a `.nvmrc` file
autoload -U add-zsh-hook
# Zsh hook function
load-nvmrc() {
    local node_version="$(nvm version)" # Current node version
    local nvmrc_path="$(nvm_find_nvmrc)" # Path to the .nvmrc file

    # Check if there exists a .nvmrc file
    if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    # Check if the node version in .nvmrc is installed on the computer
    if [ "$nvmrc_node_version" = "N/A" ]; then
        # Install the node version in .nvmrc on the computer and switch to that node version
        nvm install
    # Check if the current node version matches the version in .nvmrc
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
        # Switch node versions
        nvm use
    fi
    # If there isn't an .nvmrc make sure to set the current node version to the default node version
    elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
    fi
}
# Add the above function when the present working directory (pwd) changes
add-zsh-hook chpwd load-nvmrc
load-nvmrc `
8. Launch Gataweb project
    a. Change paths of osascript to point to your gataweb project.
    b. Add other configurations as necessary.
