# FUN_0050cd50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cd50
# extent:       0x0050cd50-0x0050cd72 (34 code bytes)
# span:         0x0050cd50-0x0050cd72 (code 34, tables 0, padding 0)
# sha256:       0da22e82752744ae9cf05712c17046a865cf942af4473a565c34145d52ef5477
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         _rand
# naming:       Ghidra name from function-index.json (not re-derived here); native counterpart src/session_bindings_conditions.c:session_conditions_crt_rand (port_acceptances, ledger class host_adapter_tested, reviewed 2026-10-15); the summary is the acceptance note
# summary:      Same LCG and 15-bit result as the pseudocode; the per-thread seed cell is a struct field. No oracle calls this symbol. Test passed on macOS arm64, 2026-10-15.
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_14
# callees:      calls FUN_00510dd3
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:native_a77_random (function ledger class host_adapter_tested; also native_ae4_alloc_slot, native_ae4_random, native_aee_random, native_af6_alloc_slot, native_af6_random, native_audio_random; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)

.org 0x0050cd50 - 0x401000
.globl FUN_0050cd50
FUN_0050cd50:
    # block 0x0050cd50: entry, 9 instruction(s), calls FUN_00510dd3, ends with ret
    call FUN_00510dd3                            # 0050cd50
    mov ecx, dword ptr [eax + field_14]          # 0050cd55
    imul ecx, ecx, 0x343fd                       # 0050cd58
    add ecx, 0x269ec3                            # 0050cd5e
    mov dword ptr [eax + field_14], ecx          # 0050cd64
    {load} mov eax, ecx                          # 0050cd67
    shr eax, 0x10                                # 0050cd69
    and eax, 0x7fff                              # 0050cd6c
    ret                                          # 0050cd71

