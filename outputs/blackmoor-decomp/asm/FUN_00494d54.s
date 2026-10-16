# FUN_00494d54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00494d54
# extent:       0x00494d54-0x00494f14 (448 code bytes)
# span:         0x00494d54-0x00494f14 (code 448, tables 0, padding 0)
# sha256:       9bfef14e385d3cbb8977da9baeebad70f1eeb1ad6e3f72c517374984415e9894
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00494d54
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1f2b, field_1f43, field_1f6b, field_1f73, field_47b1; [ecx + n] field_1f2b, field_1f43, field_1f6f, field_1f73, field_47ad; [edx + n] field_1f2b, field_1f43, field_1f6f, field_47a9, field_47b1
# callees:      calls FUN_00493ca3, FUN_004956d3, FUN_00495608, FUN_00495a5b, FUN_00494f14, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 109 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1f2b, 0x1f2b  # offset +0x1f2b
.equ field_1f43, 0x1f43  # offset +0x1f43
.equ field_1f6b, 0x1f6b  # offset +0x1f6b
.equ field_1f6f, 0x1f6f  # offset +0x1f6f
.equ field_1f73, 0x1f73  # offset +0x1f73
.equ field_47a9, 0x47a9  # offset +0x47a9
.equ field_47ad, 0x47ad  # offset +0x47ad
.equ field_47b1, 0x47b1  # offset +0x47b1

