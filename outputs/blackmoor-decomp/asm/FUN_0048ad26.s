# FUN_0048ad26
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048ad26
# extent:       0x0048ad26-0x0048ae05 (223 code bytes)
# span:         0x0048ad26-0x0048ae05 (code 223, tables 0, padding 0)
# sha256:       979e2ced1fa46b853c1f8084f97193995ba2fe76cfab355ecf1b3ff706008fe3
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48ad26_lifted
# naming:       native port src/original_methods_fl41.c:m48ad26_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 6 seeds; oracle: 64/64 instructions, 8/8 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1e, field_42, field_1a6, field_396; [ecx + n] field_21, field_2e, field_44; [edx + n] field_24, field_4e
# callees:      calls FUN_004f6334, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m48ad26_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 64 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_24, 0x24  # offset +0x24
.equ field_2e, 0x2e  # offset +0x2e
.equ field_42, 0x42  # offset +0x42
.equ field_44, 0x44  # offset +0x44
.equ field_4e, 0x4e  # offset +0x4e
.equ field_1a6, 0x1a6  # offset +0x1a6
.equ field_396, 0x396  # offset +0x396

# --- external targets -----------------------------------------------
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0048ad26 - 0x401000
.globl FUN_0048ad26
FUN_0048ad26:
    # block 0x0048ad26: entry, 13 instruction(s), ends with forward jump to 0x0048ad59
    push ebp                                     # 0048ad26
    {load} mov ebp, esp                          # 0048ad27
    sub esp, 0x10                                # 0048ad29
    push esi                                     # 0048ad2c
    push edi                                     # 0048ad2d
    mov dword ptr [ebp - local_10], ecx          # 0048ad2e
    mov eax, dword ptr [ebp - local_10]          # 0048ad31
    movsx ecx, word ptr [eax + field_1e]         # 0048ad34
    imul ecx, ecx, 0x8d                          # 0048ad38
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048ad3e
    mov dword ptr [ebp - local_8], edx           # 0048ad44
    mov dword ptr [ebp - local_4], 0x0           # 0048ad47
    jmp.d8 L_0048ad59                            # 0048ad4e
L_0048ad50:
    # block 0x0048ad50: entered by jmp at 0x0048ad7d, 3 instruction(s), falls into the block at 0x0048ad59
    mov eax, dword ptr [ebp - local_4]           # 0048ad50
    add eax, 0x1                                 # 0048ad53
    mov dword ptr [ebp - local_4], eax           # 0048ad56
L_0048ad59:
    # block 0x0048ad59: entered by jmp at 0x0048ad4e, 5 instruction(s), ends with jge to 0x0048ad7f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0048ad59
    {load} xor edx, edx                          # 0048ad5c
    mov dl, byte ptr [ecx + field_21]            # 0048ad5e
    cmp dword ptr [ebp - local_4], edx           # 0048ad61
    jge.d8 L_0048ad7f                            # 0048ad64
    # block 0x0048ad66: entered by fall-through of jge at 0x0048ad64, 7 instruction(s), ends with backward jump to 0x0048ad50
    mov eax, dword ptr [ebp - local_4]           # 0048ad66
    mov ecx, dword ptr [ebp - local_10]          # 0048ad69
    mov word ptr [ecx + 2*eax + field_2e], 0xffff # 0048ad6c
    mov edx, dword ptr [ebp - local_10]          # 0048ad73
    add edx, dword ptr [ebp - local_4]           # 0048ad76
    mov byte ptr [edx + field_24], 0x0           # 0048ad79
    jmp.d8 L_0048ad50                            # 0048ad7d
L_0048ad7f:
    # block 0x0048ad7f: entered by jge at 0x0048ad64, 10 instruction(s), ends with je to 0x0048adff (forward)
    mov eax, dword ptr [ebp - local_10]          # 0048ad7f
    mov word ptr [eax + field_42], 0x0           # 0048ad82
    mov ecx, dword ptr [ebp - local_10]          # 0048ad88
    mov dword ptr [ecx + field_44], 0x0          # 0048ad8b
    mov edx, dword ptr [ebp - local_10]          # 0048ad92
    mov dword ptr [edx + field_4e], 0x1          # 0048ad95
    mov eax, dword ptr [ebp - local_10]          # 0048ad9c
    mov dword ptr [eax + field_1a6], 0x1         # 0048ad9f
    cmp dword ptr [0x5bb1ca], 0x0                # 0048ada9
    je.d8 L_0048adff                             # 0048adb0
    # block 0x0048adb2: entered by fall-through of je at 0x0048adb0, 7 instruction(s), ends with je to 0x0048adff (forward)
    mov edi, 0x54e370                            # 0048adb2
    mov esi, dword ptr [ebp - local_8]           # 0048adb7
    add esi, 0x375                               # 0048adba
    mov ecx, 0x9                                 # 0048adc0
    {load} xor edx, edx                          # 0048adc5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048adc7
    je.d8 L_0048adff                             # 0048adc9
    # block 0x0048adcb: entered by fall-through of je at 0x0048adc9, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0048adff (forward)
    mov eax, dword ptr [ebp - local_8]           # 0048adcb
    movsx ecx, word ptr [eax + field_396]        # 0048adce
    mov dword ptr [ebp - local_c], ecx           # 0048add5
    mov edx, dword ptr [ebp - local_c]           # 0048add8
    push edx                                     # 0048addb
    mov ecx, 0x5cf1eb                            # 0048addc
    call FUN_004f6334                            # 0048ade1
    test eax, eax                                # 0048ade6
    jne.d8 L_0048adff                            # 0048ade8
    # block 0x0048adea: entered by fall-through of jne at 0x0048ade8, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0048adff
    mov eax, dword ptr [ebp - local_8]           # 0048adea
    mov cx, word ptr [eax + field_396]           # 0048aded
    push ecx                                     # 0048adf4
    mov ecx, 0x5c3a67                            # 0048adf5
    call FUN_004fb2e3                            # 0048adfa
L_0048adff:
    # block 0x0048adff: entered by je at 0x0048adb0; je at 0x0048adc9; jne at 0x0048ade8, 5 instruction(s), ends with ret
    pop edi                                      # 0048adff
    pop esi                                      # 0048ae00
    {load} mov esp, ebp                          # 0048ae01
    pop ebp                                      # 0048ae03
    ret                                          # 0048ae04

