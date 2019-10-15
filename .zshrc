source /Users/onelocal/.bash_profile

PATH=$HOME/.node/bin:$PATH

# Open .zshrc to be edited in VS Code
alias changez="code ~/.zshrc"
# Re-run source command on .zshrc to update current terminal session with new settings
alias updatez="source ~/.zshrc"

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

# Allow the use of the z plugin to easily navigate directories
. /usr/local/etc/profile.d/z.sh

# Load rbenv automatically by appending
# the following to ~/.zshrc:
eval "$(rbenv init -)"

source $(dirname $(gem which colorls))/tab_complete.sh

alias ls='colorls --group-directories-first --almost-all'
alias ll='colorls --group-directories-first --almost-all --long' # detailed list view


gataweb() {
  osascript <<EOD
  tell application "iTerm2"
    tell first session of current tab of current window
      set name to "👀 ☕️"
      split horizontally with profile "Default"
      write text "haproxy -f /Users/onelocal/Documents/dev/gataweb/ops/haproxy/dev.cfg &"
      write text "redis-server &"
      write text "DEBUG=gata:* npm run --prefix /Users/onelocal/Documents/dev/gataweb watch-coffee"
      split vertically with profile "Default"
    end tell

    tell second session of current tab of current window
      set name to "👀 typescript"
      write text "npm run --prefix /Users/onelocal/Documents/dev/gataweb/server/modules build-watch"
      split vertically with profile "Default"
    end tell

    tell third session of current tab of current window
      set name to "🥤 watch dashboard"
      write text "gulp -f /Users/onelocal/Documents/dev/gataweb/gulpfile.js build-dashboard &&  gulp -f /Users/onelocal/Documents/dev/gataweb/gulpfile.js watch-dashboard"
      split vertically with profile "Default"
    end tell

    tell fourth session of current tab of current window
      set name to "🥤 watch admin"
      write text "gulp -f /Users/onelocal/Documents/dev/gataweb/gulpfile.js build-admin &&  gulp -f /Users/onelocal/Documents/dev/gataweb/gulpfile.js watch-admin"
    end tell

    tell fifth session of current tab of current window
      set name to "👀"
      write text "DEBUG=gata:* npm run --prefix /Users/onelocal/Documents/dev/gataweb watch"
    end tell
  end tell
EOD
}

alias gataweb='gataweb'
alias killg='kill -15'
alias kill-gataweb='killg $(pgrep redis-server haproxy) || brew services stop mongodb-community@3.6'


# Enable autocompletions
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
zmodload -i zsh/complist
# Save history so we get auto suggestions
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE
# Options
setopt auto_cd # cd by typing directory name if it's not a command
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances
# setopt correct_all # autocorrect commands
setopt interactive_comments # allow comments in interactive shells
# Improve autocompletion style
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion
# Load antibody plugin manager
source <(antibody init)
# Plugins
antibody bundle zdharma/fast-syntax-highlighting
antibody bundle zsh-users/zsh-autosuggestions
antibody bundle zsh-users/zsh-history-substring-search
antibody bundle zsh-users/zsh-completions
antibody bundle marzocchi/zsh-notify
antibody bundle buonomo/yarn-completion
# Keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char
# Theme
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
# # Simplify prompt if we're using Hyper
# if [[ "$TERM_PROGRAM" == "Hyper" ]]; then
#   SPACESHIP_PROMPT_SEPARATE_LINE=false
#   SPACESHIP_DIR_SHOW=false
#   SPACESHIP_GIT_BRANCH_SHOW=false
# fi
antibody bundle denysdovhan/spaceship-prompt
# Open new tabs in same directory
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  function chpwd {
    printf 'e]7;%sa' "file://$HOSTNAME${PWD// /%20}"
  }
  chpwd
fi

# Automatically switch node versions when a directory has a `.nvmrc` file
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
load-nvmrc
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/onelocal/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/onelocal/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/onelocal/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/onelocal/google-cloud-sdk/completion.zsh.inc'; fi
