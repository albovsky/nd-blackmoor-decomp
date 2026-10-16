# FUN_00402dd2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402dd2
# extent:       0x00402dd2-0x00402e19 (71 code bytes)
# span:         0x00402dd2-0x00402e19 (code 71, tables 0, padding 0)
# sha256:       25b4db6eaa917d5d9b83afd9827959f47f882c449f135b0f52b87108bd993fa0
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00402dd2
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

.org 0x00402dd2 - 0x401000
.globl FUN_00402dd2
FUN_00402dd2:
    # block 0x00402dd2: entry, 8 instruction(s), ends with jne to 0x00402dfc (forward)
    push ebp                                     # 00402dd2
    {load} mov ebp, esp                          # 00402dd3
    push ecx                                     # 00402dd5
    mov dword ptr [ebp - local_4], ecx           # 00402dd6
    mov eax, dword ptr [ebp - local_4]           # 00402dd9
    mov ecx, dword ptr [eax + field_5c]          # 00402ddc
    cmp dword ptr [4*ecx + 0x5e6116], 0x1        # 00402ddf
    jne.d8 L_00402dfc                            # 00402de7
    # block 0x00402de9: entered by fall-through of jne at 0x00402de7, 4 instruction(s), ends with forward jump to 0x00402e0d
    mov edx, dword ptr [ebp - local_4]           # 00402de9
    mov eax, dword ptr [edx + field_5c]          # 00402dec
    mov dword ptr [4*eax + 0x5e6116], 0x0        # 00402def
    jmp.d8 L_00402e0d                            # 00402dfa
L_00402dfc:
    # block 0x00402dfc: entered by jne at 0x00402de7, 3 instruction(s), falls into the block at 0x00402e0d
    mov ecx, dword ptr [ebp - local_4]           # 00402dfc
    mov edx, dword ptr [ecx + field_5c]          # 00402dff
    mov dword ptr [4*edx + 0x5e6116], 0x1        # 00402e02
L_00402e0d:
    # block 0x00402e0d: entered by jmp at 0x00402dfa, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402e0d
    call FUN_0040236a                            # 00402e10
    {load} mov esp, ebp                          # 00402e15
    pop ebp                                      # 00402e17
    ret                                          # 00402e18

