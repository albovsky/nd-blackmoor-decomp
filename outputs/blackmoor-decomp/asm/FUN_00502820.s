# FUN_00502820
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00502820
# extent:       0x00502820-0x005028e1 (193 code bytes)
# span:         0x00502820-0x005028f0 (code 193, tables 0, padding 15)
# sha256:       883a9b247444499e989b6d1844d39126a1f3a5d05c39856ba3a80abef722b81e
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00502820
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4; [edx + n] field_c; [esi + n] field_8, field_20, field_24, field_28, field_30; [esp + n] stk_8
# callees:      calls FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 71 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x00502820 - 0x401000
.globl FUN_00502820
FUN_00502820:
    # block 0x00502820: entry, 5 instruction(s), ends with je to 0x005028df (forward)
    push esi                                     # 00502820
    mov esi, dword ptr [esp + stk_8]             # 00502821
    mov eax, dword ptr [esi + field_30]          # 00502825
    test eax, eax                                # 00502828
    je.d32 L_005028df                            # 0050282a
    # block 0x00502830: entered by fall-through of je at 0x0050282a, 3 instruction(s), ends with je to 0x00502840 (forward)
    mov eax, dword ptr [esi + field_20]          # 00502830
    test eax, eax                                # 00502833
    je.d8 L_00502840                             # 00502835
    # block 0x00502837: entered by fall-through of je at 0x00502835, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00502840
    push eax                                     # 00502837
    call FUN_0050e936                            # 00502838
    add esp, 0x4                                 # 0050283d
L_00502840:
    # block 0x00502840: entered by je at 0x00502835, 3 instruction(s), ends with je to 0x00502850 (forward)
    mov eax, dword ptr [esi + field_8]           # 00502840
    test eax, eax                                # 00502843
    je.d8 L_00502850                             # 00502845
    # block 0x00502847: entered by fall-through of je at 0x00502845, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00502850
    push eax                                     # 00502847
    call FUN_0050e936                            # 00502848
    add esp, 0x4                                 # 0050284d
L_00502850:
    # block 0x00502850: entered by je at 0x00502845, 4 instruction(s), ends with je to 0x0050289c (forward)
    mov eax, dword ptr [esi + field_24]          # 00502850
    push edi                                     # 00502853
    test eax, eax                                # 00502854
    je.d8 L_0050289c                             # 00502856
    # block 0x00502858: entered by fall-through of je at 0x00502856, 23 instruction(s), calls FUN_0050e936, falls into the block at 0x0050289c
    mov eax, dword ptr [eax]                     # 00502858
    push eax                                     # 0050285a
    call FUN_0050e936                            # 0050285b
    mov ecx, dword ptr [esi + field_24]          # 00502860
    mov edx, dword ptr [ecx + field_4]           # 00502863
    push edx                                     # 00502866
    call FUN_0050e936                            # 00502867
    mov eax, dword ptr [esi + field_24]          # 0050286c
    mov ecx, dword ptr [eax + field_8]           # 0050286f
    push ecx                                     # 00502872
    call FUN_0050e936                            # 00502873
    mov edx, dword ptr [esi + field_24]          # 00502878
    mov eax, dword ptr [edx + field_c]           # 0050287b
    push eax                                     # 0050287e
    call FUN_0050e936                            # 0050287f
    mov edi, dword ptr [esi + field_24]          # 00502884
    mov ecx, 0x6                                 # 00502887
    {load} xor eax, eax                          # 0050288c
    rep stosd dword ptr es:[edi], eax            # 0050288e
    mov ecx, dword ptr [esi + field_24]          # 00502890
    push ecx                                     # 00502893
    call FUN_0050e936                            # 00502894
    add esp, 0x14                                # 00502899
L_0050289c:
    # block 0x0050289c: entered by je at 0x00502856, 3 instruction(s), ends with je to 0x005028d3 (forward)
    mov eax, dword ptr [esi + field_28]          # 0050289c
    test eax, eax                                # 0050289f
    je.d8 L_005028d3                             # 005028a1
    # block 0x005028a3: entered by fall-through of je at 0x005028a1, 17 instruction(s), calls FUN_0050e936, falls into the block at 0x005028d3
    mov edx, dword ptr [eax]                     # 005028a3
    push edx                                     # 005028a5
    call FUN_0050e936                            # 005028a6
    mov eax, dword ptr [esi + field_28]          # 005028ab
    mov ecx, dword ptr [eax + field_4]           # 005028ae
    push ecx                                     # 005028b1
    call FUN_0050e936                            # 005028b2
    mov eax, dword ptr [esi + field_28]          # 005028b7
    {load} xor edx, edx                          # 005028ba
    mov dword ptr [eax], edx                     # 005028bc
    mov dword ptr [eax + field_4], edx           # 005028be
    mov dword ptr [eax + field_8], edx           # 005028c1
    mov dword ptr [eax + field_c], edx           # 005028c4
    mov ecx, dword ptr [esi + field_28]          # 005028c7
    push ecx                                     # 005028ca
    call FUN_0050e936                            # 005028cb
    add esp, 0xc                                 # 005028d0
L_005028d3:
    # block 0x005028d3: entered by je at 0x005028a1, 5 instruction(s), falls into the block at 0x005028df
    mov ecx, 0xd                                 # 005028d3
    {load} xor eax, eax                          # 005028d8
    {load} mov edi, esi                          # 005028da
    rep stosd dword ptr es:[edi], eax            # 005028dc
    pop edi                                      # 005028de
L_005028df:
    # block 0x005028df: entered by je at 0x0050282a, 2 instruction(s), ends with ret
    pop esi                                      # 005028df
    ret                                          # 005028e0

# --- data items (not part of the function) -------------------------
.org 0x005028e1 - 0x401000
PAD_005028e1:  # 15 byte(s) of nop padding
    .fill 15, 1, 0x90

