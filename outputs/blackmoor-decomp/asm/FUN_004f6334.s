# FUN_004f6334
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f6334
# extent:       0x004f6334-0x004f646c (312 code bytes)
# span:         0x004f6334-0x004f646c (code 312, tables 0, padding 0)
# sha256:       48cdda17186b7ccc8d331394776ccdd0454d847fb5c751bc4f73cc1468916062
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         session_conditions_query_channel_record
# naming:       native port src/session_bindings_conditions.c:session_conditions_query_channel_record (port_acceptances, ledger class native_tests_only, reviewed 2026-10-15); the note is the acceptance note, a statement about the native port
# name-note:    Decision order, error words and status bit match the pseudocode; the DirectSound GetStatus call is a host value in the record. Test passed on macOS arm64, 2026-10-15.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_16e, field_28f, field_3be, field_3c2, field_3ca, field_3ce; [ecx + n] field_24, field_19e, field_28f, field_3be, field_3c2, field_3ca; [edx + n] field_162, field_172, field_28f, field_3be, field_3c2, field_3ca
# callees:      calls FUN_004f709c; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/session_bindings_conditions.c:session_conditions_query_channel_record (function ledger class native_tests_only; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 79 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_24, 0x24  # offset +0x24
.equ field_162, 0x162  # offset +0x162
.equ field_16e, 0x16e  # offset +0x16e
.equ field_172, 0x172  # offset +0x172
.equ field_19e, 0x19e  # offset +0x19e
.equ field_28f, 0x28f  # offset +0x28f
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_004f709c, .text + (0x004f709c - 0x401000)

.org 0x004f6334 - 0x401000
.globl FUN_004f6334
FUN_004f6334:
    # block 0x004f6334: entry, 18 instruction(s), calls FUN_004f709c, ends with jne to 0x004f63a2 (forward)
    push ebp                                     # 004f6334
    {load} mov ebp, esp                          # 004f6335
    sub esp, 0xc                                 # 004f6337
    mov dword ptr [ebp - local_c], ecx           # 004f633a
    mov eax, dword ptr [ebp - local_c]           # 004f633d
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f6340
    mov ecx, dword ptr [ebp - local_c]           # 004f634a
    mov dword ptr [ecx + field_3ca], 0x0         # 004f634d
    mov edx, dword ptr [ebp + arg_8]             # 004f6357
    imul edx, edx, 0x5bb                         # 004f635a
    mov eax, dword ptr [ebp - local_c]           # 004f6360
    mov ecx, dword ptr [eax + field_3ce]         # 004f6363
    {load} add ecx, edx                          # 004f6369
    mov dword ptr [ebp - local_8], ecx           # 004f636b
    mov ecx, dword ptr [ebp - local_c]           # 004f636e
    call FUN_004f709c                            # 004f6371
    test eax, eax                                # 004f6376
    jne.d8 L_004f63a2                            # 004f6378
    # block 0x004f637a: entered by fall-through of jne at 0x004f6378, 7 instruction(s), ends with forward jump to 0x004f6466
    mov edx, dword ptr [ebp - local_c]           # 004f637a
    mov dword ptr [edx + field_3c2], 0x3ea       # 004f637d
    mov eax, dword ptr [ebp - local_c]           # 004f6387
    mov dword ptr [eax + field_3be], 0x0         # 004f638a
    mov ecx, dword ptr [ebp - local_c]           # 004f6394
    mov eax, dword ptr [ecx + field_3be]         # 004f6397
    jmp.d32 L_004f6466                           # 004f639d
L_004f63a2:
    # block 0x004f63a2: entered by jne at 0x004f6378, 3 instruction(s), ends with je to 0x004f63ba (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f63a2
    cmp dword ptr [edx + field_162], 0x0         # 004f63a5
    je.d8 L_004f63ba                             # 004f63ac
    # block 0x004f63ae: entered by fall-through of je at 0x004f63ac, 3 instruction(s), ends with jne to 0x004f63e2 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f63ae
    cmp dword ptr [eax + field_28f], 0x0         # 004f63b1
    jne.d8 L_004f63e2                            # 004f63b8
