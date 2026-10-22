# FUN_004a1cb1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1cb1
# extent:       0x004a1cb1-0x004a1ce0 (47 code bytes)
# span:         0x004a1cb1-0x004a1ce0 (code 47, tables 0, padding 0)
# sha256:       053798c34bb19a52f69e6a618a5b1f6ae0f866b455477816923c63e42368b879
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a1cb1_release_word
# naming:       native port src/original_methods_fl39e.c:m4a1cb1_release_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    When the signed word [self+0x1c] != -1 calls 0x4d3992(word); then returns 0x4a1c47(self). The jump taken both ways (word -1 and other words incl. 0xfffe, 0x8000); all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004d3992, FUN_004a1c47
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4a1cb1_release_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_004a1c47, .text + (0x004a1c47 - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004a1cb1 - 0x401000
.globl FUN_004a1cb1
FUN_004a1cb1:
    # block 0x004a1cb1: entry, 8 instruction(s), ends with je to 0x004a1cd4 (forward)
    push ebp                                     # 004a1cb1
    {load} mov ebp, esp                          # 004a1cb2
    push ecx                                     # 004a1cb4
    mov dword ptr [ebp - local_4], ecx           # 004a1cb5
    mov eax, dword ptr [ebp - local_4]           # 004a1cb8
    movsx ecx, word ptr [eax + field_1c]         # 004a1cbb
    cmp ecx, -0x1                                # 004a1cbf
    je.d8 L_004a1cd4                             # 004a1cc2
    # block 0x004a1cc4: entered by fall-through of je at 0x004a1cc2, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004a1cd4
    mov edx, dword ptr [ebp - local_4]           # 004a1cc4
    mov ax, word ptr [edx + field_1c]            # 004a1cc7
    push eax                                     # 004a1ccb
    call FUN_004d3992                            # 004a1ccc
    add esp, 0x4                                 # 004a1cd1
L_004a1cd4:
    # block 0x004a1cd4: entered by je at 0x004a1cc2, 5 instruction(s), calls FUN_004a1c47, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004a1cd4
    call FUN_004a1c47                            # 004a1cd7
    {load} mov esp, ebp                          # 004a1cdc
    pop ebp                                      # 004a1cde
    ret                                          # 004a1cdf

