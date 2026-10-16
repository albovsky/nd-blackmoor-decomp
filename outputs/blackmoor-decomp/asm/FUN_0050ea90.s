# FUN_0050ea90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ea90
# extent:       0x0050ea90-0x0050eaa2 (18 code bytes)
# span:         0x0050ea90-0x0050eaa2 (code 18, tables 0, padding 0)
# sha256:       41c673448e1e4f15c3c3535bca0d0b4452a805e750c27f833d74a97a0e1516f9
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ea90
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0050eaa2
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050eaa2, .text + (0x0050eaa2 - 0x401000)

.org 0x0050ea90 - 0x401000
.globl FUN_0050ea90
FUN_0050ea90:
    # block 0x0050ea90: entry, 6 instruction(s), calls FUN_0050eaa2, ends with ret
    push dword ptr [0x63cc4c]                    # 0050ea90
    push dword ptr [esp + stk_8]                 # 0050ea96
    call FUN_0050eaa2                            # 0050ea9a
    pop ecx                                      # 0050ea9f
    pop ecx                                      # 0050eaa0
    ret                                          # 0050eaa1

