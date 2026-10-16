# FUN_004a4c15
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a4c15
# extent:       0x004a4c15-0x004a4d55 (320 code bytes)
# span:         0x004a4c15-0x004a4d55 (code 320, tables 0, padding 0)
# sha256:       15f4046d2321225ccf1f501e834652e534ea23e1e8350c3ae59e591a2dc0bc5f
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a4c15
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_1e, field_48d, field_48f; [edx + n] field_48d, field_48f
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 84 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_48d, 0x48d  # offset +0x48d
.equ field_48f, 0x48f  # offset +0x48f

# --- external targets -----------------------------------------------

.org 0x004a4c15 - 0x401000
.globl FUN_004a4c15
FUN_004a4c15:
    # block 0x004a4c15: entry, 13 instruction(s), ends with jne to 0x004a4c55 (forward)
    push ebp                                     # 004a4c15
    {load} mov ebp, esp                          # 004a4c16
    sub esp, 0x18                                # 004a4c18
    mov dword ptr [ebp - local_18], ecx          # 004a4c1b
    mov eax, dword ptr [ebp - local_18]          # 004a4c1e
    movsx ecx, word ptr [eax + field_1e]         # 004a4c21
    imul ecx, ecx, 0x8d                          # 004a4c25
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004a4c2b
    mov dword ptr [ebp - local_10], edx          # 004a4c31
    mov eax, dword ptr [ebp - local_10]          # 004a4c34
    movsx ecx, word ptr [eax + field_48d]        # 004a4c37
    test ecx, ecx                                # 004a4c3e
    jne.d8 L_004a4c55                            # 004a4c40
    # block 0x004a4c42: entered by fall-through of jne at 0x004a4c40, 4 instruction(s), ends with je to 0x004a4c55 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004a4c42
    movsx eax, word ptr [ebp + arg_c]            # 004a4c46
    {load} cmp edx, eax                          # 004a4c4a
    je.d8 L_004a4c55                             # 004a4c4c
    # block 0x004a4c4e: entered by fall-through of je at 0x004a4c4c, 2 instruction(s), ends with forward jump to 0x004a4d4f
    {load} xor eax, eax                          # 004a4c4e
    jmp.d32 L_004a4d4f                           # 004a4c50
L_004a4c55:
    # block 0x004a4c55: entered by jne at 0x004a4c40; je at 0x004a4c4c, 4 instruction(s), ends with jne to 0x004a4c6b (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a4c55
    movsx edx, word ptr [ebp + arg_c]            # 004a4c59
    {load} cmp ecx, edx                          # 004a4c5d
    jne.d8 L_004a4c6b                            # 004a4c5f
    # block 0x004a4c61: entered by fall-through of jne at 0x004a4c5f, 2 instruction(s), ends with forward jump to 0x004a4d4f
    mov eax, 0x1                                 # 004a4c61
    jmp.d32 L_004a4d4f                           # 004a4c66
L_004a4c6b:
    # block 0x004a4c6b: entered by jne at 0x004a4c5f, 4 instruction(s), ends with forward jump to 0x004a4c8d
    mov dword ptr [ebp - local_4], 0x0           # 004a4c6b
    mov dword ptr [ebp - local_8], 0x0           # 004a4c72
    mov word ptr [ebp - local_14], 0x0           # 004a4c79
    jmp.d8 L_004a4c8d                            # 004a4c7f
L_004a4c81:
    # block 0x004a4c81: entered by jmp at 0x004a4d48, 3 instruction(s), falls into the block at 0x004a4c8d
    mov ax, word ptr [ebp - local_14]            # 004a4c81
    .insn 0x66, 0x05, 0x0001{:u16}               # 004a4c85
    mov word ptr [ebp - local_14], ax            # 004a4c89
L_004a4c8d:
    # block 0x004a4c8d: entered by jmp at 0x004a4c7f, 5 instruction(s), ends with jge to 0x004a4d4d (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004a4c8d
    mov edx, dword ptr [ebp - local_10]          # 004a4c91
    movsx eax, word ptr [edx + field_48d]        # 004a4c94
    {load} cmp ecx, eax                          # 004a4c9b
    jge.d32 L_004a4d4d                           # 004a4c9d
    # block 0x004a4ca3: entered by fall-through of jge at 0x004a4c9d, 2 instruction(s), ends with forward jump to 0x004a4cb7
    mov word ptr [ebp - local_c], 0x0            # 004a4ca3
    jmp.d8 L_004a4cb7                            # 004a4ca9
