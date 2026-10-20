# FUN_00447418
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447418
# extent:       0x00447418-0x004474cf (183 code bytes)
# span:         0x00447418-0x004474cf (code 183, tables 0, padding 0)
# sha256:       e7a350f210f976bdad8b9df085775c129f9e9babb380231422ee7a1c6a3422f4
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         controller_setup
# naming:       native port src/session_exit.c:controller_setup (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-15); the note is the acceptance note, a statement about the native port
# name-note:    Static controller_setup, parent granularity: 178-case RT-5 oracle compares the ordered boundary calls and stores. Callees 0x43a7ca (nested tick), 0x447ac7 (capture) and the buffer clear are host seams (RT-5 divergence).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_2d, field_31, field_49; [ecx + n] field_2d; [edx + n] field_35, field_39
# callees:      calls FUN_004d36ed, FUN_0043dbd5, FUN_0043a7ca, FUN_00447ac7
# track-n:      outputs/blackmoor-decomp/src/session_exit.c:controller_setup (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 52 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_2d, 0x2d  # offset +0x2d
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_49, 0x49  # offset +0x49

# --- external targets -----------------------------------------------
.set FUN_0043a7ca, .text + (0x0043a7ca - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_00447ac7, .text + (0x00447ac7 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)

.org 0x00447418 - 0x401000
.globl FUN_00447418
FUN_00447418:
    # block 0x00447418: entry, 23 instruction(s), calls FUN_004d36ed, FUN_0043dbd5, FUN_0043a7ca, FUN_00447ac7, ends with je to 0x00447482 (forward)
    push ebp                                     # 00447418
    {load} mov ebp, esp                          # 00447419
    sub esp, 0x8                                 # 0044741b
    push edi                                     # 0044741e
    mov dword ptr [ebp - local_4], ecx           # 0044741f
    mov dword ptr [0x5839a9], 0x1                # 00447422
    call FUN_004d36ed                            # 0044742c
    call FUN_0043dbd5                            # 00447431
    mov dword ptr [0x583999], 0x3                # 00447436
    call FUN_0043a7ca                            # 00447440
    mov dword ptr [0x583999], 0x4                # 00447445
    mov eax, dword ptr [ebp - local_4]           # 0044744f
    mov ecx, dword ptr [eax + field_31]          # 00447452
    push ecx                                     # 00447455
    mov edx, dword ptr [0x5cf665]                # 00447456
    push edx                                     # 0044745c
    mov ecx, dword ptr [ebp - local_4]           # 0044745d
    call FUN_00447ac7                            # 00447460
    mov eax, dword ptr [ebp - local_4]           # 00447465
    mov cl, byte ptr [eax + field_49]            # 00447468
    mov byte ptr [ebp - local_8], cl             # 0044746b
    cmp byte ptr [ebp - local_8], 0x1            # 0044746e
    je.d8 L_00447482                             # 00447472
    # block 0x00447474: entered by fall-through of je at 0x00447472, 2 instruction(s), ends with je to 0x004474ad (forward)
    cmp byte ptr [ebp - local_8], 0x2            # 00447474
    je.d8 L_004474ad                             # 00447478
    # block 0x0044747a: entered by fall-through of je at 0x00447478, 2 instruction(s), ends with je to 0x00447482 (forward)
    cmp byte ptr [ebp - local_8], 0x3            # 0044747a
    je.d8 L_00447482                             # 0044747e
    # block 0x00447480: entered by fall-through of je at 0x0044747e, 1 instruction(s), ends with forward jump to 0x004474ca
    jmp.d8 L_004474ca                            # 00447480
L_00447482:
    # block 0x00447482: entered by je at 0x00447472; je at 0x0044747e, 15 instruction(s), ends with forward jump to 0x004474ca
    mov edx, dword ptr [ebp - local_4]           # 00447482
    mov ecx, dword ptr [edx + field_39]          # 00447485
    imul ecx, ecx, 0xc                           # 00447488
    {load} xor eax, eax                          # 0044748b
    mov edx, dword ptr [ebp - local_4]           # 0044748d
    mov edi, dword ptr [edx + field_35]          # 00447490
    {load} mov edx, ecx                          # 00447493
    shr ecx, 0x2                                 # 00447495
    rep stosd dword ptr es:[edi], eax            # 00447498
    {load} mov ecx, edx                          # 0044749a
    and ecx, 0x3                                 # 0044749c
    rep stosb byte ptr es:[edi], al              # 0044749f
    mov eax, dword ptr [ebp - local_4]           # 004474a1
    mov dword ptr [eax + field_2d], 0x2          # 004474a4
    jmp.d8 L_004474ca                            # 004474ab
L_004474ad:
    # block 0x004474ad: entered by je at 0x00447478, 4 instruction(s), ends with jne to 0x004474ca (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004474ad
    mov dword ptr [ecx + field_2d], 0x1          # 004474b0
    cmp dword ptr [0x583999], 0x4                # 004474b7
    jne.d8 L_004474ca                            # 004474be
    # block 0x004474c0: entered by fall-through of jne at 0x004474be, 1 instruction(s), falls into the block at 0x004474ca
    mov dword ptr [0x583999], 0x1                # 004474c0
L_004474ca:
    # block 0x004474ca: entered by jmp at 0x00447480; jmp at 0x004474ab; jne at 0x004474be, 4 instruction(s), ends with ret
    pop edi                                      # 004474ca
    {load} mov esp, ebp                          # 004474cb
    pop ebp                                      # 004474cd
    ret                                          # 004474ce

