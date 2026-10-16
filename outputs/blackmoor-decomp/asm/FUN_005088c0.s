# FUN_005088c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005088c0
# extent:       0x005088c0-0x00508a19 (345 code bytes)
# span:         0x005088c0-0x00508a20 (code 345, tables 0, padding 7)
# sha256:       551f54308e4880926333e5ede93dbca793547cc4a856a229bd0ef4f9822a967f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00508720 (+0x1a0)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005088c0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_24, field_minus_4; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_34, stk_38, stk_3c, stk_48 and 1 more
# callees:      calls FUN_004fee30, FUN_00508180
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 123 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00508a20
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_48, 0x48  # offset +0x48
.equ stk_4c, 0x4c  # offset +0x4c

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)
.set FUN_00508180, .text + (0x00508180 - 0x401000)

.org 0x005088c0 - 0x401000
.globl FUN_005088c0
FUN_005088c0:
    # block 0x005088c0: entry, 25 instruction(s), calls FUN_004fee30, ends with jle to 0x00508a0f (forward)
    sub esp, 0x10                                # 005088c0
    mov ecx, dword ptr [esp + stk_14]            # 005088c3
    push ebx                                     # 005088c7
    push ebp                                     # 005088c8
    push esi                                     # 005088c9
    mov eax, dword ptr [ecx + field_24]          # 005088ca
    push edi                                     # 005088cd
    cdq                                          # 005088ce
    mov edi, dword ptr [esp + stk_38]            # 005088cf
    {load} sub eax, edx                          # 005088d3
    {load} mov ebp, eax                          # 005088d5
    mov dword ptr [esp + stk_14], 0x0            # 005088d7
    sar ebp                                      # 005088df
    {load} mov eax, ebp                          # 005088e1
    imul eax, edi                                # 005088e3
    shl eax, 0x2                                 # 005088e6
    push eax                                     # 005088e9
    push ecx                                     # 005088ea
    call FUN_004fee30                            # 005088eb
    add esp, 0x8                                 # 005088f0
    {load} xor ecx, ecx                          # 005088f3
    test edi, edi                                # 005088f5
    mov dword ptr [esp + stk_18], eax            # 005088f7
    mov dword ptr [esp + stk_10], ecx            # 005088fb
    jle.d32 L_00508a0f                           # 005088ff
    # block 0x00508905: entered by fall-through of jle at 0x005088ff, 5 instruction(s), falls into the block at 0x00508917
    mov edx, dword ptr [esp + stk_34]            # 00508905
    mov esi, dword ptr [esp + stk_2c]            # 00508909
    {load} sub esi, edx                          # 0050890d
    mov dword ptr [esp + stk_34], edx            # 0050890f
    mov dword ptr [esp + stk_1c], esi            # 00508913
L_00508917:
    # block 0x00508917: entered by jl at 0x00508963, 4 instruction(s), ends with je to 0x00508924 (forward)
    mov ebx, dword ptr [edx]                     # 00508917
    mov eax, dword ptr [esi + edx]               # 00508919
    test ebx, ebx                                # 0050891c
    je.d8 L_00508924                             # 0050891e
    # block 0x00508920: entered by fall-through of je at 0x0050891e, 1 instruction(s), falls into the block at 0x00508924
    inc dword ptr [esp + stk_14]                 # 00508920
L_00508924:
    # block 0x00508924: entered by je at 0x0050891e, 2 instruction(s), ends with jle to 0x00508955 (forward)
    test ebp, ebp                                # 00508924
    jle.d8 L_00508955                            # 00508926
    # block 0x00508928: entered by fall-through of jle at 0x00508926, 3 instruction(s), falls into the block at 0x00508934
    shl ecx, 0x2                                 # 00508928
    lea esi, [4*edi]                             # 0050892b
    {load} mov edx, ebp                          # 00508932
L_00508934:
    # block 0x00508934: entered by jne at 0x00508943, 7 instruction(s), ends with jne to 0x00508934 (backward)
    mov ebx, dword ptr [esp + stk_18]            # 00508934
    mov edi, dword ptr [eax]                     # 00508938
    add eax, 0x4                                 # 0050893a
    mov dword ptr [ecx + ebx], edi               # 0050893d
    {load} add ecx, esi                          # 00508940
    dec edx                                      # 00508942
    jne.d8 L_00508934                            # 00508943
    # block 0x00508945: entered by fall-through of jne at 0x00508943, 4 instruction(s), falls into the block at 0x00508955
    mov edi, dword ptr [esp + stk_38]            # 00508945
    mov ecx, dword ptr [esp + stk_10]            # 00508949
    mov edx, dword ptr [esp + stk_34]            # 0050894d
    mov esi, dword ptr [esp + stk_1c]            # 00508951
