# FUN_0042ea87
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042ea87
# extent:       0x0042ea87-0x0042ed54 (717 code bytes)
# span:         0x0042ea87-0x0042ed54 (code 717, tables 0, padding 0)
# sha256:       74b38c90c9d5fe73789787cc53eea5f40094e33abac5cae243cb69da9b7b0b20
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m42ea87_record_state
# naming:       native port src/original_methods_fl26b.c:m42ea87_record_state (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m42ea87_record_state. Direct, Unicorn differential and oracle: every instruction reached, both jcc ways (untaken edges allowlisted in the handoff). See tasks/fl26b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_2, field_8, field_28; [ecx + n] field_c; [edx + n] field_2, field_4, field_10
# callees:      calls FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:native_a62_current_selector (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 163 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
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
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)

.org 0x0042ea87 - 0x401000
.globl FUN_0042ea87
FUN_0042ea87:
    # block 0x0042ea87: entry, 9 instruction(s), ends with jne to 0x0042eabe (forward)
    push ebp                                     # 0042ea87
    {load} mov ebp, esp                          # 0042ea88
    sub esp, 0x18                                # 0042ea8a
    movsx eax, word ptr [ebp + arg_8]            # 0042ea8d
    imul eax, eax, 0x8d                          # 0042ea91
    {load} xor ecx, ecx                          # 0042ea97
    mov cl, byte ptr [eax + 0x5bb5e3]            # 0042ea99
    cmp ecx, 0x63                                # 0042ea9f
    jne.d8 L_0042eabe                            # 0042eaa2
    # block 0x0042eaa4: entered by fall-through of jne at 0x0042eaa2, 6 instruction(s), ends with forward jump to 0x0042ead6
    movsx edx, word ptr [ebp + arg_8]            # 0042eaa4
    imul edx, edx, 0x8d                          # 0042eaa8
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042eaae
    mov cx, word ptr [eax + field_28]            # 0042eab4
    mov word ptr [ebp - local_8], cx             # 0042eab8
    jmp.d8 L_0042ead6                            # 0042eabc
L_0042eabe:
    # block 0x0042eabe: entered by jne at 0x0042eaa2, 5 instruction(s), falls into the block at 0x0042ead6
    movsx edx, word ptr [ebp + arg_8]            # 0042eabe
    imul edx, edx, 0x8d                          # 0042eac2
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042eac8
    mov cx, word ptr [eax + field_8]             # 0042eace
    mov word ptr [ebp - local_8], cx             # 0042ead2
L_0042ead6:
    # block 0x0042ead6: entered by jmp at 0x0042eabc, 6 instruction(s), ends with je to 0x0042eb04 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042ead6
    imul edx, edx, 0x8d                          # 0042eada
    mov eax, dword ptr [edx + 0x5bb632]          # 0042eae0
    mov dword ptr [ebp - local_18], eax          # 0042eae6
    cmp dword ptr [ebp - local_18], 0x0          # 0042eae9
    je.d8 L_0042eb04                             # 0042eaed
    # block 0x0042eaef: entered by fall-through of je at 0x0042eaed, 2 instruction(s), ends with je to 0x0042eb22 (forward)
    cmp dword ptr [ebp - local_18], 0x1          # 0042eaef
    je.d8 L_0042eb22                             # 0042eaf3
    # block 0x0042eaf5: entered by fall-through of je at 0x0042eaf3, 2 instruction(s), ends with je to 0x0042ec5f (forward)
    cmp dword ptr [ebp - local_18], 0x2          # 0042eaf5
    je.d32 L_0042ec5f                            # 0042eaf9
    # block 0x0042eaff: entered by fall-through of je at 0x0042eaf9, 1 instruction(s), ends with forward jump to 0x0042ed50
    jmp.d32 L_0042ed50                           # 0042eaff
L_0042eb04:
    # block 0x0042eb04: entered by je at 0x0042eaed, 4 instruction(s), falls into the block at 0x0042eb22
    mov dword ptr [0x5bb1ca], 0x1                # 0042eb04
    movsx ecx, word ptr [ebp + arg_8]            # 0042eb0e
    imul ecx, ecx, 0x8d                          # 0042eb12
    mov dword ptr [ecx + 0x5bb632], 0x1          # 0042eb18
