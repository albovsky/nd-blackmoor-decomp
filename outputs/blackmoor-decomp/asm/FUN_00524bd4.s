# FUN_00524bd4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524bd4
# extent:       0x00524bd4-0x00524c05 (49 code bytes)
# span:         0x00524bd4-0x00524c05 (code 49, tables 0, padding 0)
# sha256:       312aeb9570b8cb0243d58a76aecfa1888b4f3308f835c06293ebb07927a22e20
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00524b9c (+0x38)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524bd4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_005256dd, FUN_00525268
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00524c05
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_00525268, .text + (0x00525268 - 0x401000)
.set FUN_005256dd, .text + (0x005256dd - 0x401000)

.org 0x00524bd4 - 0x401000
.globl FUN_00524bd4
FUN_00524bd4:
    # block 0x00524bd4: entry, 11 instruction(s), calls FUN_0050f978, FUN_005256dd, ends with je to 0x00524bf9 (forward)
    mov eax, 0x528df1                            # 00524bd4
    call FUN_0050f978                            # 00524bd9
    push ecx                                     # 00524bde
    push 0x3c                                    # 00524bdf
    call FUN_005256dd                            # 00524be1
    {load} mov ecx, eax                          # 00524be6
    mov dword ptr [ebp - field_minus_10], ecx    # 00524be8
    {load} xor eax, eax                          # 00524beb
    {load} cmp ecx, eax                          # 00524bed
    mov dword ptr [ebp - field_minus_4], eax     # 00524bef
    je.d8 L_00524bf9                             # 00524bf2
    # block 0x00524bf4: entered by fall-through of je at 0x00524bf2, 1 instruction(s), calls FUN_00525268, falls into the block at 0x00524bf9
    call FUN_00525268                            # 00524bf4
L_00524bf9:
    # block 0x00524bf9: entered by je at 0x00524bf2, 4 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 00524bf9
    mov dword ptr fs:[0x0], ecx                  # 00524bfc
    leave                                        # 00524c03
    ret                                          # 00524c04

