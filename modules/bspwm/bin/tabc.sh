#!/usr/bin/env sh
# Adapted from https://gist.github.com/jpentland/468a42c172eb607bb950f5d00606312c

get_root_wid() {
  xwininfo -root | awk '/Window id:/{print $4}'
}

get_clients() {
  id=$1
  xwininfo -id $id -children | sed -n '/[0-9]\+ \(child\|children\):/,$s/ \+\(0x[0-9a-z]\+\).*/\1/p'
}

get_class() {
  id=$1
  xprop -id $id | sed -n '/WM_CLASS/s/.*, "\(.*\)"/\1/p'
}

pop_tabbed() {
  tabbed=$1; shift
  if [ "$(get_class $tabbed)" != "tabbed" ]; then
     notify-send "Not an instance of tabbed"
     exit 1
  fi
}

cmd=$1; shift

command -v "xdotool" 1>/dev/null || (notify-send "please install xdotool"; exit 1)

case $cmd in
  add)
    pop_tabbed $@; shift
    wid=$1; shift
    xdotool windowreparent $wid $tabbed
    break
    ;;
  remove)
    pop_tabbed $@; shift
    wid=$1; shift
    xdotool windowreparent $wid $(get_root_wid)
    break
    ;;
  list)
    pop_tabbed $@; shift
    get_clients $tabbed
    break
    ;;
  wrap)
    wid=$1
    inst=`tabbed -d`
    xdotool windowreparent $wid $inst
    break
    ;;
esac
