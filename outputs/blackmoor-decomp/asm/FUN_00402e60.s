# FUN_00402e60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402e60
# extent:       0x00402e60-0x00402ea7 (71 code bytes)
# span:         0x00402e60-0x00402ea7 (code 71, tables 0, padding 0)
# sha256:       b6b21ad2558028390549c51ec362e7bb8ba05bb7ecf16a101e50680060d82880
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00402e60
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

.org 0x00402e60 - 0x401000
.globl FUN_00402e60
FUN_00402e60:
    # block 0x00402e60: entry, 8 instruction(s), ends with jne to 0x00402e8a (forward)
    push ebp                                     # 00402e60
    {load} mov ebp, esp                          # 00402e61
    push ecx                                     # 00402e63
    mov dword ptr [ebp - local_4], ecx           # 00402e64
    mov eax, dword ptr [ebp - local_4]           # 00402e67
    mov ecx, dword ptr [eax + field_5c]          # 00402e6a
    cmp dword ptr [4*ecx + 0x5e611e], 0x1        # 00402e6d
    jne.d8 L_00402e8a                            # 00402e75
    # block 0x00402e77: entered by fall-through of jne at 0x00402e75, 4 instruction(s), ends with forward jump to 0x00402e9b
    mov edx, dword ptr [ebp - local_4]           # 00402e77
    mov eax, dword ptr [edx + field_5c]          # 00402e7a
    mov dword ptr [4*eax + 0x5e611e], 0x0        # 00402e7d
    jmp.d8 L_00402e9b                            # 00402e88
L_00402e8a:
    # block 0x00402e8a: entered by jne at 0x00402e75, 3 instruction(s), falls into the block at 0x00402e9b
    mov ecx, dword ptr [ebp - local_4]           # 00402e8a
    mov edx, dword ptr [ecx + field_5c]          # 00402e8d
    mov dword ptr [4*edx + 0x5e611e], 0x1        # 00402e90
L_00402e9b:
    # block 0x00402e9b: entered by jmp at 0x00402e88, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402e9b
    call FUN_0040236a                            # 00402e9e
    {load} mov esp, ebp                          # 00402ea3
    pop ebp                                      # 00402ea5
    ret                                          # 00402ea6

