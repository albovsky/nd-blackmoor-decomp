# FUN_004c500c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c500c
# extent:       0x004c500c-0x004c51a5 (409 code bytes)
# span:         0x004c500c-0x004c51a5 (code 409, tables 0, padding 0)
# sha256:       f9a5743087958326617a6d3d5ce94de097680a56296b8adf2183cc7b3e9ce730
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_fast_blt_no_trans
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4c500c.c.txt, not original source) refers to the data labelled s_ERROR___DFBltNoTrans_____Data_Er_00554780, s_FastBltNoTrans_____err_ret____lx_005547d0
# name-note:    Validates rectangle size when debugging, then does a FastBlt without transparency with retry on lost surface; failure formats a FastBltNoTrans error.
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_108, local_10c
# fields:       [eax + n] field_8, field_c; [ecx + n] field_8, field_c, field_1c; [edx + n] field_4, field_8
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_0052139c, FUN_004c97b4, FUN_004c4dc3, FUN_004c88c7, FUN_0042639d; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 129 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_108, 0x108  # offset -0x108
.equ local_10c, 0x10c  # offset -0x10c
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c4dc3, .text + (0x004c4dc3 - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c500c - 0x401000
.globl FUN_004c500c
FUN_004c500c:
    # block 0x004c500c: entry, 7 instruction(s), ends with je to 0x004c50d9 (forward)
    push ebp                                     # 004c500c
    {load} mov ebp, esp                          # 004c500d
    sub esp, 0x10c                               # 004c500f
    mov dword ptr [ebp - local_10c], ecx         # 004c5015
    movsx eax, word ptr [0x63a4cd]               # 004c501b
    test eax, eax                                # 004c5022
    je.d32 L_004c50d9                            # 004c5024
    # block 0x004c502a: entered by fall-through of je at 0x004c5024, 14 instruction(s), ends with je to 0x004c5077 (forward)
    mov ecx, dword ptr [ebp + arg_18]            # 004c502a
    mov edx, dword ptr [ebp + arg_18]            # 004c502d
    mov eax, dword ptr [ecx + field_8]           # 004c5030
    sub eax, dword ptr [edx]                     # 004c5033
    add eax, 0x1                                 # 004c5035
    mov dword ptr [ebp - local_c], eax           # 004c5038
    mov ecx, dword ptr [ebp + arg_18]            # 004c503b
    mov edx, dword ptr [ebp + arg_18]            # 004c503e
    mov eax, dword ptr [ecx + field_c]           # 004c5041
    sub eax, dword ptr [edx + field_4]           # 004c5044
    add eax, 0x1                                 # 004c5047
    mov dword ptr [ebp - local_8], eax           # 004c504a
    cmp dword ptr [ebp - local_c], 0x0           # 004c504d
    je.d8 L_004c5077                             # 004c5051
    # block 0x004c5053: entered by fall-through of je at 0x004c5051, 2 instruction(s), ends with jg to 0x004c5077 (forward)
    cmp dword ptr [ebp - local_c], 0x281         # 004c5053
    jg.d8 L_004c5077                             # 004c505a
    # block 0x004c505c: entered by fall-through of jg at 0x004c505a, 2 instruction(s), ends with je to 0x004c5077 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004c505c
    je.d8 L_004c5077                             # 004c5060
    # block 0x004c5062: entered by fall-through of je at 0x004c5060, 2 instruction(s), ends with jg to 0x004c5077 (forward)
    cmp dword ptr [ebp - local_8], 0x1e1         # 004c5062
    jg.d8 L_004c5077                             # 004c5069
    # block 0x004c506b: entered by fall-through of jg at 0x004c5069, 2 instruction(s), ends with je to 0x004c5077 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c506b
    je.d8 L_004c5077                             # 004c506f
    # block 0x004c5071: entered by fall-through of je at 0x004c506f, 2 instruction(s), ends with jne to 0x004c50d9 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c5071
    jne.d8 L_004c50d9                            # 004c5075
L_004c5077:
    # block 0x004c5077: entered by je at 0x004c5051; jg at 0x004c505a; je at 0x004c5060; jg at 0x004c5069; more, 31 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c519f
    mov ecx, dword ptr [ebp + arg_18]            # 004c5077
    mov edx, dword ptr [ecx + field_c]           # 004c507a
    push edx                                     # 004c507d
    mov eax, dword ptr [ebp + arg_18]            # 004c507e
    mov ecx, dword ptr [eax + field_8]           # 004c5081
    push ecx                                     # 004c5084
    mov edx, dword ptr [ebp + arg_18]            # 004c5085
    mov eax, dword ptr [edx + field_4]           # 004c5088
    push eax                                     # 004c508b
    mov ecx, dword ptr [ebp + arg_18]            # 004c508c
    mov edx, dword ptr [ecx]                     # 004c508f
    push edx                                     # 004c5091
    mov eax, dword ptr [ebp + arg_1c]            # 004c5092
    push eax                                     # 004c5095
    push 0x554780                                # 004c5096
    lea ecx, [ebp - local_108]                   # 004c509b
    push ecx                                     # 004c50a1
    call FUN_0050ca3e                            # 004c50a2
    add esp, 0x1c                                # 004c50a7
    lea edx, [ebp - local_108]                   # 004c50aa
    push edx                                     # 004c50b0
    call FUN_0044a2b7                            # 004c50b1
    add esp, 0x4                                 # 004c50b6
    push 0x0                                     # 004c50b9
    push 0x0                                     # 004c50bb
    lea eax, [ebp - local_108]                   # 004c50bd
    push eax                                     # 004c50c3
    call FUN_0052139c                            # 004c50c4
    mov ecx, dword ptr [ebp - local_10c]         # 004c50c9
    call FUN_004c97b4                            # 004c50cf
    jmp.d32 L_004c519f                           # 004c50d4
L_004c50d9:
    # block 0x004c50d9: entered by je at 0x004c5024; jne at 0x004c5075; jmp at 0x004c519a, 3 instruction(s), ends with je to 0x004c519f (forward)
    mov ecx, 0x1                                 # 004c50d9
    test ecx, ecx                                # 004c50de
    je.d32 L_004c519f                            # 004c50e0
    # block 0x004c50e6: entered by fall-through of je at 0x004c50e0, 17 instruction(s), calls indirect dword ptr [ecx + 0x1c], ends with jne to 0x004c5112 (forward)
    push 0x0                                     # 004c50e6
    mov edx, dword ptr [ebp + arg_18]            # 004c50e8
    push edx                                     # 004c50eb
    mov eax, dword ptr [ebp + arg_8]             # 004c50ec
    push eax                                     # 004c50ef
    mov ecx, dword ptr [ebp + arg_14]            # 004c50f0
    push ecx                                     # 004c50f3
    mov edx, dword ptr [ebp + arg_10]            # 004c50f4
    push edx                                     # 004c50f7
    mov eax, dword ptr [ebp + arg_c]             # 004c50f8
    mov ecx, dword ptr [eax]                     # 004c50fb
    mov edx, dword ptr [ebp + arg_c]             # 004c50fd
    push edx                                     # 004c5100
    call dword ptr [ecx + field_1c]              # 004c5101
    mov dword ptr [ebp - local_4], eax           # 004c5104
    cmp dword ptr [ebp - local_4], 0x0           # 004c5107
    jne.d8 L_004c5112                            # 004c510b
    # block 0x004c510d: entered by fall-through of jne at 0x004c510b, 1 instruction(s), ends with forward jump to 0x004c519f
    jmp.d32 L_004c519f                           # 004c510d
L_004c5112:
    # block 0x004c5112: entered by jne at 0x004c510b, 2 instruction(s), ends with jne to 0x004c5128 (forward)
    cmp dword ptr [ebp - local_4], 0x887601c2    # 004c5112
    jne.d8 L_004c5128                            # 004c5119
    # block 0x004c511b: entered by fall-through of jne at 0x004c5119, 3 instruction(s), calls FUN_004c4dc3, ends with forward jump to 0x004c519a
    mov ecx, dword ptr [ebp - local_10c]         # 004c511b
    call FUN_004c4dc3                            # 004c5121
    jmp.d8 L_004c519a                            # 004c5126
L_004c5128:
    # block 0x004c5128: entered by jne at 0x004c5119, 2 instruction(s), ends with je to 0x004c519a (forward)
    cmp dword ptr [ebp - local_4], 0x8876021c    # 004c5128
    je.d8 L_004c519a                             # 004c512f
    # block 0x004c5131: entered by fall-through of je at 0x004c512f, 35 instruction(s), calls FUN_0050ca3e, FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c519f
    mov eax, dword ptr [ebp + arg_14]            # 004c5131
    push eax                                     # 004c5134
    mov ecx, dword ptr [ebp + arg_10]            # 004c5135
    push ecx                                     # 004c5138
    mov edx, dword ptr [ebp + arg_18]            # 004c5139
    mov eax, dword ptr [edx + field_8]           # 004c513c
    push eax                                     # 004c513f
    mov ecx, dword ptr [ebp + arg_18]            # 004c5140
    mov edx, dword ptr [ecx]                     # 004c5143
    push edx                                     # 004c5145
    mov eax, dword ptr [ebp + arg_18]            # 004c5146
    mov ecx, dword ptr [eax + field_c]           # 004c5149
    push ecx                                     # 004c514c
    mov edx, dword ptr [ebp + arg_18]            # 004c514d
    mov eax, dword ptr [edx + field_4]           # 004c5150
    push eax                                     # 004c5153
    mov ecx, dword ptr [ebp + arg_1c]            # 004c5154
    push ecx                                     # 004c5157
    mov edx, dword ptr [ebp - local_4]           # 004c5158
    push edx                                     # 004c515b
    push 0x5547d0                                # 004c515c
    push 0x63888b                                # 004c5161
    call FUN_0050ca3e                            # 004c5166
    add esp, 0x28                                # 004c516b
    mov eax, dword ptr [ebp - local_4]           # 004c516e
    push eax                                     # 004c5171
    mov ecx, dword ptr [ebp - local_10c]         # 004c5172
    call FUN_004c88c7                            # 004c5178
    push eax                                     # 004c517d
    push 0x63888b                                # 004c517e
    mov ecx, 0x583979                            # 004c5183
    call FUN_0042639d                            # 004c5188
    mov ecx, dword ptr [ebp - local_10c]         # 004c518d
    call FUN_004c97b4                            # 004c5193
    jmp.d8 L_004c519f                            # 004c5198
L_004c519a:
    # block 0x004c519a: entered by jmp at 0x004c5126; je at 0x004c512f, 1 instruction(s), ends with backward jump to 0x004c50d9
    jmp.d32 L_004c50d9                           # 004c519a
L_004c519f:
    # block 0x004c519f: entered by jmp at 0x004c50d4; je at 0x004c50e0; jmp at 0x004c510d; jmp at 0x004c5198, 3 instruction(s), ends with ret 0x18
    {load} mov esp, ebp                          # 004c519f
    pop ebp                                      # 004c51a1
    ret 0x18                                     # 004c51a2

