# FUN_0042ed54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042ed54
# extent:       0x0042ed54-0x0042f500 (1964 code bytes)
# span:         0x0042ed54-0x0042f510 (code 1964, tables 16, padding 0)
# sha256:       f733d1e41913fe184e353136c4fcbd33a3819cf4c1654a4ea7667ce3f5d537f5
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m42ed54_run_state
# naming:       native port src/original_methods_fl22b.c:m42ed54_run_state (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m42ed54_run_state (rand via host, idiv in port, 4-arm table). Direct: objects, ordered calls. Unicorn differential: 300 fixtures, every instruction reached. Window covers all 1964 bytes. See tasks/fl22b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_223, field_225, field_2a2; [ecx + n] field_21, field_27f, field_2a2, field_2b2, field_2b4, field_2b6, field_2b8, field_2ba, field_2be, field_2c2, field_2c6, field_2c8 and 1 more; [edx + n] field_21, field_223, field_266, field_268, field_26a, field_26c, field_26e, field_272, field_276, field_27a, field_27c, field_27e
# callees:      calls FUN_0050cd50, FUN_004c2dfb, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/action_family_77_runtime.h:a77_step (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 397 instruction(s), 25 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_223, 0x223  # offset +0x223
.equ field_225, 0x225  # offset +0x225
.equ field_266, 0x266  # offset +0x266
.equ field_268, 0x268  # offset +0x268
.equ field_26a, 0x26a  # offset +0x26a
.equ field_26c, 0x26c  # offset +0x26c
.equ field_26e, 0x26e  # offset +0x26e
.equ field_272, 0x272  # offset +0x272
.equ field_276, 0x276  # offset +0x276
.equ field_27a, 0x27a  # offset +0x27a
.equ field_27c, 0x27c  # offset +0x27c
.equ field_27e, 0x27e  # offset +0x27e
.equ field_27f, 0x27f  # offset +0x27f
.equ field_2a2, 0x2a2  # offset +0x2a2
.equ field_2b2, 0x2b2  # offset +0x2b2
.equ field_2b4, 0x2b4  # offset +0x2b4
.equ field_2b6, 0x2b6  # offset +0x2b6
.equ field_2b8, 0x2b8  # offset +0x2b8
.equ field_2ba, 0x2ba  # offset +0x2ba
.equ field_2be, 0x2be  # offset +0x2be
.equ field_2c2, 0x2c2  # offset +0x2c2
.equ field_2c6, 0x2c6  # offset +0x2c6
.equ field_2c8, 0x2c8  # offset +0x2c8
.equ field_2ca, 0x2ca  # offset +0x2ca

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0042ed54 - 0x401000
.globl FUN_0042ed54
FUN_0042ed54:
    # block 0x0042ed54: entry, 12 instruction(s), ends with je to 0x0042ed8f (forward)
    push ebp                                     # 0042ed54
    {load} mov ebp, esp                          # 0042ed55
    sub esp, 0x14                                # 0042ed57
    push ebx                                     # 0042ed5a
    push esi                                     # 0042ed5b
    push edi                                     # 0042ed5c
    movsx eax, word ptr [ebp + arg_8]            # 0042ed5d
    imul eax, eax, 0x8d                          # 0042ed61
    mov ecx, dword ptr [eax + 0x5bb632]          # 0042ed67
    mov dword ptr [ebp - local_10], ecx          # 0042ed6d
    cmp dword ptr [ebp - local_10], 0x0          # 0042ed70
    je.d8 L_0042ed8f                             # 0042ed74
    # block 0x0042ed76: entered by fall-through of je at 0x0042ed74, 2 instruction(s), ends with je to 0x0042ef39 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 0042ed76
    je.d32 L_0042ef39                            # 0042ed7a
    # block 0x0042ed80: entered by fall-through of je at 0x0042ed7a, 2 instruction(s), ends with je to 0x0042f1c8 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 0042ed80
    je.d32 L_0042f1c8                            # 0042ed84
    # block 0x0042ed8a: entered by fall-through of je at 0x0042ed84, 1 instruction(s), ends with forward jump to 0x0042f4f9
    jmp.d32 L_0042f4f9                           # 0042ed8a
