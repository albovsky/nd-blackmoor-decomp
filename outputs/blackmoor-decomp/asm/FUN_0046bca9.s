# FUN_0046bca9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046bca9
# extent:       0x0046bca9-0x0046c41e (1909 code bytes)
# span:         0x0046bca9-0x0046c41e (code 1909, tables 0, padding 0)
# sha256:       7b27b8f015f95940e0924bd1903220042204691a460f9556448008f0259b1c09
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46bca9_hit_test
# naming:       native port src/original_methods_fl25d.c:m46bca9_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m46bca9_hit_test. Direct, Unicorn differential and oracle: every instruction reached, both jcc ways (untaken edges allowlisted in the handoff). See tasks/fl25d-handoff.md.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8, field_c, field_43, field_45, field_47, field_49, field_4f, field_6dd, field_48a4, field_4a2c, field_4a48 and 5 more; [ecx + n] field_4, field_8, field_c, field_1e, field_6d5, field_6d9, field_48a8, field_48aa, field_4a50, field_636a; [edx + n] field_4, field_8, field_c, field_43, field_45, field_4f, field_6d1, field_48a0, field_48ac, field_48ae, field_4a52
# callees:      calls FUN_0046b954, FUN_0046c41e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25d.c:m46bca9_hit_test (function ledger class native_oracle_verified; also scan_cells; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 494 instruction(s), 46 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_43, 0x43  # offset +0x43
.equ field_45, 0x45  # offset +0x45
.equ field_47, 0x47  # offset +0x47
.equ field_49, 0x49  # offset +0x49
.equ field_4f, 0x4f  # offset +0x4f
.equ field_6d1, 0x6d1  # offset +0x6d1
.equ field_6d5, 0x6d5  # offset +0x6d5
.equ field_6d9, 0x6d9  # offset +0x6d9
.equ field_6dd, 0x6dd  # offset +0x6dd
.equ field_48a0, 0x48a0  # offset +0x48a0
.equ field_48a4, 0x48a4  # offset +0x48a4
.equ field_48a8, 0x48a8  # offset +0x48a8
.equ field_48aa, 0x48aa  # offset +0x48aa
.equ field_48ac, 0x48ac  # offset +0x48ac
.equ field_48ae, 0x48ae  # offset +0x48ae
.equ field_4a2c, 0x4a2c  # offset +0x4a2c
.equ field_4a48, 0x4a48  # offset +0x4a48
.equ field_4a50, 0x4a50  # offset +0x4a50
.equ field_4a52, 0x4a52  # offset +0x4a52
.equ field_4a5a, 0x4a5a  # offset +0x4a5a
.equ field_4a5e, 0x4a5e  # offset +0x4a5e
.equ field_4a62, 0x4a62  # offset +0x4a62
.equ field_4a66, 0x4a66  # offset +0x4a66
.equ field_4a6a, 0x4a6a  # offset +0x4a6a
.equ field_636a, 0x636a  # offset +0x636a

# --- external targets -----------------------------------------------
.set FUN_0046b954, .text + (0x0046b954 - 0x401000)
.set FUN_0046c41e, .text + (0x0046c41e - 0x401000)

.org 0x0046bca9 - 0x401000
.globl FUN_0046bca9
FUN_0046bca9:
    # block 0x0046bca9: entry, 7 instruction(s), ends with je to 0x0046c416 (forward)
    push ebp                                     # 0046bca9
    {load} mov ebp, esp                          # 0046bcaa
    sub esp, 0x14                                # 0046bcac
    mov dword ptr [ebp - local_14], ecx          # 0046bcaf
    mov eax, dword ptr [ebp - local_14]          # 0046bcb2
    cmp dword ptr [eax + field_4a48], 0x0        # 0046bcb5
    je.d32 L_0046c416                            # 0046bcbc
    # block 0x0046bcc2: entered by fall-through of je at 0x0046bcbc, 28 instruction(s), ends with je to 0x0046c0ab (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0046bcc2
    movsx edx, word ptr [ecx + field_1e]         # 0046bcc5
    imul edx, edx, 0x8d                          # 0046bcc9
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046bccf
    mov dword ptr [ebp - local_8], eax           # 0046bcd5
    mov ecx, dword ptr [ebp - local_14]          # 0046bcd8
    mov word ptr [ecx + field_4a50], 0xffff      # 0046bcdb
    mov edx, dword ptr [ebp - local_14]          # 0046bce4
    mov word ptr [edx + field_4a52], 0xffff      # 0046bce7
    mov eax, dword ptr [ebp - local_14]          # 0046bcf0
    mov ecx, dword ptr [ebp + arg_10]            # 0046bcf3
    mov edx, dword ptr [ecx + field_4]           # 0046bcf6
    mov dword ptr [eax + field_4a5e], edx        # 0046bcf9
    mov eax, dword ptr [ebp - local_14]          # 0046bcff
    mov ecx, dword ptr [ebp + arg_10]            # 0046bd02
    mov edx, dword ptr [ecx + field_c]           # 0046bd05
    mov dword ptr [eax + field_4a66], edx        # 0046bd08
    mov eax, dword ptr [ebp - local_14]          # 0046bd0e
    mov ecx, dword ptr [ebp + arg_10]            # 0046bd11
    mov edx, dword ptr [ecx]                     # 0046bd14
    mov dword ptr [eax + field_4a5a], edx        # 0046bd16
    mov eax, dword ptr [ebp - local_14]          # 0046bd1c
    mov ecx, dword ptr [ebp + arg_10]            # 0046bd1f
    mov edx, dword ptr [ecx + field_8]           # 0046bd22
    mov dword ptr [eax + field_4a62], edx        # 0046bd25
    mov eax, dword ptr [ebp - local_14]          # 0046bd2b
    cmp dword ptr [eax + field_4a2c], 0x0        # 0046bd2e
    je.d32 L_0046c0ab                            # 0046bd35
    # block 0x0046bd3b: entered by fall-through of je at 0x0046bd35, 4 instruction(s), calls FUN_0046b954, ends with forward jump to 0x0046bd55
    mov ecx, dword ptr [ebp - local_14]          # 0046bd3b
    call FUN_0046b954                            # 0046bd3e
    mov dword ptr [ebp - local_4], 0x0           # 0046bd43
    jmp.d8 L_0046bd55                            # 0046bd4a
