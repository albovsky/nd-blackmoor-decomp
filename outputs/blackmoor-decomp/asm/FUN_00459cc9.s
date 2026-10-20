# FUN_00459cc9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00459cc9
# extent:       0x00459cc9-0x00459ddc (275 code bytes)
# span:         0x00459cc9-0x00459ddc (code 275, tables 0, padding 0)
# sha256:       784be262c2930e2749a84b5ecdc413348ec0eb6da496902fce67983930623651
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m459cc9_hit_test
# naming:       native port src/original_methods_fl23a.c:m459cc9_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m459cc9_hit_test (callees via host). Direct: objects, ordered calls, edges. Unicorn differential: 300 fixtures, every instruction reached. Window covers all 275 bytes. See tasks/fl23a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1c, field_1e, field_61, field_65, field_69, field_6d, field_d6; [edx + n] field_cc
# callees:      calls FUN_00459ddc
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23a.c:m459cc9_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 74 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_61, 0x61  # offset +0x61
.equ field_65, 0x65  # offset +0x65
.equ field_69, 0x69  # offset +0x69
.equ field_6d, 0x6d  # offset +0x6d
.equ field_cc, 0xcc  # offset +0xcc
.equ field_d6, 0xd6  # offset +0xd6

# --- external targets -----------------------------------------------
.set FUN_00459ddc, .text + (0x00459ddc - 0x401000)

.org 0x00459cc9 - 0x401000
.globl FUN_00459cc9
FUN_00459cc9:
    # block 0x00459cc9: entry, 9 instruction(s), ends with je to 0x00459dd4 (forward)
    push ebp                                     # 00459cc9
    {load} mov ebp, esp                          # 00459cca
    sub esp, 0x8                                 # 00459ccc
    mov dword ptr [ebp - local_8], ecx           # 00459ccf
    mov eax, dword ptr [ebp - local_8]           # 00459cd2
    {load} xor ecx, ecx                          # 00459cd5
    mov cl, byte ptr [eax + field_d6]            # 00459cd7
    test ecx, ecx                                # 00459cdd
    je.d32 L_00459dd4                            # 00459cdf
    # block 0x00459ce5: entered by fall-through of je at 0x00459cdf, 4 instruction(s), ends with forward jump to 0x00459d05
    mov edx, dword ptr [ebp - local_8]           # 00459ce5
    mov word ptr [edx + field_cc], 0xffff        # 00459ce8
    mov word ptr [ebp - local_4], 0x0            # 00459cf1
    jmp.d8 L_00459d05                            # 00459cf7
L_00459cf9:
    # block 0x00459cf9: entered by jmp at 0x00459dcf, 3 instruction(s), falls into the block at 0x00459d05
    mov ax, word ptr [ebp - local_4]             # 00459cf9
    .insn 0x66, 0x05, 0x0001{:u16}               # 00459cfd
    mov word ptr [ebp - local_4], ax             # 00459d01
