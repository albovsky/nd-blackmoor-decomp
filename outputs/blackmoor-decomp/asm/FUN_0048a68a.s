# FUN_0048a68a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a68a
# extent:       0x0048a68a-0x0048a69a (16 code bytes)
# span:         0x0048a68a-0x0048a69a (code 16, tables 0, padding 0)
# sha256:       043100dd55e6f1f0c0ec7c6a34e01f5228726f431c9124dd62df0c86c08dc0a8
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48a68a_get_constant
# naming:       native port src/original_methods_fl36b.c:m48a68a_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d8a0u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m48a68a_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0048a68a - 0x401000
.globl FUN_0048a68a
FUN_0048a68a:
    # block 0x0048a68a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0048a68a
    {load} mov ebp, esp                          # 0048a68b
    push ecx                                     # 0048a68d
    mov dword ptr [ebp - local_4], ecx           # 0048a68e
    mov eax, 0x52d8a0                            # 0048a691
    {load} mov esp, ebp                          # 0048a696
    pop ebp                                      # 0048a698
    ret                                          # 0048a699