L_0046bd4c:
    # block 0x0046bd4c: entered by jmp at 0x0046beca, 3 instruction(s), falls into the block at 0x0046bd55
    mov ecx, dword ptr [ebp - local_4]           # 0046bd4c
    add ecx, 0x1                                 # 0046bd4f
    mov dword ptr [ebp - local_4], ecx           # 0046bd52
L_0046bd55:
    # block 0x0046bd55: entered by jmp at 0x0046bd4a, 4 instruction(s), ends with jge to 0x0046becf (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046bd55
    movsx eax, word ptr [edx + field_43]         # 0046bd58
    cmp dword ptr [ebp - local_4], eax           # 0046bd5c
    jge.d32 L_0046becf                           # 0046bd5f
    # block 0x0046bd65: entered by fall-through of jge at 0x0046bd5f, 2 instruction(s), ends with forward jump to 0x0046bd77
    mov dword ptr [ebp - local_c], 0x0           # 0046bd65
    jmp.d8 L_0046bd77                            # 0046bd6c
L_0046bd6e:
    # block 0x0046bd6e: entered by jmp at 0x0046bec5, 3 instruction(s), falls into the block at 0x0046bd77
    mov ecx, dword ptr [ebp - local_c]           # 0046bd6e
    add ecx, 0x1                                 # 0046bd71
    mov dword ptr [ebp - local_c], ecx           # 0046bd74
L_0046bd77:
    # block 0x0046bd77: entered by jmp at 0x0046bd6c, 4 instruction(s), ends with jge to 0x0046beca (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046bd77
    movsx eax, word ptr [edx + field_45]         # 0046bd7a
    cmp dword ptr [ebp - local_c], eax           # 0046bd7e
    jge.d32 L_0046beca                           # 0046bd81
    # block 0x0046bd87: entered by fall-through of jge at 0x0046bd81, 9 instruction(s), ends with jl to 0x0046bec5 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0046bd87
    mov edx, dword ptr [ebp - local_4]           # 0046bd8b
    imul edx, edx, 0x140                         # 0046bd8e
    mov eax, dword ptr [ebp - local_14]          # 0046bd94
    lea edx, [eax + edx + field_4a6a]            # 0046bd97
    mov eax, dword ptr [ebp - local_c]           # 0046bd9e
    shl eax, 0x4                                 # 0046bda1
    cmp ecx, dword ptr [edx + eax + field_4]     # 0046bda4
    jl.d32 L_0046bec5                            # 0046bda8
    # block 0x0046bdae: entered by fall-through of jl at 0x0046bda8, 9 instruction(s), ends with jg to 0x0046bec5 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0046bdae
    mov edx, dword ptr [ebp - local_4]           # 0046bdb2
    imul edx, edx, 0x140                         # 0046bdb5
    mov eax, dword ptr [ebp - local_14]          # 0046bdbb
    lea edx, [eax + edx + field_4a6a]            # 0046bdbe
    mov eax, dword ptr [ebp - local_c]           # 0046bdc5
    shl eax, 0x4                                 # 0046bdc8
    cmp ecx, dword ptr [edx + eax + field_c]     # 0046bdcb
    jg.d32 L_0046bec5                            # 0046bdcf
    # block 0x0046bdd5: entered by fall-through of jg at 0x0046bdcf, 9 instruction(s), ends with jl to 0x0046bec5 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0046bdd5
    mov edx, dword ptr [ebp - local_4]           # 0046bdd9
    imul edx, edx, 0x140                         # 0046bddc
    mov eax, dword ptr [ebp - local_14]          # 0046bde2
    lea edx, [eax + edx + field_4a6a]            # 0046bde5
    mov eax, dword ptr [ebp - local_c]           # 0046bdec
    shl eax, 0x4                                 # 0046bdef
    cmp ecx, dword ptr [edx + eax]               # 0046bdf2
    jl.d32 L_0046bec5                            # 0046bdf5
    # block 0x0046bdfb: entered by fall-through of jl at 0x0046bdf5, 9 instruction(s), ends with jg to 0x0046bec5 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0046bdfb
    mov edx, dword ptr [ebp - local_4]           # 0046bdff
    imul edx, edx, 0x140                         # 0046be02
    mov eax, dword ptr [ebp - local_14]          # 0046be08
    lea edx, [eax + edx + field_4a6a]            # 0046be0b
    mov eax, dword ptr [ebp - local_c]           # 0046be12
    shl eax, 0x4                                 # 0046be15
    cmp ecx, dword ptr [edx + eax + field_8]     # 0046be18
    jg.d32 L_0046bec5                            # 0046be1c
    # block 0x0046be22: entered by fall-through of jg at 0x0046be1c, 2 instruction(s), ends with forward jump to 0x0046be34
    mov dword ptr [ebp - local_10], 0x0          # 0046be22
    jmp.d8 L_0046be34                            # 0046be29
L_0046be2b:
    # block 0x0046be2b: entered by jmp at 0x0046bea2, 3 instruction(s), falls into the block at 0x0046be34
    mov ecx, dword ptr [ebp - local_10]          # 0046be2b
    add ecx, 0x1                                 # 0046be2e
    mov dword ptr [ebp - local_10], ecx          # 0046be31
