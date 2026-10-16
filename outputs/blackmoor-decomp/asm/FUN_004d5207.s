# FUN_004d5207
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d5207
# extent:       0x004d5207-0x004d5224 (29 code bytes)
# span:         0x004d5207-0x004d5230 (code 29, tables 0, padding 12)
# sha256:       efe655604fedeaf374129443d489d84fe202d391e69e4002074c3cbfb00f4db7
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d5207
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051e446
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051e446, .text + (0x0051e446 - 0x401000)

.org 0x004d5207 - 0x401000
.globl FUN_004d5207
FUN_004d5207:
    # block 0x004d5207: entry, 10 instruction(s), calls FUN_0051e446, ends with ret
    push ebp                                     # 004d5207
    {load} mov ebp, esp                          # 004d5208
    push ecx                                     # 004d520a
    mov dword ptr [ebp - local_4], ecx           # 004d520b
    mov dword ptr [0x5bb1c6], 0x1                # 004d520e
    mov ecx, dword ptr [ebp - local_4]           # 004d5218
    call FUN_0051e446                            # 004d521b
    {load} mov esp, ebp                          # 004d5220
    pop ebp                                      # 004d5222
    ret                                          # 004d5223

# --- data items (not part of the function) -------------------------
.org 0x004d5224 - 0x401000
PAD_004d5224:  # 12 byte(s) of int3 padding
    .fill 12, 1, 0xcc

