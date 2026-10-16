# FUN_00402f7c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402f7c
# extent:       0x00402f7c-0x00402fc3 (71 code bytes)
# span:         0x00402f7c-0x00402fc3 (code 71, tables 0, padding 0)
# sha256:       df898ac74ef9d4e71c71604fd68ed3306438ebb8ce4af5ff00c2488f1ddc9bab
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00402f7c
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0040236a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)

.org 0x00402f7c - 0x401000
.globl FUN_00402f7c
FUN_00402f7c:
    # block 0x00402f7c: entry, 8 instruction(s), ends with jne to 0x00402fa6 (forward)
    push ebp                                     # 00402f7c
    {load} mov ebp, esp                          # 00402f7d
    push ecx                                     # 00402f7f
    mov dword ptr [ebp - local_4], ecx           # 00402f80
    mov eax, dword ptr [ebp - local_4]           # 00402f83
    mov ecx, dword ptr [eax + field_5c]          # 00402f86
    cmp dword ptr [4*ecx + 0x5e612e], 0x1        # 00402f89
    jne.d8 L_00402fa6                            # 00402f91
    # block 0x00402f93: entered by fall-through of jne at 0x00402f91, 4 instruction(s), ends with forward jump to 0x00402fb7
    mov edx, dword ptr [ebp - local_4]           # 00402f93
    mov eax, dword ptr [edx + field_5c]          # 00402f96
    mov dword ptr [4*eax + 0x5e612e], 0x0        # 00402f99
    jmp.d8 L_00402fb7                            # 00402fa4
L_00402fa6:
    # block 0x00402fa6: entered by jne at 0x00402f91, 3 instruction(s), falls into the block at 0x00402fb7
    mov ecx, dword ptr [ebp - local_4]           # 00402fa6
    mov edx, dword ptr [ecx + field_5c]          # 00402fa9
    mov dword ptr [4*edx + 0x5e612e], 0x1        # 00402fac
L_00402fb7:
    # block 0x00402fb7: entered by jmp at 0x00402fa4, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402fb7
    call FUN_0040236a                            # 00402fba
    {load} mov esp, ebp                          # 00402fbf
    pop ebp                                      # 00402fc1
    ret                                          # 00402fc2

