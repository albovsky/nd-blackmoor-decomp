# FUN_004feea0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004feea0
# extent:       0x004feea0-0x004fef09 (105 code bytes)
# span:         0x004feea0-0x004fef10 (code 105, tables 0, padding 7)
# sha256:       532dd9fdc15a11a564cf399e672421e7679a5a43d6f1edae4c2598051f7f45ad
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004feea0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_44, field_48, field_4c, field_50, field_54; [edx + n] field_4; [esi + n] field_4; [esp + n] stk_10
# callees:      calls FUN_0050e936, FUN_0050ebca
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 46 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050ebca, .text + (0x0050ebca - 0x401000)

.org 0x004feea0 - 0x401000
.globl FUN_004feea0
FUN_004feea0:
    # block 0x004feea0: entry, 8 instruction(s), ends with je to 0x004feed5 (forward)
    push ebp                                     # 004feea0
    push esi                                     # 004feea1
    push edi                                     # 004feea2
    mov edi, dword ptr [esp + stk_10]            # 004feea3
    {load} xor ebp, ebp                          # 004feea7
    mov esi, dword ptr [edi + field_54]          # 004feea9
    {load} cmp esi, ebp                          # 004feeac
    je.d8 L_004feed5                             # 004feeae
    # block 0x004feeb0: entered by fall-through of je at 0x004feeae, 1 instruction(s), falls into the block at 0x004feeb1
    push ebx                                     # 004feeb0
L_004feeb1:
    # block 0x004feeb1: entered by jne at 0x004feed2, 14 instruction(s), calls FUN_0050e936, ends with jne to 0x004feeb1 (backward)
    mov eax, dword ptr [esi]                     # 004feeb1
    mov ebx, dword ptr [esi + field_4]           # 004feeb3
    push eax                                     # 004feeb6
    call FUN_0050e936                            # 004feeb7
    {load} mov edx, esi                          # 004feebc
    {load} xor ecx, ecx                          # 004feebe
    push esi                                     # 004feec0
    mov dword ptr [edx], ecx                     # 004feec1
    mov dword ptr [edx + field_4], ecx           # 004feec3
    call FUN_0050e936                            # 004feec6
    add esp, 0x8                                 # 004feecb
    {load} cmp ebx, ebp                          # 004feece
    {load} mov esi, ebx                          # 004feed0
    jne.d8 L_004feeb1                            # 004feed2
    # block 0x004feed4: entered by fall-through of jne at 0x004feed2, 1 instruction(s), falls into the block at 0x004feed5
    pop ebx                                      # 004feed4
L_004feed5:
    # block 0x004feed5: entered by je at 0x004feeae, 3 instruction(s), ends with je to 0x004feeff (forward)
    mov eax, dword ptr [edi + field_50]          # 004feed5
    {load} cmp eax, ebp                          # 004feed8
    je.d8 L_004feeff                             # 004feeda
    # block 0x004feedc: entered by fall-through of je at 0x004feeda, 13 instruction(s), calls FUN_0050ebca, falls into the block at 0x004feeff
    mov ecx, dword ptr [edi + field_4c]          # 004feedc
    mov edx, dword ptr [edi + field_44]          # 004feedf
    {load} add ecx, eax                          # 004feee2
    push ecx                                     # 004feee4
    push edx                                     # 004feee5
    call FUN_0050ebca                            # 004feee6
    mov ecx, dword ptr [edi + field_4c]          # 004feeeb
    mov dword ptr [edi + field_44], eax          # 004feeee
    mov eax, dword ptr [edi + field_50]          # 004feef1
    add esp, 0x8                                 # 004feef4
    {load} add ecx, eax                          # 004feef7
    mov dword ptr [edi + field_50], ebp          # 004feef9
    mov dword ptr [edi + field_4c], ecx          # 004feefc
L_004feeff:
    # block 0x004feeff: entered by je at 0x004feeda, 6 instruction(s), ends with ret
    mov dword ptr [edi + field_48], ebp          # 004feeff
    mov dword ptr [edi + field_54], ebp          # 004fef02
    pop edi                                      # 004fef05
    pop esi                                      # 004fef06
    pop ebp                                      # 004fef07
    ret                                          # 004fef08

# --- data items (not part of the function) -------------------------
.org 0x004fef09 - 0x401000
PAD_004fef09:  # 7 byte(s) of nop padding
    .fill 7, 1, 0x90

