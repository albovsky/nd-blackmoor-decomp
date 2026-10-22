# FUN_004e7684
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7684
# extent:       0x004e7684-0x004e76d5 (81 code bytes)
# span:         0x004e7684-0x004e76d5 (code 81, tables 0, padding 0)
# sha256:       e853c2c0d296a74be72924660d49346d9cab8dec031a5fd3d6e72aca0fce49ae
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e7684_destroy_with_frame
# naming:       native port src/original_methods_fl39a.c:m4e7684_destroy_with_frame (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the dword 0x52e4f0u at [this], calls 0x4e76ed(this) then 0x4eda7c(this) and returns the eax of the second; the SEH frame is not modelled. No jumps; all 22 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e76ed, FUN_004eda7c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m4e7684_destroy_with_frame (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e76ed, .text + (0x004e76ed - 0x401000)
.set FUN_004eda7c, .text + (0x004eda7c - 0x401000)

.org 0x004e7684 - 0x401000
.globl FUN_004e7684
FUN_004e7684:
    # block 0x004e7684: entry, 22 instruction(s), calls FUN_004e76ed, FUN_004eda7c, ends with ret
    push ebp                                     # 004e7684
    {load} mov ebp, esp                          # 004e7685
    push -0x1                                    # 004e7687
    push 0x528a1c                                # 004e7689
    mov eax, dword ptr fs:[0x0]                  # 004e768e
    push eax                                     # 004e7694
    mov dword ptr fs:[0x0], esp                  # 004e7695
    push ecx                                     # 004e769c
    mov dword ptr [ebp - local_10], ecx          # 004e769d
    mov eax, dword ptr [ebp - local_10]          # 004e76a0
    mov dword ptr [eax], 0x52e4f0                # 004e76a3
    mov dword ptr [ebp - local_4], 0x0           # 004e76a9
    mov ecx, dword ptr [ebp - local_10]          # 004e76b0
    call FUN_004e76ed                            # 004e76b3
    mov dword ptr [ebp - local_4], 0xffffffff    # 004e76b8
    mov ecx, dword ptr [ebp - local_10]          # 004e76bf
    call FUN_004eda7c                            # 004e76c2
    mov ecx, dword ptr [ebp - local_c]           # 004e76c7
    mov dword ptr fs:[0x0], ecx                  # 004e76ca
    {load} mov esp, ebp                          # 004e76d1
    pop ebp                                      # 004e76d3
    ret                                          # 004e76d4

