# FUN_00426367
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426367
# extent:       0x00426367-0x0042639d (54 code bytes)
# span:         0x00426367-0x0042639d (code 54, tables 0, padding 0)
# sha256:       45168c4203b3cce5dfaa71de604ad72df2541acb8fcd612ccf133b5f262c8dd6
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m426367_lifted
# naming:       native port src/original_methods_fl40.c:m426367_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 2 seeds; oracle 20/20 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GetLastError, KERNEL32.dll!FormatMessageA
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m426367_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00426367 - 0x401000
.globl FUN_00426367
FUN_00426367:
    # block 0x00426367: entry, 20 instruction(s), calls KERNEL32.dll!GetLastError, KERNEL32.dll!FormatMessageA, ends with ret
    push ebp                                     # 00426367
    {load} mov ebp, esp                          # 00426368
    push ecx                                     # 0042636a
    mov dword ptr [ebp - local_4], ecx           # 0042636b
    push 0x0                                     # 0042636e
    push 0x3ff                                   # 00426370
    mov eax, dword ptr [ebp - local_4]           # 00426375
    mov ecx, dword ptr [eax]                     # 00426378
    push ecx                                     # 0042637a
    push 0x400                                   # 0042637b
    call dword ptr [0x52a2a4]                    # 00426380
    push eax                                     # 00426386
    push 0x0                                     # 00426387
    push 0x1200                                  # 00426389
    call dword ptr [0x52a2a8]                    # 0042638e
    mov edx, dword ptr [ebp - local_4]           # 00426394
    mov eax, dword ptr [edx]                     # 00426397
    {load} mov esp, ebp                          # 00426399
    pop ebp                                      # 0042639b
    ret                                          # 0042639c

