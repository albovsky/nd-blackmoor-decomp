# FUN_00447e83
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447e83
# extent:       0x00447e83-0x00447eaf (44 code bytes)
# span:         0x00447e83-0x00447eaf (code 44, tables 0, padding 0)
# sha256:       7b1659c3b7fd8b553eadf95aff760dd4a51a3402a0ee2df3b3f006fd403ef92c
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00447e83
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1e, 0x1e  # offset +0x1e

# --- external targets -----------------------------------------------

.org 0x00447e83 - 0x401000
.globl FUN_00447e83
FUN_00447e83:
    # block 0x00447e83: entry, 9 instruction(s), ends with je to 0x00447ea9 (forward)
    push ebp                                     # 00447e83
    {load} mov ebp, esp                          # 00447e84
    push ecx                                     # 00447e86
    push esi                                     # 00447e87
    push edi                                     # 00447e88
    mov dword ptr [ebp - local_4], ecx           # 00447e89
    mov eax, dword ptr [ebp - local_4]           # 00447e8c
    cmp dword ptr [eax + field_1e], 0x0          # 00447e8f
    je.d8 L_00447ea9                             # 00447e93
    # block 0x00447e95: entered by fall-through of je at 0x00447e93, 6 instruction(s), falls into the block at 0x00447ea9
    mov ecx, 0x13f4                              # 00447e95
    mov esi, 0x5b61f1                            # 00447e9a
    mov edi, 0x58c9bd                            # 00447e9f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00447ea4
    movsw word ptr es:[edi], word ptr [esi]      # 00447ea6
    movsb byte ptr es:[edi], byte ptr [esi]      # 00447ea8
L_00447ea9:
    # block 0x00447ea9: entered by je at 0x00447e93, 5 instruction(s), ends with ret
    pop edi                                      # 00447ea9
    pop esi                                      # 00447eaa
    {load} mov esp, ebp                          # 00447eab
    pop ebp                                      # 00447ead
    ret                                          # 00447eae

