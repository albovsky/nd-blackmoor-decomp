# FUN_0044551b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044551b
# extent:       0x0044551b-0x004455b8 (157 code bytes)
# span:         0x0044551b-0x004455b8 (code 157, tables 0, padding 0)
# sha256:       e9a3f6e6726c21d9d6281fc8d6ca017a26fa6ee333a02ba4d57121f21bf2ef8d
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044551b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       13 ebp-relative slot(s): local_5, local_6, local_8, local_c, local_10, local_14, local_16, local_18, local_1a, local_1c, local_3e, local_1ce and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043f210, FUN_0041fd08
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 45 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_5, 0x5  # offset -0x5
.equ local_6, 0x6  # offset -0x6
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_16, 0x16  # offset -0x16
.equ local_18, 0x18  # offset -0x18
.equ local_1a, 0x1a  # offset -0x1a
.equ local_1c, 0x1c  # offset -0x1c
.equ local_3e, 0x3e  # offset -0x3e
.equ local_1ce, 0x1ce  # offset -0x1ce
.equ local_1d4, 0x1d4  # offset -0x1d4

# --- external targets -----------------------------------------------
.set FUN_0041fd08, .text + (0x0041fd08 - 0x401000)
.set FUN_0043f210, .text + (0x0043f210 - 0x401000)

.org 0x0044551b - 0x401000
.globl FUN_0044551b
FUN_0044551b:
    # block 0x0044551b: entry, 45 instruction(s), calls FUN_0043f210, FUN_0041fd08, ends with ret
    push ebp                                     # 0044551b
    {load} mov ebp, esp                          # 0044551c
    sub esp, 0x1d4                               # 0044551e
    push esi                                     # 00445524
    push edi                                     # 00445525
    push 0x5481a8                                # 00445526
    push 0x63a828                                # 0044552b
    lea eax, [ebp - local_1ce]                   # 00445530
    push eax                                     # 00445536
    call FUN_0043f210                            # 00445537
    add esp, 0xc                                 # 0044553c
    mov edi, 0x5481b0                            # 0044553f
    lea edx, [ebp - local_3e]                    # 00445544
    or ecx, -0x1                                 # 00445547
    {load} xor eax, eax                          # 0044554a
    repne scasb al, byte ptr es:[edi]            # 0044554c
    not ecx                                      # 0044554e
    {load} sub edi, ecx                          # 00445550
    {load} mov esi, edi                          # 00445552
    {load} mov eax, ecx                          # 00445554
    {load} mov edi, edx                          # 00445556
    shr ecx, 0x2                                 # 00445558
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044555b
    {load} mov ecx, eax                          # 0044555d
    and ecx, 0x3                                 # 0044555f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00445562
    mov dword ptr [ebp - local_14], 0x0          # 00445564
    mov dword ptr [ebp - local_10], 0x0          # 0044556b
    mov dword ptr [ebp - local_c], 0x1           # 00445572
    mov word ptr [ebp - local_1c], 0x5d2         # 00445579
    mov word ptr [ebp - local_1a], 0x0           # 0044557f
    mov word ptr [ebp - local_18], 0x0           # 00445585
    mov word ptr [ebp - local_16], 0x1           # 0044558b
    mov word ptr [ebp - local_8], 0xffff         # 00445591
    mov byte ptr [ebp - local_6], 0x0            # 00445597
    mov word ptr [ebp - local_5], 0x2            # 0044559b
    lea ecx, [ebp - local_1d4]                   # 004455a1
    push ecx                                     # 004455a7
    mov ecx, 0x6177e8                            # 004455a8
    call FUN_0041fd08                            # 004455ad
    pop edi                                      # 004455b2
    pop esi                                      # 004455b3
    {load} mov esp, ebp                          # 004455b4
    pop ebp                                      # 004455b6
    ret                                          # 004455b7

