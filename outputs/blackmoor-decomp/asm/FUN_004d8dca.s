# FUN_004d8dca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d8dca
# extent:       0x004d8dca-0x004d8f0a (320 code bytes)
# span:         0x004d8dca-0x004d8f0a (code 320, tables 0, padding 0)
# sha256:       2b59e5366d7010c2850c0c01037441324416109fb456afeb1651305170cb9db9
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d8dca
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_100, field_980c; [ecx + n] field_100, field_980c; [edx + n] field_100, field_980c
# callees:      calls FUN_004d8dca
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 103 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_100, 0x100  # offset +0x100
.equ field_980c, 0x980c  # offset +0x980c

# --- external targets -----------------------------------------------

.org 0x004d8dca - 0x401000
.globl FUN_004d8dca
FUN_004d8dca:
L_004d8dca:
    # block 0x004d8dca: entry, 12 instruction(s), ends with jle to 0x004d8f03 (forward)
    push ebp                                     # 004d8dca
    {load} mov ebp, esp                          # 004d8dcb
    sub esp, 0x14                                # 004d8dcd
    push esi                                     # 004d8dd0
    mov dword ptr [ebp - local_14], ecx          # 004d8dd1
    mov eax, dword ptr [ebp + arg_8]             # 004d8dd4
    mov dword ptr [ebp - local_8], eax           # 004d8dd7
    mov ecx, dword ptr [ebp + arg_c]             # 004d8dda
    mov dword ptr [ebp - local_c], ecx           # 004d8ddd
    mov edx, dword ptr [ebp + arg_c]             # 004d8de0
    cmp edx, dword ptr [ebp + arg_8]             # 004d8de3
    jle.d32 L_004d8f03                           # 004d8de6
    # block 0x004d8dec: entered by fall-through of jle at 0x004d8de6, 10 instruction(s), falls into the block at 0x004d8e0c
    mov eax, dword ptr [ebp + arg_8]             # 004d8dec
    add eax, dword ptr [ebp + arg_c]             # 004d8def
    cdq                                          # 004d8df2
    {load} sub eax, edx                          # 004d8df3
    sar eax                                      # 004d8df5
    mov ecx, dword ptr [ebp - local_14]          # 004d8df7
    mov edx, dword ptr [ecx + field_980c]        # 004d8dfa
    mov eax, dword ptr [edx + 4*eax]             # 004d8e00
    mov ecx, dword ptr [eax + field_100]         # 004d8e03
    mov dword ptr [ebp - local_4], ecx           # 004d8e09
L_004d8e0c:
    # block 0x004d8e0c: entered by jmp at 0x004d8ece, 3 instruction(s), ends with jg to 0x004d8ed3 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d8e0c
    cmp edx, dword ptr [ebp - local_c]           # 004d8e0f
    jg.d32 L_004d8ed3                            # 004d8e12
L_004d8e18:
    # block 0x004d8e18: entered by jmp at 0x004d8e43; fall-through of jg at 0x004d8e12, 3 instruction(s), ends with jge to 0x004d8e45 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004d8e18
    cmp eax, dword ptr [ebp + arg_c]             # 004d8e1b
    jge.d8 L_004d8e45                            # 004d8e1e
    # block 0x004d8e20: entered by fall-through of jge at 0x004d8e1e, 7 instruction(s), ends with jge to 0x004d8e45 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004d8e20
    mov edx, dword ptr [ecx + field_980c]        # 004d8e23
    mov eax, dword ptr [ebp - local_8]           # 004d8e29
    mov ecx, dword ptr [edx + 4*eax]             # 004d8e2c
    mov edx, dword ptr [ecx + field_100]         # 004d8e2f
    cmp edx, dword ptr [ebp - local_4]           # 004d8e35
    jge.d8 L_004d8e45                            # 004d8e38
    # block 0x004d8e3a: entered by fall-through of jge at 0x004d8e38, 4 instruction(s), ends with backward jump to 0x004d8e18
    mov eax, dword ptr [ebp - local_8]           # 004d8e3a
    add eax, 0x1                                 # 004d8e3d
    mov dword ptr [ebp - local_8], eax           # 004d8e40
    jmp.d8 L_004d8e18                            # 004d8e43
L_004d8e45:
    # block 0x004d8e45: entered by jge at 0x004d8e1e; jge at 0x004d8e38; jmp at 0x004d8e70, 3 instruction(s), ends with jle to 0x004d8e72 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004d8e45
    cmp ecx, dword ptr [ebp + arg_8]             # 004d8e48
    jle.d8 L_004d8e72                            # 004d8e4b
    # block 0x004d8e4d: entered by fall-through of jle at 0x004d8e4b, 7 instruction(s), ends with jle to 0x004d8e72 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004d8e4d
    mov eax, dword ptr [edx + field_980c]        # 004d8e50
    mov ecx, dword ptr [ebp - local_c]           # 004d8e56
    mov edx, dword ptr [eax + 4*ecx]             # 004d8e59
    mov eax, dword ptr [edx + field_100]         # 004d8e5c
    cmp eax, dword ptr [ebp - local_4]           # 004d8e62
    jle.d8 L_004d8e72                            # 004d8e65
    # block 0x004d8e67: entered by fall-through of jle at 0x004d8e65, 4 instruction(s), ends with backward jump to 0x004d8e45
    mov ecx, dword ptr [ebp - local_c]           # 004d8e67
    sub ecx, 0x1                                 # 004d8e6a
    mov dword ptr [ebp - local_c], ecx           # 004d8e6d
    jmp.d8 L_004d8e45                            # 004d8e70
