# FUN_0050a9c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050a9c0
# extent:       0x0050a9c0-0x0050aa2f (111 code bytes)
# span:         0x0050a9c0-0x0050aa30 (code 111, tables 0, padding 1)
# sha256:       d22736345da468e5410633c982307279b4c46cb1cb4d1f3c146122cb67ea7073
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050a9c0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esi + n] field_8, field_18, field_2c; [esp + n] stk_8
# callees:      calls FUN_0050e936, FUN_00506640
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 44 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050aa30
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_18, 0x18  # offset +0x18
.equ field_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_00506640, .text + (0x00506640 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x0050a9c0 - 0x401000
.globl FUN_0050a9c0
FUN_0050a9c0:
    # block 0x0050a9c0: entry, 4 instruction(s), ends with je to 0x0050aa2d (forward)
    push esi                                     # 0050a9c0
    mov esi, dword ptr [esp + stk_8]             # 0050a9c1
    test esi, esi                                # 0050a9c5
    je.d8 L_0050aa2d                             # 0050a9c7
    # block 0x0050a9c9: entered by fall-through of je at 0x0050a9c7, 3 instruction(s), ends with je to 0x0050a9fe (forward)
    mov eax, dword ptr [esi + field_8]           # 0050a9c9
    test eax, eax                                # 0050a9cc
    je.d8 L_0050a9fe                             # 0050a9ce
    # block 0x0050a9d0: entered by fall-through of je at 0x0050a9ce, 3 instruction(s), ends with je to 0x0050a9df (forward)
    mov eax, dword ptr [eax]                     # 0050a9d0
    test eax, eax                                # 0050a9d2
    je.d8 L_0050a9df                             # 0050a9d4
    # block 0x0050a9d6: entered by fall-through of je at 0x0050a9d4, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x0050a9df
    push eax                                     # 0050a9d6
    call FUN_0050e936                            # 0050a9d7
    add esp, 0x4                                 # 0050a9dc
L_0050a9df:
    # block 0x0050a9df: entered by je at 0x0050a9d4, 4 instruction(s), ends with je to 0x0050a9f2 (forward)
    mov eax, dword ptr [esi + field_8]           # 0050a9df
    mov eax, dword ptr [eax + field_4]           # 0050a9e2
    test eax, eax                                # 0050a9e5
    je.d8 L_0050a9f2                             # 0050a9e7
    # block 0x0050a9e9: entered by fall-through of je at 0x0050a9e7, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x0050a9f2
    push eax                                     # 0050a9e9
    call FUN_0050e936                            # 0050a9ea
    add esp, 0x4                                 # 0050a9ef
L_0050a9f2:
    # block 0x0050a9f2: entered by je at 0x0050a9e7, 4 instruction(s), calls FUN_0050e936, falls into the block at 0x0050a9fe
    mov ecx, dword ptr [esi + field_8]           # 0050a9f2
    push ecx                                     # 0050a9f5
    call FUN_0050e936                            # 0050a9f6
    add esp, 0x4                                 # 0050a9fb
L_0050a9fe:
    # block 0x0050a9fe: entered by je at 0x0050a9ce, 3 instruction(s), ends with je to 0x0050aa0e (forward)
    mov eax, dword ptr [esi + field_2c]          # 0050a9fe
    test eax, eax                                # 0050aa01
    je.d8 L_0050aa0e                             # 0050aa03
    # block 0x0050aa05: entered by fall-through of je at 0x0050aa03, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x0050aa0e
    push eax                                     # 0050aa05
    call FUN_0050e936                            # 0050aa06
    add esp, 0x4                                 # 0050aa0b
L_0050aa0e:
    # block 0x0050aa0e: entered by je at 0x0050aa03, 12 instruction(s), calls FUN_00506640, FUN_0050e936, falls into the block at 0x0050aa2d
    lea edx, [esi + field_18]                    # 0050aa0e
    push edi                                     # 0050aa11
    push edx                                     # 0050aa12
    call FUN_00506640                            # 0050aa13
    mov ecx, 0xe                                 # 0050aa18
    {load} xor eax, eax                          # 0050aa1d
    {load} mov edi, esi                          # 0050aa1f
    push esi                                     # 0050aa21
    rep stosd dword ptr es:[edi], eax            # 0050aa22
    call FUN_0050e936                            # 0050aa24
    add esp, 0x8                                 # 0050aa29
    pop edi                                      # 0050aa2c
L_0050aa2d:
    # block 0x0050aa2d: entered by je at 0x0050a9c7, 2 instruction(s), ends with ret
    pop esi                                      # 0050aa2d
    ret                                          # 0050aa2e

# --- data items (not part of the function) -------------------------
.org 0x0050aa2f - 0x401000
PAD_0050aa2f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

