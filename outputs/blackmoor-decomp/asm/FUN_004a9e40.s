# FUN_004a9e40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a9e40
# extent:       0x004a9e40-0x004a9ea7 (103 code bytes)
# span:         0x004a9e40-0x004a9ea7 (code 103, tables 0, padding 0)
# sha256:       e10f012d0638b9786a0bb7f7c3a84dd8cbd3b57e0c4f3bd210982f96fbb456f2
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a9e40
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004a9eb7
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
.set FUN_004a9eb7, .text + (0x004a9eb7 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004a9e40 - 0x401000
.globl FUN_004a9e40
FUN_004a9e40:
    # block 0x004a9e40: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004a9e82 (forward)
    push ebp                                     # 004a9e40
    {load} mov ebp, esp                          # 004a9e41
    push -0x1                                    # 004a9e43
    push 0x52864a                                # 004a9e45
    mov eax, dword ptr fs:[0x0]                  # 004a9e4a
    push eax                                     # 004a9e50
    mov dword ptr fs:[0x0], esp                  # 004a9e51
    sub esp, 0xc                                 # 004a9e58
    push 0x4a                                    # 004a9e5b
    call FUN_0051dc43                            # 004a9e5d
    add esp, 0x4                                 # 004a9e62
    mov dword ptr [ebp - local_14], eax          # 004a9e65
    mov dword ptr [ebp - local_4], 0x0           # 004a9e68
    cmp dword ptr [ebp - local_14], 0x0          # 004a9e6f
    je.d8 L_004a9e82                             # 004a9e73
    # block 0x004a9e75: entered by fall-through of je at 0x004a9e73, 4 instruction(s), calls FUN_004a9eb7, ends with forward jump to 0x004a9e89
    mov ecx, dword ptr [ebp - local_14]          # 004a9e75
    call FUN_004a9eb7                            # 004a9e78
    mov dword ptr [ebp - local_18], eax          # 004a9e7d
    jmp.d8 L_004a9e89                            # 004a9e80
L_004a9e82:
    # block 0x004a9e82: entered by je at 0x004a9e73, 1 instruction(s), falls into the block at 0x004a9e89
    mov dword ptr [ebp - local_18], 0x0          # 004a9e82
L_004a9e89:
    # block 0x004a9e89: entered by jmp at 0x004a9e80, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004a9e89
    mov dword ptr [ebp - local_10], eax          # 004a9e8c
    mov dword ptr [ebp - local_4], 0xffffffff    # 004a9e8f
    mov eax, dword ptr [ebp - local_10]          # 004a9e96
    mov ecx, dword ptr [ebp - local_c]           # 004a9e99
    mov dword ptr fs:[0x0], ecx                  # 004a9e9c
    {load} mov esp, ebp                          # 004a9ea3
    pop ebp                                      # 004a9ea5
    ret                                          # 004a9ea6

