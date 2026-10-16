# FUN_0051e745
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e745
# extent:       0x0051e745-0x0051e763 (30 code bytes)
# span:         0x0051e745-0x0051e763 (code 30, tables 0, padding 0)
# sha256:       d3349292ac482a61e01e7d3de96fc1004244f98117c3ac78c245cd896e11cf88
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e745
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_8, field_minus_c
# callees:      calls tail jump FUN_0051e6f1, FUN_0051e8f7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc

# --- external targets -----------------------------------------------
.set FUN_0051e6f1, .text + (0x0051e6f1 - 0x401000)
.set FUN_0051e8f7, .text + (0x0051e8f7 - 0x401000)

.org 0x0051e745 - 0x401000
.globl FUN_0051e745
FUN_0051e745:
    # block 0x0051e745: entry, 3 instruction(s), ends with je to 0x0051e762 (forward)
    mov eax, dword ptr [ecx]                     # 0051e745
    cmp dword ptr [eax - field_minus_8], 0x0     # 0051e747
    je.d8 L_0051e762                             # 0051e74b
    # block 0x0051e74d: entered by fall-through of je at 0x0051e74b, 2 instruction(s), ends with jl to 0x0051e758 (forward)
    cmp dword ptr [eax - field_minus_c], 0x0     # 0051e74d
    jl.d8 L_0051e758                             # 0051e751
    # block 0x0051e753: entered by fall-through of jl at 0x0051e751, 1 instruction(s), ends with backward jump to 0x0051e6f1
    jmp.d32 FUN_0051e6f1                         # 0051e753
L_0051e758:
    # block 0x0051e758: entered by jl at 0x0051e751, 2 instruction(s), calls FUN_0051e8f7, falls into the block at 0x0051e762
    push 0x63c418                                # 0051e758
    call FUN_0051e8f7                            # 0051e75d
L_0051e762:
    # block 0x0051e762: entered by je at 0x0051e74b, 1 instruction(s), ends with ret
    ret                                          # 0051e762

