# FUN_004bf1f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf1f0
# extent:       0x004bf1f0-0x004bf297 (167 code bytes)
# span:         0x004bf1f0-0x004bf297 (code 167, tables 0, padding 0)
# sha256:       86da5ce1049971af613060b6e459ba3224b6c3af777d97a02a6a3fb72db7d419
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bf1f0_lifted
# naming:       native port src/original_methods_fl41.c:m4bf1f0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 5 seeds; oracle: 57/57 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_2c0; [edx + n] field_4
# callees:      calls FUN_004bf38c, FUN_004bf19a, FUN_004bf542, FUN_004befc8, FUN_004bf098
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4bf1f0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------
.set FUN_004befc8, .text + (0x004befc8 - 0x401000)
.set FUN_004bf098, .text + (0x004bf098 - 0x401000)
.set FUN_004bf19a, .text + (0x004bf19a - 0x401000)
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)
.set FUN_004bf542, .text + (0x004bf542 - 0x401000)

.org 0x004bf1f0 - 0x401000
.globl FUN_004bf1f0
FUN_004bf1f0:
    # block 0x004bf1f0: entry, 9 instruction(s), calls FUN_004bf38c, ends with jne to 0x004bf220 (forward)
    push ebp                                     # 004bf1f0
    {load} mov ebp, esp                          # 004bf1f1
    sub esp, 0x10                                # 004bf1f3
    mov dword ptr [ebp - local_10], ecx          # 004bf1f6
    mov dword ptr [ebp - local_4], 0x0           # 004bf1f9
    mov ecx, dword ptr [ebp - local_10]          # 004bf200
    call FUN_004bf38c                            # 004bf203
    cmp dword ptr [ebp + arg_8], 0x0             # 004bf208
    jne.d8 L_004bf220                            # 004bf20c
    # block 0x004bf20e: entered by fall-through of jne at 0x004bf20c, 4 instruction(s), ends with forward jump to 0x004bf291
    mov eax, dword ptr [ebp - local_10]          # 004bf20e
    mov dword ptr [eax + field_2c0], 0xfffffffd  # 004bf211
    mov eax, dword ptr [ebp - local_4]           # 004bf21b
    jmp.d8 L_004bf291                            # 004bf21e
L_004bf220:
    # block 0x004bf220: entered by jne at 0x004bf20c, 8 instruction(s), calls FUN_004bf19a, ends with je to 0x004bf28e (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004bf220
    push ecx                                     # 004bf223
    mov edx, dword ptr [ebp + arg_8]             # 004bf224
    push edx                                     # 004bf227
    mov ecx, dword ptr [ebp - local_10]          # 004bf228
    call FUN_004bf19a                            # 004bf22b
    test eax, eax                                # 004bf230
    je.d8 L_004bf28e                             # 004bf232
    # block 0x004bf234: entered by fall-through of je at 0x004bf232, 32 instruction(s), calls FUN_004bf542, FUN_004befc8, FUN_004bf098, falls into the block at 0x004bf28e
    movsx eax, word ptr [0x639895]               # 004bf234
    mov ecx, dword ptr [ebp + arg_8]             # 004bf23b
    mov edx, dword ptr [ecx]                     # 004bf23e
    imul edx, eax                                # 004bf240
    mov dword ptr [ebp - local_c], edx           # 004bf243
    mov eax, dword ptr [ebp + arg_8]             # 004bf246
    mov ecx, dword ptr [ebp - local_c]           # 004bf249
    imul ecx, dword ptr [eax + field_4]          # 004bf24c
    mov dword ptr [ebp - local_8], ecx           # 004bf250
    mov edx, dword ptr [ebp - local_8]           # 004bf253
    push edx                                     # 004bf256
    lea eax, [ebp - local_4]                     # 004bf257
    push eax                                     # 004bf25a
    mov ecx, dword ptr [ebp - local_10]          # 004bf25b
    call FUN_004bf542                            # 004bf25e
    mov ecx, dword ptr [ebp + arg_8]             # 004bf263
    push ecx                                     # 004bf266
    mov ecx, dword ptr [ebp - local_10]          # 004bf267
    call FUN_004befc8                            # 004bf26a
    push 0x0                                     # 004bf26f
    push 0x0                                     # 004bf271
    mov edx, dword ptr [ebp + arg_8]             # 004bf273
    mov eax, dword ptr [edx + field_4]           # 004bf276
    push eax                                     # 004bf279
    mov ecx, dword ptr [ebp - local_c]           # 004bf27a
    push ecx                                     # 004bf27d
    mov edx, dword ptr [ebp - local_4]           # 004bf27e
    push edx                                     # 004bf281
    mov eax, dword ptr [ebp + arg_8]             # 004bf282
    push eax                                     # 004bf285
    mov ecx, dword ptr [ebp - local_10]          # 004bf286
    call FUN_004bf098                            # 004bf289
L_004bf28e:
    # block 0x004bf28e: entered by je at 0x004bf232, 1 instruction(s), falls into the block at 0x004bf291
    mov eax, dword ptr [ebp - local_4]           # 004bf28e
L_004bf291:
    # block 0x004bf291: entered by jmp at 0x004bf21e, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004bf291
    pop ebp                                      # 004bf293
    ret 0x8                                      # 004bf294

