# FUN_00473e8a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00473e8a
# extent:       0x00473e8a-0x00473f7d (243 code bytes)
# span:         0x00473e8a-0x00473f7d (code 243, tables 0, padding 0)
# sha256:       a453ea2cdf0bdc80460fbede0759f958d7c05bddf9028a5b057d130ed02da618
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00473e8a
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_4, field_8, field_419; [ecx + n] field_8, field_35f; [edx + n] field_c, field_2b, field_419, field_41d
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m473ac5_lifted (function ledger class candidate_port; also m473e8a_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 76 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_2b, 0x2b  # offset +0x2b
.equ field_35f, 0x35f  # offset +0x35f
.equ field_419, 0x419  # offset +0x419
.equ field_41d, 0x41d  # offset +0x41d

# --- external targets -----------------------------------------------

.org 0x00473e8a - 0x401000
.globl FUN_00473e8a
FUN_00473e8a:
    # block 0x00473e8a: entry, 7 instruction(s), ends with jne to 0x00473ea3 (forward)
    push ebp                                     # 00473e8a
    {load} mov ebp, esp                          # 00473e8b
    sub esp, 0x1c                                # 00473e8d
    mov dword ptr [ebp - local_1c], ecx          # 00473e90
    mov eax, dword ptr [ebp - local_1c]          # 00473e93
    cmp dword ptr [eax + field_8], 0x0           # 00473e96
    jne.d8 L_00473ea3                            # 00473e9a
    # block 0x00473e9c: entered by fall-through of jne at 0x00473e9a, 2 instruction(s), ends with forward jump to 0x00473f77
    {load} xor eax, eax                          # 00473e9c
    jmp.d32 L_00473f77                           # 00473e9e
L_00473ea3:
    # block 0x00473ea3: entered by jne at 0x00473e9a, 24 instruction(s), ends with forward jump to 0x00473f00
    mov ecx, dword ptr [ebp - local_1c]          # 00473ea3
    mov edx, dword ptr [ecx + field_8]           # 00473ea6
    mov eax, dword ptr [ebp - local_1c]          # 00473ea9
    mov ecx, dword ptr [edx]                     # 00473eac
    mov dword ptr [eax + field_419], ecx         # 00473eae
    mov edx, dword ptr [ebp + arg_8]             # 00473eb4
    mov eax, dword ptr [edx]                     # 00473eb7
    sub eax, dword ptr [0x583186]                # 00473eb9
    mov dword ptr [ebp - local_14], eax          # 00473ebf
    mov ecx, dword ptr [ebp + arg_8]             # 00473ec2
    mov edx, dword ptr [ecx + field_8]           # 00473ec5
    sub edx, dword ptr [0x583186]                # 00473ec8
    mov dword ptr [ebp - local_c], edx           # 00473ece
    mov eax, dword ptr [ebp + arg_8]             # 00473ed1
    mov ecx, dword ptr [eax + field_4]           # 00473ed4
    sub ecx, dword ptr [0x58318a]                # 00473ed7
    mov dword ptr [ebp - local_10], ecx          # 00473edd
    mov edx, dword ptr [ebp + arg_8]             # 00473ee0
    mov eax, dword ptr [edx + field_c]           # 00473ee3
    sub eax, dword ptr [0x58318a]                # 00473ee6
    mov dword ptr [ebp - local_8], eax           # 00473eec
    mov ecx, dword ptr [ebp - local_10]          # 00473eef
    mov dword ptr [ebp - local_4], ecx           # 00473ef2
    jmp.d8 L_00473f00                            # 00473ef5
L_00473ef7:
    # block 0x00473ef7: entered by jmp at 0x00473f73, 3 instruction(s), falls into the block at 0x00473f00
    mov edx, dword ptr [ebp - local_4]           # 00473ef7
    add edx, 0x1                                 # 00473efa
    mov dword ptr [ebp - local_4], edx           # 00473efd
L_00473f00:
    # block 0x00473f00: entered by jmp at 0x00473ef5, 3 instruction(s), ends with jg to 0x00473f75 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00473f00
    cmp eax, dword ptr [ebp - local_8]           # 00473f03
    jg.d8 L_00473f75                             # 00473f06
    # block 0x00473f08: entered by fall-through of jg at 0x00473f06, 3 instruction(s), ends with forward jump to 0x00473f19
    mov ecx, dword ptr [ebp - local_14]          # 00473f08
    mov dword ptr [ebp - local_18], ecx          # 00473f0b
    jmp.d8 L_00473f19                            # 00473f0e
L_00473f10:
    # block 0x00473f10: entered by jmp at 0x00473f71, 3 instruction(s), falls into the block at 0x00473f19
    mov edx, dword ptr [ebp - local_18]          # 00473f10
    add edx, 0x1                                 # 00473f13
    mov dword ptr [ebp - local_18], edx          # 00473f16
L_00473f19:
    # block 0x00473f19: entered by jmp at 0x00473f0e, 3 instruction(s), ends with jg to 0x00473f73 (forward)
    mov eax, dword ptr [ebp - local_18]          # 00473f19
    cmp eax, dword ptr [ebp - local_c]           # 00473f1c
    jg.d8 L_00473f73                             # 00473f1f
    # block 0x00473f21: entered by fall-through of jg at 0x00473f1f, 20 instruction(s), ends with jne to 0x00473f71 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 00473f21
    mov edx, dword ptr [ecx + field_8]           # 00473f24
    movsx eax, word ptr [edx + field_2b]         # 00473f27
    mov ecx, dword ptr [ebp - local_4]           # 00473f2b
    imul ecx, eax                                # 00473f2e
    mov edx, dword ptr [ebp - local_1c]          # 00473f31
    mov eax, dword ptr [edx + field_419]         # 00473f34
    lea ecx, [eax + 2*ecx]                       # 00473f3a
    mov edx, dword ptr [ebp - local_1c]          # 00473f3d
    mov eax, dword ptr [ebp - local_18]          # 00473f40
    mov cx, word ptr [ecx + 2*eax]               # 00473f43
    mov word ptr [edx + field_41d], cx           # 00473f47
    mov edx, dword ptr [ebp - local_1c]          # 00473f4e
    {load} xor eax, eax                          # 00473f51
    mov ax, word ptr [edx + field_41d]           # 00473f53
    mov ecx, dword ptr [ebp - local_1c]          # 00473f5a
    {load} xor edx, edx                          # 00473f5d
    mov dx, word ptr [ecx + field_35f]           # 00473f5f
    {load} cmp eax, edx                          # 00473f66
    jne.d8 L_00473f71                            # 00473f68
    # block 0x00473f6a: entered by fall-through of jne at 0x00473f68, 2 instruction(s), ends with forward jump to 0x00473f77
    mov eax, 0x1                                 # 00473f6a
    jmp.d8 L_00473f77                            # 00473f6f
L_00473f71:
    # block 0x00473f71: entered by jne at 0x00473f68, 1 instruction(s), ends with backward jump to 0x00473f10
    jmp.d8 L_00473f10                            # 00473f71
L_00473f73:
    # block 0x00473f73: entered by jg at 0x00473f1f, 1 instruction(s), ends with backward jump to 0x00473ef7
    jmp.d8 L_00473ef7                            # 00473f73
L_00473f75:
    # block 0x00473f75: entered by jg at 0x00473f06, 1 instruction(s), falls into the block at 0x00473f77
    {load} xor eax, eax                          # 00473f75
L_00473f77:
    # block 0x00473f77: entered by jmp at 0x00473e9e; jmp at 0x00473f6f, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00473f77
    pop ebp                                      # 00473f79
    ret 0x4                                      # 00473f7a

