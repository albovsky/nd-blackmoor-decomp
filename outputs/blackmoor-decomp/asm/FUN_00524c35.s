# FUN_00524c35
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524c35
# extent:       0x00524c35-0x00524c3e (9 code bytes)
# span:         0x00524c35-0x00524c3e (code 9, tables 0, padding 0)
# sha256:       f56d910174799f4b1ea2646d5dec8548bca1892fec478f0005b6a998b99acf3b
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524c35
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00524c35 - 0x401000
.globl FUN_00524c35
FUN_00524c35:
    # block 0x00524c35: entry, 3 instruction(s), ends with ret
    {load} mov eax, ecx                          # 00524c35
    mov dword ptr [eax], 0x52f50c                # 00524c37
    ret                                          # 00524c3d

