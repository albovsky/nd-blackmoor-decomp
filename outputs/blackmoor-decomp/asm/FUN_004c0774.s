# FUN_004c0774
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0774
# extent:       0x004c0774-0x004c08d3 (351 code bytes)
# span:         0x004c0774-0x004c08d3 (code 351, tables 0, padding 0)
# sha256:       d96e68e05f7f4c826d4d58511c0b4c6be4baee59cb98e1fc7ff4ddf09200fcdd
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c0774
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_37, field_39, field_1d4, field_20e, field_22a; [ecx + n] field_21, field_23, field_25, field_2f, field_31, field_33, field_35; [edx + n] field_22a, field_240
# callees:      calls FUN_004d36ed, FUN_004bf773, FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/action_family_35_runtime.c:action35_runtime_step (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 76 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_33, 0x33  # offset +0x33
.equ field_35, 0x35  # offset +0x35
.equ field_37, 0x37  # offset +0x37
.equ field_39, 0x39  # offset +0x39
.equ field_1d4, 0x1d4  # offset +0x1d4
.equ field_20e, 0x20e  # offset +0x20e
.equ field_22a, 0x22a  # offset +0x22a
.equ field_240, 0x240  # offset +0x240

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004bf773, .text + (0x004bf773 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)

.org 0x004c0774 - 0x401000
.globl FUN_004c0774
FUN_004c0774:
    # block 0x004c0774: entry, 9 instruction(s), ends with jne to 0x004c079f (forward)
    push ebp                                     # 004c0774
    {load} mov ebp, esp                          # 004c0775
    push ecx                                     # 004c0777
    mov dword ptr [ebp - local_4], ecx           # 004c0778
    mov eax, dword ptr [ebp - local_4]           # 004c077b
    mov ecx, dword ptr [eax + field_22a]         # 004c077e
    movsx edx, word ptr [ecx + field_21]         # 004c0784
    test edx, edx                                # 004c0788
    jne.d8 L_004c079f                            # 004c078a
    # block 0x004c078c: entered by fall-through of jne at 0x004c078a, 4 instruction(s), ends with jne to 0x004c079f (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c078c
    movsx ecx, word ptr [eax + field_1d4]        # 004c078f
    test ecx, ecx                                # 004c0796
    jne.d8 L_004c079f                            # 004c0798
    # block 0x004c079a: entered by fall-through of jne at 0x004c0798, 1 instruction(s), ends with forward jump to 0x004c08cd
    jmp.d32 L_004c08cd                           # 004c079a
L_004c079f:
    # block 0x004c079f: entered by jne at 0x004c078a; jne at 0x004c0798, 12 instruction(s), ends with je to 0x004c0802 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004c079f
    mov dword ptr [edx + field_240], 0x0         # 004c07a2
    mov dword ptr [0x5d19fb], 0x0                # 004c07ac
    mov eax, dword ptr [ebp - local_4]           # 004c07b6
    mov ecx, dword ptr [eax + field_20e]         # 004c07b9
    mov dword ptr [0x5839a9], ecx                # 004c07bf
    mov dword ptr [0x5c39f9], 0x0                # 004c07c5
    mov edx, dword ptr [ebp - local_4]           # 004c07cf
    mov eax, dword ptr [edx + field_22a]         # 004c07d2
    movsx ecx, word ptr [eax + field_37]         # 004c07d8
    cmp ecx, -0x1                                # 004c07dc
    je.d8 L_004c0802                             # 004c07df
    # block 0x004c07e1: entered by fall-through of je at 0x004c07df, 7 instruction(s), falls into the block at 0x004c0802
    mov edx, dword ptr [ebp - local_4]           # 004c07e1
    mov eax, dword ptr [edx + field_22a]         # 004c07e4
    movsx ecx, word ptr [eax + field_39]         # 004c07ea
    mov edx, dword ptr [ebp - local_4]           # 004c07ee
    mov eax, dword ptr [edx + field_22a]         # 004c07f1
    movsx edx, word ptr [eax + field_37]         # 004c07f7
    mov dword ptr [4*edx + 0x585801], ecx        # 004c07fb
