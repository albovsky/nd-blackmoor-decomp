#!/usr/bin/env python3
"""RT-23: immutable x86 dispatcher 0x427a50 / handler 0x420c17 versus the native raw-0x3f kernel.

The unmodified GAME.EXE image is mapped under Unicorn. For raw 0x3f rows the REAL dispatcher
0x427a50 runs: gate 0x423f57 (dependency tree built by the real loader 0x424aa8), the handler
0x420c17 with ECX = manager 0x6177e8, and every routine the native kernel models in-process:
0x4205c1 (response list build), 0x420737 (condition tree), 0x4209e8 (secondary table),
0x41fa11/0x41fd08/0x42028e (add/replace/remove), 0x41f986 (list reset), 0x41de29, 0x4e8d96
(held-item put-back), 0x50d550 (text compare) and the MFC CString routines the response pool uses
(0x51e627.. 0x51eac4, fixed allocator 0x50c575..). Each visit's ordered host effects and the state
the world view mirrors are compared with the native kernel (tests/action_family_3f_runtime_oracle_
driver.c, scripted host), after EVERY recorded effect (modelled state snapshot) and at the end of
every visit (full state: events, presence, response pool texts, sound-name table, object image).

COMPLETE HOOK INVENTORY (code hooks at function ENTRY; nothing else is replaced).
 R = replaced (the hook records the call, applies the scripted effect, pops the original's
 `ret N` and returns), O = observed (recorded, the original body then runs).
  R 0x4eb96e  release_engine_view(4)   R 0x4e7d04  release_engine_view(3)
  O 0x4edf96  engine_mode(v)  host part of 0x4e7728 (stores into the mapped engine object)
  O 0x4edfaf  engine_aux(v)   host part of 0x4e7786 (stores into the mapped engine object)
  R 0x4db993  cursor_hotspot(x,y) (the call made from inside 0x4edfaf, return address 0x4ee0ce, is part
              of engine_aux and is replaced without a record)
  R 0x4e9e84  inventory_add(item,flag)
  R 0x4ea06c  inventory_remove(item)
  R 0x4c948f  surface slot allocator (returns the scripted slot)
  R 0x4c2898  acquire_surface(name,w74,w76)            R 0x4c946b  release_surface(slot)
  R 0x41e3c0, 0x41e647 (x2), 0x4c51a5  layout_text_box: one 'layout' event at 0x41e3c0, the other
              three calls are required in that order and carry no state; the scripted effect writes
              the sound-name table 0x5b0a9a and [0x5b15da]
  R 0x420b9e  refresh_hotspot_surface  R 0x4dadff  poll_keys (scripted [0x58321d]/[0x58321e])
  R 0x4fb77a  sound load(descriptor)   R 0x4fb2e3  sound play(channel)
  R 0x4f6334  sound is_playing (scripted answer)  R 0x4fba69  sound unload(descriptor)
  O 0x42e493  scene_stack_pop (pure stores; its stack words are seeded by the scenario)
  R 0x4ee673  release_ui_hook(0)
  O 0x4e7757  engine_restore (stores into the mapped engine object, then 0x4e76ed/0x4d36ed)
  R 0x41db40  object release (recorded, no state)      R 0x51dc6c  CRT free (counted, no-op)
  base harness: 0x51dc43 malloc replaced by a bounded zero-filled arena (OS/CRT boundary).
 Windows imports (OS boundary, IAT slots patched to stubs): InterlockedIncrement,
 InterlockedDecrement, lstrlenA, EnterCriticalSection/LeaveCriticalSection/InitializeCriticalSection (no-ops, one thread); any other
 import raises. SEH: fs:[0] needs a TIB page (GDT FS).
 RAISING guards (reaching one fails the run): 0x52139c, 0x4c97b4, 0x44a2b7, 0x50ca3e, 0x44c479,
 0x44c4ab, 0x449a94, 0x449bff, 0x4497a0, 0x418e52, 0x41a216, 0x42639d, 0x41e1e4, 0x422970,
 0x4229b5, 0x4f6cdc, 0x4f6ef4, 0x50ce04, 0x425b8b, 0x425b40 (cel video, logging, fatal paths).
 Observers (never write): UC_HOOK_MEM_WRITE over the image classifies every store into a named
 region (anything else fails the run); UC_HOOK_MEM_READ over the object arena rejects reads past
 the object; unmapped access faults. Mutable inputs written by this harness are original global
 storage (world words, row slots, manager fields, CString pool pointers) exactly as the original
 would have left them. Debug flag 0x63a4cd is 0 (logging disabled, as in the original default).

Scripted host effects shared by BOTH sides (the stand-ins' contract, not original decisions): key
bytes, layout sound names/[0x5b15da], surface slots, is_playing answers, scene-stack words, the
chosen-response array [0x5839b1+4i] (set by the pointer path 0x4e78c2 in the original).

Dependency tails: the ':dep' corpus variants load the row's real tail through 0x424aa8 and let the
original gate 0x423f57 decide handler entry; a tail whose evaluator needs an OS service (rand/time
import) is counted in stats.dep_unsupported, never silently passed. Tier C is out of scope.

KNOWN NATIVE DEFECTS (tagged scenarios only; counted in stats.known, never as passes; a fixed native
makes them show up in stats.known_not_observed): D1 0x4209e8 evaluates each secondary-table entry
AFTER the earlier entries' effects (native evaluates all first); D2 0x4211ec clears 33 bytes per 41-byte
sound-name cell (native clears 41); D3 0x420e4c resets the list count BEFORE the surface/put-back
effects (native after). `--mutations` rebuilds the kernel with 15 single-rule breaks, one process each.

Run (from outputs/blackmoor-decomp/tests, Unicorn python, xcrun shim on PATH):
  python3 action_family_3f_runtime_original_oracle.py --mutations --result <receipt.json>
Sanitizers: CC=gcc A3F_SANITIZE=1 LD_PRELOAD=$(gcc -print-file-name=libasan.so) with RTLD_DEEPBIND stripped.
"""
from __future__ import annotations

import argparse
import bisect
import ctypes as C
import hashlib
import json
import os
import random
import shutil
import struct
import subprocess
import sys
import tempfile
import time
from collections import Counter
from pathlib import Path

import capstone
import pefile
from unicorn import UC_HOOK_BLOCK, UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
from unicorn import x86_const as X

import conditions_nested_original_oracle as deps
from cif_original_oracle import DEFAULT_EXE
import test_action_family_3f as n3f
import action_family_3f_original_oracle as c3f

ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
PRIVATE = ROOT / 'work/analysis/slices'
EXE_HASH = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'

# Original code windows (function spans of the 0x3f path), SHA-256 of the unmodified image bytes.
PINS_TABLE = (
 (0x41db40, 0x41de29,
  '7cc75ace8699f28c8bc1b56ac952114d181ab80dd4992372b034bddab8a48c4a'),
 (0x41de29, 0x41df05,
  'f563de65c8929cb81c04e5315fc10bba8bfbbde2df69c0d2ed6ffa0a2f8dadaf'),
 (0x41e3c0, 0x41e647,
  '96668493d1f4eda163a3da88b563ae49ba32c1e86b0f33da83c40544fdd961da'),
 (0x41e647, 0x41f5b1,
  '0edbc0e005ed0ac61fd4eb40e8f7b194425d232c63127cbfcdc4860e0759f4af'),
 (0x41f986, 0x41fa11,
  '4ecaa6058ea78bb879facfba9cbc086bf37ea8054a039fddaf12c87a6fcd96fd'),
 (0x41fa11, 0x41fd08,
  'f809abda9a9f9d10ce6ac69ad5244e04b5811b6e8a8c1167ca43a3d83deceba9'),
 (0x41fd08, 0x42028e,
  'e481afb28154f6f93827ab22edf3b57637b80a7ab6e5fa575bc1638940cb1cf7'),
 (0x42028e, 0x4205c1,
  '8850c4b8591907993537b12e75eefdab6fbaa4f650641a3d1019de4de8a58aa8'),
 (0x4205c1, 0x420737,
  'f9f9d1981494a2a4f8a4b7dc665a723f3a642728e0f601b8df2ce9fd1b7c1044'),
 (0x420737, 0x4209e8,
  'c7e6effcb4220a2b50265636f2c37f7c05d99e857e40b5995cfaca88f63cf77b'),
 (0x4209e8, 0x420b9e,
  'bec0cbec20f6d2a627290a5503cf8250ce3edb6aa0e6bb1901b2de836a0df7a7'),
 (0x420b9e, 0x420c17,
  '6a323858b8c714a58729ff1c74fe66f11f842730857d348ff765969bed8e5712'),
 (0x420c17, 0x422970,
  '9f905842083abb3876e521d326b10b7e7347cba2a016805feb814b200385a01f'),
 (0x4234c8, 0x4234dd,
  'fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87'),
 (0x4237f7, 0x423876,
  'f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084'),
 (0x423f57, 0x423fbb,
  '5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed'),
 (0x42406d, 0x424201,
  '9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07'),
 (0x424201, 0x424346,
  'b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394'),
 (0x424346, 0x424aa8,
  '5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01'),
 (0x424aa8, 0x425b8b,
  'e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8'),
 (0x427a50, 0x42acad,
  '1ceb29e4b0897a0f347693be385bd86e120cbb0090c0ee1fe3e8d8de02381fac'),
 (0x42e493, 0x42e560,
  'ad863a5b6157f199732eb975d2f9f9e99ebf6e539ae56df7868eedb397dd1b69'),
 (0x43dbd5, 0x43dbe3,
  '598507c387a08f61f186aa33bed364cdb4cddb3beb7b2f3638e7743017833ba3'),
 (0x4c2898, 0x4c2a8d,
  'a8cd1b424b3b67a98f9faafd1f7222f31ba5213bd840ff64beae0106ed998c43'),
 (0x4c2e5b, 0x4c2e97,
  'e94e55f6430c1ea8935fe83ec3982d90045f6ef510a1601fd28546f751e25b93'),
 (0x4c51a5, 0x4c5377,
  'dc7b9a9ed6c6241cef6a4b866d5beb55aa030f2a9263d521b3c28f917702eb0b'),
 (0x4c946b, 0x4c948f,
  'c885b7addfd0698e7365495d4d099c2d5a17d55f71aa7690a6c2c76f31140a49'),
 (0x4c948f, 0x4c94ec,
  '0b8219b7d88ac84ec24522564e2fd3a1b319f6e14431ec3a68c70fb75e894bc6'),
 (0x4d36ed, 0x4d3705,
  '9949b20e1d1c1364cc73cb7b0bc45e9da93e653d2d387c30bed3a017f13064fd'),
 (0x4dadff, 0x4dae66,
  '544471b7b218e2aed1e198ed97871fbaefed650f64473a2f472d9d5ac03f45a2'),
 (0x4db993, 0x4dbb13,
  '139830af414afb3c475a212431a0a47d478ec5334ec6c7d1c1a5b4de3a01e39a'),
 (0x4e76d5, 0x4e76ed,
  'c2600154031e55686220c64de538925d1cbbc2139a8213ebb247bdb2f43d44f8'),
 (0x4e76ed, 0x4e7700,
  'e3b792ee2e09a04bcc3505aae5545003d9e0362e54db12da064c90e74da9f1b4'),
 (0x4e7728, 0x4e7757,
  '691b2826eb2df5c2ec2cd06089d97c289c645c483dc5f1bfa1b8e7ce65203dd0'),
 (0x4e7757, 0x4e7786,
  'a2a7de12d05c8665b260e2a7bb99bfb87320cdbe17bd76fc42bfccede9395a52'),
 (0x4e7786, 0x4e779f,
  '037e4fc9f01e2cd100472faa3c17e0a1cb9a4e669e251b1441db60cf10a85bb9'),
 (0x4e7d04, 0x4e7d2e,
  'f7cc1012916b165c716ecb86ae7d8f47938e8ed4668e7077833a054a4ae2d405'),
 (0x4e8d96, 0x4e8dc8,
  '0a9074007cc3fee89ce7cc198feb0e4edc21c07abe5dd53b4953a7c304cb2f85'),
 (0x4e9e84, 0x4ea06c,
  '2474b155759c56581a8aa3345ba306834fe612ce2eaaa47db2052e61f046e932'),
 (0x4ea06c, 0x4ea1cb,
  'f6aa62744639b799a56390c9a86098b21c19b3708c1f1255023ce25c0ded2ba2'),
 (0x4eb96e, 0x4eb9c8,
  'fe96ae0e13e254c9da42f2d1457d19a597235dc0651c012e7f33b17782da77cf'),
 (0x4edf96, 0x4edfaf,
  '862b97f49db13ebd6be19e4ba74589f7095908a1ebf325a5d9ee7f7269ba9369'),
 (0x4edfaf, 0x4ee0d4,
  'dab73ecd68c6b5e5e98c4955a484e410f564728f4a882e9e41c8b6ad667c6ed5'),
 (0x4ee673, 0x4ee69e,
  'ae43cdb79497996bfc4d34f3cb51c416c9f0452731bfe2cc8c0dbff77dd9e6d6'),
 (0x4f6334, 0x4f646c,
  '48cdda17186b7ccc8d331394776ccdd0454d847fb5c751bc4f73cc1468916062'),
 (0x4fb2e3, 0x4fb397,
  'ed3fa0d31231e810539fda23128c0e4955d0a704ad0f126cb7101240fe04c9d3'),
 (0x4fb77a, 0x4fba69,
  '2ce29dc83367fe0fbde3a901b3fc7e1c9e98397a66754680f8fa74707c8ce556'),
 (0x4fba69, 0x4fba86,
  '1b43a3f31f3008e22293f89e0e702167dee2cd34edf390865c770777edc60e2d'),
 (0x50c511, 0x50c539,
  '8c70c68b613780077d0b8de5d46e99c11c89ff1ab70999379145b0d9101b47f7'),
 (0x50c575, 0x50c5ee,
  '913a992e8770e183127132a7904ab191fd101cc076663ffe7696925a0a19f132'),
 (0x50c604, 0x50c635,
  '55f10646df49a97aaddef44eca44e5927796bbae4fe4433ab49478d0abd11870'),
 (0x50d550, 0x50d651,
  'cafadc514ad4eb4dcd888e5f9f642abe6ae84185be75fa295358cc4dee747dc2'),
 (0x50f978, 0x50f997,
  '7f8b0849af9dd6f8eaa8c1e19d51a2bbb461b2c4c14fa3f213efa88cd3a7fc95'),
 (0x50fa90, 0x50fdc5,
  'ff83ddd63eca2a5bfc1616816aed96bc3731e22f4e6f539dd8052cf74e3e2f40'),
 (0x51a3d4, 0x51a3f4,
  '0cc8f87a625b97429e2bae375e9c262580b335cf7bc869e2d0f91cd5d7a92897'),
 (0x51dc43, 0x51dc6c,
  '8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2'),
 (0x51e56c, 0x51e57b,
  'ea96a6025ff6437a3365728c94cb1e635b2ac7c2426a38cb97de6adfbd056bee'),
 (0x51e59b, 0x51e5ad,
  'a200dfbaab6286ea8316adaf516632752238e5a509b809bbd6267ff78fdc5567'),
 (0x51e5cd, 0x51e5df,
  'ef5dcaa2114c58eda8e0676b41d28575a76118ef4c027c8779ac00772ba4e518'),
 (0x51e5ff, 0x51e611,
  '878363a215a2bc518eedbcff4638b583439ca0d4c86e15f01d653e30cd19be07'),
 (0x51e627, 0x51e6a9,
  '4fd2e953533efb860da40926a491ca4ef29039ec95b0491ea68a8e369c426d6f'),
 (0x51e6a9, 0x51e6f1,
  '3964ae0b57abc958f6cb0c0a01271290e36e34b58d172443b9bbb6cdbaae93e9'),
 (0x51e6f1, 0x51e722,
  'b073c443c24e7825f10e5cb84c914c3aeb5cf5cd0c9ab923c6d470c99a242984'),
 (0x51e722, 0x51e745,
  '1010d98be19a991870b554cdf0ea0380a4ea251c7b3342f53058d48514d2a9ff'),
 (0x51e745, 0x51e763,
  'd3349292ac482a61e01e7d3de96fc1004244f98117c3ac78c245cd896e11cf88'),
 (0x51e763, 0x51e791,
  'b3fc93097d4bf8e7730dc5fb934a0a3f7aac8a44f95d0c0fe2c50094f54c02d2'),
 (0x51ea75, 0x51eac4,
  '6ea15976c02949015ef4a2c4700039802f66f7110ab072a22d2a52d4b5717e9d'),
 (0x51eac4, 0x51eaec,
  '6de306f88d4356dbf89d11458ca912e933c13893d041ffc1c4a1d8bc88eea715'),
)

