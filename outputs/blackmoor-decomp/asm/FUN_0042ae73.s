# FUN_0042ae73
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042ae73
# extent:       0x0042ae73-0x0042b07e (523 code bytes)
# span:         0x0042ae73-0x0042b07e (code 523, tables 0, padding 0)
# sha256:       48d63750bd18989845fc3046817967c1cdc8f192d2590a803121d7bce5f374f6
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# name:         SceneHotspotAction0x0d::Execute
# arguments:    cdecl-style: no this (ecx is not read, the push ecx only reserves the local), one stack argument [ebp+8] = action slot index as a sign-extended 16-bit word, plain ret so the caller pops it, no return value (eax is left as the last scratch value). Slot address = 0x5bb5e3 + index * 0x8d (stride 0x8d)
# locals:       [ebp-local_phase] = the slot executor phase dword read from slot+0x4f (0x5bb632 + index*0x8d), switched on 0, 1, 2 (any other value returns at once)
# fields:       slot+0x02: dword payload pointer (0x5bb5e5 + index*0x8d), dereferenced for every payload read. slot+0x42: byte completion latch (0x5bb625), written 1 in phase 2. slot+0x43: dword hotspot-active flag (0x5bb626), written 1 or 0 by the frame compare. slot+0x47, +0x49, +0x4b, +0x4d: words (0x5bb62a, 0x5bb62c, 0x5bb62e, 0x5bb630) written in phase 0 from payload +0x18, +0x1c, +0x20, +0x24 (low 16 bits of each dword). slot+0x4f: dword phase (0x5bb632), read, written 1 in phase 0. Payload: +0x02 word (sign-extended to dword 0x5bb57b), +0x04 word (0x5bb599), +0x06 word (0x5bb595), +0x08 word (0x5c39ff), +0x0a dword (0x5bb59b), +0x0e dword (0x5bb59f), +0x12 dword (0x5bb5a3), +0x16 word (frame, compared with word 0x5bb50b), +0x18/+0x1c/+0x20/+0x24 dwords (rectangle). Globals: 0x5bb1ca = 1 in phase 0, 0x583999 = 4 in phase 2, 0x5bb50b word read
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/scene_executor.c:apply_builtin_hotspot
# unverified:   Track N correspondence is partial: apply_builtin_hotspot covers the runtime-type-0x0d branch only (the same C function also holds the type 0x6a branch for another original executor), restructures the effects (the rectangle becomes a SceneExecutorHotspotState, the phase 2 globals become a transition request) and does not model the phase 0 store of 0x5bb1ca = 1 (whose meaning is not established here). Its comment cites this address, but I did not compare it step by step. Names are my labels, the rectangle labels (left, top, right, bottom) follow s0-action-runtime-trace.md and the scene_executor.c reader, while the bytes only prove which payload dword goes to which slot word. That payload +0x16 is the hotspot frame and 0x5bb50b the current frame comes from s0-interaction-recovery.md, not from a traced writer. The meaning of 0x5bb57b, 0x5bb599, 0x5bb595, 0x5c39ff, 0x5bb59b, 0x5bb59f, 0x5bb5a3 as transition globals is from that same document and is not re-derived. Callers are not traced in this file (the dispatcher 0x427a50 is named by the pseudocode hint only).
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_phase, 0x4  # slot executor phase read from slot+0x4f, switched on 0, 1, 2
.equ pl_target_scene, 0x2  # payload+0x02: word, sign-extended into dword 0x5bb57b in phase 2
.equ pl_word_04, 0x4  # payload+0x04: word, copied to word 0x5bb599 in phase 2
.equ pl_word_06, 0x6  # payload+0x06: word, copied to word 0x5bb595 in phase 2
.equ arg_slot_index, 0x8  # stack argument: action slot index, 16-bit word read with sign extension, slot stride 0x8d
.equ pl_word_08, 0x8  # payload+0x08: word, copied to word 0x5c39ff in phase 2
.equ pl_dword_0a, 0xa  # payload+0x0a: dword, copied to 0x5bb59b in phase 2
.equ pl_dword_0e, 0xe  # payload+0x0e: dword, copied to 0x5bb59f in phase 2
.equ pl_dword_12, 0x12  # payload+0x12: dword, copied to 0x5bb5a3 in phase 2
.equ pl_frame, 0x16  # payload+0x16: word compared with the word at 0x5bb50b in phase 1
.equ pl_rect_left, 0x18  # payload+0x18: dword, low word copied to slot+0x47 in phase 0
.equ pl_rect_top, 0x1c  # payload+0x1c: dword, low word copied to slot+0x49 in phase 0
.equ pl_rect_right, 0x20  # payload+0x20: dword, low word copied to slot+0x4b in phase 0
.equ pl_rect_bottom, 0x24  # payload+0x24: dword, low word copied to slot+0x4d in phase 0

