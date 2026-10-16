# FUN_00459bd6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00459bd6
# extent:       0x00459bd6-0x00459c10 (58 code bytes)
# span:         0x00459bd6-0x00459c10 (code 58, tables 0, padding 0)
# sha256:       db467288367ea68821587a73184a96b889287f9f9d05444dcfaeffd213fb2511
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00459bd6
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_d6; [ecx + n] field_22; [edx + n] field_22
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_22, 0x22  # offset +0x22
.equ field_d6, 0xd6  # offset +0xd6

# --- external targets -----------------------------------------------

.org 0x00459bd6 - 0x401000
.globl FUN_00459bd6
FUN_00459bd6:
    # block 0x00459bd6: entry, 9 instruction(s), ends with je to 0x00459c0c (forward)
    push ebp                                     # 00459bd6
    {load} mov ebp, esp                          # 00459bd7
    push ecx                                     # 00459bd9
    mov dword ptr [ebp - local_4], ecx           # 00459bda
    mov eax, dword ptr [ebp - local_4]           # 00459bdd
    {load} xor ecx, ecx                          # 00459be0
    mov cl, byte ptr [eax + field_d6]            # 00459be2
    test ecx, ecx                                # 00459be8
    je.d8 L_00459c0c                             # 00459bea
    # block 0x00459bec: entered by fall-through of je at 0x00459bea, 4 instruction(s), ends with je to 0x00459c0c (forward)
    mov edx, dword ptr [ebp - local_4]           # 00459bec
    movsx eax, word ptr [edx + field_22]         # 00459bef
    cmp eax, -0x1                                # 00459bf3
    je.d8 L_00459c0c                             # 00459bf6
    # block 0x00459bf8: entered by fall-through of je at 0x00459bf6, 4 instruction(s), falls into the block at 0x00459c0c
    mov ecx, dword ptr [ebp - local_4]           # 00459bf8
    movsx edx, word ptr [ecx + field_22]         # 00459bfb
    imul edx, edx, 0x4a                          # 00459bff
    mov dword ptr [edx + 0x5d15a5], 0x1          # 00459c02
L_00459c0c:
    # block 0x00459c0c: entered by je at 0x00459bea; je at 0x00459bf6, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00459c0c
    pop ebp                                      # 00459c0e
    ret                                          # 00459c0f