L_0046be34:
    # block 0x0046be34: entered by jmp at 0x0046be29, 4 instruction(s), ends with jge to 0x0046bea4 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046be34
    movsx eax, word ptr [edx + field_4f]         # 0046be37
    cmp dword ptr [ebp - local_10], eax          # 0046be3b
    jge.d8 L_0046bea4                            # 0046be3e
    # block 0x0046be40: entered by fall-through of jge at 0x0046be3e, 5 instruction(s), ends with jne to 0x0046bea2 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046be40
    shl ecx, 0x4                                 # 0046be43
    mov edx, dword ptr [ebp - local_14]          # 0046be46
    cmp dword ptr [edx + ecx + field_48a0], 0x1  # 0046be49
    jne.d8 L_0046bea2                            # 0046be51
    # block 0x0046be53: entered by fall-through of jne at 0x0046be51, 6 instruction(s), ends with jne to 0x0046bea2 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046be53
    shl eax, 0x4                                 # 0046be56
    mov ecx, dword ptr [ebp - local_14]          # 0046be59
    movsx edx, word ptr [ecx + eax + field_48a8] # 0046be5c
    cmp edx, dword ptr [ebp - local_4]           # 0046be64
    jne.d8 L_0046bea2                            # 0046be67
    # block 0x0046be69: entered by fall-through of jne at 0x0046be67, 6 instruction(s), ends with jne to 0x0046bea2 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046be69
    shl eax, 0x4                                 # 0046be6c
    mov ecx, dword ptr [ebp - local_14]          # 0046be6f
    movsx edx, word ptr [ecx + eax + field_48aa] # 0046be72
    cmp edx, dword ptr [ebp - local_c]           # 0046be7a
    jne.d8 L_0046bea2                            # 0046be7d
    # block 0x0046be7f: entered by fall-through of jne at 0x0046be7d, 11 instruction(s), calls FUN_0046c41e, ends with forward jump to 0x0046c418
    mov eax, dword ptr [ebp - local_10]          # 0046be7f
    push eax                                     # 0046be82
    mov ecx, dword ptr [ebp - local_c]           # 0046be83
    push ecx                                     # 0046be86
    mov edx, dword ptr [ebp - local_4]           # 0046be87
    push edx                                     # 0046be8a
    push 0x27e2                                  # 0046be8b
    mov ecx, dword ptr [ebp - local_14]          # 0046be90
    call FUN_0046c41e                            # 0046be93
    mov eax, 0x1                                 # 0046be98
    jmp.d32 L_0046c418                           # 0046be9d
L_0046bea2:
    # block 0x0046bea2: entered by jne at 0x0046be51; jne at 0x0046be67; jne at 0x0046be7d, 1 instruction(s), ends with backward jump to 0x0046be2b
    jmp.d8 L_0046be2b                            # 0046bea2
L_0046bea4:
    # block 0x0046bea4: entered by jge at 0x0046be3e, 10 instruction(s), calls FUN_0046c41e, ends with forward jump to 0x0046c418
    push -0x1                                    # 0046bea4
    mov eax, dword ptr [ebp - local_c]           # 0046bea6
    push eax                                     # 0046bea9
    mov ecx, dword ptr [ebp - local_4]           # 0046beaa
    push ecx                                     # 0046bead
    push 0x27e3                                  # 0046beae
    mov ecx, dword ptr [ebp - local_14]          # 0046beb3
    call FUN_0046c41e                            # 0046beb6
    mov eax, 0x1                                 # 0046bebb
    jmp.d32 L_0046c418                           # 0046bec0
L_0046bec5:
    # block 0x0046bec5: entered by jl at 0x0046bda8; jg at 0x0046bdcf; jl at 0x0046bdf5; jg at 0x0046be1c, 1 instruction(s), ends with backward jump to 0x0046bd6e
    jmp.d32 L_0046bd6e                           # 0046bec5
L_0046beca:
    # block 0x0046beca: entered by jge at 0x0046bd81, 1 instruction(s), ends with backward jump to 0x0046bd4c
    jmp.d32 L_0046bd4c                           # 0046beca
L_0046becf:
    # block 0x0046becf: entered by jge at 0x0046bd5f, 2 instruction(s), ends with forward jump to 0x0046bee1
    mov dword ptr [ebp - local_4], 0x0           # 0046becf
    jmp.d8 L_0046bee1                            # 0046bed6
L_0046bed8:
    # block 0x0046bed8: entered by jmp at 0x0046c056, 3 instruction(s), falls into the block at 0x0046bee1
    mov edx, dword ptr [ebp - local_4]           # 0046bed8
    add edx, 0x1                                 # 0046bedb
    mov dword ptr [ebp - local_4], edx           # 0046bede
L_0046bee1:
    # block 0x0046bee1: entered by jmp at 0x0046bed6, 4 instruction(s), ends with jge to 0x0046c05b (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046bee1
    movsx ecx, word ptr [eax + field_43]         # 0046bee4
    cmp dword ptr [ebp - local_4], ecx           # 0046bee8
    jge.d32 L_0046c05b                           # 0046beeb
    # block 0x0046bef1: entered by fall-through of jge at 0x0046beeb, 2 instruction(s), ends with forward jump to 0x0046bf03
    mov dword ptr [ebp - local_c], 0x0           # 0046bef1
    jmp.d8 L_0046bf03                            # 0046bef8
L_0046befa:
    # block 0x0046befa: entered by jmp at 0x0046c051, 3 instruction(s), falls into the block at 0x0046bf03
    mov edx, dword ptr [ebp - local_c]           # 0046befa
    add edx, 0x1                                 # 0046befd
    mov dword ptr [ebp - local_c], edx           # 0046bf00
