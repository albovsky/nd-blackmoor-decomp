# FUN_00526245
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526245
# extent:       0x00526245-0x0052628b (70 code bytes)
# span:         0x00526245-0x0052628b (code 70, tables 0, padding 0)
# sha256:       b5534c50514a2f52327454082ed618012aaeca48f7da8106d80826e504acc38b
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526245
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005261b1, ADVAPI32.dll!RegCreateKeyExA, ADVAPI32.dll!RegCloseKey
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005261b1, .text + (0x005261b1 - 0x401000)

.org 0x00526245 - 0x401000
.globl FUN_00526245
FUN_00526245:
    # block 0x00526245: entry, 12 instruction(s), calls FUN_005261b1, ends with jne to 0x00526260 (forward)
    push ebp                                     # 00526245
    {load} mov ebp, esp                          # 00526246
    push ecx                                     # 00526248
    push ecx                                     # 00526249
    push esi                                     # 0052624a
    {load} xor esi, esi                          # 0052624b
    push edi                                     # 0052624d
    mov dword ptr [ebp - local_4], esi           # 0052624e
    call FUN_005261b1                            # 00526251
    {load} mov edi, eax                          # 00526256
    {load} cmp edi, esi                          # 00526258
    jne.d8 L_00526260                            # 0052625a
    # block 0x0052625c: entered by fall-through of jne at 0x0052625a, 2 instruction(s), ends with forward jump to 0x00526285
    {load} xor eax, eax                          # 0052625c
    jmp.d8 L_00526285                            # 0052625e
L_00526260:
    # block 0x00526260: entered by jne at 0x0052625a, 15 instruction(s), calls ADVAPI32.dll!RegCreateKeyExA, ADVAPI32.dll!RegCloseKey, falls into the block at 0x00526285
    lea eax, [ebp - local_8]                     # 00526260
    push eax                                     # 00526263
    lea eax, [ebp - local_4]                     # 00526264
    push eax                                     # 00526267
    push esi                                     # 00526268
    push 0x2001f                                 # 00526269
    push esi                                     # 0052626e
    push esi                                     # 0052626f
    push esi                                     # 00526270
    push dword ptr [ebp + arg_8]                 # 00526271
    push edi                                     # 00526274
    call dword ptr [0x52a008]                    # 00526275
    push edi                                     # 0052627b
    call dword ptr [0x52a000]                    # 0052627c
    mov eax, dword ptr [ebp - local_4]           # 00526282
L_00526285:
    # block 0x00526285: entered by jmp at 0x0052625e, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 00526285
    pop esi                                      # 00526286
    leave                                        # 00526287
    ret 0x4                                      # 00526288

