# FUN_0044da08
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044da08
# extent:       0x0044da08-0x0044e001 (1529 code bytes)
# span:         0x0044da08-0x0044e025 (code 1529, tables 36, padding 0)
# sha256:       c7193f5afc518f9c5f7bdfa645928539f8f6469e26428ca14dbcaa696af49de8
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44da08_run_state
# naming:       native port src/original_methods_fl21b.c:m44da08_run_state (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m44da08_run_state. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 1565 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1c, field_24, field_25, field_2d, field_31, field_49, field_4a, field_298, field_29e, field_2aa, field_2ac, field_2e2 and 3 more; [ecx + n] field_1c, field_1e, field_20, field_24, field_29, field_2d, field_49, field_4b, field_296, field_29c, field_2a6, field_2ae and 5 more; [edx + n] field_1c, field_1e, field_2d, field_45, field_4a, field_4f, field_296, field_29a, field_2a2, field_2ac, field_2af, field_2d2 and 4 more
# callees:      calls FUN_0044d711, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_0044d8ad, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0044d946, FUN_0042ba3a, FUN_0044d154
# track-n:      outputs/blackmoor-decomp/src/action_family_aa_runtime.h:alc_step (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 357 instruction(s), 19 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
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
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_31, 0x31  # offset +0x31
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4b, 0x4b  # offset +0x4b
.equ field_4f, 0x4f  # offset +0x4f
.equ field_296, 0x296  # offset +0x296
.equ field_298, 0x298  # offset +0x298
.equ field_29a, 0x29a  # offset +0x29a
.equ field_29c, 0x29c  # offset +0x29c
.equ field_29e, 0x29e  # offset +0x29e
.equ field_2a2, 0x2a2  # offset +0x2a2
.equ field_2a6, 0x2a6  # offset +0x2a6
.equ field_2aa, 0x2aa  # offset +0x2aa
.equ field_2ac, 0x2ac  # offset +0x2ac
.equ field_2ae, 0x2ae  # offset +0x2ae
.equ field_2af, 0x2af  # offset +0x2af
.equ field_2d2, 0x2d2  # offset +0x2d2
.equ field_2e2, 0x2e2  # offset +0x2e2
.equ field_2e4, 0x2e4  # offset +0x2e4
.equ field_2e6, 0x2e6  # offset +0x2e6
.equ field_2e8, 0x2e8  # offset +0x2e8
.equ field_2ea, 0x2ea  # offset +0x2ea
.equ field_2ee, 0x2ee  # offset +0x2ee
.equ field_2f2, 0x2f2  # offset +0x2f2
.equ field_2f6, 0x2f6  # offset +0x2f6
.equ field_2f8, 0x2f8  # offset +0x2f8
.equ field_2fa, 0x2fa  # offset +0x2fa

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0044d154, .text + (0x0044d154 - 0x401000)
.set FUN_0044d711, .text + (0x0044d711 - 0x401000)
.set FUN_0044d8ad, .text + (0x0044d8ad - 0x401000)
.set FUN_0044d946, .text + (0x0044d946 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x0044da08 - 0x401000
.globl FUN_0044da08
FUN_0044da08:
    # block 0x0044da08: entry, 16 instruction(s), ends with je to 0x0044da58 (forward)
    push ebp                                     # 0044da08
    {load} mov ebp, esp                          # 0044da09
    sub esp, 0x14                                # 0044da0b
    push esi                                     # 0044da0e
    push edi                                     # 0044da0f
    mov dword ptr [ebp - local_c], ecx           # 0044da10
    movsx eax, word ptr [ebp + arg_8]            # 0044da13
    imul eax, eax, 0x8d                          # 0044da17
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0044da1d
    mov dword ptr [ebp - local_4], ecx           # 0044da23
    movsx edx, word ptr [ebp + arg_8]            # 0044da26
    imul edx, edx, 0x8d                          # 0044da2a
    mov eax, dword ptr [edx + 0x5bb632]          # 0044da30
    mov dword ptr [ebp - local_10], eax          # 0044da36
    cmp dword ptr [ebp - local_10], 0x0          # 0044da39
    je.d8 L_0044da58                             # 0044da3d
    # block 0x0044da3f: entered by fall-through of je at 0x0044da3d, 2 instruction(s), ends with je to 0x0044dc17 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 0044da3f
    je.d32 L_0044dc17                            # 0044da43
    # block 0x0044da49: entered by fall-through of je at 0x0044da43, 2 instruction(s), ends with je to 0x0044ddc4 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 0044da49
    je.d32 L_0044ddc4                            # 0044da4d
    # block 0x0044da53: entered by fall-through of je at 0x0044da4d, 1 instruction(s), ends with forward jump to 0x0044dff9
    jmp.d32 L_0044dff9                           # 0044da53
L_0044da58:
    # block 0x0044da58: entered by je at 0x0044da3d, 72 instruction(s), calls FUN_0044d711, FUN_004d39f9, ends with jne to 0x0044dbaa (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044da58
    mov dx, word ptr [ebp + arg_8]               # 0044da5b
    mov word ptr [ecx + field_1e], dx            # 0044da5f
    mov eax, dword ptr [ebp - local_c]           # 0044da63
    mov dword ptr [eax + field_25], 0x1          # 0044da66
    mov ecx, dword ptr [ebp - local_c]           # 0044da6d
    call FUN_0044d711                            # 0044da70
    mov ecx, dword ptr [ebp - local_c]           # 0044da75
    mov byte ptr [ecx + field_24], 0x1           # 0044da78
    mov dword ptr [0x5bb1ca], 0x1                # 0044da7c
    mov edx, dword ptr [ebp - local_c]           # 0044da86
    mov dword ptr [edx + field_45], 0x0          # 0044da89
    mov eax, dword ptr [ebp - local_c]           # 0044da90
    mov dword ptr [eax + field_2d], 0x0          # 0044da93
    mov ecx, dword ptr [ebp - local_c]           # 0044da9a
    mov dword ptr [ecx + field_29], 0x0          # 0044da9d
    call FUN_004d39f9                            # 0044daa4
    mov edx, dword ptr [ebp - local_c]           # 0044daa9
    mov word ptr [edx + field_1c], ax            # 0044daac
    mov eax, dword ptr [ebp - local_c]           # 0044dab0
    movsx ecx, word ptr [eax + field_1c]         # 0044dab3
    imul ecx, ecx, 0x4a                          # 0044dab7
    mov dword ptr [ecx + 0x5d1591], 0xa          # 0044daba
    mov edx, dword ptr [ebp - local_c]           # 0044dac4
    movsx eax, word ptr [edx + field_1c]         # 0044dac7
    imul eax, eax, 0x4a                          # 0044dacb
    mov dword ptr [eax + 0x5d1595], 0x44e035     # 0044dace
    mov ecx, dword ptr [ebp - local_c]           # 0044dad8
    movsx edx, word ptr [ecx + field_1c]         # 0044dadb
    imul edx, edx, 0x4a                          # 0044dadf
    mov dword ptr [edx + 0x5d1599], 0x0          # 0044dae2
    mov eax, dword ptr [ebp - local_c]           # 0044daec
    movsx ecx, word ptr [eax + field_1c]         # 0044daef
    imul ecx, ecx, 0x4a                          # 0044daf3
    mov dword ptr [ecx + 0x5d159d], 0x0          # 0044daf6
    mov edx, dword ptr [ebp - local_c]           # 0044db00
    movsx eax, word ptr [edx + field_1c]         # 0044db03
    imul eax, eax, 0x4a                          # 0044db07
    mov dword ptr [eax + 0x5d15a1], 0x0          # 0044db0a
    mov ecx, dword ptr [ebp - local_c]           # 0044db14
    movsx edx, word ptr [ecx + field_1c]         # 0044db17
    imul edx, edx, 0x4a                          # 0044db1b
    mov dword ptr [edx + 0x5d15a5], 0x1          # 0044db1e
    mov eax, dword ptr [ebp - local_c]           # 0044db28
    movsx ecx, word ptr [eax + field_1c]         # 0044db2b
    imul ecx, ecx, 0x4a                          # 0044db2f
    mov dword ptr [ecx + 0x5d15a9], 0x1          # 0044db32
    mov edx, dword ptr [ebp - local_c]           # 0044db3c
    movsx eax, word ptr [edx + field_1c]         # 0044db3f
    imul eax, eax, 0x4a                          # 0044db43
    mov word ptr [eax + 0x5d15ad], 0x0           # 0044db46
    mov edi, 0x5495bc                            # 0044db4f
    mov ecx, dword ptr [ebp - local_c]           # 0044db54
    movsx edx, word ptr [ecx + field_1c]         # 0044db57
    imul edx, edx, 0x4a                          # 0044db5b
    add edx, 0x5d15b3                            # 0044db5e
    or ecx, -0x1                                 # 0044db64
    {load} xor eax, eax                          # 0044db67
    repne scasb al, byte ptr es:[edi]            # 0044db69
    not ecx                                      # 0044db6b
    {load} sub edi, ecx                          # 0044db6d
    {load} mov esi, edi                          # 0044db6f
    {load} mov eax, ecx                          # 0044db71
    {load} mov edi, edx                          # 0044db73
    shr ecx, 0x2                                 # 0044db75
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044db78
    {load} mov ecx, eax                          # 0044db7a
    and ecx, 0x3                                 # 0044db7c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044db7f
    mov ecx, dword ptr [ebp - local_c]           # 0044db81
    cmp dword ptr [ecx + field_20], 0x0          # 0044db84
    jne.d8 L_0044dbaa                            # 0044db88
    # block 0x0044db8a: entered by fall-through of jne at 0x0044db88, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x0044dbaa
    push 0x5495d4                                # 0044db8a
    push 0x6                                     # 0044db8f
    mov edx, dword ptr [ebp - local_4]           # 0044db91
    push edx                                     # 0044db94
    push 0x5495e8                                # 0044db95
    mov ecx, 0x5cf659                            # 0044db9a
    call FUN_004c2790                            # 0044db9f
    mov ecx, dword ptr [ebp - local_c]           # 0044dba4
    mov dword ptr [ecx + field_20], eax          # 0044dba7
L_0044dbaa:
    # block 0x0044dbaa: entered by jne at 0x0044db88, 13 instruction(s), ends with je to 0x0044dbed (forward)
    mov edx, dword ptr [ebp - local_c]           # 0044dbaa
    movsx eax, word ptr [edx + field_1c]         # 0044dbad
    imul eax, eax, 0x4a                          # 0044dbb1
    mov ecx, dword ptr [ebp - local_c]           # 0044dbb4
    mov edx, dword ptr [ecx + field_20]          # 0044dbb7
    mov dword ptr [eax + 0x5d1599], edx          # 0044dbba
    mov edi, 0x5495f0                            # 0044dbc0
    mov esi, dword ptr [ebp - local_4]           # 0044dbc5
    add esi, 0x265                               # 0044dbc8
    mov ecx, 0x9                                 # 0044dbce
    {load} xor eax, eax                          # 0044dbd3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0044dbd5
    je.d8 L_0044dbed                             # 0044dbd7
    # block 0x0044dbd9: entered by fall-through of je at 0x0044dbd7, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0044dbed
    mov ecx, dword ptr [ebp - local_4]           # 0044dbd9
    add ecx, 0x265                               # 0044dbdc
    push ecx                                     # 0044dbe2
    mov ecx, 0x5c3a67                            # 0044dbe3
    call FUN_004fb77a                            # 0044dbe8
L_0044dbed:
    # block 0x0044dbed: entered by je at 0x0044dbd7, 9 instruction(s), ends with forward jump to 0x0044dff9
    mov edx, dword ptr [ebp - local_c]           # 0044dbed
    mov byte ptr [edx + field_4a], 0x0           # 0044dbf0
    mov eax, dword ptr [ebp - local_c]           # 0044dbf4
    mov byte ptr [eax + field_49], 0x0           # 0044dbf7
    mov ecx, dword ptr [ebp - local_c]           # 0044dbfb
    movsx edx, word ptr [ecx + field_1e]         # 0044dbfe
    imul edx, edx, 0x8d                          # 0044dc02
    mov dword ptr [edx + 0x5bb632], 0x1          # 0044dc08
    jmp.d32 L_0044dff9                           # 0044dc12
L_0044dc17:
    # block 0x0044dc17: entered by je at 0x0044da43, 5 instruction(s), ends with ja to 0x0044ddbf (forward)
    mov eax, dword ptr [ebp - local_c]           # 0044dc17
    mov ecx, dword ptr [eax + field_2d]          # 0044dc1a
    mov dword ptr [ebp - local_14], ecx          # 0044dc1d
    cmp dword ptr [ebp - local_14], 0x8          # 0044dc20
    ja.d32 L_0044ddbf                            # 0044dc24
    # block 0x0044dc2a: entered by fall-through of ja at 0x0044dc24, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x44e001]
    mov edx, dword ptr [ebp - local_14]          # 0044dc2a
    jmp dword ptr [4*edx + SWTAB_0044e001_VA]    # 0044dc2d
L_0044dc34:
    # block 0x0044dc34: entered by switch case, 7 instruction(s), ends with forward jump to 0x0044ddbf
    mov eax, dword ptr [ebp - local_c]           # 0044dc34
    mov byte ptr [eax + field_49], 0x1           # 0044dc37
    mov ecx, dword ptr [ebp - local_c]           # 0044dc3b
    movsx edx, word ptr [ecx + field_1e]         # 0044dc3e
    imul edx, edx, 0x8d                          # 0044dc42
    mov dword ptr [edx + 0x5bb632], 0x2          # 0044dc48
    jmp.d32 L_0044ddbf                           # 0044dc52
L_0044dc57:
    # block 0x0044dc57: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0044dc7b (forward)
    call dword ptr [0x52a23c]                    # 0044dc57
    mov ecx, dword ptr [ebp - local_c]           # 0044dc5d
    cmp eax, dword ptr [ecx + field_4b]          # 0044dc60
    jb.d8 L_0044dc7b                             # 0044dc63
    # block 0x0044dc65: entered by fall-through of jb at 0x0044dc63, 6 instruction(s), falls into the block at 0x0044dc7b
    mov edx, dword ptr [ebp - local_c]           # 0044dc65
    mov eax, dword ptr [ebp - local_c]           # 0044dc68
    mov ecx, dword ptr [eax + field_31]          # 0044dc6b
    mov dword ptr [edx + field_2d], ecx          # 0044dc6e
    mov edx, dword ptr [ebp - local_c]           # 0044dc71
    mov dword ptr [edx + field_45], 0x1          # 0044dc74
L_0044dc7b:
    # block 0x0044dc7b: entered by jb at 0x0044dc63, 1 instruction(s), ends with forward jump to 0x0044ddbf
    jmp.d32 L_0044ddbf                           # 0044dc7b
L_0044dc80:
    # block 0x0044dc80: entered by switch case, 3 instruction(s), ends with forward jump to 0x0044ddbf
    mov eax, dword ptr [ebp - local_c]           # 0044dc80
    mov byte ptr [eax + field_24], 0x1           # 0044dc83
    jmp.d32 L_0044ddbf                           # 0044dc87
L_0044dc8c:
    # block 0x0044dc8c: entered by switch case, 8 instruction(s), calls FUN_0044d8ad, ends with forward jump to 0x0044ddbf
    push 0x1                                     # 0044dc8c
    mov ecx, dword ptr [ebp - local_c]           # 0044dc8e
    call FUN_0044d8ad                            # 0044dc91
    mov ecx, dword ptr [ebp - local_c]           # 0044dc96
    mov byte ptr [ecx + field_24], 0x1           # 0044dc99
    mov edx, dword ptr [ebp - local_c]           # 0044dc9d
    mov dword ptr [edx + field_2d], 0x1          # 0044dca0
    jmp.d32 L_0044ddbf                           # 0044dca7
L_0044dcac:
    # block 0x0044dcac: entered by switch case, 8 instruction(s), calls FUN_0044d8ad, ends with forward jump to 0x0044ddbf
    push 0x0                                     # 0044dcac
    mov ecx, dword ptr [ebp - local_c]           # 0044dcae
    call FUN_0044d8ad                            # 0044dcb1
    mov eax, dword ptr [ebp - local_c]           # 0044dcb6
    mov byte ptr [eax + field_24], 0x1           # 0044dcb9
    mov ecx, dword ptr [ebp - local_c]           # 0044dcbd
    mov dword ptr [ecx + field_2d], 0x1          # 0044dcc0
    jmp.d32 L_0044ddbf                           # 0044dcc7
L_0044dccc:
    # block 0x0044dccc: entered by switch case, 12 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0044ddbf
    call dword ptr [0x52a23c]                    # 0044dccc
    mov edx, dword ptr [ebp - local_4]           # 0044dcd2
    movsx ecx, word ptr [edx + field_2af]        # 0044dcd5
    imul ecx, ecx, 0x3e8                         # 0044dcdc
    {load} add eax, ecx                          # 0044dce2
    mov edx, dword ptr [ebp - local_c]           # 0044dce4
    mov dword ptr [edx + field_4f], eax          # 0044dce7
    mov eax, dword ptr [ebp - local_c]           # 0044dcea
    mov byte ptr [eax + field_4a], 0x1           # 0044dced
    mov ecx, dword ptr [ebp - local_c]           # 0044dcf1
    mov dword ptr [ecx + field_2d], 0x5          # 0044dcf4
    jmp.d32 L_0044ddbf                           # 0044dcfb
L_0044dd00:
    # block 0x0044dd00: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0044dd73 (forward)
    call dword ptr [0x52a23c]                    # 0044dd00
    mov edx, dword ptr [ebp - local_c]           # 0044dd06
    cmp eax, dword ptr [edx + field_4f]          # 0044dd09
    jb.d8 L_0044dd73                             # 0044dd0c
    # block 0x0044dd0e: entered by fall-through of jb at 0x0044dd0c, 7 instruction(s), ends with je to 0x0044dd5c (forward)
    mov edi, 0x5495fc                            # 0044dd0e
    mov esi, dword ptr [ebp - local_4]           # 0044dd13
    add esi, 0x2b1                               # 0044dd16
    mov ecx, 0x9                                 # 0044dd1c
    {load} xor eax, eax                          # 0044dd21
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0044dd23
    je.d8 L_0044dd5c                             # 0044dd25
    # block 0x0044dd27: entered by fall-through of je at 0x0044dd25, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x0044dd73
    mov ecx, dword ptr [ebp - local_4]           # 0044dd27
    add ecx, 0x2b1                               # 0044dd2a
    push ecx                                     # 0044dd30
    mov ecx, 0x5c3a67                            # 0044dd31
    call FUN_004fb77a                            # 0044dd36
    mov edx, dword ptr [ebp - local_4]           # 0044dd3b
    mov ax, word ptr [edx + field_2d2]           # 0044dd3e
    push eax                                     # 0044dd45
    mov ecx, 0x5c3a67                            # 0044dd46
    call FUN_004fb2e3                            # 0044dd4b
    mov ecx, dword ptr [ebp - local_c]           # 0044dd50
    mov dword ptr [ecx + field_2d], 0x7          # 0044dd53
    jmp.d8 L_0044dd73                            # 0044dd5a
L_0044dd5c:
    # block 0x0044dd5c: entered by je at 0x0044dd25, 4 instruction(s), falls into the block at 0x0044dd73
    mov edx, dword ptr [ebp - local_c]           # 0044dd5c
    movsx eax, word ptr [edx + field_1e]         # 0044dd5f
    imul eax, eax, 0x8d                          # 0044dd63
    mov dword ptr [eax + 0x5bb632], 0x2          # 0044dd69
L_0044dd73:
    # block 0x0044dd73: entered by jb at 0x0044dd0c; jmp at 0x0044dd5a, 1 instruction(s), ends with forward jump to 0x0044ddbf
    jmp.d8 L_0044ddbf                            # 0044dd73
L_0044dd75:
    # block 0x0044dd75: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0044ddbf (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044dd75
    movsx edx, word ptr [ecx + field_2d2]        # 0044dd78
    mov dword ptr [ebp - local_8], edx           # 0044dd7f
    mov eax, dword ptr [ebp - local_8]           # 0044dd82
    push eax                                     # 0044dd85
    mov ecx, 0x5cf1eb                            # 0044dd86
    call FUN_004f6334                            # 0044dd8b
    test eax, eax                                # 0044dd90
    jne.d8 L_0044ddbf                            # 0044dd92
    # block 0x0044dd94: entered by fall-through of jne at 0x0044dd92, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x0044ddbf
    mov ecx, dword ptr [ebp - local_4]           # 0044dd94
    add ecx, 0x2b1                               # 0044dd97
    push ecx                                     # 0044dd9d
    mov ecx, 0x5c3a67                            # 0044dd9e
    call FUN_004fba69                            # 0044dda3
    mov edx, dword ptr [ebp - local_c]           # 0044dda8
    movsx eax, word ptr [edx + field_1e]         # 0044ddab
    imul eax, eax, 0x8d                          # 0044ddaf
    mov dword ptr [eax + 0x5bb632], 0x2          # 0044ddb5
L_0044ddbf:
    # block 0x0044ddbf: entered by ja at 0x0044dc24; jmp at 0x0044dc52; jmp at 0x0044dc7b; jmp at 0x0044dc87; more, 1 instruction(s), ends with forward jump to 0x0044dff9
    jmp.d32 L_0044dff9                           # 0044ddbf
L_0044ddc4:
    # block 0x0044ddc4: entered by je at 0x0044da4d, 8 instruction(s), ends with je to 0x0044ddfa (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0044ddc4
    mov edi, 0x549608                            # 0044ddce
    mov esi, dword ptr [ebp - local_4]           # 0044ddd3
    add esi, 0x265                               # 0044ddd6
    mov ecx, 0x9                                 # 0044dddc
    {load} xor edx, edx                          # 0044dde1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0044dde3
    je.d8 L_0044ddfa                             # 0044dde5
    # block 0x0044dde7: entered by fall-through of je at 0x0044dde5, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0044ddfa
    mov eax, dword ptr [ebp - local_4]           # 0044dde7
    add eax, 0x265                               # 0044ddea
    push eax                                     # 0044ddef
    mov ecx, 0x5c3a67                            # 0044ddf0
    call FUN_004fba69                            # 0044ddf5
L_0044ddfa:
    # block 0x0044ddfa: entered by je at 0x0044dde5, 5 instruction(s), ends with je to 0x0044deec (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044ddfa
    {load} xor edx, edx                          # 0044ddfd
    mov dl, byte ptr [ecx + field_49]            # 0044ddff
    test edx, edx                                # 0044de02
    je.d32 L_0044deec                            # 0044de04
    # block 0x0044de0a: entered by fall-through of je at 0x0044de04, 4 instruction(s), ends with je to 0x0044debc (forward)
    mov eax, dword ptr [ebp - local_4]           # 0044de0a
    movsx ecx, word ptr [eax + field_2e2]        # 0044de0d
    cmp ecx, 0x270f                              # 0044de14
    je.d32 L_0044debc                            # 0044de1a
    # block 0x0044de20: entered by fall-through of je at 0x0044de1a, 25 instruction(s), ends with jne to 0x0044dea8 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044de20
    movsx eax, word ptr [edx + field_2e2]        # 0044de23
    mov dword ptr [0x5bb57b], eax                # 0044de2a
    mov ecx, dword ptr [ebp - local_4]           # 0044de2f
    mov dx, word ptr [ecx + field_2e4]           # 0044de32
    mov word ptr [0x5bb599], dx                  # 0044de39
    mov eax, dword ptr [ebp - local_4]           # 0044de40
    mov cx, word ptr [eax + field_2e6]           # 0044de43
    mov word ptr [0x5bb595], cx                  # 0044de4a
    mov edx, dword ptr [ebp - local_4]           # 0044de51
    mov ax, word ptr [edx + field_2e8]           # 0044de54
    mov word ptr [0x5c39ff], ax                  # 0044de5b
    mov ecx, dword ptr [ebp - local_4]           # 0044de61
    mov edx, dword ptr [ecx + field_2ea]         # 0044de64
    mov dword ptr [0x5bb59b], edx                # 0044de6a
    mov eax, dword ptr [ebp - local_4]           # 0044de70
    mov ecx, dword ptr [eax + field_2ee]         # 0044de73
    mov dword ptr [0x5bb59f], ecx                # 0044de79
    mov edx, dword ptr [ebp - local_4]           # 0044de7f
    mov eax, dword ptr [edx + field_2f2]         # 0044de82
    mov dword ptr [0x5bb5a3], eax                # 0044de88
    mov ecx, dword ptr [ebp - local_4]           # 0044de8d
    movsx edx, word ptr [ecx + field_2f6]        # 0044de90
    cmp edx, 0x1                                 # 0044de97
    jne.d8 L_0044dea8                            # 0044de9a
    # block 0x0044de9c: entered by fall-through of jne at 0x0044de9a, 2 instruction(s), ends with forward jump to 0x0044deb2
    mov dword ptr [0x5bb1ca], 0x0                # 0044de9c
    jmp.d8 L_0044deb2                            # 0044dea6
L_0044dea8:
    # block 0x0044dea8: entered by jne at 0x0044de9a, 1 instruction(s), falls into the block at 0x0044deb2
    mov dword ptr [0x5bb1ca], 0x1                # 0044dea8
L_0044deb2:
    # block 0x0044deb2: entered by jmp at 0x0044dea6, 1 instruction(s), falls into the block at 0x0044debc
    mov dword ptr [0x583999], 0x4                # 0044deb2
L_0044debc:
    # block 0x0044debc: entered by je at 0x0044de1a, 4 instruction(s), ends with je to 0x0044dee7 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0044debc
    movsx ecx, word ptr [eax + field_2f8]        # 0044debf
    cmp ecx, -0x1                                # 0044dec6
    je.d8 L_0044dee7                             # 0044dec9
    # block 0x0044decb: entered by fall-through of je at 0x0044dec9, 6 instruction(s), falls into the block at 0x0044dee7
    mov edx, dword ptr [ebp - local_4]           # 0044decb
    {load} xor eax, eax                          # 0044dece
    mov al, byte ptr [edx + field_2fa]           # 0044ded0
    mov ecx, dword ptr [ebp - local_4]           # 0044ded6
    movsx edx, word ptr [ecx + field_2f8]        # 0044ded9
    mov dword ptr [4*edx + 0x585801], eax        # 0044dee0
L_0044dee7:
    # block 0x0044dee7: entered by je at 0x0044dec9, 1 instruction(s), ends with forward jump to 0x0044dfe1
    jmp.d32 L_0044dfe1                           # 0044dee7
L_0044deec:
    # block 0x0044deec: entered by je at 0x0044de04, 5 instruction(s), ends with je to 0x0044dfe1 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0044deec
    {load} xor ecx, ecx                          # 0044deef
    mov cl, byte ptr [eax + field_4a]            # 0044def1
    test ecx, ecx                                # 0044def4
    je.d32 L_0044dfe1                            # 0044def6
    # block 0x0044defc: entered by fall-through of je at 0x0044def6, 6 instruction(s), calls FUN_0044d946, ends with je to 0x0044dfb6 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044defc
    call FUN_0044d946                            # 0044deff
    mov edx, dword ptr [ebp - local_4]           # 0044df04
    movsx eax, word ptr [edx + field_296]        # 0044df07
    cmp eax, 0x270f                              # 0044df0e
    je.d32 L_0044dfb6                            # 0044df13
    # block 0x0044df19: entered by fall-through of je at 0x0044df13, 25 instruction(s), ends with jne to 0x0044dfa2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044df19
    movsx edx, word ptr [ecx + field_296]        # 0044df1c
    mov dword ptr [0x5bb57b], edx                # 0044df23
    mov eax, dword ptr [ebp - local_4]           # 0044df29
    mov cx, word ptr [eax + field_298]           # 0044df2c
    mov word ptr [0x5bb599], cx                  # 0044df33
    mov edx, dword ptr [ebp - local_4]           # 0044df3a
    mov ax, word ptr [edx + field_29a]           # 0044df3d
    mov word ptr [0x5bb595], ax                  # 0044df44
    mov ecx, dword ptr [ebp - local_4]           # 0044df4a
    mov dx, word ptr [ecx + field_29c]           # 0044df4d
    mov word ptr [0x5c39ff], dx                  # 0044df54
    mov eax, dword ptr [ebp - local_4]           # 0044df5b
    mov ecx, dword ptr [eax + field_29e]         # 0044df5e
    mov dword ptr [0x5bb59b], ecx                # 0044df64
    mov edx, dword ptr [ebp - local_4]           # 0044df6a
    mov eax, dword ptr [edx + field_2a2]         # 0044df6d
    mov dword ptr [0x5bb59f], eax                # 0044df73
    mov ecx, dword ptr [ebp - local_4]           # 0044df78
    mov edx, dword ptr [ecx + field_2a6]         # 0044df7b
    mov dword ptr [0x5bb5a3], edx                # 0044df81
    mov eax, dword ptr [ebp - local_4]           # 0044df87
    movsx ecx, word ptr [eax + field_2aa]        # 0044df8a
    cmp ecx, 0x1                                 # 0044df91
    jne.d8 L_0044dfa2                            # 0044df94
    # block 0x0044df96: entered by fall-through of jne at 0x0044df94, 2 instruction(s), ends with forward jump to 0x0044dfac
    mov dword ptr [0x5bb1ca], 0x0                # 0044df96
    jmp.d8 L_0044dfac                            # 0044dfa0
L_0044dfa2:
    # block 0x0044dfa2: entered by jne at 0x0044df94, 1 instruction(s), falls into the block at 0x0044dfac
    mov dword ptr [0x5bb1ca], 0x1                # 0044dfa2
L_0044dfac:
    # block 0x0044dfac: entered by jmp at 0x0044dfa0, 1 instruction(s), falls into the block at 0x0044dfb6
    mov dword ptr [0x583999], 0x4                # 0044dfac
L_0044dfb6:
    # block 0x0044dfb6: entered by je at 0x0044df13, 4 instruction(s), ends with je to 0x0044dfe1 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044dfb6
    movsx eax, word ptr [edx + field_2ac]        # 0044dfb9
    cmp eax, -0x1                                # 0044dfc0
    je.d8 L_0044dfe1                             # 0044dfc3
    # block 0x0044dfc5: entered by fall-through of je at 0x0044dfc3, 6 instruction(s), falls into the block at 0x0044dfe1
    mov ecx, dword ptr [ebp - local_4]           # 0044dfc5
    {load} xor edx, edx                          # 0044dfc8
    mov dl, byte ptr [ecx + field_2ae]           # 0044dfca
    mov eax, dword ptr [ebp - local_4]           # 0044dfd0
    movsx ecx, word ptr [eax + field_2ac]        # 0044dfd3
    mov dword ptr [4*ecx + 0x585801], edx        # 0044dfda
L_0044dfe1:
    # block 0x0044dfe1: entered by jmp at 0x0044dee7; je at 0x0044def6; je at 0x0044dfc3, 7 instruction(s), calls FUN_0042ba3a, FUN_0044d154, falls into the block at 0x0044dff9
    mov edx, dword ptr [ebp - local_c]           # 0044dfe1
    mov ax, word ptr [edx + field_1e]            # 0044dfe4
    push eax                                     # 0044dfe8
    call FUN_0042ba3a                            # 0044dfe9
    add esp, 0x4                                 # 0044dfee
    mov ecx, dword ptr [ebp - local_c]           # 0044dff1
    call FUN_0044d154                            # 0044dff4
L_0044dff9:
    # block 0x0044dff9: entered by jmp at 0x0044da53; jmp at 0x0044dc12; jmp at 0x0044ddbf, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0044dff9
    pop esi                                      # 0044dffa
    {load} mov esp, ebp                          # 0044dffb
    pop ebp                                      # 0044dffd
    ret 0x4                                      # 0044dffe

# --- data items (not part of the function) -------------------------
.org 0x0044e001 - 0x401000
SWTAB_0044e001:  # 9 case address(es)
    .long L_0044dc80 - .text + 0x401000
    .long L_0044dc80 - .text + 0x401000
    .long L_0044dc57 - .text + 0x401000
    .long L_0044dc8c - .text + 0x401000
    .long L_0044dcac - .text + 0x401000
    .long L_0044dd00 - .text + 0x401000
    .long L_0044dccc - .text + 0x401000
    .long L_0044dd75 - .text + 0x401000
    .long L_0044dc34 - .text + 0x401000
.set SWTAB_0044e001_VA, SWTAB_0044e001 - .text + 0x401000