L_0046bf03:
    # block 0x0046bf03: entered by jmp at 0x0046bef8, 4 instruction(s), ends with jge to 0x0046c056 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046bf03
    movsx ecx, word ptr [eax + field_45]         # 0046bf06
    cmp dword ptr [ebp - local_c], ecx           # 0046bf0a
    jge.d32 L_0046c056                           # 0046bf0d
    # block 0x0046bf13: entered by fall-through of jge at 0x0046bf0d, 9 instruction(s), ends with jl to 0x0046c051 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0046bf13
    mov eax, dword ptr [ebp - local_4]           # 0046bf17
    imul eax, eax, 0x140                         # 0046bf1a
    mov ecx, dword ptr [ebp - local_14]          # 0046bf20
    lea eax, [ecx + eax + field_636a]            # 0046bf23
    mov ecx, dword ptr [ebp - local_c]           # 0046bf2a
    shl ecx, 0x4                                 # 0046bf2d
    cmp edx, dword ptr [eax + ecx + field_4]     # 0046bf30
    jl.d32 L_0046c051                            # 0046bf34
    # block 0x0046bf3a: entered by fall-through of jl at 0x0046bf34, 9 instruction(s), ends with jg to 0x0046c051 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0046bf3a
    mov eax, dword ptr [ebp - local_4]           # 0046bf3e
    imul eax, eax, 0x140                         # 0046bf41
    mov ecx, dword ptr [ebp - local_14]          # 0046bf47
    lea eax, [ecx + eax + field_636a]            # 0046bf4a
    mov ecx, dword ptr [ebp - local_c]           # 0046bf51
    shl ecx, 0x4                                 # 0046bf54
    cmp edx, dword ptr [eax + ecx + field_c]     # 0046bf57
    jg.d32 L_0046c051                            # 0046bf5b
    # block 0x0046bf61: entered by fall-through of jg at 0x0046bf5b, 9 instruction(s), ends with jl to 0x0046c051 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0046bf61
    mov eax, dword ptr [ebp - local_4]           # 0046bf65
    imul eax, eax, 0x140                         # 0046bf68
    mov ecx, dword ptr [ebp - local_14]          # 0046bf6e
    lea eax, [ecx + eax + field_636a]            # 0046bf71
    mov ecx, dword ptr [ebp - local_c]           # 0046bf78
    shl ecx, 0x4                                 # 0046bf7b
    cmp edx, dword ptr [eax + ecx]               # 0046bf7e
    jl.d32 L_0046c051                            # 0046bf81
    # block 0x0046bf87: entered by fall-through of jl at 0x0046bf81, 9 instruction(s), ends with jg to 0x0046c051 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0046bf87
    mov eax, dword ptr [ebp - local_4]           # 0046bf8b
    imul eax, eax, 0x140                         # 0046bf8e
    mov ecx, dword ptr [ebp - local_14]          # 0046bf94
    lea eax, [ecx + eax + field_636a]            # 0046bf97
    mov ecx, dword ptr [ebp - local_c]           # 0046bf9e
    shl ecx, 0x4                                 # 0046bfa1
    cmp edx, dword ptr [eax + ecx + field_8]     # 0046bfa4
    jg.d32 L_0046c051                            # 0046bfa8
    # block 0x0046bfae: entered by fall-through of jg at 0x0046bfa8, 2 instruction(s), ends with forward jump to 0x0046bfc0
    mov dword ptr [ebp - local_10], 0x0          # 0046bfae
    jmp.d8 L_0046bfc0                            # 0046bfb5
L_0046bfb7:
    # block 0x0046bfb7: entered by jmp at 0x0046c02e, 3 instruction(s), falls into the block at 0x0046bfc0
    mov edx, dword ptr [ebp - local_10]          # 0046bfb7
    add edx, 0x1                                 # 0046bfba
    mov dword ptr [ebp - local_10], edx          # 0046bfbd
L_0046bfc0:
    # block 0x0046bfc0: entered by jmp at 0x0046bfb5, 4 instruction(s), ends with jge to 0x0046c030 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046bfc0
    movsx ecx, word ptr [eax + field_4f]         # 0046bfc3
    cmp dword ptr [ebp - local_10], ecx          # 0046bfc7
    jge.d8 L_0046c030                            # 0046bfca
    # block 0x0046bfcc: entered by fall-through of jge at 0x0046bfca, 5 instruction(s), ends with jne to 0x0046c02e (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046bfcc
    shl edx, 0x4                                 # 0046bfcf
    mov eax, dword ptr [ebp - local_14]          # 0046bfd2
    cmp dword ptr [eax + edx + field_48a4], 0x1  # 0046bfd5
    jne.d8 L_0046c02e                            # 0046bfdd
    # block 0x0046bfdf: entered by fall-through of jne at 0x0046bfdd, 6 instruction(s), ends with jne to 0x0046c02e (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046bfdf
    shl ecx, 0x4                                 # 0046bfe2
    mov edx, dword ptr [ebp - local_14]          # 0046bfe5
    movsx eax, word ptr [edx + ecx + field_48ac] # 0046bfe8
    cmp eax, dword ptr [ebp - local_4]           # 0046bff0
    jne.d8 L_0046c02e                            # 0046bff3
    # block 0x0046bff5: entered by fall-through of jne at 0x0046bff3, 6 instruction(s), ends with jne to 0x0046c02e (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046bff5
    shl ecx, 0x4                                 # 0046bff8
    mov edx, dword ptr [ebp - local_14]          # 0046bffb
    movsx eax, word ptr [edx + ecx + field_48ae] # 0046bffe
    cmp eax, dword ptr [ebp - local_c]           # 0046c006
    jne.d8 L_0046c02e                            # 0046c009
    # block 0x0046c00b: entered by fall-through of jne at 0x0046c009, 11 instruction(s), calls FUN_0046c41e, ends with forward jump to 0x0046c418
    mov ecx, dword ptr [ebp - local_10]          # 0046c00b
    push ecx                                     # 0046c00e
    mov edx, dword ptr [ebp - local_c]           # 0046c00f
    push edx                                     # 0046c012
    mov eax, dword ptr [ebp - local_4]           # 0046c013
    push eax                                     # 0046c016
    push 0x27e4                                  # 0046c017
    mov ecx, dword ptr [ebp - local_14]          # 0046c01c
    call FUN_0046c41e                            # 0046c01f
    mov eax, 0x1                                 # 0046c024
    jmp.d32 L_0046c418                           # 0046c029
L_0046c02e:
    # block 0x0046c02e: entered by jne at 0x0046bfdd; jne at 0x0046bff3; jne at 0x0046c009, 1 instruction(s), ends with backward jump to 0x0046bfb7
    jmp.d8 L_0046bfb7                            # 0046c02e
