# FUN_00475cc4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00475cc4
# extent:       0x00475cc4-0x00475da4 (224 code bytes)
# span:         0x00475cc4-0x00475da4 (code 224, tables 0, padding 0)
# sha256:       626cdaca82283bece4a7c96789939e7098f8e9fc466c58173d780eb02fd1d381
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         add_text
# naming:       native port src/action_family_e4_runtime.c:add_text (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    add_text matches: skip on empty string, x = (int16)(rect.left + view x), y = (int16)(rect.bottom + view y), font body+0x23a and parameter +0x23c;
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_22, field_23a; [ecx + n] field_c, field_23a, field_23c; [edx + n] field_23a
# callees:      calls FUN_004c924d, FUN_004d2c20
# track-n:      outputs/blackmoor-decomp/src/action_family_e4_runtime.c:add_text (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 64 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_22, 0x22  # offset +0x22
.equ field_23a, 0x23a  # offset +0x23a
.equ field_23c, 0x23c  # offset +0x23c

# --- external targets -----------------------------------------------
.set FUN_004c924d, .text + (0x004c924d - 0x401000)
.set FUN_004d2c20, .text + (0x004d2c20 - 0x401000)

.org 0x00475cc4 - 0x401000
.globl FUN_00475cc4
FUN_00475cc4:
    # block 0x00475cc4: entry, 20 instruction(s), ends with jle to 0x00475d9d (forward)
    push ebp                                     # 00475cc4
    {load} mov ebp, esp                          # 00475cc5
    sub esp, 0x14                                # 00475cc7
    push edi                                     # 00475cca
    mov dword ptr [ebp - local_14], ecx          # 00475ccb
    mov eax, dword ptr [ebp - local_14]          # 00475cce
    movsx ecx, word ptr [eax + field_22]         # 00475cd1
    imul ecx, ecx, 0x8d                          # 00475cd5
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00475cdb
    mov dword ptr [ebp - local_8], edx           # 00475ce1
    mov edi, dword ptr [ebp + arg_8]             # 00475ce4
    or ecx, -0x1                                 # 00475ce7
    {load} xor eax, eax                          # 00475cea
    repne scasb al, byte ptr es:[edi]            # 00475cec
    not ecx                                      # 00475cee
    add ecx, -0x1                                # 00475cf0
    mov word ptr [ebp - local_10], cx            # 00475cf3
    movsx eax, word ptr [ebp - local_10]         # 00475cf7
    test eax, eax                                # 00475cfb
    jle.d32 L_00475d9d                           # 00475cfd
    # block 0x00475d03: entered by fall-through of jle at 0x00475cfd, 40 instruction(s), calls FUN_004c924d, FUN_004d2c20, falls into the block at 0x00475d9d
    mov ecx, dword ptr [ebp + arg_c]             # 00475d03
    mov edx, dword ptr [ecx + field_c]           # 00475d06
    add edx, dword ptr [0x58318a]                # 00475d09
    mov word ptr [ebp - local_c], dx             # 00475d0f
    mov eax, dword ptr [ebp + arg_c]             # 00475d13
    mov ecx, dword ptr [eax]                     # 00475d16
    add ecx, dword ptr [0x583186]                # 00475d18
    mov word ptr [ebp - local_4], cx             # 00475d1e
    mov edx, dword ptr [ebp - local_8]           # 00475d22
    mov ax, word ptr [edx + field_23a]           # 00475d25
    push eax                                     # 00475d2c
    mov ecx, 0x5cf659                            # 00475d2d
    call FUN_004c924d                            # 00475d32
    mov ecx, dword ptr [ebp - local_8]           # 00475d37
    mov dx, word ptr [ecx + field_23c]           # 00475d3a
    push edx                                     # 00475d41
    mov eax, dword ptr [0x5cf665]                # 00475d42
    push eax                                     # 00475d47
    mov ecx, dword ptr [ebp - local_8]           # 00475d48
    movsx edx, word ptr [ecx + field_23a]        # 00475d4b
    mov eax, dword ptr [4*edx + 0x5d032f]        # 00475d52
    push eax                                     # 00475d59
    mov cx, word ptr [ebp - local_c]             # 00475d5a
    push ecx                                     # 00475d5e
    mov dx, word ptr [ebp - local_4]             # 00475d5f
    push edx                                     # 00475d63
    mov eax, dword ptr [ebp - local_8]           # 00475d64
    movsx ecx, word ptr [eax + field_23a]        # 00475d67
    imul ecx, ecx, 0x1d0                         # 00475d6e
    add ecx, 0x5adb3a                            # 00475d74
    push ecx                                     # 00475d7a
    mov edx, dword ptr [ebp - local_8]           # 00475d7b
    movsx eax, word ptr [edx + field_23a]        # 00475d7e
    imul eax, eax, 0x7f3                         # 00475d85
    add eax, 0x5a4c24                            # 00475d8b
    push eax                                     # 00475d90
    mov ecx, dword ptr [ebp + arg_8]             # 00475d91
    push ecx                                     # 00475d94
    call FUN_004d2c20                            # 00475d95
    add esp, 0x20                                # 00475d9a
L_00475d9d:
    # block 0x00475d9d: entered by jle at 0x00475cfd, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 00475d9d
    {load} mov esp, ebp                          # 00475d9e
    pop ebp                                      # 00475da0
    ret 0x8                                      # 00475da1

