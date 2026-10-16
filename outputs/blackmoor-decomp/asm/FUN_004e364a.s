# FUN_004e364a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e364a
# extent:       0x004e364a-0x004e3691 (71 code bytes)
# span:         0x004e364a-0x004e3691 (code 71, tables 0, padding 0)
# sha256:       9ce367d7e154c44d8ca6cce237b62d0ac902032c1d3a79a97f89dd14d993a74b
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e364a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1ca2
# callees:      calls FUN_004e2940
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1ca2, 0x1ca2  # offset +0x1ca2

# --- external targets -----------------------------------------------
.set FUN_004e2940, .text + (0x004e2940 - 0x401000)

.org 0x004e364a - 0x401000
.globl FUN_004e364a
FUN_004e364a:
    # block 0x004e364a: entry, 6 instruction(s), ends with forward jump to 0x004e3667
    push ebp                                     # 004e364a
    {load} mov ebp, esp                          # 004e364b
    sub esp, 0x8                                 # 004e364d
    mov dword ptr [ebp - local_8], ecx           # 004e3650
    mov word ptr [ebp - local_4], 0x10           # 004e3653
    jmp.d8 L_004e3667                            # 004e3659
L_004e365b:
    # block 0x004e365b: entered by jmp at 0x004e368b, 3 instruction(s), falls into the block at 0x004e3667
    mov ax, word ptr [ebp - local_4]             # 004e365b
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e365f
    mov word ptr [ebp - local_4], ax             # 004e3663
L_004e3667:
    # block 0x004e3667: entered by jmp at 0x004e3659, 3 instruction(s), ends with jg to 0x004e368d (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004e3667
    cmp ecx, 0x19                                # 004e366b
    jg.d8 L_004e368d                             # 004e366e
    # block 0x004e3670: entered by fall-through of jg at 0x004e366e, 7 instruction(s), calls FUN_004e2940, ends with backward jump to 0x004e365b
    push 0x4                                     # 004e3670
    movsx edx, word ptr [ebp - local_4]          # 004e3672
    imul edx, edx, 0x18f                         # 004e3676
    mov eax, dword ptr [ebp - local_8]           # 004e367c
    lea ecx, [eax + edx + field_1ca2]            # 004e367f
    call FUN_004e2940                            # 004e3686
    jmp.d8 L_004e365b                            # 004e368b
L_004e368d:
    # block 0x004e368d: entered by jg at 0x004e366e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e368d
    pop ebp                                      # 004e368f
    ret                                          # 004e3690

