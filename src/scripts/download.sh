#!/bin/bash
EW_BIN="$HOME/.cache/emulator-wtf/ew-cli"

# download ew-cli wrapper if not fetched already
if [[ ! -f "$EW_BIN" ]]; then
  mkdir -p ~/.cache/emulator-wtf
  curl -sL https://maven.emulator.wtf/releases/ew-cli -o "$EW_BIN"
  chmod a+x "$EW_BIN"
fi

# poke wrapper to fetch the jar if necessary
$EW_BIN --version
