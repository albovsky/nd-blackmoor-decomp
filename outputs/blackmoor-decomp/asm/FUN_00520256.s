# FUN_00520256
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520256
# extent:       0x00520256-0x00520291 (59 code bytes)
# span:         0x00520256-0x00520291 (code 59, tables 0, padding 0)
# sha256:       d897217ad986beee2d86d5b98219a918e7005f1662dc6f17a7f46f401ac94109
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520256
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esi + n] field_4, field_8; [esp + n] stk_c
# callees:      calls FUN_0051e745, FUN_0051e8a7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051e745, .text + (0x0051e745 - 0x401000)
.set FUN_0051e8a7, .text + (0x0051e8a7 - 0x401000)

.org 0x00520256 - 0x401000
.globl FUN_00520256
FUN_00520256:
    # block 0x00520256: entry, 7 instruction(s), calls FUN_0051e745, falls into the block at 0x00520269
    push esi                                     # 00520256
    {load} mov esi, ecx                          # 00520257
    push edi                                     # 00520259
    mov edi, dword ptr [esp + stk_c]             # 0052025a
    mov eax, dword ptr [esi + field_8]           # 0052025e
    lea ecx, [eax + 4*edi]                       # 00520261
    call FUN_0051e745                            # 00520264
L_00520269:
    # block 0x00520269: entered by jmp at 0x00520282, 5 instruction(s), ends with jge to 0x00520284 (forward)
    mov eax, dword ptr [esi + field_4]           # 00520269
    dec eax                                      # 0052026c
    {load} cmp edi, eax                          # 0052026d
    mov eax, dword ptr [esi + field_8]           # 0052026f
    jge.d8 L_00520284                            # 00520272
    # block 0x00520274: entered by fall-through of jge at 0x00520272, 6 instruction(s), calls FUN_0051e8a7, ends with backward jump to 0x00520269
    lea ecx, [eax + 4*edi + field_4]             # 00520274
    push ecx                                     # 00520278
    lea ecx, [eax + 4*edi]                       # 00520279
    call FUN_0051e8a7                            # 0052027c
    inc edi                                      # 00520281
    jmp.d8 L_00520269                            # 00520282
L_00520284:
    # block 0x00520284: entered by jge at 0x00520272, 5 instruction(s), calls FUN_0051e745, ends with ret 0x4
    lea ecx, [eax + 4*edi]                       # 00520284
    call FUN_0051e745                            # 00520287
    pop edi                                      # 0052028c
    pop esi                                      # 0052028d
    ret 0x4                                      # 0052028e

