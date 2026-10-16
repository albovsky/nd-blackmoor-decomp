# FUN_0052615c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052615c
# extent:       0x0052615c-0x0052617a (30 code bytes)
# span:         0x0052615c-0x0052617a (code 30, tables 0, padding 0)
# sha256:       aa2a674020d255307f7c99e146388b344aabd2723e4bd6a8744546455b0c2388
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005260ac (+0xb0)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052615c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8
# callees:      calls FUN_005256dd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005256dd, .text + (0x005256dd - 0x401000)

.org 0x0052615c - 0x401000
.globl FUN_0052615c
FUN_0052615c:
    # block 0x0052615c: entry, 4 instruction(s), calls FUN_005256dd, ends with je to 0x00526177 (forward)
    push 0xc                                     # 0052615c
    call FUN_005256dd                            # 0052615e
    test eax, eax                                # 00526163
    je.d8 L_00526177                             # 00526165
    # block 0x00526167: entered by fall-through of je at 0x00526165, 4 instruction(s), ends with ret
    and dword ptr [eax + field_4], 0x0           # 00526167
    and word ptr [eax + field_8], 0x0            # 0052616b
    mov dword ptr [eax], 0x52ff4c                # 00526170
    ret                                          # 00526176
L_00526177:
    # block 0x00526177: entered by je at 0x00526165, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00526177
    ret                                          # 00526179

