# FUN_0047badf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047badf
# extent:       0x0047badf-0x0047bb56 (119 code bytes)
# span:         0x0047badf-0x0047bb56 (code 119, tables 0, padding 0)
# sha256:       15901b7c1a05ea7ad2dbba5434982980285d16328255d862802c16dc105c5658
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47badf_check_range
# naming:       native port src/original_methods_fl31a.c:m47badf_check_range (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Signed compares of [self+0x290/0x294] with [self+0x2a0] and [[self+0xc]+0x341] select flag [self+0x28] or [self+0x2c]; 81 profiles, every instruction and jump direction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c, field_2c, field_290, field_2a0, field_341; [ecx + n] field_28, field_294, field_2a0, field_341; [edx + n] field_c, field_290, field_294
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl31a.c:m47badf_check_range (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 34 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_c, 0xc  # offset +0xc
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_290, 0x290  # offset +0x290
.equ field_294, 0x294  # offset +0x294
.equ field_2a0, 0x2a0  # offset +0x2a0
.equ field_341, 0x341  # offset +0x341

# --- external targets -----------------------------------------------

.org 0x0047badf - 0x401000
.globl FUN_0047badf
FUN_0047badf:
    # block 0x0047badf: entry, 9 instruction(s), ends with jl to 0x0047bb1d (forward)
    push ebp                                     # 0047badf
    {load} mov ebp, esp                          # 0047bae0
    push ecx                                     # 0047bae2
    mov dword ptr [ebp - local_4], ecx           # 0047bae3
    mov eax, dword ptr [ebp - local_4]           # 0047bae6
    mov ecx, dword ptr [ebp - local_4]           # 0047bae9
    mov edx, dword ptr [eax + field_290]         # 0047baec
    cmp edx, dword ptr [ecx + field_2a0]         # 0047baf2
    jl.d8 L_0047bb1d                             # 0047baf8
    # block 0x0047bafa: entered by fall-through of jl at 0x0047baf8, 6 instruction(s), ends with jg to 0x0047bb1d (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047bafa
    mov ecx, dword ptr [eax + field_c]           # 0047bafd
    mov edx, dword ptr [ebp - local_4]           # 0047bb00
    mov eax, dword ptr [edx + field_294]         # 0047bb03
    cmp eax, dword ptr [ecx + field_341]         # 0047bb09
    jg.d8 L_0047bb1d                             # 0047bb0f
    # block 0x0047bb11: entered by fall-through of jg at 0x0047bb0f, 3 instruction(s), ends with forward jump to 0x0047bb52
    mov ecx, dword ptr [ebp - local_4]           # 0047bb11
    mov dword ptr [ecx + field_28], 0x1          # 0047bb14
    jmp.d8 L_0047bb52                            # 0047bb1b
L_0047bb1d:
    # block 0x0047bb1d: entered by jl at 0x0047baf8; jg at 0x0047bb0f, 5 instruction(s), ends with jge to 0x0047bb52 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0047bb1d
    mov eax, dword ptr [ebp - local_4]           # 0047bb20
    mov ecx, dword ptr [edx + field_290]         # 0047bb23
    cmp ecx, dword ptr [eax + field_2a0]         # 0047bb29
    jge.d8 L_0047bb52                            # 0047bb2f
    # block 0x0047bb31: entered by fall-through of jge at 0x0047bb2f, 6 instruction(s), ends with jl to 0x0047bb52 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0047bb31
    mov eax, dword ptr [edx + field_c]           # 0047bb34
    mov ecx, dword ptr [ebp - local_4]           # 0047bb37
    mov edx, dword ptr [ecx + field_294]         # 0047bb3a
    cmp edx, dword ptr [eax + field_341]         # 0047bb40
    jl.d8 L_0047bb52                             # 0047bb46
    # block 0x0047bb48: entered by fall-through of jl at 0x0047bb46, 2 instruction(s), falls into the block at 0x0047bb52
    mov eax, dword ptr [ebp - local_4]           # 0047bb48
    mov dword ptr [eax + field_2c], 0x1          # 0047bb4b
L_0047bb52:
    # block 0x0047bb52: entered by jmp at 0x0047bb1b; jge at 0x0047bb2f; jl at 0x0047bb46, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047bb52
    pop ebp                                      # 0047bb54
    ret                                          # 0047bb55

