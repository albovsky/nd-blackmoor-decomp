# FUN_00488e9c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00488e9c
# extent:       0x00488e9c-0x0048905b (447 code bytes)
# span:         0x00488e9c-0x0048905b (code 447, tables 0, padding 0)
# sha256:       f2ca65102b72b407f020982400f4a39a1b891ad199d0947ec840b7ce76dbc0e1
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m488e9c_init_record
# naming:       native port src/original_methods_fl30b.c:m488e9c_init_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Allocates 0xaba bytes and fills them by three copies; all instructions run; allocation failure and negative or overrunning counts are native rejections, not original behaviour. See fl30b-handoff.md.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1c, field_20, field_aa; [ecx + n] field_1c, field_20, field_29, field_33, field_35, field_aa; [edx + n] field_1c, field_20, field_2b
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30b.c:m488e9c_init_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 143 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_33, 0x33  # offset +0x33
.equ field_35, 0x35  # offset +0x35
.equ field_aa, 0xaa  # offset +0xaa

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00488e9c - 0x401000
.globl FUN_00488e9c
FUN_00488e9c:
    # block 0x00488e9c: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00488f03 (forward)
    push ebp                                     # 00488e9c
    {load} mov ebp, esp                          # 00488e9d
    sub esp, 0xc                                 # 00488e9f
    push esi                                     # 00488ea2
    push edi                                     # 00488ea3
    mov dword ptr [ebp - local_c], ecx           # 00488ea4
    push 0xaba                                   # 00488ea7
    call FUN_0051dc43                            # 00488eac
    add esp, 0x4                                 # 00488eb1
    mov dword ptr [ebp - local_8], eax           # 00488eb4
    mov eax, dword ptr [ebp + arg_8]             # 00488eb7
    mov ecx, dword ptr [ebp - local_8]           # 00488eba
    mov dword ptr [eax], ecx                     # 00488ebd
    cmp dword ptr [ebp - local_8], 0x0           # 00488ebf
    jne.d8 L_00488f03                            # 00488ec3
    # block 0x00488ec5: entered by fall-through of jne at 0x00488ec3, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00488f03
    movsx edx, word ptr [0x5c39e3]               # 00488ec5
    push edx                                     # 00488ecc
    mov eax, dword ptr [0x5bb57b]                # 00488ecd
    push eax                                     # 00488ed2
    push 0x54df58                                # 00488ed3
    push 0x63888b                                # 00488ed8
    call FUN_0050ca3e                            # 00488edd
    add esp, 0x10                                # 00488ee2
    push 0x63888b                                # 00488ee5
    push 0x54df84                                # 00488eea
    mov ecx, 0x583979                            # 00488eef
    call FUN_0042639d                            # 00488ef4
    mov ecx, 0x5cf659                            # 00488ef9
    call FUN_004c97b4                            # 00488efe
L_00488f03:
    # block 0x00488f03: entered by jne at 0x00488ec3, 29 instruction(s), ends with jne to 0x00488f7a (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00488f03
    mov edx, dword ptr [ebp + arg_8]             # 00488f06
    mov eax, dword ptr [edx]                     # 00488f09
    mov dword ptr [ecx + field_1c], eax          # 00488f0b
    mov ecx, dword ptr [ebp - local_c]           # 00488f0e
    mov edx, dword ptr [ebp - local_c]           # 00488f11
    mov eax, dword ptr [edx + field_1c]          # 00488f14
    mov dword ptr [ecx + field_20], eax          # 00488f17
    mov ecx, dword ptr [ebp + arg_c]             # 00488f1a
    mov esi, dword ptr [ecx]                     # 00488f1d
    mov edx, dword ptr [ebp - local_c]           # 00488f1f
    mov edi, dword ptr [edx + field_20]          # 00488f22
    mov ecx, 0x2b                                # 00488f25
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00488f2a
    mov eax, dword ptr [ebp + arg_c]             # 00488f2c
    mov ecx, dword ptr [eax]                     # 00488f2f
    add ecx, 0xac                                # 00488f31
    mov edx, dword ptr [ebp + arg_c]             # 00488f37
    mov dword ptr [edx], ecx                     # 00488f3a
    mov eax, dword ptr [ebp + arg_10]            # 00488f3c
    mov ecx, dword ptr [eax]                     # 00488f3f
    add ecx, 0xac                                # 00488f41
    mov edx, dword ptr [ebp + arg_10]            # 00488f47
    mov dword ptr [edx], ecx                     # 00488f4a
    mov eax, dword ptr [ebp - local_c]           # 00488f4c
    mov ecx, dword ptr [eax + field_20]          # 00488f4f
    movsx edx, word ptr [ecx + field_29]         # 00488f52
    cmp edx, 0x2                                 # 00488f56
    jne.d8 L_00488f7a                            # 00488f59
    # block 0x00488f5b: entered by fall-through of jne at 0x00488f59, 10 instruction(s), ends with forward jump to 0x00488f88
    mov eax, dword ptr [ebp - local_c]           # 00488f5b
    mov ecx, dword ptr [eax + field_20]          # 00488f5e
    movsx edx, word ptr [ecx + field_35]         # 00488f61
    mov eax, dword ptr [ebp - local_c]           # 00488f65
    mov ecx, dword ptr [eax + field_20]          # 00488f68
    movsx eax, word ptr [ecx + field_33]         # 00488f6b
    {load} sub edx, eax                          # 00488f6f
    add edx, 0x1                                 # 00488f71
    mov word ptr [ebp - local_4], dx             # 00488f74
    jmp.d8 L_00488f88                            # 00488f78
