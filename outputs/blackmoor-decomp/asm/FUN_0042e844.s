# FUN_0042e844
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042e844
# extent:       0x0042e844-0x0042ea87 (579 code bytes)
# span:         0x0042e844-0x0042ea87 (code 579, tables 0, padding 0)
# sha256:       80447f83a1367e5dcfff7373597b837fa4aace201a01a1b607ef394eb5de2f09
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m42e844_step_record
# naming:       native port src/original_methods_fl30b.c:m42e844_step_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Three-state record stepper: state 0 sets a global and acts as state 1 (key match), state 2 loads ten pairs into a dword table; all instructions and jump directions run. See fl30b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_34; [ecx + n] field_2, field_28, field_30; [edx + n] field_2a, field_2c, field_38
# callees:      calls FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30b.c:m42e844_step_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 124 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ field_28, 0x28  # offset +0x28
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)

.org 0x0042e844 - 0x401000
.globl FUN_0042e844
FUN_0042e844:
    # block 0x0042e844: entry, 9 instruction(s), ends with je to 0x0042e878 (forward)
    push ebp                                     # 0042e844
    {load} mov ebp, esp                          # 0042e845
    sub esp, 0xc                                 # 0042e847
    movsx eax, word ptr [ebp + arg_8]            # 0042e84a
    imul eax, eax, 0x8d                          # 0042e84e
    mov ecx, dword ptr [eax + 0x5bb632]          # 0042e854
    mov dword ptr [ebp - local_c], ecx           # 0042e85a
    cmp dword ptr [ebp - local_c], 0x0           # 0042e85d
    je.d8 L_0042e878                             # 0042e861
    # block 0x0042e863: entered by fall-through of je at 0x0042e861, 2 instruction(s), ends with je to 0x0042e896 (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 0042e863
    je.d8 L_0042e896                             # 0042e867
    # block 0x0042e869: entered by fall-through of je at 0x0042e867, 2 instruction(s), ends with je to 0x0042e9dd (forward)
    cmp dword ptr [ebp - local_c], 0x2           # 0042e869
    je.d32 L_0042e9dd                            # 0042e86d
    # block 0x0042e873: entered by fall-through of je at 0x0042e86d, 1 instruction(s), ends with forward jump to 0x0042ea83
    jmp.d32 L_0042ea83                           # 0042e873
L_0042e878:
    # block 0x0042e878: entered by je at 0x0042e861, 4 instruction(s), falls into the block at 0x0042e896
    mov dword ptr [0x5bb1ca], 0x1                # 0042e878
    movsx edx, word ptr [ebp + arg_8]            # 0042e882
    imul edx, edx, 0x8d                          # 0042e886
    mov dword ptr [edx + 0x5bb632], 0x1          # 0042e88c
L_0042e896:
    # block 0x0042e896: entered by je at 0x0042e867, 5 instruction(s), ends with forward jump to 0x0042e8be
    movsx eax, word ptr [ebp + arg_8]            # 0042e896
    imul eax, eax, 0x8d                          # 0042e89a
    mov dword ptr [eax + 0x5bb626], 0x0          # 0042e8a0
    mov word ptr [ebp - local_8], 0x0            # 0042e8aa
    jmp.d8 L_0042e8be                            # 0042e8b0
L_0042e8b2:
    # block 0x0042e8b2: entered by jmp at 0x0042e9d3, 3 instruction(s), falls into the block at 0x0042e8be
    mov cx, word ptr [ebp - local_8]             # 0042e8b2
    add cx, 0x1                                  # 0042e8b6
    mov word ptr [ebp - local_8], cx             # 0042e8ba
