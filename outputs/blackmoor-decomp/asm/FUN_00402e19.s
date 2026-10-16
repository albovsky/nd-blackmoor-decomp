# FUN_00402e19
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402e19
# extent:       0x00402e19-0x00402e60 (71 code bytes)
# span:         0x00402e19-0x00402e60 (code 71, tables 0, padding 0)
# sha256:       db67f29ca588afce314e45f45f2ed4e3d4289661f3f6525c68e024fd4a88f14a
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00402e19
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

.org 0x00402e19 - 0x401000
.globl FUN_00402e19
FUN_00402e19:
    # block 0x00402e19: entry, 8 instruction(s), ends with jne to 0x00402e43 (forward)
    push ebp                                     # 00402e19
    {load} mov ebp, esp                          # 00402e1a
    push ecx                                     # 00402e1c
    mov dword ptr [ebp - local_4], ecx           # 00402e1d
    mov eax, dword ptr [ebp - local_4]           # 00402e20
    mov ecx, dword ptr [eax + field_5c]          # 00402e23
    cmp dword ptr [4*ecx + 0x5e611a], 0x1        # 00402e26
    jne.d8 L_00402e43                            # 00402e2e
    # block 0x00402e30: entered by fall-through of jne at 0x00402e2e, 4 instruction(s), ends with forward jump to 0x00402e54
    mov edx, dword ptr [ebp - local_4]           # 00402e30
    mov eax, dword ptr [edx + field_5c]          # 00402e33
    mov dword ptr [4*eax + 0x5e611a], 0x0        # 00402e36
    jmp.d8 L_00402e54                            # 00402e41
L_00402e43:
    # block 0x00402e43: entered by jne at 0x00402e2e, 3 instruction(s), falls into the block at 0x00402e54
    mov ecx, dword ptr [ebp - local_4]           # 00402e43
    mov edx, dword ptr [ecx + field_5c]          # 00402e46
    mov dword ptr [4*edx + 0x5e611a], 0x1        # 00402e49
L_00402e54:
    # block 0x00402e54: entered by jmp at 0x00402e41, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402e54
    call FUN_0040236a                            # 00402e57
    {load} mov esp, ebp                          # 00402e5c
    pop ebp                                      # 00402e5e
    ret                                          # 00402e5f

