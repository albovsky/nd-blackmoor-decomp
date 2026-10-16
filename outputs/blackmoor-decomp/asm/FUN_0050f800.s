# FUN_0050f800
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f800
# extent:       0x0050f800-0x0050f821 (33 code bytes)
# span:         0x0050f800-0x0050f830 (code 33, tables 0, padding 15)
# sha256:       f028a2bb21a2463601e9046f5105991b09f90af85bae56b363c014dafc609ea6
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050f7e0 (+0x20)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f800
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0050f800 - 0x401000
.globl FUN_0050f800
FUN_0050f800:
    # block 0x0050f800: entry, 2 instruction(s), ends with jae to 0x0050f81b (forward)
    cmp cl, 0x40                                 # 0050f800
    jae.d8 L_0050f81b                            # 0050f803
    # block 0x0050f805: entered by fall-through of jae at 0x0050f803, 2 instruction(s), ends with jae to 0x0050f810 (forward)
    cmp cl, 0x20                                 # 0050f805
    jae.d8 L_0050f810                            # 0050f808
    # block 0x0050f80a: entered by fall-through of jae at 0x0050f808, 3 instruction(s), ends with ret
    shrd eax, edx, cl                            # 0050f80a
    sar edx, cl                                  # 0050f80d
    ret                                          # 0050f80f
L_0050f810:
    # block 0x0050f810: entered by jae at 0x0050f808, 5 instruction(s), ends with ret
    {load} mov eax, edx                          # 0050f810
    sar edx, 0x1f                                # 0050f812
    and cl, 0x1f                                 # 0050f815
    sar eax, cl                                  # 0050f818
    ret                                          # 0050f81a
L_0050f81b:
    # block 0x0050f81b: entered by jae at 0x0050f803, 3 instruction(s), ends with ret
    sar edx, 0x1f                                # 0050f81b
    {load} mov eax, edx                          # 0050f81e
    ret                                          # 0050f820

# --- data items (not part of the function) -------------------------
.org 0x0050f821 - 0x401000
PAD_0050f821:  # 15 byte(s) of int3 padding
    .fill 15, 1, 0xcc