L_0042e8be:
    # block 0x0042e8be: entered by jmp at 0x0042e8b0, 7 instruction(s), ends with jge to 0x0042e9d8 (forward)
    movsx edx, word ptr [ebp - local_8]          # 0042e8be
    movsx eax, word ptr [ebp + arg_8]            # 0042e8c2
    imul eax, eax, 0x8d                          # 0042e8c6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042e8cc
    movsx eax, word ptr [ecx + field_28]         # 0042e8d2
    {load} cmp edx, eax                          # 0042e8d6
    jge.d32 L_0042e9d8                           # 0042e8d8
    # block 0x0042e8de: entered by fall-through of jge at 0x0042e8d8, 9 instruction(s), ends with jne to 0x0042e9d3 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042e8de
    imul ecx, ecx, 0x8d                          # 0042e8e2
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042e8e8
    movsx eax, word ptr [ebp - local_8]          # 0042e8ee
    imul eax, eax, 0x12                          # 0042e8f2
    movsx ecx, word ptr [edx + eax + field_2a]   # 0042e8f5
    movsx edx, word ptr [0x5bb50b]               # 0042e8fa
    {load} cmp ecx, edx                          # 0042e901
    jne.d32 L_0042e9d3                           # 0042e903
    # block 0x0042e909: entered by fall-through of jne at 0x0042e903, 40 instruction(s), ends with forward jump to 0x0042e9d8
    movsx eax, word ptr [ebp + arg_8]            # 0042e909
    imul eax, eax, 0x8d                          # 0042e90d
    mov dword ptr [eax + 0x5bb626], 0x1          # 0042e913
    movsx ecx, word ptr [ebp + arg_8]            # 0042e91d
    imul ecx, ecx, 0x8d                          # 0042e921
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042e927
    movsx eax, word ptr [ebp - local_8]          # 0042e92d
    imul eax, eax, 0x12                          # 0042e931
    movsx ecx, word ptr [ebp + arg_8]            # 0042e934
    imul ecx, ecx, 0x8d                          # 0042e938
    mov dx, word ptr [edx + eax + field_2c]      # 0042e93e
    mov word ptr [ecx + 0x5bb62a], dx            # 0042e943
    movsx eax, word ptr [ebp + arg_8]            # 0042e94a
    imul eax, eax, 0x8d                          # 0042e94e
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042e954
    movsx edx, word ptr [ebp - local_8]          # 0042e95a
    imul edx, edx, 0x12                          # 0042e95e
    movsx eax, word ptr [ebp + arg_8]            # 0042e961
    imul eax, eax, 0x8d                          # 0042e965
    mov cx, word ptr [ecx + edx + field_30]      # 0042e96b
    mov word ptr [eax + 0x5bb62c], cx            # 0042e970
    movsx edx, word ptr [ebp + arg_8]            # 0042e977
    imul edx, edx, 0x8d                          # 0042e97b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042e981
    movsx ecx, word ptr [ebp - local_8]          # 0042e987
    imul ecx, ecx, 0x12                          # 0042e98b
    movsx edx, word ptr [ebp + arg_8]            # 0042e98e
    imul edx, edx, 0x8d                          # 0042e992
    mov ax, word ptr [eax + ecx + field_34]      # 0042e998
    mov word ptr [edx + 0x5bb62e], ax            # 0042e99d
    movsx ecx, word ptr [ebp + arg_8]            # 0042e9a4
    imul ecx, ecx, 0x8d                          # 0042e9a8
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042e9ae
    movsx eax, word ptr [ebp - local_8]          # 0042e9b4
    imul eax, eax, 0x12                          # 0042e9b8
    movsx ecx, word ptr [ebp + arg_8]            # 0042e9bb
    imul ecx, ecx, 0x8d                          # 0042e9bf
    mov dx, word ptr [edx + eax + field_38]      # 0042e9c5
    mov word ptr [ecx + 0x5bb630], dx            # 0042e9ca
    jmp.d8 L_0042e9d8                            # 0042e9d1
L_0042e9d3:
    # block 0x0042e9d3: entered by jne at 0x0042e903, 1 instruction(s), ends with backward jump to 0x0042e8b2
    jmp.d32 L_0042e8b2                           # 0042e9d3