L_0042ed8f:
    # block 0x0042ed8f: entered by je at 0x0042ed74, 14 instruction(s), calls FUN_0050cd50, ends with je to 0x0042eddb (forward)
    mov byte ptr [0x5b5158], 0x1                 # 0042ed8f
    mov byte ptr [0x5b516a], 0x0                 # 0042ed96
    mov dword ptr [0x5bb1ca], 0x1                # 0042ed9d
    mov dx, word ptr [ebp + arg_8]               # 0042eda7
    mov word ptr [0x5b5159], dx                  # 0042edab
    mov byte ptr [0x5b515d], 0x0                 # 0042edb2
    call FUN_0050cd50                            # 0042edb9
    cdq                                          # 0042edbe
    mov ecx, 0x5                                 # 0042edbf
    idiv ecx                                     # 0042edc4
    mov word ptr [ebp - local_4], dx             # 0042edc6
    movsx edx, word ptr [ebp - local_4]          # 0042edca
    test edx, edx                                # 0042edce
    je.d8 L_0042eddb                             # 0042edd0
    # block 0x0042edd2: entered by fall-through of je at 0x0042edd0, 3 instruction(s), ends with jne to 0x0042ede1 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0042edd2
    cmp eax, 0x1                                 # 0042edd6
    jne.d8 L_0042ede1                            # 0042edd9
L_0042eddb:
    # block 0x0042eddb: entered by je at 0x0042edd0; fall-through of jne at 0x0042edd9, 1 instruction(s), falls into the block at 0x0042ede1
    mov word ptr [ebp - local_4], 0x2            # 0042eddb
L_0042ede1:
    # block 0x0042ede1: entered by jne at 0x0042edd9, 14 instruction(s), ends with jle to 0x0042ee3d (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042ede1
    imul ecx, ecx, 0x8d                          # 0042ede5
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042edeb
    movsx eax, word ptr [edx + field_223]        # 0042edf1
    movsx ecx, word ptr [ebp - local_4]          # 0042edf8
    {load} add eax, ecx                          # 0042edfc
    mov word ptr [0x5b5168], ax                  # 0042edfe
    movsx edx, word ptr [0x5b5168]               # 0042ee04
    movsx eax, word ptr [ebp + arg_8]            # 0042ee0b
    imul eax, eax, 0x8d                          # 0042ee0f
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042ee15
    movsx eax, word ptr [ecx + field_21]         # 0042ee1b
    {load} cmp edx, eax                          # 0042ee1f
    jle.d8 L_0042ee3d                            # 0042ee21
    # block 0x0042ee23: entered by fall-through of jle at 0x0042ee21, 5 instruction(s), falls into the block at 0x0042ee3d
    movsx ecx, word ptr [ebp + arg_8]            # 0042ee23
    imul ecx, ecx, 0x8d                          # 0042ee27
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042ee2d
    mov ax, word ptr [edx + field_21]            # 0042ee33
    mov word ptr [0x5b5168], ax                  # 0042ee37
L_0042ee3d:
    # block 0x0042ee3d: entered by jle at 0x0042ee21, 2 instruction(s), ends with forward jump to 0x0042ee51
    mov word ptr [ebp - local_8], 0x0            # 0042ee3d
    jmp.d8 L_0042ee51                            # 0042ee43
L_0042ee45:
    # block 0x0042ee45: entered by jmp at 0x0042ee73, 3 instruction(s), falls into the block at 0x0042ee51
    mov cx, word ptr [ebp - local_8]             # 0042ee45
    add cx, 0x1                                  # 0042ee49
    mov word ptr [ebp - local_8], cx             # 0042ee4d
L_0042ee51:
    # block 0x0042ee51: entered by jmp at 0x0042ee43, 3 instruction(s), ends with jge to 0x0042ee75 (forward)
    movsx edx, word ptr [ebp - local_8]          # 0042ee51
    cmp edx, 0x10                                # 0042ee55
    jge.d8 L_0042ee75                            # 0042ee58
    # block 0x0042ee5a: entered by fall-through of jge at 0x0042ee58, 5 instruction(s), ends with backward jump to 0x0042ee45
    movsx eax, word ptr [ebp - local_8]          # 0042ee5a
    mov byte ptr [eax + 0x5b5128], 0x0           # 0042ee5e
    movsx ecx, word ptr [ebp - local_8]          # 0042ee65
    mov word ptr [2*ecx + 0x5b5138], 0xffff      # 0042ee69
    jmp.d8 L_0042ee45                            # 0042ee73
