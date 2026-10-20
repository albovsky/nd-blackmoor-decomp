# FUN_00512c79
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512c79
# extent:       0x00512c79-0x00512c8e (21 code bytes)
# span:         0x00512c79-0x00512c8e (code 21, tables 0, padding 0)
# sha256:       2c520a8b8bb935efd9f695a43ed5ae5fc0af8fb5ecf50b354e3002a3b73d993e
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_only_call_LeaveCriticalSection
# naming:       INFERRED (lower confidence, not verified): function-xrefs.json lists KERNEL32.dll!LeaveCriticalSection as the only import of the 21-byte function and no callee
# name-note:    A 21-byte leaf function with no direct callee whose only external call is KERNEL32.dll!LeaveCriticalSection
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!LeaveCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00512c79 - 0x401000
.globl FUN_00512c79
FUN_00512c79:
    # block 0x00512c79: entry, 7 instruction(s), calls KERNEL32.dll!LeaveCriticalSection, ends with ret
    push ebp                                     # 00512c79
    {load} mov ebp, esp                          # 00512c7a
    mov eax, dword ptr [ebp + arg_8]             # 00512c7c
    push dword ptr [4*eax + 0x5686b0]            # 00512c7f
    call dword ptr [0x52a0c8]                    # 00512c86
    pop ebp                                      # 00512c8c
    ret                                          # 00512c8d

