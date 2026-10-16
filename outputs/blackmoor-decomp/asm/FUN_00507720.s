# FUN_00507720
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00507720
# extent:       0x00507720-0x0050779a (122 code bytes)
# span:         0x00507720-0x005077a0 (code 122, tables 0, padding 6)
# sha256:       58cf576a2e34563249ca1be3d6064efdee4ef992ee6993027add79953a8ef97c
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00507720
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_14, field_18, field_1c; [esp + n] stk_8
# callees:      calls FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 50 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005077a0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x00507720 - 0x401000
.globl FUN_00507720
FUN_00507720:
    # block 0x00507720: entry, 4 instruction(s), ends with je to 0x00507798 (forward)
    push esi                                     # 00507720
    mov esi, dword ptr [esp + stk_8]             # 00507721
    test esi, esi                                # 00507725
    je.d8 L_00507798                             # 00507727
    # block 0x00507729: entered by fall-through of je at 0x00507727, 5 instruction(s), ends with jle to 0x0050774e (forward)
    mov eax, dword ptr [esi + field_4]           # 00507729
    push edi                                     # 0050772c
    {load} xor edi, edi                          # 0050772d
    test eax, eax                                # 0050772f
    jle.d8 L_0050774e                            # 00507731
L_00507733:
    # block 0x00507733: entered by jl at 0x0050774c; fall-through of jle at 0x00507731, 4 instruction(s), ends with je to 0x00507746 (forward)
    mov eax, dword ptr [esi + field_14]          # 00507733
    mov eax, dword ptr [eax + 4*edi]             # 00507736
    test eax, eax                                # 00507739
    je.d8 L_00507746                             # 0050773b
    # block 0x0050773d: entered by fall-through of je at 0x0050773b, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00507746
    push eax                                     # 0050773d
    call FUN_0050e936                            # 0050773e
    add esp, 0x4                                 # 00507743
L_00507746:
    # block 0x00507746: entered by je at 0x0050773b, 4 instruction(s), ends with jl to 0x00507733 (backward)
    mov eax, dword ptr [esi + field_4]           # 00507746
    inc edi                                      # 00507749
    {load} cmp edi, eax                          # 0050774a
    jl.d8 L_00507733                             # 0050774c
L_0050774e:
    # block 0x0050774e: entered by jle at 0x00507731; fall-through of jl at 0x0050774c, 8 instruction(s), calls FUN_0050e936, ends with jle to 0x0050777a (forward)
    mov ecx, dword ptr [esi + field_14]          # 0050774e
    push ecx                                     # 00507751
    call FUN_0050e936                            # 00507752
    mov eax, dword ptr [esi + field_18]          # 00507757
    add esp, 0x4                                 # 0050775a
    {load} xor edi, edi                          # 0050775d
    test eax, eax                                # 0050775f
    jle.d8 L_0050777a                            # 00507761
L_00507763:
    # block 0x00507763: entered by jl at 0x00507778; fall-through of jle at 0x00507761, 9 instruction(s), calls FUN_0050e936, ends with jl to 0x00507763 (backward)
    mov edx, dword ptr [esi + field_1c]          # 00507763
    mov eax, dword ptr [edx + 4*edi]             # 00507766
    push eax                                     # 00507769
    call FUN_0050e936                            # 0050776a
    mov eax, dword ptr [esi + field_18]          # 0050776f
    add esp, 0x4                                 # 00507772
    inc edi                                      # 00507775
    {load} cmp edi, eax                          # 00507776
    jl.d8 L_00507763                             # 00507778
L_0050777a:
    # block 0x0050777a: entered by jle at 0x00507761; fall-through of jl at 0x00507778, 11 instruction(s), calls FUN_0050e936, falls into the block at 0x00507798
    mov ecx, dword ptr [esi + field_1c]          # 0050777a
    push ecx                                     # 0050777d
    call FUN_0050e936                            # 0050777e
    mov ecx, 0xb                                 # 00507783
    {load} xor eax, eax                          # 00507788
    {load} mov edi, esi                          # 0050778a
    push esi                                     # 0050778c
    rep stosd dword ptr es:[edi], eax            # 0050778d
    call FUN_0050e936                            # 0050778f
    add esp, 0x8                                 # 00507794
    pop edi                                      # 00507797
L_00507798:
    # block 0x00507798: entered by je at 0x00507727, 2 instruction(s), ends with ret
    pop esi                                      # 00507798
    ret                                          # 00507799

# --- data items (not part of the function) -------------------------
.org 0x0050779a - 0x401000
PAD_0050779a:  # 6 byte(s) of nop padding
    .fill 6, 1, 0x90

