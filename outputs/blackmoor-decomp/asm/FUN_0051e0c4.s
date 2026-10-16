# FUN_0051e0c4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e0c4
# extent:       0x0051e0c4-0x0051e0fe (58 code bytes)
# span:         0x0051e0c4-0x0051e0fe (code 58, tables 0, padding 0)
# sha256:       c24f2b496e5aa5b5f959434c778ba88aee97ad8c18c958213e920e18b8afc15e
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e0c4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c; [esi + n] field_50, field_54
# callees:      calls FUN_00525371, FUN_00521287, FUN_0052142d, FUN_0051b097
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54

# --- external targets -----------------------------------------------
.set FUN_0051b097, .text + (0x0051b097 - 0x401000)
.set FUN_00521287, .text + (0x00521287 - 0x401000)
.set FUN_0052142d, .text + (0x0052142d - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051e0c4 - 0x401000
.globl FUN_0051e0c4
FUN_0051e0c4:
    # block 0x0051e0c4: entry, 7 instruction(s), calls FUN_00525371, ends with je to 0x0051e0dd (forward)
    push esi                                     # 0051e0c4
    push edi                                     # 0051e0c5
    {load} mov esi, ecx                          # 0051e0c6
    call FUN_00525371                            # 0051e0c8
    mov eax, dword ptr [eax + field_4]           # 0051e0cd
    test eax, eax                                # 0051e0d0
    je.d8 L_0051e0dd                             # 0051e0d2
    # block 0x0051e0d4: entered by fall-through of je at 0x0051e0d2, 3 instruction(s), calls FUN_00521287, falls into the block at 0x0051e0dd
    push 0x0                                     # 0051e0d4
    {load} mov ecx, eax                          # 0051e0d6
    call FUN_00521287                            # 0051e0d8
L_0051e0dd:
    # block 0x0051e0dd: entered by je at 0x0051e0d2, 3 instruction(s), ends with je to 0x0051e0e7 (forward)
    mov eax, dword ptr [esi + field_50]          # 0051e0dd
    test eax, eax                                # 0051e0e0
    je.d8 L_0051e0e7                             # 0051e0e2
    # block 0x0051e0e4: entered by fall-through of je at 0x0051e0e2, 1 instruction(s), falls into the block at 0x0051e0e7
    mov eax, dword ptr [eax + field_1c]          # 0051e0e4
L_0051e0e7:
    # block 0x0051e0e7: entered by je at 0x0051e0e2, 11 instruction(s), calls FUN_0052142d, FUN_0051b097, ends with ret
    lea ecx, [esi + field_54]                    # 0051e0e7
    push ecx                                     # 0051e0ea
    push eax                                     # 0051e0eb
    call FUN_0052142d                            # 0051e0ec
    push esi                                     # 0051e0f1
    {load} mov edi, eax                          # 0051e0f2
    call FUN_0051b097                            # 0051e0f4
    {load} mov eax, edi                          # 0051e0f9
    pop edi                                      # 0051e0fb
    pop esi                                      # 0051e0fc
    ret                                          # 0051e0fd

