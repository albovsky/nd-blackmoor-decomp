# FUN_0051b522
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b522
# extent:       0x0051b522-0x0051b593 (113 code bytes)
# span:         0x0051b522-0x0051b593 (code 113, tables 0, padding 0)
# sha256:       64ddc8285e720b5c310d35deb67d380c121a6976fde4bd4ac89c3fcbd71f9a85
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b522
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [ebx + n] field_1c; [esi + n] field_4, field_8, field_c, field_24
# callees:      calls FUN_005210a2, USER32.dll!GetDlgCtrlID, USER32.dll!SendMessageA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_005210a2, .text + (0x005210a2 - 0x401000)

.org 0x0051b522 - 0x401000
.globl FUN_0051b522
FUN_0051b522:
    # block 0x0051b522: entry, 12 instruction(s), calls FUN_005210a2, ends with je to 0x0051b58a (forward)
    push ebp                                     # 0051b522
    {load} mov ebp, esp                          # 0051b523
    push ebx                                     # 0051b525
    push edi                                     # 0051b526
    push dword ptr [ebp + arg_c]                 # 0051b527
    {load} mov ebx, ecx                          # 0051b52a
    push dword ptr [ebp + arg_8]                 # 0051b52c
    push dword ptr [ebx + field_1c]              # 0051b52f
    call FUN_005210a2                            # 0051b532
    {load} mov edi, eax                          # 0051b537
    test edi, edi                                # 0051b539
    je.d8 L_0051b58a                             # 0051b53b
    # block 0x0051b53d: entered by fall-through of je at 0x0051b53b, 8 instruction(s), calls USER32.dll!GetDlgCtrlID, ends with je to 0x0051b584 (forward)
    push esi                                     # 0051b53d
    push edi                                     # 0051b53e
    call dword ptr [0x52a40c]                    # 0051b53f
    mov esi, dword ptr [ebp + arg_10]            # 0051b545
    movzx eax, ax                                # 0051b548
    test esi, esi                                # 0051b54b
    mov dword ptr [ebp + arg_c], eax             # 0051b54d
    je.d8 L_0051b584                             # 0051b550
    # block 0x0051b552: entered by fall-through of je at 0x0051b550, 2 instruction(s), ends with jb to 0x0051b584 (forward)
    cmp dword ptr [esi], 0x28                    # 0051b552
    jb.d8 L_0051b584                             # 0051b555
    # block 0x0051b557: entered by fall-through of jb at 0x0051b555, 12 instruction(s), calls USER32.dll!SendMessageA, ends with jne to 0x0051b584 (forward)
    mov eax, dword ptr [ebx + field_1c]          # 0051b557
    or dword ptr [esi + field_4], 0x1            # 0051b55a
    or dword ptr [esi + field_24], -0x1          # 0051b55e
    push 0x0                                     # 0051b562
    push 0x0                                     # 0051b564
    push 0x87                                    # 0051b566
    push edi                                     # 0051b56b
    mov dword ptr [esi + field_8], eax           # 0051b56c
    mov dword ptr [esi + field_c], edi           # 0051b56f
    call dword ptr [0x52a4c8]                    # 0051b572
    test ah, 0x20                                # 0051b578
    jne.d8 L_0051b584                            # 0051b57b
    # block 0x0051b57d: entered by fall-through of jne at 0x0051b57b, 1 instruction(s), falls into the block at 0x0051b584
    or dword ptr [esi + field_4], 0x80000002     # 0051b57d
L_0051b584:
    # block 0x0051b584: entered by je at 0x0051b550; jb at 0x0051b555; jne at 0x0051b57b, 3 instruction(s), ends with forward jump to 0x0051b58d
    mov eax, dword ptr [ebp + arg_c]             # 0051b584
    pop esi                                      # 0051b587
    jmp.d8 L_0051b58d                            # 0051b588
L_0051b58a:
    # block 0x0051b58a: entered by je at 0x0051b53b, 1 instruction(s), falls into the block at 0x0051b58d
    or eax, -0x1                                 # 0051b58a
L_0051b58d:
    # block 0x0051b58d: entered by jmp at 0x0051b588, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 0051b58d
    pop ebx                                      # 0051b58e
    pop ebp                                      # 0051b58f
    ret 0xc                                      # 0051b590

