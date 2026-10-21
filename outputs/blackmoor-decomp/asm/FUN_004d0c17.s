# FUN_004d0c17
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d0c17
# extent:       0x004d0c17-0x004d0c57 (64 code bytes)
# span:         0x004d0c17-0x004d0c57 (code 64, tables 0, padding 0)
# sha256:       8f85e3e936eede69ce7f537266189646a90d32ecfac77fd15d7f31d841e7a9f2
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d0c17_post_message
# naming:       native port src/original_methods_fl34c.c:m4d0c17_post_message (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Same body as 0x4d0abc with globals 0x5d2bdb/df/e3, text 0x55a0e8 and cleared word 0x63a97e; constants verified from its own disassembly; 0x4c5377 pops 0x14.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34c.c:m4d0c17_post_message (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004d0c17 - 0x401000
.globl FUN_004d0c17
FUN_004d0c17:
    # block 0x004d0c17: entry, 17 instruction(s), calls FUN_004c5377, ends with ret
    push ebp                                     # 004d0c17
    {load} mov ebp, esp                          # 004d0c18
    push 0x55a0e8                                # 004d0c1a
    mov eax, dword ptr [0x5d2be3]                # 004d0c1f
    push eax                                     # 004d0c24
    mov ecx, dword ptr [0x5d2bdf]                # 004d0c25
    push ecx                                     # 004d0c2b
    mov edx, dword ptr [0x5cf665]                # 004d0c2c
    push edx                                     # 004d0c32
    mov eax, dword ptr [0x5d2bdb]                # 004d0c33
    push eax                                     # 004d0c38
    mov ecx, 0x5cf659                            # 004d0c39
    call FUN_004c5377                            # 004d0c3e
    mov word ptr [0x5bb1c4], 0x2                 # 004d0c43
    mov word ptr [0x63a97e], 0x0                 # 004d0c4c
    pop ebp                                      # 004d0c55
    ret                                          # 004d0c56

