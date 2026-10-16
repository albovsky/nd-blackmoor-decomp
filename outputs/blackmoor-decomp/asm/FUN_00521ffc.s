# FUN_00521ffc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521ffc
# extent:       0x00521ffc-0x0052205d (97 code bytes)
# span:         0x00521ffc-0x0052205d (code 97, tables 0, padding 0)
# sha256:       2312582125d5bd30110f553c579dc18c23c6006895adf367620949ff3300515e
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521ffc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_1c; [esi + n] field_4, field_8; [esp + n] stk_8
# callees:      calls FUN_0051b4ac, USER32.dll!GetAsyncKeyState, USER32.dll!SendMessageA, FUN_0051ce42
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051b4ac, .text + (0x0051b4ac - 0x401000)
.set FUN_0051ce42, .text + (0x0051ce42 - 0x401000)

.org 0x00521ffc - 0x401000
.globl FUN_00521ffc
FUN_00521ffc:
    # block 0x00521ffc: entry, 8 instruction(s), calls FUN_0051b4ac, ends with jne to 0x0052204b (forward)
    push esi                                     # 00521ffc
    mov esi, dword ptr [esp + stk_8]             # 00521ffd
    push edi                                     # 00522001
    {load} mov edi, ecx                          # 00522002
    push esi                                     # 00522004
    call FUN_0051b4ac                            # 00522005
    test eax, eax                                # 0052200a
    jne.d8 L_0052204b                            # 0052200c
    # block 0x0052200e: entered by fall-through of jne at 0x0052200c, 2 instruction(s), ends with jne to 0x00522050 (forward)
    cmp dword ptr [esi + field_4], 0x100         # 0052200e
    jne.d8 L_00522050                            # 00522015
    # block 0x00522017: entered by fall-through of jne at 0x00522015, 4 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with jge to 0x00522050 (forward)
    push 0x11                                    # 00522017
    call dword ptr [0x52a4b4]                    # 00522019
    test ax, ax                                  # 0052201f
    jge.d8 L_00522050                            # 00522022
    # block 0x00522024: entered by fall-through of jge at 0x00522022, 3 instruction(s), ends with je to 0x00522036 (forward)
    mov eax, dword ptr [esi + field_8]           # 00522024
    cmp eax, 0x9                                 # 00522027
    je.d8 L_00522036                             # 0052202a
    # block 0x0052202c: entered by fall-through of je at 0x0052202a, 2 instruction(s), ends with je to 0x00522036 (forward)
    cmp eax, 0x21                                # 0052202c
    je.d8 L_00522036                             # 0052202f
    # block 0x00522031: entered by fall-through of je at 0x0052202f, 2 instruction(s), ends with jne to 0x00522050 (forward)
    cmp eax, 0x22                                # 00522031
    jne.d8 L_00522050                            # 00522034
L_00522036:
    # block 0x00522036: entered by je at 0x0052202a; je at 0x0052202f; fall-through of jne at 0x00522034, 7 instruction(s), calls USER32.dll!SendMessageA, ends with je to 0x00522050 (forward)
    push esi                                     # 00522036
    push 0x0                                     # 00522037
    push 0x475                                   # 00522039
    push dword ptr [edi + field_1c]              # 0052203e
    call dword ptr [0x52a4c8]                    # 00522041
    test eax, eax                                # 00522047
    je.d8 L_00522050                             # 00522049
L_0052204b:
    # block 0x0052204b: entered by jne at 0x0052200c; fall-through of je at 0x00522049, 3 instruction(s), ends with forward jump to 0x00522058
    push 0x1                                     # 0052204b
    pop eax                                      # 0052204d
    jmp.d8 L_00522058                            # 0052204e
L_00522050:
    # block 0x00522050: entered by jne at 0x00522015; jge at 0x00522022; jne at 0x00522034; je at 0x00522049, 3 instruction(s), calls FUN_0051ce42, falls into the block at 0x00522058
    push esi                                     # 00522050
    {load} mov ecx, edi                          # 00522051
    call FUN_0051ce42                            # 00522053
L_00522058:
    # block 0x00522058: entered by jmp at 0x0052204e, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 00522058
    pop esi                                      # 00522059
    ret 0x4                                      # 0052205a

