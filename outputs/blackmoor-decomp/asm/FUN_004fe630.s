# FUN_004fe630
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fe630
# extent:       0x004fe630-0x004fe633 (3 code bytes)
# span:         0x004fe630-0x004fe640 (code 3, tables 0, padding 13)
# sha256:       4bc724f3b1d0caf4fe369c18cba3102e6c4ea057f63fe1587e3973134a7f755e
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fe630
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x004fe630 - 0x401000
.globl FUN_004fe630
FUN_004fe630:
    # block 0x004fe630: entry, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 004fe630
    ret                                          # 004fe632

# --- data items (not part of the function) -------------------------
.org 0x004fe633 - 0x401000
PAD_004fe633:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

