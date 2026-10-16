# FUN_00401add
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401add
# extent:       0x00401add-0x00401afa (29 code bytes)
# span:         0x00401add-0x00401afa (code 29, tables 0, padding 0)
# sha256:       159d18d7629cfd3002c82693205543a0a1e688dc2300547b2874e2c150b8eb50
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401add
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401526
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00401526, .text + (0x00401526 - 0x401000)

.org 0x00401add - 0x401000
.globl FUN_00401add
FUN_00401add:
    # block 0x00401add: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401add
    {load} mov ebp, esp                          # 00401ade
    push ecx                                     # 00401ae0
    mov dword ptr [ebp - local_4], ecx           # 00401ae1
    mov dword ptr [0x569138], 0x26               # 00401ae4
    mov ecx, dword ptr [ebp - local_4]           # 00401aee
    call FUN_00401526                            # 00401af1
    {load} mov esp, ebp                          # 00401af6
    pop ebp                                      # 00401af8
    ret                                          # 00401af9

