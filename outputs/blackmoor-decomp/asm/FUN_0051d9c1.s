# FUN_0051d9c1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d9c1
# extent:       0x0051d9c1-0x0051d9f3 (50 code bytes)
# span:         0x0051d9c1-0x0051d9f3 (code 50, tables 0, padding 0)
# sha256:       2a9ffaf32f86eeb2700bf249c7ac16aca490f8f79eb7e8ebadd7166c4d4cffdd
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d9c1
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_20
# callees:      calls FUN_00525ffa, FUN_005253ae, FUN_0052606a; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051d9f3
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_005253ae, .text + (0x005253ae - 0x401000)
.set FUN_00525ffa, .text + (0x00525ffa - 0x401000)
.set FUN_0052606a, .text + (0x0052606a - 0x401000)

.org 0x0051d9c1 - 0x401000
.globl FUN_0051d9c1
FUN_0051d9c1:
    # block 0x0051d9c1: entry, 9 instruction(s), calls FUN_00525ffa, indirect dword ptr [eax + 0x20], ends with je to 0x0051d9dd (forward)
    push esi                                     # 0051d9c1
    {load} mov esi, ecx                          # 0051d9c2
    push 0xd                                     # 0051d9c4
    call FUN_00525ffa                            # 0051d9c6
    mov eax, dword ptr [esi]                     # 0051d9cb
    {load} mov ecx, esi                          # 0051d9cd
    call dword ptr [eax + field_20]              # 0051d9cf
    test eax, eax                                # 0051d9d2
    je.d8 L_0051d9dd                             # 0051d9d4
    # block 0x0051d9d6: entered by fall-through of je at 0x0051d9d4, 2 instruction(s), calls FUN_005253ae, falls into the block at 0x0051d9dd
    {load} mov ecx, eax                          # 0051d9d6
    call FUN_005253ae                            # 0051d9d8
L_0051d9dd:
    # block 0x0051d9dd: entered by je at 0x0051d9d4, 4 instruction(s), calls FUN_0052606a, ends with je to 0x0051d9f1 (forward)
    push 0xd                                     # 0051d9dd
    call FUN_0052606a                            # 0051d9df
    test esi, esi                                # 0051d9e4
    je.d8 L_0051d9f1                             # 0051d9e6
    # block 0x0051d9e8: entered by fall-through of je at 0x0051d9e6, 4 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x0051d9f1
    mov eax, dword ptr [esi]                     # 0051d9e8
    push 0x1                                     # 0051d9ea
    {load} mov ecx, esi                          # 0051d9ec
    call dword ptr [eax + field_4]               # 0051d9ee
L_0051d9f1:
    # block 0x0051d9f1: entered by je at 0x0051d9e6, 2 instruction(s), ends with ret
    pop esi                                      # 0051d9f1
    ret                                          # 0051d9f2

