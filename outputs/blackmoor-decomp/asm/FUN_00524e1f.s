# FUN_00524e1f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524e1f
# extent:       0x00524e1f-0x00524f55 (310 code bytes)
# span:         0x00524e1f-0x00524f55 (code 310, tables 0, padding 0)
# sha256:       1ea384a2acdcd5255907b81da8ec79d96c564d1bc72a45d0ce64c66fa0830ecc
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524e1f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_10, field_14; [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_28, field_78, field_7c, field_80, field_88, field_8c, field_90, field_94, field_98, field_a8, field_ac, field_b0 and 1 more
# callees:      calls FUN_0050f978, FUN_00525371, FUN_005211ff, FUN_0050e936, FUN_005268fc; plus 7 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 97 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_28, 0x28  # offset +0x28
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_80, 0x80  # offset +0x80
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_a8, 0xa8  # offset +0xa8
.equ field_ac, 0xac  # offset +0xac
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b2, 0xb2  # offset +0xb2

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_005211ff, .text + (0x005211ff - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_005268fc, .text + (0x005268fc - 0x401000)

.org 0x00524e1f - 0x401000
.globl FUN_00524e1f
FUN_00524e1f:
    # block 0x00524e1f: entry, 13 instruction(s), calls FUN_0050f978, ends with je to 0x00524e4d (forward)
    mov eax, 0x528e80                            # 00524e1f
    call FUN_0050f978                            # 00524e24
    push ecx                                     # 00524e29
    push ebx                                     # 00524e2a
    push esi                                     # 00524e2b
    {load} mov esi, ecx                          # 00524e2c
    mov dword ptr [ebp - field_minus_10], esi    # 00524e2e
    mov dword ptr [esi], 0x52f514                # 00524e31
    mov ecx, dword ptr [esi + field_80]          # 00524e37
    {load} xor ebx, ebx                          # 00524e3d
    {load} cmp ecx, ebx                          # 00524e3f
    mov dword ptr [ebp - field_minus_4], ebx     # 00524e41
    je.d8 L_00524e4d                             # 00524e44
    # block 0x00524e46: entered by fall-through of je at 0x00524e44, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x00524e4d
    mov eax, dword ptr [ecx]                     # 00524e46
    push 0x1                                     # 00524e48
    call dword ptr [eax + field_4]               # 00524e4a
L_00524e4d:
    # block 0x00524e4d: entered by je at 0x00524e44, 3 instruction(s), ends with je to 0x00524e5e (forward)
    mov ecx, dword ptr [esi + field_a8]          # 00524e4d
    {load} cmp ecx, ebx                          # 00524e53
    je.d8 L_00524e5e                             # 00524e55
    # block 0x00524e57: entered by fall-through of je at 0x00524e55, 3 instruction(s), calls indirect dword ptr [eax + 0x14], falls into the block at 0x00524e5e
    mov eax, dword ptr [ecx]                     # 00524e57
    push 0x1                                     # 00524e59
    call dword ptr [eax + field_14]              # 00524e5b
L_00524e5e:
    # block 0x00524e5e: entered by je at 0x00524e55, 3 instruction(s), calls FUN_00525371, ends with jne to 0x00524e96 (forward)
    call FUN_00525371                            # 00524e5e
    cmp byte ptr [eax + field_14], bl            # 00524e63
    jne.d8 L_00524e96                            # 00524e66
    # block 0x00524e68: entered by fall-through of jne at 0x00524e66, 3 instruction(s), ends with je to 0x00524e7f (forward)
    mov ecx, dword ptr [0x63c424]                # 00524e68
    {load} cmp ecx, ebx                          # 00524e6e
    je.d8 L_00524e7f                             # 00524e70
    # block 0x00524e72: entered by fall-through of je at 0x00524e70, 4 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x00524e7f
    mov eax, dword ptr [ecx]                     # 00524e72
    push 0x1                                     # 00524e74
    call dword ptr [eax + field_4]               # 00524e76
    mov dword ptr [0x63c424], ebx                # 00524e79
L_00524e7f:
    # block 0x00524e7f: entered by je at 0x00524e70, 3 instruction(s), ends with je to 0x00524e96 (forward)
    mov ecx, dword ptr [0x63c420]                # 00524e7f
    {load} cmp ecx, ebx                          # 00524e85
    je.d8 L_00524e96                             # 00524e87
    # block 0x00524e89: entered by fall-through of je at 0x00524e87, 4 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x00524e96
    mov eax, dword ptr [ecx]                     # 00524e89
    push 0x1                                     # 00524e8b
    call dword ptr [eax + field_4]               # 00524e8d
    mov dword ptr [0x63c420], ebx                # 00524e90
L_00524e96:
    # block 0x00524e96: entered by jne at 0x00524e66; je at 0x00524e87, 3 instruction(s), ends with je to 0x00524ea6 (forward)
    mov eax, dword ptr [esi + field_94]          # 00524e96
    {load} cmp eax, ebx                          # 00524e9c
    je.d8 L_00524ea6                             # 00524e9e
    # block 0x00524ea0: entered by fall-through of je at 0x00524e9e, 2 instruction(s), calls FUN_005211ff, falls into the block at 0x00524ea6
    push eax                                     # 00524ea0
    call FUN_005211ff                            # 00524ea1
L_00524ea6:
    # block 0x00524ea6: entered by je at 0x00524e9e, 3 instruction(s), ends with je to 0x00524eb6 (forward)
    mov eax, dword ptr [esi + field_98]          # 00524ea6
    {load} cmp eax, ebx                          # 00524eac
    je.d8 L_00524eb6                             # 00524eae
    # block 0x00524eb0: entered by fall-through of je at 0x00524eae, 2 instruction(s), calls FUN_005211ff, falls into the block at 0x00524eb6
    push eax                                     # 00524eb0
    call FUN_005211ff                            # 00524eb1
L_00524eb6:
    # block 0x00524eb6: entered by je at 0x00524eae, 5 instruction(s), ends with je to 0x00524ecc (forward)
    mov ax, word ptr [esi + field_b0]            # 00524eb6
    push edi                                     # 00524ebd
    mov edi, dword ptr [0x52a240]                # 00524ebe
    {load} cmp ax, bx                            # 00524ec4
    je.d8 L_00524ecc                             # 00524ec7
    # block 0x00524ec9: entered by fall-through of je at 0x00524ec7, 2 instruction(s), calls indirect edi, falls into the block at 0x00524ecc
    push eax                                     # 00524ec9
    call edi                                     # 00524eca
L_00524ecc:
    # block 0x00524ecc: entered by je at 0x00524ec7, 3 instruction(s), ends with je to 0x00524edb (forward)
    mov ax, word ptr [esi + field_b2]            # 00524ecc
    {load} cmp ax, bx                            # 00524ed3
    je.d8 L_00524edb                             # 00524ed6
    # block 0x00524ed8: entered by fall-through of je at 0x00524ed6, 2 instruction(s), calls indirect edi, falls into the block at 0x00524edb
    push eax                                     # 00524ed8
    call edi                                     # 00524ed9
L_00524edb:
    # block 0x00524edb: entered by je at 0x00524ed6, 4 instruction(s), ends with je to 0x00524eed (forward)
    mov ecx, dword ptr [esi + field_ac]          # 00524edb
    pop edi                                      # 00524ee1
    {load} cmp ecx, ebx                          # 00524ee2
    je.d8 L_00524eed                             # 00524ee4
    # block 0x00524ee6: entered by fall-through of je at 0x00524ee4, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x00524eed
    mov eax, dword ptr [ecx]                     # 00524ee6
    push 0x1                                     # 00524ee8
    call dword ptr [eax + field_4]               # 00524eea
L_00524eed:
    # block 0x00524eed: entered by je at 0x00524ee4, 4 instruction(s), calls FUN_00525371, ends with jne to 0x00524efd (forward)
    call FUN_00525371                            # 00524eed
    mov ecx, dword ptr [eax + field_10]          # 00524ef2
    cmp ecx, dword ptr [esi + field_78]          # 00524ef5
    jne.d8 L_00524efd                            # 00524ef8
    # block 0x00524efa: entered by fall-through of jne at 0x00524ef8, 1 instruction(s), falls into the block at 0x00524efd
    mov dword ptr [eax + field_10], ebx          # 00524efa
L_00524efd:
    # block 0x00524efd: entered by jne at 0x00524ef8, 2 instruction(s), ends with jne to 0x00524f05 (forward)
    cmp dword ptr [eax + field_4], esi           # 00524efd
    jne.d8 L_00524f05                            # 00524f00
    # block 0x00524f02: entered by fall-through of jne at 0x00524f00, 1 instruction(s), falls into the block at 0x00524f05
    mov dword ptr [eax + field_4], ebx           # 00524f02
L_00524f05:
    # block 0x00524f05: entered by jne at 0x00524f00, 21 instruction(s), calls FUN_0050e936, FUN_005268fc, ends with ret
    push dword ptr [esi + field_78]              # 00524f05
    call FUN_0050e936                            # 00524f08
    push dword ptr [esi + field_7c]              # 00524f0d
    call FUN_0050e936                            # 00524f10
    push dword ptr [esi + field_88]              # 00524f15
    call FUN_0050e936                            # 00524f1b
    push dword ptr [esi + field_8c]              # 00524f20
    call FUN_0050e936                            # 00524f26
    push dword ptr [esi + field_90]              # 00524f2b
    call FUN_0050e936                            # 00524f31
    or dword ptr [ebp - field_minus_4], -0x1     # 00524f36
    add esp, 0x14                                # 00524f3a
    {load} mov ecx, esi                          # 00524f3d
    mov dword ptr [esi + field_28], ebx          # 00524f3f
    call FUN_005268fc                            # 00524f42
    mov ecx, dword ptr [ebp - field_minus_c]     # 00524f47
    pop esi                                      # 00524f4a
    pop ebx                                      # 00524f4b
    mov dword ptr fs:[0x0], ecx                  # 00524f4c
    leave                                        # 00524f53
    ret                                          # 00524f54

