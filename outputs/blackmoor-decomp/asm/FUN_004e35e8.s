# FUN_004e35e8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e35e8
# extent:       0x004e35e8-0x004e364a (98 code bytes)
# span:         0x004e35e8-0x004e364a (code 98, tables 0, padding 0)
# sha256:       5e405691bd12eea3f1d608050f6ffce3279236d58388fb7ee97dcdfcdc034c0b
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e35e8_lifted
# naming:       native port src/original_methods_fl41.c:m4e35e8_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 6 seeds; oracle: 29/29 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1ca2
# callees:      calls FUN_004e2940
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4e35e8_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1ca2, 0x1ca2  # offset +0x1ca2

# --- external targets -----------------------------------------------
.set FUN_004e2940, .text + (0x004e2940 - 0x401000)

.org 0x004e35e8 - 0x401000
.globl FUN_004e35e8
FUN_004e35e8:
    # block 0x004e35e8: entry, 6 instruction(s), ends with je to 0x004e360c (forward)
    push ebp                                     # 004e35e8
    {load} mov ebp, esp                          # 004e35e9
    sub esp, 0x8                                 # 004e35eb
    mov dword ptr [ebp - local_8], ecx           # 004e35ee
    cmp dword ptr [0x5a1e58], 0x0                # 004e35f1
    je.d8 L_004e360c                             # 004e35f8
    # block 0x004e35fa: entered by fall-through of je at 0x004e35f8, 5 instruction(s), calls FUN_004e2940, ends with forward jump to 0x004e3646
    push 0x0                                     # 004e35fa
    mov ecx, dword ptr [ebp - local_8]           # 004e35fc
    add ecx, 0x30e5                              # 004e35ff
    call FUN_004e2940                            # 004e3605
    jmp.d8 L_004e3646                            # 004e360a
L_004e360c:
    # block 0x004e360c: entered by je at 0x004e35f8, 2 instruction(s), ends with forward jump to 0x004e3620
    mov word ptr [ebp - local_4], 0x0            # 004e360c
    jmp.d8 L_004e3620                            # 004e3612
L_004e3614:
    # block 0x004e3614: entered by jmp at 0x004e3644, 3 instruction(s), falls into the block at 0x004e3620
    mov ax, word ptr [ebp - local_4]             # 004e3614
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e3618
    mov word ptr [ebp - local_4], ax             # 004e361c
L_004e3620:
    # block 0x004e3620: entered by jmp at 0x004e3612, 3 instruction(s), ends with jg to 0x004e3646 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004e3620
    cmp ecx, 0xf                                 # 004e3624
    jg.d8 L_004e3646                             # 004e3627
    # block 0x004e3629: entered by fall-through of jg at 0x004e3627, 7 instruction(s), calls FUN_004e2940, ends with backward jump to 0x004e3614
    push 0x0                                     # 004e3629
    movsx edx, word ptr [ebp - local_4]          # 004e362b
    imul edx, edx, 0x18f                         # 004e362f
    mov eax, dword ptr [ebp - local_8]           # 004e3635
    lea ecx, [eax + edx + field_1ca2]            # 004e3638
    call FUN_004e2940                            # 004e363f
    jmp.d8 L_004e3614                            # 004e3644
L_004e3646:
    # block 0x004e3646: entered by jmp at 0x004e360a; jg at 0x004e3627, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e3646
    pop ebp                                      # 004e3648
    ret                                          # 004e3649

