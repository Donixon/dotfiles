# ── History ───────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY          # sla timestamp + duur op
setopt INC_APPEND_HISTORY        # meteen opslaan, niet bij afsluiten
setopt HIST_IGNORE_ALL_DUPS      # geen dubbele entries
setopt HIST_FIND_NO_DUPS         # sla dubbelen over bij zoeken
setopt HIST_REDUCE_BLANKS        # extra spaties verwijderen
setopt HIST_IGNORE_SPACE         # commando's met spatie vooraan niet opslaan

# ── Navigatie ─────────────────────────────────────────────────────────────
setopt AUTO_CD                   # typ mapnaam zonder 'cd'
setopt AUTO_PUSHD                # cd houdt een history bij
setopt PUSHD_IGNORE_DUPS         # geen dubbelen in map-history
setopt PUSHD_SILENT              # geen output bij pushd/popd

# ── Globbing ──────────────────────────────────────────────────────────────
setopt EXTENDED_GLOB             # krachtigere glob patronen
setopt GLOBDOTS                  # match ook verborgen bestanden
setopt NO_CASE_GLOB              # case-insensitive bestanden zoeken

# ── Overig ────────────────────────────────────────────────────────────────
setopt INTERACTIVE_COMMENTS      # # als commentaar in terminal
setopt NO_BEEP                   # geen geluid bij errors
setopt CORRECT                   # spellingscontrole voor commando's
setopt COMPLETE_IN_WORD          # completion ook midden in een woord

# ── Completion ────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case-insensitief
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}── %d%f'
zstyle ':completion:*:warnings' format '%F{red}geen resultaten%f'

# ── Key bindings ──────────────────────────────────────────────────────────
bindkey -e
bindkey '^[[A'  history-beginning-search-backward  # pijl omhoog
bindkey '^[[B'  history-beginning-search-forward   # pijl omlaag
bindkey '^[[H'  beginning-of-line                  # Home
bindkey '^[[F'  end-of-line                        # End
bindkey '^[[3~' delete-char                        # Delete
bindkey '^[[1;5C' forward-word                     # Ctrl+→
bindkey '^[[1;5D' backward-word                    # Ctrl+←

# Bewerk huidig commando in $EDITOR (Ctrl+E)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

# ── Prompt ────────────────────────────────────────────────────────────────
autoload -Uz vcs_info add-zsh-hook

zstyle ':vcs_info:git:*' formats ' %F{green}(%b)%f'
zstyle ':vcs_info:*' enable git

_timer_start() { _cmd_start=$SECONDS }
_timer_stop()  {
    local elapsed=$(( SECONDS - ${_cmd_start:-$SECONDS} ))
    (( elapsed >= 3 )) && _cmd_time="${elapsed}s" || _cmd_time=""
    unset _cmd_start
}

add-zsh-hook preexec _timer_start
add-zsh-hook precmd  _timer_stop
add-zsh-hook precmd  vcs_info

setopt PROMPT_SUBST
PROMPT=$'\n''%F{cyan}%~%f${vcs_info_msg_0_} %(?.%F{green}✓%f.%F{red}✗%f)${_cmd_time:+ %F{yellow}${_cmd_time}%f}
%F{magenta}❯%f '

# ── Gekleurde man pages ───────────────────────────────────────────────────
export LESS_TERMCAP_mb=$'\e[1;31m'   # begin blink
export LESS_TERMCAP_md=$'\e[1;36m'   # begin bold (cyan)
export LESS_TERMCAP_me=$'\e[0m'      # reset bold/blink
export LESS_TERMCAP_so=$'\e[01;33m'  # statusbalk (geel)
export LESS_TERMCAP_se=$'\e[0m'      # reset statusbalk
export LESS_TERMCAP_us=$'\e[1;32m'   # begin underline (groen)
export LESS_TERMCAP_ue=$'\e[0m'      # reset underline

# ── Functies ──────────────────────────────────────────────────────────────

# Map aanmaken en er meteen in gaan
mkcd() { mkdir -p "$@" && cd "$_" }

# Elk archief uitpakken met één commando
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1"   ;;
            *.tar.gz)  tar xzf "$1"   ;;
            *.tar.xz)  tar xJf "$1"   ;;
            *.tar.zst) tar --zstd -xf "$1" ;;
            *.tar)     tar xf  "$1"   ;;
            *.bz2)     bunzip2 "$1"   ;;
            *.gz)      gunzip  "$1"   ;;
            *.zip)     unzip   "$1"   ;;
            *.7z)      7z x    "$1"   ;;
            *.rar)     unrar x "$1"   ;;
            *)         echo "'$1' kan ik niet uitpakken" ;;
        esac
    else
        echo "'$1' is geen bestand"
    fi
}

# ls automatisch na cd
chpwd() { ls --color=auto }

# ── Aliassen ──────────────────────────────────────────────────────────────
alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias la='ls -lah --color=auto'
alias lt='ls -lht --color=auto'        # gesorteerd op tijd
alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'                      # - gaat terug naar vorige map

alias rm='rm -i'                       # vraag bevestiging
alias cp='cp -i'
alias mv='mv -i'

alias zr='source ~/.zshrc'            # herlaad zsh config
alias ze='$EDITOR ~/.zshrc'           # bewerk zsh config

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# ── Suffix aliassen ───────────────────────────────────────────────────────
alias -s {md,txt,conf,log}=nano        # open direct met nano

# ── Omgeving ──────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nano
