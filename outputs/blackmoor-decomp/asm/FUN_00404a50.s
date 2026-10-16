# FUN_00404a50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404a50
# extent:       0x00404a50-0x00404aba (106 code bytes)
# span:         0x00404a50-0x00404aba (code 106, tables 0, padding 0)
# sha256:       b5c54924cebe442ac0756c6954744a88a240590c58d96c564840646ca17077e1
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00404a50
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00404aca
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
.set FUN_00404aca, .text + (0x00404aca - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00404a50 - 0x401000
.globl FUN_00404a50
FUN_00404a50:
    # block 0x00404a50: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00404a95 (forward)
    push ebp                                     # 00404a50
    {load} mov ebp, esp                          # 00404a51
    push -0x1                                    # 00404a53
    push 0x526d2a                                # 00404a55
    mov eax, dword ptr fs:[0x0]                  # 00404a5a
    push eax                                     # 00404a60
    mov dword ptr fs:[0x0], esp                  # 00404a61
    sub esp, 0xc                                 # 00404a68
    push 0xde0                                   # 00404a6b
    call FUN_0051dc43                            # 00404a70
    add esp, 0x4                                 # 00404a75
    mov dword ptr [ebp - local_14], eax          # 00404a78
    mov dword ptr [ebp - local_4], 0x0           # 00404a7b
    cmp dword ptr [ebp - local_14], 0x0          # 00404a82
    je.d8 L_00404a95                             # 00404a86
    # block 0x00404a88: entered by fall-through of je at 0x00404a86, 4 instruction(s), calls FUN_00404aca, ends with forward jump to 0x00404a9c
    mov ecx, dword ptr [ebp - local_14]          # 00404a88
    call FUN_00404aca                            # 00404a8b
    mov dword ptr [ebp - local_18], eax          # 00404a90
    jmp.d8 L_00404a9c                            # 00404a93
L_00404a95:
    # block 0x00404a95: entered by je at 0x00404a86, 1 instruction(s), falls into the block at 0x00404a9c
    mov dword ptr [ebp - local_18], 0x0          # 00404a95
L_00404a9c:
    # block 0x00404a9c: entered by jmp at 0x00404a93, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00404a9c
    mov dword ptr [ebp - local_10], eax          # 00404a9f
    mov dword ptr [ebp - local_4], 0xffffffff    # 00404aa2
    mov eax, dword ptr [ebp - local_10]          # 00404aa9
    mov ecx, dword ptr [ebp - local_c]           # 00404aac
    mov dword ptr fs:[0x0], ecx                  # 00404aaf
    {load} mov esp, ebp                          # 00404ab6
    pop ebp                                      # 00404ab8
    ret                                          # 00404ab9

