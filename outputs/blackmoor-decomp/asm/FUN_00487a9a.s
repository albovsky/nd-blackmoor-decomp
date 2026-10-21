# FUN_00487a9a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487a9a
# extent:       0x00487a9a-0x00487aaa (16 code bytes)
# span:         0x00487a9a-0x00487aaa (code 16, tables 0, padding 0)
# sha256:       356eee34ddb0d37491f656f28e46ae09124b36d95056e9820e46e796e8bdd2a0
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m487a9a_get_constant
# naming:       native port src/original_methods_fl36b.c:m487a9a_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d790u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m487a9a_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00487a9a - 0x401000
.globl FUN_00487a9a
FUN_00487a9a:
    # block 0x00487a9a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00487a9a
    {load} mov ebp, esp                          # 00487a9b
    push ecx                                     # 00487a9d
    mov dword ptr [ebp - local_4], ecx           # 00487a9e
    mov eax, 0x52d790                            # 00487aa1
    {load} mov esp, ebp                          # 00487aa6
    pop ebp                                      # 00487aa8
    ret                                          # 00487aa9