L_00508955:
    # block 0x00508955: entered by jle at 0x00508926, 6 instruction(s), ends with jl to 0x00508917 (backward)
    inc ecx                                      # 00508955
    add edx, 0x4                                 # 00508956
    {load} cmp ecx, edi                          # 00508959
    mov dword ptr [esp + stk_10], ecx            # 0050895b
    mov dword ptr [esp + stk_34], edx            # 0050895f
    jl.d8 L_00508917                             # 00508963
    # block 0x00508965: entered by fall-through of jl at 0x00508963, 3 instruction(s), ends with je to 0x00508a0f (forward)
    mov eax, dword ptr [esp + stk_14]            # 00508965
    test eax, eax                                # 00508969
    je.d32 L_00508a0f                            # 0050896b
    # block 0x00508971: entered by fall-through of je at 0x0050896b, 16 instruction(s), calls FUN_00508180, ends with je to 0x00508a03 (forward)
    mov ecx, dword ptr [esp + stk_3c]            # 00508971
    mov eax, dword ptr [esp + stk_28]            # 00508975
    push 0x507f70                                # 00508979
    push ecx                                     # 0050897e
    mov ecx, dword ptr [esp + stk_2c]            # 0050897f
    lea edx, [esp + stk_20]                      # 00508983
    push 0x1                                     # 00508987
    push edx                                     # 00508989
    push eax                                     # 0050898a
    push ecx                                     # 0050898b
    call FUN_00508180                            # 0050898c
    mov dword ptr [esp + stk_4c], eax            # 00508991
    mov eax, dword ptr [esp + stk_48]            # 00508995
    add esp, 0x18                                # 00508999
    test eax, eax                                # 0050899c
    je.d8 L_00508a03                             # 0050899e
    # block 0x005089a0: entered by fall-through of je at 0x0050899e, 6 instruction(s), falls into the block at 0x005089b4
    mov ebx, dword ptr [esp + stk_2c]            # 005089a0
    {load} xor edx, edx                          # 005089a4
    {load} sub ebx, eax                          # 005089a6
    mov dword ptr [esp + stk_10], edx            # 005089a8
    mov dword ptr [esp + stk_24], eax            # 005089ac
    mov dword ptr [esp + stk_2c], ebx            # 005089b0
L_005089b4:
    # block 0x005089b4: entered by jl at 0x00508a01, 4 instruction(s), ends with jle to 0x005089f3 (forward)
    mov esi, dword ptr [ebx + eax]               # 005089b4
    mov ecx, dword ptr [eax]                     # 005089b7
    test ebp, ebp                                # 005089b9
    jle.d8 L_005089f3                            # 005089bb
    # block 0x005089bd: entered by fall-through of jle at 0x005089bb, 4 instruction(s), falls into the block at 0x005089cb
    shl edx, 0x2                                 # 005089bd
    lea ebx, [4*edi]                             # 005089c0
    {load} sub esi, ecx                          # 005089c7
    {load} mov edi, ebp                          # 005089c9
L_005089cb:
    # block 0x005089cb: entered by jne at 0x005089e1, 9 instruction(s), ends with jne to 0x005089cb (backward)
    mov eax, dword ptr [esp + stk_18]            # 005089cb
    fld dword ptr [esi + ecx]                    # 005089cf
    fsub dword ptr [edx + eax]                   # 005089d2
    add ecx, 0x4                                 # 005089d5
    {load} add edx, ebx                          # 005089d8
    dec edi                                      # 005089da
    fadd dword ptr [ecx - field_minus_4]         # 005089db
    fstp dword ptr [ecx - field_minus_4]         # 005089de
    jne.d8 L_005089cb                            # 005089e1
    # block 0x005089e3: entered by fall-through of jne at 0x005089e1, 4 instruction(s), falls into the block at 0x005089f3
    mov edi, dword ptr [esp + stk_38]            # 005089e3
    mov edx, dword ptr [esp + stk_10]            # 005089e7
    mov eax, dword ptr [esp + stk_24]            # 005089eb
    mov ebx, dword ptr [esp + stk_2c]            # 005089ef
L_005089f3:
    # block 0x005089f3: entered by jle at 0x005089bb, 6 instruction(s), ends with jl to 0x005089b4 (backward)
    inc edx                                      # 005089f3
    add eax, 0x4                                 # 005089f4
    {load} cmp edx, edi                          # 005089f7
    mov dword ptr [esp + stk_10], edx            # 005089f9
    mov dword ptr [esp + stk_24], eax            # 005089fd
    jl.d8 L_005089b4                             # 00508a01
L_00508a03:
    # block 0x00508a03: entered by je at 0x0050899e; fall-through of jl at 0x00508a01, 7 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_34]            # 00508a03
    pop edi                                      # 00508a07
    pop esi                                      # 00508a08
    pop ebp                                      # 00508a09
    pop ebx                                      # 00508a0a
    add esp, 0x10                                # 00508a0b
    ret                                          # 00508a0e
L_00508a0f:
    # block 0x00508a0f: entered by jle at 0x005088ff; je at 0x0050896b, 7 instruction(s), ends with ret
    pop edi                                      # 00508a0f
    pop esi                                      # 00508a10
    pop ebp                                      # 00508a11
    {load} xor eax, eax                          # 00508a12
    pop ebx                                      # 00508a14
    add esp, 0x10                                # 00508a15
    ret                                          # 00508a18

# --- data items (not part of the function) -------------------------
.org 0x00508a19 - 0x401000
PAD_00508a19:  # 7 byte(s) of nop padding
    .fill 7, 1, 0x90

