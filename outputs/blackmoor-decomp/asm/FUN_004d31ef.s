# FUN_004d31ef
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d31ef
# extent:       0x004d31ef-0x004d335c (365 code bytes)
# span:         0x004d31ef-0x004d335c (code 365, tables 0, padding 0)
# sha256:       01554ec6db9e6077c113183d773c0868df4b97c960645b6bc2c39ea1a9ec5306
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d31ef
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ce04, FUN_004ee673
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 90 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004ee673, .text + (0x004ee673 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004d31ef - 0x401000
.globl FUN_004d31ef
FUN_004d31ef:
    # block 0x004d31ef: entry, 7 instruction(s), ends with je to 0x004d320a (forward)
    push ebp                                     # 004d31ef
    {load} mov ebp, esp                          # 004d31f0
    sub esp, 0x28                                # 004d31f2
    movsx eax, word ptr [ebp + arg_8]            # 004d31f5
    mov dword ptr [ebp - local_c], eax           # 004d31f9
    cmp dword ptr [ebp - local_c], 0x1           # 004d31fc
    je.d8 L_004d320a                             # 004d3200
    # block 0x004d3202: entered by fall-through of je at 0x004d3200, 2 instruction(s), ends with je to 0x004d3240 (forward)
    cmp dword ptr [ebp - local_c], 0x2           # 004d3202
    je.d8 L_004d3240                             # 004d3206
    # block 0x004d3208: entered by fall-through of je at 0x004d3206, 1 instruction(s), ends with forward jump to 0x004d3270
    jmp.d8 L_004d3270                            # 004d3208
L_004d320a:
    # block 0x004d320a: entered by je at 0x004d3200, 13 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004d3270
    mov ecx, dword ptr [0x5b0a1e]                # 004d320a
    sub ecx, dword ptr [0x5b0a16]                # 004d3210
    add ecx, 0x1                                 # 004d3216
    mov dword ptr [ebp - local_10], ecx          # 004d3219
    fild dword ptr [ebp - local_10]              # 004d321c
    fstp dword ptr [ebp - local_14]              # 004d321f
    fld dword ptr [0x5b15d0]                     # 004d3222
    fmul dword ptr [ebp - local_14]              # 004d3228
    call FUN_0050ce04                            # 004d322b
    mov edx, dword ptr [0x5b0a82]                # 004d3230
    {load} sub edx, eax                          # 004d3236
    mov dword ptr [0x5b0a82], edx                # 004d3238
    jmp.d8 L_004d3270                            # 004d323e
L_004d3240:
    # block 0x004d3240: entered by je at 0x004d3206, 11 instruction(s), calls FUN_0050ce04, falls into the block at 0x004d3270
    mov eax, dword ptr [0x5b0a1e]                # 004d3240
    sub eax, dword ptr [0x5b0a16]                # 004d3245
    mov dword ptr [ebp - local_18], eax          # 004d324b
    fild dword ptr [ebp - local_18]              # 004d324e
    fstp dword ptr [ebp - local_1c]              # 004d3251
    fld dword ptr [0x5b15d0]                     # 004d3254
    fmul dword ptr [ebp - local_1c]              # 004d325a
    call FUN_0050ce04                            # 004d325d
    mov ecx, dword ptr [0x5b0a82]                # 004d3262
    {load} add ecx, eax                          # 004d3268
    mov dword ptr [0x5b0a82], ecx                # 004d326a
L_004d3270:
    # block 0x004d3270: entered by jmp at 0x004d3208; jmp at 0x004d323e, 3 instruction(s), ends with jge to 0x004d328a (forward)
    mov edx, dword ptr [0x5b0a82]                # 004d3270
    cmp edx, dword ptr [0x5b0a26]                # 004d3276
    jge.d8 L_004d328a                            # 004d327c
    # block 0x004d327e: entered by fall-through of jge at 0x004d327c, 3 instruction(s), ends with forward jump to 0x004d32ec
    mov eax, dword ptr [0x5b0a26]                # 004d327e
    mov dword ptr [0x5b0a82], eax                # 004d3283
    jmp.d8 L_004d32ec                            # 004d3288
L_004d328a:
    # block 0x004d328a: entered by jge at 0x004d327c, 6 instruction(s), ends with jle to 0x004d32c1 (forward)
    mov ecx, dword ptr [0x5b0a1e]                # 004d328a
    sub ecx, dword ptr [0x5b0a16]                # 004d3290
    mov edx, dword ptr [0x5b0a82]                # 004d3296
    {load} add edx, ecx                          # 004d329c
    cmp edx, dword ptr [0x5b0a2e]                # 004d329e
    jle.d8 L_004d32c1                            # 004d32a4
    # block 0x004d32a6: entered by fall-through of jle at 0x004d32a4, 6 instruction(s), ends with forward jump to 0x004d32ec
    mov eax, dword ptr [0x5b0a1e]                # 004d32a6
    sub eax, dword ptr [0x5b0a16]                # 004d32ab
    mov ecx, dword ptr [0x5b0a2e]                # 004d32b1
    {load} sub ecx, eax                          # 004d32b7
    mov dword ptr [0x5b0a82], ecx                # 004d32b9
    jmp.d8 L_004d32ec                            # 004d32bf
L_004d32c1:
    # block 0x004d32c1: entered by jle at 0x004d32a4, 5 instruction(s), ends with jl to 0x004d32ec (forward)
    movsx edx, word ptr [0x5b0a7c]               # 004d32c1
    mov eax, dword ptr [0x5b0a26]                # 004d32c8
    {load} add eax, edx                          # 004d32cd
    cmp dword ptr [0x5b0a82], eax                # 004d32cf
    jl.d8 L_004d32ec                             # 004d32d5
    # block 0x004d32d7: entered by fall-through of jl at 0x004d32d5, 4 instruction(s), falls into the block at 0x004d32ec
    movsx ecx, word ptr [0x5b0a7c]               # 004d32d7
    mov edx, dword ptr [0x5b0a26]                # 004d32de
    {load} add edx, ecx                          # 004d32e4
    mov dword ptr [0x5b0a82], edx                # 004d32e6
L_004d32ec:
    # block 0x004d32ec: entered by jmp at 0x004d3288; jmp at 0x004d32bf; jl at 0x004d32d5, 7 instruction(s), ends with jle to 0x004d3332 (forward)
    mov eax, dword ptr [0x5b0a1e]                # 004d32ec
    sub eax, dword ptr [0x5b0a16]                # 004d32f1
    mov ecx, dword ptr [0x5b0a82]                # 004d32f7
    {load} add ecx, eax                          # 004d32fd
    mov dword ptr [0x5b0a8a], ecx                # 004d32ff
    cmp dword ptr [0x5b0a82], 0x0                # 004d3305
    jle.d8 L_004d3332                            # 004d330c
    # block 0x004d330e: entered by fall-through of jle at 0x004d330c, 10 instruction(s), ends with forward jump to 0x004d3339
    fild dword ptr [0x5b0a82]                    # 004d330e
    fstp dword ptr [ebp - local_20]              # 004d3314
    movsx edx, word ptr [0x5b0a7c]               # 004d3317
    mov dword ptr [ebp - local_24], edx          # 004d331e
    fild dword ptr [ebp - local_24]              # 004d3321
    fstp dword ptr [ebp - local_28]              # 004d3324
    fld dword ptr [ebp - local_20]               # 004d3327
    fdiv dword ptr [ebp - local_28]              # 004d332a
    fstp dword ptr [ebp - local_4]               # 004d332d
    jmp.d8 L_004d3339                            # 004d3330
L_004d3332:
    # block 0x004d3332: entered by jle at 0x004d330c, 1 instruction(s), falls into the block at 0x004d3339
    mov dword ptr [ebp - local_4], 0x0           # 004d3332
L_004d3339:
    # block 0x004d3339: entered by jmp at 0x004d3330, 11 instruction(s), calls FUN_0050ce04, FUN_004ee673, ends with ret
    fld dword ptr [ebp - local_4]                # 004d3339
    fmul dword ptr [0x52cbec]                    # 004d333c
    call FUN_0050ce04                            # 004d3342
    mov dword ptr [ebp - local_8], eax           # 004d3347
    mov eax, dword ptr [ebp - local_8]           # 004d334a
    push eax                                     # 004d334d
    mov ecx, 0x582711                            # 004d334e
    call FUN_004ee673                            # 004d3353
    {load} mov esp, ebp                          # 004d3358
    pop ebp                                      # 004d335a
    ret                                          # 004d335b

