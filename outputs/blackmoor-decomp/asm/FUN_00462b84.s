# FUN_00462b84
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00462b84
# extent:       0x00462b84-0x00462c39 (181 code bytes)
# span:         0x00462b84-0x00462c39 (code 181, tables 0, padding 0)
# sha256:       91472233b4e954089125fb2d35671ae55ed9f876fdf3e19f81fa42ca0d776e21
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         cell_rect
# naming:       native port src/action_family_d3_runtime.c:cell_rect (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with cell_rect (cell base/rect from gap, origin, view). Native takes view_x/view_y as arguments; oracle compares the resulting grid cells.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e; [ecx + n] field_4, field_4f, field_53; [edx + n] field_4, field_8, field_c, field_240, field_244, field_248
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d3_runtime.c:cell_rect (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 54 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_14, 0x14  # offset +0x14
.equ field_1e, 0x1e  # offset +0x1e
.equ field_4f, 0x4f  # offset +0x4f
.equ field_53, 0x53  # offset +0x53
.equ field_240, 0x240  # offset +0x240
.equ field_244, 0x244  # offset +0x244
.equ field_248, 0x248  # offset +0x248

# --- external targets -----------------------------------------------

.org 0x00462b84 - 0x401000
.globl FUN_00462b84
FUN_00462b84:
    # block 0x00462b84: entry, 54 instruction(s), ends with ret 0x10
    push ebp                                     # 00462b84
    {load} mov ebp, esp                          # 00462b85
    sub esp, 0x8                                 # 00462b87
    mov dword ptr [ebp - local_8], ecx           # 00462b8a
    mov eax, dword ptr [ebp - local_8]           # 00462b8d
    movsx ecx, word ptr [eax + field_1e]         # 00462b90
    imul ecx, ecx, 0x8d                          # 00462b94
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00462b9a
    mov dword ptr [ebp - local_4], edx           # 00462ba0
    movsx eax, word ptr [ebp + arg_c]            # 00462ba3
    mov ecx, dword ptr [ebp - local_8]           # 00462ba7
    imul eax, dword ptr [ecx + field_4f]         # 00462baa
    mov edx, dword ptr [ebp - local_4]           # 00462bae
    mov ecx, dword ptr [edx + field_240]         # 00462bb1
    {load} add ecx, eax                          # 00462bb7
    mov edx, dword ptr [ebp - local_4]           # 00462bb9
    movsx eax, word ptr [edx + field_248]        # 00462bbc
    movsx edx, word ptr [ebp + arg_c]            # 00462bc3
    imul eax, edx                                # 00462bc7
    mov edx, dword ptr [0x583186]                # 00462bca
    {load} add edx, ecx                          # 00462bd0
    {load} add eax, edx                          # 00462bd2
    mov ecx, dword ptr [ebp + arg_14]            # 00462bd4
    mov dword ptr [ecx], eax                     # 00462bd7
    mov edx, dword ptr [ebp + arg_14]            # 00462bd9
    mov eax, dword ptr [edx]                     # 00462bdc
    mov ecx, dword ptr [ebp - local_8]           # 00462bde
    add eax, dword ptr [ecx + field_4f]          # 00462be1
    mov edx, dword ptr [ebp + arg_14]            # 00462be4
    mov dword ptr [edx + field_8], eax           # 00462be7
    movsx eax, word ptr [ebp + arg_8]            # 00462bea
    mov ecx, dword ptr [ebp - local_8]           # 00462bee
    imul eax, dword ptr [ecx + field_53]         # 00462bf1
    mov edx, dword ptr [ebp - local_4]           # 00462bf5
    mov ecx, dword ptr [edx + field_244]         # 00462bf8
    {load} add ecx, eax                          # 00462bfe
    mov edx, dword ptr [ebp - local_4]           # 00462c00
    movsx eax, word ptr [edx + field_248]        # 00462c03
    movsx edx, word ptr [ebp + arg_8]            # 00462c0a
    imul eax, edx                                # 00462c0e
    mov edx, dword ptr [0x58318a]                # 00462c11
    {load} add edx, ecx                          # 00462c17
    {load} add eax, edx                          # 00462c19
    mov ecx, dword ptr [ebp + arg_14]            # 00462c1b
    mov dword ptr [ecx + field_4], eax           # 00462c1e
    mov edx, dword ptr [ebp + arg_14]            # 00462c21
    mov eax, dword ptr [edx + field_4]           # 00462c24
    mov ecx, dword ptr [ebp - local_8]           # 00462c27
    add eax, dword ptr [ecx + field_53]          # 00462c2a
    mov edx, dword ptr [ebp + arg_14]            # 00462c2d
    mov dword ptr [edx + field_c], eax           # 00462c30
    {load} mov esp, ebp                          # 00462c33
    pop ebp                                      # 00462c35
    ret 0x10                                     # 00462c36

