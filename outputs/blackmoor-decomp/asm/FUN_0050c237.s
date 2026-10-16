# FUN_0050c237
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c237
# extent:       0x0050c237-0x0050c261 (42 code bytes)
# span:         0x0050c237-0x0050c261 (code 42, tables 0, padding 0)
# sha256:       8cd1828338bbb52be9d883ad4333df983c2ba9ab1fac7769c58eae8fd57ea557
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c237
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_c, field_10, field_94; [esp + n] stk_8, stk_c
# callees:      calls FUN_0051f62a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_94, 0x94  # offset +0x94

# --- external targets -----------------------------------------------
.set FUN_0051f62a, .text + (0x0051f62a - 0x401000)

.org 0x0050c237 - 0x401000
.globl FUN_0050c237
FUN_0050c237:
    # block 0x0050c237: entry, 12 instruction(s), calls FUN_0051f62a, ends with ret 0x8
    push esi                                     # 0050c237
    {load} mov esi, ecx                          # 0050c238
    push dword ptr [esp + stk_8]                 # 0050c23a
    call FUN_0051f62a                            # 0050c23e
    mov eax, dword ptr [esp + stk_c]             # 0050c243
    and dword ptr [esi + field_c], 0x0           # 0050c247
    and dword ptr [esi + field_10], 0x0          # 0050c24b
    mov dword ptr [esi + field_94], eax          # 0050c24f
    mov dword ptr [esi], 0x52fda8                # 0050c255
    {load} mov eax, esi                          # 0050c25b
    pop esi                                      # 0050c25d
    ret 0x8                                      # 0050c25e