# CRT static initialisers (original x86) of the MFC CString fixed allocators (0x40-block pools of
# 0x50/0x90/0x110/0x210 bytes at 0x63c3f0/0x63c3c8/0x63c3a0/0x63c378), run after every hard reset.
STATIC_INIT = (0x51e56c, 0x51e59b, 0x51e5cd, 0x51e5ff)
MGR = 0x6177e8
ENGINE_OBJ = 0x582711
SLOT = 0x5bb5b3
ROW = 0x8d
PHASE = 0x7f
COMPLETE = 0x72
TAIL_BASE = 0x2000a000
OBJ_BASE = 0x22000000
OBJ_SIZE = 0x400000
TIB = 0x7ff00000
GDT = 0x7ff10000
STUBS = 0x7e000000
LOG_FLAG = 0x63a4cd
NIL_PTR_VAR = 0x5679b0
EVENTS_VA, EVENT_SLOTS = 0x585801, 3000
PRESENCE_VA, PRESENCE_SLOTS = 0x583bd5, 1803
NAMES_VA = 0x5b0a9a
NO_SOUND_VA = 0x544054


class OracleError(RuntimeError):
    pass


def sha(data):
    return hashlib.sha256(data).hexdigest()


# ret-pop (bytes the callee removes) of every replaced function, read from its disassembly.
POPS = {0x4eb96e: 0, 0x4e7d04: 0, 0x4db993: 8, 0x4e9e84: 8, 0x4ea06c: 4, 0x4c948f: 0, 0x4c2898: 20,
        0x4c946b: 4, 0x41e3c0: 4, 0x41e647: 20, 0x4c51a5: 20, 0x420b9e: 0, 0x4dadff: 0, 0x4fb77a: 4,
        0x4fb2e3: 4, 0x4f6334: 4, 0x4fba69: 4, 0x4ee673: 4, 0x41db40: 4, 0x51dc6c: 0}
OBSERVED = {0x4edf96: 'engine_mode', 0x4edfaf: 'engine_aux', 0x42e493: 'scene_stack_pop',
            0x4e7757: 'engine_restore'}
GUARDS = [0x52139c, 0x4c97b4, 0x44a2b7, 0x50ca3e, 0x44c479, 0x44c4ab, 0x449a94, 0x449bff, 0x4497a0,
          0x418e52, 0x41a216, 0x42639d, 0x41e1e4, 0x422970, 0x4229b5, 0x4f6cdc, 0x4f6ef4, 0x50ce04]

MGR_FIELDS = {'m.row': (0x75b, 2), 'm.type': (0x75a, 1), 'm.sub': (0x6b6, 4), 'm.count': (0xf21, 2),
              'm.slot0': (0xf73, 2), 'm.slot1': (0xf75, 2), 'm.cel': (0x6b2, 4),
              'm.dispname': (0x75d, 33)}
RESP_FIELDS = {'name': (0, 33), 'scene': (0x21, 2), 'w23': (0x23, 2), 'w25': (0x25, 2), 'w27': (0x27, 2),
               'd29': (0x29, 4), 'd2d': (0x2d, 4), 'd31': (0x31, 4), 'evi': (0x35, 2), 'evv': (0x37, 1),
               'w38': (0x38, 2)}
WORLD = {'w.held': (0x583a29, 2), 'w.mode': (0x583999, 4), 'w.f9': (0x5c39e9, 4), 'w.fd': (0x5c39ed, 4),
         'w.e204': (0x583204, 4), 'w.c106': (0x583106, 4), 'w.l788': (0x5b3788, 4), 'w.hx': (0x5b378c, 2),
         'w.hy': (0x5b378e, 2), 'w.capt': (0x5bb202, 4), 'w.fast': (0x58322a, 1), 'w.skip': (0x58321d, 1),
         'w.key': (0x58321e, 1), 'w.exit': (0x58322b, 1), 'w.sel': (0x570374, 2),
         'w.chosen': (0x5839b1, 120), 'w.start': (0x5bb1ca, 4), 'w.x57b': (0x5bb57b, 4),
         'w.x599': (0x5bb599, 2), 'w.x595': (0x5bb595, 2), 'w.x9ff': (0x5c39ff, 2),
         'w.x59b': (0x5bb59b, 4), 'w.x59f': (0x5bb59f, 4), 'w.x5a3': (0x5bb5a3, 4),
         'w.f1c4': (0x5bb1c4, 2), 'w.r1c8': (0x5831c8, 4), 'w.r1c6': (0x5831c6, 2),
         'w.u191d': (0x5d191d, 4), 'w.u15da': (0x5b15da, 4), 'w.u15c8': (0x5b15c8, 4),
         'w.u15d6': (0x5b15d6, 4), 'w.u8e': (0x5b0a8e, 2), 'w.u90': (0x5b0a90, 2), 'w.u7c': (0x5b0a7c, 2),
         'w.u74': (0x5b0a74, 2), 'w.u76': (0x5b0a76, 2), 'w.u1e': (0x5b0a1e, 4), 'w.u16': (0x5b0a16, 4),
         'w.uinames': (NAMES_VA, 60 * 41), 'w.events': (EVENTS_VA, EVENT_SLOTS * 4),
         'w.presence': (PRESENCE_VA, PRESENCE_SLOTS * 4)}

# Stores into manager/engine/global memory the original makes that the native model does not
# represent and no kernel decision reads (listed with the reason; the write observer still counts them).
UNCOMPARED = [
    (MGR + 0x690, MGR + 0x6b2, 'cel/video word state reset by 0x41de29 and phase 0'),
    (MGR + 0x6ba, MGR + 0x75a, 'cel timing words and rect copies 0x6da..0x75a written at phase 0 (geometry of the '
                              'cel arms; never read by the sound arms)'),
    (MGR + 0x6aa, MGR + 0x6ae, 'object pointer copy for the sound load'),
    (MGR + 0x784, MGR + 0x7d9, 'scratch flags of 0x420737 and cel words (0x78a/0x788/0x78c/0x784)'),
    (MGR + 0xf77, MGR + 0xfb5, 'cel/caption pointers cleared at finish'),
    (MGR + 0x20d5, MGR + 0x20dd, 'row object pointer copies'),
    (MGR + 0x1c, MGR + 0x6ae, 'cel record table cleared by 0x41de29'),
    (ENGINE_OBJ, ENGINE_OBJ + 0x1000, 'engine object fields written by 0x4edf96/0x4edfaf/0x4e76d5/0x4e7757'),
    (0x5bb57f, 0x5bb583, 'dword companion of the scene word, stored by 0x42e493'),
    (0x5c3a05, 0x5c3a1b, 'scene stack words popped by 0x42e493'),
    (0x5c3a47, 0x5c3a4b, 'gate 0x423f57 store'),
    (0x63786d, 0x63786d + 0x620, 'dependency evaluator state inside the engine object'),
    (0x63c370, 0x63c440, 'MFC CFixedAlloc state of the CString pool (0x50c575, 0x50c604)'),
    (0x5b1436, 0x5b1436 + 10 * 0x29, 'byte 0 of ten 0x29-byte cells (compared as w.u1436)'),
]


def u32(uc, a):
    return struct.unpack('<I', bytes(uc.mem_read(a, 4)))[0]


def cstr(data):
    return bytes(data).split(b'\0')[0]


class Script(C.Structure):
    _fields_ = [('playing_c', C.c_int32 * 64), ('playing_d', C.c_int32 * 64), ('n_c', C.c_int32),
                ('n_d', C.c_int32), ('key_skip', C.c_uint8 * 64), ('key_other', C.c_uint8 * 64),
                ('n_keys', C.c_int32), ('names', (C.c_uint8 * 41) * 30), ('hotspot', C.c_int32),
                ('slots', C.c_int16 * 8), ('n_slots', C.c_int32), ('stack_marker', C.c_int16),
                ('stack_scene', C.c_int16), ('stack_w09', C.c_int16), ('stack_w0b', C.c_int16),
                ('stack_w0d', C.c_int16), ('stack_pad', C.c_int16), ('stack_d0f', C.c_int32),
                ('stack_d13', C.c_int32), ('stack_d17', C.c_int32), ('fail_pop', C.c_int32)]


