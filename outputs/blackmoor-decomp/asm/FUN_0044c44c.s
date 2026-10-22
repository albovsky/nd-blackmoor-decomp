# FUN_0044c44c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c44c
# extent:       0x0044c44c-0x0044c479 (45 code bytes)
# span:         0x0044c44c-0x0044c479 (code 45, tables 0, padding 0)
# sha256:       d1f1f4c607e49eb5dc18ee99eb94b447507628a58e4d8c72d7f66ea6c1bf7b9b
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44c44c_lifted
# naming:       native port src/original_methods_fl40.c:m44c44c_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 8/8 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44c44c_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0044c44c - 0x401000
.globl FUN_0044c44c
FUN_0044c44c:
    # block 0x0044c44c: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0044c44c
    {load} mov ebp, esp                          # 0044c44d
    mov dword ptr [0x617e80], 0x0                # 0044c44f
    mov dword ptr [0x5b4c3a], 0x0                # 0044c459
    mov dword ptr [0x5b4eb1], 0x0                # 0044c463
    mov dword ptr [0x637fd3], 0x0                # 0044c46d
    pop ebp                                      # 0044c477
    ret                                          # 0044c478