L_0042ee75:
    # block 0x0042ee75: entered by jge at 0x0042ee58, 26 instruction(s), calls FUN_004c2dfb, FUN_004c2790, ends with je to 0x0042ef16 (forward)
    mov word ptr [0x5b5166], 0x0                 # 0042ee75
    push 0x5d03cf                                # 0042ee7e
    mov ecx, 0x5cf659                            # 0042ee83
    call FUN_004c2dfb                            # 0042ee88
    push 0x545b24                                # 0042ee8d
    push 0x6                                     # 0042ee92
    movsx edx, word ptr [ebp + arg_8]            # 0042ee94
    imul edx, edx, 0x8d                          # 0042ee98
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042ee9e
    push eax                                     # 0042eea4
    push 0x545b40                                # 0042eea5
    mov ecx, 0x5cf659                            # 0042eeaa
    call FUN_004c2790                            # 0042eeaf
    mov dword ptr [0x5d03cf], eax                # 0042eeb4
    mov ecx, dword ptr [0x5d03cf]                # 0042eeb9
    mov dword ptr [0x5d1a83], ecx                # 0042eebf
    mov dword ptr [0x5d1a8f], 0x1                # 0042eec5
    mov edi, 0x545b48                            # 0042eecf
    movsx edx, word ptr [ebp + arg_8]            # 0042eed4
    imul edx, edx, 0x8d                          # 0042eed8
    mov esi, dword ptr [edx + 0x5bb5e5]          # 0042eede
    add esi, 0x235                               # 0042eee4
    mov ecx, 0x9                                 # 0042eeea
    {load} xor eax, eax                          # 0042eeef
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0042eef1
    je.d8 L_0042ef16                             # 0042eef3
    # block 0x0042eef5: entered by fall-through of je at 0x0042eef3, 7 instruction(s), calls FUN_004fb77a, falls into the block at 0x0042ef16
    movsx ecx, word ptr [ebp + arg_8]            # 0042eef5
    imul ecx, ecx, 0x8d                          # 0042eef9
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042eeff
    add edx, 0x235                               # 0042ef05
    push edx                                     # 0042ef0b
    mov ecx, 0x5c3a67                            # 0042ef0c
    call FUN_004fb77a                            # 0042ef11
L_0042ef16:
    # block 0x0042ef16: entered by je at 0x0042eef3, 5 instruction(s), ends with forward jump to 0x0042f4f9
    mov dword ptr [0x5b5162], 0x0                # 0042ef16
    movsx eax, word ptr [ebp + arg_8]            # 0042ef20
    imul eax, eax, 0x8d                          # 0042ef24
    mov dword ptr [eax + 0x5bb632], 0x1          # 0042ef2a
    jmp.d32 L_0042f4f9                           # 0042ef34
L_0042ef39:
    # block 0x0042ef39: entered by je at 0x0042ed7a, 4 instruction(s), ends with ja to 0x0042f1c3 (forward)
    mov ecx, dword ptr [0x5b5162]                # 0042ef39
    mov dword ptr [ebp - local_14], ecx          # 0042ef3f
    cmp dword ptr [ebp - local_14], 0x3          # 0042ef42
    ja.d32 L_0042f1c3                            # 0042ef46
    # block 0x0042ef4c: entered by fall-through of ja at 0x0042ef46, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x42f500]
    mov edx, dword ptr [ebp - local_14]          # 0042ef4c
    jmp dword ptr [4*edx + SWTAB_0042f500_VA]    # 0042ef4f
L_0042ef56:
    # block 0x0042ef56: entered by switch case, 3 instruction(s), ends with forward jump to 0x0042ef71
    mov byte ptr [0x5b516a], 0x1                 # 0042ef56
    mov word ptr [ebp - local_8], 0x0            # 0042ef5d
    jmp.d8 L_0042ef71                            # 0042ef63
L_0042ef65:
    # block 0x0042ef65: entered by jmp at 0x0042efc6, 3 instruction(s), falls into the block at 0x0042ef71
    mov ax, word ptr [ebp - local_8]             # 0042ef65
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042ef69
    mov word ptr [ebp - local_8], ax             # 0042ef6d
