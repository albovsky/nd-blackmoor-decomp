"""Shared reader of scenes.txt (written by mkscenes.py): {scene id: text block}. The first line of a block is the header "S2010 title=... bg=...", the
following lines are the action rows."""
import re
import sys
from pathlib import Path


def load_blocks(path='scenes.txt'):
    if not Path(path).exists():
        raise SystemExit('%s not found: run mkscenes.py first (it needs the decoded scene resources under work/analysis)' % path)
    blocks = {}
    for b in re.split(r'(?m)^SCENE ', Path(path).read_text()):
        if not b.strip():
            continue
        key = b.split(' ', 1)[0]
        if not re.fullmatch(r'S\d+', key):
            raise SystemExit('%s: scene header %r is not a scene id: regenerate it with mkscenes.py' % (path, key))
        blocks[key] = b
    return blocks
