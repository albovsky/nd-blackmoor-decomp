# FUN_00510e3a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510e3a
# extent:       0x00510e3a-0x00510eda (160 code bytes)
# span:         0x00510e3a-0x00510eda (code 160, tables 0, padding 0)
# sha256:       891a981448309d62be8816e23a2d061166e37b9d1b83177cfca26a52c45c2ba4
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510e3a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_24, field_28, field_30, field_38, field_40, field_44, field_50; [esp + n] stk_8
# callees:      calls KERNEL32.dll!TlsGetValue, FUN_0050e936, KERNEL32.dll!TlsSetValue
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 62 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_30, 0x30  # offset +0x30
.equ field_38, 0x38  # offset +0x38
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x00510e3a - 0x401000
.globl FUN_00510e3a
FUN_00510e3a:
    # block 0x00510e3a: entry, 3 instruction(s), ends with je to 0x00510ed9 (forward)
    mov eax, dword ptr [0x5681f0]                # 00510e3a
    cmp eax, -0x1                                # 00510e3f
    je.d32 L_00510ed9                            # 00510e42
    # block 0x00510e48: entered by fall-through of je at 0x00510e42, 4 instruction(s), ends with jne to 0x00510e5e (forward)
    push esi                                     # 00510e48
    mov esi, dword ptr [esp + stk_8]             # 00510e49
    test esi, esi                                # 00510e4d
    jne.d8 L_00510e5e                            # 00510e4f
    # block 0x00510e51: entered by fall-through of jne at 0x00510e4f, 5 instruction(s), calls KERNEL32.dll!TlsGetValue, ends with je to 0x00510eca (forward)
    push eax                                     # 00510e51
    call dword ptr [0x52a0dc]                    # 00510e52
    {load} mov esi, eax                          # 00510e58
    test esi, esi                                # 00510e5a
    je.d8 L_00510eca                             # 00510e5c
L_00510e5e:
    # block 0x00510e5e: entered by jne at 0x00510e4f; fall-through of je at 0x00510e5c, 3 instruction(s), ends with je to 0x00510e6c (forward)
    mov eax, dword ptr [esi + field_24]          # 00510e5e
    test eax, eax                                # 00510e61
    je.d8 L_00510e6c                             # 00510e63
    # block 0x00510e65: entered by fall-through of je at 0x00510e63, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00510e6c
    push eax                                     # 00510e65
    call FUN_0050e936                            # 00510e66
    pop ecx                                      # 00510e6b
L_00510e6c:
    # block 0x00510e6c: entered by je at 0x00510e63, 3 instruction(s), ends with je to 0x00510e7a (forward)
    mov eax, dword ptr [esi + field_28]          # 00510e6c
    test eax, eax                                # 00510e6f
    je.d8 L_00510e7a                             # 00510e71
    # block 0x00510e73: entered by fall-through of je at 0x00510e71, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00510e7a
    push eax                                     # 00510e73
    call FUN_0050e936                            # 00510e74
    pop ecx                                      # 00510e79
L_00510e7a:
    # block 0x00510e7a: entered by je at 0x00510e71, 3 instruction(s), ends with je to 0x00510e88 (forward)
    mov eax, dword ptr [esi + field_30]          # 00510e7a
    test eax, eax                                # 00510e7d
    je.d8 L_00510e88                             # 00510e7f
    # block 0x00510e81: entered by fall-through of je at 0x00510e7f, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00510e88
    push eax                                     # 00510e81
    call FUN_0050e936                            # 00510e82
    pop ecx                                      # 00510e87
L_00510e88:
    # block 0x00510e88: entered by je at 0x00510e7f, 3 instruction(s), ends with je to 0x00510e96 (forward)
    mov eax, dword ptr [esi + field_38]          # 00510e88
    test eax, eax                                # 00510e8b
    je.d8 L_00510e96                             # 00510e8d
    # block 0x00510e8f: entered by fall-through of je at 0x00510e8d, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00510e96
    push eax                                     # 00510e8f
    call FUN_0050e936                            # 00510e90
    pop ecx                                      # 00510e95
L_00510e96:
    # block 0x00510e96: entered by je at 0x00510e8d, 3 instruction(s), ends with je to 0x00510ea4 (forward)
    mov eax, dword ptr [esi + field_40]          # 00510e96
    test eax, eax                                # 00510e99
    je.d8 L_00510ea4                             # 00510e9b
    # block 0x00510e9d: entered by fall-through of je at 0x00510e9b, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00510ea4
    push eax                                     # 00510e9d
    call FUN_0050e936                            # 00510e9e
    pop ecx                                      # 00510ea3
L_00510ea4:
    # block 0x00510ea4: entered by je at 0x00510e9b, 3 instruction(s), ends with je to 0x00510eb2 (forward)
    mov eax, dword ptr [esi + field_44]          # 00510ea4
    test eax, eax                                # 00510ea7
    je.d8 L_00510eb2                             # 00510ea9
    # block 0x00510eab: entered by fall-through of je at 0x00510ea9, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00510eb2
    push eax                                     # 00510eab
    call FUN_0050e936                            # 00510eac
    pop ecx                                      # 00510eb1
L_00510eb2:
    # block 0x00510eb2: entered by je at 0x00510ea9, 3 instruction(s), ends with je to 0x00510ec3 (forward)
    mov eax, dword ptr [esi + field_50]          # 00510eb2
    cmp eax, 0x568a58                            # 00510eb5
    je.d8 L_00510ec3                             # 00510eba
    # block 0x00510ebc: entered by fall-through of je at 0x00510eba, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00510ec3
    push eax                                     # 00510ebc
    call FUN_0050e936                            # 00510ebd
    pop ecx                                      # 00510ec2
L_00510ec3:
    # block 0x00510ec3: entered by je at 0x00510eba, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00510eca
    push esi                                     # 00510ec3
    call FUN_0050e936                            # 00510ec4
    pop ecx                                      # 00510ec9
L_00510eca:
    # block 0x00510eca: entered by je at 0x00510e5c, 4 instruction(s), calls KERNEL32.dll!TlsSetValue, falls into the block at 0x00510ed9
    push 0x0                                     # 00510eca
    push dword ptr [0x5681f0]                    # 00510ecc
    call dword ptr [0x52a0d4]                    # 00510ed2
    pop esi                                      # 00510ed8
L_00510ed9:
    # block 0x00510ed9: entered by je at 0x00510e42, 1 instruction(s), ends with ret
    ret                                          # 00510ed9

