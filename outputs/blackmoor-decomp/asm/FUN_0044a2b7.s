# FUN_0044a2b7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044a2b7
# extent:       0x0044a2b7-0x0044a32c (117 code bytes)
# span:         0x0044a2b7-0x0044a32c (code 117, tables 0, padding 0)
# sha256:       7b48071ed7922831f5195ca6fc01a23b60e0586992094df450379fa7b1a70aa4
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44a2b7_lifted
# naming:       native port src/original_methods_fl40.c:m44a2b7_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 37/37 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_2, local_4, local_6, local_8, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GetSystemTime, FUN_0050ddb9, FUN_0050dc53
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44a2b7_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 37 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_2, 0x2  # offset -0x2
.equ local_4, 0x4  # offset -0x4
.equ local_6, 0x6  # offset -0x6
.equ local_8, 0x8  # offset -0x8
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050dc53, .text + (0x0050dc53 - 0x401000)
.set FUN_0050ddb9, .text + (0x0050ddb9 - 0x401000)

.org 0x0044a2b7 - 0x401000
.globl FUN_0044a2b7
FUN_0044a2b7:
    # block 0x0044a2b7: entry, 37 instruction(s), calls KERNEL32.dll!GetSystemTime, FUN_0050ddb9, FUN_0050dc53, ends with ret
    push ebp                                     # 0044a2b7
    {load} mov ebp, esp                          # 0044a2b8
    sub esp, 0x10                                # 0044a2ba
    lea eax, [ebp - local_10]                    # 0044a2bd
    push eax                                     # 0044a2c0
    call dword ptr [0x52a270]                    # 0044a2c1
    mov ecx, dword ptr [ebp + arg_8]             # 0044a2c7
    push ecx                                     # 0044a2ca
    mov edx, dword ptr [ebp - local_2]           # 0044a2cb
    and edx, 0xffff                              # 0044a2ce
    push edx                                     # 0044a2d4
    mov eax, dword ptr [ebp - local_4]           # 0044a2d5
    and eax, 0xffff                              # 0044a2d8
    push eax                                     # 0044a2dd
    mov ecx, dword ptr [ebp - local_6]           # 0044a2de
    and ecx, 0xffff                              # 0044a2e1
    push ecx                                     # 0044a2e7
    mov edx, dword ptr [ebp - local_8]           # 0044a2e8
    and edx, 0xffff                              # 0044a2eb
    push edx                                     # 0044a2f1
    mov eax, dword ptr [0x63a84c]                # 0044a2f2
    push eax                                     # 0044a2f7
    push 0x548abc                                # 0044a2f8
    mov ecx, dword ptr [0x5a4c10]                # 0044a2fd
    push ecx                                     # 0044a303
    call FUN_0050ddb9                            # 0044a304
    add esp, 0x20                                # 0044a309
    mov edx, dword ptr [0x5a4c10]                # 0044a30c
    push edx                                     # 0044a312
    call FUN_0050dc53                            # 0044a313
    add esp, 0x4                                 # 0044a318
    mov eax, dword ptr [0x63a84c]                # 0044a31b
    add eax, 0x1                                 # 0044a320
    mov dword ptr [0x63a84c], eax                # 0044a323
    {load} mov esp, ebp                          # 0044a328
    pop ebp                                      # 0044a32a
    ret                                          # 0044a32b

