# FUN_004631d1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004631d1
# extent:       0x004631d1-0x004632bf (238 code bytes)
# span:         0x004631d1-0x004632bf (code 238, tables 0, padding 0)
# sha256:       115e9a8ef37e51166c8b883eeb5c6ffb898d5518b68f1fa650698f3b9d57e586
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4631d1_check_piece
# naming:       native port src/original_methods_fl18.c:m4631d1_check_piece (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4631d1_check_piece. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 238 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_3f, field_270; [ecx + n] field_24, field_47; [edx + n] field_24, field_43, field_57
# callees:      calls FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/action_family_d3_runtime.h:cpz_click (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 63 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_3f, 0x3f  # offset +0x3f
.equ field_43, 0x43  # offset +0x43
.equ field_47, 0x47  # offset +0x47
.equ field_57, 0x57  # offset +0x57
.equ field_270, 0x270  # offset +0x270

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004631d1 - 0x401000
.globl FUN_004631d1
FUN_004631d1:
    # block 0x004631d1: entry, 14 instruction(s), ends with je to 0x004632b9 (forward)
    push ebp                                     # 004631d1
    {load} mov ebp, esp                          # 004631d2
    sub esp, 0x8                                 # 004631d4
    push esi                                     # 004631d7
    push edi                                     # 004631d8
    mov dword ptr [ebp - local_8], ecx           # 004631d9
    mov eax, dword ptr [ebp - local_8]           # 004631dc
    movsx ecx, word ptr [eax + field_1e]         # 004631df
    imul ecx, ecx, 0x8d                          # 004631e3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004631e9
    mov dword ptr [ebp - local_4], edx           # 004631ef
    mov eax, dword ptr [ebp - local_8]           # 004631f2
    cmp dword ptr [eax + field_3f], 0x0          # 004631f5
    je.d32 L_004632b9                            # 004631f9
    # block 0x004631ff: entered by fall-through of je at 0x004631f9, 3 instruction(s), ends with jne to 0x004632b9 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004631ff
    cmp dword ptr [ecx + field_47], 0x0          # 00463202
    jne.d32 L_004632b9                           # 00463206
    # block 0x0046320c: entered by fall-through of jne at 0x00463206, 3 instruction(s), ends with jne to 0x004632b9 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046320c
    cmp dword ptr [edx + field_24], 0x0          # 0046320f
    jne.d32 L_004632b9                           # 00463213
    # block 0x00463219: entered by fall-through of jne at 0x00463213, 5 instruction(s), ends with jne to 0x004632b9 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00463219
    movsx ecx, word ptr [eax + field_1e]         # 0046321c
    imul ecx, ecx, 0x8d                          # 00463220
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 00463226
    jne.d32 L_004632b9                           # 0046322d
    # block 0x00463233: entered by fall-through of jne at 0x0046322d, 2 instruction(s), ends with jne to 0x00463262 (forward)
    cmp dword ptr [0x5c39e5], 0x277f             # 00463233
    jne.d8 L_00463262                            # 0046323d
    # block 0x0046323f: entered by fall-through of jne at 0x0046323d, 7 instruction(s), ends with forward jump to 0x004632b9
    mov edx, dword ptr [ebp - local_8]           # 0046323f
    mov dword ptr [edx + field_43], 0x1          # 00463242
    mov eax, dword ptr [ebp - local_8]           # 00463249
    movsx ecx, word ptr [eax + field_1e]         # 0046324c
    imul ecx, ecx, 0x8d                          # 00463250
    mov dword ptr [ecx + 0x5bb632], 0x2          # 00463256
    jmp.d8 L_004632b9                            # 00463260
L_00463262:
    # block 0x00463262: entered by jne at 0x0046323d, 4 instruction(s), ends with je to 0x004632b9 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00463262
    movsx eax, word ptr [edx + field_57]         # 00463265
    test eax, eax                                # 00463269
    je.d8 L_004632b9                             # 0046326b
    # block 0x0046326d: entered by fall-through of je at 0x0046326b, 6 instruction(s), ends with je to 0x004632b9 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0046326d
    mov dword ptr [ecx + field_24], 0x2          # 00463270
    mov edx, dword ptr [ebp - local_8]           # 00463277
    movsx eax, word ptr [edx + field_57]         # 0046327a
    test eax, eax                                # 0046327e
    je.d8 L_004632b9                             # 00463280
    # block 0x00463282: entered by fall-through of je at 0x00463280, 2 instruction(s), ends with je to 0x004632b9 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 00463282
    je.d8 L_004632b9                             # 00463289
    # block 0x0046328b: entered by fall-through of je at 0x00463289, 7 instruction(s), ends with je to 0x004632b9 (forward)
    mov edi, 0x54b158                            # 0046328b
    mov esi, dword ptr [ebp - local_4]           # 00463290
    add esi, 0x24f                               # 00463293
    mov ecx, 0x9                                 # 00463299
    {load} xor edx, edx                          # 0046329e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004632a0
    je.d8 L_004632b9                             # 004632a2
    # block 0x004632a4: entered by fall-through of je at 0x004632a2, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004632b9
    mov eax, dword ptr [ebp - local_4]           # 004632a4
    mov cx, word ptr [eax + field_270]           # 004632a7
    push ecx                                     # 004632ae
    mov ecx, 0x5c3a67                            # 004632af
    call FUN_004fb2e3                            # 004632b4
L_004632b9:
    # block 0x004632b9: entered by je at 0x004631f9; jne at 0x00463206; jne at 0x00463213; jne at 0x0046322d; more, 5 instruction(s), ends with ret
    pop edi                                      # 004632b9
    pop esi                                      # 004632ba
    {load} mov esp, ebp                          # 004632bb
    pop ebp                                      # 004632bd
    ret                                          # 004632be

