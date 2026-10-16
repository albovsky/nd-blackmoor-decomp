# FUN_0050e5cc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e5cc
# extent:       0x0050e5cc-0x0050e699 (205 code bytes)
# span:         0x0050e5cc-0x0050e699 (code 205, tables 0, padding 0)
# sha256:       00ae7e0839e56350834370a003bf8de4bdb5a3dc4557fdb5121d97f288fc4e92
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e5cc
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_114, local_120, local_12c, local_134, local_13c, local_140
# fields:       [esi + n] field_4, field_8, field_c, field_10
# callees:      calls KERNEL32.dll!FindFirstFileA, KERNEL32.dll!GetLastError, FUN_0050ea7e, FUN_0050e781, FUN_005128b0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 65 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_114, 0x114  # offset -0x114
.equ local_120, 0x120  # offset -0x120
.equ local_12c, 0x12c  # offset -0x12c
.equ local_134, 0x134  # offset -0x134
.equ local_13c, 0x13c  # offset -0x13c
.equ local_140, 0x140  # offset -0x140
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050e781, .text + (0x0050e781 - 0x401000)
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_005128b0, .text + (0x005128b0 - 0x401000)

.org 0x0050e5cc - 0x401000
.globl FUN_0050e5cc
FUN_0050e5cc:
    # block 0x0050e5cc: entry, 12 instruction(s), calls KERNEL32.dll!FindFirstFileA, ends with jne to 0x0050e630 (forward)
    push ebp                                     # 0050e5cc
    {load} mov ebp, esp                          # 0050e5cd
    sub esp, 0x140                               # 0050e5cf
    push esi                                     # 0050e5d5
    lea eax, [ebp - local_140]                   # 0050e5d6
    push edi                                     # 0050e5dc
    push eax                                     # 0050e5dd
    push dword ptr [ebp + arg_8]                 # 0050e5de
    call dword ptr [0x52a114]                    # 0050e5e1
    {load} mov edi, eax                          # 0050e5e7
    cmp edi, -0x1                                # 0050e5e9
    jne.d8 L_0050e630                            # 0050e5ec
    # block 0x0050e5ee: entered by fall-through of jne at 0x0050e5ec, 5 instruction(s), calls KERNEL32.dll!GetLastError, ends with jb to 0x0050e60a (forward)
    call dword ptr [0x52a2a4]                    # 0050e5ee
    push 0x2                                     # 0050e5f4
    pop esi                                      # 0050e5f6
    {load} cmp eax, esi                          # 0050e5f7
    jb.d8 L_0050e60a                             # 0050e5f9
    # block 0x0050e5fb: entered by fall-through of jb at 0x0050e5f9, 2 instruction(s), ends with jbe to 0x0050e627 (forward)
    cmp eax, 0x3                                 # 0050e5fb
    jbe.d8 L_0050e627                            # 0050e5fe
    # block 0x0050e600: entered by fall-through of jbe at 0x0050e5fe, 2 instruction(s), ends with je to 0x0050e61a (forward)
    cmp eax, 0x8                                 # 0050e600
    je.d8 L_0050e61a                             # 0050e603
    # block 0x0050e605: entered by fall-through of je at 0x0050e603, 2 instruction(s), ends with je to 0x0050e627 (forward)
    cmp eax, 0x12                                # 0050e605
    je.d8 L_0050e627                             # 0050e608
L_0050e60a:
    # block 0x0050e60a: entered by jb at 0x0050e5f9; fall-through of je at 0x0050e608, 2 instruction(s), calls FUN_0050ea7e, falls into the block at 0x0050e615
    call FUN_0050ea7e                            # 0050e60a
    mov dword ptr [eax], 0x16                    # 0050e60f
L_0050e615:
    # block 0x0050e615: entered by jmp at 0x0050e625; jmp at 0x0050e62e, 2 instruction(s), ends with forward jump to 0x0050e695
    or eax, -0x1                                 # 0050e615
    jmp.d8 L_0050e695                            # 0050e618
L_0050e61a:
    # block 0x0050e61a: entered by je at 0x0050e603, 3 instruction(s), calls FUN_0050ea7e, ends with backward jump to 0x0050e615
    call FUN_0050ea7e                            # 0050e61a
    mov dword ptr [eax], 0xc                     # 0050e61f
    jmp.d8 L_0050e615                            # 0050e625
L_0050e627:
    # block 0x0050e627: entered by jbe at 0x0050e5fe; je at 0x0050e608, 3 instruction(s), calls FUN_0050ea7e, ends with backward jump to 0x0050e615
    call FUN_0050ea7e                            # 0050e627
    mov dword ptr [eax], esi                     # 0050e62c
    jmp.d8 L_0050e615                            # 0050e62e
L_0050e630:
    # block 0x0050e630: entered by jne at 0x0050e5ec, 28 instruction(s), calls FUN_0050e781, FUN_005128b0, falls into the block at 0x0050e695
    mov eax, dword ptr [ebp - local_140]         # 0050e630
    mov esi, dword ptr [ebp + arg_c]             # 0050e636
    sub eax, 0x80                                # 0050e639
    neg eax                                      # 0050e63e
    {load} sbb eax, eax                          # 0050e640
    and eax, dword ptr [ebp - local_140]         # 0050e642
    mov dword ptr [esi], eax                     # 0050e648
    lea eax, [ebp - local_13c]                   # 0050e64a
    push eax                                     # 0050e650
    call FUN_0050e781                            # 0050e651
    mov dword ptr [esi + field_4], eax           # 0050e656
    lea eax, [ebp - local_134]                   # 0050e659
    push eax                                     # 0050e65f
    call FUN_0050e781                            # 0050e660
    mov dword ptr [esi + field_8], eax           # 0050e665
    lea eax, [ebp - local_12c]                   # 0050e668
    push eax                                     # 0050e66e
    call FUN_0050e781                            # 0050e66f
    mov dword ptr [esi + field_c], eax           # 0050e674
    mov eax, dword ptr [ebp - local_120]         # 0050e677
    mov dword ptr [esi + field_10], eax          # 0050e67d
    lea eax, [ebp - local_114]                   # 0050e680
    add esi, 0x14                                # 0050e686
    push eax                                     # 0050e689
    push esi                                     # 0050e68a
    call FUN_005128b0                            # 0050e68b
    add esp, 0x14                                # 0050e690
    {load} mov eax, edi                          # 0050e693
L_0050e695:
    # block 0x0050e695: entered by jmp at 0x0050e618, 4 instruction(s), ends with ret
    pop edi                                      # 0050e695
    pop esi                                      # 0050e696
    leave                                        # 0050e697
    ret                                          # 0050e698

