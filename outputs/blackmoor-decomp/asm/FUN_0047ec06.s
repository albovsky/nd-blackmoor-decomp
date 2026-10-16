# FUN_0047ec06
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047ec06
# extent:       0x0047ec06-0x0047ed96 (400 code bytes)
# span:         0x0047ec06-0x0047ed96 (code 400, tables 0, padding 0)
# sha256:       4b171230db3dbb0c9c1e7d6cc6b0d518e1506f9d3319e6684061285263116129
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047ec06
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1e, field_a9, field_7b6, field_1350; [ecx + n] field_7b6, field_7ba, field_7be, field_1350, field_13a2; [edx + n] field_7ba, field_7c2, field_7d7, field_1350; [esi + n] field_7b6, field_7ba
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 113 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_a9, 0xa9  # offset +0xa9
.equ field_7b6, 0x7b6  # offset +0x7b6
.equ field_7ba, 0x7ba  # offset +0x7ba
.equ field_7be, 0x7be  # offset +0x7be
.equ field_7c2, 0x7c2  # offset +0x7c2
.equ field_7d7, 0x7d7  # offset +0x7d7
.equ field_1350, 0x1350  # offset +0x1350
.equ field_13a2, 0x13a2  # offset +0x13a2

# --- external targets -----------------------------------------------

.org 0x0047ec06 - 0x401000
.globl FUN_0047ec06
FUN_0047ec06:
    # block 0x0047ec06: entry, 43 instruction(s), ends with forward jump to 0x0047ecac
    push ebp                                     # 0047ec06
    {load} mov ebp, esp                          # 0047ec07
    sub esp, 0x14                                # 0047ec09
    push ebx                                     # 0047ec0c
    push esi                                     # 0047ec0d
    push edi                                     # 0047ec0e
    mov dword ptr [ebp - local_14], ecx          # 0047ec0f
    mov eax, dword ptr [ebp - local_14]          # 0047ec12
    movsx ecx, word ptr [eax + field_1e]         # 0047ec15
    imul ecx, ecx, 0x8d                          # 0047ec19
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0047ec1f
    mov dword ptr [ebp - local_8], edx           # 0047ec25
    mov eax, dword ptr [ebp - local_14]          # 0047ec28
    movsx ecx, word ptr [eax + field_1350]       # 0047ec2b
    imul ecx, ecx, 0x25                          # 0047ec32
    mov edx, dword ptr [ebp - local_14]          # 0047ec35
    movsx eax, word ptr [edx + field_1350]       # 0047ec38
    imul eax, eax, 0x25                          # 0047ec3f
    mov edx, dword ptr [ebp - local_14]          # 0047ec42
    mov esi, dword ptr [ebp - local_14]          # 0047ec45
    mov ecx, dword ptr [edx + ecx + field_7c2]   # 0047ec48
    sub ecx, dword ptr [esi + eax + field_7ba]   # 0047ec4f
    {load} mov eax, ecx                          # 0047ec56
    cdq                                          # 0047ec58
    {load} sub eax, edx                          # 0047ec59
    sar eax                                      # 0047ec5b
    mov word ptr [ebp - local_4], ax             # 0047ec5d
    mov edx, dword ptr [ebp - local_14]          # 0047ec61
    movsx eax, word ptr [edx + field_1350]       # 0047ec64
    imul eax, eax, 0x25                          # 0047ec6b
    mov ecx, dword ptr [ebp - local_14]          # 0047ec6e
    movsx edx, word ptr [ecx + field_1350]       # 0047ec71
    imul edx, edx, 0x25                          # 0047ec78
    mov ecx, dword ptr [ebp - local_14]          # 0047ec7b
    mov esi, dword ptr [ebp - local_14]          # 0047ec7e
    mov eax, dword ptr [ecx + eax + field_7be]   # 0047ec81
    sub eax, dword ptr [esi + edx + field_7b6]   # 0047ec88
    cdq                                          # 0047ec8f
    {load} sub eax, edx                          # 0047ec90
    sar eax                                      # 0047ec92
    mov word ptr [ebp - local_10], ax            # 0047ec94
    mov word ptr [ebp - local_c], 0x0            # 0047ec98
    jmp.d8 L_0047ecac                            # 0047ec9e
L_0047eca0:
    # block 0x0047eca0: entered by jmp at 0x0047ed86, 3 instruction(s), falls into the block at 0x0047ecac
    mov dx, word ptr [ebp - local_c]             # 0047eca0
    add dx, 0x1                                  # 0047eca4
    mov word ptr [ebp - local_c], dx             # 0047eca8
