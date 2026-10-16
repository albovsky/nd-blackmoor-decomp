# FUN_00522e1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522e1a
# extent:       0x00522e1a-0x00522ed0 (182 code bytes)
# span:         0x00522e1a-0x00522ed0 (code 182, tables 0, padding 0)
# sha256:       378d81d0f3e14cb647a84e40738473b69ef996d395c45791a564f39118015363
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522e1a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_88, field_8c; [esi + n] field_1c, field_24, field_a0; [esp + n] stk_10
# callees:      calls FUN_0051d672, USER32.dll!SetFocus, USER32.dll!GetParent, FUN_0051abe4, USER32.dll!GetActiveWindow, FUN_00522ed0; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 68 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_a0, 0xa0  # offset +0xa0

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051d672, .text + (0x0051d672 - 0x401000)
.set FUN_00522ed0, .text + (0x00522ed0 - 0x401000)

.org 0x00522e1a - 0x401000
.globl FUN_00522e1a
FUN_00522e1a:
    # block 0x00522e1a: entry, 8 instruction(s), ends with je to 0x00522e41 (forward)
    push ebx                                     # 00522e1a
    push esi                                     # 00522e1b
    push edi                                     # 00522e1c
    mov edi, dword ptr [esp + stk_10]            # 00522e1d
    {load} xor ebx, ebx                          # 00522e21
    {load} mov esi, ecx                          # 00522e23
    {load} cmp edi, ebx                          # 00522e25
    je.d8 L_00522e41                             # 00522e27
    # block 0x00522e29: entered by fall-through of je at 0x00522e27, 2 instruction(s), ends with je to 0x00522e41 (forward)
    test byte ptr [esi + field_24], 0x4          # 00522e29
    je.d8 L_00522e41                             # 00522e2d
    # block 0x00522e2f: entered by fall-through of je at 0x00522e2d, 5 instruction(s), calls FUN_0051d672, USER32.dll!SetFocus, ends with forward jump to 0x00522eca
    push ebx                                     # 00522e2f
    call FUN_0051d672                            # 00522e30
    push ebx                                     # 00522e35
    call dword ptr [0x52a2fc]                    # 00522e36
    jmp.d32 L_00522eca                           # 00522e3c
L_00522e41:
    # block 0x00522e41: entered by je at 0x00522e27; je at 0x00522e2d, 6 instruction(s), calls USER32.dll!GetParent, FUN_0051abe4, ends with jne to 0x00522eca (forward)
    push dword ptr [esi + field_1c]              # 00522e41
    call dword ptr [0x52a3dc]                    # 00522e44
    push eax                                     # 00522e4a
    call FUN_0051abe4                            # 00522e4b
    test eax, eax                                # 00522e50
    jne.d8 L_00522eca                            # 00522e52
    # block 0x00522e54: entered by fall-through of jne at 0x00522e52, 2 instruction(s), ends with jne to 0x00522e70 (forward)
    {load} cmp edi, ebx                          # 00522e54
    jne.d8 L_00522e70                            # 00522e56
    # block 0x00522e58: entered by fall-through of jne at 0x00522e56, 2 instruction(s), ends with jne to 0x00522eb8 (forward)
    cmp dword ptr [esi + field_a0], ebx          # 00522e58
    jne.d8 L_00522eb8                            # 00522e5e
    # block 0x00522e60: entered by fall-through of jne at 0x00522e5e, 5 instruction(s), calls indirect dword ptr [eax + 0x88], ends with forward jump to 0x00522eb8
    mov eax, dword ptr [esi]                     # 00522e60
    or byte ptr [esi + field_24], -0x80          # 00522e62
    {load} mov ecx, esi                          # 00522e66
    call dword ptr [eax + field_88]              # 00522e68
    jmp.d8 L_00522eb8                            # 00522e6e
L_00522e70:
    # block 0x00522e70: entered by jne at 0x00522e56, 5 instruction(s), ends with je to 0x00522ea3 (forward)
    mov eax, dword ptr [esi + field_24]          # 00522e70
    mov ebx, dword ptr [0x52a4c8]                # 00522e73
    test al, -0x80                               # 00522e79
    push ebp                                     # 00522e7b
    je.d8 L_00522ea3                             # 00522e7c
    # block 0x00522e7e: entered by fall-through of je at 0x00522e7c, 9 instruction(s), calls indirect dword ptr [eax + 0x8c], USER32.dll!GetActiveWindow, ends with jne to 0x00522ea3 (forward)
    and al, 0x7f                                 # 00522e7e
    {load} mov ecx, esi                          # 00522e80
    mov dword ptr [esi + field_24], eax          # 00522e82
    mov eax, dword ptr [esi]                     # 00522e85
    call dword ptr [eax + field_8c]              # 00522e87
    mov ebp, dword ptr [esi + field_1c]          # 00522e8d
    call dword ptr [0x52a354]                    # 00522e90
    {load} cmp eax, ebp                          # 00522e96
    jne.d8 L_00522ea3                            # 00522e98
    # block 0x00522e9a: entered by fall-through of jne at 0x00522e98, 5 instruction(s), calls indirect ebx, falls into the block at 0x00522ea3
    push 0x0                                     # 00522e9a
    push 0x1                                     # 00522e9c
    push 0x6                                     # 00522e9e
    push ebp                                     # 00522ea0
    call ebx                                     # 00522ea1
L_00522ea3:
    # block 0x00522ea3: entered by je at 0x00522e7c; jne at 0x00522e98, 3 instruction(s), ends with je to 0x00522eb8 (forward)
    test byte ptr [esi + field_24], 0x20         # 00522ea3
    pop ebp                                      # 00522ea7
    je.d8 L_00522eb8                             # 00522ea8
    # block 0x00522eaa: entered by fall-through of je at 0x00522ea8, 5 instruction(s), calls indirect ebx, falls into the block at 0x00522eb8
    push 0x0                                     # 00522eaa
    push 0x1                                     # 00522eac
    push 0x86                                    # 00522eae
    push dword ptr [esi + field_1c]              # 00522eb3
    call ebx                                     # 00522eb6
L_00522eb8:
    # block 0x00522eb8: entered by jne at 0x00522e5e; jmp at 0x00522e6e; je at 0x00522ea8, 7 instruction(s), calls FUN_00522ed0, falls into the block at 0x00522eca
    neg edi                                      # 00522eb8
    {load} sbb edi, edi                          # 00522eba
    {load} mov ecx, esi                          # 00522ebc
    and edi, -0x10                               # 00522ebe
    add edi, 0x20                                # 00522ec1
    push edi                                     # 00522ec4
    call FUN_00522ed0                            # 00522ec5
L_00522eca:
    # block 0x00522eca: entered by jmp at 0x00522e3c; jne at 0x00522e52, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 00522eca
    pop esi                                      # 00522ecb
    pop ebx                                      # 00522ecc
    ret 0x4                                      # 00522ecd

