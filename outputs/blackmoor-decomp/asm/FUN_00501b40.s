# FUN_00501b40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00501b40
# extent:       0x00501b40-0x00501b67 (39 code bytes)
# span:         0x00501b40-0x00501b70 (code 39, tables 0, padding 9)
# sha256:       fc6603fc76183a92b9eafefff4e5336650e406d54c55aef17dbca2a90ba040c8
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005019e0 (+0x160)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00501b40
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00501b40 - 0x401000
.globl FUN_00501b40
FUN_00501b40:
    # block 0x00501b40: entry, 12 instruction(s), ends with je to 0x00501b61 (forward)
    mov eax, dword ptr [esp + stk_4]             # 00501b40
    mov edx, dword ptr [esp + stk_8]             # 00501b44
    mov ecx, dword ptr [eax]                     # 00501b48
    mov eax, dword ptr [edx]                     # 00501b4a
    fld dword ptr [ecx]                          # 00501b4c
    fabs                                         # 00501b4e
    fld dword ptr [eax]                          # 00501b50
    fabs                                         # 00501b52
    fcompp                                       # 00501b54
    fnstsw ax                                    # 00501b56
    test ah, 0x1                                 # 00501b58
    je.d8 L_00501b61                             # 00501b5b
    # block 0x00501b5d: entered by fall-through of je at 0x00501b5b, 2 instruction(s), ends with ret
    or eax, -0x1                                 # 00501b5d
    ret                                          # 00501b60
L_00501b61:
    # block 0x00501b61: entered by je at 0x00501b5b, 2 instruction(s), ends with ret
    mov eax, 0x1                                 # 00501b61
    ret                                          # 00501b66

# --- data items (not part of the function) -------------------------
.org 0x00501b67 - 0x401000
PAD_00501b67:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

