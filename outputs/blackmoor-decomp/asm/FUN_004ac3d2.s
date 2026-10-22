# FUN_004ac3d2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ac3d2
# extent:       0x004ac3d2-0x004ac488 (182 code bytes)
# span:         0x004ac3d2-0x004ac488 (code 182, tables 0, padding 0)
# sha256:       006c863d4972f70b565f2950d99139d55be95db8b95edc41fed99f211f43cfb0
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ac3d2_lifted
# naming:       native port src/original_methods_fl41.c:m4ac3d2_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 5 seeds; oracle: 53/53 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8, field_32, field_225; [ecx + n] field_c, field_32, field_34, field_221, field_225, field_229, field_22b, field_minus_2; [edx + n] field_4, field_32
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4ac3d2_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 53 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_2, 0x2  # offset -0x2
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_32, 0x32  # offset +0x32
.equ field_34, 0x34  # offset +0x34
.equ field_221, 0x221  # offset +0x221
.equ field_225, 0x225  # offset +0x225
.equ field_229, 0x229  # offset +0x229
.equ field_22b, 0x22b  # offset +0x22b

# --- external targets -----------------------------------------------

.org 0x004ac3d2 - 0x401000
.globl FUN_004ac3d2
FUN_004ac3d2:
    # block 0x004ac3d2: entry, 53 instruction(s), ends with ret 0x8
    push ebp                                     # 004ac3d2
    {load} mov ebp, esp                          # 004ac3d3
    push ecx                                     # 004ac3d5
    mov dword ptr [ebp - local_4], ecx           # 004ac3d6
    mov eax, dword ptr [ebp - local_4]           # 004ac3d9
    movsx ecx, word ptr [eax + field_32]         # 004ac3dc
    imul ecx, ecx, 0xc                           # 004ac3e0
    mov edx, dword ptr [ebp + arg_8]             # 004ac3e3
    mov eax, dword ptr [ebp + arg_c]             # 004ac3e6
    mov ecx, dword ptr [eax + ecx + field_225]   # 004ac3e9
    mov dword ptr [edx + field_4], ecx           # 004ac3f0
    mov edx, dword ptr [ebp - local_4]           # 004ac3f3
    movsx eax, word ptr [edx + field_32]         # 004ac3f6
    imul eax, eax, 0xc                           # 004ac3fa
    mov ecx, dword ptr [ebp - local_4]           # 004ac3fd
    movsx edx, word ptr [ecx + field_32]         # 004ac400
    imul edx, edx, 0xc                           # 004ac404
    mov ecx, dword ptr [ebp + arg_c]             # 004ac407
    movsx edx, word ptr [ecx + edx + field_22b]  # 004ac40a
    mov ecx, dword ptr [ebp + arg_c]             # 004ac412
    mov eax, dword ptr [ecx + eax + field_225]   # 004ac415
    {load} add eax, edx                          # 004ac41c
    mov ecx, dword ptr [ebp + arg_8]             # 004ac41e
    mov dword ptr [ecx + field_c], eax           # 004ac421
    mov edx, dword ptr [ebp - local_4]           # 004ac424
    movsx eax, word ptr [edx + field_32]         # 004ac427
    imul eax, eax, 0xc                           # 004ac42b
    mov ecx, dword ptr [ebp - local_4]           # 004ac42e
    movsx edx, word ptr [ecx + field_32]         # 004ac431
    imul edx, edx, 0xc                           # 004ac435
    mov ecx, dword ptr [ebp + arg_c]             # 004ac438
    movsx edx, word ptr [ecx + edx + field_229]  # 004ac43b
    mov ecx, dword ptr [ebp - local_4]           # 004ac443
    movsx ecx, word ptr [ecx + field_34]         # 004ac446
    imul edx, ecx                                # 004ac44a
    mov ecx, dword ptr [ebp + arg_c]             # 004ac44d
    mov eax, dword ptr [ecx + eax + field_221]   # 004ac450
    {load} add eax, edx                          # 004ac457
    mov ecx, dword ptr [ebp + arg_8]             # 004ac459
    mov dword ptr [ecx], eax                     # 004ac45c
    mov edx, dword ptr [ebp - local_4]           # 004ac45e
    movsx eax, word ptr [edx + field_32]         # 004ac461
    imul eax, eax, 0xc                           # 004ac465
    mov ecx, dword ptr [ebp + arg_c]             # 004ac468
    movsx edx, word ptr [ecx + eax + field_229]  # 004ac46b
    mov eax, dword ptr [ebp + arg_8]             # 004ac473
    mov ecx, dword ptr [eax]                     # 004ac476
    lea edx, [ecx + edx - field_minus_2]         # 004ac478
    mov eax, dword ptr [ebp + arg_8]             # 004ac47c
    mov dword ptr [eax + field_8], edx           # 004ac47f
    {load} mov esp, ebp                          # 004ac482
    pop ebp                                      # 004ac484
    ret 0x8                                      # 004ac485

