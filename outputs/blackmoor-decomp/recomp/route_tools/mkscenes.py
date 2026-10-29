"""Write scenes.txt: the action rows of every decoded scene resource, one block per scene named by its id (S2010), through the production scene parser.
  python3 mkscenes.py [scenes.txt]
Needs a C compiler and the decoded resources of the owner's game under work/analysis (hiff-resources.json and hiff-resources/NNNN.bin). The output holds the
rows' type bytes and bodies (hotspot geometry and scene ids), derived from the local game: keep it out of git."""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parents[1]                       # outputs/blackmoor-decomp
ANALYSIS = PROJECT.parents[1] / 'work' / 'analysis'
out_path = Path(sys.argv[1] if len(sys.argv) > 1 else 'scenes.txt')
index = json.loads((ANALYSIS / 'hiff-resources.json').read_text())['resources']
scenes = {str(ANALYSIS / 'hiff-resources' / Path(r['path']).name): r['name'] for r in index if r['name'][:1] == 'S' and r['name'][1:].isdigit()}
with tempfile.TemporaryDirectory() as tmp:
    exe = Path(tmp) / 'scenedump'
    subprocess.run(['cc', '-std=c11', '-O1', '-I', str(PROJECT / 'src'), str(HERE / 'scenedump.c'), str(PROJECT / 'src/scene_resource.c'),
                    str(PROJECT / 'src/hiff.c'), '-o', str(exe)], check=True)
    text = subprocess.run([str(exe), *scenes], check=True, capture_output=True, text=True).stdout
lines = []
for ln in text.splitlines():
    if ln.startswith('SCENE '):
        path, _, rest = ln[6:].partition(' ')
        ln = 'SCENE %s %s' % (scenes[path], rest)
    lines.append(ln)
out_path.write_text('\n'.join(lines) + '\n')
print('wrote', out_path, len(scenes), 'scenes')
