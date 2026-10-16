# FUN_0051da29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051da29
# extent:       0x0051da29-0x0051dab9 (144 code bytes)
# span:         0x0051da29-0x0051dab9 (code 144, tables 0, padding 0)
# sha256:       87bab155031456b4a8b51c7734dcc464fffe2d095def6ed65665e647ec65def9
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051da29
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c; [ecx + n] field_1c; [edi + n] field_1c; [esi + n] field_8, field_c, field_10, field_14, field_18; [esp + n] stk_8, stk_c
# callees:      calls USER32.dll!EnableMenuItem, USER32.dll!GetFocus, USER32.dll!GetParent, FUN_0051abe4, USER32.dll!GetNextDlgTabItem, FUN_0051d699, FUN_0051d672
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 48 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051d672, .text + (0x0051d672 - 0x401000)
.set FUN_0051d699, .text + (0x0051d699 - 0x401000)

.org 0x0051da29 - 0x401000
.globl FUN_0051da29
FUN_0051da29:
    # block 0x0051da29: entry, 5 instruction(s), ends with je to 0x0051da59 (forward)
    push esi                                     # 0051da29
    {load} mov esi, ecx                          # 0051da2a
    mov eax, dword ptr [esi + field_c]           # 0051da2c
    test eax, eax                                # 0051da2f
    je.d8 L_0051da59                             # 0051da31
    # block 0x0051da33: entered by fall-through of je at 0x0051da31, 2 instruction(s), ends with jne to 0x0051dab5 (forward)
    cmp dword ptr [esi + field_10], 0x0          # 0051da33
    jne.d8 L_0051dab5                            # 0051da37
    # block 0x0051da39: entered by fall-through of jne at 0x0051da37, 11 instruction(s), calls USER32.dll!EnableMenuItem, ends with forward jump to 0x0051daae
    mov ecx, dword ptr [esp + stk_8]             # 0051da39
    neg ecx                                      # 0051da3d
    {load} sbb ecx, ecx                          # 0051da3f
    and ecx, -0x3                                # 0051da41
    add ecx, 0x3                                 # 0051da44
    or ch, 0x4                                   # 0051da47
    push ecx                                     # 0051da4a
    push dword ptr [esi + field_8]               # 0051da4b
    push dword ptr [eax + field_4]               # 0051da4e
    call dword ptr [0x52a338]                    # 0051da51
    jmp.d8 L_0051daae                            # 0051da57
L_0051da59:
    # block 0x0051da59: entered by je at 0x0051da31, 3 instruction(s), ends with jne to 0x0051daa1 (forward)
    cmp dword ptr [esp + stk_8], 0x0             # 0051da59
    push edi                                     # 0051da5e
    jne.d8 L_0051daa1                            # 0051da5f
    # block 0x0051da61: entered by fall-through of jne at 0x0051da5f, 4 instruction(s), calls USER32.dll!GetFocus, ends with jne to 0x0051daa1 (forward)
    mov edi, dword ptr [esi + field_14]          # 0051da61
    call dword ptr [0x52a308]                    # 0051da64
    cmp eax, dword ptr [edi + field_1c]          # 0051da6a
    jne.d8 L_0051daa1                            # 0051da6d
    # block 0x0051da6f: entered by fall-through of jne at 0x0051da6d, 7 instruction(s), calls USER32.dll!GetParent, FUN_0051abe4, ends with je to 0x0051da88 (forward)
    push dword ptr [edi + field_1c]              # 0051da6f
    call dword ptr [0x52a3dc]                    # 0051da72
    push eax                                     # 0051da78
    call FUN_0051abe4                            # 0051da79
    mov ecx, dword ptr [esi + field_14]          # 0051da7e
    test ecx, ecx                                # 0051da81
    je.d8 L_0051da88                             # 0051da83
    # block 0x0051da85: entered by fall-through of je at 0x0051da83, 1 instruction(s), falls into the block at 0x0051da88
    mov ecx, dword ptr [ecx + field_1c]          # 0051da85
L_0051da88:
    # block 0x0051da88: entered by je at 0x0051da83, 8 instruction(s), calls USER32.dll!GetNextDlgTabItem, FUN_0051abe4, FUN_0051d699, falls into the block at 0x0051daa1
    push 0x0                                     # 0051da88
    push ecx                                     # 0051da8a
    push dword ptr [eax + field_1c]              # 0051da8b
    call dword ptr [0x52a334]                    # 0051da8e
    push eax                                     # 0051da94
    call FUN_0051abe4                            # 0051da95
    {load} mov ecx, eax                          # 0051da9a
    call FUN_0051d699                            # 0051da9c
L_0051daa1:
    # block 0x0051daa1: entered by jne at 0x0051da5f; jne at 0x0051da6d, 4 instruction(s), calls FUN_0051d672, falls into the block at 0x0051daae
    push dword ptr [esp + stk_c]                 # 0051daa1
    mov ecx, dword ptr [esi + field_14]          # 0051daa5
    call FUN_0051d672                            # 0051daa8
    pop edi                                      # 0051daad
L_0051daae:
    # block 0x0051daae: entered by jmp at 0x0051da57, 1 instruction(s), falls into the block at 0x0051dab5
    mov dword ptr [esi + field_18], 0x1          # 0051daae
L_0051dab5:
    # block 0x0051dab5: entered by jne at 0x0051da37, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 0051dab5
    ret 0x4                                      # 0051dab6

