# FUN_00475fb1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00475fb1
# extent:       0x00475fb1-0x0047608e (221 code bytes)
# span:         0x00475fb1-0x0047608e (code 221, tables 0, padding 0)
# sha256:       892e744a836f9bb8fcfbda5c59ff1d9915a8ae268a67cdd3da9c77fca2280959
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         write_cursor
# naming:       native port src/action_family_e4_runtime.c:write_cursor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      write_cursor matches the two branches (0x27d6 with state != 6 -> kind 9 sub 1; 0x27d5/0x27d7 -> kind 0x16 sub 1) and the no-write fallthrough;
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_e4_runtime.c:write_cursor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00475fb1 - 0x401000
.globl FUN_00475fb1
FUN_00475fb1:
    # block 0x00475fb1: entry, 7 instruction(s), ends with jne to 0x00476020 (forward)
    push ebp                                     # 00475fb1
    {load} mov ebp, esp                          # 00475fb2
    push ecx                                     # 00475fb4
    mov dword ptr [ebp - local_4], ecx           # 00475fb5
    movsx eax, word ptr [ebp + arg_8]            # 00475fb8
    cmp eax, 0x27d6                              # 00475fbc
    jne.d8 L_00476020                            # 00475fc1
    # block 0x00475fc3: entered by fall-through of jne at 0x00475fc1, 2 instruction(s), ends with je to 0x00476020 (forward)
    cmp dword ptr [0x622fce], 0x6                # 00475fc3
    je.d8 L_00476020                             # 00475fca
    # block 0x00475fcc: entered by fall-through of je at 0x00475fca, 14 instruction(s), ends with forward jump to 0x00476088
    mov ecx, dword ptr [0x5d0377]                # 00475fcc
    mov dword ptr [0x5d162d], ecx                # 00475fd2
    mov dword ptr [0x5b44f0], 0x9                # 00475fd8
    mov dword ptr [0x5b44f4], 0x1                # 00475fe2
    mov edx, dword ptr [0x5b44f0]                # 00475fec
    shl edx, 0x5                                 # 00475ff2
    mov eax, dword ptr [0x5b44f4]                # 00475ff5
    shl eax, 0x4                                 # 00475ffa
    lea ecx, [edx + eax + 0x5b160c]              # 00475ffd
    mov dword ptr [0x5d1631], ecx                # 00476004
    mov dword ptr [0x5d1639], 0x1                # 0047600a
    movsx edx, word ptr [ebp + arg_8]            # 00476014
    mov dword ptr [0x5c39e5], edx                # 00476018
    jmp.d8 L_00476088                            # 0047601e
L_00476020:
    # block 0x00476020: entered by jne at 0x00475fc1; je at 0x00475fca, 3 instruction(s), ends with je to 0x00476037 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00476020
    cmp eax, 0x27d5                              # 00476024
    je.d8 L_00476037                             # 00476029
    # block 0x0047602b: entered by fall-through of je at 0x00476029, 3 instruction(s), ends with jne to 0x00476088 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0047602b
    cmp ecx, 0x27d7                              # 0047602f
    jne.d8 L_00476088                            # 00476035
L_00476037:
    # block 0x00476037: entered by je at 0x00476029; fall-through of jne at 0x00476035, 13 instruction(s), falls into the block at 0x00476088
    mov dword ptr [0x5b44f0], 0x16               # 00476037
    mov dword ptr [0x5b44f4], 0x1                # 00476041
    mov edx, dword ptr [0x5d0377]                # 0047604b
    mov dword ptr [0x5d162d], edx                # 00476051
    mov eax, dword ptr [0x5b44f0]                # 00476057
    shl eax, 0x5                                 # 0047605c
    mov ecx, dword ptr [0x5b44f4]                # 0047605f
    shl ecx, 0x4                                 # 00476065
    lea edx, [eax + ecx + 0x5b160c]              # 00476068
    mov dword ptr [0x5d1631], edx                # 0047606f
    mov dword ptr [0x5d1639], 0x1                # 00476075
    movsx eax, word ptr [ebp + arg_8]            # 0047607f
    mov dword ptr [0x5c39e5], eax                # 00476083
L_00476088:
    # block 0x00476088: entered by jmp at 0x0047601e; jne at 0x00476035, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00476088
    pop ebp                                      # 0047608a
    ret 0x4                                      # 0047608b

