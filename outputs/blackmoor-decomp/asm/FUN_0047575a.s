# FUN_0047575a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047575a
# extent:       0x0047575a-0x0047576a (16 code bytes)
# span:         0x0047575a-0x0047576a (code 16, tables 0, padding 0)
# sha256:       921ba3722b8048914b4e7ba70b5addc9a876dccd19fa2de7026592b526d12edf
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047575a
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

.org 0x0047575a - 0x401000
.globl FUN_0047575a
FUN_0047575a:
    # block 0x0047575a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0047575a
    {load} mov ebp, esp                          # 0047575b
    push ecx                                     # 0047575d
    mov dword ptr [ebp - local_4], ecx           # 0047575e
    mov eax, 0x52d458                            # 00475761
    {load} mov esp, ebp                          # 00475766
    pop ebp                                      # 00475768
    ret                                          # 00475769

