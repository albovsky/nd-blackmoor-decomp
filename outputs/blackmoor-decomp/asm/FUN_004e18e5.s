# FUN_004e18e5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e18e5
# extent:       0x004e18e5-0x004e1a7e (409 code bytes)
# span:         0x004e18e5-0x004e1a7e (code 409, tables 0, padding 0)
# sha256:       abbdf3f09a10550f28f78b57b4007b2ceff868cc6295828023b46716f2c6df9e
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e18e5
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_757; [ecx + n] field_757; [edx + n] field_757
# callees:      calls FUN_004e2940, FUN_004e2956
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 97 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ field_757, 0x757  # offset +0x757

# --- external targets -----------------------------------------------
.set FUN_004e2940, .text + (0x004e2940 - 0x401000)
.set FUN_004e2956, .text + (0x004e2956 - 0x401000)

.org 0x004e18e5 - 0x401000
.globl FUN_004e18e5
FUN_004e18e5:
    # block 0x004e18e5: entry, 6 instruction(s), ends with forward jump to 0x004e1902
    push ebp                                     # 004e18e5
    {load} mov ebp, esp                          # 004e18e6
    sub esp, 0x10                                # 004e18e8
    mov dword ptr [ebp - local_10], ecx          # 004e18eb
    mov word ptr [ebp - local_8], 0x0            # 004e18ee
    jmp.d8 L_004e1902                            # 004e18f4
L_004e18f6:
    # block 0x004e18f6: entered by jmp at 0x004e1a73, 3 instruction(s), falls into the block at 0x004e1902
    mov ax, word ptr [ebp - local_8]             # 004e18f6
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e18fa
    mov word ptr [ebp - local_8], ax             # 004e18fe
L_004e1902:
    # block 0x004e1902: entered by jmp at 0x004e18f4, 3 instruction(s), ends with jge to 0x004e1a78 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e1902
    cmp ecx, 0x5                                 # 004e1906
    jge.d32 L_004e1a78                           # 004e1909
    # block 0x004e190f: entered by fall-through of jge at 0x004e1909, 4 instruction(s), ends with jne to 0x004e1942 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004e190f
    imul edx, edx, 0x1a4                         # 004e1913
    cmp dword ptr [edx + 0x5a1620], 0x1          # 004e1919
    jne.d8 L_004e1942                            # 004e1920
    # block 0x004e1922: entered by fall-through of jne at 0x004e1920, 7 instruction(s), calls FUN_004e2940, ends with forward jump to 0x004e1a73
    push 0x3                                     # 004e1922
    movsx eax, word ptr [ebp - local_8]          # 004e1924
    imul eax, eax, 0x18f                         # 004e1928
    mov ecx, dword ptr [ebp - local_10]          # 004e192e
    lea ecx, [ecx + eax + field_757]             # 004e1931
    call FUN_004e2940                            # 004e1938
    jmp.d32 L_004e1a73                           # 004e193d
L_004e1942:
    # block 0x004e1942: entered by jne at 0x004e1920, 7 instruction(s), calls FUN_004e2956, ends with jne to 0x004e1993 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004e1942
    imul edx, edx, 0x18f                         # 004e1946
    mov eax, dword ptr [ebp - local_10]          # 004e194c
    lea ecx, [eax + edx + field_757]             # 004e194f
    call FUN_004e2956                            # 004e1956
    cmp eax, 0x3                                 # 004e195b
    jne.d8 L_004e1993                            # 004e195e
    # block 0x004e1960: entered by fall-through of jne at 0x004e195e, 4 instruction(s), ends with jne to 0x004e1993 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e1960
    imul ecx, ecx, 0x1a4                         # 004e1964
    cmp dword ptr [ecx + 0x5a1620], 0x2          # 004e196a
    jne.d8 L_004e1993                            # 004e1971
    # block 0x004e1973: entered by fall-through of jne at 0x004e1971, 7 instruction(s), calls FUN_004e2940, ends with forward jump to 0x004e1a73
    push 0x0                                     # 004e1973
    movsx edx, word ptr [ebp - local_8]          # 004e1975
    imul edx, edx, 0x18f                         # 004e1979
    mov eax, dword ptr [ebp - local_10]          # 004e197f
    lea ecx, [eax + edx + field_757]             # 004e1982
    call FUN_004e2940                            # 004e1989
    jmp.d32 L_004e1a73                           # 004e198e
L_004e1993:
    # block 0x004e1993: entered by jne at 0x004e195e; jne at 0x004e1971, 4 instruction(s), ends with jne to 0x004e1a73 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e1993
    imul ecx, ecx, 0x1a4                         # 004e1997
    cmp dword ptr [ecx + 0x5a1620], 0x0          # 004e199d
    jne.d32 L_004e1a73                           # 004e19a4
    # block 0x004e19aa: entered by fall-through of jne at 0x004e19a4, 3 instruction(s), ends with forward jump to 0x004e19c5
    mov dword ptr [ebp - local_4], 0x0           # 004e19aa
    mov word ptr [ebp - local_c], 0x0            # 004e19b1
    jmp.d8 L_004e19c5                            # 004e19b7