L_0042eb22:
    # block 0x0042eb22: entered by je at 0x0042eaf3, 9 instruction(s), ends with jne to 0x0042eb65 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042eb22
    imul edx, edx, 0x8d                          # 0042eb26
    mov dword ptr [edx + 0x5bb626], 0x0          # 0042eb2c
    movsx eax, word ptr [ebp + arg_8]            # 0042eb36
    imul eax, eax, 0x8d                          # 0042eb3a
    {load} xor ecx, ecx                          # 0042eb40
    mov cl, byte ptr [eax + 0x5bb5e3]            # 0042eb42
    cmp ecx, 0x63                                # 0042eb48
    jne.d8 L_0042eb65                            # 0042eb4b
    # block 0x0042eb4d: entered by fall-through of jne at 0x0042eb4b, 6 instruction(s), ends with forward jump to 0x0042eb7b
    movsx edx, word ptr [ebp + arg_8]            # 0042eb4d
    imul edx, edx, 0x8d                          # 0042eb51
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042eb57
    add eax, 0x2a                                # 0042eb5d
    mov dword ptr [ebp - local_14], eax          # 0042eb60
    jmp.d8 L_0042eb7b                            # 0042eb63
L_0042eb65:
    # block 0x0042eb65: entered by jne at 0x0042eb4b, 5 instruction(s), falls into the block at 0x0042eb7b
    movsx ecx, word ptr [ebp + arg_8]            # 0042eb65
    imul ecx, ecx, 0x8d                          # 0042eb69
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042eb6f
    add edx, 0xa                                 # 0042eb75
    mov dword ptr [ebp - local_14], edx          # 0042eb78
L_0042eb7b:
    # block 0x0042eb7b: entered by jmp at 0x0042eb63, 2 instruction(s), ends with forward jump to 0x0042eb8f
    mov word ptr [ebp - local_10], 0x0           # 0042eb7b
    jmp.d8 L_0042eb8f                            # 0042eb81
L_0042eb83:
    # block 0x0042eb83: entered by jmp at 0x0042ec55, 3 instruction(s), falls into the block at 0x0042eb8f
    mov ax, word ptr [ebp - local_10]            # 0042eb83
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042eb87
    mov word ptr [ebp - local_10], ax            # 0042eb8b
