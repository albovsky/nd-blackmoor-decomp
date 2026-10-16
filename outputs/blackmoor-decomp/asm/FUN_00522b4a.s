# FUN_00522b4a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522b4a
# extent:       0x00522b4a-0x00522b60 (22 code bytes)
# span:         0x00522b4a-0x00522b60 (code 22, tables 0, padding 0)
# sha256:       f3a9874f2572a37ee522ba09caae5dae22518d6702fad2b6ee655ff554fb93a8
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00522af2 (+0x58)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522b4a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_8c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8c, 0x8c  # offset +0x8c

# --- external targets -----------------------------------------------

.org 0x00522b4a - 0x401000
.globl FUN_00522b4a
FUN_00522b4a:
    # block 0x00522b4a: entry, 3 instruction(s), ends with je to 0x00522b5b (forward)
    mov eax, dword ptr [ecx + field_8c]          # 00522b4a
    test eax, eax                                # 00522b50
    je.d8 L_00522b5b                             # 00522b52
    # block 0x00522b54: entered by fall-through of je at 0x00522b52, 2 instruction(s), ends with forward jump to 0x00522b5d
    add eax, 0x20000                             # 00522b54
    jmp.d8 L_00522b5d                            # 00522b59
L_00522b5b:
    # block 0x00522b5b: entered by je at 0x00522b52, 1 instruction(s), falls into the block at 0x00522b5d
    {load} xor eax, eax                          # 00522b5b
L_00522b5d:
    # block 0x00522b5d: entered by jmp at 0x00522b59, 1 instruction(s), ends with ret 0x8
    ret 0x8                                      # 00522b5d

