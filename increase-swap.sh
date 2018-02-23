#!/bin/bash
cd "$(dirname "$0")"

NEXT_SWAP="$((swapon --show | tail -n +2 | awk '{print $1}' && ls /swap.*) | sort | uniq -c | grep ' 1 ' | head -1 | awk '{print $2}')"
if [ ! -z "$NEXT_SWAP" ]
then
  sudo swapon $NEXT_SWAP
else
  ./add_swap.sh
fi
