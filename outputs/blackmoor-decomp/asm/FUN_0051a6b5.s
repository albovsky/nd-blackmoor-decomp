# FUN_0051a6b5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a6b5
# extent:       0x0051a6b5-0x0051a6cb (22 code bytes)
# span:         0x0051a6b5-0x0051a6cb (code 22, tables 0, padding 0)
# sha256:       db782356bab288f45a4ef5c54981d549dbf29720500767871b817e3a1c686cc4
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051a643 (+0x72)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a6b5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls USER32.dll!RegisterWindowMessageA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051a6cb
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0051a6b5 - 0x401000
.globl FUN_0051a6b5
FUN_0051a6b5:
    # block 0x0051a6b5: entry, 1 instruction(s), ends with forward jump to 0x0051a6ba
    jmp.d32 L_0051a6ba                           # 0051a6b5
L_0051a6ba:
    # block 0x0051a6ba: entered by jmp at 0x0051a6b5, 4 instruction(s), calls USER32.dll!RegisterWindowMessageA, ends with ret
    push 0x52ea44                                # 0051a6ba
    call dword ptr [0x52a460]                    # 0051a6bf
    mov dword ptr [0x63c354], eax                # 0051a6c5
    ret                                          # 0051a6ca

