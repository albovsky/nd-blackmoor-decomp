# FUN_00510eda
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510eda
# extent:       0x00510eda-0x00510f3b (97 code bytes)
# span:         0x00510eda-0x00510f3b (code 97, tables 0, padding 0)
# sha256:       96042a017df2c27d1cf65ad98aaea9b611931e858b611906a5551896ef369d51
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510eda
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       2 ebp-relative slot(s): local_4, local_18
# fields:       [eax + n] field_60
# callees:      calls FUN_00510dd3, LOC_00510f36, tail jump FUN_00516650; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         unreachable_code_entry:0x00510f22
# note:         unreachable_code_entry:0x00510f26
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_18, 0x18  # offset -0x18
.equ field_60, 0x60  # offset +0x60

# --- external targets -----------------------------------------------
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)
.set FUN_00516650, .text + (0x00516650 - 0x401000)

.org 0x00510eda - 0x401000
.globl FUN_00510eda
FUN_00510eda:
    # block 0x00510eda: entry, 19 instruction(s), calls FUN_00510dd3, ends with je to 0x00510f2d (forward)
    push ebp                                     # 00510eda
    {load} mov ebp, esp                          # 00510edb
    push -0x1                                    # 00510edd
    push 0x530408                                # 00510edf
    push 0x511930                                # 00510ee4
    mov eax, dword ptr fs:[0x0]                  # 00510ee9
    push eax                                     # 00510eef
    mov dword ptr fs:[0x0], esp                  # 00510ef0
    push ecx                                     # 00510ef7
    push ecx                                     # 00510ef8
    push ebx                                     # 00510ef9
    push esi                                     # 00510efa
    push edi                                     # 00510efb
    mov dword ptr [ebp - local_18], esp          # 00510efc
    {load} xor esi, esi                          # 00510eff
    mov dword ptr [ebp - local_4], esi           # 00510f01
    call FUN_00510dd3                            # 00510f04
    cmp dword ptr [eax + field_60], esi          # 00510f09
    je.d8 L_00510f2d                             # 00510f0c
    # block 0x00510f0e: entered by fall-through of je at 0x00510f0c, 5 instruction(s), calls FUN_00510dd3, indirect dword ptr [eax + 0x60], ends with forward jump to 0x00510f2d
    mov dword ptr [ebp - local_4], 0x1           # 00510f0e
    call FUN_00510dd3                            # 00510f15
    call dword ptr [eax + field_60]              # 00510f1a
    mov dword ptr [ebp - local_4], esi           # 00510f1d
    jmp.d8 L_00510f2d                            # 00510f20
    # block 0x00510f22: entered by follows jmp at 0x00510f20, 3 instruction(s), ends with ret
    push 0x1                                     # 00510f22
    pop eax                                      # 00510f24
    ret                                          # 00510f25
    # block 0x00510f26: entered by follows ret at 0x00510f25, 2 instruction(s), falls into the block at 0x00510f2d
    mov esp, dword ptr [ebp - local_18]          # 00510f26
    and dword ptr [ebp - local_4], 0x0           # 00510f29
L_00510f2d:
    # block 0x00510f2d: entered by je at 0x00510f0c; jmp at 0x00510f20, 2 instruction(s), calls LOC_00510f36, falls into the block at 0x00510f36
    or dword ptr [ebp - local_4], -0x1           # 00510f2d
    call L_00510f36                              # 00510f31
L_00510f36:
    # block 0x00510f36: entered by fall-through, 1 instruction(s), ends with forward jump to 0x00516650
    jmp.d32 FUN_00516650                         # 00510f36

