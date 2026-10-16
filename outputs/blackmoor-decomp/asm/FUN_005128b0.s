# FUN_005128b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005128b0
# extent:       0x005128b0-0x005128b7 (7 code bytes)
# span:         0x005128b0-0x005128c0 (code 7, tables 0, padding 9)
# sha256:       31c7c51054b39a8a3d95b0c921efa1e98353c95313759c7b45fdea6d1dd12d3a
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005128b0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls tail jump LOC_00512921
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set LOC_00512921, .text + (0x00512921 - 0x401000)

.org 0x005128b0 - 0x401000
.globl FUN_005128b0
FUN_005128b0:
    # block 0x005128b0: entry, 3 instruction(s), ends with forward jump to 0x00512921
    push edi                                     # 005128b0
    mov edi, dword ptr [esp + stk_8]             # 005128b1
    jmp.d8 . + (108)  # -> LOC_00512921          # 005128b5

# --- data items (not part of the function) -------------------------
.org 0x005128b7 - 0x401000
PAD_005128b7:  # 9 byte(s) of alignment instructions
    {disp32} lea esp, [esp]
    {load} mov edi, edi

