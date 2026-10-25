#!/usr/bin/env python3
"""FL-58: scripts/fl41_survivors.py with every reviewed written reason switched off (the automated pass credits a row only when kills, identical -O2 code and the proof rules explain every mutant).

  fl58_classify.py MERGED_LOG [--equiv FILE] --out FILE      (run from outputs/blackmoor-decomp)
"""
import sys
from pathlib import Path

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import fl41_survivors as S

S.WRITTEN.clear()
S.main()
