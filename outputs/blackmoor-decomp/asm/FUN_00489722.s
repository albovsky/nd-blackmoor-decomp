# FUN_00489722
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00489722
# extent:       0x00489722-0x004897cd (171 code bytes)
# span:         0x00489722-0x004897cd (code 171, tables 0, padding 0)
# sha256:       795ab792bb5c319138df6217adf3a789727530b98bbdaae3a67731cb47fb50b6
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m489722_lifted
# naming:       native port src/original_methods_fl41.c:m489722_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 7 seeds; oracle: 47/47 instructions, 10/10 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1c, field_ab2; [ecx + n] field_1c, field_cc; [edx + n] field_1c, field_2c, field_aa2, field_aa4, field_ab0
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m489722_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 47 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_2c, 0x2c  # offset +0x2c
.equ field_cc, 0xcc  # offset +0xcc
.equ field_aa2, 0xaa2  # offset +0xaa2
.equ field_aa4, 0xaa4  # offset +0xaa4
.equ field_ab0, 0xab0  # offset +0xab0
.equ field_ab2, 0xab2  # offset +0xab2

# --- external targets -----------------------------------------------

.org 0x00489722 - 0x401000
.globl FUN_00489722
FUN_00489722:
    # block 0x00489722: entry, 6 instruction(s), ends with forward jump to 0x0048973d
    push ebp                                     # 00489722
    {load} mov ebp, esp                          # 00489723
    sub esp, 0x8                                 # 00489725
    mov dword ptr [ebp - local_8], ecx           # 00489728
    mov dword ptr [ebp - local_4], 0x0           # 0048972b
    jmp.d8 L_0048973d                            # 00489732
L_00489734:
    # block 0x00489734: entered by jmp at 0x004897c4, 3 instruction(s), falls into the block at 0x0048973d
    mov eax, dword ptr [ebp - local_4]           # 00489734
    add eax, 0x1                                 # 00489737
    mov dword ptr [ebp - local_4], eax           # 0048973a
L_0048973d:
    # block 0x0048973d: entered by jmp at 0x00489732, 4 instruction(s), ends with jge to 0x004897c9 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0048973d
    mov edx, dword ptr [ebp - local_4]           # 00489740
    cmp edx, dword ptr [ecx + field_cc]          # 00489743
    jge.d8 L_004897c9                            # 00489749
    # block 0x0048974b: entered by fall-through of jge at 0x00489749, 9 instruction(s), ends with je to 0x004897c4 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0048974b
    mov ecx, dword ptr [ebp - local_4]           # 0048974e
    mov edx, dword ptr [ebp - local_8]           # 00489751
    mov ecx, dword ptr [edx + 4*ecx + field_2c]  # 00489754
    mov dword ptr [eax + field_1c], ecx          # 00489758
    mov edx, dword ptr [ebp - local_8]           # 0048975b
    mov eax, dword ptr [edx + field_1c]          # 0048975e
    cmp dword ptr [eax + field_ab2], 0x0         # 00489761
    je.d8 L_004897c4                             # 00489768
    # block 0x0048976a: entered by fall-through of je at 0x00489768, 6 instruction(s), ends with jne to 0x004897c4 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0048976a
    mov edx, dword ptr [ecx + field_1c]          # 0048976d
    movsx eax, word ptr [edx + field_ab0]        # 00489770
    imul eax, eax, 0x8d                          # 00489777
    cmp dword ptr [eax + 0x5bb632], 0x1          # 0048977d
    jne.d8 L_004897c4                            # 00489784
    # block 0x00489786: entered by fall-through of jne at 0x00489784, 5 instruction(s), ends with je to 0x004897c4 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00489786
    mov edx, dword ptr [ecx + field_1c]          # 00489789
    movsx eax, word ptr [edx + field_aa2]        # 0048978c
    cmp eax, -0x1                                # 00489793
    je.d8 L_004897c4                             # 00489796
    # block 0x00489798: entered by fall-through of je at 0x00489796, 5 instruction(s), ends with je to 0x004897c4 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00489798
    mov edx, dword ptr [ecx + field_1c]          # 0048979b
    movsx eax, word ptr [edx + field_aa4]        # 0048979e
    cmp eax, -0x1                                # 004897a5
    je.d8 L_004897c4                             # 004897a8
    # block 0x004897aa: entered by fall-through of je at 0x004897a8, 5 instruction(s), falls into the block at 0x004897c4
    mov ecx, dword ptr [ebp - local_8]           # 004897aa
    mov edx, dword ptr [ecx + field_1c]          # 004897ad
    movsx eax, word ptr [edx + field_aa2]        # 004897b0
    imul eax, eax, 0x4a                          # 004897b7
    mov dword ptr [eax + 0x5d15a5], 0x1          # 004897ba
L_004897c4:
    # block 0x004897c4: entered by je at 0x00489768; jne at 0x00489784; je at 0x00489796; je at 0x004897a8, 1 instruction(s), ends with backward jump to 0x00489734
    jmp.d32 L_00489734                           # 004897c4
L_004897c9:
    # block 0x004897c9: entered by jge at 0x00489749, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004897c9
    pop ebp                                      # 004897cb
    ret                                          # 004897cc

