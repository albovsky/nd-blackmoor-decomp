# FUN_0051672d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051672d
# extent:       0x0051672d-0x00516796 (105 code bytes)
# span:         0x0051672d-0x005167a0 (code 105, tables 0, padding 10)
# sha256:       037cacdd9dc40d35dccd56734c2ef5a8bcdd13dc2b44d043846ba20bfe410f5e
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051672d
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!WideCharToMultiByte, FUN_0050ea7e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)

.org 0x0051672d - 0x401000
.globl FUN_0051672d
FUN_0051672d:
    # block 0x0051672d: entry, 5 instruction(s), ends with jne to 0x00516739 (forward)
    push ebp                                     # 0051672d
    {load} mov ebp, esp                          # 0051672e
    mov eax, dword ptr [ebp + arg_8]             # 00516730
    test eax, eax                                # 00516733
    jne.d8 L_00516739                            # 00516735
    # block 0x00516737: entered by fall-through of jne at 0x00516735, 2 instruction(s), ends with ret
    pop ebp                                      # 00516737
    ret                                          # 00516738
L_00516739:
    # block 0x00516739: entered by jne at 0x00516735, 2 instruction(s), ends with jne to 0x00516754 (forward)
    cmp dword ptr [0x63cb1c], 0x0                # 00516739
    jne.d8 L_00516754                            # 00516740
    # block 0x00516742: entered by fall-through of jne at 0x00516740, 3 instruction(s), ends with ja to 0x00516786 (forward)
    mov cx, word ptr [ebp + arg_c]               # 00516742
    .insn 0x6681/7, ecx, 255{:s16}               # 00516746
    ja.d8 L_00516786                             # 0051674b
    # block 0x0051674d: entered by fall-through of ja at 0x0051674b, 5 instruction(s), ends with ret
    push 0x1                                     # 0051674d
    mov byte ptr [eax], cl                       # 0051674f
    pop eax                                      # 00516751
    pop ebp                                      # 00516752
    ret                                          # 00516753
L_00516754:
    # block 0x00516754: entered by jne at 0x00516740, 14 instruction(s), calls KERNEL32.dll!WideCharToMultiByte, ends with je to 0x00516786 (forward)
    lea ecx, [ebp + arg_8]                       # 00516754
    and dword ptr [ebp + arg_8], 0x0             # 00516757
    push ecx                                     # 0051675b
    push 0x0                                     # 0051675c
    push dword ptr [0x56840c]                    # 0051675e
    push eax                                     # 00516764
    lea eax, [ebp + arg_c]                       # 00516765
    push 0x1                                     # 00516768
    push eax                                     # 0051676a
    push 0x220                                   # 0051676b
    push dword ptr [0x63cb2c]                    # 00516770
    call dword ptr [0x52a1f4]                    # 00516776
    test eax, eax                                # 0051677c
    je.d8 L_00516786                             # 0051677e
    # block 0x00516780: entered by fall-through of je at 0x0051677e, 2 instruction(s), ends with je to 0x00516794 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 00516780
    je.d8 L_00516794                             # 00516784
L_00516786:
    # block 0x00516786: entered by ja at 0x0051674b; je at 0x0051677e; fall-through of je at 0x00516784, 3 instruction(s), calls FUN_0050ea7e, falls into the block at 0x00516794
    call FUN_0050ea7e                            # 00516786
    mov dword ptr [eax], 0x2a                    # 0051678b
    or eax, -0x1                                 # 00516791
L_00516794:
    # block 0x00516794: entered by je at 0x00516784, 2 instruction(s), ends with ret
    pop ebp                                      # 00516794
    ret                                          # 00516795

# --- data items (not part of the function) -------------------------
.org 0x00516796 - 0x401000
PAD_00516796:  # 10 byte(s) of int3 padding
    .fill 10, 1, 0xcc

