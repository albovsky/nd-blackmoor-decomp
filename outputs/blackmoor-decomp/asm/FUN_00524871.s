# FUN_00524871
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524871
# extent:       0x00524871-0x00524880 (15 code bytes)
# span:         0x00524871-0x00524880 (code 15, tables 0, padding 0)
# sha256:       d0b150ab845ae4cd9ddf4b31a550f4947ec1eb3182644f8e718a388109583b78
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524871
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_30; [esp + n] stk_4
# callees:      calls FUN_00525371
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00524871 - 0x401000
.globl FUN_00524871
FUN_00524871:
    # block 0x00524871: entry, 4 instruction(s), calls FUN_00525371, ends with ret 0x4
    call FUN_00525371                            # 00524871
    mov ecx, dword ptr [esp + stk_4]             # 00524876
    mov dword ptr [eax + field_30], ecx          # 0052487a
    ret 0x4                                      # 0052487d

