#!/bin/sh
# Lift every ledger function, compile the result with the host into one shared library, and boot GAME.EXE from its entry point.
# Needs: GAME.EXE at work/original/GAME.EXE (or $GAME_EXE), python3 with pefile, capstone and unicorn, a C compiler.
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
PROJECT=$HERE/../..
cd "$HERE"
python3 -I lift_all.py "$HERE"
cc -O1 -fPIC -w -I"$PROJECT/src" -I"$HERE" -c all_lifted.c -o all_lifted.o
cc -O1 -fPIC -Wall -I"$PROJECT/src" -I"$HERE" -c host.c -o host.o
cc -shared -o libspike.so all_lifted.o host.o -lm
timeout 900 python3 -I driver.py "$@"
