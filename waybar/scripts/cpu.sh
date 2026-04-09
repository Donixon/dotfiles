#!/bin/bash
prev=($(awk 'NR==1' /proc/stat))
sleep 0.5
curr=($(awk 'NR==1' /proc/stat))

prev_idle=$(( ${prev[4]} + ${prev[5]} ))
curr_idle=$(( ${curr[4]} + ${curr[5]} ))

prev_total=0
for v in "${prev[@]:1:7}"; do (( prev_total += v )); done
curr_total=0
for v in "${curr[@]:1:7}"; do (( curr_total += v )); done

d_idle=$(( curr_idle - prev_idle ))
d_total=$(( curr_total - prev_total ))
CPU=$(( (d_total - d_idle) * 100 / d_total ))

if [ "$CPU" -lt 30 ]; then
    CLASS="low"
elif [ "$CPU" -lt 60 ]; then
    CLASS="medium"
elif [ "$CPU" -lt 80 ]; then
    CLASS="high"
else
    CLASS="critical"
fi

echo "{\"text\": \"󰘚 ${CPU}%\", \"class\": \"$CLASS\", \"tooltip\": \"CPU gebruik: ${CPU}%\"}"
