# FUN_0041608b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041608b
# extent:       0x0041608b-0x00416122 (151 code bytes)
# span:         0x0041608b-0x00416122 (code 151, tables 0, padding 0)
# sha256:       9f4f9d94a710c1b656d8bdf49fda76fe1646802d31dfcf03b8fbd808a19d51b7
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041608b
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_172; [edx + n] field_172, field_1d6
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_172, 0x172  # offset +0x172
.equ field_1d6, 0x1d6  # offset +0x1d6

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0041608b - 0x401000
.globl FUN_0041608b
FUN_0041608b:
    # block 0x0041608b: entry, 6 instruction(s), ends with forward jump to 0x004160a8
    push ebp                                     # 0041608b
    {load} mov ebp, esp                          # 0041608c
    sub esp, 0xc                                 # 0041608e
    mov dword ptr [ebp - local_c], ecx           # 00416091
    mov word ptr [ebp - local_4], 0x0            # 00416094
    jmp.d8 L_004160a8                            # 0041609a
L_0041609c:
    # block 0x0041609c: entered by jmp at 0x0041611a, 3 instruction(s), falls into the block at 0x004160a8
    mov ax, word ptr [ebp - local_4]             # 0041609c
    .insn 0x66, 0x05, 0x0001{:u16}               # 004160a0
    mov word ptr [ebp - local_4], ax             # 004160a4
L_004160a8:
    # block 0x004160a8: entered by jmp at 0x0041609a, 3 instruction(s), ends with jge to 0x0041611c (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004160a8
    cmp ecx, 0x19                                # 004160ac
    jge.d8 L_0041611c                            # 004160af
    # block 0x004160b1: entered by fall-through of jge at 0x004160af, 4 instruction(s), ends with je to 0x0041611a (forward)
    movsx edx, word ptr [ebp - local_4]          # 004160b1
    mov eax, dword ptr [ebp + arg_8]             # 004160b5
    cmp dword ptr [eax + 4*edx + field_172], 0x0 # 004160b8
    je.d8 L_0041611a                             # 004160c0
    # block 0x004160c2: entered by fall-through of je at 0x004160c0, 7 instruction(s), ends with jne to 0x004160f7 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004160c2
    mov edx, dword ptr [ebp + arg_8]             # 004160c6
    {load} xor eax, eax                          # 004160c9
    mov ax, word ptr [edx + 2*ecx + field_1d6]   # 004160cb
    and eax, 0x8                                 # 004160d3
    test eax, eax                                # 004160d6
    jne.d8 L_004160f7                            # 004160d8
    # block 0x004160da: entered by fall-through of jne at 0x004160d8, 8 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004160f7
    movsx ecx, word ptr [ebp - local_4]          # 004160da
    mov edx, dword ptr [ebp + arg_8]             # 004160de
    mov eax, dword ptr [edx + 4*ecx + field_172] # 004160e1
    mov dword ptr [ebp - local_8], eax           # 004160e8
    mov ecx, dword ptr [ebp - local_8]           # 004160eb
    push ecx                                     # 004160ee
    call FUN_0051dc6c                            # 004160ef
    add esp, 0x4                                 # 004160f4
L_004160f7:
    # block 0x004160f7: entered by jne at 0x004160d8, 6 instruction(s), falls into the block at 0x0041611a
    movsx edx, word ptr [ebp - local_4]          # 004160f7
    mov eax, dword ptr [ebp + arg_8]             # 004160fb
    mov dword ptr [eax + 4*edx + field_172], 0x0 # 004160fe
    movsx ecx, word ptr [ebp - local_4]          # 00416109
    mov edx, dword ptr [ebp + arg_8]             # 0041610d
    mov word ptr [edx + 2*ecx + field_1d6], 0x0  # 00416110
L_0041611a:
    # block 0x0041611a: entered by je at 0x004160c0, 1 instruction(s), ends with backward jump to 0x0041609c
    jmp.d8 L_0041609c                            # 0041611a
L_0041611c:
    # block 0x0041611c: entered by jge at 0x004160af, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0041611c
    pop ebp                                      # 0041611e
    ret 0x4                                      # 0041611f

