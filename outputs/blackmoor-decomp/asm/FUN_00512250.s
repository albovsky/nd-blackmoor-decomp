# FUN_00512250
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512250
# extent:       0x00512250-0x005122ad (93 code bytes)
# span:         0x00512250-0x005122ad (code 93, tables 0, padding 0)
# sha256:       a270751a3992d4104c5ada157b96f6e0b6eeac66ea5d9f476954ccd45178839a
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512250
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_8
# callees:      calls FUN_0051771b, FUN_005122ad, FUN_0051777a, FUN_0050ea7e, FUN_0050ea87
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_0050ea87, .text + (0x0050ea87 - 0x401000)
.set FUN_005122ad, .text + (0x005122ad - 0x401000)
.set FUN_0051771b, .text + (0x0051771b - 0x401000)
.set FUN_0051777a, .text + (0x0051777a - 0x401000)

.org 0x00512250 - 0x401000
.globl FUN_00512250
FUN_00512250:
    # block 0x00512250: entry, 4 instruction(s), ends with jae to 0x00512295 (forward)
    push esi                                     # 00512250
    mov esi, dword ptr [esp + stk_8]             # 00512251
    cmp esi, dword ptr [0x63cee0]                # 00512255
    jae.d8 L_00512295                            # 0051225b
    # block 0x0051225d: entered by fall-through of jae at 0x0051225b, 8 instruction(s), ends with je to 0x00512295 (forward)
    {load} mov ecx, esi                          # 0051225d
    {load} mov eax, esi                          # 0051225f
    sar ecx, 0x5                                 # 00512261
    and eax, 0x1f                                # 00512264
    mov ecx, dword ptr [4*ecx + 0x63cde0]        # 00512267
    lea eax, [eax + 8*eax]                       # 0051226e
    test byte ptr [ecx + 4*eax + field_4], 0x1   # 00512271
    je.d8 L_00512295                             # 00512276
    # block 0x00512278: entered by fall-through of je at 0x00512276, 13 instruction(s), calls FUN_0051771b, FUN_005122ad, FUN_0051777a, ends with ret
    push edi                                     # 00512278
    push esi                                     # 00512279
    call FUN_0051771b                            # 0051227a
    push esi                                     # 0051227f
    call FUN_005122ad                            # 00512280
    push esi                                     # 00512285
    {load} mov edi, eax                          # 00512286
    call FUN_0051777a                            # 00512288
    add esp, 0xc                                 # 0051228d
    {load} mov eax, edi                          # 00512290
    pop edi                                      # 00512292
    pop esi                                      # 00512293
    ret                                          # 00512294
L_00512295:
    # block 0x00512295: entered by jae at 0x0051225b; je at 0x00512276, 7 instruction(s), calls FUN_0050ea7e, FUN_0050ea87, ends with ret
    call FUN_0050ea7e                            # 00512295
    mov dword ptr [eax], 0x9                     # 0051229a
    call FUN_0050ea87                            # 005122a0
    and dword ptr [eax], 0x0                     # 005122a5
    or eax, -0x1                                 # 005122a8
    pop esi                                      # 005122ab
    ret                                          # 005122ac

