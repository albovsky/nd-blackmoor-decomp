# FUN_00521014
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521014
# extent:       0x00521014-0x0052102d (25 code bytes)
# span:         0x00521014-0x0052102d (code 25, tables 0, padding 0)
# sha256:       c63bded6b5fdedff68d99dda62fb584a2c2df874b0bafcb7ae525579992cac8b
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        ebp
# ending:       call-end (the code part ends in a call with no instruction after it; the call may or may not return, so it is counted only bound together with the range at 0x0052102d that follows it, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521014
# arguments:    no [ebp+n] stack argument slot referenced; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050f997
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; the code part ends in a call with no instruction after it, whether the callee returns is not proven here, and the entry is counted only bound together with the range at 0x0052102d that follows it (owner ruling of 2026-10-16)
# note:         call_without_fallthrough:0x00521028
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0050f997, .text + (0x0050f997 - 0x401000)

.org 0x00521014 - 0x401000
.globl FUN_00521014
FUN_00521014:
    # block 0x00521014: entry, 8 instruction(s), calls FUN_0050f997, ends with call 0x50f997 and no instruction after it in this entry; if the call returns, execution continues in the entry at 0x0052102d, which is bound together with this one
    push ebp                                     # 00521014
    {load} mov ebp, esp                          # 00521015
    push ecx                                     # 00521017
    lea eax, [ebp - local_4]                     # 00521018
    push 0x534470                                # 0052101b
    push eax                                     # 00521020
    mov dword ptr [ebp - local_4], 0x63c4e8      # 00521021
    call FUN_0050f997                            # 00521028

