# FUN_0050e699
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e699
# extent:       0x0050e699-0x0050e761 (200 code bytes)
# span:         0x0050e699-0x0050e761 (code 200, tables 0, padding 0)
# sha256:       d03b17886fa8b67e72be66c9279cd64f34c1d16075db9cd972e266c337576361
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e699
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       6 ebp-relative slot(s): local_114, local_120, local_12c, local_134, local_13c, local_140
# fields:       [esi + n] field_4, field_8, field_c, field_10
# callees:      calls KERNEL32.dll!FindNextFileA, KERNEL32.dll!GetLastError, FUN_0050ea7e, FUN_0050e781, FUN_005128b0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 62 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x0050e699 - 0x401000
.globl FUN_0050e699
FUN_0050e699:
    # block 0x0050e699: entry, 10 instruction(s), calls KERNEL32.dll!FindNextFileA, ends with jne to 0x0050e6f9 (forward)
    push ebp                                     # 0050e699
    {load} mov ebp, esp                          # 0050e69a
    sub esp, 0x140                               # 0050e69c
    lea eax, [ebp - local_140]                   # 0050e6a2
    push esi                                     # 0050e6a8
    push eax                                     # 0050e6a9
    push dword ptr [ebp + arg_8]                 # 0050e6aa
    call dword ptr [0x52a140]                    # 0050e6ad
    test eax, eax                                # 0050e6b3
    jne.d8 L_0050e6f9                            # 0050e6b5
    # block 0x0050e6b7: entered by fall-through of jne at 0x0050e6b5, 5 instruction(s), calls KERNEL32.dll!GetLastError, ends with jb to 0x0050e6d3 (forward)
    call dword ptr [0x52a2a4]                    # 0050e6b7
    push 0x2                                     # 0050e6bd
    pop esi                                      # 0050e6bf
    {load} cmp eax, esi                          # 0050e6c0
    jb.d8 L_0050e6d3                             # 0050e6c2
    # block 0x0050e6c4: entered by fall-through of jb at 0x0050e6c2, 2 instruction(s), ends with jbe to 0x0050e6f0 (forward)
    cmp eax, 0x3                                 # 0050e6c4
    jbe.d8 L_0050e6f0                            # 0050e6c7
    # block 0x0050e6c9: entered by fall-through of jbe at 0x0050e6c7, 2 instruction(s), ends with je to 0x0050e6e3 (forward)
    cmp eax, 0x8                                 # 0050e6c9
    je.d8 L_0050e6e3                             # 0050e6cc
    # block 0x0050e6ce: entered by fall-through of je at 0x0050e6cc, 2 instruction(s), ends with je to 0x0050e6f0 (forward)
    cmp eax, 0x12                                # 0050e6ce
    je.d8 L_0050e6f0                             # 0050e6d1
L_0050e6d3:
    # block 0x0050e6d3: entered by jb at 0x0050e6c2; fall-through of je at 0x0050e6d1, 2 instruction(s), calls FUN_0050ea7e, falls into the block at 0x0050e6de
    call FUN_0050ea7e                            # 0050e6d3
    mov dword ptr [eax], 0x16                    # 0050e6d8
L_0050e6de:
    # block 0x0050e6de: entered by jmp at 0x0050e6ee; jmp at 0x0050e6f7, 2 instruction(s), ends with forward jump to 0x0050e75e
    or eax, -0x1                                 # 0050e6de
    jmp.d8 L_0050e75e                            # 0050e6e1
L_0050e6e3:
    # block 0x0050e6e3: entered by je at 0x0050e6cc, 3 instruction(s), calls FUN_0050ea7e, ends with backward jump to 0x0050e6de
    call FUN_0050ea7e                            # 0050e6e3
    mov dword ptr [eax], 0xc                     # 0050e6e8
    jmp.d8 L_0050e6de                            # 0050e6ee
L_0050e6f0:
    # block 0x0050e6f0: entered by jbe at 0x0050e6c7; je at 0x0050e6d1, 3 instruction(s), calls FUN_0050ea7e, ends with backward jump to 0x0050e6de
    call FUN_0050ea7e                            # 0050e6f0
    mov dword ptr [eax], esi                     # 0050e6f5
    jmp.d8 L_0050e6de                            # 0050e6f7
L_0050e6f9:
    # block 0x0050e6f9: entered by jne at 0x0050e6b5, 28 instruction(s), calls FUN_0050e781, FUN_005128b0, falls into the block at 0x0050e75e
    mov eax, dword ptr [ebp - local_140]         # 0050e6f9
    mov esi, dword ptr [ebp + arg_c]             # 0050e6ff
    sub eax, 0x80                                # 0050e702
    neg eax                                      # 0050e707
    {load} sbb eax, eax                          # 0050e709
    and eax, dword ptr [ebp - local_140]         # 0050e70b
    mov dword ptr [esi], eax                     # 0050e711
    lea eax, [ebp - local_13c]                   # 0050e713
    push eax                                     # 0050e719
    call FUN_0050e781                            # 0050e71a
    mov dword ptr [esi + field_4], eax           # 0050e71f
    lea eax, [ebp - local_134]                   # 0050e722
    push eax                                     # 0050e728
    call FUN_0050e781                            # 0050e729
    mov dword ptr [esi + field_8], eax           # 0050e72e
    lea eax, [ebp - local_12c]                   # 0050e731
    push eax                                     # 0050e737
    call FUN_0050e781                            # 0050e738
    mov dword ptr [esi + field_c], eax           # 0050e73d
    mov eax, dword ptr [ebp - local_120]         # 0050e740
    mov dword ptr [esi + field_10], eax          # 0050e746
    lea eax, [ebp - local_114]                   # 0050e749
    add esi, 0x14                                # 0050e74f
    push eax                                     # 0050e752
    push esi                                     # 0050e753
    call FUN_005128b0                            # 0050e754
    add esp, 0x14                                # 0050e759
    {load} xor eax, eax                          # 0050e75c
L_0050e75e:
    # block 0x0050e75e: entered by jmp at 0x0050e6e1, 3 instruction(s), ends with ret
    pop esi                                      # 0050e75e
    leave                                        # 0050e75f
    ret                                          # 0050e760

