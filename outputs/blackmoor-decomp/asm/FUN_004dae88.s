# FUN_004dae88
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dae88
# extent:       0x004dae88-0x004daeb5 (45 code bytes)
# span:         0x004dae88-0x004daeb5 (code 45, tables 0, padding 0)
# sha256:       a1a81a3bca7cc831639a049e870e925f36dda56f04a50e3cb7e1a6334c573b86
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_only_call_SetCursorPos
# naming:       INFERRED (lower confidence, not verified): function-xrefs.json lists USER32.dll!SetCursorPos as the only import of the 45-byte function and no callee
# name-note:    A 45-byte leaf function with no direct callee whose only external call is USER32.dll!SetCursorPos
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_18; [edx + n] field_1c
# callees:      calls USER32.dll!SetCursorPos
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x004dae88 - 0x401000
.globl FUN_004dae88
FUN_004dae88:
    # block 0x004dae88: entry, 18 instruction(s), calls USER32.dll!SetCursorPos, ends with ret 0x8
    push ebp                                     # 004dae88
    {load} mov ebp, esp                          # 004dae89
    push ecx                                     # 004dae8b
    mov dword ptr [ebp - local_4], ecx           # 004dae8c
    mov eax, dword ptr [ebp - local_4]           # 004dae8f
    mov ecx, dword ptr [ebp + arg_8]             # 004dae92
    mov dword ptr [eax + field_18], ecx          # 004dae95
    mov edx, dword ptr [ebp - local_4]           # 004dae98
    mov eax, dword ptr [ebp + arg_c]             # 004dae9b
    mov dword ptr [edx + field_1c], eax          # 004dae9e
    mov ecx, dword ptr [ebp + arg_c]             # 004daea1
    push ecx                                     # 004daea4
    mov edx, dword ptr [ebp + arg_8]             # 004daea5
    push edx                                     # 004daea8
    call dword ptr [0x52a488]                    # 004daea9
    {load} mov esp, ebp                          # 004daeaf
    pop ebp                                      # 004daeb1
    ret 0x8                                      # 004daeb2