L_004a4cab:
    # block 0x004a4cab: entered by jmp at 0x004a4d25, 3 instruction(s), falls into the block at 0x004a4cb7
    mov cx, word ptr [ebp - local_c]             # 004a4cab
    add cx, 0x1                                  # 004a4caf
    mov word ptr [ebp - local_c], cx             # 004a4cb3
L_004a4cb7:
    # block 0x004a4cb7: entered by jmp at 0x004a4ca9, 8 instruction(s), ends with je to 0x004a4d27 (forward)
    movsx edx, word ptr [ebp - local_14]         # 004a4cb7
    imul edx, edx, 0xa                           # 004a4cbb
    mov eax, dword ptr [ebp - local_10]          # 004a4cbe
    lea ecx, [eax + edx + field_48f]             # 004a4cc1
    movsx edx, word ptr [ebp - local_c]          # 004a4cc8
    movsx eax, word ptr [ecx + 2*edx]            # 004a4ccc
    cmp eax, -0x1                                # 004a4cd0
    je.d8 L_004a4d27                             # 004a4cd3
    # block 0x004a4cd5: entered by fall-through of je at 0x004a4cd3, 9 instruction(s), ends with jne to 0x004a4cfd (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a4cd5
    movsx edx, word ptr [ebp - local_14]         # 004a4cd9
    imul edx, edx, 0xa                           # 004a4cdd
    mov eax, dword ptr [ebp - local_10]          # 004a4ce0
    lea edx, [eax + edx + field_48f]             # 004a4ce3
    movsx eax, word ptr [ebp - local_c]          # 004a4cea
    movsx edx, word ptr [edx + 2*eax]            # 004a4cee
    {load} cmp ecx, edx                          # 004a4cf2
    jne.d8 L_004a4cfd                            # 004a4cf4
    # block 0x004a4cf6: entered by fall-through of jne at 0x004a4cf4, 1 instruction(s), falls into the block at 0x004a4cfd
    mov dword ptr [ebp - local_4], 0x1           # 004a4cf6
L_004a4cfd:
    # block 0x004a4cfd: entered by jne at 0x004a4cf4, 9 instruction(s), ends with jne to 0x004a4d25 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004a4cfd
    movsx ecx, word ptr [ebp - local_14]         # 004a4d01
    imul ecx, ecx, 0xa                           # 004a4d05
    mov edx, dword ptr [ebp - local_10]          # 004a4d08
    lea ecx, [edx + ecx + field_48f]             # 004a4d0b
    movsx edx, word ptr [ebp - local_c]          # 004a4d12
    movsx ecx, word ptr [ecx + 2*edx]            # 004a4d16
    {load} cmp eax, ecx                          # 004a4d1a
    jne.d8 L_004a4d25                            # 004a4d1c
    # block 0x004a4d1e: entered by fall-through of jne at 0x004a4d1c, 1 instruction(s), falls into the block at 0x004a4d25
    mov dword ptr [ebp - local_8], 0x1           # 004a4d1e
L_004a4d25:
    # block 0x004a4d25: entered by jne at 0x004a4d1c, 1 instruction(s), ends with backward jump to 0x004a4cab
    jmp.d8 L_004a4cab                            # 004a4d25
L_004a4d27:
    # block 0x004a4d27: entered by je at 0x004a4cd3, 2 instruction(s), ends with je to 0x004a4d3a (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004a4d27
    je.d8 L_004a4d3a                             # 004a4d2b
    # block 0x004a4d2d: entered by fall-through of je at 0x004a4d2b, 2 instruction(s), ends with je to 0x004a4d3a (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004a4d2d
    je.d8 L_004a4d3a                             # 004a4d31
    # block 0x004a4d33: entered by fall-through of je at 0x004a4d31, 2 instruction(s), ends with forward jump to 0x004a4d4f
    mov eax, 0x1                                 # 004a4d33
    jmp.d8 L_004a4d4f                            # 004a4d38
L_004a4d3a:
    # block 0x004a4d3a: entered by je at 0x004a4d2b; je at 0x004a4d31, 3 instruction(s), ends with backward jump to 0x004a4c81
    mov dword ptr [ebp - local_4], 0x0           # 004a4d3a
    mov dword ptr [ebp - local_8], 0x0           # 004a4d41
    jmp.d32 L_004a4c81                           # 004a4d48
L_004a4d4d:
    # block 0x004a4d4d: entered by jge at 0x004a4c9d, 1 instruction(s), falls into the block at 0x004a4d4f
    {load} xor eax, eax                          # 004a4d4d
L_004a4d4f:
    # block 0x004a4d4f: entered by jmp at 0x004a4c50; jmp at 0x004a4c66; jmp at 0x004a4d38, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004a4d4f
    pop ebp                                      # 004a4d51
    ret 0x8                                      # 004a4d52

