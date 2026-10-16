# FUN_00460f16
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00460f16
# extent:       0x00460f16-0x00460f26 (16 code bytes)
# span:         0x00460f16-0x00460f26 (code 16, tables 0, padding 0)
# sha256:       01886c3a80755602c3e7ab5440638401f6db9bfb7f08f3bdb2757a3152dafabc
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00460f16
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

.org 0x00460f16 - 0x401000
.globl FUN_00460f16
FUN_00460f16:
    # block 0x00460f16: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00460f16
    {load} mov ebp, esp                          # 00460f17
    push ecx                                     # 00460f19
    mov dword ptr [ebp - local_4], ecx           # 00460f1a
    mov eax, 0x52cfd8                            # 00460f1d
    {load} mov esp, ebp                          # 00460f22
    pop ebp                                      # 00460f24
    ret                                          # 00460f25

