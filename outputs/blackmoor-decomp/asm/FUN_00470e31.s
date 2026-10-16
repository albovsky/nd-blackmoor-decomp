# FUN_00470e31
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470e31
# extent:       0x00470e31-0x00470e71 (64 code bytes)
# span:         0x00470e31-0x00470e71 (code 64, tables 0, padding 0)
# sha256:       36e3c9aff2f7f2e4401397f609fe7190aa910c554626a77075fd3ace7033d16b
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00470e31
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_d3e; [ecx + n] field_d38; [edx + n] field_d38
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_d38, 0xd38  # offset +0xd38
.equ field_d3e, 0xd3e  # offset +0xd3e

# --- external targets -----------------------------------------------

.org 0x00470e31 - 0x401000
.globl FUN_00470e31
FUN_00470e31:
    # block 0x00470e31: entry, 9 instruction(s), ends with je to 0x00470e6d (forward)
    push ebp                                     # 00470e31
    {load} mov ebp, esp                          # 00470e32
    push ecx                                     # 00470e34
    mov dword ptr [ebp - local_4], ecx           # 00470e35
    mov eax, dword ptr [ebp - local_4]           # 00470e38
    {load} xor ecx, ecx                          # 00470e3b
    mov cl, byte ptr [eax + field_d3e]           # 00470e3d
    test ecx, ecx                                # 00470e43
    je.d8 L_00470e6d                             # 00470e45
    # block 0x00470e47: entered by fall-through of je at 0x00470e45, 4 instruction(s), ends with je to 0x00470e6d (forward)
    mov edx, dword ptr [ebp - local_4]           # 00470e47
    movsx eax, word ptr [edx + field_d38]        # 00470e4a
    cmp eax, -0x1                                # 00470e51
    je.d8 L_00470e6d                             # 00470e54
    # block 0x00470e56: entered by fall-through of je at 0x00470e54, 4 instruction(s), falls into the block at 0x00470e6d
    mov ecx, dword ptr [ebp - local_4]           # 00470e56
    movsx edx, word ptr [ecx + field_d38]        # 00470e59
    imul edx, edx, 0x4a                          # 00470e60
    mov dword ptr [edx + 0x5d15a5], 0x1          # 00470e63
L_00470e6d:
    # block 0x00470e6d: entered by je at 0x00470e45; je at 0x00470e54, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00470e6d
    pop ebp                                      # 00470e6f
    ret                                          # 00470e70

