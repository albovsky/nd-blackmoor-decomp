# FUN_0044ad41
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044ad41
# extent:       0x0044ad41-0x0044af17 (470 code bytes)
# span:         0x0044ad41-0x0044af20 (code 470, tables 0, padding 9)
# sha256:       680ab601095c3fd097f91a67b534c42c9b073b6e96b0752181e1176e60969252
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_file_version_info_reader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/44ad41.c.txt, not original source) refers to the data labelled s_GetVersionInfo_____Bad_return_on_00548d94, s__StringFileInfo_040904B0_FileVer_00548e40
# name-note:    Reads the file version resource with GetFileVersionInfo/VerQueryValue (\StringFileInfo\040904B0\FileVersion) and parses four numbers into globals.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fcee2, FUN_004264e8, FUN_0051dc43, FUN_0042639d, FUN_004fcedc, FUN_004fced6, FUN_0050deda, FUN_0050cb1b, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 144 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004fced6, .text + (0x004fced6 - 0x401000)
.set FUN_004fcedc, .text + (0x004fcedc - 0x401000)
.set FUN_004fcee2, .text + (0x004fcee2 - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0050deda, .text + (0x0050deda - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0044ad41 - 0x401000
.globl FUN_0044ad41
FUN_0044ad41:
    # block 0x0044ad41: entry, 14 instruction(s), calls FUN_004fcee2, ends with jne to 0x0044ad82 (forward)
    push ebp                                     # 0044ad41
    {load} mov ebp, esp                          # 0044ad42
    sub esp, 0x2c                                # 0044ad44
    push esi                                     # 0044ad47
    push edi                                     # 0044ad48
    mov dword ptr [ebp - local_8], 0x0           # 0044ad49
    mov dword ptr [ebp - local_14], 0x0          # 0044ad50
    lea eax, [ebp - local_4]                     # 0044ad57
    push eax                                     # 0044ad5a
    push 0x63999b                                # 0044ad5b
    call FUN_004fcee2                            # 0044ad60
    mov dword ptr [ebp - local_18], eax          # 0044ad65
    cmp dword ptr [ebp - local_18], 0x0          # 0044ad68
    jne.d8 L_0044ad82                            # 0044ad6c
    # block 0x0044ad6e: entered by fall-through of jne at 0x0044ad6c, 4 instruction(s), calls FUN_004264e8, ends with forward jump to 0x0044af0f
    push 0x548d94                                # 0044ad6e
    mov ecx, 0x583979                            # 0044ad73
    call FUN_004264e8                            # 0044ad78
    jmp.d32 L_0044af0f                           # 0044ad7d
L_0044ad82:
    # block 0x0044ad82: entered by jne at 0x0044ad6c, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x0044adb6 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 0044ad82
    push ecx                                     # 0044ad85
    call FUN_0051dc43                            # 0044ad86
    add esp, 0x4                                 # 0044ad8b
    mov dword ptr [ebp - local_20], eax          # 0044ad8e
    mov edx, dword ptr [ebp - local_20]          # 0044ad91
    mov dword ptr [ebp - local_8], edx           # 0044ad94
    cmp dword ptr [ebp - local_8], 0x0           # 0044ad97
    jne.d8 L_0044adb6                            # 0044ad9b
    # block 0x0044ad9d: entered by fall-through of jne at 0x0044ad9b, 5 instruction(s), calls FUN_0042639d, ends with forward jump to 0x0044af0d
    push 0x548dd0                                # 0044ad9d
    push 0x548dec                                # 0044ada2
    mov ecx, 0x583979                            # 0044ada7
    call FUN_0042639d                            # 0044adac
    jmp.d32 L_0044af0d                           # 0044adb1
L_0044adb6:
    # block 0x0044adb6: entered by jne at 0x0044ad9b, 10 instruction(s), calls FUN_004fcedc, ends with jne to 0x0044ade4 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0044adb6
    push eax                                     # 0044adb9
    mov ecx, dword ptr [ebp - local_18]          # 0044adba
    push ecx                                     # 0044adbd
    mov edx, dword ptr [ebp - local_4]           # 0044adbe
    push edx                                     # 0044adc1
    push 0x63999b                                # 0044adc2
    call FUN_004fcedc                            # 0044adc7
    test eax, eax                                # 0044adcc
    jne.d8 L_0044ade4                            # 0044adce
    # block 0x0044add0: entered by fall-through of jne at 0x0044adce, 4 instruction(s), calls FUN_004264e8, ends with forward jump to 0x0044af0b
    push 0x548e08                                # 0044add0
    mov ecx, 0x583979                            # 0044add5
    call FUN_004264e8                            # 0044adda
    jmp.d32 L_0044af0b                           # 0044addf
L_0044ade4:
    # block 0x0044ade4: entered by jne at 0x0044adce, 17 instruction(s), calls FUN_004fced6, FUN_0051dc43, ends with jne to 0x0044ae2e (forward)
    lea eax, [ebp - local_10]                    # 0044ade4
    push eax                                     # 0044ade7
    lea ecx, [ebp - local_c]                     # 0044ade8
    push ecx                                     # 0044adeb
    push 0x548e40                                # 0044adec
    mov edx, dword ptr [ebp - local_8]           # 0044adf1
    push edx                                     # 0044adf4
    call FUN_004fced6                            # 0044adf5
    mov eax, dword ptr [ebp - local_10]          # 0044adfa
    push eax                                     # 0044adfd
    call FUN_0051dc43                            # 0044adfe
    add esp, 0x4                                 # 0044ae03
    mov dword ptr [ebp - local_24], eax          # 0044ae06
    mov ecx, dword ptr [ebp - local_24]          # 0044ae09
    mov dword ptr [ebp - local_14], ecx          # 0044ae0c
    cmp dword ptr [ebp - local_14], 0x0          # 0044ae0f
    jne.d8 L_0044ae2e                            # 0044ae13
    # block 0x0044ae15: entered by fall-through of jne at 0x0044ae13, 5 instruction(s), calls FUN_0042639d, ends with forward jump to 0x0044af09
    push 0x548e68                                # 0044ae15
    push 0x548e88                                # 0044ae1a
    mov ecx, 0x583979                            # 0044ae1f
    call FUN_0042639d                            # 0044ae24
    jmp.d32 L_0044af09                           # 0044ae29
L_0044ae2e:
    # block 0x0044ae2e: entered by jne at 0x0044ae13, 50 instruction(s), calls FUN_0050deda, FUN_0050cb1b, falls into the block at 0x0044aed7
    mov ecx, dword ptr [ebp - local_10]          # 0044ae2e
    mov esi, dword ptr [ebp - local_c]           # 0044ae31
    mov edi, dword ptr [ebp - local_14]          # 0044ae34
    {load} mov edx, ecx                          # 0044ae37
    shr ecx, 0x2                                 # 0044ae39
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044ae3c
    {load} mov ecx, edx                          # 0044ae3e
    and ecx, 0x3                                 # 0044ae40
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044ae43
    push 0x548ea4                                # 0044ae45
    mov eax, dword ptr [ebp - local_14]          # 0044ae4a
    push eax                                     # 0044ae4d
    call FUN_0050deda                            # 0044ae4e
    add esp, 0x8                                 # 0044ae53
    mov dword ptr [ebp - local_1c], eax          # 0044ae56
    mov ecx, dword ptr [ebp - local_1c]          # 0044ae59
    push ecx                                     # 0044ae5c
    call FUN_0050cb1b                            # 0044ae5d
    add esp, 0x4                                 # 0044ae62
    mov word ptr [0x5bb21e], ax                  # 0044ae65
    push 0x548ea8                                # 0044ae6b
    push 0x0                                     # 0044ae70
    call FUN_0050deda                            # 0044ae72
    add esp, 0x8                                 # 0044ae77
    mov dword ptr [ebp - local_1c], eax          # 0044ae7a
    mov edx, dword ptr [ebp - local_1c]          # 0044ae7d
    push edx                                     # 0044ae80
    call FUN_0050cb1b                            # 0044ae81
    add esp, 0x4                                 # 0044ae86
    mov word ptr [0x5bb220], ax                  # 0044ae89
    push 0x548eac                                # 0044ae8f
    push 0x0                                     # 0044ae94
    call FUN_0050deda                            # 0044ae96
    add esp, 0x8                                 # 0044ae9b
    mov dword ptr [ebp - local_1c], eax          # 0044ae9e
    mov eax, dword ptr [ebp - local_1c]          # 0044aea1
    push eax                                     # 0044aea4
    call FUN_0050cb1b                            # 0044aea5
    add esp, 0x4                                 # 0044aeaa
    mov word ptr [0x5bb222], ax                  # 0044aead
    push 0x548eb0                                # 0044aeb3
    push 0x0                                     # 0044aeb8
    call FUN_0050deda                            # 0044aeba
    add esp, 0x8                                 # 0044aebf
    mov dword ptr [ebp - local_1c], eax          # 0044aec2
    mov ecx, dword ptr [ebp - local_1c]          # 0044aec5
    push ecx                                     # 0044aec8
    call FUN_0050cb1b                            # 0044aec9
    add esp, 0x4                                 # 0044aece
    mov word ptr [0x5bb224], ax                  # 0044aed1
L_0044aed7:
    # block 0x0044aed7: entered by jmp at 0x0044af09; jmp at 0x0044af0b; jmp at 0x0044af0d; jmp at 0x0044af0f, 2 instruction(s), ends with je to 0x0044aeef (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0044aed7
    je.d8 L_0044aeef                             # 0044aedb
    # block 0x0044aedd: entered by fall-through of je at 0x0044aedb, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044aeef
    mov edx, dword ptr [ebp - local_8]           # 0044aedd
    mov dword ptr [ebp - local_28], edx          # 0044aee0
    mov eax, dword ptr [ebp - local_28]          # 0044aee3
    push eax                                     # 0044aee6
    call FUN_0051dc6c                            # 0044aee7
    add esp, 0x4                                 # 0044aeec
L_0044aeef:
    # block 0x0044aeef: entered by je at 0x0044aedb, 2 instruction(s), ends with je to 0x0044af07 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 0044aeef
    je.d8 L_0044af07                             # 0044aef3
    # block 0x0044aef5: entered by fall-through of je at 0x0044aef3, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044af07
    mov ecx, dword ptr [ebp - local_14]          # 0044aef5
    mov dword ptr [ebp - local_2c], ecx          # 0044aef8
    mov edx, dword ptr [ebp - local_2c]          # 0044aefb
    push edx                                     # 0044aefe
    call FUN_0051dc6c                            # 0044aeff
    add esp, 0x4                                 # 0044af04
L_0044af07:
    # block 0x0044af07: entered by je at 0x0044aef3, 1 instruction(s), ends with forward jump to 0x0044af11
    jmp.d8 L_0044af11                            # 0044af07
L_0044af09:
    # block 0x0044af09: entered by jmp at 0x0044ae29, 1 instruction(s), ends with backward jump to 0x0044aed7
    jmp.d8 L_0044aed7                            # 0044af09
L_0044af0b:
    # block 0x0044af0b: entered by jmp at 0x0044addf, 1 instruction(s), ends with backward jump to 0x0044aed7
    jmp.d8 L_0044aed7                            # 0044af0b
L_0044af0d:
    # block 0x0044af0d: entered by jmp at 0x0044adb1, 1 instruction(s), ends with backward jump to 0x0044aed7
    jmp.d8 L_0044aed7                            # 0044af0d
L_0044af0f:
    # block 0x0044af0f: entered by jmp at 0x0044ad7d, 1 instruction(s), ends with backward jump to 0x0044aed7
    jmp.d8 L_0044aed7                            # 0044af0f
L_0044af11:
    # block 0x0044af11: entered by jmp at 0x0044af07, 5 instruction(s), ends with ret
    pop edi                                      # 0044af11
    pop esi                                      # 0044af12
    {load} mov esp, ebp                          # 0044af13
    pop ebp                                      # 0044af15
    ret                                          # 0044af16

# --- data items (not part of the function) -------------------------
.org 0x0044af17 - 0x401000
PAD_0044af17:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

