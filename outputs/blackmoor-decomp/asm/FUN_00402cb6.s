# FUN_00402cb6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402cb6
# extent:       0x00402cb6-0x00402cfd (71 code bytes)
# span:         0x00402cb6-0x00402cfd (code 71, tables 0, padding 0)
# sha256:       d11b427c73b53bbe869b7d81a7fd190482de0dff4e26d1a640c25ef96bd13ca6
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00402cb6
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

.org 0x00402cb6 - 0x401000
.globl FUN_00402cb6
FUN_00402cb6:
    # block 0x00402cb6: entry, 8 instruction(s), ends with jne to 0x00402ce0 (forward)
    push ebp                                     # 00402cb6
    {load} mov ebp, esp                          # 00402cb7
    push ecx                                     # 00402cb9
    mov dword ptr [ebp - local_4], ecx           # 00402cba
    mov eax, dword ptr [ebp - local_4]           # 00402cbd
    mov ecx, dword ptr [eax + field_5c]          # 00402cc0
    cmp dword ptr [4*ecx + 0x5e6106], 0x1        # 00402cc3
    jne.d8 L_00402ce0                            # 00402ccb
    # block 0x00402ccd: entered by fall-through of jne at 0x00402ccb, 4 instruction(s), ends with forward jump to 0x00402cf1
    mov edx, dword ptr [ebp - local_4]           # 00402ccd
    mov eax, dword ptr [edx + field_5c]          # 00402cd0
    mov dword ptr [4*eax + 0x5e6106], 0x0        # 00402cd3
    jmp.d8 L_00402cf1                            # 00402cde
L_00402ce0:
    # block 0x00402ce0: entered by jne at 0x00402ccb, 3 instruction(s), falls into the block at 0x00402cf1
    mov ecx, dword ptr [ebp - local_4]           # 00402ce0
    mov edx, dword ptr [ecx + field_5c]          # 00402ce3
    mov dword ptr [4*edx + 0x5e6106], 0x1        # 00402ce6
L_00402cf1:
    # block 0x00402cf1: entered by jmp at 0x00402cde, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402cf1
    call FUN_0040236a                            # 00402cf4
    {load} mov esp, ebp                          # 00402cf9
    pop ebp                                      # 00402cfb
    ret                                          # 00402cfc

