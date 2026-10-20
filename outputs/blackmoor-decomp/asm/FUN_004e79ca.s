# FUN_004e79ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e79ca
# extent:       0x004e79ca-0x004e7a10 (70 code bytes)
# span:         0x004e79ca-0x004e7a10 (code 70, tables 0, padding 0)
# sha256:       993cc294c089d5d804e2642cb8844e65050a43bda10b11ea9088a424e2bcb2d0
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_convo_text_box_restore
# naming:       INFERRED (lower confidence, not verified): the repository text src/caption_lifecycle.h:227 says "0x4d3705 -> 0x4e79ca CUIConvo::RestoreTextBox"
# name-note:    CUIConvo::RestoreTextBox, the layer 9 restore callback target.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ee630, FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004ee630, .text + (0x004ee630 - 0x401000)

.org 0x004e79ca - 0x401000
.globl FUN_004e79ca
FUN_004e79ca:
    # block 0x004e79ca: entry, 9 instruction(s), calls FUN_004ee630, ends with je to 0x004e7a0c (forward)
    push ebp                                     # 004e79ca
    {load} mov ebp, esp                          # 004e79cb
    sub esp, 0x8                                 # 004e79cd
    mov dword ptr [ebp - local_8], ecx           # 004e79d0
    mov ecx, dword ptr [ebp - local_8]           # 004e79d3
    call FUN_004ee630                            # 004e79d6
    mov dword ptr [ebp - local_4], eax           # 004e79db
    cmp dword ptr [ebp - local_4], 0x0           # 004e79de
    je.d8 L_004e7a0c                             # 004e79e2
    # block 0x004e79e4: entered by fall-through of je at 0x004e79e2, 11 instruction(s), calls FUN_004c5377, falls into the block at 0x004e7a0c
    push 0x55c514                                # 004e79e4
    push 0x5b0227                                # 004e79e9
    mov eax, dword ptr [ebp - local_8]           # 004e79ee
    add eax, 0x981                               # 004e79f1
    push eax                                     # 004e79f6
    mov ecx, dword ptr [0x5cf665]                # 004e79f7
    push ecx                                     # 004e79fd
    mov edx, dword ptr [ebp - local_4]           # 004e79fe
    push edx                                     # 004e7a01
    mov ecx, 0x5cf659                            # 004e7a02
    call FUN_004c5377                            # 004e7a07
L_004e7a0c:
    # block 0x004e7a0c: entered by je at 0x004e79e2, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e7a0c
    pop ebp                                      # 004e7a0e
    ret                                          # 004e7a0f

