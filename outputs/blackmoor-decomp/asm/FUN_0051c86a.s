# FUN_0051c86a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c86a
# extent:       0x0051c86a-0x0051c8ce (100 code bytes)
# span:         0x0051c86a-0x0051c8ce (code 100, tables 0, padding 0)
# sha256:       5f7ae5dfd4d06f3332d24d1218837f897aa07e4d022218a9db097a43fed8117f
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c86a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_1c
# callees:      calls FUN_0051d526, FUN_0050c193, USER32.dll!SendMessageA, FUN_0051ab4b; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050c193, .text + (0x0050c193 - 0x401000)
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)

.org 0x0051c86a - 0x401000
.globl FUN_0051c86a
FUN_0051c86a:
    # block 0x0051c86a: entry, 7 instruction(s), calls FUN_0051d526, ends with jne to 0x0051c8c1 (forward)
    push ebx                                     # 0051c86a
    push esi                                     # 0051c86b
    push edi                                     # 0051c86c
    {load} mov ebx, ecx                          # 0051c86d
    call FUN_0051d526                            # 0051c86f
    test eax, 0x40000000                         # 0051c874
    jne.d8 L_0051c8c1                            # 0051c879
    # block 0x0051c87b: entered by fall-through of jne at 0x0051c879, 4 instruction(s), calls FUN_0050c193, ends with je to 0x0051c8c1 (forward)
    call FUN_0050c193                            # 0051c87b
    {load} mov esi, eax                          # 0051c880
    test esi, esi                                # 0051c882
    je.d8 L_0051c8c1                             # 0051c884
    # block 0x0051c886: entered by fall-through of je at 0x0051c884, 5 instruction(s), calls indirect edi, ends with jl to 0x0051c8c1 (forward)
    mov edi, dword ptr [0x52a4b8]                # 0051c886
    push 0x10                                    # 0051c88c
    call edi                                     # 0051c88e
    test ax, ax                                  # 0051c890
    jl.d8 L_0051c8c1                             # 0051c893
    # block 0x0051c895: entered by fall-through of jl at 0x0051c893, 4 instruction(s), calls indirect edi, ends with jl to 0x0051c8c1 (forward)
    push 0x11                                    # 0051c895
    call edi                                     # 0051c897
    test ax, ax                                  # 0051c899
    jl.d8 L_0051c8c1                             # 0051c89c
    # block 0x0051c89e: entered by fall-through of jl at 0x0051c89c, 4 instruction(s), calls indirect edi, ends with jl to 0x0051c8c1 (forward)
    push 0x12                                    # 0051c89e
    call edi                                     # 0051c8a0
    test ax, ax                                  # 0051c8a2
    jl.d8 L_0051c8c1                             # 0051c8a5
    # block 0x0051c8a7: entered by fall-through of jl at 0x0051c8a5, 8 instruction(s), calls USER32.dll!SendMessageA, ends with forward jump to 0x0051c8c8
    push 0x0                                     # 0051c8a7
    push 0xe146                                  # 0051c8a9
    push 0x111                                   # 0051c8ae
    push dword ptr [esi + field_1c]              # 0051c8b3
    call dword ptr [0x52a4c8]                    # 0051c8b6
    push 0x1                                     # 0051c8bc
    pop eax                                      # 0051c8be
    jmp.d8 L_0051c8c8                            # 0051c8bf
L_0051c8c1:
    # block 0x0051c8c1: entered by jne at 0x0051c879; je at 0x0051c884; jl at 0x0051c893; jl at 0x0051c89c; jl at 0x0051c8a5, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0051c8c8
    {load} mov ecx, ebx                          # 0051c8c1
    call FUN_0051ab4b                            # 0051c8c3
L_0051c8c8:
    # block 0x0051c8c8: entered by jmp at 0x0051c8bf, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 0051c8c8
    pop esi                                      # 0051c8c9
    pop ebx                                      # 0051c8ca
    ret 0x4                                      # 0051c8cb

