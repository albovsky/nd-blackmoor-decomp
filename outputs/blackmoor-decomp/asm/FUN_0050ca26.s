# FUN_0050ca26
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ca26
# extent:       0x0050ca26-0x0050ca3e (24 code bytes)
# span:         0x0050ca26-0x0050ca3e (code 24, tables 0, padding 0)
# sha256:       9b234eb12406cca066a2a4bf894cedcff6ff8f97f2e3eeb7efbae25d8d9dc703
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ca26
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8; [ebx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0050ca26 - 0x401000
.globl FUN_0050ca26
FUN_0050ca26:
    # block 0x0050ca26: entry, 10 instruction(s), ends with ret 0x4
    push ebx                                     # 0050ca26
    push ecx                                     # 0050ca27
    mov ebx, 0x567e10                            # 0050ca28
    mov ecx, dword ptr [ebp + field_8]           # 0050ca2d
    mov dword ptr [ebx + field_8], ecx           # 0050ca30
    mov dword ptr [ebx + field_4], eax           # 0050ca33
    mov dword ptr [ebx + field_c], ebp           # 0050ca36
    pop ecx                                      # 0050ca39
    pop ebx                                      # 0050ca3a
    ret 0x4                                      # 0050ca3b

