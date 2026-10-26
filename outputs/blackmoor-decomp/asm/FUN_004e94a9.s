# FUN_004e94a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e94a9
# extent:       0x004e94a9-0x004e94c1 (24 code bytes)
# span:         0x004e94a9-0x004e94c1 (code 24, tables 0, padding 0)
# sha256:       2cf8102f8c2ffa25dd2993f3e67f4c2f01298eda0dfde180fbfcd00b99554184
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e94a9_lifted
# naming:       native port src/original_methods_fl41.c:m4e94a9_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 1 seeds; oracle: 11/11 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_7011
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4e94a9_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_7011, 0x7011  # offset +0x7011

# --- external targets -----------------------------------------------

.org 0x004e94a9 - 0x401000
.globl FUN_004e94a9
FUN_004e94a9:
    # block 0x004e94a9: entry, 11 instruction(s), ends with ret
    push ebp                                     # 004e94a9
    {load} mov ebp, esp                          # 004e94aa
    push ecx                                     # 004e94ac
    mov dword ptr [ebp - local_4], ecx           # 004e94ad
    mov eax, dword ptr [ebp - local_4]           # 004e94b0
    {load} xor ecx, ecx                          # 004e94b3
    mov cl, byte ptr [eax + field_7011]          # 004e94b5
    {load} mov eax, ecx                          # 004e94bb
    {load} mov esp, ebp                          # 004e94bd
    pop ebp                                      # 004e94bf
    ret                                          # 004e94c0

