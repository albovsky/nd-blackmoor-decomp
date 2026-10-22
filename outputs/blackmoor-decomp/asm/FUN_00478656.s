# FUN_00478656
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00478656
# extent:       0x00478656-0x00478684 (46 code bytes)
# span:         0x00478656-0x00478684 (code 46, tables 0, padding 0)
# sha256:       ef77c95346c56048c4982e524b1f9e4b3100530e5ae657d6a5b9d07fc5c682cb
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00478656
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m478656_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------

.org 0x00478656 - 0x401000
.globl FUN_00478656
FUN_00478656:
    # block 0x00478656: entry, 8 instruction(s), ends with jne to 0x0047867c (forward)
    push ebp                                     # 00478656
    {load} mov ebp, esp                          # 00478657
    push ecx                                     # 00478659
    mov dword ptr [ebp - local_4], ecx           # 0047865a
    movsx eax, word ptr [ebp + arg_8]            # 0047865d
    movsx ecx, word ptr [ebp + arg_10]           # 00478661
    {load} cmp eax, ecx                          # 00478665
    jne.d8 L_0047867c                            # 00478667
    # block 0x00478669: entered by fall-through of jne at 0x00478667, 4 instruction(s), ends with jne to 0x0047867c (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00478669
    movsx eax, word ptr [ebp + arg_14]           # 0047866d
    {load} cmp edx, eax                          # 00478671
    jne.d8 L_0047867c                            # 00478673
    # block 0x00478675: entered by fall-through of jne at 0x00478673, 2 instruction(s), ends with forward jump to 0x0047867e
    mov eax, 0x1                                 # 00478675
    jmp.d8 L_0047867e                            # 0047867a
L_0047867c:
    # block 0x0047867c: entered by jne at 0x00478667; jne at 0x00478673, 1 instruction(s), falls into the block at 0x0047867e
    {load} xor eax, eax                          # 0047867c
L_0047867e:
    # block 0x0047867e: entered by jmp at 0x0047867a, 3 instruction(s), ends with ret 0x10
    {load} mov esp, ebp                          # 0047867e
    pop ebp                                      # 00478680
    ret 0x10                                     # 00478681

