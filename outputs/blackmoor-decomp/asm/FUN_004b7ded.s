# FUN_004b7ded
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7ded
# extent:       0x004b7ded-0x004b7ec2 (213 code bytes)
# span:         0x004b7ded-0x004b7ed0 (code 213, tables 0, padding 14)
# sha256:       83baf4768946c998ed996003060902f026fffa4a2ddc37db65aeab788e99898b
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_two_dial_puzzle_redraw
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4b7ded.c.txt, not original source) refers to the data labelled s_Two_Dial_puzzle__dial_one_00551cfc, s_Two_Dial_puzzle__dial_two_00551d18
# name-note:    Draws the two-dial puzzle dial one and dial two images when the redraw flag is set, tagged Two_Dial_puzzle dial strings.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_10, local_14
# fields:       [ecx + n] field_6b, field_1ab
# callees:      calls FUN_00457071, FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 60 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_6b, 0x6b  # offset +0x6b
.equ field_1ab, 0x1ab  # offset +0x1ab

# --- external targets -----------------------------------------------
.set FUN_00457071, .text + (0x00457071 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004b7ded - 0x401000
.globl FUN_004b7ded
FUN_004b7ded:
    # block 0x004b7ded: entry, 11 instruction(s), ends with je to 0x004b7ebe (forward)
    push ebp                                     # 004b7ded
    {load} mov ebp, esp                          # 004b7dee
    sub esp, 0x14                                # 004b7df0
    movsx eax, word ptr [0x6249c1]               # 004b7df3
    imul eax, eax, 0x8d                          # 004b7dfa
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b7e00
    mov dword ptr [ebp - local_14], ecx          # 004b7e06
    {load} xor edx, edx                          # 004b7e09
    mov dl, byte ptr [0x6249bc]                  # 004b7e0b
    test edx, edx                                # 004b7e11
    je.d32 L_004b7ebe                            # 004b7e13
    # block 0x004b7e19: entered by fall-through of je at 0x004b7e13, 46 instruction(s), calls FUN_00457071, FUN_004c5377, falls into the block at 0x004b7ebe
    lea eax, [ebp - local_10]                    # 004b7e19
    push eax                                     # 004b7e1c
    mov ecx, dword ptr [ebp - local_14]          # 004b7e1d
    add ecx, 0x4b                                # 004b7e20
    push ecx                                     # 004b7e23
    mov ecx, 0x6248ed                            # 004b7e24
    call FUN_00457071                            # 004b7e29
    push 0x551cfc                                # 004b7e2e
    lea edx, [ebp - local_10]                    # 004b7e33
    push edx                                     # 004b7e36
    movsx eax, word ptr [0x6249d1]               # 004b7e37
    shl eax, 0x4                                 # 004b7e3e
    mov ecx, dword ptr [ebp - local_14]          # 004b7e41
    lea edx, [ecx + eax + field_6b]              # 004b7e44
    push edx                                     # 004b7e48
    mov eax, dword ptr [0x5cf665]                # 004b7e49
    push eax                                     # 004b7e4e
    movsx ecx, word ptr [0x6249cf]               # 004b7e4f
    imul ecx, ecx, 0x4a                          # 004b7e56
    mov edx, dword ptr [ecx + 0x5d1599]          # 004b7e59
    push edx                                     # 004b7e5f
    mov ecx, 0x5cf659                            # 004b7e60
    call FUN_004c5377                            # 004b7e65
    lea eax, [ebp - local_10]                    # 004b7e6a
    push eax                                     # 004b7e6d
    mov ecx, dword ptr [ebp - local_14]          # 004b7e6e
    add ecx, 0x5b                                # 004b7e71
    push ecx                                     # 004b7e74
    mov ecx, 0x6248ed                            # 004b7e75
    call FUN_00457071                            # 004b7e7a
    push 0x551d18                                # 004b7e7f
    lea edx, [ebp - local_10]                    # 004b7e84
    push edx                                     # 004b7e87
    movsx eax, word ptr [0x6249d3]               # 004b7e88
    shl eax, 0x4                                 # 004b7e8f
    mov ecx, dword ptr [ebp - local_14]          # 004b7e92
    lea edx, [ecx + eax + field_1ab]             # 004b7e95
    push edx                                     # 004b7e9c
    mov eax, dword ptr [0x5cf665]                # 004b7e9d
    push eax                                     # 004b7ea2
    movsx ecx, word ptr [0x6249cf]               # 004b7ea3
    imul ecx, ecx, 0x4a                          # 004b7eaa
    mov edx, dword ptr [ecx + 0x5d1599]          # 004b7ead
    push edx                                     # 004b7eb3
    mov ecx, 0x5cf659                            # 004b7eb4
    call FUN_004c5377                            # 004b7eb9
L_004b7ebe:
    # block 0x004b7ebe: entered by je at 0x004b7e13, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b7ebe
    pop ebp                                      # 004b7ec0
    ret                                          # 004b7ec1

# --- data items (not part of the function) -------------------------
.org 0x004b7ec2 - 0x401000
PAD_004b7ec2:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

