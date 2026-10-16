# FUN_0051ac91
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ac91
# extent:       0x0051ac91-0x0051acc0 (47 code bytes)
# span:         0x0051ac91-0x0051acc0 (code 47, tables 0, padding 0)
# sha256:       5b0d70f44b50e47b779ef749750385a90df5031dd0738bd0ea9c7bf98d9e7ac5
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ac91
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051ac0b, FUN_0051aa23
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0051aa23, .text + (0x0051aa23 - 0x401000)
.set FUN_0051ac0b, .text + (0x0051ac0b - 0x401000)

.org 0x0051ac91 - 0x401000
.globl FUN_0051ac91
FUN_0051ac91:
    # block 0x0051ac91: entry, 4 instruction(s), ends with jne to 0x0051aca2 (forward)
    push ebp                                     # 0051ac91
    {load} mov ebp, esp                          # 0051ac92
    cmp dword ptr [ebp + arg_c], 0x360           # 0051ac94
    jne.d8 L_0051aca2                            # 0051ac9b
    # block 0x0051ac9d: entered by fall-through of jne at 0x0051ac9b, 3 instruction(s), ends with forward jump to 0x0051acbc
    push 0x1                                     # 0051ac9d
    pop eax                                      # 0051ac9f
    jmp.d8 L_0051acbc                            # 0051aca0
L_0051aca2:
    # block 0x0051aca2: entered by jne at 0x0051ac9b, 8 instruction(s), calls FUN_0051ac0b, FUN_0051aa23, falls into the block at 0x0051acbc
    push dword ptr [ebp + arg_8]                 # 0051aca2
    call FUN_0051ac0b                            # 0051aca5
    push dword ptr [ebp + arg_14]                # 0051acaa
    push dword ptr [ebp + arg_10]                # 0051acad
    push dword ptr [ebp + arg_c]                 # 0051acb0
    push dword ptr [ebp + arg_8]                 # 0051acb3
    push eax                                     # 0051acb6
    call FUN_0051aa23                            # 0051acb7
L_0051acbc:
    # block 0x0051acbc: entered by jmp at 0x0051aca0, 2 instruction(s), ends with ret 0x10
    pop ebp                                      # 0051acbc
    ret 0x10                                     # 0051acbd

