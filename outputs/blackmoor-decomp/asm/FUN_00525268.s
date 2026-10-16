# FUN_00525268
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525268
# extent:       0x00525268-0x00525287 (31 code bytes)
# span:         0x00525268-0x00525287 (code 31, tables 0, padding 0)
# sha256:       19ad93b88807b22b131cc22f44a1b0c1f17a660ed389b617ccb507a7e369edf6
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525268
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_c, field_28
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------

.org 0x00525268 - 0x401000
.globl FUN_00525268
FUN_00525268:
    # block 0x00525268: entry, 7 instruction(s), ends with ret
    {load} mov eax, ecx                          # 00525268
    and dword ptr [eax + field_8], 0x0           # 0052526a
    and dword ptr [eax + field_c], 0x0           # 0052526e
    mov dword ptr [eax], 0x52fb8c                # 00525272
    mov dword ptr [eax + field_c], 0x54          # 00525278
    mov dword ptr [eax + field_28], 0x51dc29     # 0052527f
    ret                                          # 00525286

