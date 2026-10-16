# FUN_00512330
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512330
# extent:       0x00512330-0x0051235b (43 code bytes)
# span:         0x00512330-0x0051235b (code 43, tables 0, padding 0)
# sha256:       b113b02fe31cbc51e375e2d94656373efc9c1e05b2bb6bd78fa6ca9d3fb29327
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512330
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8, field_c; [esp + n] stk_8
# callees:      calls FUN_0050e936
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x00512330 - 0x401000
.globl FUN_00512330
FUN_00512330:
    # block 0x00512330: entry, 5 instruction(s), ends with je to 0x00512359 (forward)
    push esi                                     # 00512330
    mov esi, dword ptr [esp + stk_8]             # 00512331
    mov eax, dword ptr [esi + field_c]           # 00512335
    test al, -0x7d                               # 00512338
    je.d8 L_00512359                             # 0051233a
    # block 0x0051233c: entered by fall-through of je at 0x0051233a, 2 instruction(s), ends with je to 0x00512359 (forward)
    test al, 0x8                                 # 0051233c
    je.d8 L_00512359                             # 0051233e
    # block 0x00512340: entered by fall-through of je at 0x0051233e, 8 instruction(s), calls FUN_0050e936, falls into the block at 0x00512359
    push dword ptr [esi + field_8]               # 00512340
    call FUN_0050e936                            # 00512343
    .insn 0x6681/4, dword ptr [esi + field_c], -1033{:s16} # 00512348
    {load} xor eax, eax                          # 0051234e
    pop ecx                                      # 00512350
    mov dword ptr [esi], eax                     # 00512351
    mov dword ptr [esi + field_8], eax           # 00512353
    mov dword ptr [esi + field_4], eax           # 00512356
L_00512359:
    # block 0x00512359: entered by je at 0x0051233a; je at 0x0051233e, 2 instruction(s), ends with ret
    pop esi                                      # 00512359
    ret                                          # 0051235a

