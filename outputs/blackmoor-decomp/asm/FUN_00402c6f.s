# FUN_00402c6f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402c6f
# extent:       0x00402c6f-0x00402cb6 (71 code bytes)
# span:         0x00402c6f-0x00402cb6 (code 71, tables 0, padding 0)
# sha256:       2c1b0a3bd20f58949fdb27ebbbf531b31d125a37bc7e9690fb69c9f87f3a3e8d
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00402c6f
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

.org 0x00402c6f - 0x401000
.globl FUN_00402c6f
FUN_00402c6f:
    # block 0x00402c6f: entry, 8 instruction(s), ends with jne to 0x00402c99 (forward)
    push ebp                                     # 00402c6f
    {load} mov ebp, esp                          # 00402c70
    push ecx                                     # 00402c72
    mov dword ptr [ebp - local_4], ecx           # 00402c73
    mov eax, dword ptr [ebp - local_4]           # 00402c76
    mov ecx, dword ptr [eax + field_5c]          # 00402c79
    cmp dword ptr [4*ecx + 0x5e6102], 0x1        # 00402c7c
    jne.d8 L_00402c99                            # 00402c84
    # block 0x00402c86: entered by fall-through of jne at 0x00402c84, 4 instruction(s), ends with forward jump to 0x00402caa
    mov edx, dword ptr [ebp - local_4]           # 00402c86
    mov eax, dword ptr [edx + field_5c]          # 00402c89
    mov dword ptr [4*eax + 0x5e6102], 0x0        # 00402c8c
    jmp.d8 L_00402caa                            # 00402c97
L_00402c99:
    # block 0x00402c99: entered by jne at 0x00402c84, 3 instruction(s), falls into the block at 0x00402caa
    mov ecx, dword ptr [ebp - local_4]           # 00402c99
    mov edx, dword ptr [ecx + field_5c]          # 00402c9c
    mov dword ptr [4*edx + 0x5e6102], 0x1        # 00402c9f
L_00402caa:
    # block 0x00402caa: entered by jmp at 0x00402c97, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402caa
    call FUN_0040236a                            # 00402cad
    {load} mov esp, ebp                          # 00402cb2
    pop ebp                                      # 00402cb4
    ret                                          # 00402cb5

