# FUN_0052788d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052788d
# extent:       0x0052788d-0x0052789c (15 code bytes)
# span:         0x0052788d-0x0052789c (code 15, tables 0, padding 0)
# sha256:       7df8214df31050f884ab2a3869f120223c86de9d92958dbb3074bd76cb8c3d53
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052788d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00447e46
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00447e46, .text + (0x00447e46 - 0x401000)

.org 0x0052788d - 0x401000
.globl FUN_0052788d
FUN_0052788d:
    # block 0x0052788d: entry, 4 instruction(s), calls FUN_00447e46, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 0052788d
    add ecx, 0xc7c07                             # 00527890
    call FUN_00447e46                            # 00527896
    ret                                          # 0052789b

