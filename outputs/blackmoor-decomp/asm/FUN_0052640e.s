# FUN_0052640e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052640e
# extent:       0x0052640e-0x00526471 (99 code bytes)
# span:         0x0052640e-0x00526471 (code 99, tables 0, padding 0)
# sha256:       50478621f613d4d4981826ca6a80e05e8d0dfe149580e695bf3211661cae945e
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052640e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_14, field_68, field_6c, field_70, field_74; [esp + n] stk_8, stk_c, stk_10, stk_14
# callees:      calls FUN_00525371, FUN_00526471, FUN_0051ecc9; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74

# --- external targets -----------------------------------------------
.set FUN_0051ecc9, .text + (0x0051ecc9 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00526471, .text + (0x00526471 - 0x401000)

.org 0x0052640e - 0x401000
.globl FUN_0052640e
FUN_0052640e:
    # block 0x0052640e: entry, 15 instruction(s), calls indirect esi, FUN_00525371, ends with je to 0x0052645a (forward)
    push esi                                     # 0052640e
    mov esi, dword ptr [0x52a0f4]                # 0052640f
    push 0x0                                     # 00526415
    call esi                                     # 00526417
    .insn 0x66, 0x0d, 0x8001{:u16}               # 00526419
    push eax                                     # 0052641d
    call esi                                     # 0052641e
    call FUN_00525371                            # 00526420
    mov esi, dword ptr [esp + stk_8]             # 00526425
    mov dword ptr [eax + field_8], esi           # 00526429
    mov dword ptr [eax + field_c], esi           # 0052642c
    call FUN_00525371                            # 0052642f
    mov eax, dword ptr [eax + field_4]           # 00526434
    test eax, eax                                # 00526437
    je.d8 L_0052645a                             # 00526439
    # block 0x0052643b: entered by fall-through of je at 0x00526439, 9 instruction(s), calls FUN_00526471, falls into the block at 0x0052645a
    mov ecx, dword ptr [esp + stk_c]             # 0052643b
    mov dword ptr [eax + field_68], esi          # 0052643f
    mov dword ptr [eax + field_6c], ecx          # 00526442
    mov ecx, dword ptr [esp + stk_10]            # 00526445
    mov dword ptr [eax + field_70], ecx          # 00526449
    mov ecx, dword ptr [esp + stk_14]            # 0052644c
    mov dword ptr [eax + field_74], ecx          # 00526450
    {load} mov ecx, eax                          # 00526453
    call FUN_00526471                            # 00526455
L_0052645a:
    # block 0x0052645a: entered by je at 0x00526439, 4 instruction(s), calls FUN_00525371, ends with jne to 0x0052646b (forward)
    call FUN_00525371                            # 0052645a
    cmp byte ptr [eax + field_14], 0x0           # 0052645f
    pop esi                                      # 00526463
    jne.d8 L_0052646b                            # 00526464
    # block 0x00526466: entered by fall-through of jne at 0x00526464, 1 instruction(s), calls FUN_0051ecc9, falls into the block at 0x0052646b
    call FUN_0051ecc9                            # 00526466
L_0052646b:
    # block 0x0052646b: entered by jne at 0x00526464, 3 instruction(s), ends with ret 0x10
    push 0x1                                     # 0052646b
    pop eax                                      # 0052646d
    ret 0x10                                     # 0052646e