L_0042ef71:
    # block 0x0042ef71: entered by jmp at 0x0042ef63, 7 instruction(s), ends with jge to 0x0042efc8 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0042ef71
    movsx edx, word ptr [ebp + arg_8]            # 0042ef75
    imul edx, edx, 0x8d                          # 0042ef79
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042ef7f
    movsx edx, word ptr [eax + field_223]        # 0042ef85
    {load} cmp ecx, edx                          # 0042ef8c
    jge.d8 L_0042efc8                            # 0042ef8e
    # block 0x0042ef90: entered by fall-through of jge at 0x0042ef8e, 10 instruction(s), ends with je to 0x0042efc6 (forward)
    movsx eax, word ptr [ebp - local_8]          # 0042ef90
    movsx ecx, word ptr [2*eax + 0x5b5138]       # 0042ef94
    movsx edx, word ptr [ebp + arg_8]            # 0042ef9c
    imul edx, edx, 0x8d                          # 0042efa0
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042efa6
    movsx edx, word ptr [ebp - local_8]          # 0042efac
    {load} xor ebx, ebx                          # 0042efb0
    mov bl, byte ptr [eax + edx + field_225]     # 0042efb2
    {load} cmp ecx, ebx                          # 0042efb9
    je.d8 L_0042efc6                             # 0042efbb
    # block 0x0042efbd: entered by fall-through of je at 0x0042efbb, 2 instruction(s), ends with forward jump to 0x0042efc8
    mov byte ptr [0x5b516a], 0x0                 # 0042efbd
    jmp.d8 L_0042efc8                            # 0042efc4
L_0042efc6:
    # block 0x0042efc6: entered by je at 0x0042efbb, 1 instruction(s), ends with backward jump to 0x0042ef65
    jmp.d8 L_0042ef65                            # 0042efc6
L_0042efc8:
    # block 0x0042efc8: entered by jge at 0x0042ef8e; jmp at 0x0042efc4, 4 instruction(s), ends with je to 0x0042efe2 (forward)
    {load} xor eax, eax                          # 0042efc8
    mov al, byte ptr [0x5b516a]                  # 0042efca
    test eax, eax                                # 0042efcf
    je.d8 L_0042efe2                             # 0042efd1
    # block 0x0042efd3: entered by fall-through of je at 0x0042efd1, 2 instruction(s), ends with forward jump to 0x0042f1c3
    mov dword ptr [0x5b5162], 0x1                # 0042efd3
    jmp.d32 L_0042f1c3                           # 0042efdd
L_0042efe2:
    # block 0x0042efe2: entered by je at 0x0042efd1, 4 instruction(s), ends with jl to 0x0042f035 (forward)
    movsx ecx, word ptr [0x5b5166]               # 0042efe2
    movsx edx, word ptr [0x5b5168]               # 0042efe9
    {load} cmp ecx, edx                          # 0042eff0
    jl.d8 L_0042f035                             # 0042eff2
    # block 0x0042eff4: entered by fall-through of jl at 0x0042eff2, 2 instruction(s), ends with forward jump to 0x0042f008
    mov word ptr [ebp - local_8], 0x0            # 0042eff4
    jmp.d8 L_0042f008                            # 0042effa
L_0042effc:
    # block 0x0042effc: entered by jmp at 0x0042f02a, 3 instruction(s), falls into the block at 0x0042f008
    mov ax, word ptr [ebp - local_8]             # 0042effc
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042f000
    mov word ptr [ebp - local_8], ax             # 0042f004
L_0042f008:
    # block 0x0042f008: entered by jmp at 0x0042effa, 3 instruction(s), ends with jge to 0x0042f02c (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0042f008
    cmp ecx, 0x10                                # 0042f00c
    jge.d8 L_0042f02c                            # 0042f00f
    # block 0x0042f011: entered by fall-through of jge at 0x0042f00f, 5 instruction(s), ends with backward jump to 0x0042effc
    movsx edx, word ptr [ebp - local_8]          # 0042f011
    mov byte ptr [edx + 0x5b5128], 0x0           # 0042f015
    movsx eax, word ptr [ebp - local_8]          # 0042f01c
    mov word ptr [2*eax + 0x5b5138], 0xffff      # 0042f020
    jmp.d8 L_0042effc                            # 0042f02a
L_0042f02c:
    # block 0x0042f02c: entered by jge at 0x0042f00f, 1 instruction(s), falls into the block at 0x0042f035
    mov word ptr [0x5b5166], 0x0                 # 0042f02c
L_0042f035:
    # block 0x0042f035: entered by jl at 0x0042eff2, 1 instruction(s), ends with forward jump to 0x0042f1c3
    jmp.d32 L_0042f1c3                           # 0042f035