L_004e19b9:
    # block 0x004e19b9: entered by jmp at 0x004e1a32, 3 instruction(s), falls into the block at 0x004e19c5
    mov dx, word ptr [ebp - local_c]             # 004e19b9
    add dx, 0x1                                  # 004e19bd
    mov word ptr [ebp - local_c], dx             # 004e19c1
L_004e19c5:
    # block 0x004e19c5: entered by jmp at 0x004e19b7, 3 instruction(s), ends with jge to 0x004e1a34 (forward)
    movsx eax, word ptr [ebp - local_c]          # 004e19c5
    cmp eax, 0x32                                # 004e19c9
    jge.d8 L_004e1a34                            # 004e19cc
    # block 0x004e19ce: entered by fall-through of jge at 0x004e19cc, 2 instruction(s), ends with jne to 0x004e1a34 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004e19ce
    jne.d8 L_004e1a34                            # 004e19d2
    # block 0x004e19d4: entered by fall-through of jne at 0x004e19d2, 7 instruction(s), ends with jl to 0x004e1a32 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004e19d4
    movsx edx, word ptr [ebp - local_8]          # 004e19d8
    imul edx, edx, 0x1a4                         # 004e19dc
    movsx eax, word ptr [ebp - local_c]          # 004e19e2
    movsx edx, word ptr [edx + 2*eax + 0x5a1624] # 004e19e6
    {load} cmp ecx, edx                          # 004e19ee
    jl.d8 L_004e1a32                             # 004e19f0
    # block 0x004e19f2: entered by fall-through of jl at 0x004e19f0, 7 instruction(s), ends with jg to 0x004e1a32 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004e19f2
    movsx ecx, word ptr [ebp - local_8]          # 004e19f6
    imul ecx, ecx, 0x1a4                         # 004e19fa
    movsx edx, word ptr [ebp - local_c]          # 004e1a00
    movsx ecx, word ptr [ecx + 2*edx + 0x5a1688] # 004e1a04
    {load} cmp eax, ecx                          # 004e1a0c
    jg.d8 L_004e1a32                             # 004e1a0e
    # block 0x004e1a10: entered by fall-through of jg at 0x004e1a0e, 7 instruction(s), calls FUN_004e2940, falls into the block at 0x004e1a32
    push 0x3                                     # 004e1a10
    movsx edx, word ptr [ebp - local_8]          # 004e1a12
    imul edx, edx, 0x18f                         # 004e1a16
    mov eax, dword ptr [ebp - local_10]          # 004e1a1c
    lea ecx, [eax + edx + field_757]             # 004e1a1f
    call FUN_004e2940                            # 004e1a26
    mov dword ptr [ebp - local_4], 0x1           # 004e1a2b
L_004e1a32:
    # block 0x004e1a32: entered by jl at 0x004e19f0; jg at 0x004e1a0e, 1 instruction(s), ends with backward jump to 0x004e19b9
    jmp.d8 L_004e19b9                            # 004e1a32
L_004e1a34:
    # block 0x004e1a34: entered by jge at 0x004e19cc; jne at 0x004e19d2, 2 instruction(s), ends with jne to 0x004e1a73 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004e1a34
    jne.d8 L_004e1a73                            # 004e1a38
    # block 0x004e1a3a: entered by fall-through of jne at 0x004e1a38, 7 instruction(s), calls FUN_004e2956, ends with jne to 0x004e1a73 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e1a3a
    imul ecx, ecx, 0x18f                         # 004e1a3e
    mov edx, dword ptr [ebp - local_10]          # 004e1a44
    lea ecx, [edx + ecx + field_757]             # 004e1a47
    call FUN_004e2956                            # 004e1a4e
    cmp eax, 0x3                                 # 004e1a53
    jne.d8 L_004e1a73                            # 004e1a56
    # block 0x004e1a58: entered by fall-through of jne at 0x004e1a56, 6 instruction(s), calls FUN_004e2940, falls into the block at 0x004e1a73
    push 0x0                                     # 004e1a58
    movsx eax, word ptr [ebp - local_8]          # 004e1a5a
    imul eax, eax, 0x18f                         # 004e1a5e
    mov ecx, dword ptr [ebp - local_10]          # 004e1a64
    lea ecx, [ecx + eax + field_757]             # 004e1a67
    call FUN_004e2940                            # 004e1a6e
L_004e1a73:
    # block 0x004e1a73: entered by jmp at 0x004e193d; jmp at 0x004e198e; jne at 0x004e19a4; jne at 0x004e1a38; more, 1 instruction(s), ends with backward jump to 0x004e18f6
    jmp.d32 L_004e18f6                           # 004e1a73
L_004e1a78:
    # block 0x004e1a78: entered by jge at 0x004e1909, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004e1a78
    pop ebp                                      # 004e1a7a
    ret 0x4                                      # 004e1a7b