L_0046c030:
    # block 0x0046c030: entered by jge at 0x0046bfca, 10 instruction(s), calls FUN_0046c41e, ends with forward jump to 0x0046c418
    push -0x1                                    # 0046c030
    mov ecx, dword ptr [ebp - local_c]           # 0046c032
    push ecx                                     # 0046c035
    mov edx, dword ptr [ebp - local_4]           # 0046c036
    push edx                                     # 0046c039
    push 0x27e5                                  # 0046c03a
    mov ecx, dword ptr [ebp - local_14]          # 0046c03f
    call FUN_0046c41e                            # 0046c042
    mov eax, 0x1                                 # 0046c047
    jmp.d32 L_0046c418                           # 0046c04c
L_0046c051:
    # block 0x0046c051: entered by jl at 0x0046bf34; jg at 0x0046bf5b; jl at 0x0046bf81; jg at 0x0046bfa8, 1 instruction(s), ends with backward jump to 0x0046befa
    jmp.d32 L_0046befa                           # 0046c051
L_0046c056:
    # block 0x0046c056: entered by jge at 0x0046bf0d, 1 instruction(s), ends with backward jump to 0x0046bed8
    jmp.d32 L_0046bed8                           # 0046c056
L_0046c05b:
    # block 0x0046c05b: entered by jge at 0x0046beeb, 13 instruction(s), ends with forward jump to 0x0046c418
    mov dword ptr [0x5b44f0], 0x24               # 0046c05b
    mov dword ptr [0x5b44f4], 0x0                # 0046c065
    mov eax, dword ptr [0x5d0377]                # 0046c06f
    mov dword ptr [0x5d162d], eax                # 0046c074
    mov ecx, dword ptr [0x5b44f0]                # 0046c079
    shl ecx, 0x5                                 # 0046c07f
    mov edx, dword ptr [0x5b44f4]                # 0046c082
    shl edx, 0x4                                 # 0046c088
    lea eax, [ecx + edx + 0x5b160c]              # 0046c08b
    mov dword ptr [0x5d1631], eax                # 0046c092
    mov dword ptr [0x5d1639], 0x1                # 0046c097
    mov eax, 0x1                                 # 0046c0a1
    jmp.d32 L_0046c418                           # 0046c0a6
L_0046c0ab:
    # block 0x0046c0ab: entered by je at 0x0046bd35, 2 instruction(s), ends with forward jump to 0x0046c0bd
    mov dword ptr [ebp - local_4], 0x0           # 0046c0ab
    jmp.d8 L_0046c0bd                            # 0046c0b2
L_0046c0b4:
    # block 0x0046c0b4: entered by jmp at 0x0046c232, 3 instruction(s), falls into the block at 0x0046c0bd
    mov ecx, dword ptr [ebp - local_4]           # 0046c0b4
    add ecx, 0x1                                 # 0046c0b7
    mov dword ptr [ebp - local_4], ecx           # 0046c0ba
L_0046c0bd:
    # block 0x0046c0bd: entered by jmp at 0x0046c0b2, 4 instruction(s), ends with jge to 0x0046c237 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046c0bd
    movsx eax, word ptr [edx + field_43]         # 0046c0c0
    cmp dword ptr [ebp - local_4], eax           # 0046c0c4
    jge.d32 L_0046c237                           # 0046c0c7
    # block 0x0046c0cd: entered by fall-through of jge at 0x0046c0c7, 2 instruction(s), ends with forward jump to 0x0046c0df
    mov dword ptr [ebp - local_c], 0x0           # 0046c0cd
    jmp.d8 L_0046c0df                            # 0046c0d4
L_0046c0d6:
    # block 0x0046c0d6: entered by jmp at 0x0046c22d, 3 instruction(s), falls into the block at 0x0046c0df
    mov ecx, dword ptr [ebp - local_c]           # 0046c0d6
    add ecx, 0x1                                 # 0046c0d9
    mov dword ptr [ebp - local_c], ecx           # 0046c0dc
L_0046c0df:
    # block 0x0046c0df: entered by jmp at 0x0046c0d4, 4 instruction(s), ends with jge to 0x0046c232 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046c0df
    movsx eax, word ptr [edx + field_45]         # 0046c0e2
    cmp dword ptr [ebp - local_c], eax           # 0046c0e6
    jge.d32 L_0046c232                           # 0046c0e9
    # block 0x0046c0ef: entered by fall-through of jge at 0x0046c0e9, 9 instruction(s), ends with jl to 0x0046c22d (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0046c0ef
    mov edx, dword ptr [ebp - local_4]           # 0046c0f3
    imul edx, edx, 0x140                         # 0046c0f6
    mov eax, dword ptr [ebp - local_14]          # 0046c0fc
    lea edx, [eax + edx + field_4a6a]            # 0046c0ff
    mov eax, dword ptr [ebp - local_c]           # 0046c106
    shl eax, 0x4                                 # 0046c109
    cmp ecx, dword ptr [edx + eax + field_4]     # 0046c10c
    jl.d32 L_0046c22d                            # 0046c110
    # block 0x0046c116: entered by fall-through of jl at 0x0046c110, 9 instruction(s), ends with jg to 0x0046c22d (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0046c116
    mov edx, dword ptr [ebp - local_4]           # 0046c11a
    imul edx, edx, 0x140                         # 0046c11d
    mov eax, dword ptr [ebp - local_14]          # 0046c123
    lea edx, [eax + edx + field_4a6a]            # 0046c126
    mov eax, dword ptr [ebp - local_c]           # 0046c12d
    shl eax, 0x4                                 # 0046c130
    cmp ecx, dword ptr [edx + eax + field_c]     # 0046c133
    jg.d32 L_0046c22d                            # 0046c137
    # block 0x0046c13d: entered by fall-through of jg at 0x0046c137, 9 instruction(s), ends with jl to 0x0046c22d (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0046c13d
    mov edx, dword ptr [ebp - local_4]           # 0046c141
    imul edx, edx, 0x140                         # 0046c144
    mov eax, dword ptr [ebp - local_14]          # 0046c14a
    lea edx, [eax + edx + field_4a6a]            # 0046c14d
    mov eax, dword ptr [ebp - local_c]           # 0046c154
    shl eax, 0x4                                 # 0046c157
    cmp ecx, dword ptr [edx + eax]               # 0046c15a
    jl.d32 L_0046c22d                            # 0046c15d
    # block 0x0046c163: entered by fall-through of jl at 0x0046c15d, 9 instruction(s), ends with jg to 0x0046c22d (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0046c163
    mov edx, dword ptr [ebp - local_4]           # 0046c167
    imul edx, edx, 0x140                         # 0046c16a
    mov eax, dword ptr [ebp - local_14]          # 0046c170
    lea edx, [eax + edx + field_4a6a]            # 0046c173
    mov eax, dword ptr [ebp - local_c]           # 0046c17a
    shl eax, 0x4                                 # 0046c17d
    cmp ecx, dword ptr [edx + eax + field_8]     # 0046c180
    jg.d32 L_0046c22d                            # 0046c184
    # block 0x0046c18a: entered by fall-through of jg at 0x0046c184, 2 instruction(s), ends with forward jump to 0x0046c19c
    mov dword ptr [ebp - local_10], 0x0          # 0046c18a
    jmp.d8 L_0046c19c                            # 0046c191