L_0042f03a:
    # block 0x0042f03a: entered by switch case, 6 instruction(s), ends with je to 0x0042f08c (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042f03a
    imul ecx, ecx, 0x8d                          # 0042f03e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f044
    movsx eax, word ptr [edx + field_27c]        # 0042f04a
    cmp eax, -0x1                                # 0042f051
    je.d8 L_0042f08c                             # 0042f054
    # block 0x0042f056: entered by fall-through of je at 0x0042f054, 10 instruction(s), falls into the block at 0x0042f08c
    movsx ecx, word ptr [ebp + arg_8]            # 0042f056
    imul ecx, ecx, 0x8d                          # 0042f05a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f060
    {load} xor eax, eax                          # 0042f066
    mov al, byte ptr [edx + field_27e]           # 0042f068
    movsx ecx, word ptr [ebp + arg_8]            # 0042f06e
    imul ecx, ecx, 0x8d                          # 0042f072
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f078
    movsx ecx, word ptr [edx + field_27c]        # 0042f07e
    mov dword ptr [4*ecx + 0x585801], eax        # 0042f085
L_0042f08c:
    # block 0x0042f08c: entered by je at 0x0042f054, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0042f1c3
    call dword ptr [0x52a23c]                    # 0042f08c
    movsx edx, word ptr [ebp + arg_8]            # 0042f092
    imul edx, edx, 0x8d                          # 0042f096
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 0042f09c
    movsx edx, word ptr [ecx + field_27f]        # 0042f0a2
    imul edx, edx, 0x3e8                         # 0042f0a9
    {load} add eax, edx                          # 0042f0af
    mov dword ptr [0x5b515e], eax                # 0042f0b1
    mov dword ptr [0x5b5162], 0x2                # 0042f0b6
    jmp.d32 L_0042f1c3                           # 0042f0c0
L_0042f0c5:
    # block 0x0042f0c5: entered by switch case, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0042f160 (forward)
    call dword ptr [0x52a23c]                    # 0042f0c5
    cmp eax, dword ptr [0x5b515e]                # 0042f0cb
    jb.d32 L_0042f160                            # 0042f0d1
    # block 0x0042f0d7: entered by fall-through of jb at 0x0042f0d1, 9 instruction(s), ends with je to 0x0042f14c (forward)
    mov edi, 0x545b54                            # 0042f0d7
    movsx eax, word ptr [ebp + arg_8]            # 0042f0dc
    imul eax, eax, 0x8d                          # 0042f0e0
    mov esi, dword ptr [eax + 0x5bb5e5]          # 0042f0e6
    add esi, 0x281                               # 0042f0ec
    mov ecx, 0x9                                 # 0042f0f2
    {load} xor edx, edx                          # 0042f0f7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0042f0f9
    je.d8 L_0042f14c                             # 0042f0fb
    # block 0x0042f0fd: entered by fall-through of je at 0x0042f0fb, 16 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x0042f160
    movsx eax, word ptr [ebp + arg_8]            # 0042f0fd
    imul eax, eax, 0x8d                          # 0042f101
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f107
    add ecx, 0x281                               # 0042f10d
    push ecx                                     # 0042f113
    mov ecx, 0x5c3a67                            # 0042f114
    call FUN_004fb77a                            # 0042f119
    movsx edx, word ptr [ebp + arg_8]            # 0042f11e
    imul edx, edx, 0x8d                          # 0042f122
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042f128
    mov cx, word ptr [eax + field_2a2]           # 0042f12e
    push ecx                                     # 0042f135
    mov ecx, 0x5c3a67                            # 0042f136
    call FUN_004fb2e3                            # 0042f13b
    mov dword ptr [0x5b5162], 0x3                # 0042f140
    jmp.d8 L_0042f160                            # 0042f14a
L_0042f14c:
    # block 0x0042f14c: entered by je at 0x0042f0fb, 3 instruction(s), falls into the block at 0x0042f160
    movsx edx, word ptr [ebp + arg_8]            # 0042f14c
    imul edx, edx, 0x8d                          # 0042f150
    mov dword ptr [edx + 0x5bb632], 0x2          # 0042f156
L_0042f160:
    # block 0x0042f160: entered by jb at 0x0042f0d1; jmp at 0x0042f14a, 1 instruction(s), ends with forward jump to 0x0042f1c3
    jmp.d8 L_0042f1c3                            # 0042f160
