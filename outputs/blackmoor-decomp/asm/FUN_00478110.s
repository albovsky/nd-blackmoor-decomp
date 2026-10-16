# FUN_00478110
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00478110
# extent:       0x00478110-0x0047817a (106 code bytes)
# span:         0x00478110-0x0047817a (code 106, tables 0, padding 0)
# sha256:       0a5242a5ebfc90f793d24447637fd1c20be9d20ab70cb47b59729e16e5e8d679
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00478110
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0047818a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_0047818a, .text + (0x0047818a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00478110 - 0x401000
.globl FUN_00478110
FUN_00478110:
    # block 0x00478110: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00478155 (forward)
    push ebp                                     # 00478110
    {load} mov ebp, esp                          # 00478111
    push -0x1                                    # 00478113
    push 0x5282fa                                # 00478115
    mov eax, dword ptr fs:[0x0]                  # 0047811a
    push eax                                     # 00478120
    mov dword ptr fs:[0x0], esp                  # 00478121
    sub esp, 0xc                                 # 00478128
    push 0x15a0                                  # 0047812b
    call FUN_0051dc43                            # 00478130
    add esp, 0x4                                 # 00478135
    mov dword ptr [ebp - local_14], eax          # 00478138
    mov dword ptr [ebp - local_4], 0x0           # 0047813b
    cmp dword ptr [ebp - local_14], 0x0          # 00478142
    je.d8 L_00478155                             # 00478146
    # block 0x00478148: entered by fall-through of je at 0x00478146, 4 instruction(s), calls FUN_0047818a, ends with forward jump to 0x0047815c
    mov ecx, dword ptr [ebp - local_14]          # 00478148
    call FUN_0047818a                            # 0047814b
    mov dword ptr [ebp - local_18], eax          # 00478150
    jmp.d8 L_0047815c                            # 00478153
L_00478155:
    # block 0x00478155: entered by je at 0x00478146, 1 instruction(s), falls into the block at 0x0047815c
    mov dword ptr [ebp - local_18], 0x0          # 00478155
L_0047815c:
    # block 0x0047815c: entered by jmp at 0x00478153, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0047815c
    mov dword ptr [ebp - local_10], eax          # 0047815f
    mov dword ptr [ebp - local_4], 0xffffffff    # 00478162
    mov eax, dword ptr [ebp - local_10]          # 00478169
    mov ecx, dword ptr [ebp - local_c]           # 0047816c
    mov dword ptr fs:[0x0], ecx                  # 0047816f
    {load} mov esp, ebp                          # 00478176
    pop ebp                                      # 00478178
    ret                                          # 00478179

