# FUN_00480abe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00480abe
# extent:       0x00480abe-0x00480b34 (118 code bytes)
# span:         0x00480abe-0x00480b34 (code 118, tables 0, padding 0)
# sha256:       ba681aed048f368ca378977728503946fe6779cdc8521ed735098d751d2c2801
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         sound_rotate_480abe
# naming:       native port src/action_family_eb_runtime.c:sound_rotate_480abe (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with sound_rotate_480abe (record +0x715, channel +0x736, delay 0x15e, state 1). Body is a parameter; sound_play/tick are host callbacks; oracle aggregate.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e; [ecx + n] field_736, field_13e7; [edx + n] field_13ca
# callees:      calls FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:sound_rotate_480abe (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 34 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_736, 0x736  # offset +0x736
.equ field_13ca, 0x13ca  # offset +0x13ca
.equ field_13e7, 0x13e7  # offset +0x13e7

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00480abe - 0x401000
.globl FUN_00480abe
FUN_00480abe:
    # block 0x00480abe: entry, 18 instruction(s), ends with je to 0x00480b2e (forward)
    push ebp                                     # 00480abe
    {load} mov ebp, esp                          # 00480abf
    sub esp, 0x8                                 # 00480ac1
    push esi                                     # 00480ac4
    push edi                                     # 00480ac5
    mov dword ptr [ebp - local_8], ecx           # 00480ac6
    mov eax, dword ptr [ebp - local_8]           # 00480ac9
    movsx ecx, word ptr [eax + field_1e]         # 00480acc
    imul ecx, ecx, 0x8d                          # 00480ad0
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00480ad6
    mov dword ptr [ebp - local_4], edx           # 00480adc
    mov edi, 0x54d5d0                            # 00480adf
    mov esi, dword ptr [ebp - local_4]           # 00480ae4
    add esi, 0x715                               # 00480ae7
    mov ecx, 0x9                                 # 00480aed
    {load} xor eax, eax                          # 00480af2
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00480af4
    je.d8 L_00480b2e                             # 00480af6
    # block 0x00480af8: entered by fall-through of je at 0x00480af6, 11 instruction(s), calls FUN_004fb2e3, KERNEL32.dll!GetTickCount, falls into the block at 0x00480b2e
    mov ecx, dword ptr [ebp - local_4]           # 00480af8
    mov dx, word ptr [ecx + field_736]           # 00480afb
    push edx                                     # 00480b02
    mov ecx, 0x5c3a67                            # 00480b03
    call FUN_004fb2e3                            # 00480b08
    call dword ptr [0x52a23c]                    # 00480b0d
    add eax, 0x15e                               # 00480b13
    mov ecx, dword ptr [ebp - local_8]           # 00480b18
    mov dword ptr [ecx + field_13e7], eax        # 00480b1b
    mov edx, dword ptr [ebp - local_8]           # 00480b21
    mov dword ptr [edx + field_13ca], 0x1        # 00480b24
L_00480b2e:
    # block 0x00480b2e: entered by je at 0x00480af6, 5 instruction(s), ends with ret
    pop edi                                      # 00480b2e
    pop esi                                      # 00480b2f
    {load} mov esp, ebp                          # 00480b30
    pop ebp                                      # 00480b32
    ret                                          # 00480b33