L_0042f162:
    # block 0x0042f162: entered by switch case, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x0042f1c3 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042f162
    imul eax, eax, 0x8d                          # 0042f166
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f16c
    movsx edx, word ptr [ecx + field_2a2]        # 0042f172
    mov dword ptr [ebp - local_c], edx           # 0042f179
    mov eax, dword ptr [ebp - local_c]           # 0042f17c
    push eax                                     # 0042f17f
    mov ecx, 0x5cf1eb                            # 0042f180
    call FUN_004f6334                            # 0042f185
    test eax, eax                                # 0042f18a
    jne.d8 L_0042f1c3                            # 0042f18c
    # block 0x0042f18e: entered by fall-through of jne at 0x0042f18c, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x0042f1c3
    movsx ecx, word ptr [ebp + arg_8]            # 0042f18e
    imul ecx, ecx, 0x8d                          # 0042f192
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f198
    add edx, 0x281                               # 0042f19e
    push edx                                     # 0042f1a4
    mov ecx, 0x5c3a67                            # 0042f1a5
    call FUN_004fba69                            # 0042f1aa
    movsx eax, word ptr [ebp + arg_8]            # 0042f1af
    imul eax, eax, 0x8d                          # 0042f1b3
    mov dword ptr [eax + 0x5bb632], 0x2          # 0042f1b9
L_0042f1c3:
    # block 0x0042f1c3: entered by ja at 0x0042ef46; jmp at 0x0042efdd; jmp at 0x0042f035; jmp at 0x0042f0c0; more, 1 instruction(s), ends with forward jump to 0x0042f4f9
    jmp.d32 L_0042f4f9                           # 0042f1c3
L_0042f1c8:
    # block 0x0042f1c8: entered by je at 0x0042ed84, 15 instruction(s), calls FUN_004c2dfb, ends with je to 0x0042f239 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0042f1c8
    mov byte ptr [0x5b5158], 0x0                 # 0042f1d2
    push 0x5d03cf                                # 0042f1d9
    mov ecx, 0x5cf659                            # 0042f1de
    call FUN_004c2dfb                            # 0042f1e3
    mov dword ptr [0x5d1a8f], 0x0                # 0042f1e8
    mov edi, 0x545b60                            # 0042f1f2
    movsx ecx, word ptr [ebp + arg_8]            # 0042f1f7
    imul ecx, ecx, 0x8d                          # 0042f1fb
    mov esi, dword ptr [ecx + 0x5bb5e5]          # 0042f201
    add esi, 0x235                               # 0042f207
    mov ecx, 0x9                                 # 0042f20d
    {load} xor edx, edx                          # 0042f212
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0042f214
    je.d8 L_0042f239                             # 0042f216
    # block 0x0042f218: entered by fall-through of je at 0x0042f216, 7 instruction(s), calls FUN_004fba69, falls into the block at 0x0042f239
    movsx eax, word ptr [ebp + arg_8]            # 0042f218
    imul eax, eax, 0x8d                          # 0042f21c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f222
    add ecx, 0x235                               # 0042f228
    push ecx                                     # 0042f22e
    mov ecx, 0x5c3a67                            # 0042f22f
    call FUN_004fba69                            # 0042f234
