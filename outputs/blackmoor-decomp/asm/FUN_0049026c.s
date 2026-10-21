# FUN_0049026c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049026c
# extent:       0x0049026c-0x0049027c (16 code bytes)
# span:         0x0049026c-0x0049027c (code 16, tables 0, padding 0)
# sha256:       565fc161bf5c56051c613fad6bd2751f2054636c2e15be761998d32120031fea
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m49026c_get_constant
# naming:       native port src/original_methods_fl36b.c:m49026c_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52da50u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m49026c_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0049026c - 0x401000
.globl FUN_0049026c
FUN_0049026c:
    # block 0x0049026c: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0049026c
    {load} mov ebp, esp                          # 0049026d
    push ecx                                     # 0049026f
    mov dword ptr [ebp - local_4], ecx           # 00490270
    mov eax, 0x52da50                            # 00490273
    {load} mov esp, ebp                          # 00490278
    pop ebp                                      # 0049027a
    ret                                          # 0049027b

