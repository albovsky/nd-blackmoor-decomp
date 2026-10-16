# FUN_00522ac8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522ac8
# extent:       0x00522ac8-0x00522af2 (42 code bytes)
# span:         0x00522ac8-0x00522af2 (code 42, tables 0, padding 0)
# sha256:       0818794f3999b21dabe5b87f9b32fc9ee56ffcebcac1b0f38cdbeccc0bcb8d80
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522ac8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_50
# callees:      calls FUN_0051c174, USER32.dll!SetCursor, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c174, .text + (0x0051c174 - 0x401000)

.org 0x00522ac8 - 0x401000
.globl FUN_00522ac8
FUN_00522ac8:
    # block 0x00522ac8: entry, 5 instruction(s), calls FUN_0051c174, ends with je to 0x00522ae7 (forward)
    push esi                                     # 00522ac8
    {load} mov esi, ecx                          # 00522ac9
    call FUN_0051c174                            # 00522acb
    cmp dword ptr [eax + field_50], 0x0          # 00522ad0
    je.d8 L_00522ae7                             # 00522ad4
    # block 0x00522ad6: entered by fall-through of je at 0x00522ad4, 5 instruction(s), calls USER32.dll!SetCursor, ends with forward jump to 0x00522aee
    push dword ptr [0x63c78c]                    # 00522ad6
    call dword ptr [0x52a474]                    # 00522adc
    push 0x1                                     # 00522ae2
    pop eax                                      # 00522ae4
    jmp.d8 L_00522aee                            # 00522ae5
L_00522ae7:
    # block 0x00522ae7: entered by je at 0x00522ad4, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x00522aee
    {load} mov ecx, esi                          # 00522ae7
    call FUN_0051ab4b                            # 00522ae9
L_00522aee:
    # block 0x00522aee: entered by jmp at 0x00522ae5, 2 instruction(s), ends with ret 0xc
    pop esi                                      # 00522aee
    ret 0xc                                      # 00522aef