L_0042f239:
    # block 0x0042f239: entered by je at 0x0042f216, 4 instruction(s), ends with je to 0x0042f3ca (forward)
    {load} xor edx, edx                          # 0042f239
    mov dl, byte ptr [0x5b515d]                  # 0042f23b
    test edx, edx                                # 0042f241
    je.d32 L_0042f3ca                            # 0042f243
    # block 0x0042f249: entered by fall-through of je at 0x0042f243, 6 instruction(s), ends with je to 0x0042f373 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042f249
    imul eax, eax, 0x8d                          # 0042f24d
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f253
    movsx edx, word ptr [ecx + field_2b2]        # 0042f259
    cmp edx, 0x270f                              # 0042f260
    je.d32 L_0042f373                            # 0042f266
    # block 0x0042f26c: entered by fall-through of je at 0x0042f266, 41 instruction(s), ends with jne to 0x0042f35f (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042f26c
    imul eax, eax, 0x8d                          # 0042f270
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f276
    movsx edx, word ptr [ecx + field_2b2]        # 0042f27c
    mov dword ptr [0x5bb57b], edx                # 0042f283
    movsx eax, word ptr [ebp + arg_8]            # 0042f289
    imul eax, eax, 0x8d                          # 0042f28d
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f293
    mov dx, word ptr [ecx + field_2b4]           # 0042f299
    mov word ptr [0x5bb599], dx                  # 0042f2a0
    movsx eax, word ptr [ebp + arg_8]            # 0042f2a7
    imul eax, eax, 0x8d                          # 0042f2ab
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f2b1
    mov dx, word ptr [ecx + field_2b6]           # 0042f2b7
    mov word ptr [0x5bb595], dx                  # 0042f2be
    movsx eax, word ptr [ebp + arg_8]            # 0042f2c5
    imul eax, eax, 0x8d                          # 0042f2c9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f2cf
    mov dx, word ptr [ecx + field_2b8]           # 0042f2d5
    mov word ptr [0x5c39ff], dx                  # 0042f2dc
    movsx eax, word ptr [ebp + arg_8]            # 0042f2e3
    imul eax, eax, 0x8d                          # 0042f2e7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f2ed
    mov edx, dword ptr [ecx + field_2ba]         # 0042f2f3
    mov dword ptr [0x5bb59b], edx                # 0042f2f9
    movsx eax, word ptr [ebp + arg_8]            # 0042f2ff
    imul eax, eax, 0x8d                          # 0042f303
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f309
    mov edx, dword ptr [ecx + field_2be]         # 0042f30f
    mov dword ptr [0x5bb59f], edx                # 0042f315
    movsx eax, word ptr [ebp + arg_8]            # 0042f31b
    imul eax, eax, 0x8d                          # 0042f31f
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f325
    mov edx, dword ptr [ecx + field_2c2]         # 0042f32b
    mov dword ptr [0x5bb5a3], edx                # 0042f331
    movsx eax, word ptr [ebp + arg_8]            # 0042f337
    imul eax, eax, 0x8d                          # 0042f33b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f341
    movsx edx, word ptr [ecx + field_2c6]        # 0042f347
    cmp edx, 0x1                                 # 0042f34e
    jne.d8 L_0042f35f                            # 0042f351
    # block 0x0042f353: entered by fall-through of jne at 0x0042f351, 2 instruction(s), ends with forward jump to 0x0042f369
    mov dword ptr [0x5bb1ca], 0x0                # 0042f353
    jmp.d8 L_0042f369                            # 0042f35d
L_0042f35f:
    # block 0x0042f35f: entered by jne at 0x0042f351, 1 instruction(s), falls into the block at 0x0042f369
    mov dword ptr [0x5bb1ca], 0x1                # 0042f35f
L_0042f369:
    # block 0x0042f369: entered by jmp at 0x0042f35d, 1 instruction(s), falls into the block at 0x0042f373
    mov dword ptr [0x583999], 0x4                # 0042f369
L_0042f373:
    # block 0x0042f373: entered by je at 0x0042f266, 6 instruction(s), ends with je to 0x0042f3c5 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042f373
    imul eax, eax, 0x8d                          # 0042f377
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f37d
    movsx edx, word ptr [ecx + field_2c8]        # 0042f383
    cmp edx, -0x1                                # 0042f38a
    je.d8 L_0042f3c5                             # 0042f38d
    # block 0x0042f38f: entered by fall-through of je at 0x0042f38d, 10 instruction(s), falls into the block at 0x0042f3c5
    movsx eax, word ptr [ebp + arg_8]            # 0042f38f
    imul eax, eax, 0x8d                          # 0042f393
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f399
    {load} xor edx, edx                          # 0042f39f
    mov dl, byte ptr [ecx + field_2ca]           # 0042f3a1
    movsx eax, word ptr [ebp + arg_8]            # 0042f3a7
    imul eax, eax, 0x8d                          # 0042f3ab
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042f3b1
    movsx eax, word ptr [ecx + field_2c8]        # 0042f3b7
    mov dword ptr [4*eax + 0x585801], edx        # 0042f3be
L_0042f3c5:
    # block 0x0042f3c5: entered by je at 0x0042f38d, 1 instruction(s), ends with forward jump to 0x0042f4ec
    jmp.d32 L_0042f4ec                           # 0042f3c5
