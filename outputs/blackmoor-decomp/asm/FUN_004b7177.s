# FUN_004b7177
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7177
# extent:       0x004b7177-0x004b7187 (16 code bytes)
# span:         0x004b7177-0x004b7187 (code 16, tables 0, padding 0)
# sha256:       11f9b3e041a5945f96fa1eaaebad00f4cb8dfe098f1911567c5d9b18995f44b1
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b7177
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

.org 0x004b7177 - 0x401000
.globl FUN_004b7177
FUN_004b7177:
    # block 0x004b7177: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004b7177
    {load} mov ebp, esp                          # 004b7178
    push ecx                                     # 004b717a
    mov dword ptr [ebp - local_4], ecx           # 004b717b
    mov eax, 0x52e170                            # 004b717e
    {load} mov esp, ebp                          # 004b7183
    pop ebp                                      # 004b7185
    ret                                          # 004b7186

