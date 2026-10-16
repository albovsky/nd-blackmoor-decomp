# FUN_0050c775
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c775
# extent:       0x0050c775-0x0050c82b (182 code bytes)
# span:         0x0050c775-0x0050c82b (code 182, tables 0, padding 0)
# sha256:       aed62b1b1045fc24ebc21f44a42d7122a8a001df1098b2d39743ad00ebc031cb
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c775
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_18, arg_1c, arg_20; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       13 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 1 more
# fields:       [eax + n] field_68
# callees:      calls FUN_00510dd3; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ field_68, 0x68  # offset +0x68

# --- external targets -----------------------------------------------
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)

.org 0x0050c775 - 0x401000
.globl FUN_0050c775
FUN_0050c775:
    # block 0x0050c775: entry, 43 instruction(s), calls FUN_00510dd3, indirect dword ptr [eax + 0x68], ends with je to 0x0050c81a (forward)
    push ebp                                     # 0050c775
    {load} mov ebp, esp                          # 0050c776
    sub esp, 0x34                                # 0050c778
    push ebx                                     # 0050c77b
    push esi                                     # 0050c77c
    push edi                                     # 0050c77d
    and dword ptr [ebp - local_28], 0x0          # 0050c77e
    mov dword ptr [ebp - local_24], 0x50c82b     # 0050c782
    mov eax, dword ptr [ebp + arg_18]            # 0050c789
    mov dword ptr [ebp - local_20], eax          # 0050c78c
    mov eax, dword ptr [ebp + arg_c]             # 0050c78f
    mov dword ptr [ebp - local_1c], eax          # 0050c792
    mov eax, dword ptr [ebp + arg_1c]            # 0050c795
    mov dword ptr [ebp - local_18], eax          # 0050c798
    mov eax, dword ptr [ebp + arg_20]            # 0050c79b
    mov dword ptr [ebp - local_14], eax          # 0050c79e
    and dword ptr [ebp - local_10], 0x0          # 0050c7a1
    and dword ptr [ebp - local_c], 0x0           # 0050c7a5
    and dword ptr [ebp - local_8], 0x0           # 0050c7a9
    and dword ptr [ebp - local_4], 0x0           # 0050c7ad
    mov dword ptr [ebp - local_10], 0x50c7fd     # 0050c7b1
    mov dword ptr [ebp - local_c], esp           # 0050c7b8
    mov dword ptr [ebp - local_8], ebp           # 0050c7bb
    mov eax, dword ptr fs:[0x0]                  # 0050c7be
    mov dword ptr [ebp - local_28], eax          # 0050c7c4
    {disp32} lea eax, [ebp - local_28]           # 0050c7c7
    mov dword ptr fs:[0x0], eax                  # 0050c7cd
    mov dword ptr [ebp - local_34], 0x1          # 0050c7d3
    mov eax, dword ptr [ebp + arg_8]             # 0050c7da
    mov dword ptr [ebp - local_30], eax          # 0050c7dd
    mov eax, dword ptr [ebp + arg_10]            # 0050c7e0
    mov dword ptr [ebp - local_2c], eax          # 0050c7e3
    lea eax, [ebp - local_30]                    # 0050c7e6
    push eax                                     # 0050c7e9
    mov eax, dword ptr [ebp + arg_8]             # 0050c7ea
    push dword ptr [eax]                         # 0050c7ed
    call FUN_00510dd3                            # 0050c7ef
    call dword ptr [eax + field_68]              # 0050c7f4
    pop ecx                                      # 0050c7f7
    pop ecx                                      # 0050c7f8
    and dword ptr [ebp - local_34], 0x0          # 0050c7f9
    cmp dword ptr [ebp - local_4], 0x0           # 0050c7fd
    je.d8 L_0050c81a                             # 0050c801
    # block 0x0050c803: entered by fall-through of je at 0x0050c801, 6 instruction(s), ends with forward jump to 0x0050c823
    mov ebx, dword ptr fs:[0x0]                  # 0050c803
    mov eax, dword ptr [ebx]                     # 0050c80a
    mov ebx, dword ptr [ebp - local_28]          # 0050c80c
    mov dword ptr [ebx], eax                     # 0050c80f
    mov dword ptr fs:[0x0], ebx                  # 0050c811
    jmp.d8 L_0050c823                            # 0050c818
L_0050c81a:
    # block 0x0050c81a: entered by je at 0x0050c801, 2 instruction(s), falls into the block at 0x0050c823
    mov eax, dword ptr [ebp - local_28]          # 0050c81a
    mov dword ptr fs:[0x0], eax                  # 0050c81d
L_0050c823:
    # block 0x0050c823: entered by jmp at 0x0050c818, 6 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_34]          # 0050c823
    pop edi                                      # 0050c826
    pop esi                                      # 0050c827
    pop ebx                                      # 0050c828
    leave                                        # 0050c829
    ret                                          # 0050c82a

