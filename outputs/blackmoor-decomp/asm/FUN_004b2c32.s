# FUN_004b2c32
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b2c32
# extent:       0x004b2c32-0x004b2ce6 (180 code bytes)
# span:         0x004b2c32-0x004b2ce6 (code 180, tables 0, padding 0)
# sha256:       9d4f5100c96bf494cac42c9380795134432cd88158480cba4281ac5931a02508
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b2c32
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_18, field_1e, field_25, field_27, field_29, field_151d; [ecx + n] field_27, field_29, field_43, field_151d; [edx + n] field_18, field_25, field_43
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 51 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_18, 0x18  # offset +0x18
.equ field_1e, 0x1e  # offset +0x1e
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_43, 0x43  # offset +0x43
.equ field_151d, 0x151d  # offset +0x151d

# --- external targets -----------------------------------------------

.org 0x004b2c32 - 0x401000
.globl FUN_004b2c32
FUN_004b2c32:
    # block 0x004b2c32: entry, 13 instruction(s), ends with je to 0x004b2c99 (forward)
    push ebp                                     # 004b2c32
    {load} mov ebp, esp                          # 004b2c33
    sub esp, 0x8                                 # 004b2c35
    mov dword ptr [ebp - local_8], ecx           # 004b2c38
    mov eax, dword ptr [ebp - local_8]           # 004b2c3b
    movsx ecx, word ptr [eax + field_1e]         # 004b2c3e
    imul ecx, ecx, 0x8d                          # 004b2c42
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b2c48
    mov dword ptr [ebp - local_4], edx           # 004b2c4e
    mov eax, dword ptr [ebp - local_4]           # 004b2c51
    movsx ecx, word ptr [eax + field_29]         # 004b2c54
    cmp ecx, 0x14                                # 004b2c58
    je.d8 L_004b2c99                             # 004b2c5b
    # block 0x004b2c5d: entered by fall-through of je at 0x004b2c5b, 11 instruction(s), ends with jne to 0x004b2c99 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b2c5d
    movsx eax, word ptr [edx + field_25]         # 004b2c60
    imul eax, eax, 0x1e4                         # 004b2c64
    mov ecx, dword ptr [ebp - local_8]           # 004b2c6a
    lea edx, [ecx + eax + field_43]              # 004b2c6d
    mov eax, dword ptr [ebp - local_4]           # 004b2c71
    movsx ecx, word ptr [eax + field_27]         # 004b2c74
    imul ecx, ecx, 0x2c                          # 004b2c78
    movsx edx, word ptr [edx + ecx + field_18]   # 004b2c7b
    cmp edx, 0x6                                 # 004b2c80
    jne.d8 L_004b2c99                            # 004b2c83
    # block 0x004b2c85: entered by fall-through of jne at 0x004b2c83, 4 instruction(s), ends with forward jump to 0x004b2ce2
    mov eax, dword ptr [ebp - local_8]           # 004b2c85
    mov dword ptr [eax + field_151d], 0x1        # 004b2c88
    mov eax, 0x1                                 # 004b2c92
    jmp.d8 L_004b2ce2                            # 004b2c97
L_004b2c99:
    # block 0x004b2c99: entered by je at 0x004b2c5b; jne at 0x004b2c83, 4 instruction(s), ends with jne to 0x004b2ce0 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b2c99
    movsx edx, word ptr [ecx + field_29]         # 004b2c9c
    cmp edx, 0x14                                # 004b2ca0
    jne.d8 L_004b2ce0                            # 004b2ca3
    # block 0x004b2ca5: entered by fall-through of jne at 0x004b2ca3, 11 instruction(s), ends with jne to 0x004b2ce0 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b2ca5
    movsx ecx, word ptr [eax + field_25]         # 004b2ca8
    imul ecx, ecx, 0x1e4                         # 004b2cac
    mov edx, dword ptr [ebp - local_8]           # 004b2cb2
    lea eax, [edx + ecx + field_43]              # 004b2cb5
    mov ecx, dword ptr [ebp - local_4]           # 004b2cb9
    movsx edx, word ptr [ecx + field_27]         # 004b2cbc
    imul edx, edx, 0x2c                          # 004b2cc0
    movsx eax, word ptr [eax + edx + field_18]   # 004b2cc3
    test eax, eax                                # 004b2cc8
    jne.d8 L_004b2ce0                            # 004b2cca
    # block 0x004b2ccc: entered by fall-through of jne at 0x004b2cca, 4 instruction(s), ends with forward jump to 0x004b2ce2
    mov ecx, dword ptr [ebp - local_8]           # 004b2ccc
    mov dword ptr [ecx + field_151d], 0x1        # 004b2ccf
    mov eax, 0x1                                 # 004b2cd9
    jmp.d8 L_004b2ce2                            # 004b2cde
L_004b2ce0:
    # block 0x004b2ce0: entered by jne at 0x004b2ca3; jne at 0x004b2cca, 1 instruction(s), falls into the block at 0x004b2ce2
    {load} xor eax, eax                          # 004b2ce0
L_004b2ce2:
    # block 0x004b2ce2: entered by jmp at 0x004b2c97; jmp at 0x004b2cde, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b2ce2
    pop ebp                                      # 004b2ce4
    ret                                          # 004b2ce5