L_00459d05:
    # block 0x00459d05: entered by jmp at 0x00459cf7, 3 instruction(s), ends with jge to 0x00459dd4 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00459d05
    cmp ecx, 0x4                                 # 00459d09
    jge.d32 L_00459dd4                           # 00459d0c
    # block 0x00459d12: entered by fall-through of jge at 0x00459d0c, 9 instruction(s), ends with jl to 0x00459dcf (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00459d12
    mov eax, dword ptr [ebp - local_8]           # 00459d16
    movsx ecx, word ptr [eax + field_1c]         # 00459d19
    imul ecx, ecx, 0x8d                          # 00459d1d
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 00459d23
    movsx ecx, word ptr [ebp - local_4]          # 00459d29
    shl ecx, 0x4                                 # 00459d2d
    cmp edx, dword ptr [eax + ecx + field_65]    # 00459d30
    jl.d32 L_00459dcf                            # 00459d34
    # block 0x00459d3a: entered by fall-through of jl at 0x00459d34, 9 instruction(s), ends with jg to 0x00459dcf (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00459d3a
    mov eax, dword ptr [ebp - local_8]           # 00459d3e
    movsx ecx, word ptr [eax + field_1c]         # 00459d41
    imul ecx, ecx, 0x8d                          # 00459d45
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 00459d4b
    movsx ecx, word ptr [ebp - local_4]          # 00459d51
    shl ecx, 0x4                                 # 00459d55
    cmp edx, dword ptr [eax + ecx + field_6d]    # 00459d58
    jg.d8 L_00459dcf                             # 00459d5c
    # block 0x00459d5e: entered by fall-through of jg at 0x00459d5c, 9 instruction(s), ends with jl to 0x00459dcf (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00459d5e
    mov eax, dword ptr [ebp - local_8]           # 00459d62
    movsx ecx, word ptr [eax + field_1c]         # 00459d65
    imul ecx, ecx, 0x8d                          # 00459d69
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 00459d6f
    movsx ecx, word ptr [ebp - local_4]          # 00459d75
    shl ecx, 0x4                                 # 00459d79
    cmp edx, dword ptr [eax + ecx + field_61]    # 00459d7c
    jl.d8 L_00459dcf                             # 00459d80
    # block 0x00459d82: entered by fall-through of jl at 0x00459d80, 9 instruction(s), ends with jg to 0x00459dcf (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00459d82
    mov eax, dword ptr [ebp - local_8]           # 00459d86
    movsx ecx, word ptr [eax + field_1c]         # 00459d89
    imul ecx, ecx, 0x8d                          # 00459d8d
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 00459d93
    movsx ecx, word ptr [ebp - local_4]          # 00459d99
    shl ecx, 0x4                                 # 00459d9d
    cmp edx, dword ptr [eax + ecx + field_69]    # 00459da0
    jg.d8 L_00459dcf                             # 00459da4
    # block 0x00459da6: entered by fall-through of jg at 0x00459da4, 6 instruction(s), ends with je to 0x00459dbb (forward)
    movsx edx, word ptr [ebp - local_4]          # 00459da6
    mov eax, dword ptr [ebp - local_8]           # 00459daa
    {load} xor ecx, ecx                          # 00459dad
    mov cl, byte ptr [eax + edx + field_1e]      # 00459daf
    test ecx, ecx                                # 00459db3
    je.d8 L_00459dbb                             # 00459db5
    # block 0x00459db7: entered by fall-through of je at 0x00459db5, 2 instruction(s), ends with forward jump to 0x00459dd6
    {load} xor eax, eax                          # 00459db7
    jmp.d8 L_00459dd6                            # 00459db9
L_00459dbb:
    # block 0x00459dbb: entered by je at 0x00459db5, 6 instruction(s), calls FUN_00459ddc, ends with forward jump to 0x00459dd6
    mov dx, word ptr [ebp - local_4]             # 00459dbb
    push edx                                     # 00459dbf
    mov ecx, dword ptr [ebp - local_8]           # 00459dc0
    call FUN_00459ddc                            # 00459dc3
    mov eax, 0x1                                 # 00459dc8
    jmp.d8 L_00459dd6                            # 00459dcd
L_00459dcf:
    # block 0x00459dcf: entered by jl at 0x00459d34; jg at 0x00459d5c; jl at 0x00459d80; jg at 0x00459da4, 1 instruction(s), ends with backward jump to 0x00459cf9
    jmp.d32 L_00459cf9                           # 00459dcf
L_00459dd4:
    # block 0x00459dd4: entered by je at 0x00459cdf; jge at 0x00459d0c, 1 instruction(s), falls into the block at 0x00459dd6
    {load} xor eax, eax                          # 00459dd4
L_00459dd6:
    # block 0x00459dd6: entered by jmp at 0x00459db9; jmp at 0x00459dcd, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00459dd6
    pop ebp                                      # 00459dd8
    ret 0x8                                      # 00459dd9

