# FUN_004fee30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fee30
# extent:       0x004fee30-0x004fee9c (108 code bytes)
# span:         0x004fee30-0x004feea0 (code 108, tables 0, padding 4)
# sha256:       c43fc6bff2428303f11b81ce62cf7345c2a917ada3586093ae55b063a76c31f2
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fee30
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_7; [esi + n] field_44, field_48, field_4c, field_50, field_54; [esp + n] stk_8
# callees:      calls FUN_0050ea90
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 40 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_7, 0x7  # offset +0x7
.equ stk_8, 0x8  # offset +0x8
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54

# --- external targets -----------------------------------------------
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x004fee30 - 0x401000
.globl FUN_004fee30
FUN_004fee30:
    # block 0x004fee30: entry, 11 instruction(s), ends with jle to 0x004fee8c (forward)
    mov eax, dword ptr [esp + stk_8]             # 004fee30
    push esi                                     # 004fee34
    mov esi, dword ptr [esp + stk_8]             # 004fee35
    push edi                                     # 004fee39
    lea edi, [eax + field_7]                     # 004fee3a
    mov ecx, dword ptr [esi + field_48]          # 004fee3d
    mov eax, dword ptr [esi + field_4c]          # 004fee40
    and edi, -0x8                                # 004fee43
    {load} add ecx, edi                          # 004fee46
    {load} cmp ecx, eax                          # 004fee48
    jle.d8 L_004fee8c                            # 004fee4a
    # block 0x004fee4c: entered by fall-through of jle at 0x004fee4a, 3 instruction(s), ends with je to 0x004fee76 (forward)
    mov eax, dword ptr [esi + field_44]          # 004fee4c
    test eax, eax                                # 004fee4f
    je.d8 L_004fee76                             # 004fee51
    # block 0x004fee53: entered by fall-through of je at 0x004fee51, 12 instruction(s), calls FUN_0050ea90, falls into the block at 0x004fee76
    push 0x8                                     # 004fee53
    call FUN_0050ea90                            # 004fee55
    mov edx, dword ptr [esi + field_48]          # 004fee5a
    mov ecx, dword ptr [esi + field_50]          # 004fee5d
    add esp, 0x4                                 # 004fee60
    {load} add ecx, edx                          # 004fee63
    mov dword ptr [esi + field_50], ecx          # 004fee65
    mov ecx, dword ptr [esi + field_54]          # 004fee68
    mov dword ptr [eax + field_4], ecx           # 004fee6b
    mov edx, dword ptr [esi + field_44]          # 004fee6e
    mov dword ptr [eax], edx                     # 004fee71
    mov dword ptr [esi + field_54], eax          # 004fee73
L_004fee76:
    # block 0x004fee76: entered by je at 0x004fee51, 6 instruction(s), calls FUN_0050ea90, falls into the block at 0x004fee8c
    push edi                                     # 004fee76
    mov dword ptr [esi + field_4c], edi          # 004fee77
    call FUN_0050ea90                            # 004fee7a
    add esp, 0x4                                 # 004fee7f
    mov dword ptr [esi + field_44], eax          # 004fee82
    mov dword ptr [esi + field_48], 0x0          # 004fee85
L_004fee8c:
    # block 0x004fee8c: entered by jle at 0x004fee4a, 8 instruction(s), ends with ret
    mov ecx, dword ptr [esi + field_48]          # 004fee8c
    mov eax, dword ptr [esi + field_44]          # 004fee8f
    {load} add eax, ecx                          # 004fee92
    {load} add ecx, edi                          # 004fee94
    mov dword ptr [esi + field_48], ecx          # 004fee96
    pop edi                                      # 004fee99
    pop esi                                      # 004fee9a
    ret                                          # 004fee9b

# --- data items (not part of the function) -------------------------
.org 0x004fee9c - 0x401000
PAD_004fee9c:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

