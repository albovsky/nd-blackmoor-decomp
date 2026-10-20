# FUN_00528a1c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528a1c
# extent:       0x00528a1c-0x00528a26 (10 code bytes)
# span:         0x00528a1c-0x00528a30 (code 10, tables 0, padding 10)
# sha256:       0b2d8e6d53b8166f3436b560fac9ebb279d6e53cd1fe78034d437d6f46da3ff2
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00528a13 (+0x9)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         eh_handler_stub_of_004e7684
# naming:       function-xrefs.json eh_stubs entry (container 0x00528a13); a structural fact about the bytes
# name-note:    The compiler's exception handler stub (loads the FuncInfo at 0x00533760 and jumps to the shared handler) of the function at 0x004e7684
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0050c6c6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name states a structural role that function-xrefs.json records about the bytes; it is not read from this code and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c6c6, .text + (0x0050c6c6 - 0x401000)

.org 0x00528a1c - 0x401000
.globl FUN_00528a1c
FUN_00528a1c:
    # block 0x00528a1c: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x533760                            # 00528a1c
    jmp.d32 FUN_0050c6c6                         # 00528a21

# --- data items (not part of the function) -------------------------
.org 0x00528a26 - 0x401000
PAD_00528a26:  # 10 byte(s) of int3 padding
    .fill 10, 1, 0xcc

