# FUN_0050e97e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e97e
# extent:       0x0050e97e-0x0050ea0b (141 code bytes)
# span:         0x0050e97e-0x0050ea0b (code 141, tables 0, padding 0)
# sha256:       583ae13966613f0e6a067f086da001b71b778ebe80ef708b03d9cc18ece2c9f7
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e97e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c, stk_14
# callees:      calls FUN_00512c18, FUN_005152b9, FUN_00512c79, KERNEL32.dll!HeapAlloc, FUN_00515a64, FUN_0050f920
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_005152b9, .text + (0x005152b9 - 0x401000)
.set FUN_00515a64, .text + (0x00515a64 - 0x401000)

.org 0x0050e97e - 0x401000
.globl FUN_0050e97e
FUN_0050e97e:
    # block 0x0050e97e: entry, 8 instruction(s), ends with ja to 0x0050e99e (forward)
    push ebx                                     # 0050e97e
    push esi                                     # 0050e97f
    mov esi, dword ptr [esp + stk_c]             # 0050e980
    push edi                                     # 0050e984
    imul esi, dword ptr [esp + stk_14]           # 0050e985
    cmp esi, -0x20                               # 0050e98a
    {load} mov ebx, esi                          # 0050e98d
    ja.d8 L_0050e99e                             # 0050e98f
    # block 0x0050e991: entered by fall-through of ja at 0x0050e98f, 2 instruction(s), ends with jne to 0x0050e998 (forward)
    test esi, esi                                # 0050e991
    jne.d8 L_0050e998                            # 0050e993
    # block 0x0050e995: entered by fall-through of jne at 0x0050e993, 2 instruction(s), falls into the block at 0x0050e998
    push 0x1                                     # 0050e995
    pop esi                                      # 0050e997
L_0050e998:
    # block 0x0050e998: entered by jne at 0x0050e993, 2 instruction(s), falls into the block at 0x0050e99e
    add esi, 0xf                                 # 0050e998
    and esi, -0x10                               # 0050e99b
L_0050e99e:
    # block 0x0050e99e: entered by ja at 0x0050e98f; jmp at 0x0050e9f3, 3 instruction(s), ends with ja to 0x0050e9df (forward)
    {load} xor edi, edi                          # 0050e99e
    cmp esi, -0x20                               # 0050e9a0
    ja.d8 L_0050e9df                             # 0050e9a3
    # block 0x0050e9a5: entered by fall-through of ja at 0x0050e9a3, 2 instruction(s), ends with ja to 0x0050e9ca (forward)
    cmp ebx, dword ptr [0x568b78]                # 0050e9a5
    ja.d8 L_0050e9ca                             # 0050e9ab
    # block 0x0050e9ad: entered by fall-through of ja at 0x0050e9ab, 10 instruction(s), calls FUN_00512c18, FUN_005152b9, FUN_00512c79, ends with jne to 0x0050e9f5 (forward)
    push 0x9                                     # 0050e9ad
    call FUN_00512c18                            # 0050e9af
    push ebx                                     # 0050e9b4
    call FUN_005152b9                            # 0050e9b5
    push 0x9                                     # 0050e9ba
    {load} mov edi, eax                          # 0050e9bc
    call FUN_00512c79                            # 0050e9be
    add esp, 0xc                                 # 0050e9c3
    test edi, edi                                # 0050e9c6
    jne.d8 L_0050e9f5                            # 0050e9c8
L_0050e9ca:
    # block 0x0050e9ca: entered by ja at 0x0050e9ab; fall-through of jne at 0x0050e9c8, 7 instruction(s), calls KERNEL32.dll!HeapAlloc, ends with jne to 0x0050ea01 (forward)
    push esi                                     # 0050e9ca
    push 0x8                                     # 0050e9cb
    push dword ptr [0x63cdd8]                    # 0050e9cd
    call dword ptr [0x52a150]                    # 0050e9d3
    {load} mov edi, eax                          # 0050e9d9
    test edi, edi                                # 0050e9db
    jne.d8 L_0050ea01                            # 0050e9dd
L_0050e9df:
    # block 0x0050e9df: entered by ja at 0x0050e9a3; fall-through of jne at 0x0050e9dd, 2 instruction(s), ends with je to 0x0050ea01 (forward)
    cmp dword ptr [0x63cc4c], 0x0                # 0050e9df
    je.d8 L_0050ea01                             # 0050e9e6
    # block 0x0050e9e8: entered by fall-through of je at 0x0050e9e6, 5 instruction(s), calls FUN_00515a64, ends with je to 0x0050ea07 (forward)
    push esi                                     # 0050e9e8
    call FUN_00515a64                            # 0050e9e9
    test eax, eax                                # 0050e9ee
    pop ecx                                      # 0050e9f0
    je.d8 L_0050ea07                             # 0050e9f1
    # block 0x0050e9f3: entered by fall-through of je at 0x0050e9f1, 1 instruction(s), ends with backward jump to 0x0050e99e
    jmp.d8 L_0050e99e                            # 0050e9f3
L_0050e9f5:
    # block 0x0050e9f5: entered by jne at 0x0050e9c8, 5 instruction(s), calls FUN_0050f920, falls into the block at 0x0050ea01
    push ebx                                     # 0050e9f5
    push 0x0                                     # 0050e9f6
    push edi                                     # 0050e9f8
    call FUN_0050f920                            # 0050e9f9
    add esp, 0xc                                 # 0050e9fe
L_0050ea01:
    # block 0x0050ea01: entered by jne at 0x0050e9dd; je at 0x0050e9e6, 1 instruction(s), falls into the block at 0x0050ea03
    {load} mov eax, edi                          # 0050ea01
L_0050ea03:
    # block 0x0050ea03: entered by jmp at 0x0050ea09, 4 instruction(s), ends with ret
    pop edi                                      # 0050ea03
    pop esi                                      # 0050ea04
    pop ebx                                      # 0050ea05
    ret                                          # 0050ea06
L_0050ea07:
    # block 0x0050ea07: entered by je at 0x0050e9f1, 2 instruction(s), ends with backward jump to 0x0050ea03
    {load} xor eax, eax                          # 0050ea07
    jmp.d8 L_0050ea03                            # 0050ea09

