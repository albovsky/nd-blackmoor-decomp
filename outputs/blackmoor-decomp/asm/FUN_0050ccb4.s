# FUN_0050ccb4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ccb4
# extent:       0x0050ccb4-0x0050ccec (56 code bytes)
# span:         0x0050ccb4-0x0050ccec (code 56, tables 0, padding 0)
# sha256:       3885d9913cd611456b43fd587b0e6de29b9dce59ab0551243860dc3b640826b6
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ccb4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0050ccb4 - 0x401000
.globl FUN_0050ccb4
FUN_0050ccb4:
    # block 0x0050ccb4: entry, 8 instruction(s), ends with ret
    mov eax, 0x511e31                            # 0050ccb4
    mov dword ptr [0x56841c], 0x511adb           # 0050ccb9
    mov dword ptr [0x568418], eax                # 0050ccc3
    mov dword ptr [0x568420], 0x511b41           # 0050ccc8
    mov dword ptr [0x568424], 0x511a81           # 0050ccd2
    mov dword ptr [0x568428], 0x511b29           # 0050ccdc
    mov dword ptr [0x56842c], eax                # 0050cce6
    ret                                          # 0050cceb

