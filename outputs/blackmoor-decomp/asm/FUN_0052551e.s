# FUN_0052551e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052551e
# extent:       0x0052551e-0x00525523 (5 code bytes)
# span:         0x0052551e-0x00525523 (code 5, tables 0, padding 0)
# sha256:       5c390136992cfd232e4f9d9d9fb3e4e6cd46322ca93a7b4bfb66aad9785481da
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005254fe (+0x20)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         jump_thunk_to_00520b14
# naming:       function-xrefs.json thunks entry (kind jump, container 0x005254fe); a structural fact about the bytes
# name-note:    A 5-byte direct jump to 0x00520b14, the whole body of the entry
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_00520b14
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name states a structural role that function-xrefs.json records about the bytes; it is not read from this code and not a recovered name
# note:         further_unindexed_code_at:0x00525523
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00520b14, .text + (0x00520b14 - 0x401000)

.org 0x0052551e - 0x401000
.globl FUN_0052551e
FUN_0052551e:
    # block 0x0052551e: entry, 1 instruction(s), ends with backward jump to 0x00520b14
    jmp.d32 FUN_00520b14                         # 0052551e

