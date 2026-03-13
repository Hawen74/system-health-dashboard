# ----------------------------------------------------------------------
# .bashrc - Shell Environment Configuration
# ----------------------------------------------------------------------

export REPO_ROOT=$(dirname "$(readlink -f "$BASH_SOURCE")")

if [[ ":$PATH:" != *":$REPO_ROOT/bin:"* ]]; then
    export PATH="$PATH:$REPO_ROOT/bin"
fi

# Colors & Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias ..='cd ..'
alias cls='clear'
alias repo='cd ~/repo'

# Git branch in prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1='\[\e[34m\]\u@\h\[\e[m\]:\[\e[32m\]\w\[\e[36m\]$(parse_git_branch)\[\e[m\]\$ '

if [[ $- == *i* ]]; then
    repo
fi

echo "✅ Lab environment loaded. Type 'health-check.sh' to run the dashboard."
