# FUN_004ba486
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ba486
# extent:       0x004ba486-0x004ba4f2 (108 code bytes)
# span:         0x004ba486-0x004ba4f2 (code 108, tables 0, padding 0)
# sha256:       8510b8daf129425ab4b546b95734efe2030f887ede8999a5bd636bdebc2d38e1
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ba486
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_2d4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_2d4, 0x2d4  # offset +0x2d4

# --- external targets -----------------------------------------------

.org 0x004ba486 - 0x401000
.globl FUN_004ba486
FUN_004ba486:
    # block 0x004ba486: entry, 22 instruction(s), ends with ret 0x4
    push ebp                                     # 004ba486
    {load} mov ebp, esp                          # 004ba487
    push ecx                                     # 004ba489
    mov dword ptr [ebp - local_4], ecx           # 004ba48a
    mov dword ptr [0x5c39e5], 0x276a             # 004ba48d
    movsx eax, word ptr [ebp + arg_8]            # 004ba497
    mov ecx, dword ptr [ebp - local_4]           # 004ba49b
    mov dword ptr [ecx + field_2d4], eax         # 004ba49e
    mov dword ptr [0x5b44f0], 0x0                # 004ba4a4
    mov dword ptr [0x5b44f4], 0x1                # 004ba4ae
    mov edx, dword ptr [0x5d0377]                # 004ba4b8
    mov dword ptr [0x5d162d], edx                # 004ba4be
    mov eax, dword ptr [0x5b44f0]                # 004ba4c4
    shl eax, 0x5                                 # 004ba4c9
    mov ecx, dword ptr [0x5b44f4]                # 004ba4cc
    shl ecx, 0x4                                 # 004ba4d2
    lea edx, [eax + ecx + 0x5b160c]              # 004ba4d5
    mov dword ptr [0x5d1631], edx                # 004ba4dc
    mov dword ptr [0x5d1639], 0x1                # 004ba4e2
    {load} mov esp, ebp                          # 004ba4ec
    pop ebp                                      # 004ba4ee
    ret 0x4                                      # 004ba4ef

