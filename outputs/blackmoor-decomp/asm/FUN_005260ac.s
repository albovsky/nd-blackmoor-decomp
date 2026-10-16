# FUN_005260ac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005260ac
# extent:       0x005260ac-0x0052615c (176 code bytes)
# span:         0x005260ac-0x0052615c (code 176, tables 0, padding 0)
# sha256:       03ed9e00e11df0a588624d7069e28de0272280545bed8e6c48483cd4e48bb653
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005260ac
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_minus_8; [esi + n] field_4, field_8
# callees:      calls FUN_00525bd1, KERNEL32.dll!GetModuleHandleA, KERNEL32.dll!FindResourceA, KERNEL32.dll!LoadResource, FUN_0051fd7e, KERNEL32.dll!GlobalAlloc, KERNEL32.dll!lstrcpyA, FUN_0051e8f7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 63 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052615c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0051e8f7, .text + (0x0051e8f7 - 0x401000)
.set FUN_0051fd7e, .text + (0x0051fd7e - 0x401000)
.set FUN_00525bd1, .text + (0x00525bd1 - 0x401000)

.org 0x005260ac - 0x401000
.globl FUN_005260ac
FUN_005260ac:
    # block 0x005260ac: entry, 13 instruction(s), calls FUN_00525bd1, ends with jne to 0x0052613a (forward)
    push ebp                                     # 005260ac
    {load} mov ebp, esp                          # 005260ad
    push ebx                                     # 005260af
    push esi                                     # 005260b0
    push edi                                     # 005260b1
    push 0x52615c                                # 005260b2
    mov ecx, 0x63c9e8                            # 005260b7
    call FUN_00525bd1                            # 005260bc
    mov ebx, dword ptr [ebp + arg_c]             # 005260c1
    mov edi, dword ptr [ebp + arg_8]             # 005260c4
    {load} mov esi, eax                          # 005260c7
    cmp word ptr [esi + field_8], 0x0            # 005260c9
    jne.d8 L_0052613a                            # 005260ce
    # block 0x005260d0: entered by fall-through of jne at 0x005260ce, 5 instruction(s), calls KERNEL32.dll!GetModuleHandleA, ends with je to 0x00526118 (forward)
    push 0x52eb68                                # 005260d0
    call dword ptr [0x52a248]                    # 005260d5
    test eax, eax                                # 005260db
    mov dword ptr [ebp + arg_c], eax             # 005260dd
    je.d8 L_00526118                             # 005260e0
    # block 0x005260e2: entered by fall-through of je at 0x005260e0, 15 instruction(s), calls KERNEL32.dll!FindResourceA, KERNEL32.dll!LoadResource, ends with je to 0x00526118 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 005260e2
    push 0x5                                     # 005260e5
    neg ecx                                      # 005260e7
    {load} sbb ecx, ecx                          # 005260e9
    and ecx, 0xe                                 # 005260eb
    add ecx, 0x3ee                               # 005260ee
    movzx ecx, cx                                # 005260f4
    push ecx                                     # 005260f7
    push eax                                     # 005260f8
    call dword ptr [0x52a218]                    # 005260f9
    push eax                                     # 005260ff
    push dword ptr [ebp + arg_c]                 # 00526100
    call dword ptr [0x52a21c]                    # 00526103
    test eax, eax                                # 00526109
    je.d8 L_00526118                             # 0052610b
    # block 0x0052610d: entered by fall-through of je at 0x0052610b, 5 instruction(s), calls FUN_0051fd7e, falls into the block at 0x00526118
    push ebx                                     # 0052610d
    push edi                                     # 0052610e
    push eax                                     # 0052610f
    call FUN_0051fd7e                            # 00526110
    add esp, 0xc                                 # 00526115
L_00526118:
    # block 0x00526118: entered by je at 0x005260e0; je at 0x0052610b, 12 instruction(s), calls KERNEL32.dll!GlobalAlloc, KERNEL32.dll!lstrcpyA, falls into the block at 0x0052613a
    mov eax, dword ptr [edi]                     # 00526118
    mov eax, dword ptr [eax - field_minus_8]     # 0052611a
    inc eax                                      # 0052611d
    push eax                                     # 0052611e
    push 0x40                                    # 0052611f
    call dword ptr [0x52a1dc]                    # 00526121
    mov dword ptr [esi + field_4], eax           # 00526127
    push dword ptr [edi]                         # 0052612a
    push eax                                     # 0052612c
    call dword ptr [0x52a244]                    # 0052612d
    mov ax, word ptr [ebx]                       # 00526133
    mov word ptr [esi + field_8], ax             # 00526136
L_0052613a:
    # block 0x0052613a: entered by jne at 0x005260ce, 13 instruction(s), calls FUN_0051e8f7, ends with ret 0xc
    push dword ptr [esi + field_4]               # 0052613a
    {load} mov ecx, edi                          # 0052613d
    call FUN_0051e8f7                            # 0052613f
    mov si, word ptr [esi + field_8]             # 00526144
    {load} xor eax, eax                          # 00526148
    mov word ptr [ebx], si                       # 0052614a
    .insn 0x6681/7, esi, -1{:s16}                # 0052614d
    pop edi                                      # 00526152
    pop esi                                      # 00526153
    setne al                                     # 00526154
    pop ebx                                      # 00526157
    pop ebp                                      # 00526158
    ret 0xc                                      # 00526159

