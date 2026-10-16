# FUN_00516d7d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516d7d
# extent:       0x00516d7d-0x00516daa (45 code bytes)
# span:         0x00516d7d-0x00516daa (code 45, tables 0, padding 0)
# sha256:       b0503cca4d9b285176c369fa46e68595c1de29b68cd7112e07b894d910c66d77
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516d7d
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00516f69, FUN_00516d51
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
.set FUN_00516d51, .text + (0x00516d51 - 0x401000)
.set FUN_00516f69, .text + (0x00516f69 - 0x401000)

.org 0x00516d7d - 0x401000
.globl FUN_00516d7d
FUN_00516d7d:
    # block 0x00516d7d: entry, 21 instruction(s), calls FUN_00516f69, FUN_00516d51, ends with ret
    push ebp                                     # 00516d7d
    {load} mov ebp, esp                          # 00516d7e
    sub esp, 0xc                                 # 00516d80
    {load} xor eax, eax                          # 00516d83
    push eax                                     # 00516d85
    push eax                                     # 00516d86
    push eax                                     # 00516d87
    push eax                                     # 00516d88
    push dword ptr [ebp + arg_c]                 # 00516d89
    lea eax, [ebp + arg_c]                       # 00516d8c
    push eax                                     # 00516d8f
    lea eax, [ebp - local_c]                     # 00516d90
    push eax                                     # 00516d93
    call FUN_00516f69                            # 00516d94
    push dword ptr [ebp + arg_8]                 # 00516d99
    lea eax, [ebp - local_c]                     # 00516d9c
    push eax                                     # 00516d9f
    call FUN_00516d51                            # 00516da0
    add esp, 0x24                                # 00516da5
    leave                                        # 00516da8
    ret                                          # 00516da9

