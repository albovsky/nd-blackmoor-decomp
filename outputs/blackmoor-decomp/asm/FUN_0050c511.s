# FUN_0050c511
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c511
# extent:       0x0050c511-0x0050c539 (40 code bytes)
# span:         0x0050c511-0x0050c539 (code 40, tables 0, padding 0)
# sha256:       8c70c68b613780077d0b8de5d46e99c11c89ff1ab70999379145b0d9101b47f7
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_only_call_InitializeCriticalSection
# naming:       INFERRED (lower confidence, not verified): function-xrefs.json lists KERNEL32.dll!InitializeCriticalSection as the only import of the 40-byte function and no callee
# name-note:    A 40-byte leaf function with no direct callee whose only external call is KERNEL32.dll!InitializeCriticalSection
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8, field_c, field_10; [esp + n] stk_4, stk_c
# callees:      calls KERNEL32.dll!InitializeCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0050c511 - 0x401000
.globl FUN_0050c511
FUN_0050c511:
    # block 0x0050c511: entry, 14 instruction(s), calls KERNEL32.dll!InitializeCriticalSection, ends with ret 0x8
    mov eax, dword ptr [esp + stk_4]             # 0050c511
    push esi                                     # 0050c515
    {load} mov esi, ecx                          # 0050c516
    and dword ptr [esi + field_c], 0x0           # 0050c518
    and dword ptr [esi + field_8], 0x0           # 0050c51c
    mov dword ptr [esi], eax                     # 0050c520
    mov eax, dword ptr [esp + stk_c]             # 0050c522
    mov dword ptr [esi + field_4], eax           # 0050c526
    lea eax, [esi + field_10]                    # 0050c529
    push eax                                     # 0050c52c
    call dword ptr [0x52a0b4]                    # 0050c52d
    {load} mov eax, esi                          # 0050c533
    pop esi                                      # 0050c535
    ret 0x8                                      # 0050c536

