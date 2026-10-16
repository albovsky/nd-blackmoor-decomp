# FUN_00524951
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524951
# extent:       0x00524951-0x0052496c (27 code bytes)
# span:         0x00524951-0x0052496c (code 27, tables 0, padding 0)
# sha256:       28d1514236bfb131bed4ac7ac184d05baf7168d6272a0760908769badc1330f4
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00524945 (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524951
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0050c539
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052496c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c539, .text + (0x0050c539 - 0x401000)

.org 0x00524951 - 0x401000
.globl FUN_00524951
FUN_00524951:
    # block 0x00524951: entry, 2 instruction(s), ends with jne to 0x0052496b (forward)
    test byte ptr [0x63aa28], 0x1                # 00524951
    jne.d8 L_0052496b                            # 00524958
    # block 0x0052495a: entered by fall-through of jne at 0x00524958, 3 instruction(s), ends with backward jump to 0x0050c539
    or byte ptr [0x63aa28], 0x1                  # 0052495a
    mov ecx, 0x63c230                            # 00524961
    jmp.d32 FUN_0050c539                         # 00524966
L_0052496b:
    # block 0x0052496b: entered by jne at 0x00524958, 1 instruction(s), ends with ret
    ret                                          # 0052496b

