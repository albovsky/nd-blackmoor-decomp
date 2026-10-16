# FUN_0052505e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052505e
# extent:       0x0052505e-0x00525093 (53 code bytes)
# span:         0x0052505e-0x00525093 (code 53, tables 0, padding 0)
# sha256:       aaed30c2cc14a30757910bee8765ad33cd6a047ee3772c19af0a3f1d9c9de61b
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052505e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_0051dc43, FUN_005227c6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525093
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_005227c6, .text + (0x005227c6 - 0x401000)

.org 0x0052505e - 0x401000
.globl FUN_0052505e
FUN_0052505e:
    # block 0x0052505e: entry, 12 instruction(s), calls FUN_0050f978, FUN_0051dc43, ends with je to 0x00525087 (forward)
    mov eax, 0x528fa9                            # 0052505e
    call FUN_0050f978                            # 00525063
    push ecx                                     # 00525068
    push 0xbc                                    # 00525069
    call FUN_0051dc43                            # 0052506e
    pop ecx                                      # 00525073
    {load} mov ecx, eax                          # 00525074
    mov dword ptr [ebp - field_minus_10], ecx    # 00525076
    {load} xor eax, eax                          # 00525079
    {load} cmp ecx, eax                          # 0052507b
    mov dword ptr [ebp - field_minus_4], eax     # 0052507d
    je.d8 L_00525087                             # 00525080
    # block 0x00525082: entered by fall-through of je at 0x00525080, 1 instruction(s), calls FUN_005227c6, falls into the block at 0x00525087
    call FUN_005227c6                            # 00525082
L_00525087:
    # block 0x00525087: entered by je at 0x00525080, 4 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 00525087
    mov dword ptr fs:[0x0], ecx                  # 0052508a
    leave                                        # 00525091
    ret                                          # 00525092

