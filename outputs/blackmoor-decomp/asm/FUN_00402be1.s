# FUN_00402be1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402be1
# extent:       0x00402be1-0x00402c28 (71 code bytes)
# span:         0x00402be1-0x00402c28 (code 71, tables 0, padding 0)
# sha256:       42c7f757a988629903f8481889dc7313fe4df2f48a12578532183b48d35d8f77
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00402be1
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

.org 0x00402be1 - 0x401000
.globl FUN_00402be1
FUN_00402be1:
    # block 0x00402be1: entry, 8 instruction(s), ends with jne to 0x00402c0b (forward)
    push ebp                                     # 00402be1
    {load} mov ebp, esp                          # 00402be2
    push ecx                                     # 00402be4
    mov dword ptr [ebp - local_4], ecx           # 00402be5
    mov eax, dword ptr [ebp - local_4]           # 00402be8
    mov ecx, dword ptr [eax + field_5c]          # 00402beb
    cmp dword ptr [4*ecx + 0x5e60fa], 0x1        # 00402bee
    jne.d8 L_00402c0b                            # 00402bf6
    # block 0x00402bf8: entered by fall-through of jne at 0x00402bf6, 4 instruction(s), ends with forward jump to 0x00402c1c
    mov edx, dword ptr [ebp - local_4]           # 00402bf8
    mov eax, dword ptr [edx + field_5c]          # 00402bfb
    mov dword ptr [4*eax + 0x5e60fa], 0x0        # 00402bfe
    jmp.d8 L_00402c1c                            # 00402c09
L_00402c0b:
    # block 0x00402c0b: entered by jne at 0x00402bf6, 3 instruction(s), falls into the block at 0x00402c1c
    mov ecx, dword ptr [ebp - local_4]           # 00402c0b
    mov edx, dword ptr [ecx + field_5c]          # 00402c0e
    mov dword ptr [4*edx + 0x5e60fa], 0x1        # 00402c11
L_00402c1c:
    # block 0x00402c1c: entered by jmp at 0x00402c09, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402c1c
    call FUN_0040236a                            # 00402c1f
    {load} mov esp, ebp                          # 00402c24
    pop ebp                                      # 00402c26
    ret                                          # 00402c27

