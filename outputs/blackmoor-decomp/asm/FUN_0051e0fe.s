# FUN_0051e0fe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e0fe
# extent:       0x0051e0fe-0x0051e140 (66 code bytes)
# span:         0x0051e0fe-0x0051e140 (code 66, tables 0, padding 0)
# sha256:       86b699ffdec8d4320b1ece89ecbeacd4bf6cd5b0d02b58784abb7574321308fd
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e0fe
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esi + n] field_54
# callees:      calls FUN_0051b0e3, FUN_0051ac62, USER32.dll!IsWindow, USER32.dll!EnableWindow, FUN_00525371, FUN_00521287
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_54, 0x54  # offset +0x54

# --- external targets -----------------------------------------------
.set FUN_0051ac62, .text + (0x0051ac62 - 0x401000)
.set FUN_0051b0e3, .text + (0x0051b0e3 - 0x401000)
.set FUN_00521287, .text + (0x00521287 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051e0fe - 0x401000
.globl FUN_0051e0fe
FUN_0051e0fe:
    # block 0x0051e0fe: entry, 9 instruction(s), calls FUN_0051b0e3, FUN_0051ac62, USER32.dll!IsWindow, ends with je to 0x0051e125 (forward)
    push esi                                     # 0051e0fe
    {load} mov esi, ecx                          # 0051e0ff
    call FUN_0051b0e3                            # 0051e101
    {load} mov ecx, esi                          # 0051e106
    call FUN_0051ac62                            # 0051e108
    push dword ptr [esi + field_54]              # 0051e10d
    call dword ptr [0x52a300]                    # 0051e110
    test eax, eax                                # 0051e116
    je.d8 L_0051e125                             # 0051e118
    # block 0x0051e11a: entered by fall-through of je at 0x0051e118, 3 instruction(s), calls USER32.dll!EnableWindow, falls into the block at 0x0051e125
    push 0x1                                     # 0051e11a
    push dword ptr [esi + field_54]              # 0051e11c
    call dword ptr [0x52a4d0]                    # 0051e11f
L_0051e125:
    # block 0x0051e125: entered by je at 0x0051e118, 6 instruction(s), calls FUN_00525371, ends with je to 0x0051e13f (forward)
    and dword ptr [esi + field_54], 0x0          # 0051e125
    call FUN_00525371                            # 0051e129
    mov eax, dword ptr [eax + field_4]           # 0051e12e
    pop esi                                      # 0051e131
    test eax, eax                                # 0051e132
    je.d8 L_0051e13f                             # 0051e134
    # block 0x0051e136: entered by fall-through of je at 0x0051e134, 3 instruction(s), calls FUN_00521287, falls into the block at 0x0051e13f
    push 0x1                                     # 0051e136
    {load} mov ecx, eax                          # 0051e138
    call FUN_00521287                            # 0051e13a
L_0051e13f:
    # block 0x0051e13f: entered by je at 0x0051e134, 1 instruction(s), ends with ret
    ret                                          # 0051e13f

