# FUN_0041bebc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041bebc
# extent:       0x0041bebc-0x0041bf4d (145 code bytes)
# span:         0x0041bebc-0x0041bf4d (code 145, tables 0, padding 0)
# sha256:       6f256162b16537f140d4aede8805f4da650c91699385eb0ccb914956a95f5cda
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41bebc_lifted
# naming:       native port src/original_methods_fl40.c:m41bebc_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 38/38 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0041c29a, FUN_004230d1, FUN_0051e7ba, FUN_0050cba8, FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41bebc_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 38 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0041c29a, .text + (0x0041c29a - 0x401000)
.set FUN_004230d1, .text + (0x004230d1 - 0x401000)
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x0041bebc - 0x401000
.globl FUN_0041bebc
FUN_0041bebc:
    # block 0x0041bebc: entry, 38 instruction(s), calls FUN_0041c29a, FUN_004230d1, FUN_0051e7ba, FUN_0050cba8, FUN_0051d730, ends with ret
    push ebp                                     # 0041bebc
    {load} mov ebp, esp                          # 0041bebd
    push -0x1                                    # 0041bebf
    push 0x52738c                                # 0041bec1
    mov eax, dword ptr fs:[0x0]                  # 0041bec6
    push eax                                     # 0041becc
    mov dword ptr fs:[0x0], esp                  # 0041becd
    push ecx                                     # 0041bed4
    mov dword ptr [ebp - local_10], ecx          # 0041bed5
    mov eax, dword ptr [ebp - local_10]          # 0041bed8
    mov dword ptr [eax], 0x52c628                # 0041bedb
    mov dword ptr [ebp - local_4], 0x3           # 0041bee1
    mov ecx, dword ptr [ebp - local_10]          # 0041bee8
    call FUN_0041c29a                            # 0041beeb
    mov byte ptr [ebp - local_4], 0x2            # 0041bef0
    mov ecx, dword ptr [ebp - local_10]          # 0041bef4
    add ecx, 0xfd1                               # 0041bef7
    call FUN_004230d1                            # 0041befd
    mov byte ptr [ebp - local_4], 0x1            # 0041bf02
    mov ecx, dword ptr [ebp - local_10]          # 0041bf06
    add ecx, 0xf1d                               # 0041bf09
    call FUN_0051e7ba                            # 0041bf0f
    mov byte ptr [ebp - local_4], 0x0            # 0041bf14
    push 0x51e7ba                                # 0041bf18
    push 0x1e                                    # 0041bf1d
    push 0x4                                     # 0041bf1f
    mov ecx, dword ptr [ebp - local_10]          # 0041bf21
    add ecx, 0xea5                               # 0041bf24
    push ecx                                     # 0041bf2a
    call FUN_0050cba8                            # 0041bf2b
    mov dword ptr [ebp - local_4], 0xffffffff    # 0041bf30
    mov ecx, dword ptr [ebp - local_10]          # 0041bf37
    call FUN_0051d730                            # 0041bf3a
    mov ecx, dword ptr [ebp - local_c]           # 0041bf3f
    mov dword ptr fs:[0x0], ecx                  # 0041bf42
    {load} mov esp, ebp                          # 0041bf49
    pop ebp                                      # 0041bf4b
    ret                                          # 0041bf4c

