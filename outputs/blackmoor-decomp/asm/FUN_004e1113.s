# FUN_004e1113
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e1113
# extent:       0x004e1113-0x004e1157 (68 code bytes)
# span:         0x004e1113-0x004e1157 (code 68, tables 0, padding 0)
# sha256:       3e3a309b786165b5b121be9ed145ff3b94523b8930f4f12995fb72fb15e250ff
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e1113_log_guarded
# naming:       native port src/original_methods_fl39e.c:m4e1113_log_guarded (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    When dword [self+0x74f] != 0 calls 0x4c5377(this 0x5cf659) with that dword, the global 0x5cf665, self+0x25, self+0x35 and 0x55be0c. The jump taken both ways; all 24 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_74f; [ecx + n] field_74f
# callees:      calls FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4e1113_log_guarded (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_74f, 0x74f  # offset +0x74f

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004e1113 - 0x401000
.globl FUN_004e1113
FUN_004e1113:
    # block 0x004e1113: entry, 7 instruction(s), ends with je to 0x004e1153 (forward)
    push ebp                                     # 004e1113
    {load} mov ebp, esp                          # 004e1114
    push ecx                                     # 004e1116
    mov dword ptr [ebp - local_4], ecx           # 004e1117
    mov eax, dword ptr [ebp - local_4]           # 004e111a
    cmp dword ptr [eax + field_74f], 0x0         # 004e111d
    je.d8 L_004e1153                             # 004e1124
    # block 0x004e1126: entered by fall-through of je at 0x004e1124, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x004e1153
    push 0x55be0c                                # 004e1126
    mov ecx, dword ptr [ebp - local_4]           # 004e112b
    add ecx, 0x35                                # 004e112e
    push ecx                                     # 004e1131
    mov edx, dword ptr [ebp - local_4]           # 004e1132
    add edx, 0x25                                # 004e1135
    push edx                                     # 004e1138
    mov eax, dword ptr [0x5cf665]                # 004e1139
    push eax                                     # 004e113e
    mov ecx, dword ptr [ebp - local_4]           # 004e113f
    mov edx, dword ptr [ecx + field_74f]         # 004e1142
    push edx                                     # 004e1148
    mov ecx, 0x5cf659                            # 004e1149
    call FUN_004c5377                            # 004e114e
L_004e1153:
    # block 0x004e1153: entered by je at 0x004e1124, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e1153
    pop ebp                                      # 004e1155
    ret                                          # 004e1156

