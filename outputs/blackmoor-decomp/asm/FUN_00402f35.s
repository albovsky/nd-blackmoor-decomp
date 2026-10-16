# FUN_00402f35
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402f35
# extent:       0x00402f35-0x00402f7c (71 code bytes)
# span:         0x00402f35-0x00402f7c (code 71, tables 0, padding 0)
# sha256:       ac099cffb9d861cd2ee0fa30579a2c4c50c09ec8a64a1634765c5319f5e6d81d
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00402f35
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

.org 0x00402f35 - 0x401000
.globl FUN_00402f35
FUN_00402f35:
    # block 0x00402f35: entry, 8 instruction(s), ends with jne to 0x00402f5f (forward)
    push ebp                                     # 00402f35
    {load} mov ebp, esp                          # 00402f36
    push ecx                                     # 00402f38
    mov dword ptr [ebp - local_4], ecx           # 00402f39
    mov eax, dword ptr [ebp - local_4]           # 00402f3c
    mov ecx, dword ptr [eax + field_5c]          # 00402f3f
    cmp dword ptr [4*ecx + 0x5e612a], 0x1        # 00402f42
    jne.d8 L_00402f5f                            # 00402f4a
    # block 0x00402f4c: entered by fall-through of jne at 0x00402f4a, 4 instruction(s), ends with forward jump to 0x00402f70
    mov edx, dword ptr [ebp - local_4]           # 00402f4c
    mov eax, dword ptr [edx + field_5c]          # 00402f4f
    mov dword ptr [4*eax + 0x5e612a], 0x0        # 00402f52
    jmp.d8 L_00402f70                            # 00402f5d
L_00402f5f:
    # block 0x00402f5f: entered by jne at 0x00402f4a, 3 instruction(s), falls into the block at 0x00402f70
    mov ecx, dword ptr [ebp - local_4]           # 00402f5f
    mov edx, dword ptr [ecx + field_5c]          # 00402f62
    mov dword ptr [4*edx + 0x5e612a], 0x1        # 00402f65
L_00402f70:
    # block 0x00402f70: entered by jmp at 0x00402f5d, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402f70
    call FUN_0040236a                            # 00402f73
    {load} mov esp, ebp                          # 00402f78
    pop ebp                                      # 00402f7a
    ret                                          # 00402f7b

