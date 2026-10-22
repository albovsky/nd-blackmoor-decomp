# FUN_0045ef5a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045ef5a
# extent:       0x0045ef5a-0x0045f0e6 (396 code bytes)
# span:         0x0045ef5a-0x0045f0e6 (code 396, tables 0, padding 0)
# sha256:       7b96b9bfc763e8f225932d270dde2cf08b0243862c2ba96c60d6ae3fea92f9da
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045ef5a
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_2d3, field_2d5, field_31d, field_39e, field_62b; [ecx + n] field_4, field_8, field_c, field_2d9, field_305, field_31d, field_379, field_62b, field_62d, field_723; [edx + n] field_4, field_8, field_c, field_6b, field_2d5, field_2d7, field_2fd, field_31d, field_62b, field_62d, field_62f
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/action_family_f6_runtime.c:slide_common (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 98 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_6b, 0x6b  # offset +0x6b
.equ field_2d3, 0x2d3  # offset +0x2d3
.equ field_2d5, 0x2d5  # offset +0x2d5
.equ field_2d7, 0x2d7  # offset +0x2d7
.equ field_2d9, 0x2d9  # offset +0x2d9
.equ field_2fd, 0x2fd  # offset +0x2fd
.equ field_305, 0x305  # offset +0x305
.equ field_31d, 0x31d  # offset +0x31d
.equ field_379, 0x379  # offset +0x379
.equ field_39e, 0x39e  # offset +0x39e
.equ field_62b, 0x62b  # offset +0x62b
.equ field_62d, 0x62d  # offset +0x62d
.equ field_62f, 0x62f  # offset +0x62f
.equ field_723, 0x723  # offset +0x723

# --- external targets -----------------------------------------------

.org 0x0045ef5a - 0x401000
.globl FUN_0045ef5a
FUN_0045ef5a:
    # block 0x0045ef5a: entry, 49 instruction(s), ends with je to 0x0045f08c (forward)
    push ebp                                     # 0045ef5a
    {load} mov ebp, esp                          # 0045ef5b
    push ecx                                     # 0045ef5d
    mov dword ptr [ebp - local_4], ecx           # 0045ef5e
    mov eax, dword ptr [ebp - local_4]           # 0045ef61
    mov ecx, dword ptr [eax + field_31d]         # 0045ef64
    movsx edx, word ptr [ebp + arg_10]           # 0045ef6a
    imul edx, edx, 0xd0                          # 0045ef6e
    lea eax, [ecx + edx + field_723]             # 0045ef74
    movsx ecx, word ptr [ebp + arg_c]            # 0045ef7b
    shl ecx, 0x4                                 # 0045ef7f
    {load} add eax, ecx                          # 0045ef82
    mov edx, dword ptr [ebp - local_4]           # 0045ef84
    add edx, 0x2dd                               # 0045ef87
    mov ecx, dword ptr [eax]                     # 0045ef8d
    mov dword ptr [edx], ecx                     # 0045ef8f
    mov ecx, dword ptr [eax + field_4]           # 0045ef91
    mov dword ptr [edx + field_4], ecx           # 0045ef94
    mov ecx, dword ptr [eax + field_8]           # 0045ef97
    mov dword ptr [edx + field_8], ecx           # 0045ef9a
    mov eax, dword ptr [eax + field_c]           # 0045ef9d
    mov dword ptr [edx + field_c], eax           # 0045efa0
    mov ecx, dword ptr [ebp - local_4]           # 0045efa3
    mov edx, dword ptr [ecx + field_31d]         # 0045efa6
    movsx eax, word ptr [ebp + arg_10]           # 0045efac
    imul eax, eax, 0xd0                          # 0045efb0
    lea ecx, [edx + eax + field_6b]              # 0045efb6
    movsx edx, word ptr [ebp + arg_c]            # 0045efba
    shl edx, 0x4                                 # 0045efbe
    {load} add ecx, edx                          # 0045efc1
    mov eax, dword ptr [ebp - local_4]           # 0045efc3
    add eax, 0x2fd                               # 0045efc6
    mov edx, dword ptr [ecx]                     # 0045efcb
    mov dword ptr [eax], edx                     # 0045efcd
    mov edx, dword ptr [ecx + field_4]           # 0045efcf
    mov dword ptr [eax + field_4], edx           # 0045efd2
    mov edx, dword ptr [ecx + field_8]           # 0045efd5
    mov dword ptr [eax + field_8], edx           # 0045efd8
    mov ecx, dword ptr [ecx + field_c]           # 0045efdb
    mov dword ptr [eax + field_c], ecx           # 0045efde
    mov edx, dword ptr [ebp - local_4]           # 0045efe1
    mov word ptr [edx + field_2d7], 0x0          # 0045efe4
    mov eax, dword ptr [ebp - local_4]           # 0045efed
    mov cl, byte ptr [ebp + arg_8]               # 0045eff0
    mov byte ptr [eax + field_2d3], cl           # 0045eff3
    mov edx, dword ptr [ebp + arg_8]             # 0045eff9
    and edx, 0xff                                # 0045effc
    test edx, edx                                # 0045f002
    je.d32 L_0045f08c                            # 0045f004
    # block 0x0045f00a: entered by fall-through of je at 0x0045f004, 29 instruction(s), ends with forward jump to 0x0045f0a9
    mov eax, dword ptr [ebp - local_4]           # 0045f00a
    mov word ptr [eax + field_2d5], 0x0          # 0045f00d
    mov ecx, dword ptr [ebp - local_4]           # 0045f016
    mov edx, dword ptr [ecx + field_31d]         # 0045f019
    movsx eax, word ptr [edx + field_62d]        # 0045f01f
    mov ecx, dword ptr [ebp - local_4]           # 0045f026
    mov edx, dword ptr [ecx + field_31d]         # 0045f029
    movsx ecx, word ptr [edx + field_62b]        # 0045f02f
    sub ecx, 0x1                                 # 0045f036
    imul eax, ecx                                # 0045f039
    mov edx, dword ptr [ebp - local_4]           # 0045f03c
    mov ecx, dword ptr [edx + field_2fd]         # 0045f03f
    {load} sub ecx, eax                          # 0045f045
    mov edx, dword ptr [ebp - local_4]           # 0045f047
    mov dword ptr [edx + field_2fd], ecx         # 0045f04a
    mov eax, dword ptr [ebp - local_4]           # 0045f050
    mov ecx, dword ptr [eax + field_31d]         # 0045f053
    movsx edx, word ptr [ecx + field_62d]        # 0045f059
    mov eax, dword ptr [ebp - local_4]           # 0045f060
    mov ecx, dword ptr [eax + field_31d]         # 0045f063
    movsx eax, word ptr [ecx + field_62b]        # 0045f069
    sub eax, 0x1                                 # 0045f070
    imul edx, eax                                # 0045f073
    mov ecx, dword ptr [ebp - local_4]           # 0045f076
    mov eax, dword ptr [ecx + field_305]         # 0045f079
    {load} sub eax, edx                          # 0045f07f
    mov ecx, dword ptr [ebp - local_4]           # 0045f081
    mov dword ptr [ecx + field_305], eax         # 0045f084
    jmp.d8 L_0045f0a9                            # 0045f08a
L_0045f08c:
    # block 0x0045f08c: entered by je at 0x0045f004, 6 instruction(s), falls into the block at 0x0045f0a9
    mov edx, dword ptr [ebp - local_4]           # 0045f08c
    mov eax, dword ptr [edx + field_31d]         # 0045f08f
    movsx ecx, word ptr [eax + field_62b]        # 0045f095
    sub ecx, 0x1                                 # 0045f09c
    mov edx, dword ptr [ebp - local_4]           # 0045f09f
    mov word ptr [edx + field_2d5], cx           # 0045f0a2
L_0045f0a9:
    # block 0x0045f0a9: entered by jmp at 0x0045f08a, 14 instruction(s), calls KERNEL32.dll!GetTickCount, ends with ret 0x10
    mov eax, dword ptr [ebp - local_4]           # 0045f0a9
    mov dword ptr [eax + field_39e], 0x3         # 0045f0ac
    mov ecx, dword ptr [ebp - local_4]           # 0045f0b6
    mov edx, dword ptr [ebp + arg_14]            # 0045f0b9
    mov dword ptr [ecx + field_2d9], edx         # 0045f0bc
    call dword ptr [0x52a23c]                    # 0045f0c2
    mov ecx, dword ptr [ebp - local_4]           # 0045f0c8
    mov edx, dword ptr [ecx + field_31d]         # 0045f0cb
    add eax, dword ptr [edx + field_62f]         # 0045f0d1
    mov ecx, dword ptr [ebp - local_4]           # 0045f0d7
    mov dword ptr [ecx + field_379], eax         # 0045f0da
    {load} mov esp, ebp                          # 0045f0e0
    pop ebp                                      # 0045f0e2
    ret 0x10                                     # 0045f0e3

