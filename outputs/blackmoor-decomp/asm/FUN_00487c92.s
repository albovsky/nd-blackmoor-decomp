# FUN_00487c92
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487c92
# extent:       0x00487c92-0x00487dcf (317 code bytes)
# span:         0x00487c92-0x00487dcf (code 317, tables 0, padding 0)
# sha256:       6f731d918ecc28a20f3096924e18358cc2979f379636d47a187b1c61c0b52ade
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m487c92_hit_test
# naming:       native port src/original_methods_fl23a.c:m487c92_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m487c92_hit_test (callees via host). Direct: objects, ordered calls, edges. Unicorn differential: 300 fixtures, every instruction reached. Window covers all 317 bytes. See tasks/fl23a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_71, field_5af; [ecx + n] field_1e, field_21, field_24, field_65, field_5a7, field_5ab; [edx + n] field_325, field_329, field_32d, field_331, field_5a3
# callees:      calls FUN_00487dcf
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23a.c:m487c92_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 87 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_24, 0x24  # offset +0x24
.equ field_65, 0x65  # offset +0x65
.equ field_71, 0x71  # offset +0x71
.equ field_325, 0x325  # offset +0x325
.equ field_329, 0x329  # offset +0x329
.equ field_32d, 0x32d  # offset +0x32d
.equ field_331, 0x331  # offset +0x331
.equ field_5a3, 0x5a3  # offset +0x5a3
.equ field_5a7, 0x5a7  # offset +0x5a7
.equ field_5ab, 0x5ab  # offset +0x5ab
.equ field_5af, 0x5af  # offset +0x5af

# --- external targets -----------------------------------------------
.set FUN_00487dcf, .text + (0x00487dcf - 0x401000)

.org 0x00487c92 - 0x401000
.globl FUN_00487c92
FUN_00487c92:
    # block 0x00487c92: entry, 7 instruction(s), ends with je to 0x00487dc7 (forward)
    push ebp                                     # 00487c92
    {load} mov ebp, esp                          # 00487c93
    sub esp, 0xc                                 # 00487c95
    mov dword ptr [ebp - local_c], ecx           # 00487c98
    mov eax, dword ptr [ebp - local_c]           # 00487c9b
    cmp dword ptr [eax + field_71], 0x0          # 00487c9e
    je.d32 L_00487dc7                            # 00487ca2
    # block 0x00487ca8: entered by fall-through of je at 0x00487ca2, 10 instruction(s), ends with jne to 0x00487d1f (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00487ca8
    movsx edx, word ptr [ecx + field_1e]         # 00487cab
    imul edx, edx, 0x8d                          # 00487caf
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00487cb5
    mov dword ptr [ebp - local_4], eax           # 00487cbb
    mov ecx, dword ptr [ebp - local_c]           # 00487cbe
    {load} xor edx, edx                          # 00487cc1
    mov dl, byte ptr [ecx + field_65]            # 00487cc3
    test edx, edx                                # 00487cc6
    jne.d8 L_00487d1f                            # 00487cc8
    # block 0x00487cca: entered by fall-through of jne at 0x00487cc8, 4 instruction(s), ends with jl to 0x00487d1f (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00487cca
    mov ecx, dword ptr [ebp - local_4]           # 00487cce
    cmp eax, dword ptr [ecx + field_5a7]         # 00487cd1
    jl.d8 L_00487d1f                             # 00487cd7
    # block 0x00487cd9: entered by fall-through of jl at 0x00487cd7, 4 instruction(s), ends with jg to 0x00487d1f (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00487cd9
    mov eax, dword ptr [ebp - local_4]           # 00487cdd
    cmp edx, dword ptr [eax + field_5af]         # 00487ce0
    jg.d8 L_00487d1f                             # 00487ce6
    # block 0x00487ce8: entered by fall-through of jg at 0x00487ce6, 4 instruction(s), ends with jl to 0x00487d1f (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00487ce8
    mov edx, dword ptr [ebp - local_4]           # 00487cec
    cmp ecx, dword ptr [edx + field_5a3]         # 00487cef
    jl.d8 L_00487d1f                             # 00487cf5
    # block 0x00487cf7: entered by fall-through of jl at 0x00487cf5, 4 instruction(s), ends with jg to 0x00487d1f (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00487cf7
    mov ecx, dword ptr [ebp - local_4]           # 00487cfb
    cmp eax, dword ptr [ecx + field_5ab]         # 00487cfe
    jg.d8 L_00487d1f                             # 00487d04
    # block 0x00487d06: entered by fall-through of jg at 0x00487d04, 6 instruction(s), calls FUN_00487dcf, ends with forward jump to 0x00487dc9
    push 0x0                                     # 00487d06
    push 0x2789                                  # 00487d08
    mov ecx, dword ptr [ebp - local_c]           # 00487d0d
    call FUN_00487dcf                            # 00487d10
    mov eax, 0x1                                 # 00487d15
    jmp.d32 L_00487dc9                           # 00487d1a
