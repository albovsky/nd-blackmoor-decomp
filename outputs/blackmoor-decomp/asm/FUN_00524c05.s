# FUN_00524c05
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524c05
# extent:       0x00524c05-0x00524c1a (21 code bytes)
# span:         0x00524c05-0x00524c1a (code 21, tables 0, padding 0)
# sha256:       c5d9e8f0f9a5c108f070cfd7dd66444bff8e3fb3fcee6fbdfdb988427bee2f11
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00524b9c (+0x69)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524c05
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005256dd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_005256dd, .text + (0x005256dd - 0x401000)

.org 0x00524c05 - 0x401000
.globl FUN_00524c05
FUN_00524c05:
    # block 0x00524c05: entry, 4 instruction(s), calls FUN_005256dd, ends with je to 0x00524c17 (forward)
    push 0x4                                     # 00524c05
    call FUN_005256dd                            # 00524c07
    test eax, eax                                # 00524c0c
    je.d8 L_00524c17                             # 00524c0e
    # block 0x00524c10: entered by fall-through of je at 0x00524c0e, 2 instruction(s), ends with ret
    mov dword ptr [eax], 0x52f440                # 00524c10
    ret                                          # 00524c16
L_00524c17:
    # block 0x00524c17: entered by je at 0x00524c0e, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00524c17
    ret                                          # 00524c19

