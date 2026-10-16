# FUN_00521a56
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521a56
# extent:       0x00521a56-0x00521a86 (48 code bytes)
# span:         0x00521a56-0x00521a86 (code 48, tables 0, padding 0)
# sha256:       4f38c242f01ee95c60af25c331e7bd3498d68ea61611e0097ecae419faa03239
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521a56
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1038; [edx + n] field_10; [esi + n] field_58; [esp + n] stk_8
# callees:      calls FUN_00521942, FUN_0050ea90, FUN_00525371; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_58, 0x58  # offset +0x58
.equ field_1038, 0x1038  # offset +0x1038

# --- external targets -----------------------------------------------
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_00521942, .text + (0x00521942 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00521a56 - 0x401000
.globl FUN_00521a56
FUN_00521a56:
    # block 0x00521a56: entry, 16 instruction(s), calls FUN_00521942, FUN_0050ea90, FUN_00525371, indirect dword ptr [edx + 0x10], ends with ret 0x4
    push esi                                     # 00521a56
    {load} mov esi, ecx                          # 00521a57
    call FUN_00521942                            # 00521a59
    push 0x8                                     # 00521a5e
    call FUN_0050ea90                            # 00521a60
    pop ecx                                      # 00521a65
    mov dword ptr [esi + field_58], eax          # 00521a66
    call FUN_00525371                            # 00521a69
    mov eax, dword ptr [eax + field_1038]        # 00521a6e
    push dword ptr [esp + stk_8]                 # 00521a74
    {load} mov ecx, eax                          # 00521a78
    mov edx, dword ptr [eax]                     # 00521a7a
    push dword ptr [esi + field_58]              # 00521a7c
    call dword ptr [edx + field_10]              # 00521a7f
    pop esi                                      # 00521a82
    ret 0x4                                      # 00521a83

