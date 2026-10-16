# FUN_0050aa30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050aa30
# extent:       0x0050aa30-0x0050aaef (191 code bytes)
# span:         0x0050aa30-0x0050aaf0 (code 191, tables 0, padding 1)
# sha256:       5b261047b4bc3064dc11b80dd9242f5ca9461f300adc3c0dd6a9c1cc36286c55
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050a9c0 (+0x70)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050aa30
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [edx + n] field_18; [esi + n] field_4, field_8, field_c, field_10, field_14, field_18; [esp + n] stk_4, stk_14, stk_18, stk_1c
# callees:      calls FUN_0050ea90, FUN_0050be60, FUN_0050a9a0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 81 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050aaf0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050a9a0, .text + (0x0050a9a0 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x0050aa30 - 0x401000
.globl FUN_0050aa30
FUN_0050aa30:
    # block 0x0050aa30: entry, 41 instruction(s), calls FUN_0050ea90, FUN_0050be60, ends with jl to 0x0050aadf (forward)
    mov eax, dword ptr [esp + stk_4]             # 0050aa30
    push ebx                                     # 0050aa34
    push ebp                                     # 0050aa35
    push esi                                     # 0050aa36
    mov ecx, dword ptr [eax + field_1c]          # 0050aa37
    push edi                                     # 0050aa3a
    push 0x60                                    # 0050aa3b
    mov dword ptr [esp + stk_18], ecx            # 0050aa3d
    call FUN_0050ea90                            # 0050aa41
    mov edi, dword ptr [esp + stk_1c]            # 0050aa46
    push 0x8                                     # 0050aa4a
    push edi                                     # 0050aa4c
    {load} mov esi, eax                          # 0050aa4d
    call FUN_0050be60                            # 0050aa4f
    push 0x10                                    # 0050aa54
    push edi                                     # 0050aa56
    mov dword ptr [esi], eax                     # 0050aa57
    call FUN_0050be60                            # 0050aa59
    push 0x10                                    # 0050aa5e
    push edi                                     # 0050aa60
    mov dword ptr [esi + field_4], eax           # 0050aa61
    call FUN_0050be60                            # 0050aa64
    push 0x6                                     # 0050aa69
    push edi                                     # 0050aa6b
    mov dword ptr [esi + field_8], eax           # 0050aa6c
    call FUN_0050be60                            # 0050aa6f
    push 0x8                                     # 0050aa74
    push edi                                     # 0050aa76
    mov dword ptr [esi + field_c], eax           # 0050aa77
    call FUN_0050be60                            # 0050aa7a
    push 0x4                                     # 0050aa7f
    push edi                                     # 0050aa81
    mov dword ptr [esi + field_10], eax          # 0050aa82
    call FUN_0050be60                            # 0050aa85
    mov edx, dword ptr [esi]                     # 0050aa8a
    add esp, 0x34                                # 0050aa8c
    mov ecx, 0x1                                 # 0050aa8f
    inc eax                                      # 0050aa94
    {load} cmp edx, ecx                          # 0050aa95
    mov dword ptr [esi + field_14], eax          # 0050aa97
    jl.d8 L_0050aadf                             # 0050aa9a
    # block 0x0050aa9c: entered by fall-through of jl at 0x0050aa9a, 2 instruction(s), ends with jl to 0x0050aadf (forward)
    cmp dword ptr [esi + field_4], ecx           # 0050aa9c
    jl.d8 L_0050aadf                             # 0050aa9f
    # block 0x0050aaa1: entered by fall-through of jl at 0x0050aa9f, 2 instruction(s), ends with jl to 0x0050aadf (forward)
    cmp dword ptr [esi + field_8], ecx           # 0050aaa1
    jl.d8 L_0050aadf                             # 0050aaa4
    # block 0x0050aaa6: entered by fall-through of jl at 0x0050aaa4, 2 instruction(s), ends with jl to 0x0050aadf (forward)
    {load} cmp eax, ecx                          # 0050aaa6
    jl.d8 L_0050aadf                             # 0050aaa8
    # block 0x0050aaaa: entered by fall-through of jl at 0x0050aaa8, 3 instruction(s), ends with jle to 0x0050aad8 (forward)
    {load} xor ebp, ebp                          # 0050aaaa
    test eax, eax                                # 0050aaac
    jle.d8 L_0050aad8                            # 0050aaae
    # block 0x0050aab0: entered by fall-through of jle at 0x0050aaae, 1 instruction(s), falls into the block at 0x0050aab3
    lea ebx, [esi + field_18]                    # 0050aab0
L_0050aab3:
    # block 0x0050aab3: entered by jl at 0x0050aad6, 7 instruction(s), calls FUN_0050be60, ends with jl to 0x0050aadf (forward)
    push 0x8                                     # 0050aab3
    push edi                                     # 0050aab5
    call FUN_0050be60                            # 0050aab6
    add esp, 0x8                                 # 0050aabb
    mov dword ptr [ebx], eax                     # 0050aabe
    test eax, eax                                # 0050aac0
    jl.d8 L_0050aadf                             # 0050aac2
    # block 0x0050aac4: entered by fall-through of jl at 0x0050aac2, 3 instruction(s), ends with jge to 0x0050aadf (forward)
    mov edx, dword ptr [esp + stk_14]            # 0050aac4
    cmp eax, dword ptr [edx + field_18]          # 0050aac8
    jge.d8 L_0050aadf                            # 0050aacb
    # block 0x0050aacd: entered by fall-through of jge at 0x0050aacb, 5 instruction(s), ends with jl to 0x0050aab3 (backward)
    mov eax, dword ptr [esi + field_14]          # 0050aacd
    inc ebp                                      # 0050aad0
    add ebx, 0x4                                 # 0050aad1
    {load} cmp ebp, eax                          # 0050aad4
    jl.d8 L_0050aab3                             # 0050aad6
L_0050aad8:
    # block 0x0050aad8: entered by jle at 0x0050aaae; fall-through of jl at 0x0050aad6, 6 instruction(s), ends with ret
    {load} mov eax, esi                          # 0050aad8
    pop edi                                      # 0050aada
    pop esi                                      # 0050aadb
    pop ebp                                      # 0050aadc
    pop ebx                                      # 0050aadd
    ret                                          # 0050aade
L_0050aadf:
    # block 0x0050aadf: entered by jl at 0x0050aa9a; jl at 0x0050aa9f; jl at 0x0050aaa4; jl at 0x0050aaa8; more, 9 instruction(s), calls FUN_0050a9a0, ends with ret
    push esi                                     # 0050aadf
    call FUN_0050a9a0                            # 0050aae0
    add esp, 0x4                                 # 0050aae5
    {load} xor eax, eax                          # 0050aae8
    pop edi                                      # 0050aaea
    pop esi                                      # 0050aaeb
    pop ebp                                      # 0050aaec
    pop ebx                                      # 0050aaed
    ret                                          # 0050aaee

# --- data items (not part of the function) -------------------------
.org 0x0050aaef - 0x401000
PAD_0050aaef:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

