# FUN_00523992
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523992
# extent:       0x00523992-0x005239ad (27 code bytes)
# span:         0x00523992-0x005239ad (code 27, tables 0, padding 0)
# sha256:       d03e6161a69fa90dc99555caad364816a5f05f3c0a0a1a5d2cee953b934d90e5
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0052398b (+0x7)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523992
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_98
# callees:      calls FUN_0051d699, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005239ad
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_98, 0x98  # offset +0x98

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051d699, .text + (0x0051d699 - 0x401000)

.org 0x00523992 - 0x401000
.globl FUN_00523992
FUN_00523992:
    # block 0x00523992: entry, 3 instruction(s), ends with je to 0x005239a5 (forward)
    mov eax, dword ptr [ecx + field_98]          # 00523992
    test eax, eax                                # 00523998
    je.d8 L_005239a5                             # 0052399a
    # block 0x0052399c: entered by fall-through of je at 0x0052399a, 3 instruction(s), calls FUN_0051d699, ends with forward jump to 0x005239aa
    {load} mov ecx, eax                          # 0052399c
    call FUN_0051d699                            # 0052399e
    jmp.d8 L_005239aa                            # 005239a3
L_005239a5:
    # block 0x005239a5: entered by je at 0x0052399a, 1 instruction(s), calls FUN_0051ab4b, falls into the block at 0x005239aa
    call FUN_0051ab4b                            # 005239a5
L_005239aa:
    # block 0x005239aa: entered by jmp at 0x005239a3, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 005239aa

