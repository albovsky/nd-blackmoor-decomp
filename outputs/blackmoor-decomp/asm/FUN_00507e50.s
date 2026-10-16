# FUN_00507e50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00507e50
# extent:       0x00507e50-0x00507f6e (286 code bytes)
# span:         0x00507e50-0x00507f70 (code 286, tables 0, padding 2)
# sha256:       8ea4bd43a88b4143793f01ec2dd387ea20486275c632f0f0203d5c2e3df8250e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00507c30 (+0x220)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00507e50
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_24; [esp + n] stk_10, stk_14, stk_18, stk_20, stk_28, stk_2c, stk_30, stk_34, stk_38
# callees:      calls FUN_00508180
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 111 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00507f70
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------
.set FUN_00508180, .text + (0x00508180 - 0x401000)

.org 0x00507e50 - 0x401000
.globl FUN_00507e50
FUN_00507e50:
    # block 0x00507e50: entry, 15 instruction(s), ends with jle to 0x00507f64 (forward)
    sub esp, 0xc                                 # 00507e50
    mov eax, dword ptr [esp + stk_10]            # 00507e53
    push ebx                                     # 00507e57
    push ebp                                     # 00507e58
    push esi                                     # 00507e59
    mov eax, dword ptr [eax + field_24]          # 00507e5a
    mov esi, dword ptr [esp + stk_30]            # 00507e5d
    cdq                                          # 00507e61
    {load} sub eax, edx                          # 00507e62
    push edi                                     # 00507e64
    {load} mov edi, eax                          # 00507e65
    mov dword ptr [esp + stk_10], 0x0            # 00507e67
    sar edi                                      # 00507e6f
    test esi, esi                                # 00507e71
    jle.d32 L_00507f64                           # 00507e73
    # block 0x00507e79: entered by fall-through of jle at 0x00507e73, 11 instruction(s), falls into the block at 0x00507e9d
    mov ebp, dword ptr [esp + stk_2c]            # 00507e79
    mov eax, dword ptr [esp + stk_30]            # 00507e7d
    mov ebx, dword ptr [esp + stk_28]            # 00507e81
    {load} mov ecx, ebp                          # 00507e85
    {load} sub eax, ebp                          # 00507e87
    {load} sub ecx, ebx                          # 00507e89
    mov dword ptr [esp + stk_28], ebx            # 00507e8b
    {load} mov edx, ebx                          # 00507e8f
    mov dword ptr [esp + stk_14], eax            # 00507e91
    mov dword ptr [esp + stk_18], ecx            # 00507e95
    mov dword ptr [esp + stk_30], esi            # 00507e99
L_00507e9d:
    # block 0x00507e9d: entered by jne at 0x00507ef5, 3 instruction(s), ends with je to 0x00507ee9 (forward)
    lea esi, [ecx + edx]                         # 00507e9d
    cmp dword ptr [esi + eax], 0x0               # 00507ea0
    je.d8 L_00507ee9                             # 00507ea4
    # block 0x00507ea6: entered by fall-through of je at 0x00507ea4, 2 instruction(s), ends with je to 0x00507ecd (forward)
    test ebp, ebp                                # 00507ea6
    je.d8 L_00507ecd                             # 00507ea8
    # block 0x00507eaa: entered by fall-through of je at 0x00507ea8, 3 instruction(s), ends with jle to 0x00507ecd (forward)
    {load} xor eax, eax                          # 00507eaa
    test edi, edi                                # 00507eac
    jle.d8 L_00507ecd                            # 00507eae
L_00507eb0:
    # block 0x00507eb0: entered by jl at 0x00507ec3; fall-through of jle at 0x00507eae, 9 instruction(s), ends with jl to 0x00507eb0 (backward)
    mov ecx, dword ptr [esi]                     # 00507eb0
    mov ebp, dword ptr [edx]                     # 00507eb2
    {disp8} fld dword ptr [ebp + 4*eax]          # 00507eb4
    fadd dword ptr [ecx + 4*eax]                 # 00507eb8
    lea ecx, [ecx + 4*eax]                       # 00507ebb
    inc eax                                      # 00507ebe
    {load} cmp eax, edi                          # 00507ebf
    fstp dword ptr [ecx]                         # 00507ec1
    jl.d8 L_00507eb0                             # 00507ec3
    # block 0x00507ec5: entered by fall-through of jl at 0x00507ec3, 2 instruction(s), falls into the block at 0x00507ecd
    mov ebp, dword ptr [esp + stk_2c]            # 00507ec5
    mov ecx, dword ptr [esp + stk_18]            # 00507ec9
L_00507ecd:
    # block 0x00507ecd: entered by je at 0x00507ea8; jle at 0x00507eae, 9 instruction(s), falls into the block at 0x00507ee9
    mov eax, dword ptr [esp + stk_28]            # 00507ecd
    mov esi, dword ptr [edx]                     # 00507ed1
    mov dword ptr [eax], esi                     # 00507ed3
    mov esi, dword ptr [esp + stk_10]            # 00507ed5
    inc esi                                      # 00507ed9
    add eax, 0x4                                 # 00507eda
    mov dword ptr [esp + stk_28], eax            # 00507edd
    mov eax, dword ptr [esp + stk_14]            # 00507ee1
    mov dword ptr [esp + stk_10], esi            # 00507ee5
