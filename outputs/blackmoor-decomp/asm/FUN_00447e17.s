# FUN_00447e17
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447e17
# extent:       0x00447e17-0x00447e27 (16 code bytes)
# span:         0x00447e17-0x00447e27 (code 16, tables 0, padding 0)
# sha256:       f42728428f8813446084505b8d1b868534d5c613652072f244460fbf34153fd0
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00447e17
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

.org 0x00447e17 - 0x401000
.globl FUN_00447e17
FUN_00447e17:
    # block 0x00447e17: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00447e17
    {load} mov ebp, esp                          # 00447e18
    push ecx                                     # 00447e1a
    mov dword ptr [ebp - local_4], ecx           # 00447e1b
    mov eax, 0x52cad0                            # 00447e1e
    {load} mov esp, ebp                          # 00447e23
    pop ebp                                      # 00447e25
    ret                                          # 00447e26

