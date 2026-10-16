# FUN_004c0f60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0f60
# extent:       0x004c0f60-0x004c0f70 (16 code bytes)
# span:         0x004c0f60-0x004c0f70 (code 16, tables 0, padding 0)
# sha256:       59917f598b2745b38f2b05c163ae4e171d7b2e41a594a0f0973755dc0cdb54de
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c0f60
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

.org 0x004c0f60 - 0x401000
.globl FUN_004c0f60
FUN_004c0f60:
    # block 0x004c0f60: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004c0f60
    {load} mov ebp, esp                          # 004c0f61
    push ecx                                     # 004c0f63
    mov dword ptr [ebp - local_4], ecx           # 004c0f64
    mov eax, 0x52e218                            # 004c0f67
    {load} mov esp, ebp                          # 004c0f6c
    pop ebp                                      # 004c0f6e
    ret                                          # 004c0f6f