L_0046c193:
    # block 0x0046c193: entered by jmp at 0x0046c20a, 3 instruction(s), falls into the block at 0x0046c19c
    mov ecx, dword ptr [ebp - local_10]          # 0046c193
    add ecx, 0x1                                 # 0046c196
    mov dword ptr [ebp - local_10], ecx          # 0046c199
L_0046c19c:
    # block 0x0046c19c: entered by jmp at 0x0046c191, 4 instruction(s), ends with jge to 0x0046c20c (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046c19c
    movsx eax, word ptr [edx + field_4f]         # 0046c19f
    cmp dword ptr [ebp - local_10], eax          # 0046c1a3
    jge.d8 L_0046c20c                            # 0046c1a6
    # block 0x0046c1a8: entered by fall-through of jge at 0x0046c1a6, 5 instruction(s), ends with jne to 0x0046c20a (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046c1a8
    shl ecx, 0x4                                 # 0046c1ab
    mov edx, dword ptr [ebp - local_14]          # 0046c1ae
    cmp dword ptr [edx + ecx + field_48a0], 0x1  # 0046c1b1
    jne.d8 L_0046c20a                            # 0046c1b9
    # block 0x0046c1bb: entered by fall-through of jne at 0x0046c1b9, 6 instruction(s), ends with jne to 0x0046c20a (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046c1bb
    shl eax, 0x4                                 # 0046c1be
    mov ecx, dword ptr [ebp - local_14]          # 0046c1c1
    movsx edx, word ptr [ecx + eax + field_48a8] # 0046c1c4
    cmp edx, dword ptr [ebp - local_4]           # 0046c1cc
    jne.d8 L_0046c20a                            # 0046c1cf
    # block 0x0046c1d1: entered by fall-through of jne at 0x0046c1cf, 6 instruction(s), ends with jne to 0x0046c20a (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046c1d1
    shl eax, 0x4                                 # 0046c1d4
    mov ecx, dword ptr [ebp - local_14]          # 0046c1d7
    movsx edx, word ptr [ecx + eax + field_48aa] # 0046c1da
    cmp edx, dword ptr [ebp - local_c]           # 0046c1e2
    jne.d8 L_0046c20a                            # 0046c1e5
    # block 0x0046c1e7: entered by fall-through of jne at 0x0046c1e5, 11 instruction(s), calls FUN_0046c41e, ends with forward jump to 0x0046c418
    mov eax, dword ptr [ebp - local_10]          # 0046c1e7
    push eax                                     # 0046c1ea
    mov ecx, dword ptr [ebp - local_c]           # 0046c1eb
    push ecx                                     # 0046c1ee
    mov edx, dword ptr [ebp - local_4]           # 0046c1ef
    push edx                                     # 0046c1f2
    push 0x27e6                                  # 0046c1f3
    mov ecx, dword ptr [ebp - local_14]          # 0046c1f8
    call FUN_0046c41e                            # 0046c1fb
    mov eax, 0x1                                 # 0046c200
    jmp.d32 L_0046c418                           # 0046c205
L_0046c20a:
    # block 0x0046c20a: entered by jne at 0x0046c1b9; jne at 0x0046c1cf; jne at 0x0046c1e5, 1 instruction(s), ends with backward jump to 0x0046c193
    jmp.d8 L_0046c193                            # 0046c20a
L_0046c20c:
    # block 0x0046c20c: entered by jge at 0x0046c1a6, 10 instruction(s), calls FUN_0046c41e, ends with forward jump to 0x0046c418
    push -0x1                                    # 0046c20c
    mov eax, dword ptr [ebp - local_c]           # 0046c20e
    push eax                                     # 0046c211
    mov ecx, dword ptr [ebp - local_4]           # 0046c212
    push ecx                                     # 0046c215
    push 0x27e7                                  # 0046c216
    mov ecx, dword ptr [ebp - local_14]          # 0046c21b
    call FUN_0046c41e                            # 0046c21e
    mov eax, 0x1                                 # 0046c223
    jmp.d32 L_0046c418                           # 0046c228
L_0046c22d:
    # block 0x0046c22d: entered by jl at 0x0046c110; jg at 0x0046c137; jl at 0x0046c15d; jg at 0x0046c184, 1 instruction(s), ends with backward jump to 0x0046c0d6
    jmp.d32 L_0046c0d6                           # 0046c22d
L_0046c232:
    # block 0x0046c232: entered by jge at 0x0046c0e9, 1 instruction(s), ends with backward jump to 0x0046c0b4
    jmp.d32 L_0046c0b4                           # 0046c232
L_0046c237:
    # block 0x0046c237: entered by jge at 0x0046c0c7, 2 instruction(s), ends with forward jump to 0x0046c249
    mov dword ptr [ebp - local_4], 0x0           # 0046c237
    jmp.d8 L_0046c249                            # 0046c23e
