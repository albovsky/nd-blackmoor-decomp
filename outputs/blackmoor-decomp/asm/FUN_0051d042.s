# FUN_0051d042
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d042
# extent:       0x0051d042-0x0051d0b9 (119 code bytes)
# span:         0x0051d042-0x0051d0b9 (code 119, tables 0, padding 0)
# sha256:       577587e29832ffb27424a7d27dd19ef0bfbadad7ddf3159ed96aa517fee4a885
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d042
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10, stk_14
# callees:      calls KERNEL32.dll!GetModuleHandleA, KERNEL32.dll!LoadLibraryA, KERNEL32.dll!GetProcAddress, COMCTL32.dll!#17, KERNEL32.dll!FreeLibrary; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------

.org 0x0051d042 - 0x401000
.globl FUN_0051d042
FUN_0051d042:
    # block 0x0051d042: entry, 12 instruction(s), calls KERNEL32.dll!GetModuleHandleA, KERNEL32.dll!LoadLibraryA, ends with je to 0x0051d0b3 (forward)
    push ebx                                     # 0051d042
    push esi                                     # 0051d043
    mov esi, 0x52eb68                            # 0051d044
    push edi                                     # 0051d049
    push esi                                     # 0051d04a
    call dword ptr [0x52a248]                    # 0051d04b
    push esi                                     # 0051d051
    {load} mov edi, eax                          # 0051d052
    call dword ptr [0x52a210]                    # 0051d054
    {load} mov ebx, eax                          # 0051d05a
    test ebx, ebx                                # 0051d05c
    je.d8 L_0051d0b3                             # 0051d05e
    # block 0x0051d060: entered by fall-through of je at 0x0051d05e, 6 instruction(s), calls KERNEL32.dll!GetProcAddress, ends with jne to 0x0051d08d (forward)
    push 0x52eb50                                # 0051d060
    push ebx                                     # 0051d065
    {load} xor esi, esi                          # 0051d066
    call dword ptr [0x52a24c]                    # 0051d068
    test eax, eax                                # 0051d06e
    jne.d8 L_0051d08d                            # 0051d070
    # block 0x0051d072: entered by fall-through of jne at 0x0051d070, 5 instruction(s), ends with jne to 0x0051d0aa (forward)
    mov eax, dword ptr [esp + stk_14]            # 0051d072
    mov edi, 0x3fc0                              # 0051d076
    {load} and eax, edi                          # 0051d07b
    cmp eax, dword ptr [esp + stk_14]            # 0051d07d
    jne.d8 L_0051d0aa                            # 0051d081
    # block 0x0051d083: entered by fall-through of jne at 0x0051d081, 3 instruction(s), calls COMCTL32.dll!#17, ends with forward jump to 0x0051d0aa
    call dword ptr [0x52a020]                    # 0051d083
    {load} mov esi, edi                          # 0051d089
    jmp.d8 L_0051d0aa                            # 0051d08b
L_0051d08d:
    # block 0x0051d08d: entered by jne at 0x0051d070, 4 instruction(s), calls indirect eax, ends with je to 0x0051d0aa (forward)
    push dword ptr [esp + stk_10]                # 0051d08d
    call eax                                     # 0051d091
    test eax, eax                                # 0051d093
    je.d8 L_0051d0aa                             # 0051d095
    # block 0x0051d097: entered by fall-through of je at 0x0051d095, 3 instruction(s), ends with jne to 0x0051d0aa (forward)
    mov esi, dword ptr [esp + stk_14]            # 0051d097
    test edi, edi                                # 0051d09b
    jne.d8 L_0051d0aa                            # 0051d09d
    # block 0x0051d09f: entered by fall-through of jne at 0x0051d09d, 2 instruction(s), calls COMCTL32.dll!#17, falls into the block at 0x0051d0aa
    call dword ptr [0x52a020]                    # 0051d09f
    .insn 0x6681/1, esi, 16320{:s16}             # 0051d0a5
L_0051d0aa:
    # block 0x0051d0aa: entered by jne at 0x0051d081; jmp at 0x0051d08b; je at 0x0051d095; jne at 0x0051d09d, 3 instruction(s), calls KERNEL32.dll!FreeLibrary, falls into the block at 0x0051d0b3
    push ebx                                     # 0051d0aa
    call dword ptr [0x52a214]                    # 0051d0ab
    {load} mov eax, esi                          # 0051d0b1
L_0051d0b3:
    # block 0x0051d0b3: entered by je at 0x0051d05e, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 0051d0b3
    pop esi                                      # 0051d0b4
    pop ebx                                      # 0051d0b5
    ret 0x8                                      # 0051d0b6