L_0042eb8f:
    # block 0x0042eb8f: entered by jmp at 0x0042eb81, 5 instruction(s), ends with jge to 0x0042ec5a (forward)
    movsx ecx, word ptr [ebp - local_10]         # 0042eb8f
    mov edx, dword ptr [ebp - local_14]          # 0042eb93
    movsx eax, word ptr [edx]                    # 0042eb96
    {load} cmp ecx, eax                          # 0042eb99
    jge.d32 L_0042ec5a                           # 0042eb9b
    # block 0x0042eba1: entered by fall-through of jge at 0x0042eb9b, 7 instruction(s), ends with jne to 0x0042ec55 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 0042eba1
    imul ecx, ecx, 0x12                          # 0042eba5
    mov edx, dword ptr [ebp - local_14]          # 0042eba8
    movsx eax, word ptr [edx + ecx + field_2]    # 0042ebab
    movsx ecx, word ptr [0x5bb50b]               # 0042ebb0
    {load} cmp eax, ecx                          # 0042ebb7
    jne.d32 L_0042ec55                           # 0042ebb9
    # block 0x0042ebbf: entered by fall-through of jne at 0x0042ebb9, 32 instruction(s), ends with forward jump to 0x0042ec5a
    movsx edx, word ptr [ebp + arg_8]            # 0042ebbf
    imul edx, edx, 0x8d                          # 0042ebc3
    mov dword ptr [edx + 0x5bb626], 0x1          # 0042ebc9
    movsx eax, word ptr [ebp - local_10]         # 0042ebd3
    imul eax, eax, 0x12                          # 0042ebd7
    movsx ecx, word ptr [ebp + arg_8]            # 0042ebda
    imul ecx, ecx, 0x8d                          # 0042ebde
    mov edx, dword ptr [ebp - local_14]          # 0042ebe4
    mov ax, word ptr [edx + eax + field_4]       # 0042ebe7
    mov word ptr [ecx + 0x5bb62a], ax            # 0042ebec
    movsx ecx, word ptr [ebp - local_10]         # 0042ebf3
    imul ecx, ecx, 0x12                          # 0042ebf7
    movsx edx, word ptr [ebp + arg_8]            # 0042ebfa
    imul edx, edx, 0x8d                          # 0042ebfe
    mov eax, dword ptr [ebp - local_14]          # 0042ec04
    mov cx, word ptr [eax + ecx + field_8]       # 0042ec07
    mov word ptr [edx + 0x5bb62c], cx            # 0042ec0c
    movsx edx, word ptr [ebp - local_10]         # 0042ec13
    imul edx, edx, 0x12                          # 0042ec17
    movsx eax, word ptr [ebp + arg_8]            # 0042ec1a
    imul eax, eax, 0x8d                          # 0042ec1e
    mov ecx, dword ptr [ebp - local_14]          # 0042ec24
    mov dx, word ptr [ecx + edx + field_c]       # 0042ec27
    mov word ptr [eax + 0x5bb62e], dx            # 0042ec2c
    movsx eax, word ptr [ebp - local_10]         # 0042ec33
    imul eax, eax, 0x12                          # 0042ec37
    movsx ecx, word ptr [ebp + arg_8]            # 0042ec3a
    imul ecx, ecx, 0x8d                          # 0042ec3e
    mov edx, dword ptr [ebp - local_14]          # 0042ec44
    mov ax, word ptr [edx + eax + field_10]      # 0042ec47
    mov word ptr [ecx + 0x5bb630], ax            # 0042ec4c
    jmp.d8 L_0042ec5a                            # 0042ec53
L_0042ec55:
    # block 0x0042ec55: entered by jne at 0x0042ebb9, 1 instruction(s), ends with backward jump to 0x0042eb83
    jmp.d32 L_0042eb83                           # 0042ec55
L_0042ec5a:
    # block 0x0042ec5a: entered by jge at 0x0042eb9b; jmp at 0x0042ec53, 1 instruction(s), ends with forward jump to 0x0042ed50
    jmp.d32 L_0042ed50                           # 0042ec5a
L_0042ec5f:
    # block 0x0042ec5f: entered by je at 0x0042eaf9, 3 instruction(s), ends with jge to 0x0042ed3c (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0042ec5f
    cmp ecx, 0x23                                # 0042ec63
    jge.d32 L_0042ed3c                           # 0042ec66
    # block 0x0042ec6c: entered by fall-through of jge at 0x0042ec66, 12 instruction(s), ends with jne to 0x0042ecb0 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042ec6c
    imul edx, edx, 0x8d                          # 0042ec70
    mov byte ptr [edx + 0x5bb625], 0x1           # 0042ec76
    movsx eax, word ptr [ebp + arg_8]            # 0042ec7d
    imul eax, eax, 0x8d                          # 0042ec81
    mov dword ptr [eax + 0x5bb626], 0x0          # 0042ec87
    movsx ecx, word ptr [ebp + arg_8]            # 0042ec91
    imul ecx, ecx, 0x8d                          # 0042ec95
    {load} xor edx, edx                          # 0042ec9b
    mov dl, byte ptr [ecx + 0x5bb5e3]            # 0042ec9d
    cmp edx, 0x63                                # 0042eca3
    jne.d8 L_0042ecb0                            # 0042eca6
    # block 0x0042eca8: entered by fall-through of jne at 0x0042eca6, 2 instruction(s), ends with forward jump to 0x0042ecb6
    mov word ptr [ebp - local_c], 0xa            # 0042eca8
    jmp.d8 L_0042ecb6                            # 0042ecae