def make_script(d):
    s = Script()
    for key in ('playing_c', 'playing_d', 'key_skip', 'key_other', 'slots'):
        vals = d.get(key, [])
        for i, v in enumerate(vals):
            getattr(s, key)[i] = v
    s.n_c, s.n_d, s.n_keys, s.n_slots = (len(d.get('playing_c', [])), len(d.get('playing_d', [])),
                                         len(d.get('key_skip', [])), len(d.get('slots', [])))
    for i, name in enumerate(d.get('names', [])):
        raw = (name + b'\0').ljust(41, b'\xbb')[:41]
        for k, b in enumerate(raw):
            s.names[i][k] = b
    s.hotspot = d.get('hotspot', 0)
    st = d.get('stack', (0x1234, 321, 2, 3, 0, 0x11111111, 0x22222222, 0x33333333))
    (s.stack_marker, s.stack_scene, s.stack_w09, s.stack_w0b, s.stack_w0d, s.stack_d0f, s.stack_d13,
     s.stack_d17) = st
    s.fail_pop = d.get('fail_pop', 0)
    return s


# ---------------------------------------------------------------------------------------------
# native side
# ---------------------------------------------------------------------------------------------
def build_driver(src_dir, out):
    cc = os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')
    cmd = [cc, '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g', '-fPIC', '-shared',
           f'-I{src_dir}', str(PROJECT / 'tests/action_family_3f_runtime_oracle_driver.c'),
           str(Path(src_dir) / 'action_family_3f_runtime.c'), str(Path(src_dir) / 'action_family_3f.c'),
           '-o', str(out)]
    if os.environ.get('A3F_SANITIZE'):  # ASan/UBSan build of the native kernel (preload the runtime into python)
        cmd[1:1] = ['-fsanitize=address,undefined', '-fno-sanitize-recover=undefined', '-fno-omit-frame-pointer']
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise OracleError('driver build failed: ' + done.stderr[-800:])
    return out


class Native:
    lib = None
    layout = None

    @classmethod
    def open(cls, path):
        lib = C.CDLL(str(path))
        p = C.c_void_p
        lib.a3f_new.restype = p
        lib.a3f_new.argtypes = [C.c_void_p, C.c_size_t, C.c_uint32, C.POINTER(Script)]
        lib.a3f_free.argtypes = [p]
        lib.a3f_visit.argtypes = [p, C.c_int32, C.c_uint32]
        lib.a3f_visit.restype = C.c_int
        lib.a3f_why.argtypes = [p]
        lib.a3f_why.restype = C.c_char_p
        lib.a3f_log_count.argtypes = [p]
        lib.a3f_log_text.argtypes = [p, C.c_int]
        lib.a3f_log_text.restype = C.c_char_p
        lib.a3f_log_snapshot.argtypes = [p, C.c_int, C.c_void_p]
        lib.a3f_clear_log.argtypes = [p]
        lib.a3f_result.argtypes = [p, C.c_void_p]
        lib.a3f_arena.argtypes = [p, C.c_void_p]
        lib.a3f_store.argtypes = [p, C.c_void_p, C.c_int]
        lib.a3f_load.argtypes = [p, C.c_void_p]
        lib.a3f_snapshot_size.argtypes = [p, C.c_int]
        lib.a3f_snapshot_size.restype = C.c_size_t
        lib.a3f_set_chosen.argtypes = [p, C.c_int, C.c_int32]
        lib.a3f_set_event.argtypes = [p, C.c_int, C.c_int32]
        lib.a3f_set_presence.argtypes = [p, C.c_int, C.c_int32]
        lib.a3f_layout.argtypes = [C.c_char_p, C.c_size_t]
        lib.a3f_layout.restype = C.c_size_t
        lib.a3f_script_size.restype = C.c_size_t
        if lib.a3f_script_size() != C.sizeof(Script):
            raise OracleError('script struct layout mismatch')
        buf = C.create_string_buffer(1 << 16)
        n = lib.a3f_layout(buf, len(buf))
        spec = [(a, int(b), int(c)) for a, b, c in (ln.split() for ln in buf.raw[:n].decode().splitlines())]
        return lib, spec

    def __init__(self, lib, spec, image, handle_base, script):
        self.lib, self.spec = lib, spec
        self.arena_bytes = len(image)
        buf = (C.c_uint8 * len(image)).from_buffer_copy(image)
        self.script = make_script(script)
        self.h = lib.a3f_new(buf, len(image), handle_base, C.byref(self.script))
        self.light = lib.a3f_snapshot_size(self.h, 0)
        self.full = lib.a3f_snapshot_size(self.h, 1)

    def close(self):
        self.lib.a3f_free(self.h)

    def store(self, full=True):
        out = (C.c_uint8 * (self.full if full else self.light))()
        self.lib.a3f_store(self.h, out, 1 if full else 0)
        return bytes(out)

    def load(self, blob):
        buf = (C.c_uint8 * len(blob)).from_buffer_copy(blob)
        self.lib.a3f_load(self.h, buf)

    def visit(self, row, phase):
        self.lib.a3f_clear_log(self.h)
        status = self.lib.a3f_visit(self.h, row, phase)
        events = []
        for i in range(self.lib.a3f_log_count(self.h)):
            snap = (C.c_uint8 * self.light)()
            self.lib.a3f_log_snapshot(self.h, i, snap)
            events.append((self.lib.a3f_log_text(self.h, i).decode('latin1'), bytes(snap)))
        res = (C.c_uint32 * 8)()
        self.lib.a3f_result(self.h, res)
        return status, (self.lib.a3f_why(self.h) or b'').decode(), events, list(res)

    def arena(self):
        out = (C.c_uint8 * self.arena_bytes)()
        self.lib.a3f_arena(self.h, out)
        return bytes(out)


