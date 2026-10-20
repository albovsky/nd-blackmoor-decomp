# FUN_0051777a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051777a
# extent:       0x0051777a-0x0051779c (34 code bytes)
# span:         0x0051777a-0x0051779c (code 34, tables 0, padding 0)
# sha256:       897c60da498f1d602408e3fb82903ddf7409aac06d7e80709386374655f6f7c8
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_only_call_LeaveCriticalSection
# naming:       INFERRED (lower confidence, not verified): function-xrefs.json lists KERNEL32.dll!LeaveCriticalSection as the only import of the 34-byte function and no callee
# name-note:    A 34-byte leaf function with no direct callee whose only external call is KERNEL32.dll!LeaveCriticalSection
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_c; [esp + n] stk_4
# callees:      calls KERNEL32.dll!LeaveCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0051777a - 0x401000
.globl FUN_0051777a
FUN_0051777a:
    # block 0x0051777a: entry, 10 instruction(s), calls KERNEL32.dll!LeaveCriticalSection, ends with ret
    mov eax, dword ptr [esp + stk_4]             # 0051777a
    {load} mov ecx, eax                          # 0051777e
    and eax, 0x1f                                # 00517780
    sar ecx, 0x5                                 # 00517783
    lea eax, [eax + 8*eax]                       # 00517786
    mov ecx, dword ptr [4*ecx + 0x63cde0]        # 00517789
    lea eax, [ecx + 4*eax + field_c]             # 00517790
    push eax                                     # 00517794
    call dword ptr [0x52a0c8]                    # 00517795
    ret                                          # 0051779b

