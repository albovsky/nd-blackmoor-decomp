# FUN_0051c4ec
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c4ec
# extent:       0x0051c4ec-0x0051c519 (45 code bytes)
# span:         0x0051c4ec-0x0051c519 (code 45, tables 0, padding 0)
# sha256:       7354214db73f5cd1b12f2870d970f4b1bd2363dbb7b3831f5b59306d89548867
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c4ec
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_38, field_3c, field_40; [edx + n] field_a8; [esp + n] stk_8
# callees:      calls FUN_00525b0f; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_a8, 0xa8  # offset +0xa8

# --- external targets -----------------------------------------------
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051c4ec - 0x401000
.globl FUN_0051c4ec
FUN_0051c4ec:
    # block 0x0051c4ec: entry, 14 instruction(s), calls FUN_00525b0f, indirect dword ptr [edx + 0xa8], ends with ret 0x4
    push esi                                     # 0051c4ec
    {load} mov esi, ecx                          # 0051c4ed
    push 0x52496c                                # 0051c4ef
    mov ecx, 0x63c444                            # 0051c4f4
    call FUN_00525b0f                            # 0051c4f9
    push dword ptr [esp + stk_8]                 # 0051c4fe
    mov edx, dword ptr [esi]                     # 0051c502
    {load} mov ecx, esi                          # 0051c504
    push dword ptr [eax + field_40]              # 0051c506
    push dword ptr [eax + field_3c]              # 0051c509
    push dword ptr [eax + field_38]              # 0051c50c
    call dword ptr [edx + field_a8]              # 0051c50f
    pop esi                                      # 0051c515
    ret 0x4                                      # 0051c516

