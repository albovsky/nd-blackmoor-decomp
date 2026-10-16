# FUN_0050ebca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ebca
# extent:       0x0050ebca-0x0050ed02 (312 code bytes)
# span:         0x0050ebca-0x0050ed10 (code 312, tables 0, padding 14)
# sha256:       34d6064f2e4fbfb671aca82d5fe88aea64edf55f84d9023e010b6d3630b0a2c1
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ebca
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [ebx + n] field_minus_4
# callees:      calls FUN_0050ea90, FUN_0050e936, FUN_00512c18, FUN_00514f63, FUN_0051576e, FUN_005152b9, FUN_0050fa90, FUN_00514f8e, KERNEL32.dll!HeapAlloc, FUN_00512c79, KERNEL32.dll!HeapReAlloc, FUN_00515a64
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 125 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050ed10
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_00514f63, .text + (0x00514f63 - 0x401000)
.set FUN_00514f8e, .text + (0x00514f8e - 0x401000)
.set FUN_005152b9, .text + (0x005152b9 - 0x401000)
.set FUN_0051576e, .text + (0x0051576e - 0x401000)
.set FUN_00515a64, .text + (0x00515a64 - 0x401000)

.org 0x0050ebca - 0x401000
.globl FUN_0050ebca
FUN_0050ebca:
    # block 0x0050ebca: entry, 8 instruction(s), ends with jne to 0x0050ebe5 (forward)
    push ebp                                     # 0050ebca
    {load} mov ebp, esp                          # 0050ebcb
    push ebx                                     # 0050ebcd
    mov ebx, dword ptr [ebp + arg_8]             # 0050ebce
    push esi                                     # 0050ebd1
    push edi                                     # 0050ebd2
    test ebx, ebx                                # 0050ebd3
    jne.d8 L_0050ebe5                            # 0050ebd5
    # block 0x0050ebd7: entered by fall-through of jne at 0x0050ebd5, 4 instruction(s), calls FUN_0050ea90, ends with forward jump to 0x0050ecfd
    push dword ptr [ebp + arg_c]                 # 0050ebd7
    call FUN_0050ea90                            # 0050ebda
    pop ecx                                      # 0050ebdf
    jmp.d32 L_0050ecfd                           # 0050ebe0
L_0050ebe5:
    # block 0x0050ebe5: entered by jne at 0x0050ebd5, 3 instruction(s), ends with jne to 0x0050ebfa (forward)
    mov esi, dword ptr [ebp + arg_c]             # 0050ebe5
    test esi, esi                                # 0050ebe8
    jne.d8 L_0050ebfa                            # 0050ebea
    # block 0x0050ebec: entered by fall-through of jne at 0x0050ebea, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x0050ebf3
    push ebx                                     # 0050ebec
    call FUN_0050e936                            # 0050ebed
    pop ecx                                      # 0050ebf2
L_0050ebf3:
    # block 0x0050ebf3: entered by jmp at 0x0050ecf6, 2 instruction(s), ends with forward jump to 0x0050ecfd
    {load} xor eax, eax                          # 0050ebf3
    jmp.d32 L_0050ecfd                           # 0050ebf5
L_0050ebfa:
    # block 0x0050ebfa: entered by jne at 0x0050ebea; jne at 0x0050ecf0, 3 instruction(s), ends with ja to 0x0050ecde (forward)
    {load} xor edi, edi                          # 0050ebfa
    cmp esi, -0x20                               # 0050ebfc
    ja.d32 L_0050ecde                            # 0050ebff
    # block 0x0050ec05: entered by fall-through of ja at 0x0050ebff, 9 instruction(s), calls FUN_00512c18, FUN_00514f63, ends with je to 0x0050ecb3 (forward)
    push 0x9                                     # 0050ec05
    call FUN_00512c18                            # 0050ec07
    push ebx                                     # 0050ec0c
    call FUN_00514f63                            # 0050ec0d
    pop ecx                                      # 0050ec12
    mov dword ptr [ebp + arg_c], eax             # 0050ec13
    test eax, eax                                # 0050ec16
    pop ecx                                      # 0050ec18
    je.d32 L_0050ecb3                            # 0050ec19
    # block 0x0050ec1f: entered by fall-through of je at 0x0050ec19, 2 instruction(s), ends with ja to 0x0050ec69 (forward)
    cmp esi, dword ptr [0x568b78]                # 0050ec1f
    ja.d8 L_0050ec69                             # 0050ec25
    # block 0x0050ec27: entered by fall-through of ja at 0x0050ec25, 7 instruction(s), calls FUN_0051576e, ends with je to 0x0050ec3a (forward)
    push esi                                     # 0050ec27
    push ebx                                     # 0050ec28
    push eax                                     # 0050ec29
    call FUN_0051576e                            # 0050ec2a
    add esp, 0xc                                 # 0050ec2f
    test eax, eax                                # 0050ec32
    je.d8 L_0050ec3a                             # 0050ec34
    # block 0x0050ec36: entered by fall-through of je at 0x0050ec34, 2 instruction(s), ends with forward jump to 0x0050ec65
    {load} mov edi, ebx                          # 0050ec36
    jmp.d8 L_0050ec65                            # 0050ec38
