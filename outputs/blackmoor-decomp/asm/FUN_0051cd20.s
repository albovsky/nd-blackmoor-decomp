# FUN_0051cd20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051cd20
# extent:       0x0051cd20-0x0051cd70 (80 code bytes)
# span:         0x0051cd20-0x0051cd70 (code 80, tables 0, padding 0)
# sha256:       c98d48d89b7afe4d6dc34c192bd022019a538eb012ac880f80058a29a15596ff
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051cd20
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [esp + n] stk_10, stk_14
# callees:      calls FUN_00525371, KERNEL32.dll!FindResourceA, KERNEL32.dll!LoadResource, KERNEL32.dll!LockResource, FUN_0051cd70
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0051cd70, .text + (0x0051cd70 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051cd20 - 0x401000
.globl FUN_0051cd20
FUN_0051cd20:
    # block 0x0051cd20: entry, 7 instruction(s), ends with je to 0x0051cd62 (forward)
    push ebx                                     # 0051cd20
    push esi                                     # 0051cd21
    push edi                                     # 0051cd22
    {load} xor edi, edi                          # 0051cd23
    cmp dword ptr [esp + stk_10], edi            # 0051cd25
    {load} mov ebx, ecx                          # 0051cd29
    je.d8 L_0051cd62                             # 0051cd2b
    # block 0x0051cd2d: entered by fall-through of je at 0x0051cd2b, 8 instruction(s), calls FUN_00525371, KERNEL32.dll!FindResourceA, ends with je to 0x0051cd62 (forward)
    call FUN_00525371                            # 0051cd2d
    mov esi, dword ptr [eax + field_c]           # 0051cd32
    push 0xf0                                    # 0051cd35
    push dword ptr [esp + stk_14]                # 0051cd3a
    push esi                                     # 0051cd3e
    call dword ptr [0x52a218]                    # 0051cd3f
    {load} cmp eax, edi                          # 0051cd45
    je.d8 L_0051cd62                             # 0051cd47
    # block 0x0051cd49: entered by fall-through of je at 0x0051cd47, 5 instruction(s), calls KERNEL32.dll!LoadResource, ends with jne to 0x0051cd59 (forward)
    push eax                                     # 0051cd49
    push esi                                     # 0051cd4a
    call dword ptr [0x52a21c]                    # 0051cd4b
    {load} cmp eax, edi                          # 0051cd51
    jne.d8 L_0051cd59                            # 0051cd53
    # block 0x0051cd55: entered by fall-through of jne at 0x0051cd53, 2 instruction(s), ends with forward jump to 0x0051cd6a
    {load} xor eax, eax                          # 0051cd55
    jmp.d8 L_0051cd6a                            # 0051cd57
L_0051cd59:
    # block 0x0051cd59: entered by jne at 0x0051cd53, 3 instruction(s), calls KERNEL32.dll!LockResource, falls into the block at 0x0051cd62
    push eax                                     # 0051cd59
    call dword ptr [0x52a220]                    # 0051cd5a
    {load} mov edi, eax                          # 0051cd60
L_0051cd62:
    # block 0x0051cd62: entered by je at 0x0051cd2b; je at 0x0051cd47, 3 instruction(s), calls FUN_0051cd70, falls into the block at 0x0051cd6a
    push edi                                     # 0051cd62
    {load} mov ecx, ebx                          # 0051cd63
    call FUN_0051cd70                            # 0051cd65
L_0051cd6a:
    # block 0x0051cd6a: entered by jmp at 0x0051cd57, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 0051cd6a
    pop esi                                      # 0051cd6b
    pop ebx                                      # 0051cd6c
    ret 0x4                                      # 0051cd6d

