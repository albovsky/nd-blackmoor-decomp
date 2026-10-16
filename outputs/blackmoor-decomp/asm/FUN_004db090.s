# FUN_004db090
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db090
# extent:       0x004db090-0x004db0d6 (70 code bytes)
# span:         0x004db090-0x004db0d6 (code 70, tables 0, padding 0)
# sha256:       ff778fa18523e7938c7ff0a59669c0a59712c43f4d5fdb7c31643255db3a79a3
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004db090
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_10; [ecx + n] field_4, field_c; [edx + n] field_10
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x004db090 - 0x401000
.globl FUN_004db090
FUN_004db090:
    # block 0x004db090: entry, 6 instruction(s), ends with je to 0x004db0b3 (forward)
    push ebp                                     # 004db090
    {load} mov ebp, esp                          # 004db091
    push ecx                                     # 004db093
    mov dword ptr [ebp - local_4], ecx           # 004db094
    cmp dword ptr [0x5c39e5], -0x1               # 004db097
    je.d8 L_004db0b3                             # 004db09e
    # block 0x004db0a0: entered by fall-through of je at 0x004db09e, 3 instruction(s), ends with jne to 0x004db0b3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004db0a0
    cmp dword ptr [eax + field_4], 0x0           # 004db0a3
    jne.d8 L_004db0b3                            # 004db0a7
    # block 0x004db0a9: entered by fall-through of jne at 0x004db0a7, 2 instruction(s), falls into the block at 0x004db0b3
    mov ecx, dword ptr [ebp - local_4]           # 004db0a9
    mov dword ptr [ecx + field_4], 0x1           # 004db0ac
L_004db0b3:
    # block 0x004db0b3: entered by je at 0x004db09e; jne at 0x004db0a7, 3 instruction(s), ends with jne to 0x004db0c6 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004db0b3
    cmp dword ptr [edx + field_10], 0x1          # 004db0b6
    jne.d8 L_004db0c6                            # 004db0ba
    # block 0x004db0bc: entered by fall-through of jne at 0x004db0ba, 2 instruction(s), falls into the block at 0x004db0c6
    mov eax, dword ptr [ebp - local_4]           # 004db0bc
    mov dword ptr [eax + field_10], 0x2          # 004db0bf
L_004db0c6:
    # block 0x004db0c6: entered by jne at 0x004db0ba, 5 instruction(s), ends with ret 0x8
    mov ecx, dword ptr [ebp - local_4]           # 004db0c6
    mov dword ptr [ecx + field_c], 0x0           # 004db0c9
    {load} mov esp, ebp                          # 004db0d0
    pop ebp                                      # 004db0d2
    ret 0x8                                      # 004db0d3

