# FUN_0048bafb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048bafb
# extent:       0x0048bafb-0x0048bb17 (28 code bytes)
# span:         0x0048bafb-0x0048bb17 (code 28, tables 0, padding 0)
# sha256:       cb7f75c30e3bce2c26cf9f09a6297f918596e365e72ab5ac76c55edec0d1159b
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048bafb
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0048bafb - 0x401000
.globl FUN_0048bafb
FUN_0048bafb:
    # block 0x0048bafb: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0048bafb
    {load} mov ebp, esp                          # 0048bafc
    push ecx                                     # 0048bafe
    mov dword ptr [ebp - local_4], ecx           # 0048baff
    mov eax, dword ptr [ebp - local_4]           # 0048bb02
    mov dword ptr [eax], 0x52d960                # 0048bb05
    mov ecx, dword ptr [ebp - local_4]           # 0048bb0b
    call FUN_0051d730                            # 0048bb0e
    {load} mov esp, ebp                          # 0048bb13
    pop ebp                                      # 0048bb15
    ret                                          # 0048bb16

