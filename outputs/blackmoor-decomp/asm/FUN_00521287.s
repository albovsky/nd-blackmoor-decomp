# FUN_00521287
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521287
# extent:       0x00521287-0x005212b5 (46 code bytes)
# span:         0x00521287-0x005212b5 (code 46, tables 0, padding 0)
# sha256:       13cc475e962198278513f1b4b04c9c7c461773d6469e4e0cb1312c762b6acaa4
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521287
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_64, field_b0; [esi + n] field_68; [esp + n] stk_8
# callees:      calls FUN_0050c193; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_b0, 0xb0  # offset +0xb0

# --- external targets -----------------------------------------------
.set FUN_0050c193, .text + (0x0050c193 - 0x401000)

.org 0x00521287 - 0x401000
.globl FUN_00521287
FUN_00521287:
    # block 0x00521287: entry, 5 instruction(s), calls FUN_0050c193, ends with je to 0x005212b1 (forward)
    push esi                                     # 00521287
    call FUN_0050c193                            # 00521288
    {load} mov esi, eax                          # 0052128d
    test esi, esi                                # 0052128f
    je.d8 L_005212b1                             # 00521291
    # block 0x00521293: entered by fall-through of je at 0x00521291, 5 instruction(s), calls indirect dword ptr [eax + 0xb0], ends with je to 0x005212b1 (forward)
    mov eax, dword ptr [esi]                     # 00521293
    {load} mov ecx, esi                          # 00521295
    call dword ptr [eax + field_b0]              # 00521297
    test eax, eax                                # 0052129d
    je.d8 L_005212b1                             # 0052129f
    # block 0x005212a1: entered by fall-through of je at 0x0052129f, 3 instruction(s), ends with je to 0x005212b1 (forward)
    mov ecx, dword ptr [esi + field_68]          # 005212a1
    test ecx, ecx                                # 005212a4
    je.d8 L_005212b1                             # 005212a6
    # block 0x005212a8: entered by fall-through of je at 0x005212a6, 3 instruction(s), calls indirect dword ptr [eax + 0x64], falls into the block at 0x005212b1
    mov eax, dword ptr [ecx]                     # 005212a8
    push dword ptr [esp + stk_8]                 # 005212aa
    call dword ptr [eax + field_64]              # 005212ae
L_005212b1:
    # block 0x005212b1: entered by je at 0x00521291; je at 0x0052129f; je at 0x005212a6, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 005212b1
    ret 0x4                                      # 005212b2

