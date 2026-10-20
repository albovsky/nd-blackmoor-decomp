# FUN_004866b4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004866b4
# extent:       0x004866b4-0x00486725 (113 code bytes)
# span:         0x004866b4-0x00486725 (code 113, tables 0, padding 0)
# sha256:       38379eb29665b615dc33cc66ddbfaea8c0067eb1132ca15870b30a45e0e93f5b
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inside_area
# naming:       native port src/action_family_ea_runtime.c:inside_area (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      1:1 with inside_area (point in rect, strict edges). Native takes the row body as a parameter; return value is visible only via the parent's effects.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_8, field_c, field_26; [ecx + n] field_5a7, field_5ab, field_5af, field_5b3
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.c:inside_area (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_26, 0x26  # offset +0x26
.equ field_5a7, 0x5a7  # offset +0x5a7
.equ field_5ab, 0x5ab  # offset +0x5ab
.equ field_5af, 0x5af  # offset +0x5af
.equ field_5b3, 0x5b3  # offset +0x5b3

# --- external targets -----------------------------------------------

.org 0x004866b4 - 0x401000
.globl FUN_004866b4
FUN_004866b4:
    # block 0x004866b4: entry, 14 instruction(s), ends with jl to 0x0048671d (forward)
    push ebp                                     # 004866b4
    {load} mov ebp, esp                          # 004866b5
    sub esp, 0x8                                 # 004866b7
    mov dword ptr [ebp - local_8], ecx           # 004866ba
    mov eax, dword ptr [ebp - local_8]           # 004866bd
    movsx ecx, word ptr [eax + field_26]         # 004866c0
    imul ecx, ecx, 0x8d                          # 004866c4
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004866ca
    mov dword ptr [ebp - local_4], edx           # 004866d0
    mov eax, dword ptr [ebp + arg_8]             # 004866d3
    mov ecx, dword ptr [ebp - local_4]           # 004866d6
    mov edx, dword ptr [eax + field_4]           # 004866d9
    cmp edx, dword ptr [ecx + field_5ab]         # 004866dc
    jl.d8 L_0048671d                             # 004866e2
    # block 0x004866e4: entered by fall-through of jl at 0x004866e2, 5 instruction(s), ends with jg to 0x0048671d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004866e4
    mov ecx, dword ptr [ebp - local_4]           # 004866e7
    mov edx, dword ptr [eax + field_c]           # 004866ea
    cmp edx, dword ptr [ecx + field_5b3]         # 004866ed
    jg.d8 L_0048671d                             # 004866f3
    # block 0x004866f5: entered by fall-through of jg at 0x004866f3, 5 instruction(s), ends with jl to 0x0048671d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004866f5
    mov ecx, dword ptr [ebp - local_4]           # 004866f8
    mov edx, dword ptr [eax]                     # 004866fb
    cmp edx, dword ptr [ecx + field_5a7]         # 004866fd
    jl.d8 L_0048671d                             # 00486703
    # block 0x00486705: entered by fall-through of jl at 0x00486703, 5 instruction(s), ends with jg to 0x0048671d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00486705
    mov ecx, dword ptr [ebp - local_4]           # 00486708
    mov edx, dword ptr [eax + field_8]           # 0048670b
    cmp edx, dword ptr [ecx + field_5af]         # 0048670e
    jg.d8 L_0048671d                             # 00486714
    # block 0x00486716: entered by fall-through of jg at 0x00486714, 2 instruction(s), ends with forward jump to 0x0048671f
    mov eax, 0x1                                 # 00486716
    jmp.d8 L_0048671f                            # 0048671b
L_0048671d:
    # block 0x0048671d: entered by jl at 0x004866e2; jg at 0x004866f3; jl at 0x00486703; jg at 0x00486714, 1 instruction(s), falls into the block at 0x0048671f
    {load} xor eax, eax                          # 0048671d
L_0048671f:
    # block 0x0048671f: entered by jmp at 0x0048671b, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0048671f
    pop ebp                                      # 00486721
    ret 0x4                                      # 00486722

