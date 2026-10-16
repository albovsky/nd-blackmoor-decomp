# FUN_00401afa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401afa
# extent:       0x00401afa-0x00401b17 (29 code bytes)
# span:         0x00401afa-0x00401b17 (code 29, tables 0, padding 0)
# sha256:       41a5c4c68d019113c27699666da7640570f36fb9f37b6cf33d2a557fab30f0a4
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401afa
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

.org 0x00401afa - 0x401000
.globl FUN_00401afa
FUN_00401afa:
    # block 0x00401afa: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401afa
    {load} mov ebp, esp                          # 00401afb
    push ecx                                     # 00401afd
    mov dword ptr [ebp - local_4], ecx           # 00401afe
    mov dword ptr [0x569138], 0x27               # 00401b01
    mov ecx, dword ptr [ebp - local_4]           # 00401b0b
    call FUN_00401526                            # 00401b0e
    {load} mov esp, ebp                          # 00401b13
    pop ebp                                      # 00401b15
    ret                                          # 00401b16

