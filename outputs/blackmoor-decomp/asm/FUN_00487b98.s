# FUN_00487b98
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487b98
# extent:       0x00487b98-0x00487bcc (52 code bytes)
# span:         0x00487b98-0x00487bcc (code 52, tables 0, padding 0)
# sha256:       a9f89d12e82ecb66d0874e041494ee0d0a077a04f4d0507617c8c1afff13b45e
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m487b98_mark_entry
# naming:       native port src/original_methods_fl39a.c:m487b98_mark_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns when dword [self+0x71] is 0 or the signed word [self+0x1c] is -1; otherwise stores dword 1 at [0x5d15a5 + i*0x4a]. Both jumps taken both ways; all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_71; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m487b98_mark_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_71, 0x71  # offset +0x71

# --- external targets -----------------------------------------------

.org 0x00487b98 - 0x401000
.globl FUN_00487b98
FUN_00487b98:
    # block 0x00487b98: entry, 7 instruction(s), ends with je to 0x00487bc8 (forward)
    push ebp                                     # 00487b98
    {load} mov ebp, esp                          # 00487b99
    push ecx                                     # 00487b9b
    mov dword ptr [ebp - local_4], ecx           # 00487b9c
    mov eax, dword ptr [ebp - local_4]           # 00487b9f
    cmp dword ptr [eax + field_71], 0x0          # 00487ba2
    je.d8 L_00487bc8                             # 00487ba6
    # block 0x00487ba8: entered by fall-through of je at 0x00487ba6, 4 instruction(s), ends with je to 0x00487bc8 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00487ba8
    movsx edx, word ptr [ecx + field_1c]         # 00487bab
    cmp edx, -0x1                                # 00487baf
    je.d8 L_00487bc8                             # 00487bb2
    # block 0x00487bb4: entered by fall-through of je at 0x00487bb2, 4 instruction(s), falls into the block at 0x00487bc8
    mov eax, dword ptr [ebp - local_4]           # 00487bb4
    movsx ecx, word ptr [eax + field_1c]         # 00487bb7
    imul ecx, ecx, 0x4a                          # 00487bbb
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00487bbe
L_00487bc8:
    # block 0x00487bc8: entered by je at 0x00487ba6; je at 0x00487bb2, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00487bc8
    pop ebp                                      # 00487bca
    ret                                          # 00487bcb

