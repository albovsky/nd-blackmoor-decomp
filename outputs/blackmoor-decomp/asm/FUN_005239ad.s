# FUN_005239ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005239ad
# extent:       0x005239ad-0x005239bd (16 code bytes)
# span:         0x005239ad-0x005239bd (code 16, tables 0, padding 0)
# sha256:       bb8f608f0db55d1af02493c5c53568e56d4a236e5513f2857cd101dd6cccedb8
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0052398b (+0x22)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005239ad
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_3c
# callees:      calls FUN_0052398b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_3c, 0x3c  # offset +0x3c

# --- external targets -----------------------------------------------
.set FUN_0052398b, .text + (0x0052398b - 0x401000)

.org 0x005239ad - 0x401000
.globl FUN_005239ad
FUN_005239ad:
    # block 0x005239ad: entry, 3 instruction(s), calls FUN_0052398b, ends with je to 0x005239ba (forward)
    call FUN_0052398b                            # 005239ad
    test eax, eax                                # 005239b2
    je.d8 L_005239ba                             # 005239b4
    # block 0x005239b6: entered by fall-through of je at 0x005239b4, 2 instruction(s), ends with ret
    mov eax, dword ptr [eax + field_3c]          # 005239b6
    ret                                          # 005239b9
L_005239ba:
    # block 0x005239ba: entered by je at 0x005239b4, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 005239ba
    ret                                          # 005239bc

