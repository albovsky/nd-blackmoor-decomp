# FUN_0044af20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044af20
# extent:       0x0044af20-0x0044af33 (19 code bytes)
# span:         0x0044af20-0x0044af40 (code 19, tables 0, padding 13)
# sha256:       a43193c0aa63c2d652509b87434ddb08b679f83c3357bea59c793a72f51791da
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044af20
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

.org 0x0044af20 - 0x401000
.globl FUN_0044af20
FUN_0044af20:
    # block 0x0044af20: entry, 9 instruction(s), calls FUN_0051de13, ends with ret
    push ebp                                     # 0044af20
    {load} mov ebp, esp                          # 0044af21
    push ecx                                     # 0044af23
    mov dword ptr [ebp - local_4], ecx           # 0044af24
    mov ecx, dword ptr [ebp - local_4]           # 0044af27
    call FUN_0051de13                            # 0044af2a
    {load} mov esp, ebp                          # 0044af2f
    pop ebp                                      # 0044af31
    ret                                          # 0044af32

# --- data items (not part of the function) -------------------------
.org 0x0044af33 - 0x401000
PAD_0044af33:  # 13 byte(s) of int3 padding
    .fill 13, 1, 0xcc