# ---------------------------------------------------------------------------------------------
# original side
# ---------------------------------------------------------------------------------------------
class X86(deps.OriginalMachine):
    def __init__(self, spec):
        super().__init__(DEFAULT_EXE)
        uc = self.machine
        self.spec = spec
        self.pristine = bytes(self.pe.image)
        for a, z, digest in PINS_TABLE:
            if sha(self.pristine[a - self.pe.image_base:z - self.pe.image_base]) != digest:
                raise OracleError('code window pin mismatch %#x..%#x' % (a, z))
        uc.mem_map(OBJ_BASE, OBJ_SIZE)
        uc.mem_map(TIB, 0x1000)
        uc.mem_map(GDT, 0x1000)
        uc.mem_map(STUBS, 0x1000)
        uc.mem_write(STUBS, b'\xc3' * 0x1000)
        def seg(base, limit, access, flags):
            return struct.pack('<HHBBBB', limit & 0xffff, base & 0xffff, (base >> 16) & 0xff, access,
                               ((limit >> 16) & 0xf) | (flags << 4), (base >> 24) & 0xff)
        # flat ring-0 code/data segments plus an FS segment whose base is the TIB page (SEH chain)
        uc.mem_write(GDT, bytes(8) + seg(0, 0xfffff, 0x9b, 0xc) + seg(0, 0xfffff, 0x93, 0xc)
                     + seg(TIB, 0xfff, 0x93, 0x4))
        uc.reg_write(X.UC_X86_REG_GDTR, (0, GDT, 0xfff, 0))
        uc.reg_write(X.UC_X86_REG_CS, 0x08)
        for reg in (X.UC_X86_REG_SS, X.UC_X86_REG_DS, X.UC_X86_REG_ES, X.UC_X86_REG_GS):
            uc.reg_write(reg, 0x10)
        uc.reg_write(X.UC_X86_REG_FS, 0x18)
        self.hooks = {}
        self.events = []
        self.layout_calls = []
        self.entered = []
        self.frees = Counter()
        self.writes = Counter()
        self.unclassified = Counter()
        self.script = {}
        self.counters = Counter()
        self.counters_total = Counter()
        self.arena_len = 0
        self.imports = {}
        self._install_imports()
        self._install_hooks()
        regions = sorted((a, z, why) for a, z, why in UNCOMPARED)
        self.regions = regions
        self.named = []
        for name, (off, size) in MGR_FIELDS.items():
            self.named.append((MGR + off, MGR + off + size, name))
        self.named.append((MGR + 0x7d9, MGR + 0x7d9 + 30 * 0x3a, 'response records'))
        self.named.append((MGR + 0xea5, MGR + 0xf21, 'CString pool pointers'))
        for name, (addr, size) in WORLD.items():
            self.named.append((addr, addr + size, name))
        self.blocks = set()
        self.reads = {}
        self.read_counts = Counter()
        uc.hook_add(UC_HOOK_BLOCK, lambda u, a, sz, d: self.blocks.add((a, sz)), begin=0x401000, end=0x52a000)
        uc.hook_add(UC_HOOK_MEM_READ, self._on_data_read, begin=0x537000, end=0x646000)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._on_write, begin=self.pe.image_base,
                    end=self.pe.image_base + self.pe.size_of_image)
        uc.hook_add(UC_HOOK_MEM_WRITE, self._on_obj_write, begin=OBJ_BASE, end=OBJ_BASE + OBJ_SIZE - 1)
        uc.hook_add(UC_HOOK_MEM_READ, self._on_obj_read, begin=OBJ_BASE, end=OBJ_BASE + OBJ_SIZE - 1)

    # -- imports (OS boundary) -------------------------------------------------------------
    def _install_imports(self):
        pe = pefile.PE(str(DEFAULT_EXE))
        idx = 0
        for entry in pe.DIRECTORY_ENTRY_IMPORT:
            for imp in entry.imports:
                stub = STUBS + 16 * idx
                self.imports[stub] = (imp.name.decode() if imp.name else 'ord%d' % imp.ordinal, imp.address)
                idx += 1
        for stub in self.imports:
            self.machine.hook_add(UC_HOOK_CODE, self._guard(self._on_import), begin=stub, end=stub)
        self._patch_iat()

    def _patch_iat(self):
        for stub, (_name, iat) in self.imports.items():
            self.machine.mem_write(iat, struct.pack('<I', stub))

    def _on_import(self, uc, address, size, user):
        name, _iat = self.imports[address]
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        arg0 = u32(uc, sp + 4)
        if name == 'InterlockedIncrement':
            v = (struct.unpack('<i', bytes(uc.mem_read(arg0, 4)))[0] + 1) & 0xffffffff
            uc.mem_write(arg0, struct.pack('<I', v))
            self._ret(uc, 4, v)
        elif name == 'InterlockedDecrement':
            v = (struct.unpack('<i', bytes(uc.mem_read(arg0, 4)))[0] - 1) & 0xffffffff
            uc.mem_write(arg0, struct.pack('<I', v))
            self._ret(uc, 4, v)
        elif name in ('EnterCriticalSection', 'LeaveCriticalSection', 'InitializeCriticalSection'):
            self._ret(uc, 4, 0)  # single-threaded oracle: the MFC allocator lock is uncontended
        elif name == 'lstrlenA':
            n = 0
            while uc.mem_read(arg0 + n, 1)[0] != 0:
                n += 1
            self._ret(uc, 4, n)
        else:
            raise OracleError('unexpected Windows import %s called from %#x' % (name, u32(uc, sp)))
        self.counters['os:' + name] += 1

    # -- hook plumbing ----------------------------------------------------------------------
    def _guard(self, fn):
        def run(uc, address, size, user):
            try:
                fn(uc, address, size, user)
            except Exception as error:  # reported by deps.call after emu_stop
                self._hook_error = 'hook %#x: %r' % (address, error)
                uc.emu_stop()
        return run

    def _ret(self, uc, pop, eax=None):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        ret = u32(uc, sp)
        uc.reg_write(X.UC_X86_REG_ESP, sp + 4 + pop)
        if eax is not None:
            uc.reg_write(X.UC_X86_REG_EAX, eax & 0xffffffff)
        uc.reg_write(X.UC_X86_REG_EIP, ret)

    def _on_code(self, uc, address, size, user):
        # the base class replaces malloc here; its diagnostic printer / bad-tree stop may never run
        try:
            if address != deps.ORIGINAL_ALLOCATOR:
                raise OracleError('unexpected diagnostic/fatal path %#x' % address)
            super()._on_code(uc, address, size, user)
        except Exception as error:
            self._hook_error = 'hook %#x: %r' % (address, error)
            uc.emu_stop()

    def _install_hooks(self):
        uc = self.machine
        table = {}
        for a in POPS:
            table[a] = self._replaced
        for a in OBSERVED:
            table[a] = self._observed
        for a in GUARDS:
            table[a] = self._raise
        table[0x420c17] = self._entry
        for a, fn in table.items():
            uc.hook_add(UC_HOOK_CODE, self._guard(fn), begin=a, end=a)

    def _raise(self, uc, address, size, user):
        raise OracleError('guarded original routine %#x reached' % address)

    def _entry(self, uc, address, size, user):
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        row = struct.unpack('<h', bytes(uc.mem_read(sp + 4, 2)))[0]
        if uc.reg_read(X.UC_X86_REG_ECX) != MGR:
            raise OracleError('handler entered with ECX != 0x6177e8')
        self.entered.append(row)

    # -- state access ---------------------------------------------------------------------
    def rd(self, a, n):
        return bytes(self.machine.mem_read(a, n))

    def s16(self, a):
        return struct.unpack('<h', self.rd(a, 2))[0]

    def s32(self, a):
        return struct.unpack('<i', self.rd(a, 4))[0]

    def wr(self, a, b):
        self.machine.mem_write(a, bytes(b))

    def snapshot(self, full):
        out = bytearray()
        nil = u32(self.machine, NIL_PTR_VAR)
        for name, size, is_full in self.spec:
            if is_full and not full:
                continue
            out += self.field(name, size, nil)
        return bytes(out)

    def field(self, name, size, nil):
        if name in MGR_FIELDS:
            off, sz = MGR_FIELDS[name]
            assert sz == size
            return self.rd(MGR + off, sz)
        if name in WORLD:
            addr, sz = WORLD[name]
            assert sz == size, name
            return self.rd(addr, sz)
        if name == 'w.u1436':
            return bytes(self.rd(0x5b1436 + 0x29 * k, 1)[0] for k in range(10))
        i, sub = int(name[1:3]), name[4:]
        if name[0] == 'r' and sub == 'text':
            p = u32(self.machine, MGR + 0xea5 + 4 * i)
            return bytes(size) if p == nil else self.rd(p, size)
        if name[0] == 'r':
            off, sz = RESP_FIELDS[sub]
            assert sz == size, name
            return self.rd(MGR + 0x7d9 + 0x3a * i + off, sz)
        raise OracleError('no x86 mapping for field ' + name)

    def phase(self, row):
        return struct.unpack('<I', self.rd(SLOT + row * ROW + PHASE, 4))[0]

    def completed(self, row):
        return self.rd(SLOT + row * ROW + COMPLETE, 1)[0]

    # -- write classification -----------------------------------------------------------------
    def _on_write(self, uc, access, address, size, value, user):
        if not self.active:
            return
        end = address + size
        for a, z, _why in self.named:
            if a <= address and end <= z:
                self.writes['named'] += 1
                return
        for a, z, _why in self.regions:
            if a <= address < z:
                self.writes['uncompared'] += 1
                return
        if SLOT <= address < SLOT + 8 * ROW:
            row, off = divmod(address - SLOT, ROW)
            if off in (0x36, 0x37, 0x38, 0x39, COMPLETE, 0x73, 0x74, 0x75, 0x76, PHASE, 0x80, 0x81, 0x82):
                self.writes['row'] += 1
                return
        self.unclassified[(address, size)] += 1

    def _on_data_read(self, uc, access, address, size, value, user):
        if self.active:
            key = (address, size)
            self.read_counts[key] += 1
            if key not in self.reads:
                self.reads[key] = uc.reg_read(X.UC_X86_REG_EIP)

    def _on_obj_write(self, uc, access, address, size, value, user):
        if not self.active:
            return
        off = address - OBJ_BASE
        if self.arena_lo <= off and off + size <= self.arena_hi:
            self.writes['object'] += 1
            return
        self.unclassified[(address, size)] += 1

    def _on_obj_read(self, uc, access, address, size, value, user):
        if self.active and not (0 <= address - OBJ_BASE and address - OBJ_BASE + size <= self.arena_len):
            raise OracleError('original read past the object arena at %#x' % address)

    # -- replaced / observed externals ----------------------------------------------------------
    def log(self, text, snap=True):
        self.events.append((text, self.snapshot(False) if snap else None))

    def _observed(self, uc, address, size, user):
        self.counters_total['O %#x' % address] += 1
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        name = OBSERVED[address]
        if name in ('engine_mode', 'engine_aux'):
            self.log('%s %d' % (name, struct.unpack('<i', bytes(uc.mem_read(sp + 4, 4)))[0]))
        else:
            self.log(name)

    def _replaced(self, uc, address, size, user):
        self.counters_total['R %#x' % address] += 1
        sp = uc.reg_read(X.UC_X86_REG_ESP)
        a = [struct.unpack('<I', bytes(uc.mem_read(sp + 4 + 4 * i, 4)))[0] for i in range(5)]
        s16 = lambda v: struct.unpack('<h', struct.pack('<H', v & 0xffff))[0]
        s32 = lambda v: struct.unpack('<i', struct.pack('<I', v))[0]
        sc = self.script
        eax = 0
        if address == 0x4eb96e:
            self.log('view 4')
        elif address == 0x4e7d04:
            self.log('view 3')
        elif address == 0x4db993:
            if u32(uc, sp) == 0x4ee0ce:  # reached from inside 0x4edfaf (engine_aux host routine)
                self.counters['aux_cursor'] += 1
            else:
                self.log('cursor %d %d' % (s32(a[0]), s32(a[1])))
        elif address == 0x4e9e84:
            self.log('inv_add %d %d' % (s16(a[0]), s32(a[1])))
        elif address == 0x4ea06c:
            self.log('inv_remove %d' % s16(a[0]))
        elif address == 0x4c948f:
            i = self.counters['slot_alloc']
            self.counters['slot_alloc'] += 1
            slots = sc.get('slots', [])
            eax = slots[i] if i < len(slots) else 0
        elif address == 0x4c2898:
            slot = (a[0] - 0x5d02cb) // 4
            name = cstr(self.rd(a[4], 64)).decode()
            self.log('surface %s %d %d -> %d' % (name, s16(a[1]), s16(a[2]), slot))
        elif address == 0x4c946b:
            self.log('surf_release %d' % s16(a[0]))
        elif address == 0x41e3c0:
            self.layout_calls = [0x41e3c0]
            self.log('layout row=%d count=%d slots=%d,%d' % (s16(a[0]), self.s16(MGR + 0xf21),
                                                            self.s16(MGR + 0xf73), self.s16(MGR + 0xf75)))
            for i, nm in enumerate(sc.get('names', [])[:30]):
                self.wr(NAMES_VA + 41 * i, (nm + b'\0').ljust(41, b'\xbb')[:41])
            for i in range(len(sc.get('names', [])), 30):
                self.wr(NAMES_VA + 41 * i, bytes(41))
            self.wr(0x5b15da, struct.pack('<i', sc.get('hotspot', 0)))
        elif address in (0x41e647, 0x4c51a5):
            self.layout_calls.append(address)
            if address == 0x4c51a5 and self.layout_calls != [0x41e3c0, 0x41e647, 0x41e647, 0x4c51a5]:
                raise OracleError('layout call order %s' % [hex(x) for x in self.layout_calls])
        elif address == 0x420b9e:
            self.log('refresh %d' % self.s16(MGR + 0xf73))
        elif address == 0x4dadff:
            self.log('keys')
            i = self.counters['key_poll']
            self.counters['key_poll'] += 1
            ks, ko = sc.get('key_skip', []), sc.get('key_other', [])
            self.wr(0x58321d, bytes([ks[i] if i < len(ks) else 0]))
            self.wr(0x58321e, bytes([ko[i] if i < len(ko) else 0]))
        elif address == 0x4fb77a:
            d = self.rd(a[0], 0x31)
            name = cstr(d[:33]).decode('latin1')
            self.log('snd_load %s ch=%u ctl=%u p1=%d p2=%d mode=%u' % (
                name, struct.unpack_from('<H', d, 0x21)[0], struct.unpack_from('<I', d, 0x29)[0],
                struct.unpack_from('<h', d, 0x2d)[0], struct.unpack_from('<h', d, 0x2f)[0], d[0x25]))
        elif address == 0x4fb2e3:
            self.log('snd_play %u' % (a[0] & 0xffff))
        elif address == 0x4f6334:
            key = 'c' if (a[0] & 0xffff) == 0x0c else 'd'
            i = self.counters['playing_' + key]
            self.counters['playing_' + key] += 1
            seq = sc.get('playing_' + key, [])
            eax = seq[i] if i < len(seq) else 0
            self.log('snd_playing %u -> %d' % (a[0] & 0xffff, eax))
        elif address == 0x4fba69:
            self.log('snd_unload %u' % struct.unpack('<H', self.rd(a[0] + 0x21, 2))[0])
        elif address == 0x4ee673:
            self.log('ui_hook %d' % s32(a[0]))
        elif address == 0x41db40:
            self.log('release row=%d' % s16(a[0]), snap=False)
        elif address == 0x51dc6c:
            self.frees['free'] += 1
        else:
            raise OracleError('replaced hook without behaviour %#x' % address)
        self._ret(uc, POPS[address], eax)

    # -- scenario plumbing ----------------------------------------------------------------------
    active = False
    arena_lo = arena_hi = 0

    def hard_reset(self):
        uc = self.machine
        uc.mem_write(self.pe.image_base, self.pristine)
        self._patch_iat()
        uc.mem_write(0x20000000, bytes(0x200000))
        uc.mem_write(OBJ_BASE, bytes(OBJ_SIZE))
        uc.mem_write(TIB, bytes(0x1000))
        self.arena_cursor = deps.ARENA_START
        self.frees.clear()
        for ctor in STATIC_INIT:  # CRT startup: the four MFC CFixedAlloc pools of the CString heap
            self.call(ctor, [], 0)
        nil = u32(uc, NIL_PTR_VAR)
        for i in range(31):
            self.wr(MGR + 0xea5 + 4 * i, struct.pack('<I', nil))
        self.wr(MGR + 0x75b, struct.pack('<h', -1))
        self.wr(MGR + 0xf73, struct.pack('<hh', -1, -1))
        self.wr(0x570374, struct.pack('<h', 0x1f))
        self.wr(0x583a29, struct.pack('<h', -1))
        if self.rd(LOG_FLAG, 2) != b'\0\0':
            raise OracleError('original debug flag nonzero')

    def install_object(self, image):
        self.arena_len = len(image)
        self.wr(OBJ_BASE, image)
        self.arena_lo, self.arena_hi = 0x747, 0x747 + 0x2d

    def install_rows(self, row, tail, handle):
        """Rows 0..row-1 are completed dummies; `row` is the raw 0x3f row (type 0x3f, loader tree)."""
        self.wr(SLOT, bytes(8 * ROW))
        for i in range(row):
            self.wr(SLOT + i * ROW + COMPLETE, b'\1')
        base = SLOT + row * ROW
        self.wr(base + 0x30, bytes([0x3f, 2]) + struct.pack('<I', handle))
        storage = TAIL_BASE + row * 0x80
        self.wr(storage, tail or bytes(16))
        _, ok = self.call(0x424aa8, [base, 124, 124 + len(tail), storage], deps.ENGINE_THIS)
        if not ok:
            raise OracleError('original dependency construction failed')
        self.wr(base + COMPLETE, b'\0')
        self.wr(base + PHASE, struct.pack('<I', 0))
        self.wr(0x5c39e3, struct.pack('<h', row + 1))

    def dispatch(self):
        self.events = []
        self.entered = []
        self.layout_calls = []
        self.counters['visit'] += 1
        self.counters_total.update(['dispatch'])
        self.writes.clear()
        self.unclassified.clear()
        self.wr(0x5c3a47, bytes(4))
        self.active = True
        try:
            _, ok = self.call(0x427a50, [], 0)
        finally:
            self.active = False
        if not ok:
            raise OracleError('original dispatcher did not return')
        if self.unclassified:
            items = ', '.join('%#x/%d' % k for k in sorted(self.unclassified)[:24])
            raise OracleError('unclassified original stores: ' + items)
        if self.layout_calls and self.layout_calls != [0x41e3c0, 0x41e647, 0x41e647, 0x4c51a5]:
            raise OracleError('incomplete layout call sequence')

    def call(self, address, args, ecx):
        # deps.call's budget (2M instructions) is enough for one visit but not for a pool-heavy one.
        from unicorn import UcError
        uc = self.machine
        self._hook_error = None
        words = [deps.RETURN_SENTINEL, *[v & 0xFFFFFFFF for v in args]]
        uc.mem_write(deps.STACK_TOP, struct.pack('<' + 'I' * len(words), *words))
        uc.reg_write(X.UC_X86_REG_ESP, deps.STACK_TOP)
        uc.reg_write(X.UC_X86_REG_ECX, ecx)
        uc.reg_write(X.UC_X86_REG_EFLAGS, 0x202)
        try:
            uc.emu_start(address, deps.RETURN_SENTINEL, timeout=60_000_000, count=40_000_000)
        except UcError as error:
            eip = uc.reg_read(X.UC_X86_REG_EIP)
            if self._hook_error:
                raise OracleError(self._hook_error) from error
            raise OracleError('x86 call %#x failed at %#x: %s' % (address, eip, error)) from error
        if self._hook_error:
            raise OracleError(self._hook_error)
        if uc.reg_read(X.UC_X86_REG_EIP) != deps.RETURN_SENTINEL:
            raise OracleError('x86 call %#x stopped at %#x' % (address, uc.reg_read(X.UC_X86_REG_EIP)))
        return uc.reg_read(X.UC_X86_REG_EAX), True


