# FUN_0044af40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044af40
# extent:       0x0044af40-0x0044afa7 (103 code bytes)
# span:         0x0044af40-0x0044afa7 (code 103, tables 0, padding 0)
# sha256:       118416a86690e7d81791547aaad70a3a9d9e129719296548592faf87fcd7fc4a
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044af40
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0044afb7
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
.set FUN_0044afb7, .text + (0x0044afb7 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0044af40 - 0x401000
.globl FUN_0044af40
FUN_0044af40:
    # block 0x0044af40: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0044af82 (forward)
    push ebp                                     # 0044af40
    {load} mov ebp, esp                          # 0044af41
    push -0x1                                    # 0044af43
    push 0x527f7a                                # 0044af45
    mov eax, dword ptr fs:[0x0]                  # 0044af4a
    push eax                                     # 0044af50
    mov dword ptr fs:[0x0], esp                  # 0044af51
    sub esp, 0xc                                 # 0044af58
    push 0x1e                                    # 0044af5b
    call FUN_0051dc43                            # 0044af5d
    add esp, 0x4                                 # 0044af62
    mov dword ptr [ebp - local_14], eax          # 0044af65
    mov dword ptr [ebp - local_4], 0x0           # 0044af68
    cmp dword ptr [ebp - local_14], 0x0          # 0044af6f
    je.d8 L_0044af82                             # 0044af73
    # block 0x0044af75: entered by fall-through of je at 0x0044af73, 4 instruction(s), calls FUN_0044afb7, ends with forward jump to 0x0044af89
    mov ecx, dword ptr [ebp - local_14]          # 0044af75
    call FUN_0044afb7                            # 0044af78
    mov dword ptr [ebp - local_18], eax          # 0044af7d
    jmp.d8 L_0044af89                            # 0044af80
L_0044af82:
    # block 0x0044af82: entered by je at 0x0044af73, 1 instruction(s), falls into the block at 0x0044af89
    mov dword ptr [ebp - local_18], 0x0          # 0044af82
L_0044af89:
    # block 0x0044af89: entered by jmp at 0x0044af80, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0044af89
    mov dword ptr [ebp - local_10], eax          # 0044af8c
    mov dword ptr [ebp - local_4], 0xffffffff    # 0044af8f
    mov eax, dword ptr [ebp - local_10]          # 0044af96
    mov ecx, dword ptr [ebp - local_c]           # 0044af99
    mov dword ptr fs:[0x0], ecx                  # 0044af9c
    {load} mov esp, ebp                          # 0044afa3
    pop ebp                                      # 0044afa5
    ret                                          # 0044afa6

