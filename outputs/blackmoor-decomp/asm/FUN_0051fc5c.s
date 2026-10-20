# FUN_0051fc5c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fc5c
# extent:       0x0051fc5c-0x0051fc6a (14 code bytes)
# span:         0x0051fc5c-0x0051fc6a (code 14, tables 0, padding 0)
# sha256:       f7cf1abd0478f84e78e1970987ce84ce543f423c6a373ccf0d2efbb5e77e45d8
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_only_call_GlobalFree
# naming:       INFERRED (lower confidence, not verified): function-xrefs.json lists KERNEL32.dll!GlobalFree as the only import of the 14-byte function and no callee
# name-note:    A 14-byte leaf function with no direct callee whose only external call is KERNEL32.dll!GlobalFree
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GlobalFree
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0051fc5c - 0x401000
.globl FUN_0051fc5c
FUN_0051fc5c:
    # block 0x0051fc5c: entry, 3 instruction(s), ends with je to 0x0051fc69 (forward)
    mov eax, dword ptr [ecx]                     # 0051fc5c
    test eax, eax                                # 0051fc5e
    je.d8 L_0051fc69                             # 0051fc60
    # block 0x0051fc62: entered by fall-through of je at 0x0051fc60, 2 instruction(s), calls KERNEL32.dll!GlobalFree, falls into the block at 0x0051fc69
    push eax                                     # 0051fc62
    call dword ptr [0x52a20c]                    # 0051fc63
L_0051fc69:
    # block 0x0051fc69: entered by je at 0x0051fc60, 1 instruction(s), ends with ret
    ret                                          # 0051fc69

