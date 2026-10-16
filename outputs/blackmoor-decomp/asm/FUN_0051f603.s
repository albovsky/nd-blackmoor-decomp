# FUN_0051f603
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f603
# extent:       0x0051f603-0x0051f611 (14 code bytes)
# span:         0x0051f603-0x0051f611 (code 14, tables 0, padding 0)
# sha256:       caa4ab67d94207a78e7d8b0a4fc3d866d6a7db542f30bbbfcd1aae480ab69717
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f603
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_18
# callees:      calls FUN_0051f636
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_0051f636, .text + (0x0051f636 - 0x401000)

.org 0x0051f603 - 0x401000
.globl FUN_0051f603
FUN_0051f603:
    # block 0x0051f603: entry, 4 instruction(s), calls FUN_0051f636, ends with ret
    mov ecx, dword ptr [ebp - field_minus_18]    # 0051f603
    call FUN_0051f636                            # 0051f606
    mov eax, 0x51f5f1                            # 0051f60b
    ret                                          # 0051f610