L_00507ee9:
    # block 0x00507ee9: entered by je at 0x00507ea4, 5 instruction(s), ends with jne to 0x00507e9d (backward)
    mov esi, dword ptr [esp + stk_30]            # 00507ee9
    add edx, 0x4                                 # 00507eed
    dec esi                                      # 00507ef0
    mov dword ptr [esp + stk_30], esi            # 00507ef1
    jne.d8 L_00507e9d                            # 00507ef5
    # block 0x00507ef7: entered by fall-through of jne at 0x00507ef5, 3 instruction(s), ends with je to 0x00507f64 (forward)
    mov eax, dword ptr [esp + stk_10]            # 00507ef7
    test eax, eax                                # 00507efb
    je.d8 L_00507f64                             # 00507efd
    # block 0x00507eff: entered by fall-through of je at 0x00507efd, 14 instruction(s), calls FUN_00508180, ends with je to 0x00507f58 (forward)
    mov edx, dword ptr [esp + stk_38]            # 00507eff
    mov ecx, dword ptr [esp + stk_20]            # 00507f03
    push 0x507f70                                # 00507f07
    push edx                                     # 00507f0c
    push eax                                     # 00507f0d
    mov eax, dword ptr [esp + stk_30]            # 00507f0e
    push ebx                                     # 00507f12
    push eax                                     # 00507f13
    push ecx                                     # 00507f14
    call FUN_00508180                            # 00507f15
    add esp, 0x18                                # 00507f1a
    mov dword ptr [esp + stk_2c], eax            # 00507f1d
    test ebp, ebp                                # 00507f21
    je.d8 L_00507f58                             # 00507f23
    # block 0x00507f25: entered by fall-through of je at 0x00507f23, 2 instruction(s), falls into the block at 0x00507f2b
    {load} mov esi, ebp                          # 00507f25
    mov ebp, dword ptr [esp + stk_34]            # 00507f27
L_00507f2b:
    # block 0x00507f2b: entered by jne at 0x00507f56, 3 instruction(s), ends with je to 0x00507f52 (forward)
    mov edx, dword ptr [esp + stk_14]            # 00507f2b
    cmp dword ptr [esi + edx], 0x0               # 00507f2f
    je.d8 L_00507f52                             # 00507f33
    # block 0x00507f35: entered by fall-through of je at 0x00507f33, 3 instruction(s), ends with jle to 0x00507f4f (forward)
    {load} xor ecx, ecx                          # 00507f35
    test edi, edi                                # 00507f37
    jle.d8 L_00507f4f                            # 00507f39
L_00507f3b:
    # block 0x00507f3b: entered by jl at 0x00507f4d; fall-through of jle at 0x00507f39, 9 instruction(s), ends with jl to 0x00507f3b (backward)
    mov eax, dword ptr [esi]                     # 00507f3b
    fld dword ptr [eax + 4*ecx]                  # 00507f3d
    lea edx, [eax + 4*ecx]                       # 00507f40
    mov eax, dword ptr [ebx]                     # 00507f43
    fsub dword ptr [eax + 4*ecx]                 # 00507f45
    inc ecx                                      # 00507f48
    {load} cmp ecx, edi                          # 00507f49
    fstp dword ptr [edx]                         # 00507f4b
    jl.d8 L_00507f3b                             # 00507f4d
L_00507f4f:
    # block 0x00507f4f: entered by jle at 0x00507f39; fall-through of jl at 0x00507f4d, 1 instruction(s), falls into the block at 0x00507f52
    add ebx, 0x4                                 # 00507f4f
L_00507f52:
    # block 0x00507f52: entered by je at 0x00507f33, 3 instruction(s), ends with jne to 0x00507f2b (backward)
    add esi, 0x4                                 # 00507f52
    dec ebp                                      # 00507f55
    jne.d8 L_00507f2b                            # 00507f56
L_00507f58:
    # block 0x00507f58: entered by je at 0x00507f23; fall-through of jne at 0x00507f56, 7 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_2c]            # 00507f58
    pop edi                                      # 00507f5c
    pop esi                                      # 00507f5d
    pop ebp                                      # 00507f5e
    pop ebx                                      # 00507f5f
    add esp, 0xc                                 # 00507f60
    ret                                          # 00507f63
L_00507f64:
    # block 0x00507f64: entered by jle at 0x00507e73; je at 0x00507efd, 7 instruction(s), ends with ret
    pop edi                                      # 00507f64
    pop esi                                      # 00507f65
    pop ebp                                      # 00507f66
    {load} xor eax, eax                          # 00507f67
    pop ebx                                      # 00507f69
    add esp, 0xc                                 # 00507f6a
    ret                                          # 00507f6d

# --- data items (not part of the function) -------------------------
.org 0x00507f6e - 0x401000
PAD_00507f6e:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90

