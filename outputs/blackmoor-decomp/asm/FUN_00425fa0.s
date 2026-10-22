# FUN_00425fa0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00425fa0
# extent:       0x00425fa0-0x00425fc0 (32 code bytes)
# span:         0x00425fa0-0x00425fc0 (code 32, tables 0, padding 0)
# sha256:       bc3b0ce04906f08a1580dd8e863b3511d8f2d237cb5bb4e60f2424c4f5ec2301
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m425fa0_lifted
# naming:       native port src/original_methods_fl40.c:m425fa0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 9/9 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c924d
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m425fa0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c924d, .text + (0x004c924d - 0x401000)

.org 0x00425fa0 - 0x401000
.globl FUN_00425fa0
FUN_00425fa0:
    # block 0x00425fa0: entry, 9 instruction(s), calls FUN_004c924d, ends with ret
    push ebp                                     # 00425fa0
    {load} mov ebp, esp                          # 00425fa1
    mov ax, word ptr [0x5b0266]                  # 00425fa3
    push eax                                     # 00425fa9
    mov ecx, 0x5cf659                            # 00425faa
    call FUN_004c924d                            # 00425faf
    mov dword ptr [0x5d1761], 0x1                # 00425fb4
    pop ebp                                      # 00425fbe
    ret                                          # 00425fbf

