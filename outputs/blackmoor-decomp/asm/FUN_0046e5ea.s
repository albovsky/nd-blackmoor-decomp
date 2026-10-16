# FUN_0046e5ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046e5ea
# extent:       0x0046e5ea-0x0046e5fa (16 code bytes)
# span:         0x0046e5ea-0x0046e5fa (code 16, tables 0, padding 0)
# sha256:       ffbb57e458e4f9c7e15dc4f8b8e32de7f6b21500e198ce51695595d6bf224b36
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046e5ea
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

.org 0x0046e5ea - 0x401000
.globl FUN_0046e5ea
FUN_0046e5ea:
    # block 0x0046e5ea: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0046e5ea
    {load} mov ebp, esp                          # 0046e5eb
    push ecx                                     # 0046e5ed
    mov dword ptr [ebp - local_4], ecx           # 0046e5ee
    mov eax, 0x52d338                            # 0046e5f1
    {load} mov esp, ebp                          # 0046e5f6
    pop ebp                                      # 0046e5f8
    ret                                          # 0046e5f9

