# FUN_0051086b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051086b
# extent:       0x0051086b-0x00510909 (158 code bytes)
# span:         0x0051086b-0x00510909 (code 158, tables 0, padding 0)
# sha256:       63c2ea1686ab60746c2a7eb252b9ac2287d99cfcc0dc6077bcce9fc26f9ffc7f
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051086b
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_4; [ebx + n] field_8; [edi + n] field_4, field_8
# callees:      calls FUN_00510f3b, FUN_00510d20, FUN_0050cc86
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         unreachable_code_entry:0x005108d2
# note:         unreachable_code_entry:0x005108dc
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050cc86, .text + (0x0050cc86 - 0x401000)
.set FUN_00510d20, .text + (0x00510d20 - 0x401000)
.set FUN_00510f3b, .text + (0x00510f3b - 0x401000)

.org 0x0051086b - 0x401000
.globl FUN_0051086b
FUN_0051086b:
    # block 0x0051086b: entry, 17 instruction(s), falls into the block at 0x0051089d
    push ebp                                     # 0051086b
    {load} mov ebp, esp                          # 0051086c
    push -0x1                                    # 0051086e
    push 0x5303c0                                # 00510870
    push 0x511930                                # 00510875
    mov eax, dword ptr fs:[0x0]                  # 0051087a
    push eax                                     # 00510880
    mov dword ptr fs:[0x0], esp                  # 00510881
    sub esp, 0xc                                 # 00510888
    push ebx                                     # 0051088b
    push esi                                     # 0051088c
    push edi                                     # 0051088d
    mov dword ptr [ebp - local_18], esp          # 0051088e
    mov ebx, dword ptr [ebp + arg_8]             # 00510891
    mov esi, dword ptr [ebx + field_8]           # 00510894
    mov dword ptr [ebp - local_1c], esi          # 00510897
    mov edi, dword ptr [ebp + arg_10]            # 0051089a
L_0051089d:
    # block 0x0051089d: entered by jmp at 0x005108f5, 2 instruction(s), ends with je to 0x005108f7 (forward)
    cmp esi, dword ptr [ebp + arg_14]            # 0051089d
    je.d8 L_005108f7                             # 005108a0
    # block 0x005108a2: entered by fall-through of je at 0x005108a0, 2 instruction(s), ends with jle to 0x005108ac (forward)
    cmp esi, -0x1                                # 005108a2
    jle.d8 L_005108ac                            # 005108a5
    # block 0x005108a7: entered by fall-through of jle at 0x005108a5, 2 instruction(s), ends with jl to 0x005108b1 (forward)
    cmp esi, dword ptr [edi + field_4]           # 005108a7
    jl.d8 L_005108b1                             # 005108aa
L_005108ac:
    # block 0x005108ac: entered by jle at 0x005108a5; fall-through of jl at 0x005108aa, 1 instruction(s), calls FUN_00510f3b, falls into the block at 0x005108b1
    call FUN_00510f3b                            # 005108ac
L_005108b1:
    # block 0x005108b1: entered by jl at 0x005108aa, 5 instruction(s), ends with je to 0x005108cc (forward)
    and dword ptr [ebp - local_4], 0x0           # 005108b1
    mov eax, dword ptr [edi + field_8]           # 005108b5
    mov eax, dword ptr [eax + 8*esi + field_4]   # 005108b8
    test eax, eax                                # 005108bc
    je.d8 L_005108cc                             # 005108be
    # block 0x005108c0: entered by fall-through of je at 0x005108be, 4 instruction(s), calls FUN_00510d20, falls into the block at 0x005108cc
    push 0x103                                   # 005108c0
    push ebx                                     # 005108c5
    push eax                                     # 005108c6
    call FUN_00510d20                            # 005108c7
L_005108cc:
    # block 0x005108cc: entered by je at 0x005108be, 2 instruction(s), ends with forward jump to 0x005108ec
    or dword ptr [ebp - local_4], -0x1           # 005108cc
    jmp.d8 L_005108ec                            # 005108d0
    # block 0x005108d2: entered by follows jmp at 0x005108d0, 4 instruction(s), calls FUN_0050cc86, ends with ret
    push dword ptr [ebp - local_14]              # 005108d2
    call FUN_0050cc86                            # 005108d5
    pop ecx                                      # 005108da
    ret                                          # 005108db
    # block 0x005108dc: entered by follows ret at 0x005108db, 5 instruction(s), falls into the block at 0x005108ec
    mov esp, dword ptr [ebp - local_18]          # 005108dc
    or dword ptr [ebp - local_4], -0x1           # 005108df
    mov edi, dword ptr [ebp + arg_10]            # 005108e3
    mov ebx, dword ptr [ebp + arg_8]             # 005108e6
    mov esi, dword ptr [ebp - local_1c]          # 005108e9
L_005108ec:
    # block 0x005108ec: entered by jmp at 0x005108d0, 4 instruction(s), ends with backward jump to 0x0051089d
    mov eax, dword ptr [edi + field_8]           # 005108ec
    mov esi, dword ptr [eax + 8*esi]             # 005108ef
    mov dword ptr [ebp - local_1c], esi          # 005108f2
    jmp.d8 L_0051089d                            # 005108f5
L_005108f7:
    # block 0x005108f7: entered by je at 0x005108a0, 8 instruction(s), ends with ret
    mov dword ptr [ebx + field_8], esi           # 005108f7
    mov ecx, dword ptr [ebp - local_10]          # 005108fa
    mov dword ptr fs:[0x0], ecx                  # 005108fd
    pop edi                                      # 00510904
    pop esi                                      # 00510905
    pop ebx                                      # 00510906
    leave                                        # 00510907
    ret                                          # 00510908

