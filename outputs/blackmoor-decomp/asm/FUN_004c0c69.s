# FUN_004c0c69
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0c69
# extent:       0x004c0c69-0x004c0c7d (20 code bytes)
# span:         0x004c0c69-0x004c0c7d (code 20, tables 0, padding 0)
# sha256:       2d01ffd9fae4e24d8e0992c6d99d46535dba02a16768ce5c96588e6913834838
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c0c69
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_24a
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_24a, 0x24a  # offset +0x24a

# --- external targets -----------------------------------------------

.org 0x004c0c69 - 0x401000
.globl FUN_004c0c69
FUN_004c0c69:
    # block 0x004c0c69: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004c0c69
    {load} mov ebp, esp                          # 004c0c6a
    push ecx                                     # 004c0c6c
    mov dword ptr [ebp - local_4], ecx           # 004c0c6d
    mov eax, dword ptr [ebp - local_4]           # 004c0c70
    mov eax, dword ptr [eax + field_24a]         # 004c0c73
    {load} mov esp, ebp                          # 004c0c79
    pop ebp                                      # 004c0c7b
    ret                                          # 004c0c7c

