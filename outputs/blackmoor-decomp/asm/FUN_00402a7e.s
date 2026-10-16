# FUN_00402a7e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402a7e
# extent:       0x00402a7e-0x00402ac5 (71 code bytes)
# span:         0x00402a7e-0x00402ac5 (code 71, tables 0, padding 0)
# sha256:       7c42c670ca86574f608e70e2624136f65627872f650de40781c98cbac7160c03
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00402a7e
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

.org 0x00402a7e - 0x401000
.globl FUN_00402a7e
FUN_00402a7e:
    # block 0x00402a7e: entry, 8 instruction(s), ends with jne to 0x00402aa8 (forward)
    push ebp                                     # 00402a7e
    {load} mov ebp, esp                          # 00402a7f
    push ecx                                     # 00402a81
    mov dword ptr [ebp - local_4], ecx           # 00402a82
    mov eax, dword ptr [ebp - local_4]           # 00402a85
    mov ecx, dword ptr [eax + field_5c]          # 00402a88
    cmp dword ptr [4*ecx + 0x5e60e6], 0x1        # 00402a8b
    jne.d8 L_00402aa8                            # 00402a93
    # block 0x00402a95: entered by fall-through of jne at 0x00402a93, 4 instruction(s), ends with forward jump to 0x00402ab9
    mov edx, dword ptr [ebp - local_4]           # 00402a95
    mov eax, dword ptr [edx + field_5c]          # 00402a98
    mov dword ptr [4*eax + 0x5e60e6], 0x0        # 00402a9b
    jmp.d8 L_00402ab9                            # 00402aa6
L_00402aa8:
    # block 0x00402aa8: entered by jne at 0x00402a93, 3 instruction(s), falls into the block at 0x00402ab9
    mov ecx, dword ptr [ebp - local_4]           # 00402aa8
    mov edx, dword ptr [ecx + field_5c]          # 00402aab
    mov dword ptr [4*edx + 0x5e60e6], 0x1        # 00402aae
L_00402ab9:
    # block 0x00402ab9: entered by jmp at 0x00402aa6, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402ab9
    call FUN_0040236a                            # 00402abc
    {load} mov esp, ebp                          # 00402ac1
    pop ebp                                      # 00402ac3
    ret                                          # 00402ac4

