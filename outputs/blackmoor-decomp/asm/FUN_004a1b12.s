# FUN_004a1b12
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1b12
# extent:       0x004a1b12-0x004a1b22 (16 code bytes)
# span:         0x004a1b12-0x004a1b30 (code 16, tables 0, padding 14)
# sha256:       6945f2a79697c6ea1d0b7d6967b65184f504477679b4ae646fe50764436ce373
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a1b12
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004a1b12 - 0x401000
.globl FUN_004a1b12
FUN_004a1b12:
    # block 0x004a1b12: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004a1b12
    {load} mov ebp, esp                          # 004a1b13
    push ecx                                     # 004a1b15
    mov dword ptr [ebp - local_4], ecx           # 004a1b16
    mov eax, 0x52dba8                            # 004a1b19
    {load} mov esp, ebp                          # 004a1b1e
    pop ebp                                      # 004a1b20
    ret                                          # 004a1b21

# --- data items (not part of the function) -------------------------
.org 0x004a1b22 - 0x401000
PAD_004a1b22:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

