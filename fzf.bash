# Setup fzf
# ---------
if [[ ! "$PATH" == */home/jschultz/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/jschultz/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/jarvis/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
__fzf_select__() {
    local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
          -o -type f -print \
          -o -type d -print \
          -o -type l -print 2> /dev/null | cut -b3-"}"
    eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
        printf '%q ' "$item"
    done
    echo
}

if [[ $- =~ i ]]; then

  __fzf_use_tmux__() {
      [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ]
  }

  __fzfcmd() {
      __fzf_use_tmux__ &&
          echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
  }

  __fzf_select_tmux__() {
      local height
      height=${FZF_TMUX_HEIGHT:-40%}
      if [[ $height =~ %$ ]]; then
        height="-p ${height%\%}"
      else
          height="-l $height"
      fi

      tmux split-window $height "cd $(printf %q "$PWD"); FZF_DEFAULT_OPTS=$(printf %q "$FZF_DEFAULT_OPTS") PATH=$(printf %q "$PATH") FZF_CTRL_T_COMMAND=$(printf %q "$FZF_CTRL_T_COMMAND") FZF_CTRL_T_OPTS=$(printf %q "$FZF_CTRL_T_OPTS") bash -c 'source \"${BASH_SOURCE[0]}\"; RESULT=\"\$(__fzf_select__ --no-height)\"; tmux setb -b fzf \"\$RESULT\" \\; pasteb -b fzf -t $TMUX_PANE \\; deleteb -b fzf || tmux send-keys -t $TMUX_PANE \"\$RESULT\"'"
  }

  fzf-file-widget() {
      if __fzf_use_tmux__; then
        __fzf_select_tmux__
      else
          local selected="$(__fzf_select__)"
          READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
          READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
      fi
  }

  __fzf_cd__() {
      local cmd dir
      cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
         -o -type d -print 2> /dev/null | cut -b3-"}"
      dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m) && printf 'cd %q' "$dir"
  }

  __fzf_history__() (
      local line
      shopt -u nocaseglob nocasematch
      line=$(
          HISTTIMEFORMAT= history |
              FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS --tac --sync -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS +m" $(__fzfcmd) |
              command grep '^ *[0-9]') &&
          if [[ $- =~ H ]]; then
            sed 's/^ *\([0-9]*\)\** .*/!\1/' <<< "$line"
          else
              sed 's/^ *\([0-9]*\)\** *//' <<< "$line"
          fi
  )

  if [[ ! -o vi ]]; then
    # Required to refresh the prompt after fzf
    bind '"\er": redraw-current-line'
    bind '"\e^": history-expand-line'

    # CTRL-T - Paste the selected file path into the command line
    if [ $BASH_VERSINFO -gt 3 ]; then
      bind -x '"\C-\M-f": "fzf-file-widget"'
    elif __fzf_use_tmux__; then
      bind '"\C-\M-f": " \C-u \C-a\C-k`__fzf_select_tmux__`\e\C-e\C-y\C-a\C-d\C-y\ey\C-h"'
    else
        bind '"\C-\M-f": " \C-u \C-a\C-k`__fzf_select__`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
    fi

    # CTRL-R - Paste the selected command from history into the command line
    bind '"\C-\M-r": " \C-e\C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er\e^"'

    # ALT-C - cd into the selected directory
    bind '"\C-\M-o": " \C-e\C-u`__fzf_cd__`\e\C-e\er\C-m"'
  fi

fi

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -aux | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# Git commands
# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi) || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

# fcoc - checkout git commit
fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# Set up fzf key bindings and fuzzy completion
FZF_CTRL_T_COMMAND= FZF_ALT_C_COMMAND= eval "$(fzf --bash)"
bind '"\C-r": reverse-search-history'

