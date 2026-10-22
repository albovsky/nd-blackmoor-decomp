# FUN_0051e7ba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e7ba
# extent:       0x0051e7ba-0x0051e7e4 (42 code bytes)
# span:         0x0051e7ba-0x0051e7e4 (code 42, tables 0, padding 0)
# sha256:       55e7e58804caf60fe8d384c84895fe88307f9f9de956834d5a82b6be929c689f
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e7ba
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_c
# callees:      calls KERNEL32.dll!InterlockedDecrement, FUN_0051e6a9
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41be1a_lifted (function ledger class candidate_port; also m41bebc_lifted, m426428_lifted, m434d56_lifted, m44a488_lifted, m46e66a_lifted, m46f77c_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_c, 0xc  # offset -0xc

# --- external targets -----------------------------------------------
.set FUN_0051e6a9, .text + (0x0051e6a9 - 0x401000)

.org 0x0051e7ba - 0x401000
.globl FUN_0051e7ba
FUN_0051e7ba:
    # block 0x0051e7ba: entry, 6 instruction(s), ends with je to 0x0051e7e2 (forward)
    push esi                                     # 0051e7ba
    {load} mov esi, ecx                          # 0051e7bb
    mov eax, dword ptr [esi]                     # 0051e7bd
    lea ecx, [eax - field_minus_c]               # 0051e7bf
    cmp ecx, dword ptr [0x5679b4]                # 0051e7c2
    je.d8 L_0051e7e2                             # 0051e7c8
    # block 0x0051e7ca: entered by fall-through of je at 0x0051e7c8, 5 instruction(s), calls KERNEL32.dll!InterlockedDecrement, ends with jg to 0x0051e7e2 (forward)
    add eax, -0xc                                # 0051e7ca
    push eax                                     # 0051e7cd
    call dword ptr [0x52a1fc]                    # 0051e7ce
    test eax, eax                                # 0051e7d4
    jg.d8 L_0051e7e2                             # 0051e7d6
    # block 0x0051e7d8: entered by fall-through of jg at 0x0051e7d6, 3 instruction(s), calls FUN_0051e6a9, falls into the block at 0x0051e7e2
    mov ecx, dword ptr [esi]                     # 0051e7d8
    sub ecx, 0xc                                 # 0051e7da
    call FUN_0051e6a9                            # 0051e7dd
L_0051e7e2:
    # block 0x0051e7e2: entered by je at 0x0051e7c8; jg at 0x0051e7d6, 2 instruction(s), ends with ret
    pop esi                                      # 0051e7e2
    ret                                          # 0051e7e3

