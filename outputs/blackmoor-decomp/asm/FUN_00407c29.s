# FUN_00407c29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407c29
# extent:       0x00407c29-0x00407c8a (97 code bytes)
# span:         0x00407c29-0x00407c8a (code 97, tables 0, padding 0)
# sha256:       f2461914c1fcb87bd04c663e98caaad13cfd00e3eedc42f6c5bedc7eaf720864
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407c29_lifted
# naming:       native port src/original_methods_fl40.c:m407c29_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 27/27 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cba8, FUN_005218ea
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m407c29_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)
.set FUN_005218ea, .text + (0x005218ea - 0x401000)

.org 0x00407c29 - 0x401000
.globl FUN_00407c29
FUN_00407c29:
    # block 0x00407c29: entry, 27 instruction(s), calls FUN_0050cba8, FUN_005218ea, ends with ret
    push ebp                                     # 00407c29
    {load} mov ebp, esp                          # 00407c2a
    push -0x1                                    # 00407c2c
    push 0x526d70                                # 00407c2e
    mov eax, dword ptr fs:[0x0]                  # 00407c33
    push eax                                     # 00407c39
    mov dword ptr fs:[0x0], esp                  # 00407c3a
    push ecx                                     # 00407c41
    mov dword ptr [ebp - local_10], ecx          # 00407c42
    mov eax, dword ptr [ebp - local_10]          # 00407c45
    mov dword ptr [eax], 0x52bed8                # 00407c48
    mov dword ptr [ebp - local_4], 0x0           # 00407c4e
    push 0x401032                                # 00407c55
    push 0x24                                    # 00407c5a
    push 0x40                                    # 00407c5c
    mov ecx, dword ptr [ebp - local_10]          # 00407c5e
    add ecx, 0x8c                                # 00407c61
    push ecx                                     # 00407c67
    call FUN_0050cba8                            # 00407c68
    mov dword ptr [ebp - local_4], 0xffffffff    # 00407c6d
    mov ecx, dword ptr [ebp - local_10]          # 00407c74
    call FUN_005218ea                            # 00407c77
    mov ecx, dword ptr [ebp - local_c]           # 00407c7c
    mov dword ptr fs:[0x0], ecx                  # 00407c7f
    {load} mov esp, ebp                          # 00407c86
    pop ebp                                      # 00407c88
    ret                                          # 00407c89

