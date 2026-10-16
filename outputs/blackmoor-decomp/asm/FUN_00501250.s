# FUN_00501250
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00501250
# extent:       0x00501250-0x00501330 (224 code bytes)
# span:         0x00501250-0x00501330 (code 224, tables 0, padding 0)
# sha256:       a3b6ca9cf87dc473d6de84eddc7d42ea481d76580b42ef23eb382d30d16d4129
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00501250
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1f0; [ebp + n] field_4, field_14, field_1c, field_20, field_24, field_28; [ecx + n] field_4; [esi + n] field_1; [esp + n] stk_c, stk_10, stk_14, stk_18, stk_20, stk_24, stk_28, stk_2c, stk_38, stk_3c
# callees:      calls FUN_00501330
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 86 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ field_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ field_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ field_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ field_1f0, 0x1f0  # offset +0x1f0

# --- external targets -----------------------------------------------
.set FUN_00501330, .text + (0x00501330 - 0x401000)

.org 0x00501250 - 0x401000
.globl FUN_00501250
FUN_00501250:
    # block 0x00501250: entry, 14 instruction(s), ends with jle to 0x0050132b (forward)
    push ecx                                     # 00501250
    push ebx                                     # 00501251
    push ebp                                     # 00501252
    mov ebp, dword ptr [esp + stk_10]            # 00501253
    push esi                                     # 00501257
    {load} xor esi, esi                          # 00501258
    mov eax, dword ptr [ebp + field_4]           # 0050125a
    {disp8} mov ebx, dword ptr [ebp]             # 0050125d
    test ebx, ebx                                # 00501260
    fld dword ptr [eax + field_1f0]              # 00501262
    fsub dword ptr [esp + stk_28]                # 00501268
    mov dword ptr [esp + stk_14], ebx            # 0050126c
    fstp dword ptr [esp + stk_c]                 # 00501270
    jle.d32 L_0050132b                           # 00501274
    # block 0x0050127a: entered by fall-through of jle at 0x00501274, 1 instruction(s), falls into the block at 0x0050127b
    push edi                                     # 0050127a
L_0050127b:
    # block 0x0050127b: entered by jl at 0x00501324, 9 instruction(s), ends with jge to 0x005012c3 (forward)
    mov ecx, dword ptr [esp + stk_20]            # 0050127b
    mov edi, dword ptr [ebp + field_14]          # 0050127f
    lea eax, [esi + field_1]                     # 00501282
    fld dword ptr [ecx + 4*esi]                  # 00501285
    mov edx, dword ptr [edi + 4*esi]             # 00501288
    lea ecx, [ecx + 4*esi]                       # 0050128b
    fst dword ptr [esp + stk_2c]                 # 0050128e
    {load} cmp eax, ebx                          # 00501292
    jge.d8 L_005012c3                            # 00501294
    # block 0x00501296: entered by fall-through of jge at 0x00501294, 2 instruction(s), falls into the block at 0x0050129b
    {load} mov ebx, eax                          # 00501296
    lea edi, [edi + 4*eax]                       # 00501298
L_0050129b:
    # block 0x0050129b: entered by jl at 0x005012b9, 2 instruction(s), ends with jne to 0x005012bb (forward)
    cmp dword ptr [edi], edx                     # 0050129b
    jne.d8 L_005012bb                            # 0050129d
    # block 0x0050129f: entered by fall-through of jne at 0x0050129d, 8 instruction(s), ends with je to 0x005012b5 (forward)
    fcom dword ptr [ecx + field_4]               # 0050129f
    add ecx, 0x4                                 # 005012a2
    inc esi                                      # 005012a5
    add edi, 0x4                                 # 005012a6
    inc ebx                                      # 005012a9
    fnstsw ax                                    # 005012aa
    test ah, 0x1                                 # 005012ac
    je.d8 L_005012b5                             # 005012af
    # block 0x005012b1: entered by fall-through of je at 0x005012af, 2 instruction(s), falls into the block at 0x005012b5
    fstp st(0)                                   # 005012b1
    fld dword ptr [ecx]                          # 005012b3
