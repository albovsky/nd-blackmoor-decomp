# FUN_004b7051
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7051
# extent:       0x004b7051-0x004b70d1 (128 code bytes)
# span:         0x004b7051-0x004b70e0 (code 128, tables 0, padding 15)
# sha256:       af85b209471a5d9e5ed0aa6379f1f5f66035b1a8521a0a628ba0189d75024220
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b7051_draw_list
# naming:       native port src/original_methods_fl18.c:m4b7051_draw_list (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4b7051_draw_list. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 128 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_21
# callees:      calls FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:create_native_scene_session (function ledger class native_oracle_verified; also native_ad1_render, native_caption_finish_tick; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 37 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_21, 0x21  # offset +0x21

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004b7051 - 0x401000
.globl FUN_004b7051
FUN_004b7051:
    # block 0x004b7051: entry, 9 instruction(s), ends with forward jump to 0x004b707f
    push ebp                                     # 004b7051
    {load} mov ebp, esp                          # 004b7052
    sub esp, 0x8                                 # 004b7054
    movsx eax, word ptr [0x61d467]               # 004b7057
    imul eax, eax, 0x8d                          # 004b705e
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b7064
    mov dword ptr [ebp - local_8], ecx           # 004b706a
    mov dword ptr [ebp - local_4], 0x0           # 004b706d
    jmp.d8 L_004b707f                            # 004b7074
L_004b7076:
    # block 0x004b7076: entered by jmp at 0x004b70cb, 3 instruction(s), falls into the block at 0x004b707f
    mov edx, dword ptr [ebp - local_4]           # 004b7076
    add edx, 0x1                                 # 004b7079
    mov dword ptr [ebp - local_4], edx           # 004b707c
L_004b707f:
    # block 0x004b707f: entered by jmp at 0x004b7074, 4 instruction(s), ends with jge to 0x004b70cd (forward)
    mov eax, dword ptr [ebp - local_8]           # 004b707f
    movsx ecx, word ptr [eax + field_21]         # 004b7082
    cmp dword ptr [ebp - local_4], ecx           # 004b7086
    jge.d8 L_004b70cd                            # 004b7089
    # block 0x004b708b: entered by fall-through of jge at 0x004b7089, 18 instruction(s), calls FUN_004c5377, ends with backward jump to 0x004b7076
    push 0x551bb0                                # 004b708b
    mov edx, dword ptr [ebp - local_4]           # 004b7090
    shl edx, 0x4                                 # 004b7093
    add edx, 0x61d56d                            # 004b7096
    push edx                                     # 004b709c
    mov eax, dword ptr [ebp - local_4]           # 004b709d
    shl eax, 0x4                                 # 004b70a0
    add eax, 0x61d46d                            # 004b70a3
    push eax                                     # 004b70a8
    mov ecx, dword ptr [0x5cf665]                # 004b70a9
    push ecx                                     # 004b70af
    movsx edx, word ptr [0x61d465]               # 004b70b0
    imul edx, edx, 0x4a                          # 004b70b7
    mov eax, dword ptr [edx + 0x5d1599]          # 004b70ba
    push eax                                     # 004b70c0
    mov ecx, 0x5cf659                            # 004b70c1
    call FUN_004c5377                            # 004b70c6
    jmp.d8 L_004b7076                            # 004b70cb
L_004b70cd:
    # block 0x004b70cd: entered by jge at 0x004b7089, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b70cd
    pop ebp                                      # 004b70cf
    ret                                          # 004b70d0

# --- data items (not part of the function) -------------------------
.org 0x004b70d1 - 0x401000
PAD_004b70d1:  # 15 byte(s) of int3 padding
    .fill 15, 1, 0xcc

