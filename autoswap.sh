#!/bin/bash
cd "$(dirname "$0")"

OLD_PID="$(cat pid)"
if [ ! -z "$OLD_PID" ]
then
  kill $OLD_PID
fi

# Increase swap space if available memory is less than threshold
INCREASE_THRESHOLD_G=4

# Decrease swap space if available memory is more than threshold
DECREASE_THRESHOLD_G=8

(
  echo $BASHPID > pid;
  while [ 1 ]
  do
    AVAILABLE_MEM="$(($(free -g | grep Mem: | awk '{print $7}') + $(free -g | grep Swap: | awk '{print $4}')))"
    if [ "$AVAILABLE_MEM" -lt "$INCREASE_THRESHOLD_G" ]
    then
      echo "[$(date -Is)] Increasing swap" >> ./swap.log
      ./increase-swap.sh >> ./swap.log 2>&1
    elif [ "$AVAILABLE_MEM" -gt "$DECREASE_THRESHOLD_G" ]
    then
      echo "[$(date -Is)] Decreasing swap" >> ./swap.log
      ./decrease-swap.sh >> ./swap.log 2>&1
    fi
    sleep 1
  done
) &
echo Started autoswap
