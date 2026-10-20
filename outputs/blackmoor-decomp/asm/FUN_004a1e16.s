# FUN_004a1e16
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1e16
# extent:       0x004a1e16-0x004a1e93 (125 code bytes)
# span:         0x004a1e16-0x004a1e93 (code 125, tables 0, padding 0)
# sha256:       2fa975c2e896c9e5b076f5f773057c76d3eeaa62cabe8f71740d10288f363450
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a1e16_hit_test
# naming:       native port src/original_methods_fl23a.c:m4a1e16_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4a1e16_hit_test (callees via host). Direct: objects, ordered calls, edges. Unicorn differential: 300 fixtures, every instruction reached. Window covers all 125 bytes. See tasks/fl23a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_60, field_13d, field_141, field_145, field_149; [ecx + n] field_50; [edx + n] field_20
# callees:      calls FUN_004a1e93
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23a.c:m4a1e16_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 39 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_20, 0x20  # offset +0x20
.equ field_50, 0x50  # offset +0x50
.equ field_60, 0x60  # offset +0x60
.equ field_13d, 0x13d  # offset +0x13d
.equ field_141, 0x141  # offset +0x141
.equ field_145, 0x145  # offset +0x145
.equ field_149, 0x149  # offset +0x149

# --- external targets -----------------------------------------------
.set FUN_004a1e93, .text + (0x004a1e93 - 0x401000)

.org 0x004a1e16 - 0x401000
.globl FUN_004a1e16
FUN_004a1e16:
    # block 0x004a1e16: entry, 7 instruction(s), ends with je to 0x004a1e8b (forward)
    push ebp                                     # 004a1e16
    {load} mov ebp, esp                          # 004a1e17
    push ecx                                     # 004a1e19
    mov dword ptr [ebp - local_4], ecx           # 004a1e1a
    mov eax, dword ptr [ebp - local_4]           # 004a1e1d
    cmp dword ptr [eax + field_60], 0x0          # 004a1e20
    je.d8 L_004a1e8b                             # 004a1e24
    # block 0x004a1e26: entered by fall-through of je at 0x004a1e24, 5 instruction(s), ends with jl to 0x004a1e8b (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a1e26
    mov edx, dword ptr [ebp - local_4]           # 004a1e2a
    mov eax, dword ptr [edx + field_20]          # 004a1e2d
    cmp ecx, dword ptr [eax + field_141]         # 004a1e30
    jl.d8 L_004a1e8b                             # 004a1e36
    # block 0x004a1e38: entered by fall-through of jl at 0x004a1e36, 5 instruction(s), ends with jg to 0x004a1e8b (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a1e38
    mov edx, dword ptr [ebp - local_4]           # 004a1e3c
    mov eax, dword ptr [edx + field_20]          # 004a1e3f
    cmp ecx, dword ptr [eax + field_149]         # 004a1e42
    jg.d8 L_004a1e8b                             # 004a1e48
    # block 0x004a1e4a: entered by fall-through of jg at 0x004a1e48, 5 instruction(s), ends with jl to 0x004a1e8b (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a1e4a
    mov edx, dword ptr [ebp - local_4]           # 004a1e4e
    mov eax, dword ptr [edx + field_20]          # 004a1e51
    cmp ecx, dword ptr [eax + field_13d]         # 004a1e54
    jl.d8 L_004a1e8b                             # 004a1e5a
    # block 0x004a1e5c: entered by fall-through of jl at 0x004a1e5a, 5 instruction(s), ends with jg to 0x004a1e8b (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a1e5c
    mov edx, dword ptr [ebp - local_4]           # 004a1e60
    mov eax, dword ptr [edx + field_20]          # 004a1e63
    cmp ecx, dword ptr [eax + field_145]         # 004a1e66
    jg.d8 L_004a1e8b                             # 004a1e6c
    # block 0x004a1e6e: entered by fall-through of jg at 0x004a1e6c, 3 instruction(s), ends with jne to 0x004a1e8b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a1e6e
    cmp dword ptr [ecx + field_50], 0x2          # 004a1e71
    jne.d8 L_004a1e8b                            # 004a1e75
    # block 0x004a1e77: entered by fall-through of jne at 0x004a1e75, 5 instruction(s), calls FUN_004a1e93, ends with forward jump to 0x004a1e8d
    push 0x2760                                  # 004a1e77
    mov ecx, dword ptr [ebp - local_4]           # 004a1e7c
    call FUN_004a1e93                            # 004a1e7f
    mov eax, 0x1                                 # 004a1e84
    jmp.d8 L_004a1e8d                            # 004a1e89
L_004a1e8b:
    # block 0x004a1e8b: entered by je at 0x004a1e24; jl at 0x004a1e36; jg at 0x004a1e48; jl at 0x004a1e5a; more, 1 instruction(s), falls into the block at 0x004a1e8d
    {load} xor eax, eax                          # 004a1e8b
L_004a1e8d:
    # block 0x004a1e8d: entered by jmp at 0x004a1e89, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004a1e8d
    pop ebp                                      # 004a1e8f
    ret 0x8                                      # 004a1e90

