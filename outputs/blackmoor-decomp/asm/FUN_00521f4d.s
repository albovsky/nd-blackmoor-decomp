# FUN_00521f4d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521f4d
# extent:       0x00521f4d-0x00521fa5 (88 code bytes)
# span:         0x00521f4d-0x00521fa5 (code 88, tables 0, padding 0)
# sha256:       97ee51254e762c8d7a0551c7d9add75adbb5a7cd5b35460cc6b56a0626d3a929
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521f4d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_3c, field_40, field_41, field_50, field_58, field_78, field_7c, field_80, field_84; [esp + n] stk_c, stk_1c
# callees:      calls FUN_0050f920, FUN_0051e36f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_41, 0x41  # offset +0x41
.equ field_50, 0x50  # offset +0x50
.equ field_58, 0x58  # offset +0x58
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_80, 0x80  # offset +0x80
.equ field_84, 0x84  # offset +0x84

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0051e36f, .text + (0x0051e36f - 0x401000)

.org 0x00521f4d - 0x401000
.globl FUN_00521f4d
FUN_00521f4d:
    # block 0x00521f4d: entry, 20 instruction(s), calls FUN_0050f920, FUN_0051e36f, ends with je to 0x00521f99 (forward)
    push esi                                     # 00521f4d
    {load} mov esi, ecx                          # 00521f4e
    push edi                                     # 00521f50
    push 0x28                                    # 00521f51
    lea edi, [esi + field_3c]                    # 00521f53
    push 0x0                                     # 00521f56
    push edi                                     # 00521f58
    call FUN_0050f920                            # 00521f59
    mov eax, dword ptr [esi + field_78]          # 00521f5e
    and dword ptr [esi + field_84], 0x0          # 00521f61
    mov dword ptr [esi + field_50], eax          # 00521f68
    mov eax, dword ptr [esp + stk_1c]            # 00521f6b
    add esp, 0xc                                 # 00521f6f
    mov dword ptr [edi], 0x28                    # 00521f72
    mov dword ptr [esi + field_40], 0x8          # 00521f78
    mov dword ptr [esi + field_58], eax          # 00521f7f
    mov dword ptr [esi + field_80], 0x1          # 00521f82
    call FUN_0051e36f                            # 00521f8c
    test eax, eax                                # 00521f91
    je.d8 L_00521f99                             # 00521f93
    # block 0x00521f95: entered by fall-through of je at 0x00521f93, 1 instruction(s), falls into the block at 0x00521f99
    or byte ptr [esi + field_41], 0x2            # 00521f95
L_00521f99:
    # block 0x00521f99: entered by je at 0x00521f93, 5 instruction(s), ends with ret 0x8
    mov eax, dword ptr [esp + stk_c]             # 00521f99
    pop edi                                      # 00521f9d
    mov dword ptr [esi + field_7c], eax          # 00521f9e
    pop esi                                      # 00521fa1
    ret 0x8                                      # 00521fa2

