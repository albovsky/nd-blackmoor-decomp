# FUN_00522a20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522a20
# extent:       0x00522a20-0x00522a3c (28 code bytes)
# span:         0x00522a20-0x00522a3c (code 28, tables 0, padding 0)
# sha256:       98df795b9f2568695d35e28a36a4c9ab34b9fd34090cf4a183ba1377bf55d2ad
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522a20
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_6c; [esi + n] field_68; [esp + n] stk_4
# callees:      calls FUN_0051ab4b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x00522a20 - 0x401000
.globl FUN_00522a20
FUN_00522a20:
    # block 0x00522a20: entry, 7 instruction(s), calls FUN_0051ab4b, ends with je to 0x00522a39 (forward)
    push esi                                     # 00522a20
    {load} mov esi, ecx                          # 00522a21
    call FUN_0051ab4b                            # 00522a23
    mov ecx, dword ptr [esi + field_68]          # 00522a28
    pop esi                                      # 00522a2b
    test ecx, ecx                                # 00522a2c
    je.d8 L_00522a39                             # 00522a2e
    # block 0x00522a30: entered by fall-through of je at 0x00522a2e, 3 instruction(s), calls indirect dword ptr [eax + 0x6c], falls into the block at 0x00522a39
    mov eax, dword ptr [ecx]                     # 00522a30
    push dword ptr [esp + stk_4]                 # 00522a32
    call dword ptr [eax + field_6c]              # 00522a36
L_00522a39:
    # block 0x00522a39: entered by je at 0x00522a2e, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 00522a39