# --- external targets -----------------------------------------------

.org 0x0042ae73 - 0x401000
.globl FUN_0042ae73
FUN_0042ae73:
    # block 0x0042ae73: entry: local_phase = slot+0x4f (dword at 0x5bb632 + index*0x8d), if phase == 0 go to phase0_start (je)
    push ebp                                     # 0042ae73
    {load} mov ebp, esp                          # 0042ae74
    push ecx                                     # 0042ae76
    movsx eax, word ptr [ebp + arg_slot_index]            # 0042ae77
    imul eax, eax, 0x8d                          # 0042ae7b
    mov ecx, dword ptr [eax + 0x5bb632]          # 0042ae81
    mov dword ptr [ebp - local_phase], ecx           # 0042ae87
    cmp dword ptr [ebp - local_phase], 0x0           # 0042ae8a
    je.d8 phase0_start                             # 0042ae8e
    # block 0x0042ae90: phase != 0: if phase == 1 go to phase1_frame_test (je)
    cmp dword ptr [ebp - local_phase], 0x1           # 0042ae90
    je.d32 phase1_frame_test                            # 0042ae94
    # block 0x0042ae9a: phase != 1: if phase == 2 go to phase2_finish (je)
    cmp dword ptr [ebp - local_phase], 0x2           # 0042ae9a
    je.d32 phase2_finish                            # 0042ae9e
    # block 0x0042aea4: phase is not 0, 1 or 2: return without effects
    jmp.d32 epilogue                           # 0042aea4
phase0_start:
    # block 0x0042aea9: phase0_start: 0x5bb1ca = 1, then copy payload +0x18, +0x1c, +0x20, +0x24 (low words) to slot words +0x47, +0x49, +0x4b, +0x4d, then slot phase +0x4f = 1 and fall into phase1_frame_test
    mov dword ptr [0x5bb1ca], 0x1                # 0042aea9
    movsx edx, word ptr [ebp + arg_slot_index]            # 0042aeb3
    imul edx, edx, 0x8d                          # 0042aeb7
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042aebd
    movsx ecx, word ptr [ebp + arg_slot_index]            # 0042aec3
    imul ecx, ecx, 0x8d                          # 0042aec7
    mov dx, word ptr [eax + pl_rect_left]            # 0042aecd
    mov word ptr [ecx + 0x5bb62a], dx            # 0042aed1
    movsx eax, word ptr [ebp + arg_slot_index]            # 0042aed8
    imul eax, eax, 0x8d                          # 0042aedc
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042aee2
    movsx edx, word ptr [ebp + arg_slot_index]            # 0042aee8
    imul edx, edx, 0x8d                          # 0042aeec
    mov ax, word ptr [ecx + pl_rect_top]            # 0042aef2
    mov word ptr [edx + 0x5bb62c], ax            # 0042aef6
    movsx ecx, word ptr [ebp + arg_slot_index]            # 0042aefd
    imul ecx, ecx, 0x8d                          # 0042af01
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042af07
    movsx eax, word ptr [ebp + arg_slot_index]            # 0042af0d
    imul eax, eax, 0x8d                          # 0042af11
    mov cx, word ptr [edx + pl_rect_right]            # 0042af17
    mov word ptr [eax + 0x5bb62e], cx            # 0042af1b
    movsx edx, word ptr [ebp + arg_slot_index]            # 0042af22
    imul edx, edx, 0x8d                          # 0042af26
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042af2c
    movsx ecx, word ptr [ebp + arg_slot_index]            # 0042af32
    imul ecx, ecx, 0x8d                          # 0042af36
    mov dx, word ptr [eax + pl_rect_bottom]            # 0042af3c
    mov word ptr [ecx + 0x5bb630], dx            # 0042af40
    movsx eax, word ptr [ebp + arg_slot_index]            # 0042af47
    imul eax, eax, 0x8d                          # 0042af4b
    mov dword ptr [eax + 0x5bb632], 0x1          # 0042af51
