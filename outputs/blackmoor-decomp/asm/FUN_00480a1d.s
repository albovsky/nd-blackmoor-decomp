# FUN_00480a1d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00480a1d
# extent:       0x00480a1d-0x00480abe (161 code bytes)
# span:         0x00480a1d-0x00480abe (code 161, tables 0, padding 0)
# sha256:       60934d9eddf35344af12cc62759f600282e35d7f19a89bc54d7054422b5f2fac
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         sound_good
# naming:       native port src/action_family_eb_runtime.c:sound_good (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with sound_good (record +0x777, then save_and_check, state 4, deadline2 tick+100). Row phase and world are parameters; host callbacks. save_and_check (0x480b34) is credited separately (FL-10).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_13ca; [ecx + n] field_798, field_13e7, field_13eb; [edx + n] field_13e7
# callees:      calls FUN_004fb2e3, KERNEL32.dll!GetTickCount, FUN_00480b34
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:sound_blip (function ledger class native_oracle_verified; also sound_good; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 44 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_798, 0x798  # offset +0x798
.equ field_13ca, 0x13ca  # offset +0x13ca
.equ field_13e7, 0x13e7  # offset +0x13e7
.equ field_13eb, 0x13eb  # offset +0x13eb

# --- external targets -----------------------------------------------
.set FUN_00480b34, .text + (0x00480b34 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00480a1d - 0x401000
.globl FUN_00480a1d
FUN_00480a1d:
    # block 0x00480a1d: entry, 18 instruction(s), ends with je to 0x00480a82 (forward)
    push ebp                                     # 00480a1d
    {load} mov ebp, esp                          # 00480a1e
    sub esp, 0x8                                 # 00480a20
    push esi                                     # 00480a23
    push edi                                     # 00480a24
    mov dword ptr [ebp - local_8], ecx           # 00480a25
    mov eax, dword ptr [ebp - local_8]           # 00480a28
    movsx ecx, word ptr [eax + field_1e]         # 00480a2b
    imul ecx, ecx, 0x8d                          # 00480a2f
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00480a35
    mov dword ptr [ebp - local_4], edx           # 00480a3b
    mov edi, 0x54d5c4                            # 00480a3e
    mov esi, dword ptr [ebp - local_4]           # 00480a43
    add esi, 0x777                               # 00480a46
    mov ecx, 0x9                                 # 00480a4c
    {load} xor eax, eax                          # 00480a51
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00480a53
    je.d8 L_00480a82                             # 00480a55
    # block 0x00480a57: entered by fall-through of je at 0x00480a55, 10 instruction(s), calls FUN_004fb2e3, KERNEL32.dll!GetTickCount, ends with forward jump to 0x00480a91
    mov ecx, dword ptr [ebp - local_4]           # 00480a57
    mov dx, word ptr [ecx + field_798]           # 00480a5a
    push edx                                     # 00480a61
    mov ecx, 0x5c3a67                            # 00480a62
    call FUN_004fb2e3                            # 00480a67
    call dword ptr [0x52a23c]                    # 00480a6c
    add eax, 0x12c                               # 00480a72
    mov ecx, dword ptr [ebp - local_8]           # 00480a77
    mov dword ptr [ecx + field_13e7], eax        # 00480a7a
    jmp.d8 L_00480a91                            # 00480a80
L_00480a82:
    # block 0x00480a82: entered by je at 0x00480a55, 3 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x00480a91
    call dword ptr [0x52a23c]                    # 00480a82
    mov edx, dword ptr [ebp - local_8]           # 00480a88
    mov dword ptr [edx + field_13e7], eax        # 00480a8b
L_00480a91:
    # block 0x00480a91: entered by jmp at 0x00480a80, 13 instruction(s), calls FUN_00480b34, KERNEL32.dll!GetTickCount, ends with ret
    mov ecx, dword ptr [ebp - local_8]           # 00480a91
    call FUN_00480b34                            # 00480a94
    mov eax, dword ptr [ebp - local_8]           # 00480a99
    mov dword ptr [eax + field_13ca], 0x4        # 00480a9c
    call dword ptr [0x52a23c]                    # 00480aa6
    add eax, 0x64                                # 00480aac
    mov ecx, dword ptr [ebp - local_8]           # 00480aaf
    mov dword ptr [ecx + field_13eb], eax        # 00480ab2
    pop edi                                      # 00480ab8
    pop esi                                      # 00480ab9
    {load} mov esp, ebp                          # 00480aba
    pop ebp                                      # 00480abc
    ret                                          # 00480abd

