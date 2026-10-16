# FUN_00528e8c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528e8c
# extent:       0x00528e8c-0x00528ea3 (23 code bytes)
# span:         0x00528e8c-0x00528ea3 (code 23, tables 0, padding 0)
# sha256:       a56872d566c623732aafd87381017090cdc2a3edeaf371ef2af5773ac271224d
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528e8c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_minus_10
# callees:      calls tail jump FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00528e8c - 0x401000
.globl FUN_00528e8c
FUN_00528e8c:
    # block 0x00528e8c: entry, 4 instruction(s), ends with je to 0x00528ea2 (forward)
    mov eax, dword ptr [ebp - field_minus_10]    # 00528e8c
    and eax, 0x1                                 # 00528e8f
    test eax, eax                                # 00528e92
    je.d32 L_00528ea2                            # 00528e94
    # block 0x00528e9a: entered by fall-through of je at 0x00528e94, 2 instruction(s), ends with backward jump to 0x0051e7ba
    mov ecx, dword ptr [ebp + field_8]           # 00528e9a
    jmp.d32 FUN_0051e7ba                         # 00528e9d
L_00528ea2:
    # block 0x00528ea2: entered by je at 0x00528e94, 1 instruction(s), ends with ret
    ret                                          # 00528ea2

