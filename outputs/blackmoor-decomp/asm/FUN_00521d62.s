# FUN_00521d62
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521d62
# extent:       0x00521d62-0x00521d70 (14 code bytes)
# span:         0x00521d62-0x00521d70 (code 14, tables 0, padding 0)
# sha256:       350a2644f5f6f64a8429f30175860d10eebc83084591eb0984bb2f84ed59d98f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00521bed (+0x175)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521d62
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0051b4ac
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051b4ac, .text + (0x0051b4ac - 0x401000)

.org 0x00521d62 - 0x401000
.globl FUN_00521d62
FUN_00521d62:
    # block 0x00521d62: entry, 4 instruction(s), calls FUN_0051b4ac, ends with ret 0x4
    push dword ptr [esp + stk_4]                 # 00521d62
    call FUN_0051b4ac                            # 00521d66
    {load} xor eax, eax                          # 00521d6b
    ret 0x4                                      # 00521d6d

