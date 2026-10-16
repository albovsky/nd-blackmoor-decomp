# FUN_004fb2e3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fb2e3
# extent:       0x004fb2e3-0x004fb397 (180 code bytes)
# span:         0x004fb2e3-0x004fb397 (code 180, tables 0, padding 0)
# sha256:       ed3fa0d31231e810539fda23128c0e4955d0a704ad0f126cb7101240fe04c9d3
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fb2e3
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_132
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004f6059, FUN_004fa2a8
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:sound_start (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 48 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_132, 0x132  # offset +0x132

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f6059, .text + (0x004f6059 - 0x401000)
.set FUN_004fa2a8, .text + (0x004fa2a8 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004fb2e3 - 0x401000
.globl FUN_004fb2e3
FUN_004fb2e3:
    # block 0x004fb2e3: entry, 7 instruction(s), ends with je to 0x004fb31e (forward)
    push ebp                                     # 004fb2e3
    {load} mov ebp, esp                          # 004fb2e4
    push ecx                                     # 004fb2e6
    mov dword ptr [ebp - local_4], ecx           # 004fb2e7
    movsx eax, word ptr [0x63a4cd]               # 004fb2ea
    test eax, eax                                # 004fb2f1
    je.d8 L_004fb31e                             # 004fb2f3
    # block 0x004fb2f5: entered by fall-through of je at 0x004fb2f3, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fb31e
    mov ecx, dword ptr [ebp + arg_8]             # 004fb2f5
    and ecx, 0xffff                              # 004fb2f8
    push ecx                                     # 004fb2fe
    push 0x560794                                # 004fb2ff
    push 0x63888b                                # 004fb304
    call FUN_0050ca3e                            # 004fb309
    add esp, 0xc                                 # 004fb30e
    push 0x63888b                                # 004fb311
    call FUN_0044a2b7                            # 004fb316
    add esp, 0x4                                 # 004fb31b
L_004fb31e:
    # block 0x004fb31e: entered by je at 0x004fb2f3, 7 instruction(s), calls FUN_004f6059, ends with jne to 0x004fb375 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004fb31e
    and edx, 0xffff                              # 004fb321
    push edx                                     # 004fb327
    mov ecx, 0x5cf1eb                            # 004fb328
    call FUN_004f6059                            # 004fb32d
    test eax, eax                                # 004fb332
    jne.d8 L_004fb375                            # 004fb334
    # block 0x004fb336: entered by fall-through of jne at 0x004fb334, 3 instruction(s), ends with je to 0x004fb375 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004fb336
    test eax, eax                                # 004fb33d
    je.d8 L_004fb375                             # 004fb33f
    # block 0x004fb341: entered by fall-through of je at 0x004fb33f, 13 instruction(s), calls FUN_004fa2a8, FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fb375
    mov ecx, 0x5cf1eb                            # 004fb341
    call FUN_004fa2a8                            # 004fb346
    push eax                                     # 004fb34b
    mov ecx, dword ptr [ebp + arg_8]             # 004fb34c
    and ecx, 0xffff                              # 004fb34f
    push ecx                                     # 004fb355
    push 0x5607c4                                # 004fb356
    push 0x63888b                                # 004fb35b
    call FUN_0050ca3e                            # 004fb360
    add esp, 0x10                                # 004fb365
    push 0x63888b                                # 004fb368
    call FUN_0044a2b7                            # 004fb36d
    add esp, 0x4                                 # 004fb372
L_004fb375:
    # block 0x004fb375: entered by jne at 0x004fb334; je at 0x004fb33f, 8 instruction(s), ends with ret 0x4
    mov edx, dword ptr [ebp + arg_8]             # 004fb375
    and edx, 0xffff                              # 004fb378
    imul edx, edx, 0x5bb                         # 004fb37e
    mov eax, dword ptr [ebp - local_4]           # 004fb384
    mov word ptr [eax + edx + field_132], 0x1    # 004fb387
    {load} mov esp, ebp                          # 004fb391
    pop ebp                                      # 004fb393
    ret 0x4                                      # 004fb394

