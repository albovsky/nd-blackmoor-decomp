# FUN_0048cfe7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048cfe7
# extent:       0x0048cfe7-0x0048cff7 (16 code bytes)
# span:         0x0048cfe7-0x0048cff7 (code 16, tables 0, padding 0)
# sha256:       4ba6becd79932e00f14a15e61c6f719b0c78ff2072a5d262c6bacbe81399cdc0
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048cfe7
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

.org 0x0048cfe7 - 0x401000
.globl FUN_0048cfe7
FUN_0048cfe7:
    # block 0x0048cfe7: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0048cfe7
    {load} mov ebp, esp                          # 0048cfe8
    push ecx                                     # 0048cfea
    mov dword ptr [ebp - local_4], ecx           # 0048cfeb
    mov eax, 0x52d9b0                            # 0048cfee
    {load} mov esp, ebp                          # 0048cff3
    pop ebp                                      # 0048cff5
    ret                                          # 0048cff6

