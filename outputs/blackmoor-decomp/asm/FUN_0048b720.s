# FUN_0048b720
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048b720
# extent:       0x0048b720-0x0048b730 (16 code bytes)
# span:         0x0048b720-0x0048b730 (code 16, tables 0, padding 0)
# sha256:       4dcb0b00016dcdf1c4fd09d196f1ceb077c4892faac4b7c8db75b5b00bdc2af0
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048b720
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

.org 0x0048b720 - 0x401000
.globl FUN_0048b720
FUN_0048b720:
    # block 0x0048b720: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0048b720
    {load} mov ebp, esp                          # 0048b721
    push ecx                                     # 0048b723
    mov dword ptr [ebp - local_4], ecx           # 0048b724
    mov eax, 0x52d8b8                            # 0048b727
    {load} mov esp, ebp                          # 0048b72c
    pop ebp                                      # 0048b72e
    ret                                          # 0048b72f

