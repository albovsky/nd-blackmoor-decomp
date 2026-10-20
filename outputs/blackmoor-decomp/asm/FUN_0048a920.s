# FUN_0048a920
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a920
# extent:       0x0048a920-0x0048aa66 (326 code bytes)
# span:         0x0048a920-0x0048aa66 (code 326, tables 0, padding 0)
# sha256:       75799c79bb3bbc138e89f364b2828414d9cca09f0d8a859401a0a54b3dee955c
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48a920_hit_test
# naming:       native port src/original_methods_fl23a.c:m48a920_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m48a920_hit_test (callees via host). Direct: objects, ordered calls, edges. Unicorn differential: 300 fixtures, every instruction reached. Window covers all 326 bytes. See tasks/fl23a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_21, field_1aa, field_417; [ecx + n] field_1e, field_44, field_164, field_168, field_16c, field_170, field_1b0, field_40f, field_413; [edx + n] field_24, field_40b
# callees:      calls FUN_0048aa66
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23a.c:m48a920_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 91 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_44, 0x44  # offset +0x44
.equ field_164, 0x164  # offset +0x164
.equ field_168, 0x168  # offset +0x168
.equ field_16c, 0x16c  # offset +0x16c
.equ field_170, 0x170  # offset +0x170
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1b0, 0x1b0  # offset +0x1b0
.equ field_40b, 0x40b  # offset +0x40b
.equ field_40f, 0x40f  # offset +0x40f
.equ field_413, 0x413  # offset +0x413
.equ field_417, 0x417  # offset +0x417

# --- external targets -----------------------------------------------
.set FUN_0048aa66, .text + (0x0048aa66 - 0x401000)

.org 0x0048a920 - 0x401000
.globl FUN_0048a920
FUN_0048a920:
    # block 0x0048a920: entry, 7 instruction(s), ends with je to 0x0048aa5e (forward)
    push ebp                                     # 0048a920
    {load} mov ebp, esp                          # 0048a921
    sub esp, 0xc                                 # 0048a923
    mov dword ptr [ebp - local_c], ecx           # 0048a926
    mov eax, dword ptr [ebp - local_c]           # 0048a929
    cmp dword ptr [eax + field_1aa], 0x0         # 0048a92c
    je.d32 L_0048aa5e                            # 0048a933
    # block 0x0048a939: entered by fall-through of je at 0x0048a933, 9 instruction(s), ends with forward jump to 0x0048a96d
    mov ecx, dword ptr [ebp - local_c]           # 0048a939
    movsx edx, word ptr [ecx + field_1e]         # 0048a93c
    imul edx, edx, 0x8d                          # 0048a940
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0048a946
    mov dword ptr [ebp - local_8], eax           # 0048a94c
    mov ecx, dword ptr [ebp - local_c]           # 0048a94f
    mov word ptr [ecx + field_1b0], 0xffff       # 0048a952
    mov dword ptr [ebp - local_4], 0x0           # 0048a95b
    jmp.d8 L_0048a96d                            # 0048a962
L_0048a964:
    # block 0x0048a964: entered by jmp at 0x0048aa07, 3 instruction(s), falls into the block at 0x0048a96d
    mov edx, dword ptr [ebp - local_4]           # 0048a964
    add edx, 0x1                                 # 0048a967
    mov dword ptr [ebp - local_4], edx           # 0048a96a
