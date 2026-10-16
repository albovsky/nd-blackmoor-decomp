# FUN_005211ff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005211ff
# extent:       0x005211ff-0x00521235 (54 code bytes)
# span:         0x005211ff-0x00521235 (code 54, tables 0, padding 0)
# sha256:       078ef5030b7e771ab66998eec020378f801e860920603865e197a38c3fbbb0d7
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005211ff
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1; [esp + n] stk_8
# callees:      calls KERNEL32.dll!GlobalFlags, KERNEL32.dll!GlobalUnlock, KERNEL32.dll!GlobalFree
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00521235
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x005211ff - 0x401000
.globl FUN_005211ff
FUN_005211ff:
    # block 0x005211ff: entry, 4 instruction(s), ends with je to 0x00521231 (forward)
    push edi                                     # 005211ff
    mov edi, dword ptr [esp + stk_8]             # 00521200
    test edi, edi                                # 00521204
    je.d8 L_00521231                             # 00521206
    # block 0x00521208: entered by fall-through of je at 0x00521206, 7 instruction(s), calls KERNEL32.dll!GlobalFlags, ends with je to 0x0052122a (forward)
    push edi                                     # 00521208
    call dword ptr [0x52a0e0]                    # 00521209
    and eax, 0xff                                # 0052120f
    {load} mov ecx, eax                          # 00521214
    dec eax                                      # 00521216
    test ecx, ecx                                # 00521217
    je.d8 L_0052122a                             # 00521219
    # block 0x0052121b: entered by fall-through of je at 0x00521219, 2 instruction(s), falls into the block at 0x0052121f
    push esi                                     # 0052121b
    lea esi, [eax + field_1]                     # 0052121c
L_0052121f:
    # block 0x0052121f: entered by jne at 0x00521227, 4 instruction(s), calls KERNEL32.dll!GlobalUnlock, ends with jne to 0x0052121f (backward)
    push edi                                     # 0052121f
    call dword ptr [0x52a208]                    # 00521220
    dec esi                                      # 00521226
    jne.d8 L_0052121f                            # 00521227
    # block 0x00521229: entered by fall-through of jne at 0x00521227, 1 instruction(s), falls into the block at 0x0052122a
    pop esi                                      # 00521229
L_0052122a:
    # block 0x0052122a: entered by je at 0x00521219, 2 instruction(s), calls KERNEL32.dll!GlobalFree, falls into the block at 0x00521231
    push edi                                     # 0052122a
    call dword ptr [0x52a20c]                    # 0052122b
L_00521231:
    # block 0x00521231: entered by je at 0x00521206, 2 instruction(s), ends with ret 0x4
    pop edi                                      # 00521231
    ret 0x4                                      # 00521232

