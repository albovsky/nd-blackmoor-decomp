#!/bin/sh
# Run rc_headless on a script that starts by loading a save from the main menu, then the given steps.
#   RC_HEADLESS=build/rc_headless GAME_EXE=work/original/GAME.EXE RC_GAMEDIR=<scratch game dir> sh route_load.sh OUT_DIR SLOT_Y "steps"
# SLOT_Y is the y of the save's row in the Load & Save list (150 is the second row). The steps use the anchor S2010.CIF (first opened when the
# save loads). Saves are made in the game's own Load & Save screen (see ROUTES.md) and live in the Documents5 folder of RC_GAMEDIR.
set -eu
export RC_OUT=$1
export MAX_IMPORTS=${MAX_IMPORTS:-6000000}
LOAD="MAIN.CIF+1400:move:275,95;MAIN.CIF+2400:click:275,95,800;MAIN.CIF+9000:move:300,$2;MAIN.CIF+10000:click:300,$2,800;MAIN.CIF+14000:move:553,248;MAIN.CIF+15000:click:553,248,800;MAIN.CIF+20000:shot:0,0"
export INPUT="$LOAD;$3"
exec perl -e 'alarm 1500; exec @ARGV' "${RC_HEADLESS:-build/rc_headless}"
