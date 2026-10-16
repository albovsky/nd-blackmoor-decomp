# FUN_0047df47
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047df47
# extent:       0x0047df47-0x0047df57 (16 code bytes)
# span:         0x0047df47-0x0047df57 (code 16, tables 0, padding 0)
# sha256:       911158c3959d5f72162307361e0b265babd15e9c44b32c62792b7079d59ef2ef
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047df47
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

.org 0x0047df47 - 0x401000
.globl FUN_0047df47
FUN_0047df47:
    # block 0x0047df47: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0047df47
    {load} mov ebp, esp                          # 0047df48
    push ecx                                     # 0047df4a
    mov dword ptr [ebp - local_4], ecx           # 0047df4b
    mov eax, 0x52d588                            # 0047df4e
    {load} mov esp, ebp                          # 0047df53
    pop ebp                                      # 0047df55
    ret                                          # 0047df56