L_0042ecb0:
    # block 0x0042ecb0: entered by jne at 0x0042eca6, 1 instruction(s), falls into the block at 0x0042ecb6
    mov word ptr [ebp - local_c], 0x2            # 0042ecb0
L_0042ecb6:
    # block 0x0042ecb6: entered by jmp at 0x0042ecae, 2 instruction(s), ends with forward jump to 0x0042ecca
    mov word ptr [ebp - local_4], 0x0            # 0042ecb6
    jmp.d8 L_0042ecca                            # 0042ecbc
L_0042ecbe:
    # block 0x0042ecbe: entered by jmp at 0x0042ed2b, 3 instruction(s), falls into the block at 0x0042ecca
    mov ax, word ptr [ebp - local_4]             # 0042ecbe
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042ecc2
    mov word ptr [ebp - local_4], ax             # 0042ecc6
L_0042ecca:
    # block 0x0042ecca: entered by jmp at 0x0042ecbc, 4 instruction(s), ends with jge to 0x0042ed2d (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0042ecca
    movsx edx, word ptr [ebp - local_c]          # 0042ecce
    {load} cmp ecx, edx                          # 0042ecd2
    jge.d8 L_0042ed2d                            # 0042ecd4
    # block 0x0042ecd6: entered by fall-through of jge at 0x0042ecd4, 7 instruction(s), ends with je to 0x0042ed2b (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042ecd6
    imul eax, eax, 0x8d                          # 0042ecda
    movsx ecx, word ptr [ebp - local_4]          # 0042ece0
    mov edx, dword ptr [eax + 0x5bb5e5]          # 0042ece4
    movsx eax, word ptr [edx + 4*ecx]            # 0042ecea
    cmp eax, -0x1                                # 0042ecee
    je.d8 L_0042ed2b                             # 0042ecf1
    # block 0x0042ecf3: entered by fall-through of je at 0x0042ecf1, 11 instruction(s), falls into the block at 0x0042ed2b
    movsx ecx, word ptr [ebp + arg_8]            # 0042ecf3
    imul ecx, ecx, 0x8d                          # 0042ecf7
    movsx edx, word ptr [ebp - local_4]          # 0042ecfd
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 0042ed01
    movsx ecx, word ptr [eax + 4*edx + field_2]  # 0042ed07
    movsx edx, word ptr [ebp + arg_8]            # 0042ed0c
    imul edx, edx, 0x8d                          # 0042ed10
    movsx eax, word ptr [ebp - local_4]          # 0042ed16
    mov edx, dword ptr [edx + 0x5bb5e5]          # 0042ed1a
    movsx eax, word ptr [edx + 4*eax]            # 0042ed20
    mov dword ptr [4*eax + 0x585801], ecx        # 0042ed24
L_0042ed2b:
    # block 0x0042ed2b: entered by je at 0x0042ecf1, 1 instruction(s), ends with backward jump to 0x0042ecbe
    jmp.d8 L_0042ecbe                            # 0042ed2b
L_0042ed2d:
    # block 0x0042ed2d: entered by jge at 0x0042ecd4, 5 instruction(s), calls FUN_0042ba3a, ends with forward jump to 0x0042ed50
    mov cx, word ptr [ebp + arg_8]               # 0042ed2d
    push ecx                                     # 0042ed31
    call FUN_0042ba3a                            # 0042ed32
    add esp, 0x4                                 # 0042ed37
    jmp.d8 L_0042ed50                            # 0042ed3a
L_0042ed3c:
    # block 0x0042ed3c: entered by jge at 0x0042ec66, 3 instruction(s), falls into the block at 0x0042ed50
    movsx edx, word ptr [ebp + arg_8]            # 0042ed3c
    imul edx, edx, 0x8d                          # 0042ed40
    mov dword ptr [edx + 0x5bb632], 0x1          # 0042ed46
L_0042ed50:
    # block 0x0042ed50: entered by jmp at 0x0042eaff; jmp at 0x0042ec5a; jmp at 0x0042ed3a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0042ed50
    pop ebp                                      # 0042ed52
    ret                                          # 0042ed53