L_005012b5:
    # block 0x005012b5: entered by je at 0x005012af, 2 instruction(s), ends with jl to 0x0050129b (backward)
    cmp ebx, dword ptr [esp + stk_18]            # 005012b5
    jl.d8 L_0050129b                             # 005012b9
L_005012bb:
    # block 0x005012bb: entered by jne at 0x0050129d; fall-through of jl at 0x005012b9, 2 instruction(s), falls into the block at 0x005012c3
    fst dword ptr [esp + stk_2c]                 # 005012bb
    mov ebx, dword ptr [esp + stk_18]            # 005012bf
L_005012c3:
    # block 0x005012c3: entered by jge at 0x00501294, 6 instruction(s), ends with jne to 0x00501321 (forward)
    fadd dword ptr [0x52e5f4]                    # 005012c3
    mov eax, dword ptr [esp + stk_24]            # 005012c9
    fcomp dword ptr [eax + 4*esi]                # 005012cd
    fnstsw ax                                    # 005012d0
    test ah, 0x41                                # 005012d2
    jne.d8 L_00501321                            # 005012d5
    # block 0x005012d7: entered by fall-through of jne at 0x005012d5, 4 instruction(s), ends with jl to 0x005012e8 (forward)
    mov ecx, dword ptr [ebp + field_20]          # 005012d7
    sar edx, cl                                  # 005012da
    cmp edx, 0x11                                # 005012dc
    jl.d8 L_005012e8                             # 005012df
    # block 0x005012e1: entered by fall-through of jl at 0x005012df, 2 instruction(s), ends with forward jump to 0x005012ee
    mov edx, 0x10                                # 005012e1
    jmp.d8 L_005012ee                            # 005012e6
L_005012e8:
    # block 0x005012e8: entered by jl at 0x005012df, 2 instruction(s), ends with jge to 0x005012ee (forward)
    test edx, edx                                # 005012e8
    jge.d8 L_005012ee                            # 005012ea
    # block 0x005012ec: entered by fall-through of jge at 0x005012ea, 1 instruction(s), falls into the block at 0x005012ee
    {load} xor edx, edx                          # 005012ec
L_005012ee:
    # block 0x005012ee: entered by jmp at 0x005012e6; jge at 0x005012ea, 20 instruction(s), calls FUN_00501330, falls into the block at 0x00501321
    mov ecx, dword ptr [esp + stk_10]            # 005012ee
    mov eax, dword ptr [ebp + field_24]          # 005012f2
    mov edi, dword ptr [ebp + field_1c]          # 005012f5
    push ecx                                     # 005012f8
    mov ecx, dword ptr [ebp + field_28]          # 005012f9
    push eax                                     # 005012fc
    mov eax, dword ptr [ebp + field_14]          # 005012fd
    push ecx                                     # 00501300
    mov ecx, dword ptr [esp + stk_38]            # 00501301
    mov eax, dword ptr [eax + 4*esi]             # 00501305
    {load} sub eax, edi                          # 00501308
    push eax                                     # 0050130a
    mov eax, dword ptr [esp + stk_2c]            # 0050130b
    push ecx                                     # 0050130f
    mov ecx, dword ptr [eax + 4*edx]             # 00501310
    mov edx, dword ptr [esp + stk_3c]            # 00501313
    push ecx                                     # 00501317
    push edx                                     # 00501318
    call FUN_00501330                            # 00501319
    add esp, 0x1c                                # 0050131e
L_00501321:
    # block 0x00501321: entered by jne at 0x005012d5, 3 instruction(s), ends with jl to 0x0050127b (backward)
    inc esi                                      # 00501321
    {load} cmp esi, ebx                          # 00501322
    jl.d32 L_0050127b                            # 00501324
    # block 0x0050132a: entered by fall-through of jl at 0x00501324, 1 instruction(s), falls into the block at 0x0050132b
    pop edi                                      # 0050132a
L_0050132b:
    # block 0x0050132b: entered by jle at 0x00501274, 5 instruction(s), ends with ret
    pop esi                                      # 0050132b
    pop ebp                                      # 0050132c
    pop ebx                                      # 0050132d
    pop ecx                                      # 0050132e
    ret                                          # 0050132f

