# FUN_00525099
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525099
# extent:       0x00525099-0x005250b0 (23 code bytes)
# span:         0x00525099-0x005250b0 (code 23, tables 0, padding 0)
# sha256:       bfb2285f9eb0de1540272276d27337f9797f69b309eff709cc95493fdec64b13
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525099
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_d4, field_104
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_d4, 0xd4  # offset +0xd4
.equ field_104, 0x104  # offset +0x104

# --- external targets -----------------------------------------------

.org 0x00525099 - 0x401000
.globl FUN_00525099
FUN_00525099:
    # block 0x00525099: entry, 5 instruction(s), ends with ret
    {load} mov eax, ecx                          # 00525099
    or dword ptr [eax + field_d4], -0x1          # 0052509b
    or dword ptr [eax + field_104], -0x1         # 005250a2
    mov dword ptr [eax], 0x52fb7c                # 005250a9
    ret                                          # 005250af

