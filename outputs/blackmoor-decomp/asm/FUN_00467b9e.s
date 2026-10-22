# FUN_00467b9e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00467b9e
# extent:       0x00467b9e-0x00467c0e (112 code bytes)
# span:         0x00467b9e-0x00467c0e (code 112, tables 0, padding 0)
# sha256:       123d56a68ab2eaaa0246d68a25ebe17544292916fbf73665d359fbae30e80afb
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00467b9e
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1ba, field_1c0, field_1c4, field_240
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_240, 0x240  # offset +0x240

# --- external targets -----------------------------------------------

.org 0x00467b9e - 0x401000
.globl FUN_00467b9e
FUN_00467b9e:
    # block 0x00467b9e: entry, 8 instruction(s), ends with jne to 0x00467bb9 (forward)
    push ebp                                     # 00467b9e
    {load} mov ebp, esp                          # 00467b9f
    sub esp, 0x8                                 # 00467ba1
    mov dword ptr [ebp - local_8], ecx           # 00467ba4
    mov eax, dword ptr [ebp - local_8]           # 00467ba7
    mov ecx, dword ptr [ebp + arg_8]             # 00467baa
    cmp ecx, dword ptr [eax + field_1ba]         # 00467bad
    jne.d8 L_00467bb9                            # 00467bb3
    # block 0x00467bb5: entered by fall-through of jne at 0x00467bb3, 2 instruction(s), ends with forward jump to 0x00467c08
    {load} xor eax, eax                          # 00467bb5
    jmp.d8 L_00467c08                            # 00467bb7
L_00467bb9:
    # block 0x00467bb9: entered by jne at 0x00467bb3, 2 instruction(s), ends with forward jump to 0x00467bcb
    mov dword ptr [ebp - local_4], 0x0           # 00467bb9
    jmp.d8 L_00467bcb                            # 00467bc0
L_00467bc2:
    # block 0x00467bc2: entered by jmp at 0x00467c04, 3 instruction(s), falls into the block at 0x00467bcb
    mov edx, dword ptr [ebp - local_4]           # 00467bc2
    add edx, 0x1                                 # 00467bc5
    mov dword ptr [ebp - local_4], edx           # 00467bc8
L_00467bcb:
    # block 0x00467bcb: entered by jmp at 0x00467bc0, 4 instruction(s), ends with jge to 0x00467c06 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00467bcb
    mov ecx, dword ptr [ebp - local_4]           # 00467bce
    cmp ecx, dword ptr [eax + field_240]         # 00467bd1
    jge.d8 L_00467c06                            # 00467bd7
    # block 0x00467bd9: entered by fall-through of jge at 0x00467bd7, 5 instruction(s), ends with je to 0x00467bfd (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467bd9
    mov eax, dword ptr [ebp - local_8]           # 00467bdc
    mov ecx, dword ptr [eax + 8*edx + field_1c0] # 00467bdf
    cmp ecx, dword ptr [ebp + arg_8]             # 00467be6
    je.d8 L_00467bfd                             # 00467be9
    # block 0x00467beb: entered by fall-through of je at 0x00467be9, 5 instruction(s), ends with jne to 0x00467c04 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467beb
    mov eax, dword ptr [ebp - local_8]           # 00467bee
    mov ecx, dword ptr [eax + 8*edx + field_1c4] # 00467bf1
    cmp ecx, dword ptr [ebp + arg_8]             # 00467bf8
    jne.d8 L_00467c04                            # 00467bfb
L_00467bfd:
    # block 0x00467bfd: entered by je at 0x00467be9; fall-through of jne at 0x00467bfb, 2 instruction(s), ends with forward jump to 0x00467c08
    mov eax, 0x1                                 # 00467bfd
    jmp.d8 L_00467c08                            # 00467c02
L_00467c04:
    # block 0x00467c04: entered by jne at 0x00467bfb, 1 instruction(s), ends with backward jump to 0x00467bc2
    jmp.d8 L_00467bc2                            # 00467c04
L_00467c06:
    # block 0x00467c06: entered by jge at 0x00467bd7, 1 instruction(s), falls into the block at 0x00467c08
    {load} xor eax, eax                          # 00467c06
L_00467c08:
    # block 0x00467c08: entered by jmp at 0x00467bb7; jmp at 0x00467c02, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00467c08
    pop ebp                                      # 00467c0a
    ret 0x4                                      # 00467c0b

