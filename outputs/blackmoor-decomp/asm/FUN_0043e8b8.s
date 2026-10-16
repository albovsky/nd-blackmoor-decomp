# FUN_0043e8b8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043e8b8
# extent:       0x0043e8b8-0x0043e96c (180 code bytes)
# span:         0x0043e8b8-0x0043e96c (code 180, tables 0, padding 0)
# sha256:       b0a380ec6ece9b7b206a9087121c75ca5fd6360992938f532a08230a8e268e5d
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043e8b8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x0043e8b8 - 0x401000
.globl FUN_0043e8b8
FUN_0043e8b8:
    # block 0x0043e8b8: entry, 7 instruction(s), ends with forward jump to 0x0043e8de
    push ebp                                     # 0043e8b8
    {load} mov ebp, esp                          # 0043e8b9
    sub esp, 0xc                                 # 0043e8bb
    mov dword ptr [ebp - local_8], 0x0           # 0043e8be
    mov dword ptr [ebp - local_c], 0xffffffff    # 0043e8c5
    mov dword ptr [ebp - local_4], 0x0           # 0043e8cc
    jmp.d8 L_0043e8de                            # 0043e8d3
L_0043e8d5:
    # block 0x0043e8d5: entered by jmp at 0x0043e91f, 3 instruction(s), falls into the block at 0x0043e8de
    mov eax, dword ptr [ebp - local_4]           # 0043e8d5
    add eax, 0x1                                 # 0043e8d8
    mov dword ptr [ebp - local_4], eax           # 0043e8db
L_0043e8de:
    # block 0x0043e8de: entered by jmp at 0x0043e8d3, 3 instruction(s), ends with jge to 0x0043e921 (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0043e8de
    cmp dword ptr [ebp - local_4], ecx           # 0043e8e5
    jge.d8 L_0043e921                            # 0043e8e8
    # block 0x0043e8ea: entered by fall-through of jge at 0x0043e8e8, 4 instruction(s), ends with je to 0x0043e911 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0043e8ea
    imul edx, edx, 0x8d                          # 0043e8ed
    cmp dword ptr [edx + 0x5bb638], 0x0          # 0043e8f3
    je.d8 L_0043e911                             # 0043e8fa
    # block 0x0043e8fc: entered by fall-through of je at 0x0043e8fa, 2 instruction(s), ends with jne to 0x0043e90f (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0043e8fc
    jne.d8 L_0043e90f                            # 0043e900
    # block 0x0043e902: entered by fall-through of jne at 0x0043e900, 3 instruction(s), falls into the block at 0x0043e90f
    mov dword ptr [ebp - local_8], 0x1           # 0043e902
    mov eax, dword ptr [ebp - local_4]           # 0043e909
    mov dword ptr [ebp - local_c], eax           # 0043e90c
L_0043e90f:
    # block 0x0043e90f: entered by jne at 0x0043e900, 1 instruction(s), ends with forward jump to 0x0043e91f
    jmp.d8 L_0043e91f                            # 0043e90f
L_0043e911:
    # block 0x0043e911: entered by je at 0x0043e8fa, 2 instruction(s), falls into the block at 0x0043e91f
    mov dword ptr [ebp - local_8], 0x0           # 0043e911
    mov dword ptr [ebp - local_c], 0xffffffff    # 0043e918
L_0043e91f:
    # block 0x0043e91f: entered by jmp at 0x0043e90f, 1 instruction(s), ends with backward jump to 0x0043e8d5
    jmp.d8 L_0043e8d5                            # 0043e91f
L_0043e921:
    # block 0x0043e921: entered by jge at 0x0043e8e8, 2 instruction(s), ends with je to 0x0043e968 (forward)
    cmp dword ptr [ebp - local_c], -0x1          # 0043e921
    je.d8 L_0043e968                             # 0043e925
    # block 0x0043e927: entered by fall-through of je at 0x0043e925, 3 instruction(s), ends with je to 0x0043e95d (forward)
    movsx ecx, word ptr [0x63a4cd]               # 0043e927
    test ecx, ecx                                # 0043e92e
    je.d8 L_0043e95d                             # 0043e930
    # block 0x0043e932: entered by fall-through of je at 0x0043e930, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0043e95d
    mov edx, dword ptr [ebp - local_c]           # 0043e932
    push edx                                     # 0043e935
    movsx eax, word ptr [0x5c39e3]               # 0043e936
    push eax                                     # 0043e93d
    push 0x54769c                                # 0043e93e
    push 0x63888b                                # 0043e943
    call FUN_0050ca3e                            # 0043e948
    add esp, 0x10                                # 0043e94d
    push 0x63888b                                # 0043e950
    call FUN_0044a2b7                            # 0043e955
    add esp, 0x4                                 # 0043e95a
L_0043e95d:
    # block 0x0043e95d: entered by je at 0x0043e930, 2 instruction(s), falls into the block at 0x0043e968
    mov cx, word ptr [ebp - local_c]             # 0043e95d
    mov word ptr [0x5c39e3], cx                  # 0043e961
L_0043e968:
    # block 0x0043e968: entered by je at 0x0043e925, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0043e968
    pop ebp                                      # 0043e96a
    ret                                          # 0043e96b

