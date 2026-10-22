# FUN_004c4b12
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c4b12
# extent:       0x004c4b12-0x004c4c2b (281 code bytes)
# span:         0x004c4b12-0x004c4c2b (code 281, tables 0, padding 0)
# sha256:       44dc10216a01f250fbcf87e1669e1462be97246e67a3891bc390515e7548dd95
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c4b12_lifted
# naming:       native port src/original_methods_fl39d.c:m4c4b12_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (25 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_2f; [ecx + n] field_4, field_8, field_c; [edx + n] field_4, field_2f
# callees:      calls FUN_0043efb6, FUN_0043ef77, FUN_004264e8, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4c4b12_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 92 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_2f, 0x2f  # offset +0x2f

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0043ef77, .text + (0x0043ef77 - 0x401000)
.set FUN_0043efb6, .text + (0x0043efb6 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x004c4b12 - 0x401000
.globl FUN_004c4b12
FUN_004c4b12:
    # block 0x004c4b12: entry, 41 instruction(s), ends with forward jump to 0x004c4b9e
    push ebp                                     # 004c4b12
    {load} mov ebp, esp                          # 004c4b13
    sub esp, 0x18                                # 004c4b15
    mov dword ptr [ebp - local_18], ecx          # 004c4b18
    mov eax, dword ptr [ebp + arg_c]             # 004c4b1b
    and eax, 0xffff                              # 004c4b1e
    shl eax, 0x10                                # 004c4b23
    mov ecx, dword ptr [ebp + arg_c]             # 004c4b26
    and ecx, 0xffff                              # 004c4b29
    {load} or eax, ecx                           # 004c4b2f
    mov dword ptr [ebp - local_14], eax          # 004c4b31
    mov edx, dword ptr [ebp + arg_8]             # 004c4b34
    movsx eax, word ptr [edx + field_2f]         # 004c4b37
    mov ecx, dword ptr [ebp + arg_10]            # 004c4b3b
    mov edx, dword ptr [ecx + field_4]           # 004c4b3e
    imul edx, eax                                # 004c4b41
    mov eax, dword ptr [ebp + arg_8]             # 004c4b44
    mov ecx, dword ptr [eax]                     # 004c4b47
    {load} add ecx, edx                          # 004c4b49
    movsx edx, word ptr [0x639895]               # 004c4b4b
    mov eax, dword ptr [ebp + arg_10]            # 004c4b52
    mov eax, dword ptr [eax]                     # 004c4b55
    imul eax, edx                                # 004c4b57
    {load} add ecx, eax                          # 004c4b5a
    mov dword ptr [ebp - local_4], ecx           # 004c4b5c
    mov ecx, dword ptr [ebp + arg_10]            # 004c4b5f
    mov edx, dword ptr [ebp + arg_10]            # 004c4b62
    mov eax, dword ptr [ecx + field_c]           # 004c4b65
    sub eax, dword ptr [edx + field_4]           # 004c4b68
    add eax, 0x1                                 # 004c4b6b
    mov dword ptr [ebp - local_c], eax           # 004c4b6e
    mov ecx, dword ptr [ebp + arg_10]            # 004c4b71
    mov edx, dword ptr [ebp + arg_10]            # 004c4b74
    mov eax, dword ptr [ecx + field_8]           # 004c4b77
    sub eax, dword ptr [edx]                     # 004c4b7a
    add eax, 0x1                                 # 004c4b7c
    movsx ecx, word ptr [0x639895]               # 004c4b7f
    imul eax, ecx                                # 004c4b86
    mov dword ptr [ebp - local_8], eax           # 004c4b89
    mov dword ptr [ebp - local_10], 0x0          # 004c4b8c
    jmp.d8 L_004c4b9e                            # 004c4b93
L_004c4b95:
    # block 0x004c4b95: entered by jmp at 0x004c4c20, 3 instruction(s), falls into the block at 0x004c4b9e
    mov edx, dword ptr [ebp - local_10]          # 004c4b95
    add edx, 0x1                                 # 004c4b98
    mov dword ptr [ebp - local_10], edx          # 004c4b9b
L_004c4b9e:
    # block 0x004c4b9e: entered by jmp at 0x004c4b93, 3 instruction(s), ends with jge to 0x004c4c25 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004c4b9e
    cmp eax, dword ptr [ebp - local_c]           # 004c4ba1
    jge.d8 L_004c4c25                            # 004c4ba4
    # block 0x004c4ba6: entered by fall-through of jge at 0x004c4ba4, 4 instruction(s), ends with jne to 0x004c4bcf (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c4ba6
    and ecx, 0x3                                 # 004c4ba9
    test ecx, ecx                                # 004c4bac
    jne.d8 L_004c4bcf                            # 004c4bae
    # block 0x004c4bb0: entered by fall-through of jne at 0x004c4bae, 11 instruction(s), calls FUN_0043efb6, ends with forward jump to 0x004c4c11
    mov edx, dword ptr [ebp - local_8]           # 004c4bb0
    sar edx, 0x2                                 # 004c4bb3
    push edx                                     # 004c4bb6
    mov eax, dword ptr [ebp - local_14]          # 004c4bb7
    push eax                                     # 004c4bba
    mov ecx, dword ptr [ebp - local_4]           # 004c4bbb
    push ecx                                     # 004c4bbe
    mov ecx, dword ptr [ebp - local_18]          # 004c4bbf
    add ecx, 0x38cc                              # 004c4bc2
    call FUN_0043efb6                            # 004c4bc8
    jmp.d8 L_004c4c11                            # 004c4bcd
L_004c4bcf:
    # block 0x004c4bcf: entered by jne at 0x004c4bae, 4 instruction(s), ends with jne to 0x004c4bf8 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c4bcf
    and edx, 0x1                                 # 004c4bd2
    test edx, edx                                # 004c4bd5
    jne.d8 L_004c4bf8                            # 004c4bd7
    # block 0x004c4bd9: entered by fall-through of jne at 0x004c4bd7, 11 instruction(s), calls FUN_0043ef77, ends with forward jump to 0x004c4c11
    mov eax, dword ptr [ebp - local_8]           # 004c4bd9
    sar eax                                      # 004c4bdc
    push eax                                     # 004c4bde
    mov cx, word ptr [ebp + arg_c]               # 004c4bdf
    push ecx                                     # 004c4be3
    mov edx, dword ptr [ebp - local_4]           # 004c4be4
    push edx                                     # 004c4be7
    mov ecx, dword ptr [ebp - local_18]          # 004c4be8
    add ecx, 0x38cc                              # 004c4beb
    call FUN_0043ef77                            # 004c4bf1
    jmp.d8 L_004c4c11                            # 004c4bf6
L_004c4bf8:
    # block 0x004c4bf8: entered by jne at 0x004c4bd7, 6 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004c4c25
    push 0x55462c                                # 004c4bf8
    mov ecx, 0x583979                            # 004c4bfd
    call FUN_004264e8                            # 004c4c02
    mov ecx, dword ptr [ebp - local_18]          # 004c4c07
    call FUN_004c97b4                            # 004c4c0a
    jmp.d8 L_004c4c25                            # 004c4c0f
L_004c4c11:
    # block 0x004c4c11: entered by jmp at 0x004c4bcd; jmp at 0x004c4bf6, 6 instruction(s), ends with backward jump to 0x004c4b95
    mov eax, dword ptr [ebp + arg_8]             # 004c4c11
    movsx ecx, word ptr [eax + field_2f]         # 004c4c14
    mov edx, dword ptr [ebp - local_4]           # 004c4c18
    {load} add edx, ecx                          # 004c4c1b
    mov dword ptr [ebp - local_4], edx           # 004c4c1d
    jmp.d32 L_004c4b95                           # 004c4c20
L_004c4c25:
    # block 0x004c4c25: entered by jge at 0x004c4ba4; jmp at 0x004c4c0f, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004c4c25
    pop ebp                                      # 004c4c27
    ret 0xc                                      # 004c4c28

