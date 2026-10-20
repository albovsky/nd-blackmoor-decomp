# FUN_00410f99
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00410f99
# extent:       0x00410f99-0x0041107f (230 code bytes)
# span:         0x00410f99-0x00411080 (code 230, tables 0, padding 1)
# sha256:       66213ccc0b5222fd241ed267229688698a430b4ba06d799544623c6f4ec73aa1
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m410f99_init_entry
# naming:       native port src/original_methods_fl18.c:m410f99_init_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m410f99_init_entry. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 230 bytes.
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_33, field_87, field_a7; [ecx + n] field_21, field_27, field_2b, field_2d, field_5b, field_90, field_91, field_97, field_a5; [edx + n] field_21, field_23, field_27, field_29, field_2b, field_2c, field_2f, field_5f, field_a8
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_97.c:defaults (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 67 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_33, 0x33  # offset +0x33
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5f, 0x5f  # offset +0x5f
.equ field_87, 0x87  # offset +0x87
.equ field_90, 0x90  # offset +0x90
.equ field_91, 0x91  # offset +0x91
.equ field_97, 0x97  # offset +0x97
.equ field_a5, 0xa5  # offset +0xa5
.equ field_a7, 0xa7  # offset +0xa7
.equ field_a8, 0xa8  # offset +0xa8

# --- external targets -----------------------------------------------

.org 0x00410f99 - 0x401000
.globl FUN_00410f99
FUN_00410f99:
    # block 0x00410f99: entry, 67 instruction(s), ends with ret
    push ebp                                     # 00410f99
    {load} mov ebp, esp                          # 00410f9a
    push esi                                     # 00410f9c
    push edi                                     # 00410f9d
    mov edi, dword ptr [ebp + arg_c]             # 00410f9e
    mov edx, dword ptr [ebp + arg_8]             # 00410fa1
    or ecx, -0x1                                 # 00410fa4
    {load} xor eax, eax                          # 00410fa7
    repne scasb al, byte ptr es:[edi]            # 00410fa9
    not ecx                                      # 00410fab
    {load} sub edi, ecx                          # 00410fad
    {load} mov esi, edi                          # 00410faf
    {load} mov eax, ecx                          # 00410fb1
    {load} mov edi, edx                          # 00410fb3
    shr ecx, 0x2                                 # 00410fb5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00410fb8
    {load} mov ecx, eax                          # 00410fba
    and ecx, 0x3                                 # 00410fbc
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00410fbf
    mov ecx, dword ptr [ebp + arg_8]             # 00410fc1
    mov edx, dword ptr [ebp + arg_c]             # 00410fc4
    mov ax, word ptr [edx + field_21]            # 00410fc7
    mov word ptr [ecx + field_21], ax            # 00410fcb
    mov ecx, dword ptr [ebp + arg_8]             # 00410fcf
    mov edx, dword ptr [ebp + arg_c]             # 00410fd2
    mov eax, dword ptr [edx + field_23]          # 00410fd5
    mov dword ptr [ecx + field_27], eax          # 00410fd8
    mov ecx, dword ptr [ebp + arg_8]             # 00410fdb
    mov edx, dword ptr [ebp + arg_c]             # 00410fde
    mov ax, word ptr [edx + field_27]            # 00410fe1
    mov word ptr [ecx + field_2b], ax            # 00410fe5
    mov ecx, dword ptr [ebp + arg_8]             # 00410fe9
    mov edx, dword ptr [ebp + arg_c]             # 00410fec
    mov ax, word ptr [edx + field_29]            # 00410fef
    mov word ptr [ecx + field_2d], ax            # 00410ff3
    mov ecx, dword ptr [ebp + arg_8]             # 00410ff7
    mov edx, dword ptr [ebp + arg_c]             # 00410ffa
    mov al, byte ptr [edx + field_2b]            # 00410ffd
    mov byte ptr [ecx + field_90], al            # 00411000
    mov ecx, dword ptr [ebp + arg_8]             # 00411006
    mov edx, dword ptr [ebp + arg_c]             # 00411009
    mov ax, word ptr [edx + field_2c]            # 0041100c
    mov word ptr [ecx + field_91], ax            # 00411010
    mov ecx, dword ptr [ebp + arg_8]             # 00411017
    mov dx, word ptr [ebp + arg_10]              # 0041101a
    mov word ptr [ecx + field_a5], dx            # 0041101e
    mov eax, dword ptr [ebp + arg_8]             # 00411025
    mov cl, byte ptr [ebp + arg_14]              # 00411028
    mov byte ptr [eax + field_a7], cl            # 0041102b
    mov edx, dword ptr [ebp + arg_8]             # 00411031
    mov dword ptr [edx + field_2f], 0x1f4        # 00411034
    mov eax, dword ptr [ebp + arg_8]             # 0041103b
    mov dword ptr [eax + field_33], 0x7d0        # 0041103e
    mov ecx, dword ptr [ebp + arg_8]             # 00411045
    mov dword ptr [ecx + field_5b], 0x3e8        # 00411048
    mov edx, dword ptr [ebp + arg_8]             # 0041104f
    mov dword ptr [edx + field_5f], 0xa          # 00411052
    mov eax, dword ptr [ebp + arg_8]             # 00411059
    mov byte ptr [eax + field_87], 0x1           # 0041105c
    mov ecx, dword ptr [ebp + arg_8]             # 00411063
    mov word ptr [ecx + field_97], 0x1           # 00411066
    mov edx, dword ptr [ebp + arg_8]             # 0041106f
    mov word ptr [edx + field_a8], 0x2           # 00411072
    pop edi                                      # 0041107b
    pop esi                                      # 0041107c
    pop ebp                                      # 0041107d
    ret                                          # 0041107e

# --- data items (not part of the function) -------------------------
.org 0x0041107f - 0x401000
PAD_0041107f:  # 1 byte(s) of int3 padding
    .fill 1, 1, 0xcc

