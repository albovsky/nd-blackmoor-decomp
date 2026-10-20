# FUN_004db04f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db04f
# extent:       0x004db04f-0x004db066 (23 code bytes)
# span:         0x004db04f-0x004db066 (code 23, tables 0, padding 0)
# sha256:       f0508e629c166574d9a4a527b2572f5d318b8dd916fab4e1aabeb3263f4015d1
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         input_latch_dblclk
# naming:       native port src/input_latch.c:input_latch_dblclk (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-15); the note is the acceptance note, a statement about the native port
# name-note:    Extracted from the DBLCLK arm of session_input_feed here: [ecx+8] = 1, arguments ignored. RT-2 oracle drives it through wrapper 0x43ecc0 and compares the latch, 0 mismatches. Native adds a view-length check.
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/input_latch.c:input_latch_dblclk (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004db04f - 0x401000
.globl FUN_004db04f
FUN_004db04f:
    # block 0x004db04f: entry, 9 instruction(s), ends with ret 0x8
    push ebp                                     # 004db04f
    {load} mov ebp, esp                          # 004db050
    push ecx                                     # 004db052
    mov dword ptr [ebp - local_4], ecx           # 004db053
    mov eax, dword ptr [ebp - local_4]           # 004db056
    mov dword ptr [eax + field_8], 0x1           # 004db059
    {load} mov esp, ebp                          # 004db060
    pop ebp                                      # 004db062
    ret 0x8                                      # 004db063

