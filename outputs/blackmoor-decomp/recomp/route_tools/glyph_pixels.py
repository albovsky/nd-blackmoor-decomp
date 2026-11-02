"""Preserved image-only glyph input policy; the original game owns all results.

The caller supplies and pins its local atlas. No atlas/resource/template bytes
are distributed. The planning heuristic below is unchanged from the observed
private controller; its score estimate is not gameplay acceptance.
"""
from pathlib import Path
from collections import Counter
from itertools import combinations, permutations
import hashlib
import json
import re

from bul_live import crop, digest, ppm, require


def load_atlas(path, expected_sha256):
    require(digest(path) == expected_sha256, 'atlas SHA-256 mismatch')
    document = json.loads(Path(path).read_text())
    hashes = document.get('tile_hashes') if isinstance(document, dict) else None
    require(isinstance(hashes, dict) and len(hashes) == 25
            and all(isinstance(key, str) and re.fullmatch('[0-9a-f]{64}', key) for key in hashes),
            'atlas must contain exactly 25 SHA-256 tile crop keys')
    # Reference/source-path metadata is deliberately ignored.
    return frozenset(hashes)


def read_board(path, known_hashes):
    pixels = ppm(Path(path))
    kinds, board, hashes = {}, [], []
    for r in range(5):
        row, hs = [], []
        for c in range(7):
            tile = crop(pixels, 75 + 41*c, 68 + 41*r, 34, 34)
            value = hashlib.sha256(tile).hexdigest()
            row.append(kinds.setdefault(value, len(kinds)))
            hs.append(value)
        board.append(row)
        hashes.append(hs)
    unknown = [(r, c) for r in range(5) for c in range(7) if hashes[r][c] not in known_hashes]
    if unknown:
        raise ValueError('not a complete settled glyph board; unknown actual tile crops: ' + str(unknown))
    return board, hashes


def run_at(board,cell,axis):
    r,c=cell; kind=board[r][c]; dr,dc=axis; run=[cell]
    for sign in [-1,1]:
        rr,cc=r+dr*sign,c+dc*sign
        while 0<=rr<5 and 0<=cc<7 and board[rr][cc]==kind:
            run.append((rr,cc));rr+=dr*sign;cc+=dc*sign
    return run if len(run)>=3 else []

def runs_at(board,cell):
    return [run_at(board,cell,(0,1)),run_at(board,cell,(1,0))]

def swapped(board,a,b):
    out=[row[:] for row in board];out[a[0]][a[1]],out[b[0]][b[1]]=out[b[0]][b[1]],out[a[0]][a[1]];return out

def value(run):
    n=len(run);return n*50+(50 if n==4 else 150 if n==5 else 0)

def one_swap(board):
    cells=[(r,c) for r in range(5) for c in range(7)]; best=None
    for a,b in combinations(cells,2):
        if board[a[0]][a[1]]==board[b[0]][b[1]]: continue
        nxt=swapped(board,a,b)
        for first,second in [(a,b),(b,a)]:
            horizontal=run_at(nxt,first,(0,1))
            if horizontal:
                candidate={'swaps':[[first,second]],'horizontal_match':horizontal,'minimum_expected_score':value(horizontal),'basis':'horizontal run through first checked swap endpoint'}
                rank=(candidate['minimum_expected_score'],-first[0],-first[1])
                if best is None or rank>best[0]:best=(rank,candidate)
    return None if best is None else best[1]

def plan(board):
    direct=one_swap(board)
    if direct:return direct
    counts=Counter(v for row in board for v in row)
    # A triple can always be assembled in <=2 swaps if a kind occurs >=3 times.
    # Stop immediately if any earlier endpoint makes a run; its refill is unknown.
    for kind,count in counts.most_common():
        if count<3:break
        for r in range(5):
            for c in range(5):
                target=[(r,c+j) for j in range(3)]
                if not any(board[x][y]==kind for x,y in target):continue
                missing=[q for q in target if board[q[0]][q[1]]!=kind]
                for order in permutations(missing):
                    current=[row[:] for row in board]; swaps=[]
                    for dest in order:
                        donors=[(x,y) for x in range(5)for y in range(7)if current[x][y]==kind and (x,y)not in target]
                        if not donors:break
                        src=donors[0]; current=swapped(current,dest,src);swaps.append([dest,src])
                        allruns=[run for q in [dest,src]for run in runs_at(current,q)if run]
                        if allruns:
                            horizontal=run_at(current,dest,(0,1))
                            return {'swaps':swaps,'horizontal_match':horizontal,'minimum_expected_score':value(horizontal) if horizontal else 150,'basis':'image-only triple assembly; stops at first detected endpoint match; actual score must be read from next capture'}
    return {'swaps':[],'shuffle':True,'basis':'No kind occurs >=3 times in this actual capture; use authored Shuffle then recapture'}

def events(candidate):
    out=[];t=50
    if candidate.get('shuffle'):
        out.extend([{'after_ms':t,'kind':'move','x':194,'y':334},{'after_ms':t+100,'kind':'click','x':194,'y':334,'hold_ms':250}]);t+=600
    for a,b in candidate['swaps']:
        for r,c in [a,b]:
            x,y=92+41*c,85+41*r
            out.extend([{'after_ms':t,'kind':'move','x':x,'y':y},{'after_ms':t+100,'kind':'click','x':x,'y':y,'hold_ms':250}]);t+=500
        t+=200
    out.extend([{'after_ms':t+50,'kind':'move','x':635,'y':385},{'after_ms':t+2000,'kind':'shot','x':0,'y':0}]);return out
