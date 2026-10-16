# FUN_00525ebc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525ebc
# extent:       0x00525ebc-0x00525ed8 (28 code bytes)
# span:         0x00525ebc-0x00525ed8 (code 28, tables 0, padding 0)
# sha256:       39f7a59064b840a7c0826c0051cfc75bd0eec54e1fbe425fb2f28d487745a342
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00525e69 (+0x53)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525ebc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4
# callees:      calls FUN_0050c575
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050c575, .text + (0x0050c575 - 0x401000)

.org 0x00525ebc - 0x401000
.globl FUN_00525ebc
FUN_00525ebc:
    # block 0x00525ebc: entry, 4 instruction(s), calls FUN_0050c575, ends with je to 0x00525ed5 (forward)
    mov ecx, 0x63c7c0                            # 00525ebc
    call FUN_0050c575                            # 00525ec1
    test eax, eax                                # 00525ec6
    je.d8 L_00525ed5                             # 00525ec8
    # block 0x00525eca: entered by fall-through of je at 0x00525ec8, 3 instruction(s), ends with ret
    and dword ptr [eax + field_4], 0x0           # 00525eca
    mov dword ptr [eax], 0x52ff2c                # 00525ece
    ret                                          # 00525ed4
L_00525ed5:
    # block 0x00525ed5: entered by je at 0x00525ec8, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00525ed5
    ret                                          # 00525ed7

