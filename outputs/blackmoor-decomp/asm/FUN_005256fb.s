# FUN_005256fb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005256fb
# extent:       0x005256fb-0x0052570f (20 code bytes)
# span:         0x005256fb-0x0052570f (code 20, tables 0, padding 0)
# sha256:       b38e645528511c9032772e76f4ad5c78e270f69a9e944032754dfbd647fde401
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005256fb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls KERNEL32.dll!LocalFree
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x005256fb - 0x401000
.globl FUN_005256fb
FUN_005256fb:
    # block 0x005256fb: entry, 2 instruction(s), ends with je to 0x0052570c (forward)
    cmp dword ptr [esp + stk_4], 0x0             # 005256fb
    je.d8 L_0052570c                             # 00525700
    # block 0x00525702: entered by fall-through of je at 0x00525700, 2 instruction(s), calls KERNEL32.dll!LocalFree, falls into the block at 0x0052570c
    push dword ptr [esp + stk_4]                 # 00525702
    call dword ptr [0x52a1d8]                    # 00525706
L_0052570c:
    # block 0x0052570c: entered by je at 0x00525700, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0052570c

