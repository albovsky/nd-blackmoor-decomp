# FUN_00523edb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523edb
# extent:       0x00523edb-0x00523ef2 (23 code bytes)
# span:         0x00523edb-0x00523ef2 (code 23, tables 0, padding 0)
# sha256:       d2268c5ad88e45efac2d4fdfa132fad5cc92d74bd286e3ca6872320f8b5ac490
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_only_call_SendMessageA
# naming:       INFERRED (lower confidence, not verified): function-xrefs.json lists USER32.dll!SendMessageA as the only import of the 23-byte function and no callee
# name-note:    A 23-byte leaf function with no direct callee whose only external call is USER32.dll!SendMessageA
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c; [esp + n] stk_8
# callees:      calls USER32.dll!SendMessageA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x00523edb - 0x401000
.globl FUN_00523edb
FUN_00523edb:
    # block 0x00523edb: entry, 6 instruction(s), calls USER32.dll!SendMessageA, ends with ret 0x4
    push 0x0                                     # 00523edb
    push dword ptr [esp + stk_8]                 # 00523edd
    push 0x362                                   # 00523ee1
    push dword ptr [ecx + field_1c]              # 00523ee6
    call dword ptr [0x52a4c8]                    # 00523ee9
    ret 0x4                                      # 00523eef

