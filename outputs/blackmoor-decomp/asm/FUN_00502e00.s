# FUN_00502e00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00502e00
# extent:       0x00502e00-0x00502e1b (27 code bytes)
# span:         0x00502e00-0x00502e20 (code 27, tables 0, padding 5)
# sha256:       a4e602ee02cbe394020c97bb2a7996417bc15e49c6f0ccae174f78da44e612cd
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00502da0 (+0x60)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00502e00
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_minus_1; [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00502e00 - 0x401000
.globl FUN_00502e00
FUN_00502e00:
    # block 0x00502e00: entry, 11 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 00502e00
    mov edx, dword ptr [esp + stk_8]             # 00502e04
    mov ecx, dword ptr [eax]                     # 00502e08
    mov eax, dword ptr [edx]                     # 00502e0a
    mov ecx, dword ptr [ecx]                     # 00502e0c
    mov edx, dword ptr [eax]                     # 00502e0e
    {load} cmp edx, ecx                          # 00502e10
    {load} sbb edx, edx                          # 00502e12
    neg edx                                      # 00502e14
    lea eax, [edx + edx - field_minus_1]         # 00502e16
    ret                                          # 00502e1a

# --- data items (not part of the function) -------------------------
.org 0x00502e1b - 0x401000
PAD_00502e1b:  # 5 byte(s) of nop padding
    .fill 5, 1, 0x90

