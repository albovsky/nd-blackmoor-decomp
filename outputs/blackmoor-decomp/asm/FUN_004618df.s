# FUN_004618df
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004618df
# extent:       0x004618df-0x00461903 (36 code bytes)
# span:         0x004618df-0x00461903 (code 36, tables 0, padding 0)
# sha256:       f2f66622d9d8ce1b263c4fa502a9f04b4523cad20c8f49be8c4ea0c5b84dc1f8
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         cpz_grid_reset
# naming:       native port src/action_family_d3_runtime.c:cpz_grid_reset (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with cpz_grid_reset (flag byte 0x594db3 := 0, then 0x280 dwords from 0x594db5 := 0). The grid lives in a CpzWorld struct, so the unused byte at 0x594db4 is not modelled; 0x5bb1ca untouched; no NULL check.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d3_runtime.c:cpz_grid_reset (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004618df - 0x401000
.globl FUN_004618df
FUN_004618df:
    # block 0x004618df: entry, 14 instruction(s), ends with ret
    push ebp                                     # 004618df
    {load} mov ebp, esp                          # 004618e0
    push ecx                                     # 004618e2
    push edi                                     # 004618e3
    mov dword ptr [ebp - local_4], ecx           # 004618e4
    mov word ptr [0x594db3], 0x0                 # 004618e7
    mov ecx, 0x280                               # 004618f0
    {load} xor eax, eax                          # 004618f5
    mov edi, 0x594db5                            # 004618f7
    rep stosd dword ptr es:[edi], eax            # 004618fc
    pop edi                                      # 004618fe
    {load} mov esp, ebp                          # 004618ff
    pop ebp                                      # 00461901
    ret                                          # 00461902