L_00487d1f:
    # block 0x00487d1f: entered by jne at 0x00487cc8; jl at 0x00487cd7; jg at 0x00487ce6; jl at 0x00487cf5; jg at 0x00487d04, 2 instruction(s), ends with forward jump to 0x00487d33
    mov word ptr [ebp - local_8], 0x0            # 00487d1f
    jmp.d8 L_00487d33                            # 00487d25
L_00487d27:
    # block 0x00487d27: entered by jmp at 0x00487dc2, 3 instruction(s), falls into the block at 0x00487d33
    mov dx, word ptr [ebp - local_8]             # 00487d27
    add dx, 0x1                                  # 00487d2b
    mov word ptr [ebp - local_8], dx             # 00487d2f
L_00487d33:
    # block 0x00487d33: entered by jmp at 0x00487d25, 5 instruction(s), ends with jge to 0x00487dc7 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00487d33
    mov ecx, dword ptr [ebp - local_4]           # 00487d37
    movsx edx, word ptr [ecx + field_21]         # 00487d3a
    {load} cmp eax, edx                          # 00487d3e
    jge.d32 L_00487dc7                           # 00487d40
    # block 0x00487d46: entered by fall-through of jge at 0x00487d40, 6 instruction(s), ends with jl to 0x00487dc2 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00487d46
    movsx ecx, word ptr [ebp - local_8]          # 00487d4a
    shl ecx, 0x4                                 # 00487d4e
    mov edx, dword ptr [ebp - local_4]           # 00487d51
    cmp eax, dword ptr [edx + ecx + field_329]   # 00487d54
    jl.d8 L_00487dc2                             # 00487d5b
    # block 0x00487d5d: entered by fall-through of jl at 0x00487d5b, 6 instruction(s), ends with jg to 0x00487dc2 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00487d5d
    movsx ecx, word ptr [ebp - local_8]          # 00487d61
    shl ecx, 0x4                                 # 00487d65
    mov edx, dword ptr [ebp - local_4]           # 00487d68
    cmp eax, dword ptr [edx + ecx + field_331]   # 00487d6b
    jg.d8 L_00487dc2                             # 00487d72
    # block 0x00487d74: entered by fall-through of jg at 0x00487d72, 6 instruction(s), ends with jl to 0x00487dc2 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00487d74
    movsx ecx, word ptr [ebp - local_8]          # 00487d78
    shl ecx, 0x4                                 # 00487d7c
    mov edx, dword ptr [ebp - local_4]           # 00487d7f
    cmp eax, dword ptr [edx + ecx + field_325]   # 00487d82
    jl.d8 L_00487dc2                             # 00487d89
    # block 0x00487d8b: entered by fall-through of jl at 0x00487d89, 6 instruction(s), ends with jg to 0x00487dc2 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00487d8b
    movsx ecx, word ptr [ebp - local_8]          # 00487d8f
    shl ecx, 0x4                                 # 00487d93
    mov edx, dword ptr [ebp - local_4]           # 00487d96
    cmp eax, dword ptr [edx + ecx + field_32d]   # 00487d99
    jg.d8 L_00487dc2                             # 00487da0
    # block 0x00487da2: entered by fall-through of jg at 0x00487da0, 9 instruction(s), calls FUN_00487dcf, ends with forward jump to 0x00487dc9
    mov ax, word ptr [ebp - local_8]             # 00487da2
    push eax                                     # 00487da6
    push 0x2788                                  # 00487da7
    mov ecx, dword ptr [ebp - local_c]           # 00487dac
    call FUN_00487dcf                            # 00487daf
    mov ecx, dword ptr [ebp - local_c]           # 00487db4
    mov byte ptr [ecx + field_24], 0x1           # 00487db7
    mov eax, 0x1                                 # 00487dbb
    jmp.d8 L_00487dc9                            # 00487dc0
L_00487dc2:
    # block 0x00487dc2: entered by jl at 0x00487d5b; jg at 0x00487d72; jl at 0x00487d89; jg at 0x00487da0, 1 instruction(s), ends with backward jump to 0x00487d27
    jmp.d32 L_00487d27                           # 00487dc2
L_00487dc7:
    # block 0x00487dc7: entered by je at 0x00487ca2; jge at 0x00487d40, 1 instruction(s), falls into the block at 0x00487dc9
    {load} xor eax, eax                          # 00487dc7
L_00487dc9:
    # block 0x00487dc9: entered by jmp at 0x00487d1a; jmp at 0x00487dc0, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00487dc9
    pop ebp                                      # 00487dcb
    ret 0x8                                      # 00487dcc

