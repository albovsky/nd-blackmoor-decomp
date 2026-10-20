# FUN_0051da03
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051da03
# extent:       0x0051da03-0x0051da29 (38 code bytes)
# span:         0x0051da03-0x0051da29 (code 38, tables 0, padding 0)
# sha256:       dab941505842dfb98b05d03fe27a1037625ec48754fa38ecb40803ee7d0c454a
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         CCmdUI::CCmdUI
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c, field_20, field_24
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x0051da03 - 0x401000
.globl FUN_0051da03
FUN_0051da03:
    # block 0x0051da03: entry, 13 instruction(s), ends with ret
    {load} mov eax, ecx                          # 0051da03
    {load} xor ecx, ecx                          # 0051da05
    mov dword ptr [eax], 0x52ed38                # 0051da07
    mov dword ptr [eax + field_20], ecx          # 0051da0d
    mov dword ptr [eax + field_8], ecx           # 0051da10
    mov dword ptr [eax + field_4], ecx           # 0051da13
    mov dword ptr [eax + field_24], ecx          # 0051da16
    mov dword ptr [eax + field_10], ecx          # 0051da19
    mov dword ptr [eax + field_c], ecx           # 0051da1c
    mov dword ptr [eax + field_14], ecx          # 0051da1f
    mov dword ptr [eax + field_1c], ecx          # 0051da22
    mov dword ptr [eax + field_18], ecx          # 0051da25
    ret                                          # 0051da28

