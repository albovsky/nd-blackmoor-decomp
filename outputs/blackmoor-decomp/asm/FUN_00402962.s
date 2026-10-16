# FUN_00402962
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402962
# extent:       0x00402962-0x004029a9 (71 code bytes)
# span:         0x00402962-0x004029a9 (code 71, tables 0, padding 0)
# sha256:       d8ad5e220707a0e970580b29004f615c817e3584049af495ac41d0fcaf66a3d7
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00402962
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

.org 0x00402962 - 0x401000
.globl FUN_00402962
FUN_00402962:
    # block 0x00402962: entry, 8 instruction(s), ends with jne to 0x0040298c (forward)
    push ebp                                     # 00402962
    {load} mov ebp, esp                          # 00402963
    push ecx                                     # 00402965
    mov dword ptr [ebp - local_4], ecx           # 00402966
    mov eax, dword ptr [ebp - local_4]           # 00402969
    mov ecx, dword ptr [eax + field_5c]          # 0040296c
    cmp dword ptr [4*ecx + 0x5e60d6], 0x1        # 0040296f
    jne.d8 L_0040298c                            # 00402977
    # block 0x00402979: entered by fall-through of jne at 0x00402977, 4 instruction(s), ends with forward jump to 0x0040299d
    mov edx, dword ptr [ebp - local_4]           # 00402979
    mov eax, dword ptr [edx + field_5c]          # 0040297c
    mov dword ptr [4*eax + 0x5e60d6], 0x0        # 0040297f
    jmp.d8 L_0040299d                            # 0040298a
L_0040298c:
    # block 0x0040298c: entered by jne at 0x00402977, 3 instruction(s), falls into the block at 0x0040299d
    mov ecx, dword ptr [ebp - local_4]           # 0040298c
    mov edx, dword ptr [ecx + field_5c]          # 0040298f
    mov dword ptr [4*edx + 0x5e60d6], 0x1        # 00402992
L_0040299d:
    # block 0x0040299d: entered by jmp at 0x0040298a, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0040299d
    call FUN_0040236a                            # 004029a0
    {load} mov esp, ebp                          # 004029a5
    pop ebp                                      # 004029a7
    ret                                          # 004029a8

