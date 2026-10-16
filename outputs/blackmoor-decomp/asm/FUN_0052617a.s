# FUN_0052617a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052617a
# extent:       0x0052617a-0x00526195 (27 code bytes)
# span:         0x0052617a-0x00526195 (code 27, tables 0, padding 0)
# sha256:       e93375fc2f53569deb3227086863fda5be80c8af6e0b880513e6a382bb43850b
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052617a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00526195, FUN_005256fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005256fb, .text + (0x005256fb - 0x401000)
.set FUN_00526195, .text + (0x00526195 - 0x401000)

.org 0x0052617a - 0x401000
.globl FUN_0052617a
FUN_0052617a:
    # block 0x0052617a: entry, 5 instruction(s), calls FUN_00526195, ends with je to 0x0052618f (forward)
    push esi                                     # 0052617a
    {load} mov esi, ecx                          # 0052617b
    call FUN_00526195                            # 0052617d
    test byte ptr [esp + stk_8], 0x1             # 00526182
    je.d8 L_0052618f                             # 00526187
    # block 0x00526189: entered by fall-through of je at 0x00526187, 2 instruction(s), calls FUN_005256fb, falls into the block at 0x0052618f
    push esi                                     # 00526189
    call FUN_005256fb                            # 0052618a
L_0052618f:
    # block 0x0052618f: entered by je at 0x00526187, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0052618f
    pop esi                                      # 00526191
    ret 0x4                                      # 00526192

