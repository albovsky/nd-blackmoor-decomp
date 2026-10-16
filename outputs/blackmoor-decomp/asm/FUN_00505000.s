# FUN_00505000
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00505000
# extent:       0x00505000-0x00505020 (32 code bytes)
# span:         0x00505000-0x00505020 (code 32, tables 0, padding 0)
# sha256:       42556f54a409e9172cbc05d927f5fb91545e880c9b56f9d5e96d3a44ac945140
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00505000
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8, stk_c
# callees:      calls FUN_00505020
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00505020, .text + (0x00505020 - 0x401000)

.org 0x00505000 - 0x401000
.globl FUN_00505000
FUN_00505000:
    # block 0x00505000: entry, 3 instruction(s), ends with je to 0x0050501f (forward)
    mov eax, dword ptr [esp + stk_4]             # 00505000
    cmp eax, 0x1                                 # 00505004
    je.d8 L_0050501f                             # 00505007
    # block 0x00505009: entered by fall-through of je at 0x00505007, 8 instruction(s), calls FUN_00505020, falls into the block at 0x0050501f
    mov ecx, dword ptr [esp + stk_c]             # 00505009
    mov edx, dword ptr [esp + stk_8]             # 0050500d
    push ecx                                     # 00505011
    lea ecx, [edx + 4*eax]                       # 00505012
    push ecx                                     # 00505015
    push eax                                     # 00505016
    call FUN_00505020                            # 00505017
    add esp, 0xc                                 # 0050501c
L_0050501f:
    # block 0x0050501f: entered by je at 0x00505007, 1 instruction(s), ends with ret
    ret                                          # 0050501f

