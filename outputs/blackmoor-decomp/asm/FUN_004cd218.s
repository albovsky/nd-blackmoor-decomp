# FUN_004cd218
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cd218
# extent:       0x004cd218-0x004cd243 (43 code bytes)
# span:         0x004cd218-0x004cd243 (code 43, tables 0, padding 0)
# sha256:       2a454b2c769dca755e240756b10fc0bfc3bc78ffaf0baa8983e3492d1ce1cd28
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cd218_destruct
# naming:       native port src/original_methods_fl17.c:m4cd218_destruct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4cd218_destruct; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 43 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ccef1, FUN_004ccfbd, FUN_004ccff5, FUN_004ccdab
# track-n:      outputs/blackmoor-decomp/src/action_family_2d_runtime.h:d2_destruct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004ccdab, .text + (0x004ccdab - 0x401000)
.set FUN_004ccef1, .text + (0x004ccef1 - 0x401000)
.set FUN_004ccfbd, .text + (0x004ccfbd - 0x401000)
.set FUN_004ccff5, .text + (0x004ccff5 - 0x401000)

.org 0x004cd218 - 0x401000
.globl FUN_004cd218
FUN_004cd218:
    # block 0x004cd218: entry, 15 instruction(s), calls FUN_004ccef1, FUN_004ccfbd, FUN_004ccff5, FUN_004ccdab, ends with ret
    push ebp                                     # 004cd218
    {load} mov ebp, esp                          # 004cd219
    push ecx                                     # 004cd21b
    mov dword ptr [ebp - local_4], ecx           # 004cd21c
    mov ecx, dword ptr [ebp - local_4]           # 004cd21f
    call FUN_004ccef1                            # 004cd222
    mov ecx, dword ptr [ebp - local_4]           # 004cd227
    call FUN_004ccfbd                            # 004cd22a
    mov ecx, dword ptr [ebp - local_4]           # 004cd22f
    call FUN_004ccff5                            # 004cd232
    mov ecx, dword ptr [ebp - local_4]           # 004cd237
    call FUN_004ccdab                            # 004cd23a
    {load} mov esp, ebp                          # 004cd23f
    pop ebp                                      # 004cd241
    ret                                          # 004cd242

