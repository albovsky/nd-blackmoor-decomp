# FUN_00401526
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401526
# extent:       0x00401526-0x00401589 (99 code bytes)
# span:         0x00401526-0x00401589 (code 99, tables 0, padding 0)
# sha256:       77dd4415f6b0a5d221f173af5f21c9038ca50844964faffd79d271596a920011
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401526_lifted
# naming:       native port src/original_methods_fl40.c:m401526_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 23/23 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_c, local_ec, local_f0
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401cb0, FUN_0051e140, FUN_0051de13
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m401526_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_ec, 0xec  # offset -0xec
.equ local_f0, 0xf0  # offset -0xf0

# --- external targets -----------------------------------------------
.set FUN_00401cb0, .text + (0x00401cb0 - 0x401000)
.set FUN_0051de13, .text + (0x0051de13 - 0x401000)
.set FUN_0051e140, .text + (0x0051e140 - 0x401000)

.org 0x00401526 - 0x401000
.globl FUN_00401526
FUN_00401526:
    # block 0x00401526: entry, 23 instruction(s), calls FUN_00401cb0, FUN_0051e140, FUN_0051de13, ends with ret
    push ebp                                     # 00401526
    {load} mov ebp, esp                          # 00401527
    push -0x1                                    # 00401529
    push 0x526af3                                # 0040152b
    mov eax, dword ptr fs:[0x0]                  # 00401530
    push eax                                     # 00401536
    mov dword ptr fs:[0x0], esp                  # 00401537
    sub esp, 0xe4                                # 0040153e
    mov dword ptr [ebp - local_f0], ecx          # 00401544
    push 0x0                                     # 0040154a
    lea ecx, [ebp - local_ec]                    # 0040154c
    call FUN_00401cb0                            # 00401552
    mov dword ptr [ebp - local_4], 0x0           # 00401557
    lea ecx, [ebp - local_ec]                    # 0040155e
    call FUN_0051e140                            # 00401564
    mov dword ptr [ebp - local_4], 0xffffffff    # 00401569
    lea ecx, [ebp - local_ec]                    # 00401570
    call FUN_0051de13                            # 00401576
    mov ecx, dword ptr [ebp - local_c]           # 0040157b
    mov dword ptr fs:[0x0], ecx                  # 0040157e
    {load} mov esp, ebp                          # 00401585
    pop ebp                                      # 00401587
    ret                                          # 00401588