# ---------------------------------------------------------------------------------------------
# scenarios
# ---------------------------------------------------------------------------------------------
def seed_conditions(rng, image, handle_base, events, presence, hit):
    """Set event/presence entries so that each condition record hits with probability `hit`."""
    def tables():
        pc, pt = struct.unpack_from('<hI', image, 0x793)[0], struct.unpack_from('<I', image, 0x795)[0]
        sc, st = struct.unpack_from('<h', image, 0x79f)[0], struct.unpack_from('<I', image, 0x7a1)[0]
        for i in range(pc):
            e = pt - handle_base + i * 0x1d1
            yield struct.unpack_from('<h', image, e)[0], struct.unpack_from('<I', image, e + 2)[0]
        for i in range(sc):
            e = st - handle_base + i * 10
            yield struct.unpack_from('<h', image, e)[0], struct.unpack_from('<I', image, e + 2)[0]
    for count, handle in tables():
        for k in range(max(0, count)):
            o = handle - handle_base + 5 * k
            kind, index, value = image[o], struct.unpack_from('<h', image, o + 1)[0], image[o + 3]
            target = events if kind == 1 else presence if kind == 2 else None
            limit = EVENT_SLOTS if kind == 1 else PRESENCE_SLOTS
            if target is None or not 0 <= index < limit:
                continue
            target[index] = value if rng.random() < hit else (value + 1 + rng.randrange(3)) & 0xff


def body_bytes(caption=b'KEY', name=b'NSND', hooks=(0x14, 0x14), opt46=0, w47=9999, w49=0, w21=100,
               primary=(), secondary=(), tail=b''):
    """Typed body of raw 0x3f (layout of tests/test_action_family_3f.py fixture())."""
    b = bytearray(77)
    b[:len(name)] = name
    b[35:35 + len(caption)] = caption
    struct.pack_into('<H', b, 33, w21)
    struct.pack_into('<BBBHHh', b, 68, hooks[0], hooks[1], opt46, w47, w49, len(primary))
    for p in primary:
        conds = p.get('conds', [])
        b += bytes((len(conds), 0xa7))
        for kind, index, value, link in conds:
            b += struct.pack('<BhBB', kind, index, value, link)
        b += p.get('key', b'KEY').ljust(33, b'\0') + p.get('sound', b'CHOICE').ljust(33, b'\0')
        b += struct.pack('<H', p.get('scene', 9999) & 0xffff)
    b += bytes((len(secondary), 0xb8))
    for s in secondary:
        conds = s.get('conds', [])
        b += bytes((len(conds), 0xc9))
        for kind, index, value, link in conds:
            b += struct.pack('<BhBB', kind, index, value, link)
        b += struct.pack('<BhB', s['kind'], s['id'], s.get('value', 1))
    return bytes(b) + tail


class Constructor:
    """Native A-3F.1 constructor (original-verified byte for byte by action_family_3f_original_oracle)."""
    def __init__(self, lib):
        self.lib = lib
        for fn, args in (('action_family_3f_construct', [C.c_void_p, C.c_size_t, C.POINTER(n3f.Text),
                                                         C.c_size_t, C.c_uint32, C.c_uint32, C.c_void_p,
                                                         C.c_size_t, C.POINTER(n3f.Constructed)]),):
            getattr(lib, fn).argtypes = args
            getattr(lib, fn).restype = C.c_int

    def build(self, body, texts, handle, fill=0xcd):
        src = n3f.storage(body)
        texts = [t.encode() if isinstance(t, str) else t for t in texts]
        rows, keep = n3f.texts(texts)
        out = n3f.Constructed()
        if self.lib.action_family_3f_construct(src, len(src), rows, len(rows), 50, handle, None, 0,
                                               C.byref(out)) != 0:
            raise OracleError('native constructor refused the fixture')
        arena = n3f.storage(bytes([fill]) * out.arena_bytes)
        if self.lib.action_family_3f_construct(src, len(src), rows, len(rows), 50, handle, arena,
                                               out.arena_bytes, C.byref(out)) != 0:
            raise OracleError('native constructor failed')
        return bytes(arena)


def default_world(rng, **kw):
    w = dict(mode=3, f9=0, fd=0, e204=0, c106=1, l788=0, hx=11, hy=-7, capt=0, fast=0, skip=0, key=0,
             exit=0, sel=0x1f, start=0, held=-1, u74=5, u76=40, u1e=9, u16=3)
    w.update(kw)
    return w


WORLD_KEYS = {'mode': 'w.mode', 'f9': 'w.f9', 'fd': 'w.fd', 'e204': 'w.e204', 'c106': 'w.c106',
              'l788': 'w.l788', 'hx': 'w.hx', 'hy': 'w.hy', 'capt': 'w.capt', 'fast': 'w.fast',
              'skip': 'w.skip', 'key': 'w.key', 'exit': 'w.exit', 'sel': 'w.sel', 'start': 'w.start',
              'held': 'w.held', 'u74': 'w.u74', 'u76': 'w.u76', 'u1e': 'w.u1e', 'u16': 'w.u16',
              'x57b': 'w.x57b', 'u15da': 'w.u15da', 'u8e': 'w.u8e', 'u90': 'w.u90', 'u7c': 'w.u7c',
              'u191d': 'w.u191d', 'u15c8': 'w.u15c8', 'u15d6': 'w.u15d6', 'f1c4': 'w.f1c4'}


def apply_world(x, sc, rng):
    for k, v in sc['world'].items():
        addr, size = WORLD[WORLD_KEYS[k]]
        x.wr(addr, bytes([v & 0xff]) if size == 1 else struct.pack('<h' if size == 2 else '<i', v))
    for idx, v in sc.get('events', {}).items():
        x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
    for idx, v in sc.get('presence', {}).items():
        x.wr(PRESENCE_VA + 4 * idx, struct.pack('<i', v))
    st = sc['script'].get('stack', (0x1234, 321, 2, 3, 0, 0x11111111, 0x22222222, 0x33333333))
    x.wr(0x5c3a05, struct.pack('<hhhhh', st[0], st[1], st[2], st[3], 0)[:8])
    x.wr(0x5c3a0d, struct.pack('<h', st[4]))
    x.wr(0x5c3a0f, struct.pack('<iii', st[5], st[6], st[7]))
    if sc.get('poison'):
        for k in range(30):
            x.wr(0x5839b1 + 4 * k, struct.pack('<i', 0x7a7a0000 + k))
        for a in (0x5b15c8, 0x5b15d6, 0x5d191d, 0x5bb1c4, 0x5bb57b, 0x5bb59b):
            x.wr(a, struct.pack('<I', 0x5a5a0000 | (a & 0xffff)))
    if sc.get('poison_names'):
        x.wr(NAMES_VA, bytes([0xa5]) * (60 * 41))


class Mismatch(Exception):
    pass


def diff_fields(spec, a, b, full):
    out, pos = [], 0
    for name, size, is_full in spec:
        if is_full and not full:
            continue
        if a[pos:pos + size] != b[pos:pos + size]:
            k = next(i for i in range(size) if a[pos + i] != b[pos + i])
            out.append('%s[+%d] original=%02x native=%02x' % (name, k, a[pos + k], b[pos + k]))
        pos += size
    return out


def run_scenario(x, nat_lib, nat_spec, ctor, sc, stats, keep_machine=False):
    group = sc['id'].split(':')[0] if not sc['id'].startswith('seq') else 'seq'
    group = 'synth' if group == 'synth' else group.rstrip('0123456789.') if group == 'seq' else group
    before = (stats['visits'], stats['effects'], stats['ticks'])
    try:
        return run_scenario_inner(x, nat_lib, nat_spec, ctor, sc, stats, keep_machine)
    finally:
        g = stats['groups'].setdefault(group, Counter())
        g['scenarios'] += 1
        g['visits'] += stats['visits'] - before[0]
        g['effects'] += stats['effects'] - before[1]
        g['ticks'] += stats['ticks'] - before[2]


def run_scenario_inner(x, nat_lib, nat_spec, ctor, sc, stats, keep_machine=False):
    rng = random.Random(sc['seed'])
    handle = OBJ_BASE
    image = image_for(ctor, sc)
    if not keep_machine:
        x.hard_reset()
    x.script = sc['script']
    x.counters.clear()
    x.install_object(image)
    x.install_rows(sc.get('row', 0), sc.get('tail') or b'', handle)
    apply_world(x, sc, rng)
    row = sc.get('row', 0)
    nat = Native(nat_lib, nat_spec, image, handle, sc['script'])
    try:
        blob = x.snapshot(True)
        nat.load(blob)
        if nat.store(True) != blob:
            raise Mismatch('initial state round trip: ' + '; '.join(diff_fields(nat_spec, blob, nat.store(True), True)[:4]))
        tick_log = []
        for tick in range(sc.get('max_ticks', 14)):
            for idx, v in sc.get('events_at', {}).get(tick, {}).items():
                x.wr(EVENTS_VA + 4 * idx, struct.pack('<i', v))
                nat.lib.a3f_set_event(nat.h, idx, v)
            ct = sc.get('choose_at', {}).get(tick)
            if ct is not None:
                count = struct.unpack('<h', x.rd(MGR + 0xf21, 2))[0]
                idx = ct(count) if callable(ct) else ct
                if idx is not None and 0 <= idx < 30:
                    x.wr(0x5839b1 + 4 * idx, struct.pack('<i', 1))
                    nat.lib.a3f_set_chosen(nat.h, idx, 1)
            before = dict(phase=x.phase(row), done=x.completed(row), mode=x.s32(0x583999))
            blob_before = x.snapshot(True)
            x.dispatch()
            entered = x.entered
            gate = True
            if sc.get('gate'):
                gate = x.s32(EVENTS_VA + 4 * sc['gate'][0]) == sc['gate'][1]
            expect_enter = before['mode'] == 3 and not before['done'] and gate
            if not sc.get('tail') or sc.get('gate'):
                if bool(entered) != expect_enter:
                    raise Mismatch('tick %d: handler entry %s but dispatcher model says %s' % (tick, entered, expect_enter))
            if entered:
                if entered != [row]:
                    raise Mismatch('tick %d: handler entered with row %s' % (tick, entered))
                status, why, nev, res = nat.visit(row, before['phase'])
                stats['native_status'][status] += 1
                if status != 0:
                    raise Mismatch('tick %d: native refused (status %d: %s) where the original ran' % (tick, status, why))
                if res[5]:
                    nev.append(('release row=%d' % row, None))
            else:
                nev, res = [], [0] * 8
                if x.events:
                    raise Mismatch('tick %d: effects without handler entry' % tick)
            stats['ticks'] += 1
            ev = x.events
            if [t for t, _ in ev] != [t for t, _ in nev]:
                a = [t for t, _ in ev]
                b = [t for t, _ in nev]
                k = next((i for i in range(min(len(a), len(b))) if a[i] != b[i]), min(len(a), len(b)))
                raise Mismatch('tick %d effect %d: original %r vs native %r' % (
                    tick, k, a[k] if k < len(a) else None, b[k] if k < len(b) else None))
            for k, ((t, sa), (_, sb)) in enumerate(zip(ev, nev)):
                stats['effects'] += 1
                if sa is None:
                    continue
                stats['light_snapshots'] += 1
                stats['fields_compared'] += sum(1 for f in nat_spec if not f[2])
                d = diff_fields(nat_spec, sa, sb, False)
                if d:
                    raise Mismatch('tick %d effect %d (%s): %s' % (tick, k, t, '; '.join(d[:5])))
            fa, fb = x.snapshot(True), nat.store(True)
            stats['full_snapshots'] += 1
            stats['fields_compared'] += len(nat_spec)
            stats['bytes_compared'] += len(fa)
            d = diff_fields(nat_spec, fa, fb, True)
            if d:
                raise Mismatch('tick %d end of visit: %s' % (tick, '; '.join(d[:6])))
            ia, ib = x.rd(OBJ_BASE, len(image)), nat.arena()
            stats['bytes_compared'] += len(ia)
            if ia != ib:
                k = next(i for i in range(len(ia)) if ia[i] != ib[i])
                raise Mismatch('tick %d object image differs at +%#x' % (tick, k))
            after = dict(phase=x.phase(row), done=x.completed(row), mode=x.s32(0x583999))
            if entered:
                flags = dict(phase_after=res[0], ran=res[1], started=res[2], finished=res[3],
                             scene_change=res[4], released=res[5])
                if after['phase'] != flags['phase_after']:
                    raise Mismatch('tick %d phase: original %d native %d' % (tick, after['phase'], flags['phase_after']))
                if bool(after['done']) != bool(flags['finished']) or (after['done'] and not before['done']) != bool(flags['finished']):
                    raise Mismatch('tick %d completion byte: original %d native finished=%d' % (tick, after['done'], flags['finished']))
                if (before['phase'], after['phase']) == (0, 1) and not flags['started']:
                    raise Mismatch('tick %d started flag' % tick)
                rel = any(t.startswith('release') for t, _ in ev)
                if rel != bool(flags['released']):
                    raise Mismatch('tick %d release flag' % tick)
                if (after['mode'] == 4 and before['mode'] == 3) != bool(flags['scene_change']):
                    raise Mismatch('tick %d scene_change flag (mode %d->%d)' % (tick, before['mode'], after['mode']))
                stats['visits'] += 1
            tick_log.append(dict(tick=tick, entered=bool(entered), phase=(before['phase'], after['phase']),
                                 events=len(ev)))
            for t, _ in ev:
                stats['effect_kinds'][t.split()[0].split('=')[0]] += 1
            if after['done'] or after['mode'] != 3:
                break
        stats['scenarios'] += 1
        if sc.get('dep'):
            stats['gate_open' if any(t['entered'] for t in tick_log) else 'gate_closed'] += 1
        stats['writes'].update(x.writes)
        return tick_log
    finally:
        nat.close()