phase1_frame_test:
    # block 0x0042af5b: phase1_frame_test (also reached from phase 0): payload frame word +0x16 sign-extended compared with word 0x5bb50b, if not equal go to frame_mismatch (jne)
    movsx ecx, word ptr [ebp + arg_slot_index]            # 0042af5b
    imul ecx, ecx, 0x8d                          # 0042af5f
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042af65
    movsx eax, word ptr [edx + pl_frame]         # 0042af6b
    movsx ecx, word ptr [0x5bb50b]               # 0042af6f
    {load} cmp eax, ecx                          # 0042af76
    jne.d8 frame_mismatch                            # 0042af78
    # block 0x0042af7a: frame equal: slot+0x43 (dword 0x5bb626, hotspot active) = 1, go to frame_done
    movsx edx, word ptr [ebp + arg_slot_index]            # 0042af7a
    imul edx, edx, 0x8d                          # 0042af7e
    mov dword ptr [edx + 0x5bb626], 0x1          # 0042af84
    jmp.d8 frame_done                            # 0042af8e
frame_mismatch:
    # block 0x0042af90: frame_mismatch: slot+0x43 (dword 0x5bb626, hotspot active) = 0
    movsx eax, word ptr [ebp + arg_slot_index]            # 0042af90
    imul eax, eax, 0x8d                          # 0042af94
    mov dword ptr [eax + 0x5bb626], 0x0          # 0042af9a
frame_done:
    # block 0x0042afa4: frame_done: jump to the epilogue
    jmp.d32 epilogue                           # 0042afa4
phase2_finish:
    # block 0x0042afa9: phase2_finish: slot+0x42 (byte 0x5bb625, completion latch) = 1, then copy payload +0x02 (sign-extended) to dword 0x5bb57b, +0x04 to word 0x5bb599, +0x06 to word 0x5bb595, +0x08 to word 0x5c39ff, +0x0a, +0x0e, +0x12 to dwords 0x5bb59b, 0x5bb59f, 0x5bb5a3, finally engine state dword 0x583999 = 4
    movsx ecx, word ptr [ebp + arg_slot_index]            # 0042afa9
    imul ecx, ecx, 0x8d                          # 0042afad
    mov byte ptr [ecx + 0x5bb625], 0x1           # 0042afb3
    movsx edx, word ptr [ebp + arg_slot_index]            # 0042afba
    imul edx, edx, 0x8d                          # 0042afbe
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042afc4
    movsx ecx, word ptr [eax + pl_target_scene]          # 0042afca
    mov dword ptr [0x5bb57b], ecx                # 0042afce
    movsx edx, word ptr [ebp + arg_slot_index]            # 0042afd4
    imul edx, edx, 0x8d                          # 0042afd8
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042afde
    mov cx, word ptr [eax + pl_word_04]             # 0042afe4
    mov word ptr [0x5bb599], cx                  # 0042afe8
    movsx edx, word ptr [ebp + arg_slot_index]            # 0042afef
    imul edx, edx, 0x8d                          # 0042aff3
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042aff9
    mov cx, word ptr [eax + pl_word_06]             # 0042afff
    mov word ptr [0x5bb595], cx                  # 0042b003
    movsx edx, word ptr [ebp + arg_slot_index]            # 0042b00a
    imul edx, edx, 0x8d                          # 0042b00e
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b014
    mov cx, word ptr [eax + pl_word_08]             # 0042b01a
    mov word ptr [0x5c39ff], cx                  # 0042b01e
    movsx edx, word ptr [ebp + arg_slot_index]            # 0042b025
    imul edx, edx, 0x8d                          # 0042b029
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b02f
    mov ecx, dword ptr [eax + pl_dword_0a]           # 0042b035
    mov dword ptr [0x5bb59b], ecx                # 0042b038
    movsx edx, word ptr [ebp + arg_slot_index]            # 0042b03e
    imul edx, edx, 0x8d                          # 0042b042
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b048
    mov ecx, dword ptr [eax + pl_dword_0e]           # 0042b04e
    mov dword ptr [0x5bb59f], ecx                # 0042b051
    movsx edx, word ptr [ebp + arg_slot_index]            # 0042b057
    imul edx, edx, 0x8d                          # 0042b05b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b061
    mov ecx, dword ptr [eax + pl_dword_12]          # 0042b067
    mov dword ptr [0x5bb5a3], ecx                # 0042b06a
    mov dword ptr [0x583999], 0x4                # 0042b070
epilogue:
    # block 0x0042b07a: epilogue: restore the frame, plain ret (caller pops the argument)
    {load} mov esp, ebp                          # 0042b07a
    pop ebp                                      # 0042b07c
    ret                                          # 0042b07d