L_0042e9d8:
    # block 0x0042e9d8: entered by jge at 0x0042e8d8; jmp at 0x0042e9d1, 1 instruction(s), ends with forward jump to 0x0042ea83
    jmp.d32 L_0042ea83                           # 0042e9d8
L_0042e9dd:
    # block 0x0042e9dd: entered by je at 0x0042e86d, 8 instruction(s), ends with forward jump to 0x0042ea16
    movsx eax, word ptr [ebp + arg_8]            # 0042e9dd
    imul eax, eax, 0x8d                          # 0042e9e1
    mov byte ptr [eax + 0x5bb625], 0x1           # 0042e9e7
    movsx ecx, word ptr [ebp + arg_8]            # 0042e9ee
    imul ecx, ecx, 0x8d                          # 0042e9f2
    mov dword ptr [ecx + 0x5bb626], 0x0          # 0042e9f8
    mov word ptr [ebp - local_4], 0x0            # 0042ea02
    jmp.d8 L_0042ea16                            # 0042ea08
L_0042ea0a:
    # block 0x0042ea0a: entered by jmp at 0x0042ea74, 3 instruction(s), falls into the block at 0x0042ea16
    mov dx, word ptr [ebp - local_4]             # 0042ea0a
    add dx, 0x1                                  # 0042ea0e
    mov word ptr [ebp - local_4], dx             # 0042ea12
L_0042ea16:
    # block 0x0042ea16: entered by jmp at 0x0042ea08, 3 instruction(s), ends with jge to 0x0042ea76 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0042ea16
    cmp eax, 0xa                                 # 0042ea1a
    jge.d8 L_0042ea76                            # 0042ea1d
    # block 0x0042ea1f: entered by fall-through of jge at 0x0042ea1d, 7 instruction(s), ends with je to 0x0042ea74 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042ea1f
    imul ecx, ecx, 0x8d                          # 0042ea23
    movsx edx, word ptr [ebp - local_4]          # 0042ea29
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 0042ea2d
    movsx ecx, word ptr [eax + 4*edx]            # 0042ea33
    cmp ecx, -0x1                                # 0042ea37
    je.d8 L_0042ea74                             # 0042ea3a
    # block 0x0042ea3c: entered by fall-through of je at 0x0042ea3a, 11 instruction(s), falls into the block at 0x0042ea74
    movsx edx, word ptr [ebp + arg_8]            # 0042ea3c
    imul edx, edx, 0x8d                          # 0042ea40
    movsx eax, word ptr [ebp - local_4]          # 0042ea46
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 0042ea4a
    movsx edx, word ptr [ecx + 4*eax + field_2]  # 0042ea50
    movsx eax, word ptr [ebp + arg_8]            # 0042ea55
    imul eax, eax, 0x8d                          # 0042ea59
    movsx ecx, word ptr [ebp - local_4]          # 0042ea5f
    mov eax, dword ptr [eax + 0x5bb5e5]          # 0042ea63
    movsx ecx, word ptr [eax + 4*ecx]            # 0042ea69
    mov dword ptr [4*ecx + 0x585801], edx        # 0042ea6d
L_0042ea74:
    # block 0x0042ea74: entered by je at 0x0042ea3a, 1 instruction(s), ends with backward jump to 0x0042ea0a
    jmp.d8 L_0042ea0a                            # 0042ea74
L_0042ea76:
    # block 0x0042ea76: entered by jge at 0x0042ea1d, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x0042ea83
    mov dx, word ptr [ebp + arg_8]               # 0042ea76
    push edx                                     # 0042ea7a
    call FUN_0042ba3a                            # 0042ea7b
    add esp, 0x4                                 # 0042ea80
L_0042ea83:
    # block 0x0042ea83: entered by jmp at 0x0042e873; jmp at 0x0042e9d8, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0042ea83
    pop ebp                                      # 0042ea85
    ret                                          # 0042ea86

