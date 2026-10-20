# FUN_0050c5ee
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c5ee
# extent:       0x0050c5ee-0x0050c604 (22 code bytes)
# span:         0x0050c5ee-0x0050c604 (code 22, tables 0, padding 0)
# sha256:       a4c47c206b90e6c65d9f0851124cfd539e47aa61914b6ba9b9a79df6dcc8ae2b
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# ending:       call-end (the code part ends in a call with no instruction after it; the call may or may not return, so it is counted only bound together with the range at 0x0050c604 that follows it, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Catch@0050c5ee
# naming:       Ghidra name from function-index.json (not re-derived here); note is the ledger reason (compiler_eh_funclet, function-ledger-overrides.json not_needed_entries)
# name-note:    Catch@ handler of a library parent: Leaves critical section, rethrows (CxxThrow 0,0): library lock release then rethrow; tail is spilled code of another fn. Parent (free-list alloc) lets it propagate
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls KERNEL32.dll!LeaveCriticalSection, FUN_0050f997
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; the code part ends in a call with no instruction after it, whether the callee returns is not proven here, and the entry is counted only bound together with the range at 0x0050c604 that follows it (owner ruling of 2026-10-16); function ledger class nn_reviewed is a native-touch record, not a counterpart claim
# note:         call_without_fallthrough:0x0050c5ff
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_0050f997, .text + (0x0050f997 - 0x401000)

.org 0x0050c5ee - 0x401000
.globl FUN_0050c5ee
FUN_0050c5ee:
    # block 0x0050c5ee: entry, 7 instruction(s), calls KERNEL32.dll!LeaveCriticalSection, FUN_0050f997, ends with call 0x50f997 and no instruction after it in this entry; if the call returns, execution continues in the entry at 0x0050c604, which is bound together with this one
    mov eax, dword ptr [ebp - field_minus_14]    # 0050c5ee
    add eax, 0x10                                # 0050c5f1
    push eax                                     # 0050c5f4
    call dword ptr [0x52a0c8]                    # 0050c5f5
    push 0x0                                     # 0050c5fb
    push 0x0                                     # 0050c5fd
    call FUN_0050f997                            # 0050c5ff

