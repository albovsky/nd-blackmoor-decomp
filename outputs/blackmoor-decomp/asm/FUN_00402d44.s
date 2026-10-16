# FUN_00402d44
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402d44
# extent:       0x00402d44-0x00402d8b (71 code bytes)
# span:         0x00402d44-0x00402d8b (code 71, tables 0, padding 0)
# sha256:       063522a62547046e62db56f439dfbcb569fed39a5ec13263cc72500350e2e28e
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00402d44
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

.org 0x00402d44 - 0x401000
.globl FUN_00402d44
FUN_00402d44:
    # block 0x00402d44: entry, 8 instruction(s), ends with jne to 0x00402d6e (forward)
    push ebp                                     # 00402d44
    {load} mov ebp, esp                          # 00402d45
    push ecx                                     # 00402d47
    mov dword ptr [ebp - local_4], ecx           # 00402d48
    mov eax, dword ptr [ebp - local_4]           # 00402d4b
    mov ecx, dword ptr [eax + field_5c]          # 00402d4e
    cmp dword ptr [4*ecx + 0x5e610e], 0x1        # 00402d51
    jne.d8 L_00402d6e                            # 00402d59
    # block 0x00402d5b: entered by fall-through of jne at 0x00402d59, 4 instruction(s), ends with forward jump to 0x00402d7f
    mov edx, dword ptr [ebp - local_4]           # 00402d5b
    mov eax, dword ptr [edx + field_5c]          # 00402d5e
    mov dword ptr [4*eax + 0x5e610e], 0x0        # 00402d61
    jmp.d8 L_00402d7f                            # 00402d6c
L_00402d6e:
    # block 0x00402d6e: entered by jne at 0x00402d59, 3 instruction(s), falls into the block at 0x00402d7f
    mov ecx, dword ptr [ebp - local_4]           # 00402d6e
    mov edx, dword ptr [ecx + field_5c]          # 00402d71
    mov dword ptr [4*edx + 0x5e610e], 0x1        # 00402d74
L_00402d7f:
    # block 0x00402d7f: entered by jmp at 0x00402d6c, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402d7f
    call FUN_0040236a                            # 00402d82
    {load} mov esp, ebp                          # 00402d87
    pop ebp                                      # 00402d89
    ret                                          # 00402d8a

