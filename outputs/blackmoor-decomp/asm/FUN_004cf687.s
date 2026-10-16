# FUN_004cf687
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cf687
# extent:       0x004cf687-0x004cf749 (194 code bytes)
# span:         0x004cf687-0x004cf749 (code 194, tables 0, padding 0)
# sha256:       c0e04ebf854e6bfc6576ab2d1699617e96abf7bc41c8e22ee28cc0ef2dd5702a
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cf687
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_172, field_1cc; [ecx + n] field_1cc
# callees:      calls FUN_0044c479, FUN_0041546f, FUN_004156ea, FUN_0044c4ab, KERNEL32.dll!Sleep, FUN_0051ec84
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:avf_player_worker_poll (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 55 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_172, 0x172  # offset +0x172
.equ field_1cc, 0x1cc  # offset +0x1cc

# --- external targets -----------------------------------------------
.set FUN_0041546f, .text + (0x0041546f - 0x401000)
.set FUN_004156ea, .text + (0x004156ea - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)
.set FUN_0051ec84, .text + (0x0051ec84 - 0x401000)

.org 0x004cf687 - 0x401000
.globl FUN_004cf687
FUN_004cf687:
    # block 0x004cf687: entry, 6 instruction(s), falls into the block at 0x004cf69a
    push ebp                                     # 004cf687
    {load} mov ebp, esp                          # 004cf688
    sub esp, 0xc                                 # 004cf68a
    mov eax, dword ptr [ebp + arg_8]             # 004cf68d
    mov dword ptr [ebp - local_4], eax           # 004cf690
    mov dword ptr [ebp - local_8], 0x638225      # 004cf693
L_004cf69a:
    # block 0x004cf69a: entered by jmp at 0x004cf737, 3 instruction(s), ends with je to 0x004cf73c (forward)
    mov ecx, 0x1                                 # 004cf69a
    test ecx, ecx                                # 004cf69f
    je.d32 L_004cf73c                            # 004cf6a1
    # block 0x004cf6a7: entered by fall-through of je at 0x004cf6a1, 3 instruction(s), ends with je to 0x004cf6b4 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cf6a7
    cmp dword ptr [edx], 0x0                     # 004cf6aa
    je.d8 L_004cf6b4                             # 004cf6ad
    # block 0x004cf6af: entered by fall-through of je at 0x004cf6ad, 1 instruction(s), ends with forward jump to 0x004cf73c
    jmp.d32 L_004cf73c                           # 004cf6af
L_004cf6b4:
    # block 0x004cf6b4: entered by je at 0x004cf6ad, 4 instruction(s), ends with je to 0x004cf6c7 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004cf6b4
    movsx ecx, word ptr [eax + field_1cc]        # 004cf6b7
    test ecx, ecx                                # 004cf6be
    je.d8 L_004cf6c7                             # 004cf6c0
    # block 0x004cf6c2: entered by fall-through of je at 0x004cf6c0, 1 instruction(s), ends with forward jump to 0x004cf747
    jmp.d32 L_004cf747                           # 004cf6c2
L_004cf6c7:
    # block 0x004cf6c7: entered by je at 0x004cf6c0, 6 instruction(s), calls FUN_0044c479, ends with jne to 0x004cf6de (forward)
    push 0x638221                                # 004cf6c7
    call FUN_0044c479                            # 004cf6cc
    add esp, 0x4                                 # 004cf6d1
    movsx edx, ax                                # 004cf6d4
    cmp edx, 0x2                                 # 004cf6d7
    jne.d8 L_004cf6de                            # 004cf6da
    # block 0x004cf6dc: entered by fall-through of jne at 0x004cf6da, 1 instruction(s), ends with forward jump to 0x004cf745
    jmp.d8 L_004cf745                            # 004cf6dc
L_004cf6de:
    # block 0x004cf6de: entered by jne at 0x004cf6da, 5 instruction(s), ends with je to 0x004cf6f8 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004cf6de
    mov ecx, dword ptr [eax + field_172]         # 004cf6e1
    mov dword ptr [ebp - local_c], ecx           # 004cf6e7
    cmp dword ptr [ebp - local_c], 0x0           # 004cf6ea
    je.d8 L_004cf6f8                             # 004cf6ee
    # block 0x004cf6f0: entered by fall-through of je at 0x004cf6ee, 2 instruction(s), ends with je to 0x004cf708 (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 004cf6f0
    je.d8 L_004cf708                             # 004cf6f4
    # block 0x004cf6f6: entered by fall-through of je at 0x004cf6f4, 1 instruction(s), ends with forward jump to 0x004cf716
    jmp.d8 L_004cf716                            # 004cf6f6
L_004cf6f8:
    # block 0x004cf6f8: entered by je at 0x004cf6ee, 5 instruction(s), calls FUN_0041546f, ends with forward jump to 0x004cf716
    mov edx, dword ptr [ebp - local_8]           # 004cf6f8
    push edx                                     # 004cf6fb
    mov ecx, 0x5e2dbe                            # 004cf6fc
    call FUN_0041546f                            # 004cf701
    jmp.d8 L_004cf716                            # 004cf706
L_004cf708:
    # block 0x004cf708: entered by je at 0x004cf6f4, 4 instruction(s), calls FUN_004156ea, falls into the block at 0x004cf716
    mov eax, dword ptr [ebp - local_8]           # 004cf708
    push eax                                     # 004cf70b
    mov ecx, 0x5e2dbe                            # 004cf70c
    call FUN_004156ea                            # 004cf711
L_004cf716:
    # block 0x004cf716: entered by jmp at 0x004cf6f6; jmp at 0x004cf706, 5 instruction(s), calls FUN_0044c4ab, falls into the block at 0x004cf72f
    push 0x638221                                # 004cf716
    call FUN_0044c4ab                            # 004cf71b
    add esp, 0x4                                 # 004cf720
    mov ecx, dword ptr [ebp - local_8]           # 004cf723
    mov word ptr [ecx + field_1cc], 0x1          # 004cf726
L_004cf72f:
    # block 0x004cf72f: entered by jmp at 0x004cf745; jmp at 0x004cf747, 3 instruction(s), calls KERNEL32.dll!Sleep, ends with backward jump to 0x004cf69a
    push 0x1                                     # 004cf72f
    call dword ptr [0x52a2b0]                    # 004cf731
    jmp.d32 L_004cf69a                           # 004cf737
L_004cf73c:
    # block 0x004cf73c: entered by je at 0x004cf6a1; jmp at 0x004cf6af, 3 instruction(s), calls FUN_0051ec84, falls into the block at 0x004cf745
    push 0x1                                     # 004cf73c
    push 0x0                                     # 004cf73e
    call FUN_0051ec84                            # 004cf740
L_004cf745:
    # block 0x004cf745: entered by jmp at 0x004cf6dc, 1 instruction(s), ends with backward jump to 0x004cf72f
    jmp.d8 L_004cf72f                            # 004cf745
L_004cf747:
    # block 0x004cf747: entered by jmp at 0x004cf6c2, 1 instruction(s), ends with backward jump to 0x004cf72f
    jmp.d8 L_004cf72f                            # 004cf747

