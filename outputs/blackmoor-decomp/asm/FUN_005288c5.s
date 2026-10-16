# FUN_005288c5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005288c5
# extent:       0x005288c5-0x005288cf (10 code bytes)
# span:         0x005288c5-0x005288d0 (code 10, tables 0, padding 1)
# sha256:       4a3931937b00727e7abad5793f0a32938a55105d610093d615fb6b4ad1577a47
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005288ba (+0xb)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005288c5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0050c6c6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c6c6, .text + (0x0050c6c6 - 0x401000)

.org 0x005288c5 - 0x401000
.globl FUN_005288c5
FUN_005288c5:
    # block 0x005288c5: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x5335b0                            # 005288c5
    jmp.d32 FUN_0050c6c6                         # 005288ca

# --- data items (not part of the function) -------------------------
.org 0x005288cf - 0x401000
PAD_005288cf:  # 1 byte(s) of int3 padding
    .fill 1, 1, 0xcc

