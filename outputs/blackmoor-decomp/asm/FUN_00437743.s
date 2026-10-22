# FUN_00437743
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00437743
# extent:       0x00437743-0x00437774 (49 code bytes)
# span:         0x00437743-0x00437774 (code 49, tables 0, padding 0)
# sha256:       d1babff567716e463385b81509371098c549c3159b6d07eb18fe5540bbe64454
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00437743
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ecx + n] field_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m437710_init_vtable_call_ret_self (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00437743 - 0x401000
.globl FUN_00437743
FUN_00437743:
    # block 0x00437743: entry, 6 instruction(s), ends with forward jump to 0x0043775e
    push ebp                                     # 00437743
    {load} mov ebp, esp                          # 00437744
    sub esp, 0x8                                 # 00437746
    mov dword ptr [ebp - local_8], ecx           # 00437749
    mov dword ptr [ebp - local_4], 0x0           # 0043774c
    jmp.d8 L_0043775e                            # 00437753
L_00437755:
    # block 0x00437755: entered by jmp at 0x0043776e, 3 instruction(s), falls into the block at 0x0043775e
    mov eax, dword ptr [ebp - local_4]           # 00437755
    add eax, 0x1                                 # 00437758
    mov dword ptr [ebp - local_4], eax           # 0043775b
L_0043775e:
    # block 0x0043775e: entered by jmp at 0x00437753, 2 instruction(s), ends with jge to 0x00437770 (forward)
    cmp dword ptr [ebp - local_4], 0x29          # 0043775e
    jge.d8 L_00437770                            # 00437762
    # block 0x00437764: entered by fall-through of jge at 0x00437762, 4 instruction(s), ends with backward jump to 0x00437755
    mov ecx, dword ptr [ebp - local_8]           # 00437764
    add ecx, dword ptr [ebp - local_4]           # 00437767
    mov byte ptr [ecx + field_4], 0x0            # 0043776a
    jmp.d8 L_00437755                            # 0043776e
L_00437770:
    # block 0x00437770: entered by jge at 0x00437762, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00437770
    pop ebp                                      # 00437772
    ret                                          # 00437773

