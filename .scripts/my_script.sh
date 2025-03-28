ad() {
  maxdepth=5
  if [ $# -gt 0 ] ; then
    maxdepth=$1
  fi
  DIR=`find * -maxdepth $maxdepth -type d -print 2> /dev/null | fzf-tmux` \
    && xcd "$DIR"
}

fd() {
  DIR=`cat ~/.dirs/dirs.txt 2> /dev/null | fzf-tmux` \
    && xcd "$DIR"
}

fe() {
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

pdir() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  xcd "$DIR"
}

# fd - cd to selected directory
xd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

kallbatch() {
  for i in ` ps -ef | grep bash | grep -v grep |  grep -v libexec    |  awk '  { print $2 } ' `
  do
    if [ $$ -ne $i ] ; then
      sudo kill -9 $i
    fi
  done 
}

cleandirfile() {
  rm -f /tmp/dirs.txt
  for i in `cat ~/.dirs/dirs.txt`
  do
    if [ -d $i ] ; then
      echo $i >> /tmp/dirs.txt
    fi
  done
  mv /tmp/dirs.txt ~/.dirs/dirs.txt
}
