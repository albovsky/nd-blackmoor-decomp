# FUN_00402b0c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402b0c
# extent:       0x00402b0c-0x00402b53 (71 code bytes)
# span:         0x00402b0c-0x00402b53 (code 71, tables 0, padding 0)
# sha256:       656c41ac8014d7498645960c3e293b0eec48194dcd68f8a8c933f701b740ba5d
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00402b0c
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

.org 0x00402b0c - 0x401000
.globl FUN_00402b0c
FUN_00402b0c:
    # block 0x00402b0c: entry, 8 instruction(s), ends with jne to 0x00402b36 (forward)
    push ebp                                     # 00402b0c
    {load} mov ebp, esp                          # 00402b0d
    push ecx                                     # 00402b0f
    mov dword ptr [ebp - local_4], ecx           # 00402b10
    mov eax, dword ptr [ebp - local_4]           # 00402b13
    mov ecx, dword ptr [eax + field_5c]          # 00402b16
    cmp dword ptr [4*ecx + 0x5e60ee], 0x1        # 00402b19
    jne.d8 L_00402b36                            # 00402b21
    # block 0x00402b23: entered by fall-through of jne at 0x00402b21, 4 instruction(s), ends with forward jump to 0x00402b47
    mov edx, dword ptr [ebp - local_4]           # 00402b23
    mov eax, dword ptr [edx + field_5c]          # 00402b26
    mov dword ptr [4*eax + 0x5e60ee], 0x0        # 00402b29
    jmp.d8 L_00402b47                            # 00402b34
L_00402b36:
    # block 0x00402b36: entered by jne at 0x00402b21, 3 instruction(s), falls into the block at 0x00402b47
    mov ecx, dword ptr [ebp - local_4]           # 00402b36
    mov edx, dword ptr [ecx + field_5c]          # 00402b39
    mov dword ptr [4*edx + 0x5e60ee], 0x1        # 00402b3c
L_00402b47:
    # block 0x00402b47: entered by jmp at 0x00402b34, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402b47
    call FUN_0040236a                            # 00402b4a
    {load} mov esp, ebp                          # 00402b4f
    pop ebp                                      # 00402b51
    ret                                          # 00402b52

