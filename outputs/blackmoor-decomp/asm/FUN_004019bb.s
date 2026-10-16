# FUN_004019bb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004019bb
# extent:       0x004019bb-0x004019d8 (29 code bytes)
# span:         0x004019bb-0x004019d8 (code 29, tables 0, padding 0)
# sha256:       359db67c64fa1c6634678d2a31d831b6fe22e81e2ce2f7471eb427b7dff6fa60
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004019bb
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

.org 0x004019bb - 0x401000
.globl FUN_004019bb
FUN_004019bb:
    # block 0x004019bb: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 004019bb
    {load} mov ebp, esp                          # 004019bc
    push ecx                                     # 004019be
    mov dword ptr [ebp - local_4], ecx           # 004019bf
    mov dword ptr [0x569138], 0x1c               # 004019c2
    mov ecx, dword ptr [ebp - local_4]           # 004019cc
    call FUN_00401526                            # 004019cf
    {load} mov esp, ebp                          # 004019d4
    pop ebp                                      # 004019d6
    ret                                          # 004019d7

