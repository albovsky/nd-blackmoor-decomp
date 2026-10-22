# FUN_0046e5fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046e5fa
# extent:       0x0046e5fa-0x0046e66a (112 code bytes)
# span:         0x0046e5fa-0x0046e66a (code 112, tables 0, padding 0)
# sha256:       abfd6080b84eeccc06ea12f02c359841a82c1b73e6d9bb10c2e7d4791b4b37b1
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46e5fa_lifted
# naming:       native port src/original_methods_fl40.c:m46e5fa_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 30/30 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_c, local_10, local_14
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0046e6c1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m46e5fa_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_0046e6c1, .text + (0x0046e6c1 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0046e5fa - 0x401000
.globl FUN_0046e5fa
FUN_0046e5fa:
    # block 0x0046e5fa: entry, 30 instruction(s), calls FUN_0051d716, FUN_0046e6c1, ends with ret
    push ebp                                     # 0046e5fa
    {load} mov ebp, esp                          # 0046e5fb
    push -0x1                                    # 0046e5fd
    push 0x52822c                                # 0046e5ff
    mov eax, dword ptr fs:[0x0]                  # 0046e604
    push eax                                     # 0046e60a
    mov dword ptr fs:[0x0], esp                  # 0046e60b
    sub esp, 0x8                                 # 0046e612
    mov dword ptr [ebp - local_14], ecx          # 0046e615
    mov ecx, dword ptr [ebp - local_14]          # 0046e618
    call FUN_0051d716                            # 0046e61b
    mov dword ptr [ebp - local_4], 0x0           # 0046e620
    mov eax, dword ptr [ebp - local_14]          # 0046e627
    add eax, 0x8d                                # 0046e62a
    mov dword ptr [ebp - local_10], eax          # 0046e62f
    mov ecx, dword ptr [ebp - local_10]          # 0046e632
    mov edx, dword ptr [0x5679b0]                # 0046e635
    mov dword ptr [ecx], edx                     # 0046e63b
    mov byte ptr [ebp - local_4], 0x1            # 0046e63d
    mov eax, dword ptr [ebp - local_14]          # 0046e641
    mov dword ptr [eax], 0x52d370                # 0046e644
    mov ecx, dword ptr [ebp - local_14]          # 0046e64a
    call FUN_0046e6c1                            # 0046e64d
    mov dword ptr [ebp - local_4], 0xffffffff    # 0046e652
    mov eax, dword ptr [ebp - local_14]          # 0046e659
    mov ecx, dword ptr [ebp - local_c]           # 0046e65c
    mov dword ptr fs:[0x0], ecx                  # 0046e65f
    {load} mov esp, ebp                          # 0046e666
    pop ebp                                      # 0046e668
    ret                                          # 0046e669

