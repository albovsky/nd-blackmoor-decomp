# FUN_004f80d3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f80d3
# extent:       0x004f80d3-0x004f8157 (132 code bytes)
# span:         0x004f80d3-0x004f8157 (code 132, tables 0, padding 0)
# sha256:       dc16606f13f8788509f8bda97646320f50b3710e0f2010533e228f74e0d60621
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4f80d3_play_retry
# naming:       native port src/original_methods_fl28a.c:m4f80d3_play_retry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4f80d3_play_retry: the oracle runs every instruction of 0x4f80d3..0x4f8157 and both jump directions, comparing ordered host calls and memory. See tasks/fl28a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_30, field_3ca; [edx + n] field_50, field_3ca
# callees:      none direct; 3 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/live_audio.c:start_host (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_30, 0x30  # offset +0x30
.equ field_50, 0x50  # offset +0x50
.equ field_3ca, 0x3ca  # offset +0x3ca

# --- external targets -----------------------------------------------

.org 0x004f80d3 - 0x401000
.globl FUN_004f80d3
FUN_004f80d3:
    # block 0x004f80d3: entry, 20 instruction(s), calls indirect dword ptr [eax + 0x30], ends with jne to 0x004f813c (forward)
    push ebp                                     # 004f80d3
    {load} mov ebp, esp                          # 004f80d4
    push ecx                                     # 004f80d6
    mov dword ptr [ebp - local_4], ecx           # 004f80d7
    mov eax, dword ptr [ebp - local_4]           # 004f80da
    mov dword ptr [eax + field_3ca], 0x0         # 004f80dd
    mov ecx, dword ptr [ebp + arg_c]             # 004f80e7
    push ecx                                     # 004f80ea
    push 0x0                                     # 004f80eb
    push 0x0                                     # 004f80ed
    mov edx, dword ptr [ebp + arg_8]             # 004f80ef
    mov eax, dword ptr [edx]                     # 004f80f2
    mov ecx, dword ptr [ebp + arg_8]             # 004f80f4
    push ecx                                     # 004f80f7
    call dword ptr [eax + field_30]              # 004f80f8
    mov edx, dword ptr [ebp - local_4]           # 004f80fb
    mov dword ptr [edx + field_3ca], eax         # 004f80fe
    mov eax, dword ptr [ebp - local_4]           # 004f8104
    cmp dword ptr [eax + field_3ca], 0x88780096  # 004f8107
    jne.d8 L_004f813c                            # 004f8111
    # block 0x004f8113: entered by fall-through of jne at 0x004f8111, 16 instruction(s), calls indirect dword ptr [edx + 0x50], indirect dword ptr [eax + 0x30], falls into the block at 0x004f813c
    mov ecx, dword ptr [ebp + arg_8]             # 004f8113
    mov edx, dword ptr [ecx]                     # 004f8116
    mov eax, dword ptr [ebp + arg_8]             # 004f8118
    push eax                                     # 004f811b
    call dword ptr [edx + field_50]              # 004f811c
    mov ecx, dword ptr [ebp + arg_c]             # 004f811f
    push ecx                                     # 004f8122
    push 0x0                                     # 004f8123
    push 0x0                                     # 004f8125
    mov edx, dword ptr [ebp + arg_8]             # 004f8127
    mov eax, dword ptr [edx]                     # 004f812a
    mov ecx, dword ptr [ebp + arg_8]             # 004f812c
    push ecx                                     # 004f812f
    call dword ptr [eax + field_30]              # 004f8130
    mov edx, dword ptr [ebp - local_4]           # 004f8133
    mov dword ptr [edx + field_3ca], eax         # 004f8136
L_004f813c:
    # block 0x004f813c: entered by jne at 0x004f8111, 3 instruction(s), ends with jne to 0x004f814f (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f813c
    cmp dword ptr [eax + field_3ca], 0x0         # 004f813f
    jne.d8 L_004f814f                            # 004f8146
    # block 0x004f8148: entered by fall-through of jne at 0x004f8146, 2 instruction(s), ends with forward jump to 0x004f8151
    mov eax, 0x1                                 # 004f8148
    jmp.d8 L_004f8151                            # 004f814d
L_004f814f:
    # block 0x004f814f: entered by jne at 0x004f8146, 1 instruction(s), falls into the block at 0x004f8151
    {load} xor eax, eax                          # 004f814f
L_004f8151:
    # block 0x004f8151: entered by jmp at 0x004f814d, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004f8151
    pop ebp                                      # 004f8153
    ret 0x8                                      # 004f8154

