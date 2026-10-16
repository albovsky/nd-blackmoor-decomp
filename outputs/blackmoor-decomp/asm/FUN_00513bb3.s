# FUN_00513bb3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513bb3
# extent:       0x00513bb3-0x00513bba (7 code bytes)
# span:         0x00513bb3-0x00513bc0 (code 7, tables 0, padding 6)
# sha256:       9d5578b8255c35f3abcd0fa7bf4d707d46d7189bace85da145d1d183bd8e7707
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513a57 (+0x15c)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513bb3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00513bb3 - 0x401000
.globl FUN_00513bb3
FUN_00513bb3:
    # block 0x00513bb3: entry, 2 instruction(s), ends with je to 0x00513bb9 (forward)
    {load} or cl, cl                             # 00513bb3
    je.d8 L_00513bb9                             # 00513bb5
    # block 0x00513bb7: entered by fall-through of je at 0x00513bb5, 1 instruction(s), falls into the block at 0x00513bb9
    fchs                                         # 00513bb7
L_00513bb9:
    # block 0x00513bb9: entered by je at 0x00513bb5, 1 instruction(s), ends with ret
    ret                                          # 00513bb9

# --- data items (not part of the function) -------------------------
.org 0x00513bba - 0x401000
PAD_00513bba:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

