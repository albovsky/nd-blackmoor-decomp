# FUN_00401c70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401c70
# extent:       0x00401c70-0x00401c83 (19 code bytes)
# span:         0x00401c70-0x00401c90 (code 19, tables 0, padding 13)
# sha256:       d9dada6d6732ba188eca1262bb653fa46e271844d5f3af4c92d172b29c96b43a
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401c70
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051de13
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051de13, .text + (0x0051de13 - 0x401000)

.org 0x00401c70 - 0x401000
.globl FUN_00401c70
FUN_00401c70:
    # block 0x00401c70: entry, 9 instruction(s), calls FUN_0051de13, ends with ret
    push ebp                                     # 00401c70
    {load} mov ebp, esp                          # 00401c71
    push ecx                                     # 00401c73
    mov dword ptr [ebp - local_4], ecx           # 00401c74
    mov ecx, dword ptr [ebp - local_4]           # 00401c77
    call FUN_0051de13                            # 00401c7a
    {load} mov esp, ebp                          # 00401c7f
    pop ebp                                      # 00401c81
    ret                                          # 00401c82

# --- data items (not part of the function) -------------------------
.org 0x00401c83 - 0x401000
PAD_00401c83:  # 13 byte(s) of int3 padding
    .fill 13, 1, 0xcc

