# FUN_004229b5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004229b5
# extent:       0x004229b5-0x004229fa (69 code bytes)
# span:         0x004229b5-0x004229fa (code 69, tables 0, padding 0)
# sha256:       7e95503fd4276d057c6e8fda80b9b502ea3bd1c63a6e890437d2c4e8c7378595
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         cel_announce
# naming:       native port src/action_family_3f_runtime.c:cel_announce (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-16); the summary is the acceptance note
# summary:      Extracted from cel_advance's tail (no behaviour change): drawn != target sets drawn = target and flag 0x5d191d = 1. RT-25 oracle (878 scenarios, 0 mismatches) compares both; unused stack arg dropped.
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_77e; [ecx + n] field_77e; [edx + n] field_782
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:cel_announce (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_77e, 0x77e  # offset +0x77e
.equ field_782, 0x782  # offset +0x782

# --- external targets -----------------------------------------------

.org 0x004229b5 - 0x401000
.globl FUN_004229b5
FUN_004229b5:
    # block 0x004229b5: entry, 10 instruction(s), ends with jne to 0x004229d6 (forward)
    push ebp                                     # 004229b5
    {load} mov ebp, esp                          # 004229b6
    push ecx                                     # 004229b8
    mov dword ptr [ebp - local_4], ecx           # 004229b9
    mov eax, dword ptr [ebp - local_4]           # 004229bc
    movsx ecx, word ptr [eax + field_77e]        # 004229bf
    mov edx, dword ptr [ebp - local_4]           # 004229c6
    movsx eax, word ptr [edx + field_782]        # 004229c9
    {load} cmp ecx, eax                          # 004229d0
    jne.d8 L_004229d6                            # 004229d2
    # block 0x004229d4: entered by fall-through of jne at 0x004229d2, 1 instruction(s), ends with forward jump to 0x004229f4
    jmp.d8 L_004229f4                            # 004229d4
L_004229d6:
    # block 0x004229d6: entered by jne at 0x004229d2, 5 instruction(s), falls into the block at 0x004229f4
    mov ecx, dword ptr [ebp - local_4]           # 004229d6
    mov edx, dword ptr [ebp - local_4]           # 004229d9
    mov ax, word ptr [edx + field_782]           # 004229dc
    mov word ptr [ecx + field_77e], ax           # 004229e3
    mov dword ptr [0x5d191d], 0x1                # 004229ea
L_004229f4:
    # block 0x004229f4: entered by jmp at 0x004229d4, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004229f4
    pop ebp                                      # 004229f6
    ret 0x4                                      # 004229f7

