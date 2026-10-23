# FUN_004b49d4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b49d4
# extent:       0x004b49d4-0x004b4a68 (148 code bytes)
# span:         0x004b49d4-0x004b4a68 (code 148, tables 0, padding 0)
# sha256:       2072113bd71bba6651aa75da3744c7a0d7361d0a6e9c8a205cf83a32c583d52f
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b49d4
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [ecx + n] field_27, field_728, field_77a; [edx + n] field_772
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_27, 0x27  # offset +0x27
.equ field_728, 0x728  # offset +0x728
.equ field_772, 0x772  # offset +0x772
.equ field_77a, 0x77a  # offset +0x77a

# --- external targets -----------------------------------------------

.org 0x004b49d4 - 0x401000
.globl FUN_004b49d4
FUN_004b49d4:
    # block 0x004b49d4: entry, 12 instruction(s), ends with jne to 0x004b4a01 (forward)
    push ebp                                     # 004b49d4
    {load} mov ebp, esp                          # 004b49d5
    sub esp, 0xc                                 # 004b49d7
    mov dword ptr [ebp - local_c], ecx           # 004b49da
    movsx eax, word ptr [ebp + arg_8]            # 004b49dd
    mov ecx, dword ptr [ebp - local_c]           # 004b49e1
    movsx edx, word ptr [ecx + field_728]        # 004b49e4
    imul edx, edx, 0x8d                          # 004b49eb
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 004b49f1
    movsx edx, word ptr [ecx + field_27]         # 004b49f7
    {load} cmp eax, edx                          # 004b49fb
    jne.d8 L_004b4a01                            # 004b49fd
    # block 0x004b49ff: entered by fall-through of jne at 0x004b49fd, 1 instruction(s), ends with forward jump to 0x004b4a62
    jmp.d8 L_004b4a62                            # 004b49ff
L_004b4a01:
    # block 0x004b4a01: entered by jne at 0x004b49fd, 2 instruction(s), ends with forward jump to 0x004b4a15
    mov word ptr [ebp - local_4], 0x0            # 004b4a01
    jmp.d8 L_004b4a15                            # 004b4a07
L_004b4a09:
    # block 0x004b4a09: entered by jmp at 0x004b4a46, 3 instruction(s), falls into the block at 0x004b4a15
    mov ax, word ptr [ebp - local_4]             # 004b4a09
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b4a0d
    mov word ptr [ebp - local_4], ax             # 004b4a11
L_004b4a15:
    # block 0x004b4a15: entered by jmp at 0x004b4a07, 4 instruction(s), ends with jge to 0x004b4a48 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004b4a15
    movsx edx, word ptr [0x591a22]               # 004b4a19
    {load} cmp ecx, edx                          # 004b4a20
    jge.d8 L_004b4a48                            # 004b4a22
    # block 0x004b4a24: entered by fall-through of jge at 0x004b4a22, 8 instruction(s), ends with jne to 0x004b4a46 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004b4a24
    imul eax, eax, 0xc                           # 004b4a28
    movsx ecx, word ptr [ebp - local_4]          # 004b4a2b
    mov dx, word ptr [eax + 2*ecx + 0x5919fe]    # 004b4a2f
    mov word ptr [ebp - local_8], dx             # 004b4a37
    movsx eax, word ptr [ebp - local_8]          # 004b4a3b
    cmp eax, -0x1                                # 004b4a3f
    jne.d8 L_004b4a46                            # 004b4a42
    # block 0x004b4a44: entered by fall-through of jne at 0x004b4a42, 1 instruction(s), ends with forward jump to 0x004b4a62
    jmp.d8 L_004b4a62                            # 004b4a44
L_004b4a46:
    # block 0x004b4a46: entered by jne at 0x004b4a42, 1 instruction(s), ends with backward jump to 0x004b4a09
    jmp.d8 L_004b4a09                            # 004b4a46
L_004b4a48:
    # block 0x004b4a48: entered by jge at 0x004b4a22, 4 instruction(s), falls into the block at 0x004b4a62
    mov ecx, dword ptr [ebp - local_c]           # 004b4a48
    mov dword ptr [ecx + field_77a], 0x1         # 004b4a4b
    mov edx, dword ptr [ebp - local_c]           # 004b4a55
    mov dword ptr [edx + field_772], 0x1         # 004b4a58
L_004b4a62:
    # block 0x004b4a62: entered by jmp at 0x004b49ff; jmp at 0x004b4a44, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004b4a62
    pop ebp                                      # 004b4a64
    ret 0x4                                      # 004b4a65

