# FUN_005016a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005016a0
# extent:       0x005016a0-0x0050172a (138 code bytes)
# span:         0x005016a0-0x00501730 (code 138, tables 0, padding 6)
# sha256:       6ac277b48648b27beb485e441146c131df500b1c1b5535724e3a0551b64e2964
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005016a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_c; [edi + n] field_4, field_c; [esi + n] field_6c; [esp + n] stk_4, stk_8, stk_10, stk_14, stk_18, stk_1c, stk_28
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 53 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_28, 0x28  # offset +0x28
.equ field_6c, 0x6c  # offset +0x6c

# --- external targets -----------------------------------------------

.org 0x005016a0 - 0x401000
.globl FUN_005016a0
FUN_005016a0:
    # block 0x005016a0: entry, 12 instruction(s), ends with jle to 0x00501725 (forward)
    sub esp, 0x8                                 # 005016a0
    mov edx, dword ptr [esp + stk_18]            # 005016a3
    push edi                                     # 005016a7
    mov edi, dword ptr [esp + stk_10]            # 005016a8
    mov ecx, dword ptr [edi + field_4]           # 005016ac
    mov eax, dword ptr [edi]                     # 005016af
    mov dword ptr [esp + stk_8], eax             # 005016b1
    fld dword ptr [ecx + 4*edx + field_c]        # 005016b5
    {load} xor edx, edx                          # 005016b9
    fstp dword ptr [esp + stk_4]                 # 005016bb
    test eax, eax                                # 005016bf
    jle.d8 L_00501725                            # 005016c1
    # block 0x005016c3: entered by fall-through of jle at 0x005016c1, 8 instruction(s), falls into the block at 0x005016d6
    mov ecx, dword ptr [esp + stk_18]            # 005016c3
    push ebx                                     # 005016c7
    mov ebx, dword ptr [esp + stk_18]            # 005016c8
    push ebp                                     # 005016cc
    mov ebp, dword ptr [esp + stk_28]            # 005016cd
    {load} sub ebx, ecx                          # 005016d1
    push esi                                     # 005016d3
    {load} sub ebp, ecx                          # 005016d4
L_005016d6:
    # block 0x005016d6: entered by jl at 0x00501720, 10 instruction(s), ends with jne to 0x005016f8 (forward)
    mov eax, dword ptr [edi + field_c]           # 005016d6
    mov esi, dword ptr [esp + stk_28]            # 005016d9
    mov eax, dword ptr [eax + 4*esi]             # 005016dd
    mov esi, dword ptr [edi + field_4]           # 005016e0
    fld dword ptr [eax + 4*edx]                  # 005016e3
    fadd dword ptr [ebx + ecx]                   # 005016e6
    fcom dword ptr [esi + field_6c]              # 005016e9
    fnstsw ax                                    # 005016ec
    test ah, 0x41                                # 005016ee
    jne.d8 L_005016f8                            # 005016f1
    # block 0x005016f3: entered by fall-through of jne at 0x005016f1, 2 instruction(s), falls into the block at 0x005016f8
    fstp st(0)                                   # 005016f3
    fld dword ptr [esi + field_6c]               # 005016f5
L_005016f8:
    # block 0x005016f8: entered by jne at 0x005016f1, 7 instruction(s), ends with je to 0x00501713 (forward)
    fld dword ptr [esp + stk_10]                 # 005016f8
    fadd dword ptr [ecx]                         # 005016fc
    fstp dword ptr [esp + stk_1c]                # 005016fe
    fcom dword ptr [esp + stk_1c]                # 00501702
    fnstsw ax                                    # 00501706
    test ah, 0x41                                # 00501708
    je.d8 L_00501713                             # 0050170b
    # block 0x0050170d: entered by fall-through of je at 0x0050170b, 2 instruction(s), falls into the block at 0x00501713
    fstp st(0)                                   # 0050170d
    fld dword ptr [esp + stk_1c]                 # 0050170f
L_00501713:
    # block 0x00501713: entered by je at 0x0050170b, 6 instruction(s), ends with jl to 0x005016d6 (backward)
    fstp dword ptr [ecx + ebp]                   # 00501713
    mov eax, dword ptr [esp + stk_14]            # 00501716
    inc edx                                      # 0050171a
    add ecx, 0x4                                 # 0050171b
    {load} cmp edx, eax                          # 0050171e
    jl.d8 L_005016d6                             # 00501720
    # block 0x00501722: entered by fall-through of jl at 0x00501720, 3 instruction(s), falls into the block at 0x00501725
    pop esi                                      # 00501722
    pop ebp                                      # 00501723
    pop ebx                                      # 00501724
L_00501725:
    # block 0x00501725: entered by jle at 0x005016c1, 3 instruction(s), ends with ret
    pop edi                                      # 00501725
    add esp, 0x8                                 # 00501726
    ret                                          # 00501729

# --- data items (not part of the function) -------------------------
.org 0x0050172a - 0x401000
PAD_0050172a:  # 6 byte(s) of nop padding
    .fill 6, 1, 0x90