L_0042f3ca:
    # block 0x0042f3ca: entered by je at 0x0042f243, 6 instruction(s), ends with je to 0x0042f4ec (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042f3ca
    imul ecx, ecx, 0x8d                          # 0042f3ce
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f3d4
    movsx eax, word ptr [edx + field_266]        # 0042f3da
    cmp eax, 0x270f                              # 0042f3e1
    je.d32 L_0042f4ec                            # 0042f3e6
    # block 0x0042f3ec: entered by fall-through of je at 0x0042f3e6, 41 instruction(s), ends with jne to 0x0042f4d8 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042f3ec
    imul ecx, ecx, 0x8d                          # 0042f3f0
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f3f6
    movsx eax, word ptr [edx + field_266]        # 0042f3fc
    mov dword ptr [0x5bb57b], eax                # 0042f403
    movsx ecx, word ptr [ebp + arg_8]            # 0042f408
    imul ecx, ecx, 0x8d                          # 0042f40c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f412
    mov ax, word ptr [edx + field_268]           # 0042f418
    mov word ptr [0x5bb599], ax                  # 0042f41f
    movsx ecx, word ptr [ebp + arg_8]            # 0042f425
    imul ecx, ecx, 0x8d                          # 0042f429
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f42f
    mov ax, word ptr [edx + field_26a]           # 0042f435
    mov word ptr [0x5bb595], ax                  # 0042f43c
    movsx ecx, word ptr [ebp + arg_8]            # 0042f442
    imul ecx, ecx, 0x8d                          # 0042f446
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f44c
    mov ax, word ptr [edx + field_26c]           # 0042f452
    mov word ptr [0x5c39ff], ax                  # 0042f459
    movsx ecx, word ptr [ebp + arg_8]            # 0042f45f
    imul ecx, ecx, 0x8d                          # 0042f463
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f469
    mov eax, dword ptr [edx + field_26e]         # 0042f46f
    mov dword ptr [0x5bb59b], eax                # 0042f475
    movsx ecx, word ptr [ebp + arg_8]            # 0042f47a
    imul ecx, ecx, 0x8d                          # 0042f47e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f484
    mov eax, dword ptr [edx + field_272]         # 0042f48a
    mov dword ptr [0x5bb59f], eax                # 0042f490
    movsx ecx, word ptr [ebp + arg_8]            # 0042f495
    imul ecx, ecx, 0x8d                          # 0042f499
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f49f
    mov eax, dword ptr [edx + field_276]         # 0042f4a5
    mov dword ptr [0x5bb5a3], eax                # 0042f4ab
    movsx ecx, word ptr [ebp + arg_8]            # 0042f4b0
    imul ecx, ecx, 0x8d                          # 0042f4b4
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042f4ba
    movsx eax, word ptr [edx + field_27a]        # 0042f4c0
    cmp eax, 0x1                                 # 0042f4c7
    jne.d8 L_0042f4d8                            # 0042f4ca
    # block 0x0042f4cc: entered by fall-through of jne at 0x0042f4ca, 2 instruction(s), ends with forward jump to 0x0042f4e2
    mov dword ptr [0x5bb1ca], 0x0                # 0042f4cc
    jmp.d8 L_0042f4e2                            # 0042f4d6
L_0042f4d8:
    # block 0x0042f4d8: entered by jne at 0x0042f4ca, 1 instruction(s), falls into the block at 0x0042f4e2
    mov dword ptr [0x5bb1ca], 0x1                # 0042f4d8
L_0042f4e2:
    # block 0x0042f4e2: entered by jmp at 0x0042f4d6, 1 instruction(s), falls into the block at 0x0042f4ec
    mov dword ptr [0x583999], 0x4                # 0042f4e2
L_0042f4ec:
    # block 0x0042f4ec: entered by jmp at 0x0042f3c5; je at 0x0042f3e6, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x0042f4f9
    mov cx, word ptr [ebp + arg_8]               # 0042f4ec
    push ecx                                     # 0042f4f0
    call FUN_0042ba3a                            # 0042f4f1
    add esp, 0x4                                 # 0042f4f6
L_0042f4f9:
    # block 0x0042f4f9: entered by jmp at 0x0042ed8a; jmp at 0x0042ef34; jmp at 0x0042f1c3, 6 instruction(s), ends with ret
    pop edi                                      # 0042f4f9
    pop esi                                      # 0042f4fa
    pop ebx                                      # 0042f4fb
    {load} mov esp, ebp                          # 0042f4fc
    pop ebp                                      # 0042f4fe
    ret                                          # 0042f4ff

# --- data items (not part of the function) -------------------------
.org 0x0042f500 - 0x401000
SWTAB_0042f500:  # 4 case address(es)
    .long L_0042ef56 - .text + 0x401000
    .long L_0042f03a - .text + 0x401000
    .long L_0042f0c5 - .text + 0x401000
    .long L_0042f162 - .text + 0x401000
.set SWTAB_0042f500_VA, SWTAB_0042f500 - .text + 0x401000