L_004f63ba:
    # block 0x004f63ba: entered by je at 0x004f63ac; fall-through of jne at 0x004f63b8, 7 instruction(s), ends with forward jump to 0x004f6466
    mov ecx, dword ptr [ebp - local_c]           # 004f63ba
    mov dword ptr [ecx + field_3c2], 0x3ef       # 004f63bd
    mov edx, dword ptr [ebp - local_c]           # 004f63c7
    mov dword ptr [edx + field_3be], 0x0         # 004f63ca
    mov eax, dword ptr [ebp - local_c]           # 004f63d4
    mov eax, dword ptr [eax + field_3be]         # 004f63d7
    jmp.d32 L_004f6466                           # 004f63dd
L_004f63e2:
    # block 0x004f63e2: entered by jne at 0x004f63b8, 3 instruction(s), ends with je to 0x004f6411 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f63e2
    cmp dword ptr [ecx + field_19e], 0x0         # 004f63e5
    je.d8 L_004f6411                             # 004f63ec
    # block 0x004f63ee: entered by fall-through of je at 0x004f63ec, 3 instruction(s), ends with jne to 0x004f640d (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f63ee
    cmp dword ptr [edx + field_172], 0x0         # 004f63f1
    jne.d8 L_004f640d                            # 004f63f8
    # block 0x004f63fa: entered by fall-through of jne at 0x004f63f8, 3 instruction(s), ends with jne to 0x004f640d (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f63fa
    cmp dword ptr [eax + field_16e], 0x0         # 004f63fd
    jne.d8 L_004f640d                            # 004f6404
    # block 0x004f6406: entered by fall-through of jne at 0x004f6404, 2 instruction(s), ends with forward jump to 0x004f6466
    mov eax, 0x1                                 # 004f6406
    jmp.d8 L_004f6466                            # 004f640b
L_004f640d:
    # block 0x004f640d: entered by jne at 0x004f63f8; jne at 0x004f6404, 2 instruction(s), ends with forward jump to 0x004f6466
    {load} xor eax, eax                          # 004f640d
    jmp.d8 L_004f6466                            # 004f640f
L_004f6411:
    # block 0x004f6411: entered by je at 0x004f63ec, 14 instruction(s), calls indirect dword ptr [ecx + 0x24], ends with jne to 0x004f6457 (forward)
    lea ecx, [ebp - local_4]                     # 004f6411
    push ecx                                     # 004f6414
    mov edx, dword ptr [ebp - local_8]           # 004f6415
    mov eax, dword ptr [edx + field_28f]         # 004f6418
    mov ecx, dword ptr [ebp - local_8]           # 004f641e
    mov edx, dword ptr [ecx + field_28f]         # 004f6421
    mov ecx, dword ptr [edx]                     # 004f6427
    push eax                                     # 004f6429
    call dword ptr [ecx + field_24]              # 004f642a
    mov edx, dword ptr [ebp - local_c]           # 004f642d
    mov dword ptr [edx + field_3ca], eax         # 004f6430
    mov eax, dword ptr [ebp - local_c]           # 004f6436
    cmp dword ptr [eax + field_3ca], 0x0         # 004f6439
    jne.d8 L_004f6457                            # 004f6440
    # block 0x004f6442: entered by fall-through of jne at 0x004f6440, 4 instruction(s), ends with je to 0x004f6453 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f6442
    and ecx, 0x1                                 # 004f6445
    test ecx, ecx                                # 004f6448
    je.d8 L_004f6453                             # 004f644a
    # block 0x004f644c: entered by fall-through of je at 0x004f644a, 2 instruction(s), ends with forward jump to 0x004f6466
    mov eax, 0x1                                 # 004f644c
    jmp.d8 L_004f6466                            # 004f6451
L_004f6453:
    # block 0x004f6453: entered by je at 0x004f644a, 2 instruction(s), ends with forward jump to 0x004f6466
    {load} xor eax, eax                          # 004f6453
    jmp.d8 L_004f6466                            # 004f6455
L_004f6457:
    # block 0x004f6457: entered by jne at 0x004f6440, 3 instruction(s), falls into the block at 0x004f6466
    mov edx, dword ptr [ebp - local_c]           # 004f6457
    mov dword ptr [edx + field_3c2], 0x40a       # 004f645a
    {load} xor eax, eax                          # 004f6464
L_004f6466:
    # block 0x004f6466: entered by jmp at 0x004f639d; jmp at 0x004f63dd; jmp at 0x004f640b; jmp at 0x004f640f; more, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f6466
    pop ebp                                      # 004f6468
    ret 0x4                                      # 004f6469

