# FUN_0050c27d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c27d
# extent:       0x0050c27d-0x0050c284 (7 code bytes)
# span:         0x0050c27d-0x0050c284 (code 7, tables 0, padding 0)
# sha256:       26f64aad5eb8473855339a13c48660e414941e1fda1f802791c31167d48e455e
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c27d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0050c27d - 0x401000
.globl FUN_0050c27d
FUN_0050c27d:
    # block 0x0050c27d: entry, 2 instruction(s), ends with ret
    mov dword ptr [ecx], 0x52fda8                # 0050c27d
    ret                                          # 0050c283