L_0048a96d:
    # block 0x0048a96d: entered by jmp at 0x0048a962, 5 instruction(s), ends with jge to 0x0048aa0c (forward)
    mov eax, dword ptr [ebp - local_8]           # 0048a96d
    {load} xor ecx, ecx                          # 0048a970
    mov cl, byte ptr [eax + field_21]            # 0048a972
    cmp dword ptr [ebp - local_4], ecx           # 0048a975
    jge.d32 L_0048aa0c                           # 0048a978
    # block 0x0048a97e: entered by fall-through of jge at 0x0048a978, 6 instruction(s), ends with jl to 0x0048aa07 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0048a97e
    mov eax, dword ptr [ebp - local_4]           # 0048a982
    shl eax, 0x4                                 # 0048a985
    mov ecx, dword ptr [ebp - local_8]           # 0048a988
    cmp edx, dword ptr [ecx + eax + field_168]   # 0048a98b
    jl.d8 L_0048aa07                             # 0048a992
    # block 0x0048a994: entered by fall-through of jl at 0x0048a992, 6 instruction(s), ends with jg to 0x0048aa07 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0048a994
    mov eax, dword ptr [ebp - local_4]           # 0048a998
    shl eax, 0x4                                 # 0048a99b
    mov ecx, dword ptr [ebp - local_8]           # 0048a99e
    cmp edx, dword ptr [ecx + eax + field_170]   # 0048a9a1
    jg.d8 L_0048aa07                             # 0048a9a8
    # block 0x0048a9aa: entered by fall-through of jg at 0x0048a9a8, 6 instruction(s), ends with jl to 0x0048aa07 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0048a9aa
    mov eax, dword ptr [ebp - local_4]           # 0048a9ae
    shl eax, 0x4                                 # 0048a9b1
    mov ecx, dword ptr [ebp - local_8]           # 0048a9b4
    cmp edx, dword ptr [ecx + eax + field_164]   # 0048a9b7
    jl.d8 L_0048aa07                             # 0048a9be
    # block 0x0048a9c0: entered by fall-through of jl at 0x0048a9be, 6 instruction(s), ends with jg to 0x0048aa07 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0048a9c0
    mov eax, dword ptr [ebp - local_4]           # 0048a9c4
    shl eax, 0x4                                 # 0048a9c7
    mov ecx, dword ptr [ebp - local_8]           # 0048a9ca
    cmp edx, dword ptr [ecx + eax + field_16c]   # 0048a9cd
    jg.d8 L_0048aa07                             # 0048a9d4
    # block 0x0048a9d6: entered by fall-through of jg at 0x0048a9d4, 6 instruction(s), ends with jne to 0x0048aa07 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048a9d6
    add edx, dword ptr [ebp - local_4]           # 0048a9d9
    {load} xor eax, eax                          # 0048a9dc
    mov al, byte ptr [edx + field_24]            # 0048a9de
    test eax, eax                                # 0048a9e1
    jne.d8 L_0048aa07                            # 0048a9e3
    # block 0x0048a9e5: entered by fall-through of jne at 0x0048a9e3, 3 instruction(s), ends with jne to 0x0048aa07 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048a9e5
    cmp dword ptr [ecx + field_44], 0x0          # 0048a9e8
    jne.d8 L_0048aa07                            # 0048a9ec
    # block 0x0048a9ee: entered by fall-through of jne at 0x0048a9ec, 7 instruction(s), calls FUN_0048aa66, ends with forward jump to 0x0048aa60
    mov dx, word ptr [ebp - local_4]             # 0048a9ee
    push edx                                     # 0048a9f2
    push 0x2756                                  # 0048a9f3
    mov ecx, dword ptr [ebp - local_c]           # 0048a9f8
    call FUN_0048aa66                            # 0048a9fb
    mov eax, 0x1                                 # 0048aa00
    jmp.d8 L_0048aa60                            # 0048aa05
L_0048aa07:
    # block 0x0048aa07: entered by jl at 0x0048a992; jg at 0x0048a9a8; jl at 0x0048a9be; jg at 0x0048a9d4; more, 1 instruction(s), ends with backward jump to 0x0048a964
    jmp.d32 L_0048a964                           # 0048aa07
L_0048aa0c:
    # block 0x0048aa0c: entered by jge at 0x0048a978, 4 instruction(s), ends with jl to 0x0048aa5e (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0048aa0c
    mov ecx, dword ptr [ebp - local_8]           # 0048aa10
    cmp eax, dword ptr [ecx + field_40f]         # 0048aa13
    jl.d8 L_0048aa5e                             # 0048aa19
    # block 0x0048aa1b: entered by fall-through of jl at 0x0048aa19, 4 instruction(s), ends with jg to 0x0048aa5e (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0048aa1b
    mov eax, dword ptr [ebp - local_8]           # 0048aa1f
    cmp edx, dword ptr [eax + field_417]         # 0048aa22
    jg.d8 L_0048aa5e                             # 0048aa28
    # block 0x0048aa2a: entered by fall-through of jg at 0x0048aa28, 4 instruction(s), ends with jl to 0x0048aa5e (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0048aa2a
    mov edx, dword ptr [ebp - local_8]           # 0048aa2e
    cmp ecx, dword ptr [edx + field_40b]         # 0048aa31
    jl.d8 L_0048aa5e                             # 0048aa37
    # block 0x0048aa39: entered by fall-through of jl at 0x0048aa37, 4 instruction(s), ends with jg to 0x0048aa5e (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0048aa39
    mov ecx, dword ptr [ebp - local_8]           # 0048aa3d
    cmp eax, dword ptr [ecx + field_413]         # 0048aa40
    jg.d8 L_0048aa5e                             # 0048aa46
    # block 0x0048aa48: entered by fall-through of jg at 0x0048aa46, 6 instruction(s), calls FUN_0048aa66, ends with forward jump to 0x0048aa60
    push 0x0                                     # 0048aa48
    push 0x2757                                  # 0048aa4a
    mov ecx, dword ptr [ebp - local_c]           # 0048aa4f
    call FUN_0048aa66                            # 0048aa52
    mov eax, 0x1                                 # 0048aa57
    jmp.d8 L_0048aa60                            # 0048aa5c
L_0048aa5e:
    # block 0x0048aa5e: entered by je at 0x0048a933; jl at 0x0048aa19; jg at 0x0048aa28; jl at 0x0048aa37; jg at 0x0048aa46, 1 instruction(s), falls into the block at 0x0048aa60
    {load} xor eax, eax                          # 0048aa5e
L_0048aa60:
    # block 0x0048aa60: entered by jmp at 0x0048aa05; jmp at 0x0048aa5c, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0048aa60
    pop ebp                                      # 0048aa62
    ret 0x8                                      # 0048aa63

