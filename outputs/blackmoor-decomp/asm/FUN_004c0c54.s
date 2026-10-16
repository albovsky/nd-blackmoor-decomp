# FUN_004c0c54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0c54
# extent:       0x004c0c54-0x004c0c69 (21 code bytes)
# span:         0x004c0c54-0x004c0c69 (code 21, tables 0, padding 0)
# sha256:       39ce18c9c72a1fc9d0abc69c1e31af56dfe458837e6f949505fd5c30450e867b
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c0c54
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_244
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_244, 0x244  # offset +0x244

# --- external targets -----------------------------------------------

.org 0x004c0c54 - 0x401000
.globl FUN_004c0c54
FUN_004c0c54:
    # block 0x004c0c54: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004c0c54
    {load} mov ebp, esp                          # 004c0c55
    push ecx                                     # 004c0c57
    mov dword ptr [ebp - local_4], ecx           # 004c0c58
    mov eax, dword ptr [ebp - local_4]           # 004c0c5b
    movsx eax, word ptr [eax + field_244]        # 004c0c5e
    {load} mov esp, ebp                          # 004c0c65
    pop ebp                                      # 004c0c67
    ret                                          # 004c0c68

