# FUN_004230d1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004230d1
# extent:       0x004230d1-0x00423142 (113 code bytes)
# span:         0x004230d1-0x00423142 (code 113, tables 0, padding 0)
# sha256:       186703f5815f2539334306fed6207c9a4813718b4a1551194a53e972b031fde8
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004230d1
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00423021, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4110d7_lifted (function ledger class candidate_port; also m41bebc_lifted, m4230d1_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 37 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_00423021, .text + (0x00423021 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004230d1 - 0x401000
.globl FUN_004230d1
FUN_004230d1:
    # block 0x004230d1: entry, 6 instruction(s), ends with forward jump to 0x004230ec
    push ebp                                     # 004230d1
    {load} mov ebp, esp                          # 004230d2
    sub esp, 0x14                                # 004230d4
    mov dword ptr [ebp - local_10], ecx          # 004230d7
    mov dword ptr [ebp - local_4], 0x0           # 004230da
    jmp.d8 L_004230ec                            # 004230e1
L_004230e3:
    # block 0x004230e3: entered by jmp at 0x0042313c, 3 instruction(s), falls into the block at 0x004230ec
    mov eax, dword ptr [ebp - local_4]           # 004230e3
    add eax, 0x1                                 # 004230e6
    mov dword ptr [ebp - local_4], eax           # 004230e9
L_004230ec:
    # block 0x004230ec: entered by jmp at 0x004230e1, 2 instruction(s), ends with jge to 0x0042313e (forward)
    cmp dword ptr [ebp - local_4], 0x400         # 004230ec
    jge.d8 L_0042313e                            # 004230f3
    # block 0x004230f5: entered by fall-through of jge at 0x004230f3, 8 instruction(s), ends with je to 0x00423135 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004230f5
    mov edx, dword ptr [ebp - local_10]          # 004230f8
    mov eax, dword ptr [edx + 4*ecx]             # 004230fb
    mov dword ptr [ebp - local_c], eax           # 004230fe
    mov ecx, dword ptr [ebp - local_c]           # 00423101
    mov dword ptr [ebp - local_8], ecx           # 00423104
    cmp dword ptr [ebp - local_8], 0x0           # 00423107
    je.d8 L_00423135                             # 0042310b
    # block 0x0042310d: entered by fall-through of je at 0x0042310b, 6 instruction(s), calls FUN_00423021, ends with je to 0x0042312d (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0042310d
    call FUN_00423021                            # 00423110
    mov edx, 0x1                                 # 00423115
    and edx, 0x1                                 # 0042311a
    test edx, edx                                # 0042311d
    je.d8 L_0042312d                             # 0042311f
    # block 0x00423121: entered by fall-through of je at 0x0042311f, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0042312d
    mov eax, dword ptr [ebp - local_8]           # 00423121
    push eax                                     # 00423124
    call FUN_0051dc6c                            # 00423125
    add esp, 0x4                                 # 0042312a
L_0042312d:
    # block 0x0042312d: entered by je at 0x0042311f, 3 instruction(s), ends with forward jump to 0x0042313c
    mov ecx, dword ptr [ebp - local_8]           # 0042312d
    mov dword ptr [ebp - local_14], ecx          # 00423130
    jmp.d8 L_0042313c                            # 00423133
L_00423135:
    # block 0x00423135: entered by je at 0x0042310b, 1 instruction(s), falls into the block at 0x0042313c
    mov dword ptr [ebp - local_14], 0x0          # 00423135
L_0042313c:
    # block 0x0042313c: entered by jmp at 0x00423133, 1 instruction(s), ends with backward jump to 0x004230e3
    jmp.d8 L_004230e3                            # 0042313c
L_0042313e:
    # block 0x0042313e: entered by jge at 0x004230f3, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0042313e
    pop ebp                                      # 00423140
    ret                                          # 00423141