L_0046c240:
    # block 0x0046c240: entered by jmp at 0x0046c3bb, 3 instruction(s), falls into the block at 0x0046c249
    mov edx, dword ptr [ebp - local_4]           # 0046c240
    add edx, 0x1                                 # 0046c243
    mov dword ptr [ebp - local_4], edx           # 0046c246
L_0046c249:
    # block 0x0046c249: entered by jmp at 0x0046c23e, 4 instruction(s), ends with jge to 0x0046c3c0 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046c249
    movsx ecx, word ptr [eax + field_47]         # 0046c24c
    cmp dword ptr [ebp - local_4], ecx           # 0046c250
    jge.d32 L_0046c3c0                           # 0046c253
    # block 0x0046c259: entered by fall-through of jge at 0x0046c253, 2 instruction(s), ends with forward jump to 0x0046c26b
    mov dword ptr [ebp - local_c], 0x0           # 0046c259
    jmp.d8 L_0046c26b                            # 0046c260
L_0046c262:
    # block 0x0046c262: entered by jmp at 0x0046c3b6, 3 instruction(s), falls into the block at 0x0046c26b
    mov edx, dword ptr [ebp - local_c]           # 0046c262
    add edx, 0x1                                 # 0046c265
    mov dword ptr [ebp - local_c], edx           # 0046c268
L_0046c26b:
    # block 0x0046c26b: entered by jmp at 0x0046c260, 4 instruction(s), ends with jge to 0x0046c3bb (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046c26b
    movsx ecx, word ptr [eax + field_49]         # 0046c26e
    cmp dword ptr [ebp - local_c], ecx           # 0046c272
    jge.d32 L_0046c3bb                           # 0046c275
    # block 0x0046c27b: entered by fall-through of jge at 0x0046c275, 9 instruction(s), ends with jl to 0x0046c3b6 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0046c27b
    mov eax, dword ptr [ebp - local_4]           # 0046c27f
    imul eax, eax, 0x140                         # 0046c282
    mov ecx, dword ptr [ebp - local_14]          # 0046c288
    lea eax, [ecx + eax + field_636a]            # 0046c28b
    mov ecx, dword ptr [ebp - local_c]           # 0046c292
    shl ecx, 0x4                                 # 0046c295
    cmp edx, dword ptr [eax + ecx + field_4]     # 0046c298
    jl.d32 L_0046c3b6                            # 0046c29c
    # block 0x0046c2a2: entered by fall-through of jl at 0x0046c29c, 9 instruction(s), ends with jg to 0x0046c3b6 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0046c2a2
    mov eax, dword ptr [ebp - local_4]           # 0046c2a6
    imul eax, eax, 0x140                         # 0046c2a9
    mov ecx, dword ptr [ebp - local_14]          # 0046c2af
    lea eax, [ecx + eax + field_636a]            # 0046c2b2
    mov ecx, dword ptr [ebp - local_c]           # 0046c2b9
    shl ecx, 0x4                                 # 0046c2bc
    cmp edx, dword ptr [eax + ecx + field_c]     # 0046c2bf
    jg.d32 L_0046c3b6                            # 0046c2c3
    # block 0x0046c2c9: entered by fall-through of jg at 0x0046c2c3, 9 instruction(s), ends with jl to 0x0046c3b6 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0046c2c9
    mov eax, dword ptr [ebp - local_4]           # 0046c2cd
    imul eax, eax, 0x140                         # 0046c2d0
    mov ecx, dword ptr [ebp - local_14]          # 0046c2d6
    lea eax, [ecx + eax + field_636a]            # 0046c2d9
    mov ecx, dword ptr [ebp - local_c]           # 0046c2e0
    shl ecx, 0x4                                 # 0046c2e3
    cmp edx, dword ptr [eax + ecx]               # 0046c2e6
    jl.d32 L_0046c3b6                            # 0046c2e9
    # block 0x0046c2ef: entered by fall-through of jl at 0x0046c2e9, 9 instruction(s), ends with jg to 0x0046c3b6 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0046c2ef
    mov eax, dword ptr [ebp - local_4]           # 0046c2f3
    imul eax, eax, 0x140                         # 0046c2f6
    mov ecx, dword ptr [ebp - local_14]          # 0046c2fc
    lea eax, [ecx + eax + field_636a]            # 0046c2ff
    mov ecx, dword ptr [ebp - local_c]           # 0046c306
    shl ecx, 0x4                                 # 0046c309
    cmp edx, dword ptr [eax + ecx + field_8]     # 0046c30c
    jg.d32 L_0046c3b6                            # 0046c310
    # block 0x0046c316: entered by fall-through of jg at 0x0046c310, 2 instruction(s), ends with forward jump to 0x0046c328
    mov dword ptr [ebp - local_10], 0x0          # 0046c316
    jmp.d8 L_0046c328                            # 0046c31d
L_0046c31f:
    # block 0x0046c31f: entered by jmp at 0x0046c396, 3 instruction(s), falls into the block at 0x0046c328
    mov edx, dword ptr [ebp - local_10]          # 0046c31f
    add edx, 0x1                                 # 0046c322
    mov dword ptr [ebp - local_10], edx          # 0046c325
