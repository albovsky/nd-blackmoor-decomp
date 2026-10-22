# FUN_00449d37
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00449d37
# extent:       0x00449d37-0x00449d60 (41 code bytes)
# span:         0x00449d37-0x00449d60 (code 41, tables 0, padding 0)
# sha256:       21511ee99cf03cbe69dfadfa539110a52d40fd3b117700c9ec426f67dca66545
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m449d37_lifted
# naming:       native port src/original_methods_fl40.c:m449d37_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 3 seeds; oracle 16/16 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_36; [edx + n] field_28
# callees:      calls KERNEL32.dll!GetThreadPriority
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m449d37_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_28, 0x28  # offset +0x28
.equ field_36, 0x36  # offset +0x36

# --- external targets -----------------------------------------------

.org 0x00449d37 - 0x401000
.globl FUN_00449d37
FUN_00449d37:
    # block 0x00449d37: entry, 16 instruction(s), calls KERNEL32.dll!GetThreadPriority, ends with ret
    push ebp                                     # 00449d37
    {load} mov ebp, esp                          # 00449d38
    sub esp, 0xc                                 # 00449d3a
    mov dword ptr [ebp - local_c], ecx           # 00449d3d
    mov eax, dword ptr [ebp - local_c]           # 00449d40
    mov ecx, dword ptr [eax + field_36]          # 00449d43
    mov dword ptr [ebp - local_4], ecx           # 00449d46
    mov edx, dword ptr [ebp - local_4]           # 00449d49
    mov eax, dword ptr [edx + field_28]          # 00449d4c
    push eax                                     # 00449d4f
    call dword ptr [0x52a278]                    # 00449d50
    mov dword ptr [ebp - local_8], eax           # 00449d56
    mov eax, dword ptr [ebp - local_8]           # 00449d59
    {load} mov esp, ebp                          # 00449d5c
    pop ebp                                      # 00449d5e
    ret                                          # 00449d5f