# ---------------------------------------------------------------------------------------------
# corpus and matrix
# ---------------------------------------------------------------------------------------------
def load_corpus():
    corpus_bytes = (PRIVATE / 'A-3F.1.corpus.json').read_bytes()
    manifest_bytes = (ROOT / 'work/analysis/hiff-resources.json').read_bytes()
    if sha(corpus_bytes) != c3f.CORPUS_HASH or sha(manifest_bytes) != c3f.MANIFEST_HASH:
        raise OracleError('corpus/manifest identity mismatch')
    corpus, manifest = json.loads(corpus_bytes), json.loads(manifest_bytes)
    inventory = {int(r['index']): r for r in manifest['resources']}
    cache = {}

    def resource(i):
        if i not in cache:
            b = (ROOT / 'work/analysis/hiff-resources' / ('%04d.bin' % i)).read_bytes()
            if len(b) != inventory[i]['size'] or sha(b) != inventory[i]['sha256']:
                raise OracleError('resource pin mismatch %d' % i)
            cache[i] = b
        return cache[i]
    entries = c3f.parse_entries(c3f._read_cvtx_payload(resource(64)))
    table = {}
    for e in entries:
        table.setdefault(e['key'].lower(), e['caption'])
    rows = []
    for r in corpus['records']:
        if r['option_44'] != 0x14 or r['option_45'] != 0x14:
            continue
        data = resource(r['resource_index'])
        act = data[r['act_payload_offset']:r['act_payload_offset'] + r['act_payload_length']]
        if act[48] != 0x3f or sha(act[50:]) != r['body_sha256']:
            raise OracleError('ACT identity mismatch')
        body = act[50:]
        typed = body[:r['typed_body_length']]
        tail = body[r['typed_body_length']:]
        texts = c3f.resolve(body, table)
        rows.append(dict(rec=r, typed=typed, tail=tail, texts=texts, tier='A' if r['primary_count'] == 0 else 'B'))
    return corpus, rows