L_0050ec3a:
    # block 0x0050ec3a: entered by je at 0x0050ec34, 6 instruction(s), calls FUN_005152b9, ends with je to 0x0050ec69 (forward)
    push esi                                     # 0050ec3a
    call FUN_005152b9                            # 0050ec3b
    {load} mov edi, eax                          # 0050ec40
    pop ecx                                      # 0050ec42
    test edi, edi                                # 0050ec43
    je.d8 L_0050ec69                             # 0050ec45
    # block 0x0050ec47: entered by fall-through of je at 0x0050ec45, 4 instruction(s), ends with jb to 0x0050ec51 (forward)
    mov eax, dword ptr [ebx - field_minus_4]     # 0050ec47
    dec eax                                      # 0050ec4a
    {load} cmp eax, esi                          # 0050ec4b
    jb.d8 L_0050ec51                             # 0050ec4d
    # block 0x0050ec4f: entered by fall-through of jb at 0x0050ec4d, 1 instruction(s), falls into the block at 0x0050ec51
    {load} mov eax, esi                          # 0050ec4f
L_0050ec51:
    # block 0x0050ec51: entered by jb at 0x0050ec4d, 8 instruction(s), calls FUN_0050fa90, FUN_00514f8e, falls into the block at 0x0050ec65
    push eax                                     # 0050ec51
    push ebx                                     # 0050ec52
    push edi                                     # 0050ec53
    call FUN_0050fa90                            # 0050ec54
    push ebx                                     # 0050ec59
    push dword ptr [ebp + arg_c]                 # 0050ec5a
    call FUN_00514f8e                            # 0050ec5d
    add esp, 0x14                                # 0050ec62
L_0050ec65:
    # block 0x0050ec65: entered by jmp at 0x0050ec38, 2 instruction(s), ends with jne to 0x0050eca9 (forward)
    test edi, edi                                # 0050ec65
    jne.d8 L_0050eca9                            # 0050ec67
L_0050ec69:
    # block 0x0050ec69: entered by ja at 0x0050ec25; je at 0x0050ec45; fall-through of jne at 0x0050ec67, 2 instruction(s), ends with jne to 0x0050ec70 (forward)
    test esi, esi                                # 0050ec69
    jne.d8 L_0050ec70                            # 0050ec6b
    # block 0x0050ec6d: entered by fall-through of jne at 0x0050ec6b, 2 instruction(s), falls into the block at 0x0050ec70
    push 0x1                                     # 0050ec6d
    pop esi                                      # 0050ec6f
L_0050ec70:
    # block 0x0050ec70: entered by jne at 0x0050ec6b, 9 instruction(s), calls KERNEL32.dll!HeapAlloc, ends with je to 0x0050eca9 (forward)
    add esi, 0xf                                 # 0050ec70
    and esi, -0x10                               # 0050ec73
    push esi                                     # 0050ec76
    push 0x0                                     # 0050ec77
    push dword ptr [0x63cdd8]                    # 0050ec79
    call dword ptr [0x52a150]                    # 0050ec7f
    {load} mov edi, eax                          # 0050ec85
    test edi, edi                                # 0050ec87
    je.d8 L_0050eca9                             # 0050ec89
    # block 0x0050ec8b: entered by fall-through of je at 0x0050ec89, 4 instruction(s), ends with jb to 0x0050ec95 (forward)
    mov eax, dword ptr [ebx - field_minus_4]     # 0050ec8b
    dec eax                                      # 0050ec8e
    {load} cmp eax, esi                          # 0050ec8f
    jb.d8 L_0050ec95                             # 0050ec91
    # block 0x0050ec93: entered by fall-through of jb at 0x0050ec91, 1 instruction(s), falls into the block at 0x0050ec95
    {load} mov eax, esi                          # 0050ec93