# --- external targets -----------------------------------------------
.set FUN_00493ca3, .text + (0x00493ca3 - 0x401000)
.set FUN_00494f14, .text + (0x00494f14 - 0x401000)
.set FUN_00495608, .text + (0x00495608 - 0x401000)
.set FUN_004956d3, .text + (0x004956d3 - 0x401000)
.set FUN_00495a5b, .text + (0x00495a5b - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x00494d54 - 0x401000
.globl FUN_00494d54
FUN_00494d54:
    # block 0x00494d54: entry, 7 instruction(s), ends with jne to 0x00494d6f (forward)
    push ebp                                     # 00494d54
    {load} mov ebp, esp                          # 00494d55
    push ecx                                     # 00494d57
    mov dword ptr [ebp - local_4], ecx           # 00494d58
    mov eax, dword ptr [ebp - local_4]           # 00494d5b
    cmp dword ptr [eax + field_1f6b], 0x0        # 00494d5e
    jne.d8 L_00494d6f                            # 00494d65
    # block 0x00494d67: entered by fall-through of jne at 0x00494d65, 2 instruction(s), calls FUN_00493ca3, falls into the block at 0x00494d6f
    mov ecx, dword ptr [ebp - local_4]           # 00494d67
    call FUN_00493ca3                            # 00494d6a
L_00494d6f:
    # block 0x00494d6f: entered by jne at 0x00494d65, 8 instruction(s), calls FUN_004956d3, FUN_00495608, ends with je to 0x00494d93 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00494d6f
    call FUN_004956d3                            # 00494d72
    mov ecx, dword ptr [ebp - local_4]           # 00494d77
    call FUN_00495608                            # 00494d7a
    {load} xor ecx, ecx                          # 00494d7f
    mov cl, byte ptr [0x58322d]                  # 00494d81
    test ecx, ecx                                # 00494d87
    je.d8 L_00494d93                             # 00494d89
    # block 0x00494d8b: entered by fall-through of je at 0x00494d89, 2 instruction(s), calls FUN_00495a5b, falls into the block at 0x00494d93
    mov ecx, dword ptr [ebp - local_4]           # 00494d8b
    call FUN_00495a5b                            # 00494d8e
L_00494d93:
    # block 0x00494d93: entered by je at 0x00494d89, 4 instruction(s), ends with je to 0x00494ddb (forward)
    {load} xor edx, edx                          # 00494d93
    mov dl, byte ptr [0x58322e]                  # 00494d95
    test edx, edx                                # 00494d9b
    je.d8 L_00494ddb                             # 00494d9d
    # block 0x00494d9f: entered by fall-through of je at 0x00494d9d, 4 instruction(s), ends with je to 0x00494dc1 (forward)
    mov byte ptr [0x58322e], 0x0                 # 00494d9f
    mov eax, dword ptr [ebp - local_4]           # 00494da6
    cmp dword ptr [eax + field_1f73], 0x0        # 00494da9
    je.d8 L_00494dc1                             # 00494db0
    # block 0x00494db2: entered by fall-through of je at 0x00494db0, 3 instruction(s), ends with forward jump to 0x00494ddb
    mov ecx, dword ptr [ebp - local_4]           # 00494db2
    mov dword ptr [ecx + field_1f6f], 0x2        # 00494db5
    jmp.d8 L_00494ddb                            # 00494dbf
L_00494dc1:
    # block 0x00494dc1: entered by je at 0x00494db0, 4 instruction(s), falls into the block at 0x00494ddb
    mov edx, dword ptr [ebp - local_4]           # 00494dc1
    mov dword ptr [edx + field_1f6f], 0x0        # 00494dc4
    mov eax, dword ptr [ebp - local_4]           # 00494dce
    mov dword ptr [eax + field_1f73], 0x1        # 00494dd1
L_00494ddb:
    # block 0x00494ddb: entered by je at 0x00494d9d; jmp at 0x00494dbf, 3 instruction(s), ends with je to 0x00494def (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00494ddb
    cmp dword ptr [ecx + field_1f73], 0x0        # 00494dde
    je.d8 L_00494def                             # 00494de5
    # block 0x00494de7: entered by fall-through of je at 0x00494de5, 2 instruction(s), calls FUN_00494f14, falls into the block at 0x00494def
    mov ecx, dword ptr [ebp - local_4]           # 00494de7
    call FUN_00494f14                            # 00494dea
L_00494def:
    # block 0x00494def: entered by je at 0x00494de5, 4 instruction(s), ends with je to 0x00494e67 (forward)
    {load} xor edx, edx                          # 00494def
    mov dl, byte ptr [0x58322f]                  # 00494df1
    test edx, edx                                # 00494df7
    je.d8 L_00494e67                             # 00494df9
    # block 0x00494dfb: entered by fall-through of je at 0x00494df9, 12 instruction(s), ends with jne to 0x00494e3e (forward)
    mov eax, dword ptr [ebp - local_4]           # 00494dfb
    fld dword ptr [eax + field_1f2b]             # 00494dfe
    fadd dword ptr [0x52cd14]                    # 00494e04
    mov ecx, dword ptr [ebp - local_4]           # 00494e0a
    fstp dword ptr [ecx + field_1f2b]            # 00494e0d
    mov edx, dword ptr [ebp - local_4]           # 00494e13
    mov eax, dword ptr [ebp - local_4]           # 00494e16
    fld dword ptr [edx + field_1f2b]             # 00494e19
    fcomp dword ptr [eax + field_47b1]           # 00494e1f
    fnstsw ax                                    # 00494e25
    test ah, 0x41                                # 00494e27
    jne.d8 L_00494e3e                            # 00494e2a
    # block 0x00494e2c: entered by fall-through of jne at 0x00494e2a, 4 instruction(s), falls into the block at 0x00494e3e
    mov ecx, dword ptr [ebp - local_4]           # 00494e2c
    mov edx, dword ptr [ebp - local_4]           # 00494e2f
    mov eax, dword ptr [edx + field_47b1]        # 00494e32
    mov dword ptr [ecx + field_1f2b], eax        # 00494e38
L_00494e3e:
    # block 0x00494e3e: entered by jne at 0x00494e2a, 9 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x00494ed5
    mov ecx, dword ptr [ebp - local_4]           # 00494e3e
    mov edx, dword ptr [ebp - local_4]           # 00494e41
    fld dword ptr [ecx + field_1f2b]             # 00494e44
    fmul dword ptr [edx + field_47a9]            # 00494e4a
    call FUN_0050ce04                            # 00494e50
    mov ecx, dword ptr [ebp - local_4]           # 00494e55
    mov dword ptr [ecx + field_47ad], eax        # 00494e58
    mov byte ptr [0x58322f], 0x0                 # 00494e5e
    jmp.d8 L_00494ed5                            # 00494e65
L_00494e67:
    # block 0x00494e67: entered by je at 0x00494df9, 4 instruction(s), ends with je to 0x00494ed5 (forward)
    {load} xor edx, edx                          # 00494e67
    mov dl, byte ptr [0x583230]                  # 00494e69
    test edx, edx                                # 00494e6f
    je.d8 L_00494ed5                             # 00494e71
    # block 0x00494e73: entered by fall-through of je at 0x00494e71, 11 instruction(s), ends with je to 0x00494eae (forward)
    mov eax, dword ptr [ebp - local_4]           # 00494e73
    fld dword ptr [eax + field_1f2b]             # 00494e76
    fsub dword ptr [0x52cd14]                    # 00494e7c
    mov ecx, dword ptr [ebp - local_4]           # 00494e82
    fstp dword ptr [ecx + field_1f2b]            # 00494e85
    mov edx, dword ptr [ebp - local_4]           # 00494e8b
    fld dword ptr [edx + field_1f2b]             # 00494e8e
    fcomp dword ptr [0x52cbf4]                   # 00494e94
    fnstsw ax                                    # 00494e9a
    test ah, 0x1                                 # 00494e9c
    je.d8 L_00494eae                             # 00494e9f
    # block 0x00494ea1: entered by fall-through of je at 0x00494e9f, 2 instruction(s), falls into the block at 0x00494eae
    mov eax, dword ptr [ebp - local_4]           # 00494ea1
    mov dword ptr [eax + field_1f2b], 0x3f800000 # 00494ea4
L_00494eae:
    # block 0x00494eae: entered by je at 0x00494e9f, 8 instruction(s), calls FUN_0050ce04, falls into the block at 0x00494ed5
    mov ecx, dword ptr [ebp - local_4]           # 00494eae
    mov edx, dword ptr [ebp - local_4]           # 00494eb1
    fld dword ptr [ecx + field_1f2b]             # 00494eb4
    fmul dword ptr [edx + field_47a9]            # 00494eba
    call FUN_0050ce04                            # 00494ec0
    mov ecx, dword ptr [ebp - local_4]           # 00494ec5
    mov dword ptr [ecx + field_47ad], eax        # 00494ec8
    mov byte ptr [0x583230], 0x0                 # 00494ece
L_00494ed5:
    # block 0x00494ed5: entered by jmp at 0x00494e65; je at 0x00494e71, 4 instruction(s), ends with je to 0x00494f10 (forward)
    {load} xor edx, edx                          # 00494ed5
    mov dl, byte ptr [0x583231]                  # 00494ed7
    test edx, edx                                # 00494edd
    je.d8 L_00494f10                             # 00494edf
    # block 0x00494ee1: entered by fall-through of je at 0x00494edf, 3 instruction(s), ends with je to 0x00494efc (forward)
    mov eax, dword ptr [ebp - local_4]           # 00494ee1
    cmp dword ptr [eax + field_1f43], 0x0        # 00494ee4
    je.d8 L_00494efc                             # 00494eeb
    # block 0x00494eed: entered by fall-through of je at 0x00494eeb, 3 instruction(s), ends with forward jump to 0x00494f09
    mov ecx, dword ptr [ebp - local_4]           # 00494eed
    mov dword ptr [ecx + field_1f43], 0x0        # 00494ef0
    jmp.d8 L_00494f09                            # 00494efa
L_00494efc:
    # block 0x00494efc: entered by je at 0x00494eeb, 2 instruction(s), falls into the block at 0x00494f09
    mov edx, dword ptr [ebp - local_4]           # 00494efc
    mov dword ptr [edx + field_1f43], 0x1        # 00494eff
L_00494f09:
    # block 0x00494f09: entered by jmp at 0x00494efa, 1 instruction(s), falls into the block at 0x00494f10
    mov byte ptr [0x583231], 0x0                 # 00494f09
L_00494f10:
    # block 0x00494f10: entered by je at 0x00494edf, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00494f10
    pop ebp                                      # 00494f12
    ret                                          # 00494f13

