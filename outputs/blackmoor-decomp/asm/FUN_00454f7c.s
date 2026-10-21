# FUN_00454f7c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454f7c
# extent:       0x00454f7c-0x0045504b (207 code bytes)
# span:         0x00454f7c-0x0045504b (code 207, tables 0, padding 0)
# sha256:       6ec2f39747bf8e5517a939f565d51657ad1ec776a2f4718756995622debe4a2f
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m454f7c_clamp_to_bounds
# naming:       native port src/original_methods_fl38c.c:m454f7c_clamp_to_bounds (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Clamps self[0x4e,0x56] and self[0x4a,0x52] into global bounds [0x58319a,0x5831a2], [0x583196,0x58319e], extents int16 +0x16c, +0x16a. 63/63 instructions, 8/8 jump ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4a, field_4e, field_52, field_56; [ecx + n] field_16a, field_16c; [edx + n] field_4a, field_4e, field_52, field_56
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38c.c:m454f7c_clamp_to_bounds (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 63 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52
.equ field_56, 0x56  # offset +0x56
.equ field_16a, 0x16a  # offset +0x16a
.equ field_16c, 0x16c  # offset +0x16c

# --- external targets -----------------------------------------------

.org 0x00454f7c - 0x401000
.globl FUN_00454f7c
FUN_00454f7c:
    # block 0x00454f7c: entry, 8 instruction(s), ends with jge to 0x00454fb4 (forward)
    push ebp                                     # 00454f7c
    {load} mov ebp, esp                          # 00454f7d
    push ecx                                     # 00454f7f
    mov dword ptr [ebp - local_4], ecx           # 00454f80
    mov eax, dword ptr [ebp - local_4]           # 00454f83
    mov ecx, dword ptr [eax + field_4e]          # 00454f86
    cmp ecx, dword ptr [0x58319a]                # 00454f89
    jge.d8 L_00454fb4                            # 00454f8f
    # block 0x00454f91: entered by fall-through of jge at 0x00454f8f, 10 instruction(s), falls into the block at 0x00454fb4
    mov edx, dword ptr [ebp - local_4]           # 00454f91
    mov eax, dword ptr [0x58319a]                # 00454f94
    mov dword ptr [edx + field_4e], eax          # 00454f99
    mov ecx, dword ptr [ebp - local_4]           # 00454f9c
    movsx edx, word ptr [ecx + field_16c]        # 00454f9f
    mov eax, dword ptr [ebp - local_4]           # 00454fa6
    mov ecx, dword ptr [eax + field_4e]          # 00454fa9
    {load} add ecx, edx                          # 00454fac
    mov edx, dword ptr [ebp - local_4]           # 00454fae
    mov dword ptr [edx + field_56], ecx          # 00454fb1
L_00454fb4:
    # block 0x00454fb4: entered by jge at 0x00454f8f, 4 instruction(s), ends with jle to 0x00454fe5 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00454fb4
    mov ecx, dword ptr [eax + field_56]          # 00454fb7
    cmp ecx, dword ptr [0x5831a2]                # 00454fba
    jle.d8 L_00454fe5                            # 00454fc0
    # block 0x00454fc2: entered by fall-through of jle at 0x00454fc0, 10 instruction(s), falls into the block at 0x00454fe5
    mov edx, dword ptr [ebp - local_4]           # 00454fc2
    mov eax, dword ptr [0x5831a2]                # 00454fc5
    mov dword ptr [edx + field_56], eax          # 00454fca
    mov ecx, dword ptr [ebp - local_4]           # 00454fcd
    movsx edx, word ptr [ecx + field_16c]        # 00454fd0
    mov eax, dword ptr [ebp - local_4]           # 00454fd7
    mov ecx, dword ptr [eax + field_56]          # 00454fda
    {load} sub ecx, edx                          # 00454fdd
    mov edx, dword ptr [ebp - local_4]           # 00454fdf
    mov dword ptr [edx + field_4e], ecx          # 00454fe2
L_00454fe5:
    # block 0x00454fe5: entered by jle at 0x00454fc0, 4 instruction(s), ends with jge to 0x00455016 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00454fe5
    mov ecx, dword ptr [eax + field_4a]          # 00454fe8
    cmp ecx, dword ptr [0x583196]                # 00454feb
    jge.d8 L_00455016                            # 00454ff1
    # block 0x00454ff3: entered by fall-through of jge at 0x00454ff1, 10 instruction(s), falls into the block at 0x00455016
    mov edx, dword ptr [ebp - local_4]           # 00454ff3
    mov eax, dword ptr [0x583196]                # 00454ff6
    mov dword ptr [edx + field_4a], eax          # 00454ffb
    mov ecx, dword ptr [ebp - local_4]           # 00454ffe
    movsx edx, word ptr [ecx + field_16a]        # 00455001
    mov eax, dword ptr [ebp - local_4]           # 00455008
    mov ecx, dword ptr [eax + field_4a]          # 0045500b
    {load} add ecx, edx                          # 0045500e
    mov edx, dword ptr [ebp - local_4]           # 00455010
    mov dword ptr [edx + field_52], ecx          # 00455013
L_00455016:
    # block 0x00455016: entered by jge at 0x00454ff1, 4 instruction(s), ends with jle to 0x00455047 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00455016
    mov ecx, dword ptr [eax + field_52]          # 00455019
    cmp ecx, dword ptr [0x58319e]                # 0045501c
    jle.d8 L_00455047                            # 00455022
    # block 0x00455024: entered by fall-through of jle at 0x00455022, 10 instruction(s), falls into the block at 0x00455047
    mov edx, dword ptr [ebp - local_4]           # 00455024
    mov eax, dword ptr [0x58319e]                # 00455027
    mov dword ptr [edx + field_52], eax          # 0045502c
    mov ecx, dword ptr [ebp - local_4]           # 0045502f
    movsx edx, word ptr [ecx + field_16a]        # 00455032
    mov eax, dword ptr [ebp - local_4]           # 00455039
    mov ecx, dword ptr [eax + field_52]          # 0045503c
    {load} sub ecx, edx                          # 0045503f
    mov edx, dword ptr [ebp - local_4]           # 00455041
    mov dword ptr [edx + field_4a], ecx          # 00455044
L_00455047:
    # block 0x00455047: entered by jle at 0x00455022, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00455047
    pop ebp                                      # 00455049
    ret                                          # 0045504a

