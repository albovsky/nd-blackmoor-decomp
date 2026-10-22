# FUN_004c9cdd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c9cdd
# extent:       0x004c9cdd-0x004c9d91 (180 code bytes)
# span:         0x004c9cdd-0x004c9d91 (code 180, tables 0, padding 0)
# sha256:       1c995c904fec26ae73e140c08a1deeeb85ee3b20bccef006f0f46c8851c22be6
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c9cdd_find_zero_record
# naming:       native port src/original_methods_fl39f.c:m4c9cdd_find_zero_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Searches the (signed) count dword [obj+0x1758] of 16-byte records (stride 0x3e4 from +0x30c) for the first all-zero one (repe cmpsb against zeros) and stores its index. All instructions run; both jump directions taken.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_30c, field_175c; [edx + n] field_1758, field_175c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m4c9cdd_find_zero_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ arg_8, 0x8  # offset +0x8
.equ field_30c, 0x30c  # offset +0x30c
.equ field_1758, 0x1758  # offset +0x1758
.equ field_175c, 0x175c  # offset +0x175c

# --- external targets -----------------------------------------------

.org 0x004c9cdd - 0x401000
.globl FUN_004c9cdd
FUN_004c9cdd:
    # block 0x004c9cdd: entry, 13 instruction(s), ends with jne to 0x004c9d03 (forward)
    push ebp                                     # 004c9cdd
    {load} mov ebp, esp                          # 004c9cde
    sub esp, 0x20                                # 004c9ce0
    push esi                                     # 004c9ce3
    push edi                                     # 004c9ce4
    mov dword ptr [ebp - local_18], ecx          # 004c9ce5
    {load} xor eax, eax                          # 004c9ce8
    mov dword ptr [ebp - local_14], eax          # 004c9cea
    mov dword ptr [ebp - local_10], eax          # 004c9ced
    mov dword ptr [ebp - local_c], eax           # 004c9cf0
    mov dword ptr [ebp - local_8], eax           # 004c9cf3
    cmp dword ptr [ebp + arg_8], 0x0             # 004c9cf6
    jne.d8 L_004c9d03                            # 004c9cfa
    # block 0x004c9cfc: entered by fall-through of jne at 0x004c9cfa, 2 instruction(s), ends with forward jump to 0x004c9d89
    {load} xor eax, eax                          # 004c9cfc
    jmp.d32 L_004c9d89                           # 004c9cfe
L_004c9d03:
    # block 0x004c9d03: entered by jne at 0x004c9cfa, 2 instruction(s), ends with forward jump to 0x004c9d15
    mov dword ptr [ebp - local_4], 0x0           # 004c9d03
    jmp.d8 L_004c9d15                            # 004c9d0a
L_004c9d0c:
    # block 0x004c9d0c: entered by jmp at 0x004c9d75, 3 instruction(s), falls into the block at 0x004c9d15
    mov ecx, dword ptr [ebp - local_4]           # 004c9d0c
    add ecx, 0x1                                 # 004c9d0f
    mov dword ptr [ebp - local_4], ecx           # 004c9d12
L_004c9d15:
    # block 0x004c9d15: entered by jmp at 0x004c9d0a, 4 instruction(s), ends with jge to 0x004c9d77 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004c9d15
    mov eax, dword ptr [ebp - local_4]           # 004c9d18
    cmp eax, dword ptr [edx + field_1758]        # 004c9d1b
    jge.d8 L_004c9d77                            # 004c9d21
    # block 0x004c9d23: entered by fall-through of jge at 0x004c9d21, 10 instruction(s), ends with je to 0x004c9d4f (forward)
    mov ecx, 0x10                                # 004c9d23
    lea edi, [ebp - local_14]                    # 004c9d28
    mov edx, dword ptr [ebp - local_4]           # 004c9d2b
    imul edx, edx, 0x3e4                         # 004c9d2e
    mov eax, dword ptr [ebp + arg_8]             # 004c9d34
    lea esi, [eax + edx + field_30c]             # 004c9d37
    {load} xor edx, edx                          # 004c9d3e
    mov dword ptr [ebp - local_1c], edx          # 004c9d40
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004c9d43
    je.d8 L_004c9d4f                             # 004c9d45
    # block 0x004c9d47: entered by fall-through of je at 0x004c9d45, 3 instruction(s), falls into the block at 0x004c9d4f
    {load} sbb eax, eax                          # 004c9d47
    sbb eax, -0x1                                # 004c9d49
    mov dword ptr [ebp - local_1c], eax          # 004c9d4c
L_004c9d4f:
    # block 0x004c9d4f: entered by je at 0x004c9d45, 7 instruction(s), ends with je to 0x004c9d75 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c9d4f
    mov dword ptr [ebp - local_20], ecx          # 004c9d52
    {load} xor edx, edx                          # 004c9d55
    cmp dword ptr [ebp - local_20], 0x0          # 004c9d57
    sete dl                                      # 004c9d5b
    test edx, edx                                # 004c9d5e
    je.d8 L_004c9d75                             # 004c9d60
    # block 0x004c9d62: entered by fall-through of je at 0x004c9d60, 5 instruction(s), ends with forward jump to 0x004c9d89
    mov eax, dword ptr [ebp + arg_8]             # 004c9d62
    mov ecx, dword ptr [ebp - local_4]           # 004c9d65
    mov dword ptr [eax + field_175c], ecx        # 004c9d68
    mov eax, 0x1                                 # 004c9d6e
    jmp.d8 L_004c9d89                            # 004c9d73
L_004c9d75:
    # block 0x004c9d75: entered by je at 0x004c9d60, 1 instruction(s), ends with backward jump to 0x004c9d0c
    jmp.d8 L_004c9d0c                            # 004c9d75
L_004c9d77:
    # block 0x004c9d77: entered by jge at 0x004c9d21, 3 instruction(s), falls into the block at 0x004c9d89
    mov edx, dword ptr [ebp + arg_8]             # 004c9d77
    mov dword ptr [edx + field_175c], 0x0        # 004c9d7a
    mov eax, 0x1                                 # 004c9d84
L_004c9d89:
    # block 0x004c9d89: entered by jmp at 0x004c9cfe; jmp at 0x004c9d73, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004c9d89
    pop esi                                      # 004c9d8a
    {load} mov esp, ebp                          # 004c9d8b
    pop ebp                                      # 004c9d8d
    ret 0x4                                      # 004c9d8e

