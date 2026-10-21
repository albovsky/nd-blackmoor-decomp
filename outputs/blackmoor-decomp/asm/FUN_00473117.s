# FUN_00473117
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00473117
# extent:       0x00473117-0x0047314b (52 code bytes)
# span:         0x00473117-0x0047314b (code 52, tables 0, padding 0)
# sha256:       d59d037c39dc1ed995fa971baaa6fcc1d54bc55336d39b1ac7a246021f5832b9
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m473117_mark_entry
# naming:       native port src/original_methods_fl33a.c:m473117_mark_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Sets the dword of record [signed word self+0x14] at 0x5d15a5 (stride 0x4a) to 1 when dword [self+0x7a] is non-zero and the word is not -1; 18/18 instructions, 4/4 directions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_14, field_7a; [ecx + n] field_14
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl33a.c:m473117_mark_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_14, 0x14  # offset +0x14
.equ field_7a, 0x7a  # offset +0x7a

# --- external targets -----------------------------------------------

.org 0x00473117 - 0x401000
.globl FUN_00473117
FUN_00473117:
    # block 0x00473117: entry, 7 instruction(s), ends with je to 0x00473147 (forward)
    push ebp                                     # 00473117
    {load} mov ebp, esp                          # 00473118
    push ecx                                     # 0047311a
    mov dword ptr [ebp - local_4], ecx           # 0047311b
    mov eax, dword ptr [ebp - local_4]           # 0047311e
    cmp dword ptr [eax + field_7a], 0x0          # 00473121
    je.d8 L_00473147                             # 00473125
    # block 0x00473127: entered by fall-through of je at 0x00473125, 4 instruction(s), ends with je to 0x00473147 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00473127
    movsx edx, word ptr [ecx + field_14]         # 0047312a
    cmp edx, -0x1                                # 0047312e
    je.d8 L_00473147                             # 00473131
    # block 0x00473133: entered by fall-through of je at 0x00473131, 4 instruction(s), falls into the block at 0x00473147
    mov eax, dword ptr [ebp - local_4]           # 00473133
    movsx ecx, word ptr [eax + field_14]         # 00473136
    imul ecx, ecx, 0x4a                          # 0047313a
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0047313d
L_00473147:
    # block 0x00473147: entered by je at 0x00473125; je at 0x00473131, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00473147
    pop ebp                                      # 00473149
    ret                                          # 0047314a

