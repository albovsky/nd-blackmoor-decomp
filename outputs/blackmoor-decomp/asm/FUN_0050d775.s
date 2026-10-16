# FUN_0050d775
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d775
# extent:       0x0050d775-0x0050d787 (18 code bytes)
# span:         0x0050d775-0x0050d787 (code 18, tables 0, padding 0)
# sha256:       f08b5f4550f61873da85812c9ed808ffb1b8d3a95f4c91123034d42c9cadc5e1
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d775
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0050d6f7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050d787
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050d6f7, .text + (0x0050d6f7 - 0x401000)

.org 0x0050d775 - 0x401000
.globl FUN_0050d775
FUN_0050d775:
    # block 0x0050d775: entry, 8 instruction(s), calls FUN_0050d6f7, ends with ret
    push dword ptr [esp + stk_4]                 # 0050d775
    call FUN_0050d6f7                            # 0050d779
    neg eax                                      # 0050d77e
    {load} sbb eax, eax                          # 0050d780
    pop ecx                                      # 0050d782
    neg eax                                      # 0050d783
    dec eax                                      # 0050d785
    ret                                          # 0050d786

