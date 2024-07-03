#!/usr/bin/env bash

if [[ "$1" == "-h" || $1 == "--help" || $1 == "-help"  || $# -eq 0 ]]; then
  echo -e "\e[1mprolapse\e[0m - cmd tool for making timelapse videos via scrot/grim & ffmpeg
\e[1mExample: \e[0m
  prolapse -t 10 -d Pictures/wnlwm/ -o Videos/wnlwm.mp4
\e[1mExit: \e[0m
  while running, press ctrl-c and your video will be on your way OR use count/len flags
\e[1mFlags:\e[0m
  -h - help
  -t - time between frames (no default)
  -d - picture output dir (if not specified, uses mktemp -d)
  -o - final video location (default is out.mp4)
  -f - fps (default is 30)
  -q - quiet mode (default)
  -v - verbose mode
  -x - delete images after finished \e[41;97m(EXTREMELY DANGEROUS - DELETES \e[1mEVERYTHING\e[0;41;97m IN OUTPUT DIR)\e[0m
  -l - length of video in seconds(optional)
  -c - length of video in image count(optional)
  [don't use those 2 in the same place, obv]
  this program \e[1m*WILL*\e[0m overwrite any existing images already taken by it."
  exit 1
fi
args=("$@")
DELAY=5
COUNT=0
OUTPUT_DIR="$(mktemp -d)"
VID_NAME="out.mp4"
FPS=30
QUIET=1
DEL=0
if [ $XDG_SESSION_TYPE = "wayland" ]; then
   SCREENCAP="grim"
else
   SCREENCAP="scrot -o -F"
fi
i=0
len=0
trap '' INT
while [[ $i -lt $# ]]; do
  flag=${args[$i]}
  case $flag in
    "-f")
      FPS=${args[$((i+1))]}
      if [[ $len -gt 0 ]]; then
        COUNT=$((len*FPS))
      fi
      ;;
    "-q")
      QUIET=1
      ;;
    "-v")
      QUIET=0
      ;;
    "-l")
      len=${args[$((i+1))]}
      COUNT=$((len*FPS))
      ;;
    "-c")
      COUNT=${args[$((i+1))]}
      ;;
    "-t")
      DELAY=${args[$((i+1))]}
      ;;
    "-d")
      OUTPUT_DIR="${args[$((i+1))]}"
      ;;
    "-o")
      VID_NAME="${args[$((i+1))]}"
      ;;
    "-x")
      DEL=1
      ;;
  esac
  i=$((i+1))
done

if [[ DEL -eq 1 ]]; then
	echo "Hope you have a backup! -x is activated. :^)"
fi

(TAKEN=0
if [[ $COUNT -eq 0 ]]; then
  while true; do
    trap '-' INT
    $SCREENCAP "$OUTPUT_DIR/screenshot-$TAKEN.png"
    if [[ $QUIET -eq 0 ]]; then
      echo "Screenshot $TAKEN took, saved at '$OUTPUT_DIR/screenshot-$TAKEN.png'"
    fi
    TAKEN=$((TAKEN+1))
    sleep $DELAY
  done
else
  while [[ $COUNT -gt 0 ]]; do
    trap '-' INT
    $SCREENCAP -o -F "$OUTPUT_DIR/screenshot-$TAKEN.png"
    if [[ $QUIET -eq 0 ]]; then
      echo "Screenshot $TAKEN took, saved at '$OUTPUT_DIR/screenshot-$TAKEN.png'
      screenshots remaining: $COUNT"
    fi
    TAKEN=$((TAKEN+1))
    sleep $DELAY
    COUNT=$((COUNT-1))
  done
fi
)
echo "Taking screenshots finished, making video via FFMPEG..."
ffmpeg -r $FPS -f image2 -i "$OUTPUT_DIR/screenshot-%d.png" $VID_NAME
if [[ $DEL -eq 1 ]]; then
  echo "Deleting pics in $OUTPUT_DIR"
  rm $OUTPUT_DIR/*
fi
