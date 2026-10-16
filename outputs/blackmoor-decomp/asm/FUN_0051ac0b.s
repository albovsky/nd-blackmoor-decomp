# FUN_0051ac0b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ac0b
# extent:       0x0051ac0b-0x0051ac29 (30 code bytes)
# span:         0x0051ac0b-0x0051ac29 (code 30, tables 0, padding 0)
# sha256:       7df36ad7ae502d931396c589d1318c64bf70a3a10366c8a12e5d05d35466a145
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ac0b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0051ab72, FUN_0051a57e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051a57e, .text + (0x0051a57e - 0x401000)
.set FUN_0051ab72, .text + (0x0051ab72 - 0x401000)

.org 0x0051ac0b - 0x401000
.globl FUN_0051ac0b
FUN_0051ac0b:
    # block 0x0051ac0b: entry, 6 instruction(s), calls FUN_0051ab72, ends with je to 0x0051ac26 (forward)
    push 0x0                                     # 0051ac0b
    call FUN_0051ab72                            # 0051ac0d
    {load} mov ecx, eax                          # 0051ac12
    {load} xor eax, eax                          # 0051ac14
    test ecx, ecx                                # 0051ac16
    je.d8 L_0051ac26                             # 0051ac18
    # block 0x0051ac1a: entered by fall-through of je at 0x0051ac18, 3 instruction(s), calls FUN_0051a57e, falls into the block at 0x0051ac26
    push dword ptr [esp + stk_4]                 # 0051ac1a
    add ecx, 0x4                                 # 0051ac1e
    call FUN_0051a57e                            # 0051ac21
L_0051ac26:
    # block 0x0051ac26: entered by je at 0x0051ac18, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0051ac26

