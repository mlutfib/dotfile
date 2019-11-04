# Change default ls directory color to be readable on dark background
# (OSX)
export LSCOLORS='Exfxcxdxbxegedabagacad'

### ALIASES ###
alias reload='source ~/.bash_profile'
alias grep='grep --color=auto'
alias l='ls -lhaFG'
alias ll='ls -lhaFrtG'
alias h='history'
alias gh='history | grep -i $1'
alias psef='ps -ef | head -1;  ps -ef | grep -v grep | grep --color=auto -i $1'

# OSX
alias off='pmset displaysleepnow'
alias index='sudo mdutil -E /'

# -------------
# GIT RELATED
# ------------
alias gs="git status"
alias gac="git add . && git commit -m"
alias gp="git push" # + remote & branch names
alias gl="git pull" # + remote & branch names

# Pushing/pulling to origin remote
alias gpo="git push origin" # + branch name
alias glo="git pull origin" # + branch name

# Pushing/pulling to origin remote, master branch
alias gpom="git push origin master"
alias glom="git pull origin master"

alias gb="git branch" # + branch name
alias gc="git checkout" # + branch name
alias gcb="git checkout -b" # + branch name

### GIT COMPLETION ###
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

### EXPLAINSHELL ###
# Open a command in http://explainshell.com/: explain [command]
# From: https://github.com/schneems/explain_shell
function explain {
  # base url with first command already injected
  # $ explain tar
  #   => http://explainshel.com/explain/tar?args=
  url="http://explainshell.com/explain/$1?args="

  # removes $1 (tar) from arguments ($@)
  shift;

  # iterates over remaining args and adds builds the rest of the url
  for i in "$@"; do
    url=$url"$i""+"
  done

  # opens url in browser
  open $url
}

### 1337 PS1 PROMPT ###
COLOR_CYAN="\[\033[0;36m\]"
COLOR_RED="\[\033[0;31m\]"
COLOR_YELLOW="\[\033[0;33m\]"
COLOR_GREEN="\[\033[0;32m\]"
COLOR_OCHRE="\[\033[38;5;95m\]"
COLOR_BLUE="\[\033[0;94m\]"
COLOR_WHITE="\[\033[0;37m\]"
COLOR_RESET="\[\033[0m\]"

function git_status_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working tree clean" ]]; then
    echo $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo $COLOR_BLUE
  elif [[ $git_status =~ "Your branch is behind" ]] || [[ $git_status =~ "different commits each" ]]; then
    echo $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo $COLOR_GREEN
  else
    echo $COLOR_OCHRE
  fi
}

function colored_git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "$COLOR_GREEN|$(git_status_color)$branch$COLOR_GREEN| "
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "$COLOR_GREEN|$(git_status_color)$commit$COLOR_GREEN| "
  fi
}

function set_bash_prompt {
  PS1="\n"
  # timestamp
  PS1+="$COLOR_GREEN|$COLOR_BLUE\t$COLOR_GREEN|"
  # path
  PS1+=" $COLOR_CYAN\w"
  PS1+="\n"
  # git branch/status
  PS1+="$(colored_git_branch)"
  PS1+="🔥 $COLOR_RESET "
}

PROMPT_COMMAND=set_bash_prompt
