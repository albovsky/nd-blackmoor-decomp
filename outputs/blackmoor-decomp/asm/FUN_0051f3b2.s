# FUN_0051f3b2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f3b2
# extent:       0x0051f3b2-0x0051f3d4 (34 code bytes)
# span:         0x0051f3b2-0x0051f3d4 (code 34, tables 0, padding 0)
# sha256:       48181ecbf1a214f120a5fa04575ca75ad2f39aba5a45c727a09b2cb8e12e76cd
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f3b2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_1c
# callees:      calls FUN_00524880, FUN_00526978, FUN_0051ee80
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051ee80, .text + (0x0051ee80 - 0x401000)
.set FUN_00524880, .text + (0x00524880 - 0x401000)
.set FUN_00526978, .text + (0x00526978 - 0x401000)

.org 0x0051f3b2 - 0x401000
.globl FUN_0051f3b2
FUN_0051f3b2:
    # block 0x0051f3b2: entry, 4 instruction(s), ends with jne to 0x0051f3cb (forward)
    push esi                                     # 0051f3b2
    {load} mov esi, ecx                          # 0051f3b3
    cmp dword ptr [esi + field_1c], 0x0          # 0051f3b5
    jne.d8 L_0051f3cb                            # 0051f3b9
    # block 0x0051f3bb: entered by fall-through of jne at 0x0051f3b9, 3 instruction(s), calls FUN_00524880, ends with je to 0x0051f3cb (forward)
    call FUN_00524880                            # 0051f3bb
    test eax, eax                                # 0051f3c0
    je.d8 L_0051f3cb                             # 0051f3c2
    # block 0x0051f3c4: entered by fall-through of je at 0x0051f3c2, 2 instruction(s), calls FUN_00526978, falls into the block at 0x0051f3cb
    push 0x0                                     # 0051f3c4
    call FUN_00526978                            # 0051f3c6
L_0051f3cb:
    # block 0x0051f3cb: entered by jne at 0x0051f3b9; je at 0x0051f3c2, 4 instruction(s), calls FUN_0051ee80, ends with ret
    {load} mov ecx, esi                          # 0051f3cb
    call FUN_0051ee80                            # 0051f3cd
    pop esi                                      # 0051f3d2
    ret                                          # 0051f3d3

