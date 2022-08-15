#!/bin/bash

min=${1:-0}
max=${2:-0}
out=${3:-./data}

# COLORS! :)
red='\033[0;31m'
cyan='\033[0;36m'
blue='\033[0;34m'
green='\033[0;32m'
yellow='\033[0;33m'
nocolor='\033[0m'

red() {
  echo -e "${red}${1}${nocolor}"
}

green() {
  echo -e "${green}${1}${nocolor}"
}

cyan() {
  echo -e "${cyan}${1}${nocolor}"
}

blue() {
  echo -e "${blue}${1}${nocolor}"
}

yellow() {
  echo -e "${yellow}${1}${nocolor}"
}

read -d '' USAGE_MESSAGE <<- EOF

THM KoTH Data Scraper

Usage:
  ./scrape.sh START END [DIR]

Options:
  START       Starting game ID (integer, example: 1234)
  END         Ending game ID (integer, example: 4321)
  DIR         Output directory for json data (OPTIONAL, default='./data')
EOF

if [ ! $min -gt 0 ] || [ ! $max -gt $min ]; then
  red "Invalid input range: [$min, $max]"
  echo "$USAGE_MESSAGE"
  exit 1
fi

if [ ! -d $out ]; then
  yellow "Creating data output dir: $out"
  mkdir -p $out
fi

for i in $(seq $min $max); do
  game="https://tryhackme.com/games/koth/data/$i"
  json=$out/$i.json
  cyan "Check game #$i ($game -> $json)"
  curl -sL $game -o $json
  cat $json | grep -E '^{' > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    yellow "WARNING: Invalid JSON detected for #$i ($json)"
    exit 1
  fi
  if [ $((i % 100)) -eq 0 ]; then
    sleep 10
  elif [ $((i % 50)) -eq 0 ]; then
    sleep 5
  elif [ $((i % 10)) -eq 0 ]; then
    sleep 1
  fi
done
