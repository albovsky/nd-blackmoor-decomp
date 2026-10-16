# FUN_005246ee
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005246ee
# extent:       0x005246ee-0x00524704 (22 code bytes)
# span:         0x005246ee-0x00524704 (code 22, tables 0, padding 0)
# sha256:       4dc39152f9b496f9eafe356008ea94c17387e2b18dcf9a71c9d275924449a5fb
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005246cf (+0x1f)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005246ee
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_98
# callees:      calls FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_98, 0x98  # offset +0x98

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x005246ee - 0x401000
.globl FUN_005246ee
FUN_005246ee:
    # block 0x005246ee: entry, 2 instruction(s), ends with je to 0x005246fc (forward)
    cmp dword ptr [ecx + field_98], 0x0          # 005246ee
    je.d8 L_005246fc                             # 005246f5
    # block 0x005246f7: entered by fall-through of je at 0x005246f5, 3 instruction(s), ends with forward jump to 0x00524701
    push 0x1                                     # 005246f7
    pop eax                                      # 005246f9
    jmp.d8 L_00524701                            # 005246fa
L_005246fc:
    # block 0x005246fc: entered by je at 0x005246f5, 1 instruction(s), calls FUN_0051ab4b, falls into the block at 0x00524701
    call FUN_0051ab4b                            # 005246fc
L_00524701:
    # block 0x00524701: entered by jmp at 0x005246fa, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 00524701

