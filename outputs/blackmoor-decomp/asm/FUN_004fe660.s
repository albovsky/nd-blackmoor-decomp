# FUN_004fe660
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fe660
# extent:       0x004fe660-0x004fe6cc (108 code bytes)
# span:         0x004fe660-0x004fe6d0 (code 108, tables 0, padding 4)
# sha256:       26a7faa8138d6e7af0557afeebc2701dbf1a05deff8f4e3266271d39ccb02fda
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fe660
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8, field_c; [esp + n] stk_8
# callees:      calls FUN_0050e936
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 46 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x004fe660 - 0x401000
.globl FUN_004fe660
FUN_004fe660:
    # block 0x004fe660: entry, 4 instruction(s), ends with je to 0x004fe6bd (forward)
    push esi                                     # 004fe660
    mov esi, dword ptr [esp + stk_8]             # 004fe661
    test esi, esi                                # 004fe665
    je.d8 L_004fe6bd                             # 004fe667
    # block 0x004fe669: entered by fall-through of je at 0x004fe667, 5 instruction(s), ends with jle to 0x004fe68d (forward)
    mov eax, dword ptr [esi + field_8]           # 004fe669
    push edi                                     # 004fe66c
    {load} xor edi, edi                          # 004fe66d
    test eax, eax                                # 004fe66f
    jle.d8 L_004fe68d                            # 004fe671
L_004fe673:
    # block 0x004fe673: entered by jl at 0x004fe68b; fall-through of jle at 0x004fe671, 4 instruction(s), ends with je to 0x004fe685 (forward)
    mov eax, dword ptr [esi]                     # 004fe673
    mov eax, dword ptr [eax + 4*edi]             # 004fe675
    test eax, eax                                # 004fe678
    je.d8 L_004fe685                             # 004fe67a
    # block 0x004fe67c: entered by fall-through of je at 0x004fe67a, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004fe685
    push eax                                     # 004fe67c
    call FUN_0050e936                            # 004fe67d
    add esp, 0x4                                 # 004fe682
L_004fe685:
    # block 0x004fe685: entered by je at 0x004fe67a, 4 instruction(s), ends with jl to 0x004fe673 (backward)
    mov eax, dword ptr [esi + field_8]           # 004fe685
    inc edi                                      # 004fe688
    {load} cmp edi, eax                          # 004fe689
    jl.d8 L_004fe673                             # 004fe68b
L_004fe68d:
    # block 0x004fe68d: entered by jle at 0x004fe671; fall-through of jl at 0x004fe68b, 4 instruction(s), ends with je to 0x004fe69d (forward)
    mov eax, dword ptr [esi]                     # 004fe68d
    pop edi                                      # 004fe68f
    test eax, eax                                # 004fe690
    je.d8 L_004fe69d                             # 004fe692
    # block 0x004fe694: entered by fall-through of je at 0x004fe692, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004fe69d
    push eax                                     # 004fe694
    call FUN_0050e936                            # 004fe695
    add esp, 0x4                                 # 004fe69a
L_004fe69d:
    # block 0x004fe69d: entered by je at 0x004fe692, 3 instruction(s), ends with je to 0x004fe6ad (forward)
    mov eax, dword ptr [esi + field_4]           # 004fe69d
    test eax, eax                                # 004fe6a0
    je.d8 L_004fe6ad                             # 004fe6a2
    # block 0x004fe6a4: entered by fall-through of je at 0x004fe6a2, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004fe6ad
    push eax                                     # 004fe6a4
    call FUN_0050e936                            # 004fe6a5
    add esp, 0x4                                 # 004fe6aa
L_004fe6ad:
    # block 0x004fe6ad: entered by je at 0x004fe6a2, 3 instruction(s), ends with je to 0x004fe6bd (forward)
    mov eax, dword ptr [esi + field_c]           # 004fe6ad
    test eax, eax                                # 004fe6b0
    je.d8 L_004fe6bd                             # 004fe6b2
    # block 0x004fe6b4: entered by fall-through of je at 0x004fe6b2, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004fe6bd
    push eax                                     # 004fe6b4
    call FUN_0050e936                            # 004fe6b5
    add esp, 0x4                                 # 004fe6ba
L_004fe6bd:
    # block 0x004fe6bd: entered by je at 0x004fe667; je at 0x004fe6b2, 7 instruction(s), ends with ret
    {load} xor ecx, ecx                          # 004fe6bd
    mov dword ptr [esi], ecx                     # 004fe6bf
    mov dword ptr [esi + field_4], ecx           # 004fe6c1
    mov dword ptr [esi + field_8], ecx           # 004fe6c4
    mov dword ptr [esi + field_c], ecx           # 004fe6c7
    pop esi                                      # 004fe6ca
    ret                                          # 004fe6cb

# --- data items (not part of the function) -------------------------
.org 0x004fe6cc - 0x401000
PAD_004fe6cc:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

