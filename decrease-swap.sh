#!/bin/bash
cd "$(dirname "$0")"

LAST_SWAP="$((swapon --show | tail -n +2 | awk '{print $1}' && ls /swap.*) | sort | uniq -c | grep ' 2 ' | tail -1 | awk '{print $2}')"
if [ ! -z "$LAST_SWAP" ]
then
  # recalls swapped pages to memory to speedup swapoff
  # from https://unix.stackexchange.com/questions/45673/how-can-swapoff-be-that-slow#answer-325790
  perl -we 'for(`ps -e -o pid,args`) { if(m/^ *(\d+) *(.{0,40})/) { $pid=$1; $desc=$2; if(open F, "/proc/$pid/smaps") { while(<F>) { if(m/^([0-9a-f]+)-([0-9a-f]+) /si){ $start_adr=$1; $end_adr=$2; }  elsif(m/^Swap:\s*(\d\d+) *kB/s){ print "SSIZE=$1_kB\t gdb --batch --pid $pid -ex \"dump memory /dev/null 0x$start_adr 0x$end_adr\"\t2>&1 >/dev/null |grep -v debug\t### $desc \n" }}}}}' | sort -Vr | head
  sudo swapoff $LAST_SWAP
fi
