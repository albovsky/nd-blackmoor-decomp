# FUN_0045432f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045432f
# extent:       0x0045432f-0x0045441d (238 code bytes)
# span:         0x0045432f-0x0045441d (code 238, tables 0, padding 0)
# sha256:       a0b3034801ca49e7df4063d99831d39303fdc175c31375468851024fac20b6fb
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_cycling_sound_trigger
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/45432f.c.txt, not original source) refers to the data labelled s_NO_SOUND_00549df8, s_NO_SOUND_00549e04
# name-note:    Cycles a counter 0-2 and plays the matching sound slot through FUN_004fb2e3 unless its name field equals NO_SOUND.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_5d3, field_604, field_635, field_6af; [ecx + n] field_6af; [edx + n] field_6af
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 68 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_5d3, 0x5d3  # offset +0x5d3
.equ field_604, 0x604  # offset +0x604
.equ field_635, 0x635  # offset +0x635
.equ field_6af, 0x6af  # offset +0x6af

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0045432f - 0x401000
.globl FUN_0045432f
FUN_0045432f:
    # block 0x0045432f: entry, 11 instruction(s), ends with je to 0x0045435d (forward)
    push ebp                                     # 0045432f
    {load} mov ebp, esp                          # 00454330
    sub esp, 0x8                                 # 00454332
    push esi                                     # 00454335
    push edi                                     # 00454336
    mov dword ptr [ebp - local_4], ecx           # 00454337
    mov eax, dword ptr [ebp - local_4]           # 0045433a
    mov ecx, dword ptr [eax + field_6af]         # 0045433d
    mov dword ptr [ebp - local_8], ecx           # 00454343
    cmp dword ptr [ebp - local_8], 0x0           # 00454346
    je.d8 L_0045435d                             # 0045434a
    # block 0x0045434c: entered by fall-through of je at 0x0045434a, 2 instruction(s), ends with je to 0x0045438d (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 0045434c
    je.d8 L_0045438d                             # 00454350
    # block 0x00454352: entered by fall-through of je at 0x00454350, 2 instruction(s), ends with je to 0x004543bb (forward)
    cmp dword ptr [ebp - local_8], 0x2           # 00454352
    je.d8 L_004543bb                             # 00454356
    # block 0x00454358: entered by fall-through of je at 0x00454356, 1 instruction(s), ends with forward jump to 0x004543e9
    jmp.d32 L_004543e9                           # 00454358
L_0045435d:
    # block 0x0045435d: entered by je at 0x0045434a, 7 instruction(s), ends with je to 0x0045438b (forward)
    mov edi, 0x549df8                            # 0045435d
    mov esi, dword ptr [ebp - local_4]           # 00454362
    add esi, 0x5b2                               # 00454365
    mov ecx, 0x9                                 # 0045436b
    {load} xor edx, edx                          # 00454370
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00454372
    je.d8 L_0045438b                             # 00454374
    # block 0x00454376: entered by fall-through of je at 0x00454374, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0045438b
    mov eax, dword ptr [ebp - local_4]           # 00454376
    mov cx, word ptr [eax + field_5d3]           # 00454379
    push ecx                                     # 00454380
    mov ecx, 0x5c3a67                            # 00454381
    call FUN_004fb2e3                            # 00454386
L_0045438b:
    # block 0x0045438b: entered by je at 0x00454374, 1 instruction(s), ends with forward jump to 0x004543e9
    jmp.d8 L_004543e9                            # 0045438b
L_0045438d:
    # block 0x0045438d: entered by je at 0x00454350, 7 instruction(s), ends with je to 0x004543bb (forward)
    mov edi, 0x549e04                            # 0045438d
    mov esi, dword ptr [ebp - local_4]           # 00454392
    add esi, 0x5e3                               # 00454395
    mov ecx, 0x9                                 # 0045439b
    {load} xor edx, edx                          # 004543a0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004543a2
    je.d8 L_004543bb                             # 004543a4
    # block 0x004543a6: entered by fall-through of je at 0x004543a4, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004543bb
    mov eax, dword ptr [ebp - local_4]           # 004543a6
    mov cx, word ptr [eax + field_604]           # 004543a9
    push ecx                                     # 004543b0
    mov ecx, 0x5c3a67                            # 004543b1
    call FUN_004fb2e3                            # 004543b6
L_004543bb:
    # block 0x004543bb: entered by je at 0x00454356; je at 0x004543a4, 7 instruction(s), ends with je to 0x004543e9 (forward)
    mov edi, 0x549e10                            # 004543bb
    mov esi, dword ptr [ebp - local_4]           # 004543c0
    add esi, 0x614                               # 004543c3
    mov ecx, 0x9                                 # 004543c9
    {load} xor edx, edx                          # 004543ce
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004543d0
    je.d8 L_004543e9                             # 004543d2
    # block 0x004543d4: entered by fall-through of je at 0x004543d2, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004543e9
    mov eax, dword ptr [ebp - local_4]           # 004543d4
    mov cx, word ptr [eax + field_635]           # 004543d7
    push ecx                                     # 004543de
    mov ecx, 0x5c3a67                            # 004543df
    call FUN_004fb2e3                            # 004543e4
L_004543e9:
    # block 0x004543e9: entered by jmp at 0x00454358; jmp at 0x0045438b; je at 0x004543d2, 8 instruction(s), ends with jl to 0x00454417 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004543e9
    mov eax, dword ptr [edx + field_6af]         # 004543ec
    add eax, 0x1                                 # 004543f2
    mov ecx, dword ptr [ebp - local_4]           # 004543f5
    mov dword ptr [ecx + field_6af], eax         # 004543f8
    mov edx, dword ptr [ebp - local_4]           # 004543fe
    cmp dword ptr [edx + field_6af], 0x3         # 00454401
    jl.d8 L_00454417                             # 00454408
    # block 0x0045440a: entered by fall-through of jl at 0x00454408, 2 instruction(s), falls into the block at 0x00454417
    mov eax, dword ptr [ebp - local_4]           # 0045440a
    mov dword ptr [eax + field_6af], 0x0         # 0045440d
L_00454417:
    # block 0x00454417: entered by jl at 0x00454408, 5 instruction(s), ends with ret
    pop edi                                      # 00454417
    pop esi                                      # 00454418
    {load} mov esp, ebp                          # 00454419
    pop ebp                                      # 0045441b
    ret                                          # 0045441c