L_0047ecac:
    # block 0x0047ecac: entered by jmp at 0x0047ec9e, 5 instruction(s), ends with jge to 0x0047ed8b (forward)
    movsx eax, word ptr [ebp - local_c]          # 0047ecac
    mov ecx, dword ptr [ebp - local_14]          # 0047ecb0
    movsx edx, word ptr [ecx + field_13a2]       # 0047ecb3
    {load} cmp eax, edx                          # 0047ecba
    jge.d32 L_0047ed8b                           # 0047ecbc
    # block 0x0047ecc2: entered by fall-through of jge at 0x0047ecbc, 16 instruction(s), ends with je to 0x0047ed86 (forward)
    mov ecx, 0x4                                 # 0047ecc2
    movsx eax, word ptr [ebp - local_c]          # 0047ecc7
    imul eax, eax, 0x25                          # 0047eccb
    mov edx, dword ptr [ebp - local_14]          # 0047ecce
    {load} xor ebx, ebx                          # 0047ecd1
    mov bl, byte ptr [edx + eax + field_7d7]     # 0047ecd3
    imul ebx, ebx, 0x53                          # 0047ecda
    mov eax, dword ptr [ebp - local_8]           # 0047ecdd
    lea edi, [eax + ebx + field_a9]              # 0047ece0
    movsx edx, word ptr [ebp - local_c]          # 0047ece7
    imul edx, edx, 0x25                          # 0047eceb
    mov eax, dword ptr [ebp - local_14]          # 0047ecee
    lea esi, [eax + edx + field_7b6]             # 0047ecf1
    {load} xor edx, edx                          # 0047ecf8
    rep cmpsd dword ptr [esi], dword ptr es:[edi] # 0047ecfa
    je.d32 L_0047ed86                            # 0047ecfc
    # block 0x0047ed02: entered by fall-through of je at 0x0047ecfc, 10 instruction(s), ends with jle to 0x0047ed86 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0047ed02
    movsx ecx, word ptr [ebp - local_4]          # 0047ed06
    {load} add eax, ecx                          # 0047ed0a
    movsx edx, word ptr [ebp - local_c]          # 0047ed0c
    imul edx, edx, 0x25                          # 0047ed10
    mov ecx, dword ptr [ebp - local_14]          # 0047ed13
    mov edx, dword ptr [ecx + edx + field_7ba]   # 0047ed16
    sub edx, 0x4                                 # 0047ed1d
    {load} cmp eax, edx                          # 0047ed20
    jle.d8 L_0047ed86                            # 0047ed22
    # block 0x0047ed24: entered by fall-through of jle at 0x0047ed22, 6 instruction(s), ends with jge to 0x0047ed86 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0047ed24
    movsx ecx, word ptr [ebp - local_c]          # 0047ed28
    imul ecx, ecx, 0x25                          # 0047ed2c
    mov edx, dword ptr [ebp - local_14]          # 0047ed2f
    cmp eax, dword ptr [edx + ecx + field_7ba]   # 0047ed32
    jge.d8 L_0047ed86                            # 0047ed39
    # block 0x0047ed3b: entered by fall-through of jge at 0x0047ed39, 10 instruction(s), ends with jle to 0x0047ed86 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0047ed3b
    movsx ecx, word ptr [ebp - local_10]         # 0047ed3f
    {load} sub eax, ecx                          # 0047ed43
    movsx edx, word ptr [ebp - local_c]          # 0047ed45
    imul edx, edx, 0x25                          # 0047ed49
    mov ecx, dword ptr [ebp - local_14]          # 0047ed4c
    mov edx, dword ptr [ecx + edx + field_7b6]   # 0047ed4f
    sub edx, 0x14                                # 0047ed56
    {load} cmp eax, edx                          # 0047ed59
    jle.d8 L_0047ed86                            # 0047ed5b
    # block 0x0047ed5d: entered by fall-through of jle at 0x0047ed5b, 10 instruction(s), ends with jge to 0x0047ed86 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0047ed5d
    movsx ecx, word ptr [ebp - local_10]         # 0047ed61
    {load} add eax, ecx                          # 0047ed65
    movsx edx, word ptr [ebp - local_c]          # 0047ed67
    imul edx, edx, 0x25                          # 0047ed6b
    mov ecx, dword ptr [ebp - local_14]          # 0047ed6e
    mov edx, dword ptr [ecx + edx + field_7be]   # 0047ed71
    add edx, 0x14                                # 0047ed78
    {load} cmp eax, edx                          # 0047ed7b
    jge.d8 L_0047ed86                            # 0047ed7d
    # block 0x0047ed7f: entered by fall-through of jge at 0x0047ed7d, 2 instruction(s), ends with forward jump to 0x0047ed8d
    mov eax, 0x1                                 # 0047ed7f
    jmp.d8 L_0047ed8d                            # 0047ed84
L_0047ed86:
    # block 0x0047ed86: entered by je at 0x0047ecfc; jle at 0x0047ed22; jge at 0x0047ed39; jle at 0x0047ed5b; more, 1 instruction(s), ends with backward jump to 0x0047eca0
    jmp.d32 L_0047eca0                           # 0047ed86
L_0047ed8b:
    # block 0x0047ed8b: entered by jge at 0x0047ecbc, 1 instruction(s), falls into the block at 0x0047ed8d
    {load} xor eax, eax                          # 0047ed8b
L_0047ed8d:
    # block 0x0047ed8d: entered by jmp at 0x0047ed84, 6 instruction(s), ends with ret 0x8
    pop edi                                      # 0047ed8d
    pop esi                                      # 0047ed8e
    pop ebx                                      # 0047ed8f
    {load} mov esp, ebp                          # 0047ed90
    pop ebp                                      # 0047ed92
    ret 0x8                                      # 0047ed93