L_004d8e72:
    # block 0x004d8e72: entered by jle at 0x004d8e4b; jle at 0x004d8e65, 3 instruction(s), ends with jg to 0x004d8ece (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d8e72
    cmp edx, dword ptr [ebp - local_c]           # 004d8e75
    jg.d8 L_004d8ece                             # 004d8e78
    # block 0x004d8e7a: entered by fall-through of jg at 0x004d8e78, 24 instruction(s), falls into the block at 0x004d8ece
    mov eax, dword ptr [ebp - local_14]          # 004d8e7a
    mov ecx, dword ptr [eax + field_980c]        # 004d8e7d
    mov edx, dword ptr [ebp - local_8]           # 004d8e83
    mov eax, dword ptr [ecx + 4*edx]             # 004d8e86
    mov dword ptr [ebp - local_10], eax          # 004d8e89
    mov ecx, dword ptr [ebp - local_14]          # 004d8e8c
    mov edx, dword ptr [ecx + field_980c]        # 004d8e8f
    mov eax, dword ptr [ebp - local_14]          # 004d8e95
    mov ecx, dword ptr [eax + field_980c]        # 004d8e98
    mov eax, dword ptr [ebp - local_8]           # 004d8e9e
    mov esi, dword ptr [ebp - local_c]           # 004d8ea1
    mov edx, dword ptr [edx + 4*esi]             # 004d8ea4
    mov dword ptr [ecx + 4*eax], edx             # 004d8ea7
    mov eax, dword ptr [ebp - local_14]          # 004d8eaa
    mov ecx, dword ptr [eax + field_980c]        # 004d8ead
    mov edx, dword ptr [ebp - local_c]           # 004d8eb3
    mov eax, dword ptr [ebp - local_10]          # 004d8eb6
    mov dword ptr [ecx + 4*edx], eax             # 004d8eb9
    mov ecx, dword ptr [ebp - local_8]           # 004d8ebc
    add ecx, 0x1                                 # 004d8ebf
    mov dword ptr [ebp - local_8], ecx           # 004d8ec2
    mov edx, dword ptr [ebp - local_c]           # 004d8ec5
    sub edx, 0x1                                 # 004d8ec8
    mov dword ptr [ebp - local_c], edx           # 004d8ecb
L_004d8ece:
    # block 0x004d8ece: entered by jg at 0x004d8e78, 1 instruction(s), ends with backward jump to 0x004d8e0c
    jmp.d32 L_004d8e0c                           # 004d8ece
L_004d8ed3:
    # block 0x004d8ed3: entered by jg at 0x004d8e12, 3 instruction(s), ends with jge to 0x004d8eeb (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d8ed3
    cmp eax, dword ptr [ebp - local_c]           # 004d8ed6
    jge.d8 L_004d8eeb                            # 004d8ed9
    # block 0x004d8edb: entered by fall-through of jge at 0x004d8ed9, 6 instruction(s), calls FUN_004d8dca, falls into the block at 0x004d8eeb
    mov ecx, dword ptr [ebp - local_c]           # 004d8edb
    push ecx                                     # 004d8ede
    mov edx, dword ptr [ebp + arg_8]             # 004d8edf
    push edx                                     # 004d8ee2
    mov ecx, dword ptr [ebp - local_14]          # 004d8ee3
    call L_004d8dca                              # 004d8ee6
L_004d8eeb:
    # block 0x004d8eeb: entered by jge at 0x004d8ed9, 3 instruction(s), ends with jge to 0x004d8f03 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004d8eeb
    cmp eax, dword ptr [ebp + arg_c]             # 004d8eee
    jge.d8 L_004d8f03                            # 004d8ef1
    # block 0x004d8ef3: entered by fall-through of jge at 0x004d8ef1, 6 instruction(s), calls FUN_004d8dca, falls into the block at 0x004d8f03
    mov ecx, dword ptr [ebp + arg_c]             # 004d8ef3
    push ecx                                     # 004d8ef6
    mov edx, dword ptr [ebp - local_8]           # 004d8ef7
    push edx                                     # 004d8efa
    mov ecx, dword ptr [ebp - local_14]          # 004d8efb
    call L_004d8dca                              # 004d8efe
L_004d8f03:
    # block 0x004d8f03: entered by jle at 0x004d8de6; jge at 0x004d8ef1, 4 instruction(s), ends with ret 0x8
    pop esi                                      # 004d8f03
    {load} mov esp, ebp                          # 004d8f04
    pop ebp                                      # 004d8f06
    ret 0x8                                      # 004d8f07

