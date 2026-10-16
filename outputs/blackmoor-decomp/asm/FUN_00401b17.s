# FUN_00401b17
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401b17
# extent:       0x00401b17-0x00401b34 (29 code bytes)
# span:         0x00401b17-0x00401b34 (code 29, tables 0, padding 0)
# sha256:       45bc9ef63dc3cd36812a61c514d02bd5d23f4d959ec2bd8696e504d00376be4a
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401b17
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

.org 0x00401b17 - 0x401000
.globl FUN_00401b17
FUN_00401b17:
    # block 0x00401b17: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401b17
    {load} mov ebp, esp                          # 00401b18
    push ecx                                     # 00401b1a
    mov dword ptr [ebp - local_4], ecx           # 00401b1b
    mov dword ptr [0x569138], 0x28               # 00401b1e
    mov ecx, dword ptr [ebp - local_4]           # 00401b28
    call FUN_00401526                            # 00401b2b
    {load} mov esp, ebp                          # 00401b30
    pop ebp                                      # 00401b32
    ret                                          # 00401b33