L_0046c328:
    # block 0x0046c328: entered by jmp at 0x0046c31d, 4 instruction(s), ends with jge to 0x0046c398 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0046c328
    movsx ecx, word ptr [eax + field_4f]         # 0046c32b
    cmp dword ptr [ebp - local_10], ecx          # 0046c32f
    jge.d8 L_0046c398                            # 0046c332
    # block 0x0046c334: entered by fall-through of jge at 0x0046c332, 5 instruction(s), ends with jne to 0x0046c396 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046c334
    shl edx, 0x4                                 # 0046c337
    mov eax, dword ptr [ebp - local_14]          # 0046c33a
    cmp dword ptr [eax + edx + field_48a4], 0x1  # 0046c33d
    jne.d8 L_0046c396                            # 0046c345
    # block 0x0046c347: entered by fall-through of jne at 0x0046c345, 6 instruction(s), ends with jne to 0x0046c396 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046c347
    shl ecx, 0x4                                 # 0046c34a
    mov edx, dword ptr [ebp - local_14]          # 0046c34d
    movsx eax, word ptr [edx + ecx + field_48ac] # 0046c350
    cmp eax, dword ptr [ebp - local_4]           # 0046c358
    jne.d8 L_0046c396                            # 0046c35b
    # block 0x0046c35d: entered by fall-through of jne at 0x0046c35b, 6 instruction(s), ends with jne to 0x0046c396 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046c35d
    shl ecx, 0x4                                 # 0046c360
    mov edx, dword ptr [ebp - local_14]          # 0046c363
    movsx eax, word ptr [edx + ecx + field_48ae] # 0046c366
    cmp eax, dword ptr [ebp - local_c]           # 0046c36e
    jne.d8 L_0046c396                            # 0046c371
    # block 0x0046c373: entered by fall-through of jne at 0x0046c371, 11 instruction(s), calls FUN_0046c41e, ends with forward jump to 0x0046c418
    mov ecx, dword ptr [ebp - local_10]          # 0046c373
    push ecx                                     # 0046c376
    mov edx, dword ptr [ebp - local_c]           # 0046c377
    push edx                                     # 0046c37a
    mov eax, dword ptr [ebp - local_4]           # 0046c37b
    push eax                                     # 0046c37e
    push 0x27e8                                  # 0046c37f
    mov ecx, dword ptr [ebp - local_14]          # 0046c384
    call FUN_0046c41e                            # 0046c387
    mov eax, 0x1                                 # 0046c38c
    jmp.d32 L_0046c418                           # 0046c391
L_0046c396:
    # block 0x0046c396: entered by jne at 0x0046c345; jne at 0x0046c35b; jne at 0x0046c371, 1 instruction(s), ends with backward jump to 0x0046c31f
    jmp.d8 L_0046c31f                            # 0046c396
L_0046c398:
    # block 0x0046c398: entered by jge at 0x0046c332, 10 instruction(s), calls FUN_0046c41e, ends with forward jump to 0x0046c418
    push -0x1                                    # 0046c398
    mov ecx, dword ptr [ebp - local_c]           # 0046c39a
    push ecx                                     # 0046c39d
    mov edx, dword ptr [ebp - local_4]           # 0046c39e
    push edx                                     # 0046c3a1
    push 0x27e9                                  # 0046c3a2
    mov ecx, dword ptr [ebp - local_14]          # 0046c3a7
    call FUN_0046c41e                            # 0046c3aa
    mov eax, 0x1                                 # 0046c3af
    jmp.d8 L_0046c418                            # 0046c3b4
L_0046c3b6:
    # block 0x0046c3b6: entered by jl at 0x0046c29c; jg at 0x0046c2c3; jl at 0x0046c2e9; jg at 0x0046c310, 1 instruction(s), ends with backward jump to 0x0046c262
    jmp.d32 L_0046c262                           # 0046c3b6
L_0046c3bb:
    # block 0x0046c3bb: entered by jge at 0x0046c275, 1 instruction(s), ends with backward jump to 0x0046c240
    jmp.d32 L_0046c240                           # 0046c3bb
L_0046c3c0:
    # block 0x0046c3c0: entered by jge at 0x0046c253, 4 instruction(s), ends with jl to 0x0046c416 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0046c3c0
    mov ecx, dword ptr [ebp - local_8]           # 0046c3c4
    cmp eax, dword ptr [ecx + field_6d5]         # 0046c3c7
    jl.d8 L_0046c416                             # 0046c3cd
    # block 0x0046c3cf: entered by fall-through of jl at 0x0046c3cd, 4 instruction(s), ends with jg to 0x0046c416 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0046c3cf
    mov eax, dword ptr [ebp - local_8]           # 0046c3d3
    cmp edx, dword ptr [eax + field_6dd]         # 0046c3d6
    jg.d8 L_0046c416                             # 0046c3dc
    # block 0x0046c3de: entered by fall-through of jg at 0x0046c3dc, 4 instruction(s), ends with jl to 0x0046c416 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0046c3de
    mov edx, dword ptr [ebp - local_8]           # 0046c3e2
    cmp ecx, dword ptr [edx + field_6d1]         # 0046c3e5
    jl.d8 L_0046c416                             # 0046c3eb
    # block 0x0046c3ed: entered by fall-through of jl at 0x0046c3eb, 4 instruction(s), ends with jg to 0x0046c416 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0046c3ed
    mov ecx, dword ptr [ebp - local_8]           # 0046c3f1
    cmp eax, dword ptr [ecx + field_6d9]         # 0046c3f4
    jg.d8 L_0046c416                             # 0046c3fa
    # block 0x0046c3fc: entered by fall-through of jg at 0x0046c3fa, 8 instruction(s), calls FUN_0046c41e, ends with forward jump to 0x0046c418
    push -0x1                                    # 0046c3fc
    push 0x0                                     # 0046c3fe
    push 0x0                                     # 0046c400
    push 0x27ea                                  # 0046c402
    mov ecx, dword ptr [ebp - local_14]          # 0046c407
    call FUN_0046c41e                            # 0046c40a
    mov eax, 0x1                                 # 0046c40f
    jmp.d8 L_0046c418                            # 0046c414
L_0046c416:
    # block 0x0046c416: entered by je at 0x0046bcbc; jl at 0x0046c3cd; jg at 0x0046c3dc; jl at 0x0046c3eb; jg at 0x0046c3fa, 1 instruction(s), falls into the block at 0x0046c418
    {load} xor eax, eax                          # 0046c416
L_0046c418:
    # block 0x0046c418: entered by jmp at 0x0046be9d; jmp at 0x0046bec0; jmp at 0x0046c029; jmp at 0x0046c04c; more, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 0046c418
    pop ebp                                      # 0046c41a
    ret 0xc                                      # 0046c41b

