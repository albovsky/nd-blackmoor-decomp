# FUN_0046401a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046401a
# extent:       0x0046401a-0x0046402e (20 code bytes)
# span:         0x0046401a-0x0046402e (code 20, tables 0, padding 0)
# sha256:       3e6b20f61b04824c1e68d16185307e48a714a3d1b627ee407c309ed65f26dd16
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046401a
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

.org 0x0046401a - 0x401000
.globl FUN_0046401a
FUN_0046401a:
    # block 0x0046401a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0046401a
    {load} mov ebp, esp                          # 0046401b
    push ecx                                     # 0046401d
    mov dword ptr [ebp - local_4], ecx           # 0046401e
    mov word ptr [0x5a0543], 0x0                 # 00464021
    {load} mov esp, ebp                          # 0046402a
    pop ebp                                      # 0046402c
    ret                                          # 0046402d

