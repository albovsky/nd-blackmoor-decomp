# FUN_00524f55
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524f55
# extent:       0x00524f55-0x00524f85 (48 code bytes)
# span:         0x00524f55-0x00524f85 (code 48, tables 0, padding 0)
# sha256:       d507e7a1a41e659005f24748d4b27b158b503b393fa352fbd6f3e305c33c3b5e
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524f55
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_10; [esi + n] field_a8, field_b4
# callees:      calls FUN_00521641; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_10, 0x10  # offset +0x10
.equ field_a8, 0xa8  # offset +0xa8
.equ field_b4, 0xb4  # offset +0xb4

# --- external targets -----------------------------------------------
.set FUN_00521641, .text + (0x00521641 - 0x401000)

.org 0x00524f55 - 0x401000
.globl FUN_00524f55
FUN_00524f55:
    # block 0x00524f55: entry, 5 instruction(s), ends with je to 0x00524f67 (forward)
    push esi                                     # 00524f55
    {load} mov esi, ecx                          # 00524f56
    mov ecx, dword ptr [esi + field_a8]          # 00524f58
    test ecx, ecx                                # 00524f5e
    je.d8 L_00524f67                             # 00524f60
    # block 0x00524f62: entered by fall-through of je at 0x00524f60, 2 instruction(s), calls indirect dword ptr [eax + 0x10], falls into the block at 0x00524f67
    mov eax, dword ptr [ecx]                     # 00524f62
    call dword ptr [eax + field_10]              # 00524f64
L_00524f67:
    # block 0x00524f67: entered by je at 0x00524f60, 3 instruction(s), ends with je to 0x00524f83 (forward)
    mov eax, dword ptr [esi + field_b4]          # 00524f67
    test eax, eax                                # 00524f6d
    je.d8 L_00524f83                             # 00524f6f
    # block 0x00524f71: entered by fall-through of je at 0x00524f6f, 5 instruction(s), calls FUN_00521641, falls into the block at 0x00524f83
    push eax                                     # 00524f71
    push 0x52f4d0                                # 00524f72
    push 0x52f4e0                                # 00524f77
    {load} mov ecx, esi                          # 00524f7c
    call FUN_00521641                            # 00524f7e
L_00524f83:
    # block 0x00524f83: entered by je at 0x00524f6f, 2 instruction(s), ends with ret
    pop esi                                      # 00524f83
    ret                                          # 00524f84

