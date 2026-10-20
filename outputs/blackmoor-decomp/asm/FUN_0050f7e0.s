# FUN_0050f7e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f7e0
# extent:       0x0050f7e0-0x0050f7ff (31 code bytes)
# span:         0x0050f7e0-0x0050f800 (code 31, tables 0, padding 1)
# sha256:       04614067463d9a7345e7de2955a0c9fb5906c602499fb5df7f220ae231db613b
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __allshl
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x0050f800
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0050f7e0 - 0x401000
.globl FUN_0050f7e0
FUN_0050f7e0:
    # block 0x0050f7e0: entry, 2 instruction(s), ends with jae to 0x0050f7fa (forward)
    cmp cl, 0x40                                 # 0050f7e0
    jae.d8 L_0050f7fa                            # 0050f7e3
    # block 0x0050f7e5: entered by fall-through of jae at 0x0050f7e3, 2 instruction(s), ends with jae to 0x0050f7f0 (forward)
    cmp cl, 0x20                                 # 0050f7e5
    jae.d8 L_0050f7f0                            # 0050f7e8
    # block 0x0050f7ea: entered by fall-through of jae at 0x0050f7e8, 3 instruction(s), ends with ret
    shld edx, eax, cl                            # 0050f7ea
    shl eax, cl                                  # 0050f7ed
    ret                                          # 0050f7ef
L_0050f7f0:
    # block 0x0050f7f0: entered by jae at 0x0050f7e8, 5 instruction(s), ends with ret
    {load} mov edx, eax                          # 0050f7f0
    {load} xor eax, eax                          # 0050f7f2
    and cl, 0x1f                                 # 0050f7f4
    shl edx, cl                                  # 0050f7f7
    ret                                          # 0050f7f9
L_0050f7fa:
    # block 0x0050f7fa: entered by jae at 0x0050f7e3, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0050f7fa
    {load} xor edx, edx                          # 0050f7fc
    ret                                          # 0050f7fe

# --- data items (not part of the function) -------------------------
.org 0x0050f7ff - 0x401000
PAD_0050f7ff:  # 1 byte(s) of int3 padding
    .fill 1, 1, 0xcc

