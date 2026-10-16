# FUN_00516daa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516daa
# extent:       0x00516daa-0x00516dd7 (45 code bytes)
# span:         0x00516daa-0x00516dd7 (code 45, tables 0, padding 0)
# sha256:       fc3c7adc398dae82b24185ed92447bdcbc127b5db3557cd97c0c7775c4c58a0e
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516daa
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00516f69, FUN_00516d67
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00516d67, .text + (0x00516d67 - 0x401000)
.set FUN_00516f69, .text + (0x00516f69 - 0x401000)

.org 0x00516daa - 0x401000
.globl FUN_00516daa
FUN_00516daa:
    # block 0x00516daa: entry, 21 instruction(s), calls FUN_00516f69, FUN_00516d67, ends with ret
    push ebp                                     # 00516daa
    {load} mov ebp, esp                          # 00516dab
    sub esp, 0xc                                 # 00516dad
    {load} xor eax, eax                          # 00516db0
    push eax                                     # 00516db2
    push eax                                     # 00516db3
    push eax                                     # 00516db4
    push eax                                     # 00516db5
    push dword ptr [ebp + arg_c]                 # 00516db6
    lea eax, [ebp + arg_c]                       # 00516db9
    push eax                                     # 00516dbc
    lea eax, [ebp - local_c]                     # 00516dbd
    push eax                                     # 00516dc0
    call FUN_00516f69                            # 00516dc1
    push dword ptr [ebp + arg_8]                 # 00516dc6
    lea eax, [ebp - local_c]                     # 00516dc9
    push eax                                     # 00516dcc
    call FUN_00516d67                            # 00516dcd
    add esp, 0x24                                # 00516dd2
    leave                                        # 00516dd5
    ret                                          # 00516dd6

