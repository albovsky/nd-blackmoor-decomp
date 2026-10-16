# FUN_004e7e15
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7e15
# extent:       0x004e7e15-0x004e812f (794 code bytes)
# span:         0x004e7e15-0x004e812f (code 794, tables 0, padding 0)
# sha256:       19074ec7cd9986946b5ed647b9214ce04f76bc1b43d6822d1dcf5b7f6cac8e07
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e7e15
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_695, field_7fae, field_7fb2, field_822e, field_8256, field_8262; [ecx + n] field_691, field_695, field_699, field_822e, field_825e, field_8286; [edx + n] field_691, field_699, field_6b1c, field_822e, field_825a
# callees:      calls FUN_004c2dfb, FUN_004c2790, FUN_004fb77a, FUN_004e812f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 173 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_691, 0x691  # offset +0x691
.equ field_695, 0x695  # offset +0x695
.equ field_699, 0x699  # offset +0x699
.equ field_6b1c, 0x6b1c  # offset +0x6b1c
.equ field_7fae, 0x7fae  # offset +0x7fae
.equ field_7fb2, 0x7fb2  # offset +0x7fb2
.equ field_822e, 0x822e  # offset +0x822e
.equ field_8256, 0x8256  # offset +0x8256
.equ field_825a, 0x825a  # offset +0x825a
.equ field_825e, 0x825e  # offset +0x825e
.equ field_8262, 0x8262  # offset +0x8262
.equ field_8286, 0x8286  # offset +0x8286