L_004c0802:
    # block 0x004c0802: entered by je at 0x004c07df, 5 instruction(s), ends with jne to 0x004c088b (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c0802
    mov ecx, dword ptr [eax + field_22a]         # 004c0805
    movsx edx, word ptr [ecx + field_25]         # 004c080b
    cmp edx, 0x5                                 # 004c080f
    jne.d8 L_004c088b                            # 004c0812
    # block 0x004c0814: entered by fall-through of jne at 0x004c0812, 20 instruction(s), falls into the block at 0x004c088b
    mov eax, dword ptr [ebp - local_4]           # 004c0814
    mov ecx, dword ptr [eax + field_22a]         # 004c0817
    movsx edx, word ptr [ecx + field_2f]         # 004c081d
    mov dword ptr [0x5bb57b], edx                # 004c0821
    mov eax, dword ptr [ebp - local_4]           # 004c0827
    mov ecx, dword ptr [eax + field_22a]         # 004c082a
    mov dx, word ptr [ecx + field_31]            # 004c0830
    mov word ptr [0x5bb599], dx                  # 004c0834
    mov eax, dword ptr [ebp - local_4]           # 004c083b
    mov ecx, dword ptr [eax + field_22a]         # 004c083e
    mov dx, word ptr [ecx + field_33]            # 004c0844
    mov word ptr [0x5bb595], dx                  # 004c0848
    mov eax, dword ptr [ebp - local_4]           # 004c084f
    mov ecx, dword ptr [eax + field_22a]         # 004c0852
    mov dx, word ptr [ecx + field_35]            # 004c0858
    mov word ptr [0x5c39ff], dx                  # 004c085c
    mov dword ptr [0x5bb59b], 0x0                # 004c0863
    mov dword ptr [0x5bb59f], 0x0                # 004c086d
    mov dword ptr [0x5bb5a3], 0x1                # 004c0877
    mov dword ptr [0x583999], 0x4                # 004c0881
L_004c088b:
    # block 0x004c088b: entered by jne at 0x004c0812, 5 instruction(s), ends with jne to 0x004c08a9 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c088b
    mov ecx, dword ptr [eax + field_22a]         # 004c088e
    movsx edx, word ptr [ecx + field_23]         # 004c0894
    cmp edx, 0x1                                 # 004c0898
    jne.d8 L_004c08a9                            # 004c089b
    # block 0x004c089d: entered by fall-through of jne at 0x004c089b, 2 instruction(s), ends with forward jump to 0x004c08b3
    mov dword ptr [0x5bb1ca], 0x0                # 004c089d
    jmp.d8 L_004c08b3                            # 004c08a7
L_004c08a9:
    # block 0x004c08a9: entered by jne at 0x004c089b, 1 instruction(s), falls into the block at 0x004c08b3
    mov dword ptr [0x5bb1ca], 0x1                # 004c08a9
L_004c08b3:
    # block 0x004c08b3: entered by jmp at 0x004c08a7, 7 instruction(s), calls FUN_004d36ed, FUN_004bf773, FUN_0042ba3a, falls into the block at 0x004c08cd
    call FUN_004d36ed                            # 004c08b3
    mov ecx, dword ptr [ebp - local_4]           # 004c08b8
    call FUN_004bf773                            # 004c08bb
    mov ax, word ptr [ebp + arg_8]               # 004c08c0
    push eax                                     # 004c08c4
    call FUN_0042ba3a                            # 004c08c5
    add esp, 0x4                                 # 004c08ca
L_004c08cd:
    # block 0x004c08cd: entered by jmp at 0x004c079a, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004c08cd
    pop ebp                                      # 004c08cf
    ret 0x4                                      # 004c08d0

