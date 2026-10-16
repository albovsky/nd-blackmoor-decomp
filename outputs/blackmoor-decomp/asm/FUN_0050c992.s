# FUN_0050c992
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c992
# extent:       0x0050c992-0x0050c9fa (104 code bytes)
# span:         0x0050c992-0x0050c9fa (code 104, tables 0, padding 0)
# sha256:       d7f0f4a1f6800c568d718c9ea8e83e0f9e6cc840a2f89328154703b61fade08d
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c992
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_c; [ebx + n] field_4, field_8; [esp + n] stk_8, stk_10, stk_20, stk_24
# callees:      calls FUN_0050ca26; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_0050ca26, .text + (0x0050ca26 - 0x401000)

.org 0x0050c992 - 0x401000
.globl FUN_0050c992
FUN_0050c992:
    # block 0x0050c992: entry, 9 instruction(s), falls into the block at 0x0050c9af
    push ebx                                     # 0050c992
    push esi                                     # 0050c993
    push edi                                     # 0050c994
    mov eax, dword ptr [esp + stk_10]            # 0050c995
    push eax                                     # 0050c999
    push -0x2                                    # 0050c99a
    push 0x50c970                                # 0050c99c
    push dword ptr fs:[0x0]                      # 0050c9a1
    mov dword ptr fs:[0x0], esp                  # 0050c9a8
L_0050c9af:
    # block 0x0050c9af: entered by jmp at 0x0050c9ea, 5 instruction(s), ends with je to 0x0050c9ec (forward)
    mov eax, dword ptr [esp + stk_20]            # 0050c9af
    mov ebx, dword ptr [eax + field_8]           # 0050c9b3
    mov esi, dword ptr [eax + field_c]           # 0050c9b6
    cmp esi, -0x1                                # 0050c9b9
    je.d8 L_0050c9ec                             # 0050c9bc
    # block 0x0050c9be: entered by fall-through of je at 0x0050c9bc, 2 instruction(s), ends with je to 0x0050c9ec (forward)
    cmp esi, dword ptr [esp + stk_24]            # 0050c9be
    je.d8 L_0050c9ec                             # 0050c9c2
    # block 0x0050c9c4: entered by fall-through of je at 0x0050c9c2, 6 instruction(s), ends with jne to 0x0050c9ea (forward)
    lea esi, [esi + 2*esi]                       # 0050c9c4
    mov ecx, dword ptr [ebx + 4*esi]             # 0050c9c7
    mov dword ptr [esp + stk_8], ecx             # 0050c9ca
    mov dword ptr [eax + field_c], ecx           # 0050c9ce
    cmp dword ptr [ebx + 4*esi + field_4], 0x0   # 0050c9d1
    jne.d8 L_0050c9ea                            # 0050c9d6
    # block 0x0050c9d8: entered by fall-through of jne at 0x0050c9d6, 4 instruction(s), calls FUN_0050ca26, indirect dword ptr [ebx + 4*esi + 0x8], falls into the block at 0x0050c9ea
    push 0x101                                   # 0050c9d8
    mov eax, dword ptr [ebx + 4*esi + field_8]   # 0050c9dd
    call FUN_0050ca26                            # 0050c9e1
    call dword ptr [ebx + 4*esi + field_8]       # 0050c9e6
L_0050c9ea:
    # block 0x0050c9ea: entered by jne at 0x0050c9d6, 1 instruction(s), ends with backward jump to 0x0050c9af
    jmp.d8 L_0050c9af                            # 0050c9ea
L_0050c9ec:
    # block 0x0050c9ec: entered by je at 0x0050c9bc; je at 0x0050c9c2, 6 instruction(s), ends with ret
    pop dword ptr fs:[0x0]                       # 0050c9ec
    add esp, 0xc                                 # 0050c9f3
    pop edi                                      # 0050c9f6
    pop esi                                      # 0050c9f7
    pop ebx                                      # 0050c9f8
    ret                                          # 0050c9f9

