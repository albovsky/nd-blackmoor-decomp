# FUN_0052116f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052116f
# extent:       0x0052116f-0x00521188 (25 code bytes)
# span:         0x0052116f-0x00521188 (code 25, tables 0, padding 0)
# sha256:       596e9231c431cafa2be99b5cf988b7f6fc583fc828224a8a631ccc414f76604d
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_only_call_DeleteObject
# naming:       INFERRED (lower confidence, not verified): function-xrefs.json lists GDI32.dll!DeleteObject as the only import of the 25-byte function and no callee
# name-note:    A 25-byte leaf function with no direct callee whose only external call is GDI32.dll!DeleteObject
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls GDI32.dll!DeleteObject
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0052116f - 0x401000
.globl FUN_0052116f
FUN_0052116f:
    # block 0x0052116f: entry, 5 instruction(s), ends with je to 0x00521184 (forward)
    push esi                                     # 0052116f
    mov esi, dword ptr [esp + stk_8]             # 00521170
    mov eax, dword ptr [esi]                     # 00521174
    test eax, eax                                # 00521176
    je.d8 L_00521184                             # 00521178
    # block 0x0052117a: entered by fall-through of je at 0x00521178, 3 instruction(s), calls GDI32.dll!DeleteObject, falls into the block at 0x00521184
    push eax                                     # 0052117a
    call dword ptr [0x52a090]                    # 0052117b
    and dword ptr [esi], 0x0                     # 00521181
L_00521184:
    # block 0x00521184: entered by je at 0x00521178, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 00521184
    ret 0x4                                      # 00521185