L_0050ec95:
    # block 0x0050ec95: entered by jb at 0x0050ec91, 8 instruction(s), calls FUN_0050fa90, FUN_00514f8e, falls into the block at 0x0050eca9
    push eax                                     # 0050ec95
    push ebx                                     # 0050ec96
    push edi                                     # 0050ec97
    call FUN_0050fa90                            # 0050ec98
    push ebx                                     # 0050ec9d
    push dword ptr [ebp + arg_c]                 # 0050ec9e
    call FUN_00514f8e                            # 0050eca1
    add esp, 0x14                                # 0050eca6
L_0050eca9:
    # block 0x0050eca9: entered by jne at 0x0050ec67; je at 0x0050ec89, 4 instruction(s), calls FUN_00512c79, ends with forward jump to 0x0050ecda
    push 0x9                                     # 0050eca9
    call FUN_00512c79                            # 0050ecab
    pop ecx                                      # 0050ecb0
    jmp.d8 L_0050ecda                            # 0050ecb1
L_0050ecb3:
    # block 0x0050ecb3: entered by je at 0x0050ec19, 5 instruction(s), calls FUN_00512c79, ends with jne to 0x0050ecc2 (forward)
    push 0x9                                     # 0050ecb3
    call FUN_00512c79                            # 0050ecb5
    test esi, esi                                # 0050ecba
    pop ecx                                      # 0050ecbc
    jne.d8 L_0050ecc2                            # 0050ecbd
    # block 0x0050ecbf: entered by fall-through of jne at 0x0050ecbd, 2 instruction(s), falls into the block at 0x0050ecc2
    push 0x1                                     # 0050ecbf
    pop esi                                      # 0050ecc1
L_0050ecc2:
    # block 0x0050ecc2: entered by jne at 0x0050ecbd, 8 instruction(s), calls KERNEL32.dll!HeapReAlloc, falls into the block at 0x0050ecda
    add esi, 0xf                                 # 0050ecc2
    and esi, -0x10                               # 0050ecc5
    push esi                                     # 0050ecc8
    push ebx                                     # 0050ecc9
    push 0x0                                     # 0050ecca
    push dword ptr [0x63cdd8]                    # 0050eccc
    call dword ptr [0x52a154]                    # 0050ecd2
    {load} mov edi, eax                          # 0050ecd8
L_0050ecda:
    # block 0x0050ecda: entered by jmp at 0x0050ecb1, 2 instruction(s), ends with jne to 0x0050ecfb (forward)
    test edi, edi                                # 0050ecda
    jne.d8 L_0050ecfb                            # 0050ecdc
L_0050ecde:
    # block 0x0050ecde: entered by ja at 0x0050ebff; fall-through of jne at 0x0050ecdc, 2 instruction(s), ends with je to 0x0050ecfb (forward)
    cmp dword ptr [0x63cc4c], 0x0                # 0050ecde
    je.d8 L_0050ecfb                             # 0050ece5
    # block 0x0050ece7: entered by fall-through of je at 0x0050ece5, 5 instruction(s), calls FUN_00515a64, ends with jne to 0x0050ebfa (backward)
    push esi                                     # 0050ece7
    call FUN_00515a64                            # 0050ece8
    test eax, eax                                # 0050eced
    pop ecx                                      # 0050ecef
    jne.d32 L_0050ebfa                           # 0050ecf0
    # block 0x0050ecf6: entered by fall-through of jne at 0x0050ecf0, 1 instruction(s), ends with backward jump to 0x0050ebf3
    jmp.d32 L_0050ebf3                           # 0050ecf6
L_0050ecfb:
    # block 0x0050ecfb: entered by jne at 0x0050ecdc; je at 0x0050ece5, 1 instruction(s), falls into the block at 0x0050ecfd
    {load} mov eax, edi                          # 0050ecfb
L_0050ecfd:
    # block 0x0050ecfd: entered by jmp at 0x0050ebe0; jmp at 0x0050ebf5, 5 instruction(s), ends with ret
    pop edi                                      # 0050ecfd
    pop esi                                      # 0050ecfe
    pop ebx                                      # 0050ecff
    pop ebp                                      # 0050ed00
    ret                                          # 0050ed01

# --- data items (not part of the function) -------------------------
.org 0x0050ed02 - 0x401000
PAD_0050ed02:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

