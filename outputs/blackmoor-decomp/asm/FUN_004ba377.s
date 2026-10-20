# FUN_004ba377
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ba377
# extent:       0x004ba377-0x004ba486 (271 code bytes)
# span:         0x004ba377-0x004ba486 (code 271, tables 0, padding 0)
# sha256:       99fb0a1f6ce219cee96086474a801c07a01d25d1be1ab4111638b6cd5d2b509b
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ba377_hit_test
# naming:       native port src/original_methods_fl23a.c:m4ba377_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4ba377_hit_test (callees via host). Direct: objects, ordered calls, edges. Unicorn differential: 300 fixtures, every instruction reached. Window covers all 271 bytes. See tasks/fl23a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_18, field_24, field_34, field_310, field_7f0, field_7f4; [ecx + n] field_18, field_2d4, field_310, field_7ec; [edx + n] field_18, field_310, field_7f8
# callees:      calls FUN_004ba486
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:native_pointer_consume (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 69 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_18, 0x18  # offset +0x18
.equ field_24, 0x24  # offset +0x24
.equ field_34, 0x34  # offset +0x34
.equ field_2d4, 0x2d4  # offset +0x2d4
.equ field_310, 0x310  # offset +0x310
.equ field_7ec, 0x7ec  # offset +0x7ec
.equ field_7f0, 0x7f0  # offset +0x7f0
.equ field_7f4, 0x7f4  # offset +0x7f4
.equ field_7f8, 0x7f8  # offset +0x7f8

# --- external targets -----------------------------------------------
.set FUN_004ba486, .text + (0x004ba486 - 0x401000)

.org 0x004ba377 - 0x401000
.globl FUN_004ba377
FUN_004ba377:
    # block 0x004ba377: entry, 7 instruction(s), ends with je to 0x004ba47e (forward)
    push ebp                                     # 004ba377
    {load} mov ebp, esp                          # 004ba378
    push ecx                                     # 004ba37a
    mov dword ptr [ebp - local_4], ecx           # 004ba37b
    mov eax, dword ptr [ebp - local_4]           # 004ba37e
    cmp dword ptr [eax + field_34], 0x0          # 004ba381
    je.d32 L_004ba47e                            # 004ba385
    # block 0x004ba38b: entered by fall-through of je at 0x004ba385, 5 instruction(s), ends with forward jump to 0x004ba3bc
    mov ecx, dword ptr [ebp - local_4]           # 004ba38b
    mov dword ptr [ecx + field_2d4], 0xffffffff  # 004ba38e
    mov edx, dword ptr [ebp - local_4]           # 004ba398
    mov dword ptr [edx + field_310], 0x0         # 004ba39b
    jmp.d8 L_004ba3bc                            # 004ba3a5
L_004ba3a7:
    # block 0x004ba3a7: entered by jmp at 0x004ba479, 5 instruction(s), falls into the block at 0x004ba3bc
    mov eax, dword ptr [ebp - local_4]           # 004ba3a7
    mov ecx, dword ptr [eax + field_310]         # 004ba3aa
    add ecx, 0x1                                 # 004ba3b0
    mov edx, dword ptr [ebp - local_4]           # 004ba3b3
    mov dword ptr [edx + field_310], ecx         # 004ba3b6
L_004ba3bc:
    # block 0x004ba3bc: entered by jmp at 0x004ba3a5, 3 instruction(s), ends with jge to 0x004ba47e (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ba3bc
    cmp dword ptr [eax + field_310], 0x2         # 004ba3bf
    jge.d32 L_004ba47e                           # 004ba3c6
    # block 0x004ba3cc: entered by fall-through of jge at 0x004ba3c6, 5 instruction(s), ends with jne to 0x004ba479 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ba3cc
    mov edx, dword ptr [ecx + field_310]         # 004ba3cf
    mov eax, dword ptr [ebp - local_4]           # 004ba3d5
    cmp dword ptr [eax + 8*edx + field_24], 0x0  # 004ba3d8
    jne.d32 L_004ba479                           # 004ba3dd
    # block 0x004ba3e3: entered by fall-through of jne at 0x004ba3dd, 8 instruction(s), ends with jl to 0x004ba479 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004ba3e3
    mov edx, dword ptr [ebp - local_4]           # 004ba3e7
    mov eax, dword ptr [edx + field_18]          # 004ba3ea
    mov edx, dword ptr [ebp - local_4]           # 004ba3ed
    mov edx, dword ptr [edx + field_310]         # 004ba3f0
    shl edx, 0x4                                 # 004ba3f6
    cmp ecx, dword ptr [eax + edx + field_7f0]   # 004ba3f9
    jl.d8 L_004ba479                             # 004ba400
    # block 0x004ba402: entered by fall-through of jl at 0x004ba400, 8 instruction(s), ends with jg to 0x004ba479 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004ba402
    mov ecx, dword ptr [ebp - local_4]           # 004ba406
    mov edx, dword ptr [ecx + field_18]          # 004ba409
    mov ecx, dword ptr [ebp - local_4]           # 004ba40c
    mov ecx, dword ptr [ecx + field_310]         # 004ba40f
    shl ecx, 0x4                                 # 004ba415
    cmp eax, dword ptr [edx + ecx + field_7f8]   # 004ba418
    jg.d8 L_004ba479                             # 004ba41f
    # block 0x004ba421: entered by fall-through of jg at 0x004ba41f, 8 instruction(s), ends with jl to 0x004ba479 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004ba421
    mov eax, dword ptr [ebp - local_4]           # 004ba425
    mov ecx, dword ptr [eax + field_18]          # 004ba428
    mov eax, dword ptr [ebp - local_4]           # 004ba42b
    mov eax, dword ptr [eax + field_310]         # 004ba42e
    shl eax, 0x4                                 # 004ba434
    cmp edx, dword ptr [ecx + eax + field_7ec]   # 004ba437
    jl.d8 L_004ba479                             # 004ba43e
    # block 0x004ba440: entered by fall-through of jl at 0x004ba43e, 8 instruction(s), ends with jg to 0x004ba479 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004ba440
    mov edx, dword ptr [ebp - local_4]           # 004ba444
    mov eax, dword ptr [edx + field_18]          # 004ba447
    mov edx, dword ptr [ebp - local_4]           # 004ba44a
    mov edx, dword ptr [edx + field_310]         # 004ba44d
    shl edx, 0x4                                 # 004ba453
    cmp ecx, dword ptr [eax + edx + field_7f4]   # 004ba456
    jg.d8 L_004ba479                             # 004ba45d
    # block 0x004ba45f: entered by fall-through of jg at 0x004ba45d, 7 instruction(s), calls FUN_004ba486, ends with forward jump to 0x004ba480
    mov eax, dword ptr [ebp - local_4]           # 004ba45f
    mov cx, word ptr [eax + field_310]           # 004ba462
    push ecx                                     # 004ba469
    mov ecx, dword ptr [ebp - local_4]           # 004ba46a
    call FUN_004ba486                            # 004ba46d
    mov eax, 0x1                                 # 004ba472
    jmp.d8 L_004ba480                            # 004ba477
L_004ba479:
    # block 0x004ba479: entered by jne at 0x004ba3dd; jl at 0x004ba400; jg at 0x004ba41f; jl at 0x004ba43e; jg at 0x004ba45d, 1 instruction(s), ends with backward jump to 0x004ba3a7
    jmp.d32 L_004ba3a7                           # 004ba479
L_004ba47e:
    # block 0x004ba47e: entered by je at 0x004ba385; jge at 0x004ba3c6, 1 instruction(s), falls into the block at 0x004ba480
    {load} xor eax, eax                          # 004ba47e
L_004ba480:
    # block 0x004ba480: entered by jmp at 0x004ba477, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004ba480
    pop ebp                                      # 004ba482
    ret 0x8                                      # 004ba483

