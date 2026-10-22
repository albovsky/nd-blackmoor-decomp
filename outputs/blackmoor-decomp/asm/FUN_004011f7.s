# FUN_004011f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004011f7
# extent:       0x004011f7-0x00401249 (82 code bytes)
# span:         0x004011f7-0x00401249 (code 82, tables 0, padding 0)
# sha256:       e17fe2eeafd99d86935a0ea63bd2621913466e930b81892588fdda07a0d5bc30
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4011f7_lifted
# naming:       native port src/original_methods_fl40.c:m4011f7_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 3 seeds; oracle: 24/24 instructions executed, 2/2 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d9632, FUN_004dad60, FUN_004dae88, USER32.dll!ShowCursor
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4011f7_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004d9632, .text + (0x004d9632 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)

.org 0x004011f7 - 0x401000
.globl FUN_004011f7
FUN_004011f7:
    # block 0x004011f7: entry, 14 instruction(s), calls FUN_004d9632, FUN_004dad60, FUN_004dae88, USER32.dll!ShowCursor, falls into the block at 0x00401228
    push ebp                                     # 004011f7
    {load} mov ebp, esp                          # 004011f8
    push ecx                                     # 004011fa
    mov ecx, 0x5e2e70                            # 004011fb
    call FUN_004d9632                            # 00401200
    mov ecx, 0x5830a6                            # 00401205
    call FUN_004dad60                            # 0040120a
    push 0x0                                     # 0040120f
    push 0x0                                     # 00401211
    mov ecx, 0x5830a6                            # 00401213
    call FUN_004dae88                            # 00401218
    push 0x1                                     # 0040121d
    call dword ptr [0x52a4cc]                    # 0040121f
    mov dword ptr [ebp - local_4], eax           # 00401225
L_00401228:
    # block 0x00401228: entered by jmp at 0x00401239, 2 instruction(s), ends with jge to 0x0040123b (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00401228
    jge.d8 L_0040123b                            # 0040122c
    # block 0x0040122e: entered by fall-through of jge at 0x0040122c, 4 instruction(s), calls USER32.dll!ShowCursor, ends with backward jump to 0x00401228
    push 0x1                                     # 0040122e
    call dword ptr [0x52a4cc]                    # 00401230
    mov dword ptr [ebp - local_4], eax           # 00401236
    jmp.d8 L_00401228                            # 00401239
L_0040123b:
    # block 0x0040123b: entered by jge at 0x0040122c, 4 instruction(s), ends with ret
    mov dword ptr [0x5839ad], 0x1                # 0040123b
    {load} mov esp, ebp                          # 00401245
    pop ebp                                      # 00401247
    ret                                          # 00401248

