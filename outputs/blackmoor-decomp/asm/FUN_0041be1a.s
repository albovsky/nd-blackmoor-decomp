# FUN_0041be1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041be1a
# extent:       0x0041be1a-0x0041bebc (162 code bytes)
# span:         0x0041be1a-0x0041bebc (code 162, tables 0, padding 0)
# sha256:       f76a5fc9ec2ebb892997dd8fd0ed15d8e46d05807c47bc96e0c5d8e20f13de72
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41be1a_lifted
# naming:       native port src/original_methods_fl40.c:m41be1a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 43/43 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_c, local_10, local_14
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0050cb26, FUN_00423097, FUN_0041bf4d
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41be1a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 43 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_0041bf4d, .text + (0x0041bf4d - 0x401000)
.set FUN_00423097, .text + (0x00423097 - 0x401000)
.set FUN_0050cb26, .text + (0x0050cb26 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0041be1a - 0x401000
.globl FUN_0041be1a
FUN_0041be1a:
    # block 0x0041be1a: entry, 43 instruction(s), calls FUN_0051d716, FUN_0050cb26, FUN_00423097, FUN_0041bf4d, ends with ret
    push ebp                                     # 0041be1a
    {load} mov ebp, esp                          # 0041be1b
    push -0x1                                    # 0041be1d
    push 0x527343                                # 0041be1f
    mov eax, dword ptr fs:[0x0]                  # 0041be24
    push eax                                     # 0041be2a
    mov dword ptr fs:[0x0], esp                  # 0041be2b
    sub esp, 0x8                                 # 0041be32
    mov dword ptr [ebp - local_14], ecx          # 0041be35
    mov ecx, dword ptr [ebp - local_14]          # 0041be38
    call FUN_0051d716                            # 0041be3b
    mov dword ptr [ebp - local_4], 0x0           # 0041be40
    push 0x51e7ba                                # 0041be47
    push 0x422fe0                                # 0041be4c
    push 0x1e                                    # 0041be51
    push 0x4                                     # 0041be53
    mov eax, dword ptr [ebp - local_14]          # 0041be55
    add eax, 0xea5                               # 0041be58
    push eax                                     # 0041be5d
    call FUN_0050cb26                            # 0041be5e
    mov byte ptr [ebp - local_4], 0x1            # 0041be63
    mov ecx, dword ptr [ebp - local_14]          # 0041be67
    add ecx, 0xf1d                               # 0041be6a
    mov dword ptr [ebp - local_10], ecx          # 0041be70
    mov edx, dword ptr [ebp - local_10]          # 0041be73
    mov eax, dword ptr [0x5679b0]                # 0041be76
    mov dword ptr [edx], eax                     # 0041be7b
    mov byte ptr [ebp - local_4], 0x2            # 0041be7d
    mov ecx, dword ptr [ebp - local_14]          # 0041be81
    add ecx, 0xfd1                               # 0041be84
    call FUN_00423097                            # 0041be8a
    mov byte ptr [ebp - local_4], 0x3            # 0041be8f
    mov ecx, dword ptr [ebp - local_14]          # 0041be93
    mov dword ptr [ecx], 0x52c628                # 0041be96
    mov ecx, dword ptr [ebp - local_14]          # 0041be9c
    call FUN_0041bf4d                            # 0041be9f
    mov dword ptr [ebp - local_4], 0xffffffff    # 0041bea4
    mov eax, dword ptr [ebp - local_14]          # 0041beab
    mov ecx, dword ptr [ebp - local_c]           # 0041beae
    mov dword ptr fs:[0x0], ecx                  # 0041beb1
    {load} mov esp, ebp                          # 0041beb8
    pop ebp                                      # 0041beba
    ret                                          # 0041bebb

