# FUN_00525f4c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525f4c
# extent:       0x00525f4c-0x00525f67 (27 code bytes)
# span:         0x00525f4c-0x00525f67 (code 27, tables 0, padding 0)
# sha256:       a710ea505c5edab6a1ac51000a61f49ad2b5e250a707ee16523c9bb786e5ddfb
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00525f40 (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525f4c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0050c539
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c539, .text + (0x0050c539 - 0x401000)

.org 0x00525f4c - 0x401000
.globl FUN_00525f4c
FUN_00525f4c:
    # block 0x00525f4c: entry, 2 instruction(s), ends with jne to 0x00525f66 (forward)
    test byte ptr [0x63c7b8], 0x1                # 00525f4c
    jne.d8 L_00525f66                            # 00525f53
    # block 0x00525f55: entered by fall-through of jne at 0x00525f53, 3 instruction(s), ends with backward jump to 0x0050c539
    or byte ptr [0x63c7b8], 0x1                  # 00525f55
    mov ecx, 0x63c7c0                            # 00525f5c
    jmp.d32 FUN_0050c539                         # 00525f61
L_00525f66:
    # block 0x00525f66: entered by jne at 0x00525f53, 1 instruction(s), ends with ret
    ret                                          # 00525f66

