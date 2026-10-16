# FUN_0051e51c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e51c
# extent:       0x0051e51c-0x0051e52f (19 code bytes)
# span:         0x0051e51c-0x0051e52f (code 19, tables 0, padding 0)
# sha256:       661a7057be134092754087dd1ef19f3d2782d4f98d84e286a8a1fd5ed9f08a59
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051e4de (+0x3e)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e51c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_3c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_3c, 0x3c  # offset +0x3c

# --- external targets -----------------------------------------------

.org 0x0051e51c - 0x401000
.globl FUN_0051e51c
FUN_0051e51c:
    # block 0x0051e51c: entry, 3 instruction(s), ends with je to 0x0051e52a (forward)
    mov eax, dword ptr [ecx + field_3c]          # 0051e51c
    test eax, eax                                # 0051e51f
    je.d8 L_0051e52a                             # 0051e521
    # block 0x0051e523: entered by fall-through of je at 0x0051e521, 2 instruction(s), ends with forward jump to 0x0051e52c
    add eax, 0x20000                             # 0051e523
    jmp.d8 L_0051e52c                            # 0051e528
L_0051e52a:
    # block 0x0051e52a: entered by je at 0x0051e521, 1 instruction(s), falls into the block at 0x0051e52c
    {load} xor eax, eax                          # 0051e52a
L_0051e52c:
    # block 0x0051e52c: entered by jmp at 0x0051e528, 1 instruction(s), ends with ret 0x8
    ret 0x8                                      # 0051e52c

