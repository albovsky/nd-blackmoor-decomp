# FUN_0041c770
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041c770
# extent:       0x0041c770-0x0041c7f4 (132 code bytes)
# span:         0x0041c770-0x0041c7f4 (code 132, tables 0, padding 0)
# sha256:       534a84fb8d53590362b864c96a008137f7d07554ea906d3937844cbd76c16686
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41c770_init_fields
# naming:       native port src/original_methods_fl20a.c:m41c770_init_fields (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m41c770_init_fields. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 132 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1b7, field_1be, field_1c8, field_1cf; [ecx + n] field_1ba, field_1c0, field_1cc; [edx + n] field_1bc, field_1c4, field_1ce
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl20a.c:m41c770_init_fields (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_1b7, 0x1b7  # offset +0x1b7
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_1bc, 0x1bc  # offset +0x1bc
.equ field_1be, 0x1be  # offset +0x1be
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_1c8, 0x1c8  # offset +0x1c8
.equ field_1cc, 0x1cc  # offset +0x1cc
.equ field_1ce, 0x1ce  # offset +0x1ce
.equ field_1cf, 0x1cf  # offset +0x1cf

# --- external targets -----------------------------------------------

.org 0x0041c770 - 0x401000
.globl FUN_0041c770
FUN_0041c770:
    # block 0x0041c770: entry, 27 instruction(s), ends with ret 0x4
    push ebp                                     # 0041c770
    {load} mov ebp, esp                          # 0041c771
    push ecx                                     # 0041c773
    mov dword ptr [ebp - local_4], ecx           # 0041c774
    mov eax, dword ptr [ebp + arg_8]             # 0041c777
    mov byte ptr [eax + field_1b7], 0x0          # 0041c77a
    mov ecx, dword ptr [ebp + arg_8]             # 0041c781
    mov word ptr [ecx + field_1ba], 0x0          # 0041c784
    mov edx, dword ptr [ebp + arg_8]             # 0041c78d
    mov word ptr [edx + field_1bc], 0x0          # 0041c790
    mov eax, dword ptr [ebp + arg_8]             # 0041c799
    mov word ptr [eax + field_1be], 0x1          # 0041c79c
    mov ecx, dword ptr [ebp + arg_8]             # 0041c7a5
    mov dword ptr [ecx + field_1c0], 0x0         # 0041c7a8
    mov edx, dword ptr [ebp + arg_8]             # 0041c7b2
    mov dword ptr [edx + field_1c4], 0x0         # 0041c7b5
    mov eax, dword ptr [ebp + arg_8]             # 0041c7bf
    mov dword ptr [eax + field_1c8], 0x1         # 0041c7c2
    mov ecx, dword ptr [ebp + arg_8]             # 0041c7cc
    mov word ptr [ecx + field_1cc], 0xffff       # 0041c7cf
    mov edx, dword ptr [ebp + arg_8]             # 0041c7d8
    mov byte ptr [edx + field_1ce], 0x1          # 0041c7db
    mov eax, dword ptr [ebp + arg_8]             # 0041c7e2
    mov word ptr [eax + field_1cf], 0x2          # 0041c7e5
    {load} mov esp, ebp                          # 0041c7ee
    pop ebp                                      # 0041c7f0
    ret 0x4                                      # 0041c7f1

