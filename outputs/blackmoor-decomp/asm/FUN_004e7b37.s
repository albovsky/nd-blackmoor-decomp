# FUN_004e7b37
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7b37
# extent:       0x004e7b37-0x004e7ba7 (112 code bytes)
# span:         0x004e7b37-0x004e7ba7 (code 112, tables 0, padding 0)
# sha256:       b1d257420fecff6c839a3632750a5ca9e9f773525d82719fa9d1686965d8d2fb
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e7b37_destroy_vector
# naming:       native port src/original_methods_fl39c.c:m4e7b37_destroy_vector (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the dword 0x52e4f4u at [this], calls 0x4e7bf3(this), the vector iterator 0x50cba8(this+0x7654, 0x18f, 6, 0x4e1c83) and returns 0x4eda7c(this); the SEH frame is not modelled. No jumps; all 30 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e7bf3, FUN_0050cba8, FUN_004eda7c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39c.c:m4e7b37_destroy_vector (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e7bf3, .text + (0x004e7bf3 - 0x401000)
.set FUN_004eda7c, .text + (0x004eda7c - 0x401000)
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x004e7b37 - 0x401000
.globl FUN_004e7b37
FUN_004e7b37:
    # block 0x004e7b37: entry, 30 instruction(s), calls FUN_004e7bf3, FUN_0050cba8, FUN_004eda7c, ends with ret
    push ebp                                     # 004e7b37
    {load} mov ebp, esp                          # 004e7b38
    push -0x1                                    # 004e7b3a
    push 0x528a82                                # 004e7b3c
    mov eax, dword ptr fs:[0x0]                  # 004e7b41
    push eax                                     # 004e7b47
    mov dword ptr fs:[0x0], esp                  # 004e7b48
    push ecx                                     # 004e7b4f
    mov dword ptr [ebp - local_10], ecx          # 004e7b50
    mov eax, dword ptr [ebp - local_10]          # 004e7b53
    mov dword ptr [eax], 0x52e4f4                # 004e7b56
    mov dword ptr [ebp - local_4], 0x1           # 004e7b5c
    mov ecx, dword ptr [ebp - local_10]          # 004e7b63
    call FUN_004e7bf3                            # 004e7b66
    mov byte ptr [ebp - local_4], 0x0            # 004e7b6b
    push 0x4e1c83                                # 004e7b6f
    push 0x6                                     # 004e7b74
    push 0x18f                                   # 004e7b76
    mov ecx, dword ptr [ebp - local_10]          # 004e7b7b
    add ecx, 0x7654                              # 004e7b7e
    push ecx                                     # 004e7b84
    call FUN_0050cba8                            # 004e7b85
    mov dword ptr [ebp - local_4], 0xffffffff    # 004e7b8a
    mov ecx, dword ptr [ebp - local_10]          # 004e7b91
    call FUN_004eda7c                            # 004e7b94
    mov ecx, dword ptr [ebp - local_c]           # 004e7b99
    mov dword ptr fs:[0x0], ecx                  # 004e7b9c
    {load} mov esp, ebp                          # 004e7ba3
    pop ebp                                      # 004e7ba5
    ret                                          # 004e7ba6

