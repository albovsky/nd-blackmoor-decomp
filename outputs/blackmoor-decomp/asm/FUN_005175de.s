# FUN_005175de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005175de
# extent:       0x005175de-0x0051765a (124 code bytes)
# span:         0x005175de-0x0051765a (code 124, tables 0, padding 0)
# sha256:       8759f12955dc1b4da9db1e145792d31b71bd0ef983bead537a91d680eac4f9b9
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005175de
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_14
# callees:      calls KERNEL32.dll!SetStdHandle, FUN_0050ea7e, FUN_0050ea87
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_0050ea87, .text + (0x0050ea87 - 0x401000)

.org 0x005175de - 0x401000
.globl FUN_005175de
FUN_005175de:
    # block 0x005175de: entry, 5 instruction(s), ends with jae to 0x00517641 (forward)
    mov ecx, dword ptr [esp + stk_4]             # 005175de
    push esi                                     # 005175e2
    cmp ecx, dword ptr [0x63cee0]                # 005175e3
    push edi                                     # 005175e9
    jae.d8 L_00517641                            # 005175ea
    # block 0x005175ec: entered by fall-through of jae at 0x005175ea, 10 instruction(s), ends with jne to 0x00517641 (forward)
    {load} mov eax, ecx                          # 005175ec
    sar eax, 0x5                                 # 005175ee
    lea edi, [4*eax + 0x63cde0]                  # 005175f1
    {load} mov eax, ecx                          # 005175f8
    and eax, 0x1f                                # 005175fa
    lea esi, [eax + 8*eax]                       # 005175fd
    mov eax, dword ptr [edi]                     # 00517600
    shl esi, 0x2                                 # 00517602
    cmp dword ptr [eax + esi], -0x1              # 00517605
    jne.d8 L_00517641                            # 00517609
    # block 0x0051760b: entered by fall-through of jne at 0x00517609, 4 instruction(s), ends with jne to 0x00517637 (forward)
    cmp dword ptr [0x567e80], 0x1                # 0051760b
    push ebx                                     # 00517612
    mov ebx, dword ptr [esp + stk_14]            # 00517613
    jne.d8 L_00517637                            # 00517617
    # block 0x00517619: entered by fall-through of jne at 0x00517617, 2 instruction(s), ends with je to 0x0051762e (forward)
    sub ecx, 0x0                                 # 00517619
    je.d8 L_0051762e                             # 0051761c
    # block 0x0051761e: entered by fall-through of je at 0x0051761c, 2 instruction(s), ends with je to 0x00517629 (forward)
    dec ecx                                      # 0051761e
    je.d8 L_00517629                             # 0051761f
    # block 0x00517621: entered by fall-through of je at 0x0051761f, 2 instruction(s), ends with jne to 0x00517637 (forward)
    dec ecx                                      # 00517621
    jne.d8 L_00517637                            # 00517622
    # block 0x00517624: entered by fall-through of jne at 0x00517622, 3 instruction(s), ends with forward jump to 0x00517631
    push ebx                                     # 00517624
    push -0xc                                    # 00517625
    jmp.d8 L_00517631                            # 00517627
L_00517629:
    # block 0x00517629: entered by je at 0x0051761f, 3 instruction(s), ends with forward jump to 0x00517631
    push ebx                                     # 00517629
    push -0xb                                    # 0051762a
    jmp.d8 L_00517631                            # 0051762c
L_0051762e:
    # block 0x0051762e: entered by je at 0x0051761c, 2 instruction(s), falls into the block at 0x00517631
    push ebx                                     # 0051762e
    push -0xa                                    # 0051762f
L_00517631:
    # block 0x00517631: entered by jmp at 0x00517627; jmp at 0x0051762c, 1 instruction(s), calls KERNEL32.dll!SetStdHandle, falls into the block at 0x00517637
    call dword ptr [0x52a1bc]                    # 00517631
L_00517637:
    # block 0x00517637: entered by jne at 0x00517617; jne at 0x00517622, 5 instruction(s), ends with forward jump to 0x00517657
    mov eax, dword ptr [edi]                     # 00517637
    mov dword ptr [eax + esi], ebx               # 00517639
    {load} xor eax, eax                          # 0051763c
    pop ebx                                      # 0051763e
    jmp.d8 L_00517657                            # 0051763f
L_00517641:
    # block 0x00517641: entered by jae at 0x005175ea; jne at 0x00517609, 5 instruction(s), calls FUN_0050ea7e, FUN_0050ea87, falls into the block at 0x00517657
    call FUN_0050ea7e                            # 00517641
    mov dword ptr [eax], 0x9                     # 00517646
    call FUN_0050ea87                            # 0051764c
    and dword ptr [eax], 0x0                     # 00517651
    or eax, -0x1                                 # 00517654
L_00517657:
    # block 0x00517657: entered by jmp at 0x0051763f, 3 instruction(s), ends with ret
    pop edi                                      # 00517657
    pop esi                                      # 00517658
    ret                                          # 00517659

