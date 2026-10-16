# FUN_005217c4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005217c4
# extent:       0x005217c4-0x005217de (26 code bytes)
# span:         0x005217c4-0x005217de (code 26, tables 0, padding 0)
# sha256:       cf6707dc037ad634cf51ae8713e24898e4460c1fd4e7676ddc9e804b008ec70d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005217be (+0x6)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005217c4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_c
# callees:      calls FUN_0051b0e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         unreachable_code_entry:0x005217c6
# note:         further_unindexed_code_at:0x005217de
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_c, 0xc  # offset -0xc

# --- external targets -----------------------------------------------
.set FUN_0051b0e3, .text + (0x0051b0e3 - 0x401000)

.org 0x005217c4 - 0x401000
.globl FUN_005217c4
FUN_005217c4:
    # block 0x005217c4: entry, 1 instruction(s), ends with forward jump to 0x005217cb
    jmp.d8 L_005217cb                            # 005217c4
    # block 0x005217c6: entered by follows jmp at 0x005217c4, 1 instruction(s), calls FUN_0051b0e3, falls into the block at 0x005217cb
    call FUN_0051b0e3                            # 005217c6
L_005217cb:
    # block 0x005217cb: entered by jmp at 0x005217c4, 8 instruction(s), ends with ret 0xc
    {load} xor eax, eax                          # 005217cb
    mov ecx, dword ptr [ebp - field_minus_c]     # 005217cd
    pop edi                                      # 005217d0
    pop esi                                      # 005217d1
    mov dword ptr fs:[0x0], ecx                  # 005217d2
    pop ebx                                      # 005217d9
    leave                                        # 005217da
    ret 0xc                                      # 005217db

