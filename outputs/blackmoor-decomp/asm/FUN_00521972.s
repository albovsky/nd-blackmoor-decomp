# FUN_00521972
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521972
# extent:       0x00521972-0x00521a56 (228 code bytes)
# span:         0x00521972-0x00521a56 (code 228, tables 0, padding 0)
# sha256:       e56f214c5449bb9194fe755aca6da57108aa619e8e1590a39dad262a36e71585
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521972
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_e, field_minus_4, field_minus_c, field_minus_10, field_minus_14, field_minus_18, field_minus_24
# callees:      calls FUN_0050f978, FUN_005260ac, FUN_0051fd7e, FUN_0050da98, FUN_0051e7ba, FUN_0051fbcd, FUN_0051fded, FUN_0051fc6a, FUN_0051fc5c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 71 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_24, 0x24  # offset -0x24
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe

# --- external targets -----------------------------------------------
.set FUN_0050da98, .text + (0x0050da98 - 0x401000)
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051fbcd, .text + (0x0051fbcd - 0x401000)
.set FUN_0051fc5c, .text + (0x0051fc5c - 0x401000)
.set FUN_0051fc6a, .text + (0x0051fc6a - 0x401000)
.set FUN_0051fd7e, .text + (0x0051fd7e - 0x401000)
.set FUN_0051fded, .text + (0x0051fded - 0x401000)
.set FUN_005260ac, .text + (0x005260ac - 0x401000)

.org 0x00521972 - 0x401000
.globl FUN_00521972
FUN_00521972:
    # block 0x00521972: entry, 14 instruction(s), calls FUN_0050f978, FUN_005260ac, ends with je to 0x005219e9 (forward)
    mov eax, 0x528cc0                            # 00521972
    call FUN_0050f978                            # 00521977
    sub esp, 0x18                                # 0052197c
    mov eax, dword ptr [0x5679b0]                # 0052197f
    mov dword ptr [ebp - field_minus_10], eax    # 00521984
    push dword ptr [ebp + field_c]               # 00521987
    and dword ptr [ebp - field_minus_4], 0x0     # 0052198a
    lea eax, [ebp - field_minus_18]              # 0052198e
    push eax                                     # 00521991
    lea eax, [ebp - field_minus_10]              # 00521992
    push eax                                     # 00521995
    call FUN_005260ac                            # 00521996
    test eax, eax                                # 0052199b
    je.d8 L_005219e9                             # 0052199d
    # block 0x0052199f: entered by fall-through of je at 0x0052199d, 12 instruction(s), calls FUN_0051fd7e, ends with je to 0x005219f9 (forward)
    mov eax, dword ptr [0x5679b0]                # 0052199f
    mov dword ptr [ebp - field_minus_14], eax    # 005219a4
    lea eax, [ebp + field_e]                     # 005219a7
    mov byte ptr [ebp - field_minus_4], 0x1      # 005219aa
    push eax                                     # 005219ae
    lea eax, [ebp - field_minus_14]              # 005219af
    push eax                                     # 005219b2
    push dword ptr [ebp + field_8]               # 005219b3
    call FUN_0051fd7e                            # 005219b6
    add esp, 0xc                                 # 005219bb
    test eax, eax                                # 005219be
    je.d8 L_005219f9                             # 005219c0
    # block 0x005219c2: entered by fall-through of je at 0x005219c0, 7 instruction(s), calls FUN_0050da98, ends with jne to 0x005219f9 (forward)
    push dword ptr [ebp - field_minus_10]        # 005219c2
    push dword ptr [ebp - field_minus_14]        # 005219c5
    call FUN_0050da98                            # 005219c8
    pop ecx                                      # 005219cd
    test eax, eax                                # 005219ce
    pop ecx                                      # 005219d0
    jne.d8 L_005219f9                            # 005219d1
    # block 0x005219d3: entered by fall-through of jne at 0x005219d1, 3 instruction(s), ends with jne to 0x005219f9 (forward)
    mov ax, word ptr [ebp + field_e]             # 005219d3
    cmp ax, word ptr [ebp - field_minus_18]      # 005219d7
    jne.d8 L_005219f9                            # 005219db
    # block 0x005219dd: entered by fall-through of jne at 0x005219db, 3 instruction(s), calls FUN_0051e7ba, falls into the block at 0x005219e9
    and byte ptr [ebp - field_minus_4], 0x0      # 005219dd
    lea ecx, [ebp - field_minus_14]              # 005219e1
    call FUN_0051e7ba                            # 005219e4
L_005219e9:
    # block 0x005219e9: entered by je at 0x0052199d, 5 instruction(s), calls FUN_0051e7ba, ends with forward jump to 0x00521a48
    or dword ptr [ebp - field_minus_4], -0x1     # 005219e9
    lea ecx, [ebp - field_minus_10]              # 005219ed
    call FUN_0051e7ba                            # 005219f0
    {load} xor eax, eax                          # 005219f5
    jmp.d8 L_00521a48                            # 005219f7
L_005219f9:
    # block 0x005219f9: entered by je at 0x005219c0; jne at 0x005219d1; jne at 0x005219db, 23 instruction(s), calls FUN_0051fbcd, FUN_0051fded, FUN_0051fc6a, FUN_0051fc5c, FUN_0051e7ba, falls into the block at 0x00521a48
    push esi                                     # 005219f9
    lea ecx, [ebp - field_minus_24]              # 005219fa
    push dword ptr [ebp + field_8]               # 005219fd
    call FUN_0051fbcd                            # 00521a00
    push dword ptr [ebp - field_minus_18]        # 00521a05
    lea ecx, [ebp - field_minus_24]              # 00521a08
    mov byte ptr [ebp - field_minus_4], 0x2      # 00521a0b
    push dword ptr [ebp - field_minus_10]        # 00521a0f
    call FUN_0051fded                            # 00521a12
    lea ecx, [ebp - field_minus_24]              # 00521a17
    call FUN_0051fc6a                            # 00521a1a
    lea ecx, [ebp - field_minus_24]              # 00521a1f
    {load} mov esi, eax                          # 00521a22
    mov byte ptr [ebp - field_minus_4], 0x1      # 00521a24
    call FUN_0051fc5c                            # 00521a28
    and byte ptr [ebp - field_minus_4], 0x0      # 00521a2d
    lea ecx, [ebp - field_minus_14]              # 00521a31
    call FUN_0051e7ba                            # 00521a34
    or dword ptr [ebp - field_minus_4], -0x1     # 00521a39
    lea ecx, [ebp - field_minus_10]              # 00521a3d
    call FUN_0051e7ba                            # 00521a40
    {load} mov eax, esi                          # 00521a45
    pop esi                                      # 00521a47
L_00521a48:
    # block 0x00521a48: entered by jmp at 0x005219f7, 4 instruction(s), ends with ret 0x8
    mov ecx, dword ptr [ebp - field_minus_c]     # 00521a48
    mov dword ptr fs:[0x0], ecx                  # 00521a4b
    leave                                        # 00521a52
    ret 0x8                                      # 00521a53

