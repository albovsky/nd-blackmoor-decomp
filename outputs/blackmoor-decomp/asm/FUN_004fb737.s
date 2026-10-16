# FUN_004fb737
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fb737
# extent:       0x004fb737-0x004fb77a (67 code bytes)
# span:         0x004fb737-0x004fb77a (code 67, tables 0, padding 0)
# sha256:       d5c6c23e8659da5e8e520e0b8fdb022cf072da7e3b9e7631431621fd35d3d21c
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fb737
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fc808
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_004fc808, .text + (0x004fc808 - 0x401000)

.org 0x004fb737 - 0x401000
.globl FUN_004fb737
FUN_004fb737:
    # block 0x004fb737: entry, 6 instruction(s), ends with forward jump to 0x004fb754
    push ebp                                     # 004fb737
    {load} mov ebp, esp                          # 004fb738
    sub esp, 0x8                                 # 004fb73a
    mov dword ptr [ebp - local_8], ecx           # 004fb73d
    mov word ptr [ebp - local_4], 0x0            # 004fb740
    jmp.d8 L_004fb754                            # 004fb746
L_004fb748:
    # block 0x004fb748: entered by jmp at 0x004fb774, 3 instruction(s), falls into the block at 0x004fb754
    mov ax, word ptr [ebp - local_4]             # 004fb748
    .insn 0x66, 0x05, 0x0001{:u16}               # 004fb74c
    mov word ptr [ebp - local_4], ax             # 004fb750
L_004fb754:
    # block 0x004fb754: entered by jmp at 0x004fb746, 3 instruction(s), ends with jge to 0x004fb776 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004fb754
    cmp ecx, 0x3                                 # 004fb758
    jge.d8 L_004fb776                            # 004fb75b
    # block 0x004fb75d: entered by fall-through of jge at 0x004fb75b, 7 instruction(s), calls FUN_004fc808, ends with backward jump to 0x004fb748
    movsx edx, word ptr [ebp - local_4]          # 004fb75d
    imul edx, edx, 0x2f                          # 004fb761
    mov ax, word ptr [edx + 0x583381]            # 004fb764
    push eax                                     # 004fb76b
    mov ecx, dword ptr [ebp - local_8]           # 004fb76c
    call FUN_004fc808                            # 004fb76f
    jmp.d8 L_004fb748                            # 004fb774
L_004fb776:
    # block 0x004fb776: entered by jge at 0x004fb75b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004fb776
    pop ebp                                      # 004fb778
    ret                                          # 004fb779