def corpus_scenarios(rows, rng_seed=7):
    out = []
    for n, r in enumerate(rows):
        rec = r['rec']
        rng = random.Random(rng_seed * 100003 + n)
        tag = 'corpus%s:%d:%d' % (r['tier'], rec['resource_index'], rec['action_index'])
        names = [b'NO SOUND', b'', b'RSP_%d' % n, b'NO SOUND', b'', b'X' * 32]
        base = dict(body=r['typed'], texts=r['texts'], seed=n, row=n % 3, tail=None)
        variants = [
            dict(id=tag + ':end', world=default_world(rng), script=dict(playing_c=[1] * (n % 4), slots=[3, 4], names=names)),
            dict(id=tag + ':capt', world=default_world(rng, capt=1, c106=0, l788=5, held=7 + n % 5, e204=3 + n % 2),
                 script=dict(playing_c=[1, 1, 0], slots=[6, 2], names=names, hotspot=n % 2), poison=True),
            dict(id=tag + ':fast_skip', world=default_world(rng, fast=1, e204=4),
                 script=dict(playing_c=[1, 1, 1, 1, 0], key_skip=[0, 0, 1, 1], slots=[1, 2], names=names)),
            dict(id=tag + ':fast_skip2', world=default_world(rng, fast=1, e204=4), max_ticks=7,
                 script=dict(playing_c=[1] * 5 + [0], key_skip=[0, 2, 2, 255, 1], slots=[1, 2], names=names)),
            dict(id=tag + ':fast_noskip', world=default_world(rng, fast=1), max_ticks=6,
                 script=dict(playing_c=[1, 0, 0], slots=[1, 2], names=names)),
            dict(id=tag + ':exit', world=default_world(rng, exit=1, capt=n % 2, held=3),
                 script=dict(playing_c=[1], slots=[2, 1], names=names, stack=(0x1234, 100 + n, 5, 6, n % 2, 7, 8, 9)), poison=True),
        ]
        if r['tail']:
            recs = [struct.unpack_from('<8h', r['tail'], 16 * i) for i in range(len(r['tail']) // 16)]
            dep_ev = {rc[1]: rc[2] for rc in recs if rc[0] == 2 and 0 <= rc[1] < EVENT_SLOTS and 0 <= rc[2] < 256}
            dep_pr = {rc[1]: rc[2] for rc in recs if rc[0] == 1 and 0 <= rc[1] < PRESENCE_SLOTS and 0 <= rc[2] < 256}
            variants.append(dict(id=tag + ':dep', world=default_world(rng, capt=n % 2), tail=r['tail'], dep=True,
                                 events=dep_ev, presence=dep_pr, max_ticks=10,
                                 script=dict(playing_c=[1, 1, 0], slots=[2, 3], names=names)))
        if n % 40 == 0:
            variants.append(dict(id=tag + ':stale_names', world=default_world(rng, capt=1), poison_names=True, known='D2',
                                 script=dict(playing_c=[1], slots=[1, 2], names=names[:1])))
        for k, v in enumerate(variants):
            sc = dict(base)
            sc.update(v)
            sc['seed'] = rng.randrange(1 << 30)
            sc['events'], sc['presence'] = dict(v.get('events', {})), dict(v.get('presence', {}))
            sc['hit'] = 1.0 if v.get('dep') else (0.0, 1.0, 0.5, 0.5, 0.5, 0.5)[min(k, 5)]
            sc['body_image_seed'] = True
            if r['tier'] == 'B':
                sc['choose_at'] = {3: (lambda c, n=n: None if c == 0 else n % c)}
                sc['max_ticks'] = 14
            out.append(sc)
    return out


def image_for(ctor, sc):
    """Constructor output plus the scenario's post-construct patches. The constructor writes kind 0
    and event index -1 into every primary entry; kinds 1/2 and event writes (reachable only through
    other loaders in the original) are patched into BOTH images so the kernels read identical bytes."""
    image = bytearray(ctor.build(sc['body'], sc['texts'], OBJ_BASE))
    count, table = struct.unpack_from('<h', image, 0x793)[0], struct.unpack_from('<I', image, 0x795)[0]
    for i, k in enumerate(sc.get('kinds', [])[:max(count, 0)]):
        image[table - OBJ_BASE + i * 0x1d1 + 0x1b7] = k
    for i, (idx, val) in sc.get('patch_event', {}).items():
        if i < count:
            struct.pack_into('<h', image, table - OBJ_BASE + i * 0x1d1 + 0x1cc, idx)
            image[table - OBJ_BASE + i * 0x1d1 + 0x1ce] = val
    for off, data in sc.get('patch', {}).items():
        image[off:off + len(data)] = data
    inter = sc.get('inter')
    if inter:  # intermediate table (stride 0x1c, handle at +0x79b): always empty for raw 0x3f, so it is appended
        while len(image) % 4:
            image.append(0xcd)
        table_off = len(image)
        image += bytes([0xcd]) * (0x1c * len(inter))
        for i, e in enumerate(inter):
            conds = e.get('conds', [])
            while len(image) % 4:
                image.append(0xcd)
            cond_off = len(image)
            for kind, index, value, link in conds:
                image += struct.pack('<BhBB', kind, index, value, link)
            o = table_off + 0x1c * i
            struct.pack_into('<hI', image, o, len(conds), OBJ_BASE + cond_off if conds else 0)
            struct.pack_into('<hhhhiii', image, o + 6, e.get('scene', 9999), *e.get('words', (1, 2, 3)),
                             *e.get('dwords', (4, 5, 6)))
        struct.pack_into('<h', image, 0x799, len(inter))
        struct.pack_into('<I', image, 0x79b, OBJ_BASE + table_off)
    return bytes(image)


def finalize_conditions(sc, ctor):
    """Seed event/presence arrays from the object's own condition records (needs the image)."""
    image = image_for(ctor, sc)
    rng = random.Random(sc['seed'] ^ 0x5555)
    ev, pr = dict(sc.get('events', {})), dict(sc.get('presence', {}))
    seed_conditions(rng, image, OBJ_BASE, ev, pr, sc.get('hit', 0.5))
    sc['events'], sc['presence'] = ev, pr


def synthetic_matrix():
    out = []
    S = lambda n, **kw: out.append({**dict(id='synth:' + n, seed=len(out) + 1, tail=None, texts=None), **kw})
    names = [b'NO SOUND', b'', b'RESP_ONE', b'RESP_TWO', b'NO SOUNDX', b'RESP_THREE', b'']
    ev = lambda *p: dict(p)
    cond = lambda k, i, v, l=0: (k, i, v, l)
    w = lambda **kw: default_world(random.Random(1), **kw)

    def responses(primary, **bkw):
        return body_bytes(primary=primary, **bkw), ['caption text'] + [p.get('text', 'resp %d' % i) for i, p in enumerate(primary)]

    # --- condition trees through 0x420737 (also the chain rules) ---
    chains = [
        [cond(1, 3, 1)], [cond(1, 3, 1), cond(1, 4, 1)], [cond(1, 3, 1, 1), cond(1, 4, 1)],
        [cond(1, 3, 1, 1), cond(1, 4, 1, 1), cond(1, 5, 1)], [cond(1, 3, 1), cond(1, 4, 1, 1), cond(1, 5, 1)],
        [cond(2, 6, 1), cond(1, 7, 1, 1), cond(3, 8, 1)], [cond(0, 3, 1, 1), cond(1, 4, 0)],
        [cond(1, 3, 255, 1), cond(2, 9, 0, 1), cond(1, 10, 2, 0), cond(2, 11, 3)],
    ]
    for ci, conds in enumerate(chains):
        for state in range(8):
            events = {3: state & 1, 4: (state >> 1) & 1, 5: (state >> 2) & 1, 7: state & 1, 10: 2, 8: 1}
            presence = {6: state & 1, 9: (state >> 1) & 1, 11: 3 if state & 4 else 0}
            if ci == 7:
                events[3] = 255 if state & 1 else 0
            b, t = responses([dict(conds=conds, text='chain %d' % ci)])
            S('chain%d_state%d' % (ci, state), body=b, texts=t, world=w(), events=events, presence=presence,
              script=dict(playing_c=[1], slots=[4, 5], names=names), choose_at={3: 0}, max_ticks=10)
    # --- kinds 0/1/2, duplicates, 30-entry overflow ---
    def kinds_case(name, kinds, texts_, choose=0):
        prim = [dict(text=t, scene=100 + i, sound=b'SOUND%d' % i) for i, t in enumerate(texts_)]
        b, t = responses(prim)
        S(name, body=b, texts=t, world=w(), script=dict(playing_c=[1], slots=[4, 5], names=names),
          choose_at={3: lambda c, ch=choose: None if c == 0 else min(ch, c - 1)}, max_ticks=12,
          kinds=kinds, patch_event={i: (40 + i, 9) for i in range(len(kinds)) if i % 3 == 1})
    kinds_case('kinds_add_dupes', [0, 0, 0, 0], ['a', 'A', 'b', 'a'])
    kinds_case('kinds_replace', [0, 1, 1, 0], ['a', 'a', 'b', 'c'])
    kinds_case('kinds_remove', [0, 0, 2, 2, 2], ['a', 'b', 'a', 'zz', 'B'])
    kinds_case('kinds_mix', [0, 0, 0, 1, 2, 0, 1], ['x', 'y', 'z', 'y', 'x', 'q', 'w'], choose=2)
    kinds_case('overflow30', [0] * 34, ['row %d' % i for i in range(34)], choose=29)
    kinds_case('overflow_replace_full', [0] * 30 + [1, 1, 0], ['row %d' % i for i in range(30)] + ['row 3', 'new1', 'new2'], choose=29)
    kinds_case('overflow_remove_then_add', [0] * 30 + [2, 0], ['row %d' % i for i in range(30)] + ['row 0', 'late'], choose=29)
    kinds_case('case_fold', [0, 0, 0], ['Hello World', 'hello world', 'HELLO WORLD!'])
    # --- chosen response transition / sound / event write ---
    for variant in range(6):
        prim = [dict(text='r%d' % i, scene=(9999 if i == 1 else 200 + i), sound=b'S%d' % i) for i in range(3)]
        b, t = responses(prim, opt46=1 if variant % 2 else 0, w47=77)
        S('choice_v%d' % variant, body=b, texts=t, world=w(), script=dict(
            playing_c=[1, 0], playing_d=[1, 1, 0], slots=[8, 9], names=[names[variant % 6], names[(variant + 2) % 6], names[2]]),
          choose_at={3: variant % 3}, max_ticks=14, kinds=[0, 0, 0],
          patch_event={0: (-1, 0), 1: (30 + variant, 7), 2: (5, 255)})
    # --- secondary tables 1 and 2, with chaining through events ---
    secs = [
        [dict(kind=1, id=20, value=3)], [dict(kind=2, id=5, value=1)], [dict(kind=2, id=6, value=0)],
        [dict(kind=1, id=21, value=1), dict(conds=[cond(1, 21, 1)], kind=1, id=22, value=9)],
        [dict(kind=1, id=23, value=1), dict(conds=[cond(1, 23, 0)], kind=1, id=24, value=9)],
        [dict(conds=[cond(1, 25, 4)], kind=1, id=26, value=2), dict(conds=[cond(2, 27, 1)], kind=2, id=7, value=1),
         dict(kind=3, id=1, value=1), dict(kind=0, id=2, value=2)],
        [dict(kind=1, id=28, value=5), dict(conds=[cond(1, 28, 5, 1), cond(1, 29, 1)], kind=2, id=8, value=0)],
    ]
    for si, sec in enumerate(secs):
        for st in range(3):
            tag = 'D1' if si in (3, 4, 6) else None
            events = {25: 4 if st else 0, 29: 1 if st == 2 else 0}
            presence = {27: 1 if st else 0}
            b = body_bytes(secondary=sec, opt46=1, w47=300 + si, w49=2)
            S('secondary%d_%d' % (si, st), body=b, texts=['caption'], world=w(held=2 if st == 1 else -1),
              events=events, presence=presence, script=dict(playing_c=[1], slots=[1, 2], names=names), known=tag)
    # --- transition selection and misc tier A knobs ---
    for opt46 in (0, 1, 2):
        for w47 in (9999, 5):
            for exit_ in (0, 1):
                b = body_bytes(opt46=opt46, w47=w47, w49=7)
                S('trans_%d_%d_%d' % (opt46, w47, exit_), body=b, texts=['c'], world=w(exit=exit_),
                  script=dict(playing_c=[1, 1], slots=[1, 2], names=names))
    for variant in range(4):
        b = body_bytes(opt46=1)
        S('guards_%d' % variant, body=b, texts=['c'], world=w(mode=(3, 4, 3, 3)[variant], f9=(0, 0, 1, 0)[variant], fd=(0, 0, 0, 1)[variant]),
          script=dict(playing_c=[1], slots=[1, 2], names=names), max_ticks=3)
    for e204 in (0, 2, 3, 4):
        for c106, l788 in ((0, 1), (1, 1), (2, 1)):
            b = body_bytes(opt46=1)
            S('engine_%d_%d_%d' % (e204, c106, l788), body=b, texts=['c'], world=w(e204=e204, c106=c106, l788=l788),
              script=dict(playing_c=[1], slots=[1, 2], names=names), max_ticks=4)
    # patched image bytes: +0x778 (list reset keyed), +0x77c (pop flag), +0x77b already via opt46
    for flag778 in (0, 1):
        for pop in (0, 1, 2):
            b = body_bytes(opt46=0, w47=3)
            S('patch778_%d_pop%d' % (flag778, pop), body=b, texts=['c'], world=w(), script=dict(playing_c=[1], slots=[1, 2], names=names),
              patch={0x778: bytes([flag778]), 0x77c: bytes([pop])})
    # real dependency gate 0x423f57 (tree built by 0x424aa8): record = opcode 2, event index, value, 0...
    for gi, (gidx, gval, unlock) in enumerate(((40, 1, 3), (41, 0, 99), (42, 5, 2))):
        tail = struct.pack('<8h', 2, gidx, gval, 0, 0, 0, 0, 0)
        b = body_bytes(opt46=1, w47=11)
        S('gate%d' % gi, body=b, texts=['c'], world=w(), tail=tail, gate=(gidx, gval),
          events={gidx: 7}, events_at={unlock: {gidx: gval}}, row=gi,
          script=dict(playing_c=[1, 1], slots=[1, 2], names=names), max_ticks=10)
    # fast convo with a response list: the choice array decides, never the key
    for fk, skip in enumerate(([], [0, 0, 1], [1, 1, 1])):
        prim = [dict(text='fa', scene=61), dict(text='fb', scene=62)]
        b, t = responses(prim)
        S('fast_resp%d' % fk, body=b, texts=t, world=w(fast=1), script=dict(
            playing_c=[1] * 8 + [0], key_skip=skip, slots=[1, 2], names=[b'NO SOUND', b'RS1']),
          choose_at={3: 1}, max_ticks=12)
    for cap in (0, 1):
        for kinds in ([0], [0, 2]):
            prim = [dict(text='only'), dict(text='ONLY')]
            b, t = responses(prim)
            S('resp_capt%d_%d' % (cap, len(kinds)), body=b, texts=t, world=w(capt=cap), kinds=kinds,
              script=dict(playing_c=[1], slots=[3, 4], names=[b'RSX', b'']), choose_at={3: 0}, max_ticks=12)
    kinds_case('kinds_unknown', [0, 3, 255, 2, 1, 7, 0], ['k0', 'k1', 'k2', 'k0', 'k3', 'k4', 'k5'], choose=1)
    # intermediate table 0x4225..: first true entry wins, then default, then pop flag
    for ii, inter in enumerate((
            [dict(conds=[cond(1, 50, 1)], scene=70, words=(7, 8, 9), dwords=(10, 11, 12))],
            [dict(conds=[cond(1, 50, 1)], scene=70), dict(scene=71, words=(-3, 0, 4), dwords=(-1, 2, 3))],
            [dict(conds=[cond(1, 50, 1, 1), cond(2, 51, 2)], scene=72), dict(conds=[cond(1, 52, 3)], scene=73)])):
        for st in range(4):
            for exit_ in (0, 1) if st == 0 else (0,):
                prim = [dict(text='i0', scene=9999)]
                b, t = responses(prim, opt46=st & 1, w47=77, w49=5)
                S('inter%d_%d_%d' % (ii, st, exit_), body=b, texts=t, world=w(exit=exit_),
                  events={50: st & 1, 52: 3 if st & 2 else 0}, presence={51: 2 if st & 1 else 0}, inter=inter,
                  script=dict(playing_c=[1], slots=[1, 2], names=names, stack=(0x1234, 400 + ii, 1, 2, 1, 3, 4, 5)),
                  patch={0x77c: bytes([1 if st == 3 else 2])}, choose_at={3: 0}, max_ticks=12)
    # display name '_' -> ' ' and a 32-character name, response names at the 32-character limit
    for nm in (b'MY_SND_X_1', b'N' * 32, b'_', b'A_B'):
        b = body_bytes(name=nm, opt46=1, w47=9)
        S('name_%d' % len(nm), body=b, texts=['c'], world=w(), script=dict(playing_c=[1], slots=[1, 2], names=names))
    prim = [dict(text='n1', scene=3), dict(text='n2', scene=4)]
    b, t = responses(prim)
    S('resp_long_names', body=b, texts=t, world=w(), script=dict(playing_c=[0], playing_d=[1, 0], slots=[1, 2],
      names=[b'R' * 32, b'S_' + b'T' * 30]), choose_at={3: 0}, max_ticks=12)
    S('resp_long_names1', body=b, texts=t, world=w(), script=dict(playing_c=[0], playing_d=[0], slots=[1, 2],
      names=[b'R' * 32, b'S_' + b'T' * 30]), choose_at={3: 1}, max_ticks=12)
    # stale tails of the sound-name table cells (native clears 41 bytes per cell, the original 33)
    b = body_bytes(primary=[dict(text='p', scene=4)])
    S('stale_names', body=b, texts=['c', 'p'], world=w(), poison=True, poison_names=True, known='D2', script=dict(playing_c=[0], slots=[1, 2], names=[b'S1']),
      choose_at={3: 0}, max_ticks=10)
    return out


MUTANTS = {
    'fast convo ignored': ('if (playing == 0 || w->fast_convo_58322a != 0) {', 'if (playing == 0) {'),
    'chain rule forward': ('f[i + 1] = 1u;\n                    changed = 1;', 'changed = 0;'),
    'overflow off by one': ('m->response_count + 1 >= 0x1f', 'm->response_count + 1 > 0x1f'),
    'no-sound name': ('memcmp(name, NO_SOUND, 9u) != 0 && name[0] != 0u', 'name[0] != 0u'),
    'exit flag precedence': ('if (w->exit_58322b != 0) {\n        next = NEXT_POP_EXIT;', 'if (0) {\n        next = NEXT_POP_EXIT;'),
    'case sensitive text': ('if (x > 0x40u && x < 0x5bu) {', 'if (0) {'),
    'second guard ignored': ('if (w->flag_5c39e9 != 0 || w->flag_5c39ed != 0) {', 'if (w->flag_5c39e9 != 0) {'),
    'default always': ('img[C3F_DEFAULT_ENABLE] == 1u', 'img[C3F_DEFAULT_ENABLE] != 7u'),
    'event write skipped': ('w->events[m->responses[sel].event_index] = (int32_t)m->responses[sel].event_value;', '(void)0;'),
    'response sound channel': ('sound_start(h, &cmd, CONVO3F_RESPONSE_CHANNEL, why)', 'sound_start(h, &cmd, CONVO3F_SOUND_CHANNEL, why)'),
    'held item put-back flag': ('h->inventory_add(h->context, w->held_item, 0)', 'h->inventory_add(h->context, w->held_item, 1)'),
    'replace becomes add': ('        case 1u: {\n            const int found = find_response(m, entry);\n            if (found >= 0) {\n                compact_from(m, found);\n            }\n            add_response(m, entry);', '        case 1u: {\n            add_response(m, entry);'),
    'cursor compare': ('if (w->cursor_583106 < w->limit_5b3788) {', 'if (w->cursor_583106 <= w->limit_5b3788) {'),
    'selection off by one': ('w->selected_570374 = (int16_t)i;', 'w->selected_570374 = (int16_t)(i + 1);'),
    'skip key value': ('w->skip_key_58321d == 1u) {', 'w->skip_key_58321d != 0u) {'),
}


def run_sequences(x, lib, spec, ctor, scs, stats, count, seed=11):
    """Back-to-back conversations on one machine: the manager keeps its stale list, pool and slots."""
    rng = random.Random(seed)
    pool = [s for s in scs if 'resp' in s['id'] or 'kinds' in s['id'] or 'overflow' in s['id'] or 'patch778' in s['id']
            or (s['id'].startswith('corpus') and not s.get('dep'))]
    bad = []
    for n in range(count):
        picks = [rng.choice(pool) for _ in range(3)]
        for k, sc in enumerate(picks):
            sc = dict(sc)
            sc['id'] = 'seq%d.%d:%s' % (n, k, sc['id'])
            try:
                run_scenario(x, lib, spec, ctor, sc, stats, keep_machine=k > 0)
            except (Mismatch, OracleError) as error:
                if not classify(sc, str(error), stats):
                    bad.append((sc['id'], str(error)))
                    stats['mismatches'] += 1
                break
    return bad


def build_scenarios(ctor, args):
    corpus, rows = load_corpus()
    if args.limit:
        rows = rows[:args.limit]
    scs = corpus_scenarios(rows)
    for sc in scs:
        finalize_conditions(sc, ctor)
    scs += synthetic_matrix()
    if args.only:
        scs = [s for s in scs if args.only in s['id']]
    return corpus, rows, scs


KNOWN_DEFECTS = {
    'D1': ('w.events', 'effect '),  # 0x4209e8 evaluates each secondary entry AFTER the earlier entries' effects
    'D2': ('w.uinames',),           # 0x4211ec clears 33 bytes per 41-byte sound-name cell, native clears 41
    'D3': ('m.count[',),            # 0x420e4c resets the list count BEFORE the surface/put-back effects, native after
}


def classify(sc, message, stats):
    """A mismatch is 'known' only for scenarios tagged with a documented native defect whose message matches."""
    tag = sc.get('known')
    if tag and any(sig in message for sig in KNOWN_DEFECTS[tag]):
        stats['known'][tag] += 1
        return True
    if sc['id'].startswith('seq'):  # stale manager/world state of an earlier conversation
        if 'w.uinames[' in message:
            tag = 'D2'
        elif 'm.count[' in message and ' effect ' in message:
            tag = 'D3'
        if tag in ('D2', 'D3'):
            stats['known'][tag] += 1
            return True
    return False


def run_list(x, lib, spec, ctor, scs, stats, fail_fast=False):
    bad = []
    for sc in scs:
        try:
            run_scenario(x, lib, spec, ctor, sc, stats)
            if sc.get('known'):
                stats['known_not_observed'][sc['known']] += 1  # native fixed (or scenario ineffective)
        except (Mismatch, OracleError) as error:
            if classify(sc, str(error), stats):
                continue
            if sc.get('dep') and 'unexpected Windows import' in str(error):
                stats['dep_unsupported'] += 1  # the real dependency evaluator needs an OS service (rand/time)
                continue
            bad.append((sc['id'], str(error)))
            stats['mismatches'] += 1
            if fail_fast:
                break
    return bad


def new_stats():
    return dict(scenarios=0, visits=0, ticks=0, effects=0, light_snapshots=0, full_snapshots=0,
                fields_compared=0, bytes_compared=0, mismatches=0, native_status=Counter(),
                known=Counter(), known_not_observed=Counter(),
                effect_kinds=Counter(), writes=Counter(), groups={}, gate_closed=0, gate_open=0, dep_unsupported=0)


def mutation_check(x, spec, ctor_unused, scs, args, workdir):
    """Build the kernel with one rule broken at a time and require the oracle to notice."""
    source = (args.src / 'action_family_3f_runtime.c').read_text()
    report = []
    for name, (old, new) in MUTANTS.items():
        if source.count(old) != 1:
            report.append(dict(mutant=name, detected=None, why='mutation anchor drifted'))
            continue
        d = Path(workdir) / 'mut'
        shutil.rmtree(d, ignore_errors=True)
        d.mkdir(parents=True)
        for item in args.src.iterdir():
            if item.suffix in ('.c', '.h'):
                shutil.copy(item, d / item.name)
        (d / 'action_family_3f_runtime.c').write_text(source.replace(old, new))
        lib_path = build_driver(d, d / ('libmut%d.so' % len(report)))  # unique name: dlopen caches by path
        # a fresh process per mutant: a broken kernel may crash, which also counts as detection
        cmd = [sys.executable, str(Path(__file__).resolve()), '--native-library', str(lib_path), '--mutation-run',
               '--limit', str(args.limit), '--mutation-corpus-rows', str(args.mutation_corpus_rows)]
        done = subprocess.run(cmd, capture_output=True, text=True)
        first = next((l for l in done.stdout.splitlines() if l.startswith('FIRST ')), None)
        how = 'mismatch' if done.returncode == 1 else 'crash signal %d' % -done.returncode if done.returncode < 0 else \
            'undetected' if done.returncode == 0 else 'error %d: %s' % (done.returncode, done.stderr[-200:])
        report.append(dict(mutant=name, detected=done.returncode != 0 and not how.startswith('error'), how=how,
                           first=(None, first[6:]) if first else None))
    return report


COVERED = {'handler 0x420c17': (0x420c17, 0x42291e), 'list reset 0x41f986': (0x41f986, 0x41fa11),
           'add 0x41fa11': (0x41fa11, 0x41fd08), 'replace 0x41fd08': (0x41fd08, 0x42028e),
           'remove 0x42028e': (0x42028e, 0x4205c1), 'build list 0x4205c1': (0x4205c1, 0x420737),
           'condition tree 0x420737': (0x420737, 0x4209e8), 'secondary table 0x4209e8': (0x4209e8, 0x420b9e),
           'held item put-back 0x4e8d96': (0x4e8d96, 0x4e8dc8), 'row store 0x41de29': (0x41de29, 0x41df01)}


def coverage_report(x):
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    ranges = sorted(x.blocks)
    starts = [a for a, _ in ranges]

    def executed(addr):
        i = bisect.bisect_right(starts, addr) - 1
        return i >= 0 and ranges[i][0] <= addr < ranges[i][0] + ranges[i][1] or any(
            a <= addr < a + sz for a, sz in ranges[max(0, i - 3):i + 1])
    out = {}
    for name, (a, z) in COVERED.items():
        code = x.pristine[a - 0x400000:z - 0x400000]
        total = hit = 0
        missed = []
        for ins in md.disasm(code, a):
            total += 1
            if executed(ins.address):
                hit += 1
            else:
                if missed and missed[-1][1] == ins.address:
                    missed[-1][1] = ins.address + ins.size
                else:
                    missed.append([ins.address, ins.address + ins.size])
        out[name] = dict(instructions=total, executed=hit, unexecuted_ranges=[[hex(p), hex(q)] for p, q in missed])
    return out


def read_report(x):
    """Reads of image data the original made, split into modelled / static initialised / zero-valued bss."""
    modelled = [(a, z) for a, z, _ in x.named + x.regions] + [(SLOT, SLOT + 8 * ROW)]
    nil = []
    static, bss = {}, {}
    for (addr, size), count in x.read_counts.items():
        if any(a < addr + size and addr < z for a, z in modelled):
            continue
        pristine = x.pristine[addr - 0x400000:addr - 0x400000 + size]
        (bss if not any(pristine) else static)[addr] = (size, count, x.reads[(addr, size)])
    return dict(
        modelled_reads=sum(c for (a, s_), c in x.read_counts.items() if any(p < a + s_ and a < q for p, q in modelled)),
        static_initialised=[dict(addr=hex(a), size=v[0], count=v[1], reader=hex(v[2])) for a, v in sorted(static.items())],
        zero_bss=[dict(addr=hex(a), size=v[0], count=v[1], reader=hex(v[2])) for a, v in sorted(bss.items())])


def code_windows():
    return [dict(start=hex(a), end=hex(z), sha256=h) for a, z, h in PINS_TABLE]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--result', type=Path)
    ap.add_argument('--src', type=Path, default=PROJECT / 'src')
    ap.add_argument('--native-library', type=Path)
    ap.add_argument('--limit', type=int, default=0, help='only the first N corpus rows (debug)')
    ap.add_argument('--only', default='', help='substring filter of scenario ids (debug)')
    ap.add_argument('--fail-fast', action='store_true')
    ap.add_argument('--show', type=int, default=12)
    ap.add_argument('--sequences', type=int, default=80)
    ap.add_argument('--discover-pins', action='store_true')
    ap.add_argument('--mutations', action='store_true', help='also run the native mutation check')
    ap.add_argument('--mutations-only', action='store_true', help='mutation check only (baseline run separately)')
    ap.add_argument('--mutation-corpus-rows', type=int, default=30)
    ap.add_argument('--mutation-run', action='store_true', help='internal: quick scenario set against --native-library')
    args = ap.parse_args()
    started = time.monotonic()
    work = Path(tempfile.mkdtemp(prefix='RT-23.oracle-', dir=PRIVATE))
    lib_path = args.native_library or build_driver(args.src, work / 'libdriver.so')
    lib, spec = Native.open(lib_path)
    ctor = Constructor(lib)
    x = X86(spec)
    if sha(DEFAULT_EXE.read_bytes()) != EXE_HASH:
        raise OracleError('executable identity mismatch')
    corpus, rows, scs = build_scenarios(ctor, args)
    stats = new_stats()
    if args.mutation_run:
        quick = [s for s in scs if s['id'].startswith('synth:') and not s.get('known')]
        quick += [s for s in scs if s['id'].startswith('corpus') and not s.get('known')][:args.mutation_corpus_rows * 6]
        bad = run_list(x, lib, spec, ctor, quick, stats, fail_fast=True)
        if bad:
            print('FIRST %s :: %s' % (bad[0][0], bad[0][1][:300]))
        return 1 if bad else 0
    if args.mutations_only:
        args.mutations = True
        scs_run = []
    else:
        scs_run = scs
    bad = run_list(x, lib, spec, ctor, scs_run, stats, args.fail_fast)
    if not args.only and not args.mutations_only:
        stats['sequences'] = args.sequences
        bad += run_sequences(x, lib, spec, ctor, scs, stats, args.sequences)
    if args.discover_pins:
        import glob
        starts = set()
        for f in glob.glob(str(ROOT / 'work/analysis/decompiled/batch-*.json')):
            for it in json.load(open(f))['normalized_result']['items']:
                starts.add(int(it['address'], 16))
        starts = sorted(starts)
        funcs = {}
        for a, s in x.blocks:
            i = bisect.bisect_right(starts, a) - 1
            funcs[starts[i]] = starts[i + 1]
        out = [(a, z, sha(x.pristine[a - 0x400000:z - 0x400000])) for a, z in sorted(funcs.items())]
        print('PINS_TABLE = (' + ','.join('(%#x,%#x,%r)' % t for t in out) + ',)')
    for sid, msg in bad[:args.show]:
        print('MISMATCH', sid, '::', msg[:400])
    stats['groups'] = {g: dict(v) for g, v in stats['groups'].items()}
    summary = {k: (dict(v) if isinstance(v, Counter) else v) for k, v in stats.items()}
    cov, reads = coverage_report(x), read_report(x)
    for name, c in cov.items():
        print('COVERAGE %-34s %d/%d instructions' % (name, c['executed'], c['instructions']))
    print('READS modelled=%d static_initialised=%d zero_bss=%d' % (reads['modelled_reads'], len(reads['static_initialised']), len(reads['zero_bss'])))
    for r in reads['zero_bss'][:40]:
        print('  zero-bss read', r)
    print(json.dumps(summary, sort_keys=True))
    mutations = None
    if args.mutations and not bad:
        mutations = mutation_check(x, spec, ctor, None, args, work)
        for m in mutations:
            print('MUTANT', m['mutant'], 'detected=%s' % m['detected'], m['how'], (m.get('first') or ('', ''))[1][:120])
    if args.result:
        sources = {n: sha((args.src / n).read_bytes()) for n in ('action_family_3f_runtime.c', 'action_family_3f_runtime.h', 'action_family_3f.c')}
        result = dict(slice='RT-23', status='pass' if not bad else 'fail', mismatches=len(bad),
                      exe_sha256=EXE_HASH, corpus_sha256=c3f.CORPUS_HASH, manifest_sha256=c3f.MANIFEST_HASH,
                      source_sha256=sources, native_driver_sha256=sha(lib_path.read_bytes()),
                      oracle_sha256=sha(Path(__file__).read_bytes()),
                      driver_source_sha256=sha((PROJECT / 'tests/action_family_3f_runtime_oracle_driver.c').read_bytes()),
                      code_windows=code_windows(), corpus_rows=len(rows), scenarios=len(scs), stats=summary,
                      mutations=mutations, mismatch_list=bad[:50], coverage=cov, unmodelled_reads=reads,
                      hooks_fired=dict(x.counters_total), elapsed_seconds=round(time.monotonic() - started, 1))
        args.result.write_text(json.dumps(result, indent=2, default=str) + '\n')
        print('receipt', args.result)
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
