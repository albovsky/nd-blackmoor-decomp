# FUN_004709de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004709de
# extent:       0x004709de-0x00470a4f (113 code bytes)
# span:         0x004709de-0x00470a63 (code 113, tables 20, padding 0)
# sha256:       64e9e493f2ccdc3cd940ac8eb1b6ae6a73d4eb6719da9393a7020781cdcf6634
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004709de
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24a.c:m46ebff_click_27c2_27c3 (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 36 instruction(s), 2 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x004709de - 0x401000
.globl FUN_004709de
FUN_004709de:
    # block 0x004709de: entry, 9 instruction(s), ends with jge to 0x00470a02 (forward)
    push ebp                                     # 004709de
    {load} mov ebp, esp                          # 004709df
    sub esp, 0xc                                 # 004709e1
    mov dword ptr [ebp - local_8], ecx           # 004709e4
    mov eax, dword ptr [ebp + arg_c]             # 004709e7
    sub eax, dword ptr [ebp + arg_8]             # 004709ea
    mov dword ptr [ebp - local_4], eax           # 004709ed
    cmp dword ptr [ebp - local_4], 0x0           # 004709f0
    jge.d8 L_00470a02                            # 004709f4
    # block 0x004709f6: entered by fall-through of jge at 0x004709f4, 4 instruction(s), falls into the block at 0x00470a02
    mov ecx, dword ptr [ebp + arg_c]             # 004709f6
    add ecx, 0x1e                                # 004709f9
    sub ecx, dword ptr [ebp + arg_8]             # 004709fc
    mov dword ptr [ebp - local_4], ecx           # 004709ff
L_00470a02:
    # block 0x00470a02: entered by jge at 0x004709f4, 7 instruction(s), ends with ja to 0x00470a44 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00470a02
    mov dword ptr [ebp - local_c], edx           # 00470a05
    mov eax, dword ptr [ebp - local_c]           # 00470a08
    sub eax, 0x1                                 # 00470a0b
    mov dword ptr [ebp - local_c], eax           # 00470a0e
    cmp dword ptr [ebp - local_c], 0x4           # 00470a11
    ja.d8 L_00470a44                             # 00470a15
    # block 0x00470a17: entered by fall-through of ja at 0x00470a15, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x470a4f]
    mov ecx, dword ptr [ebp - local_c]           # 00470a17
    jmp dword ptr [4*ecx + SWTAB_00470a4f_VA]    # 00470a1a
L_00470a21:
    # block 0x00470a21: entered by switch case, 2 instruction(s), ends with forward jump to 0x00470a49
    mov eax, 0x12c                               # 00470a21
    jmp.d8 L_00470a49                            # 00470a26
L_00470a28:
    # block 0x00470a28: entered by switch case, 2 instruction(s), ends with forward jump to 0x00470a49
    mov eax, 0xc8                                # 00470a28
    jmp.d8 L_00470a49                            # 00470a2d
L_00470a2f:
    # block 0x00470a2f: entered by switch case, 2 instruction(s), ends with forward jump to 0x00470a49
    mov eax, 0xc8                                # 00470a2f
    jmp.d8 L_00470a49                            # 00470a34
L_00470a36:
    # block 0x00470a36: entered by switch case, 2 instruction(s), ends with forward jump to 0x00470a49
    mov eax, 0x64                                # 00470a36
    jmp.d8 L_00470a49                            # 00470a3b
L_00470a3d:
    # block 0x00470a3d: entered by switch case, 2 instruction(s), ends with forward jump to 0x00470a49
    mov eax, 0x64                                # 00470a3d
    jmp.d8 L_00470a49                            # 00470a42
L_00470a44:
    # block 0x00470a44: entered by ja at 0x00470a15, 1 instruction(s), falls into the block at 0x00470a49
    mov eax, 0x32                                # 00470a44
L_00470a49:
    # block 0x00470a49: entered by jmp at 0x00470a26; jmp at 0x00470a2d; jmp at 0x00470a34; jmp at 0x00470a3b; more, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00470a49
    pop ebp                                      # 00470a4b
    ret 0x8                                      # 00470a4c

# --- data items (not part of the function) -------------------------
.org 0x00470a4f - 0x401000
SWTAB_00470a4f:  # 5 case address(es)
    .long L_00470a21 - .text + 0x401000
    .long L_00470a28 - .text + 0x401000
    .long L_00470a2f - .text + 0x401000
    .long L_00470a36 - .text + 0x401000
    .long L_00470a3d - .text + 0x401000
.set SWTAB_00470a4f_VA, SWTAB_00470a4f - .text + 0x401000

