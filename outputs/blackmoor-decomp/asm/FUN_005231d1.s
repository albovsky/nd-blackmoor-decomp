# FUN_005231d1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005231d1
# extent:       0x005231d1-0x0052329b (202 code bytes)
# span:         0x005231d1-0x0052329b (code 202, tables 0, padding 0)
# sha256:       345cba4d5135dd913ae327b7770086e1cdd31ac5214e55187ad11ec100a8bdb5
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005231d1
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_10, field_14, field_minus_4, field_minus_c; [esi + n] field_1c, field_44, field_8c, field_ac
# callees:      calls FUN_0050f978, FUN_0051faaa, FUN_0051fb55, FUN_0051d0b9, FUN_0052314e, FUN_00522fbe, USER32.dll!GetMenu, FUN_00522953, FUN_0051c22e, FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 71 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052329b
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_44, 0x44  # offset +0x44
.equ field_8c, 0x8c  # offset +0x8c
.equ field_ac, 0xac  # offset +0xac

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051c22e, .text + (0x0051c22e - 0x401000)
.set FUN_0051d0b9, .text + (0x0051d0b9 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051faaa, .text + (0x0051faaa - 0x401000)
.set FUN_0051fb55, .text + (0x0051fb55 - 0x401000)
.set FUN_00522953, .text + (0x00522953 - 0x401000)
.set FUN_00522fbe, .text + (0x00522fbe - 0x401000)
.set FUN_0052314e, .text + (0x0052314e - 0x401000)

.org 0x005231d1 - 0x401000
.globl FUN_005231d1
FUN_005231d1:
    # block 0x005231d1: entry, 17 instruction(s), calls FUN_0050f978, FUN_0051faaa, ends with je to 0x00523215 (forward)
    mov eax, 0x528f44                            # 005231d1
    call FUN_0050f978                            # 005231d6
    push ebx                                     # 005231db
    push esi                                     # 005231dc
    push edi                                     # 005231dd
    mov edi, dword ptr [ebp + field_8]           # 005231de
    {load} mov esi, ecx                          # 005231e1
    mov dword ptr [esi + field_8c], edi          # 005231e3
    mov eax, dword ptr [0x5679b0]                # 005231e9
    mov dword ptr [ebp + field_8], eax           # 005231ee
    {load} xor ebx, ebx                          # 005231f1
    push edi                                     # 005231f3
    lea ecx, [ebp + field_8]                     # 005231f4
    mov dword ptr [ebp - field_minus_4], ebx     # 005231f7
    call FUN_0051faaa                            # 005231fa
    test eax, eax                                # 005231ff
    je.d8 L_00523215                             # 00523201
    # block 0x00523203: entered by fall-through of je at 0x00523201, 6 instruction(s), calls FUN_0051fb55, falls into the block at 0x00523215
    push 0xa                                     # 00523203
    push ebx                                     # 00523205
    push dword ptr [ebp + field_8]               # 00523206
    lea eax, [esi + field_ac]                    # 00523209
    push eax                                     # 0052320f
    call FUN_0051fb55                            # 00523210
L_00523215:
    # block 0x00523215: entered by je at 0x00523201, 20 instruction(s), calls FUN_0051d0b9, FUN_0052314e, FUN_00522fbe, ends with je to 0x0052327c (forward)
    push 0x8                                     # 00523215
    call FUN_0051d0b9                            # 00523217
    push edi                                     # 0052321c
    {load} mov ecx, esi                          # 0052321d
    push dword ptr [ebp + field_c]               # 0052321f
    call FUN_0052314e                            # 00523222
    push dword ptr [ebp + field_14]              # 00523227
    mov ecx, dword ptr [esi + field_ac]          # 0052322a
    movzx edi, di                                # 00523230
    push ebx                                     # 00523233
    push edi                                     # 00523234
    push dword ptr [ebp + field_10]              # 00523235
    push 0x63c430                                # 00523238
    push dword ptr [ebp + field_c]               # 0052323d
    push ecx                                     # 00523240
    push eax                                     # 00523241
    {load} mov ecx, esi                          # 00523242
    call FUN_00522fbe                            # 00523244
    test eax, eax                                # 00523249
    je.d8 L_0052327c                             # 0052324b
    # block 0x0052324d: entered by fall-through of je at 0x0052324b, 8 instruction(s), calls USER32.dll!GetMenu, FUN_00522953, ends with jne to 0x00523279 (forward)
    push dword ptr [esi + field_1c]              # 0052324d
    call dword ptr [0x52a3f4]                    # 00523250
    push edi                                     # 00523256
    {load} mov ecx, esi                          # 00523257
    mov dword ptr [esi + field_44], eax          # 00523259
    call FUN_00522953                            # 0052325c
    cmp dword ptr [ebp + field_14], ebx          # 00523261
    jne.d8 L_00523279                            # 00523264
    # block 0x00523266: entered by fall-through of jne at 0x00523264, 7 instruction(s), calls FUN_0051c22e, falls into the block at 0x00523279
    push 0x1                                     # 00523266
    push 0x1                                     # 00523268
    push ebx                                     # 0052326a
    push ebx                                     # 0052326b
    push 0x364                                   # 0052326c
    push dword ptr [esi + field_1c]              # 00523271
    call FUN_0051c22e                            # 00523274
L_00523279:
    # block 0x00523279: entered by jne at 0x00523264, 2 instruction(s), falls into the block at 0x0052327c
    push 0x1                                     # 00523279
    pop ebx                                      # 0052327b
L_0052327c:
    # block 0x0052327c: entered by je at 0x0052324b, 11 instruction(s), calls FUN_0051e7ba, ends with ret 0x10
    or dword ptr [ebp - field_minus_4], -0x1     # 0052327c
    lea ecx, [ebp + field_8]                     # 00523280
    call FUN_0051e7ba                            # 00523283
    mov ecx, dword ptr [ebp - field_minus_c]     # 00523288
    pop edi                                      # 0052328b
    {load} mov eax, ebx                          # 0052328c
    pop esi                                      # 0052328e
    pop ebx                                      # 0052328f
    mov dword ptr fs:[0x0], ecx                  # 00523290
    leave                                        # 00523297
    ret 0x10                                     # 00523298

