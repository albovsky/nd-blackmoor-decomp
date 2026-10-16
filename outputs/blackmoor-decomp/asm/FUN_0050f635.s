# FUN_0050f635
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f635
# extent:       0x0050f635-0x0050f65d (40 code bytes)
# span:         0x0050f635-0x0050f65d (code 40, tables 0, padding 0)
# sha256:       16d6865efd1b677fd092559ec28a0e36b2fc2db94a99824590d19b64a9d8f50d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050f462 (+0x1d3)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f635
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0050f635 - 0x401000
.globl FUN_0050f635
FUN_0050f635:
    # block 0x0050f635: entry, 8 instruction(s), ends with jne to 0x0050f65a (forward)
    fld st(0)                                    # 0050f635
    frndint                                      # 0050f637
    fcomp st(1)                                  # 0050f639
    mov cl, 0x0                                  # 0050f63b
    wait                                         # 0050f63d
    fnstsw ax                                    # 0050f63e
    sahf                                         # 0050f640
    jne.d8 L_0050f65a                            # 0050f641
    # block 0x0050f643: entered by fall-through of jne at 0x0050f641, 9 instruction(s), ends with jne to 0x0050f659 (forward)
    fmul qword ptr [0x567ff0]                    # 0050f643
    inc cl                                       # 0050f649
    fld st(0)                                    # 0050f64b
    frndint                                      # 0050f64d
    fcompp                                       # 0050f64f
    wait                                         # 0050f651
    fnstsw ax                                    # 0050f652
    sahf                                         # 0050f654
    jne.d8 L_0050f659                            # 0050f655
    # block 0x0050f657: entered by fall-through of jne at 0x0050f655, 1 instruction(s), falls into the block at 0x0050f659
    inc cl                                       # 0050f657
L_0050f659:
    # block 0x0050f659: entered by jne at 0x0050f655, 1 instruction(s), ends with ret
    ret                                          # 0050f659
L_0050f65a:
    # block 0x0050f65a: entered by jne at 0x0050f641, 2 instruction(s), ends with ret
    fstp st(0)                                   # 0050f65a
    ret                                          # 0050f65c

