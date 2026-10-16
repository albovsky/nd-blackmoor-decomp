# FUN_0051a801
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a801
# extent:       0x0051a801-0x0051a82d (44 code bytes)
# span:         0x0051a801-0x0051a82d (code 44, tables 0, padding 0)
# sha256:       38cc3b0497be3959b316e74732d880831b4d9a65a04d8483dc660ba39a006747
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a801
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_1c; [esp + n] stk_18
# callees:      calls FUN_0051d716, FUN_0050f920
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0051a801 - 0x401000
.globl FUN_0051a801
FUN_0051a801:
    # block 0x0051a801: entry, 17 instruction(s), calls FUN_0051d716, FUN_0050f920, ends with ret 0x4
    push esi                                     # 0051a801
    push edi                                     # 0051a802
    {load} mov esi, ecx                          # 0051a803
    call FUN_0051d716                            # 0051a805
    lea edi, [esi + field_1c]                    # 0051a80a
    push 0x20                                    # 0051a80d
    push 0x0                                     # 0051a80f
    push edi                                     # 0051a811
    mov dword ptr [esi], 0x52ea60                # 0051a812
    call FUN_0050f920                            # 0051a818
    mov eax, dword ptr [esp + stk_18]            # 0051a81d
    add esp, 0xc                                 # 0051a821
    mov dword ptr [edi], eax                     # 0051a824
    {load} mov eax, esi                          # 0051a826
    pop edi                                      # 0051a828
    pop esi                                      # 0051a829
    ret 0x4                                      # 0051a82a