# --- external targets -----------------------------------------------
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004e812f, .text + (0x004e812f - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x004e7e15 - 0x401000
.globl FUN_004e7e15
FUN_004e7e15:
    # block 0x004e7e15: entry, 14 instruction(s), ends with forward jump to 0x004e7e6f
    push ebp                                     # 004e7e15
    {load} mov ebp, esp                          # 004e7e16
    push ecx                                     # 004e7e18
    push esi                                     # 004e7e19
    push edi                                     # 004e7e1a
    mov dword ptr [ebp - local_4], ecx           # 004e7e1b
    mov word ptr [0x583a2b], 0x0                 # 004e7e1e
    mov word ptr [0x583a2d], 0x0                 # 004e7e27
    mov word ptr [0x583a2f], 0x0                 # 004e7e30
    mov word ptr [0x583a29], 0xffff              # 004e7e39
    mov word ptr [0x583f1d], 0xffff              # 004e7e42
    mov eax, dword ptr [ebp - local_4]           # 004e7e4b
    mov dword ptr [eax + field_822e], 0x0        # 004e7e4e
    jmp.d8 L_004e7e6f                            # 004e7e58
L_004e7e5a:
    # block 0x004e7e5a: entered by jmp at 0x004e7ef0, 5 instruction(s), falls into the block at 0x004e7e6f
    mov ecx, dword ptr [ebp - local_4]           # 004e7e5a
    mov edx, dword ptr [ecx + field_822e]        # 004e7e5d
    add edx, 0x1                                 # 004e7e63
    mov eax, dword ptr [ebp - local_4]           # 004e7e66
    mov dword ptr [eax + field_822e], edx        # 004e7e69
L_004e7e6f:
    # block 0x004e7e6f: entered by jmp at 0x004e7e58, 3 instruction(s), ends with jge to 0x004e7ef5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e7e6f
    cmp dword ptr [ecx + field_822e], 0x46       # 004e7e72
    jge.d8 L_004e7ef5                            # 004e7e79
    # block 0x004e7e7b: entered by fall-through of jge at 0x004e7e79, 19 instruction(s), ends with backward jump to 0x004e7e5a
    mov edx, dword ptr [ebp - local_4]           # 004e7e7b
    mov eax, dword ptr [edx + field_822e]        # 004e7e7e
    mov dword ptr [4*eax + 0x583bd5], 0x0        # 004e7e84
    mov ecx, dword ptr [ebp - local_4]           # 004e7e8f
    mov edx, dword ptr [ecx + field_822e]        # 004e7e92
    mov word ptr [2*edx + 0x583a31], 0xffff      # 004e7e98
    mov eax, dword ptr [ebp - local_4]           # 004e7ea2
    mov ecx, dword ptr [eax + field_822e]        # 004e7ea5
    mov word ptr [2*ecx + 0x583abd], 0xffff      # 004e7eab
    mov edx, dword ptr [ebp - local_4]           # 004e7eb5
    mov eax, dword ptr [edx + field_822e]        # 004e7eb8
    mov word ptr [2*eax + 0x583b49], 0xffff      # 004e7ebe
    mov ecx, dword ptr [ebp - local_4]           # 004e7ec8
    mov edx, dword ptr [ecx + field_822e]        # 004e7ecb
    mov dword ptr [4*edx + 0x583ced], 0x0        # 004e7ed1
    mov eax, dword ptr [ebp - local_4]           # 004e7edc
    mov ecx, dword ptr [eax + field_822e]        # 004e7edf
    mov dword ptr [4*ecx + 0x583e05], 0x0        # 004e7ee5
    jmp.d32 L_004e7e5a                           # 004e7ef0
L_004e7ef5:
    # block 0x004e7ef5: entered by jge at 0x004e7e79, 3 instruction(s), ends with forward jump to 0x004e7f19
    mov edx, dword ptr [ebp - local_4]           # 004e7ef5
    mov dword ptr [edx + field_822e], 0x0        # 004e7ef8
    jmp.d8 L_004e7f19                            # 004e7f02
L_004e7f04:
    # block 0x004e7f04: entered by jmp at 0x004e7f59, 5 instruction(s), falls into the block at 0x004e7f19
    mov eax, dword ptr [ebp - local_4]           # 004e7f04
    mov ecx, dword ptr [eax + field_822e]        # 004e7f07
    add ecx, 0x1                                 # 004e7f0d
    mov edx, dword ptr [ebp - local_4]           # 004e7f10
    mov dword ptr [edx + field_822e], ecx        # 004e7f13
L_004e7f19:
    # block 0x004e7f19: entered by jmp at 0x004e7f02, 3 instruction(s), ends with jge to 0x004e7f5b (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e7f19
    cmp dword ptr [eax + field_822e], 0x10       # 004e7f1c
    jge.d8 L_004e7f5b                            # 004e7f23
    # block 0x004e7f25: entered by fall-through of jge at 0x004e7f23, 11 instruction(s), ends with backward jump to 0x004e7f04
    mov ecx, dword ptr [ebp - local_4]           # 004e7f25
    mov edx, dword ptr [ecx + field_822e]        # 004e7f28
    imul edx, edx, 0x28                          # 004e7f2e
    mov eax, dword ptr [ebp - local_4]           # 004e7f31
    mov dword ptr [eax + edx + field_7fae], 0xffffffff # 004e7f34
    mov ecx, dword ptr [ebp - local_4]           # 004e7f3f
    mov edx, dword ptr [ecx + field_822e]        # 004e7f42
    imul edx, edx, 0x28                          # 004e7f48
    mov eax, dword ptr [ebp - local_4]           # 004e7f4b
    mov dword ptr [eax + edx + field_7fb2], 0x0  # 004e7f4e
    jmp.d8 L_004e7f04                            # 004e7f59
L_004e7f5b:
    # block 0x004e7f5b: entered by jge at 0x004e7f23, 15 instruction(s), ends with je to 0x004e7fc9 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e7f5b
    mov dword ptr [ecx + field_825e], 0x0        # 004e7f5e
    mov edx, dword ptr [ebp - local_4]           # 004e7f68
    mov dword ptr [edx + field_6b1c], 0xffffffff # 004e7f6b
    mov eax, dword ptr [ebp - local_4]           # 004e7f75
    mov dword ptr [eax + field_8256], 0x0        # 004e7f78
    mov ecx, dword ptr [ebp - local_4]           # 004e7f82
    mov dword ptr [ecx + field_8286], 0x0        # 004e7f85
    mov edx, dword ptr [ebp - local_4]           # 004e7f8f
    mov dword ptr [edx + field_825a], 0x0        # 004e7f92
    mov eax, dword ptr [ebp - local_4]           # 004e7f9c
    mov dword ptr [eax + field_8262], 0x0        # 004e7f9f
    mov ecx, dword ptr [ebp - local_4]           # 004e7fa9
    cmp dword ptr [ecx + field_699], 0x0         # 004e7fac
    je.d8 L_004e7fc9                             # 004e7fb3
    # block 0x004e7fb5: entered by fall-through of je at 0x004e7fb3, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004e7fc9
    mov edx, dword ptr [ebp - local_4]           # 004e7fb5
    add edx, 0x699                               # 004e7fb8
    push edx                                     # 004e7fbe
    mov ecx, 0x5cf659                            # 004e7fbf
    call FUN_004c2dfb                            # 004e7fc4
L_004e7fc9:
    # block 0x004e7fc9: entered by je at 0x004e7fb3, 3 instruction(s), ends with je to 0x004e7fe9 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e7fc9
    cmp dword ptr [eax + field_695], 0x0         # 004e7fcc
    je.d8 L_004e7fe9                             # 004e7fd3
    # block 0x004e7fd5: entered by fall-through of je at 0x004e7fd3, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004e7fe9
    mov ecx, dword ptr [ebp - local_4]           # 004e7fd5
    add ecx, 0x695                               # 004e7fd8
    push ecx                                     # 004e7fde
    mov ecx, 0x5cf659                            # 004e7fdf
    call FUN_004c2dfb                            # 004e7fe4
L_004e7fe9:
    # block 0x004e7fe9: entered by je at 0x004e7fd3, 3 instruction(s), ends with je to 0x004e8008 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e7fe9
    cmp dword ptr [edx + field_691], 0x0         # 004e7fec
    je.d8 L_004e8008                             # 004e7ff3
    # block 0x004e7ff5: entered by fall-through of je at 0x004e7ff3, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004e8008
    mov eax, dword ptr [ebp - local_4]           # 004e7ff5
    add eax, 0x691                               # 004e7ff8
    push eax                                     # 004e7ffd
    mov ecx, 0x5cf659                            # 004e7ffe
    call FUN_004c2dfb                            # 004e8003
L_004e8008:
    # block 0x004e8008: entered by je at 0x004e7ff3, 3 instruction(s), ends with jne to 0x004e803d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e8008
    cmp dword ptr [ecx + field_695], 0x0         # 004e800b
    jne.d8 L_004e803d                            # 004e8012
    # block 0x004e8014: entered by fall-through of jne at 0x004e8012, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004e803d
    push 0x55c5a0                                # 004e8014
    push 0x6                                     # 004e8019
    mov edx, dword ptr [ebp - local_4]           # 004e801b
    add edx, 0x69f                               # 004e801e
    push edx                                     # 004e8024
    push 0x55c5b4                                # 004e8025
    mov ecx, 0x5cf659                            # 004e802a
    call FUN_004c2790                            # 004e802f
    mov ecx, dword ptr [ebp - local_4]           # 004e8034
    mov dword ptr [ecx + field_695], eax         # 004e8037
L_004e803d:
    # block 0x004e803d: entered by jne at 0x004e8012, 3 instruction(s), ends with jne to 0x004e8071 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e803d
    cmp dword ptr [edx + field_691], 0x0         # 004e8040
    jne.d8 L_004e8071                            # 004e8047
    # block 0x004e8049: entered by fall-through of jne at 0x004e8047, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004e8071
    push 0x55c5bc                                # 004e8049
    push 0x6                                     # 004e804e
    mov eax, dword ptr [ebp - local_4]           # 004e8050
    add eax, 0x6c0                               # 004e8053
    push eax                                     # 004e8058
    push 0x55c5d0                                # 004e8059
    mov ecx, 0x5cf659                            # 004e805e
    call FUN_004c2790                            # 004e8063
    mov ecx, dword ptr [ebp - local_4]           # 004e8068
    mov dword ptr [ecx + field_691], eax         # 004e806b
L_004e8071:
    # block 0x004e8071: entered by jne at 0x004e8047, 36 instruction(s), ends with je to 0x004e8121 (forward)
    mov dword ptr [0x5d1703], 0xc                # 004e8071
    mov dword ptr [0x5d1707], 0x0                # 004e807b
    mov edx, dword ptr [ebp - local_4]           # 004e8085
    mov eax, dword ptr [edx + field_699]         # 004e8088
    mov dword ptr [0x5d170b], eax                # 004e808e
    mov ecx, dword ptr [ebp - local_4]           # 004e8093
    add ecx, 0x8266                              # 004e8096
    mov dword ptr [0x5d170f], ecx                # 004e809c
    mov edx, dword ptr [ebp - local_4]           # 004e80a2
    add edx, 0x8276                              # 004e80a5
    mov dword ptr [0x5d1713], edx                # 004e80ab
    mov dword ptr [0x5d1717], 0x0                # 004e80b1
    mov dword ptr [0x5d171b], 0x1                # 004e80bb
    mov word ptr [0x5d171f], 0x1                 # 004e80c5
    mov edi, 0x55c5d8                            # 004e80ce
    mov edx, 0x5d1725                            # 004e80d3
    or ecx, -0x1                                 # 004e80d8
    {load} xor eax, eax                          # 004e80db
    repne scasb al, byte ptr es:[edi]            # 004e80dd
    not ecx                                      # 004e80df
    {load} sub edi, ecx                          # 004e80e1
    {load} mov esi, edi                          # 004e80e3
    {load} mov eax, ecx                          # 004e80e5
    {load} mov edi, edx                          # 004e80e7
    shr ecx, 0x2                                 # 004e80e9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e80ec
    {load} mov ecx, eax                          # 004e80ee
    and ecx, 0x3                                 # 004e80f0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e80f3
    mov edi, 0x55c5e4                            # 004e80f5
    mov esi, dword ptr [ebp - local_4]           # 004e80fa
    add esi, 0x6e1                               # 004e80fd
    mov ecx, 0x9                                 # 004e8103
    {load} xor edx, edx                          # 004e8108
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e810a
    je.d8 L_004e8121                             # 004e810c
    # block 0x004e810e: entered by fall-through of je at 0x004e810c, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004e8121
    mov eax, dword ptr [ebp - local_4]           # 004e810e
    add eax, 0x6e1                               # 004e8111
    push eax                                     # 004e8116
    mov ecx, 0x5c3a67                            # 004e8117
    call FUN_004fb77a                            # 004e811c
L_004e8121:
    # block 0x004e8121: entered by je at 0x004e810c, 7 instruction(s), calls FUN_004e812f, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004e8121
    call FUN_004e812f                            # 004e8124
    pop edi                                      # 004e8129
    pop esi                                      # 004e812a
    {load} mov esp, ebp                          # 004e812b
    pop ebp                                      # 004e812d
    ret                                          # 004e812e

