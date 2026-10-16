# FUN_00520a2c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520a2c
# extent:       0x00520a2c-0x00520a40 (20 code bytes)
# span:         0x00520a2c-0x00520a40 (code 20, tables 0, padding 0)
# sha256:       3df0a2413f8cba3e91daf8769eabd8226e401d6ecf46e5d4fc2949949a3352cf
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520a2c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00520a2c - 0x401000
.globl FUN_00520a2c
FUN_00520a2c:
    # block 0x00520a2c: entry, 7 instruction(s), ends with ret
    {load} mov eax, ecx                          # 00520a2c
    {load} xor ecx, ecx                          # 00520a2e
    mov dword ptr [eax], 0x52fc80                # 00520a30
    mov dword ptr [eax + field_4], ecx           # 00520a36
    mov dword ptr [eax + field_8], ecx           # 00520a39
    mov dword ptr [eax + field_c], ecx           # 00520a3c
    ret                                          # 00520a3f