L_00488f7a:
    # block 0x00488f7a: entered by jne at 0x00488f59, 4 instruction(s), falls into the block at 0x00488f88
    mov ecx, dword ptr [ebp - local_c]           # 00488f7a
    mov edx, dword ptr [ecx + field_20]          # 00488f7d
    mov ax, word ptr [edx + field_2b]            # 00488f80
    mov word ptr [ebp - local_4], ax             # 00488f84
L_00488f88:
    # block 0x00488f88: entered by jmp at 0x00488f78, 63 instruction(s), ends with je to 0x00489053 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00488f88
    shl ecx, 0x4                                 # 00488f8c
    mov edx, dword ptr [ebp + arg_c]             # 00488f8f
    mov esi, dword ptr [edx]                     # 00488f92
    mov eax, dword ptr [ebp - local_c]           # 00488f94
    mov edi, dword ptr [eax + field_1c]          # 00488f97
    add edi, 0xac                                # 00488f9a
    {load} mov edx, ecx                          # 00488fa0
    shr ecx, 0x2                                 # 00488fa2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00488fa5
    {load} mov ecx, edx                          # 00488fa7
    and ecx, 0x3                                 # 00488fa9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00488fac
    movsx eax, word ptr [ebp - local_4]          # 00488fae
    shl eax, 0x4                                 # 00488fb2
    mov ecx, dword ptr [ebp + arg_c]             # 00488fb5
    mov edx, dword ptr [ecx]                     # 00488fb8
    {load} add edx, eax                          # 00488fba
    mov eax, dword ptr [ebp + arg_c]             # 00488fbc
    mov dword ptr [eax], edx                     # 00488fbf
    movsx ecx, word ptr [ebp - local_4]          # 00488fc1
    shl ecx, 0x4                                 # 00488fc5
    mov edx, dword ptr [ebp + arg_10]            # 00488fc8
    mov eax, dword ptr [edx]                     # 00488fcb
    {load} add eax, ecx                          # 00488fcd
    mov ecx, dword ptr [ebp + arg_10]            # 00488fcf
    mov dword ptr [ecx], eax                     # 00488fd2
    mov edx, dword ptr [ebp - local_c]           # 00488fd4
    mov eax, dword ptr [edx + field_20]          # 00488fd7
    movsx ecx, word ptr [eax + field_aa]         # 00488fda
    imul ecx, ecx, 0x26                          # 00488fe1
    mov edx, dword ptr [ebp + arg_c]             # 00488fe4
    mov esi, dword ptr [edx]                     # 00488fe7
    mov eax, dword ptr [ebp - local_c]           # 00488fe9
    mov edi, dword ptr [eax + field_1c]          # 00488fec
    add edi, 0x6ec                               # 00488fef
    {load} mov edx, ecx                          # 00488ff5
    shr ecx, 0x2                                 # 00488ff7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00488ffa
    {load} mov ecx, edx                          # 00488ffc
    and ecx, 0x3                                 # 00488ffe
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00489001
    mov eax, dword ptr [ebp - local_c]           # 00489003
    mov ecx, dword ptr [eax + field_20]          # 00489006
    movsx edx, word ptr [ecx + field_aa]         # 00489009
    imul edx, edx, 0x26                          # 00489010
    mov eax, dword ptr [ebp + arg_c]             # 00489013
    mov ecx, dword ptr [eax]                     # 00489016
    {load} add ecx, edx                          # 00489018
    mov edx, dword ptr [ebp + arg_c]             # 0048901a
    mov dword ptr [edx], ecx                     # 0048901d
    mov eax, dword ptr [ebp - local_c]           # 0048901f
    mov ecx, dword ptr [eax + field_20]          # 00489022
    movsx edx, word ptr [ecx + field_aa]         # 00489025
    imul edx, edx, 0x26                          # 0048902c
    mov eax, dword ptr [ebp + arg_10]            # 0048902f
    mov ecx, dword ptr [eax]                     # 00489032
    {load} add ecx, edx                          # 00489034
    mov edx, dword ptr [ebp + arg_10]            # 00489036
    mov dword ptr [edx], ecx                     # 00489039
    movsx eax, word ptr [0x63a4cd]               # 0048903b
    test eax, eax                                # 00489042
    je.d8 L_00489053                             # 00489044
    # block 0x00489046: entered by fall-through of je at 0x00489044, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00489053
    push 0x54dfa0                                # 00489046
    call FUN_0044a2b7                            # 0048904b
    add esp, 0x4                                 # 00489050
L_00489053:
    # block 0x00489053: entered by je at 0x00489044, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00489053
    pop esi                                      # 00489054
    {load} mov esp, ebp                          # 00489055
    pop ebp                                      # 00489057
    ret 0xc                                      # 00489058

