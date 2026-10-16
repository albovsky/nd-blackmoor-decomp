# FUN_00470a63
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470a63
# extent:       0x00470a63-0x00470a73 (16 code bytes)
# span:         0x00470a63-0x00470a73 (code 16, tables 0, padding 0)
# sha256:       5181de79d41756f9d93a098f93e1e53eea4353a320a440a6c88421567691b821
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00470a63
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

.org 0x00470a63 - 0x401000
.globl FUN_00470a63
FUN_00470a63:
    # block 0x00470a63: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00470a63
    {load} mov ebp, esp                          # 00470a64
    push ecx                                     # 00470a66
    mov dword ptr [ebp - local_4], ecx           # 00470a67
    mov eax, 0x52d350                            # 00470a6a
    {load} mov esp, ebp                          # 00470a6f
    pop ebp                                      # 00470a71
    ret                                          # 00470a72

