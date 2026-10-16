# FUN_00449d90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00449d90
# extent:       0x00449d90-0x00449dc7 (55 code bytes)
# span:         0x00449d90-0x00449dc7 (code 55, tables 0, padding 0)
# sha256:       c3ca6145390d9b2e1bc85660c49dc80a1485edf7e6d20b9cdff486f90057c172
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00449d90
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d0a9, FUN_0050cee4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)

.org 0x00449d90 - 0x401000
.globl FUN_00449d90
FUN_00449d90:
    # block 0x00449d90: entry, 11 instruction(s), calls FUN_0050d0a9, ends with jne to 0x00449db2 (forward)
    push ebp                                     # 00449d90
    {load} mov ebp, esp                          # 00449d91
    push ecx                                     # 00449d93
    push 0x548aac                                # 00449d94
    mov eax, dword ptr [ebp + arg_8]             # 00449d99
    push eax                                     # 00449d9c
    call FUN_0050d0a9                            # 00449d9d
    add esp, 0x8                                 # 00449da2
    mov dword ptr [ebp - local_4], eax           # 00449da5
    cmp dword ptr [ebp - local_4], 0x0           # 00449da8
    jne.d8 L_00449db2                            # 00449dac
    # block 0x00449dae: entered by fall-through of jne at 0x00449dac, 2 instruction(s), ends with forward jump to 0x00449dc3
    {load} xor eax, eax                          # 00449dae
    jmp.d8 L_00449dc3                            # 00449db0
L_00449db2:
    # block 0x00449db2: entered by jne at 0x00449dac, 5 instruction(s), calls FUN_0050cee4, falls into the block at 0x00449dc3
    mov ecx, dword ptr [ebp - local_4]           # 00449db2
    push ecx                                     # 00449db5
    call FUN_0050cee4                            # 00449db6
    add esp, 0x4                                 # 00449dbb
    mov eax, 0x1                                 # 00449dbe
L_00449dc3:
    # block 0x00449dc3: entered by jmp at 0x00449db0, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00449dc3
    pop ebp                                      # 00449dc5
    ret                                          # 00449dc6

