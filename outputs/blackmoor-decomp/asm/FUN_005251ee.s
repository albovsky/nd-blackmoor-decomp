# FUN_005251ee
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005251ee
# extent:       0x005251ee-0x00525263 (117 code bytes)
# span:         0x005251ee-0x00525263 (code 117, tables 0, padding 0)
# sha256:       0dd393d7cb87e39976b37a9c28db3b31008ac086524562f3fb918b3186ee977e
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005251ee
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_c; [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_1044, field_1048, field_106c, field_1070
# callees:      calls FUN_0050f978, FUN_00525bb3; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00525263
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ field_1044, 0x1044  # offset +0x1044
.equ field_1048, 0x1048  # offset +0x1048
.equ field_106c, 0x106c  # offset +0x106c
.equ field_1070, 0x1070  # offset +0x1070

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_00525bb3, .text + (0x00525bb3 - 0x401000)

.org 0x005251ee - 0x401000
.globl FUN_005251ee
FUN_005251ee:
    # block 0x005251ee: entry, 12 instruction(s), calls FUN_0050f978, ends with je to 0x0052521d (forward)
    mov eax, 0x528fea                            # 005251ee
    call FUN_0050f978                            # 005251f3
    push ecx                                     # 005251f8
    push esi                                     # 005251f9
    {load} mov esi, ecx                          # 005251fa
    push edi                                     # 005251fc
    mov dword ptr [ebp - field_minus_10], esi    # 005251fd
    mov dword ptr [esi], 0x52fb84                # 00525200
    mov ecx, dword ptr [esi + field_1044]        # 00525206
    mov dword ptr [ebp - field_minus_4], 0x1     # 0052520c
    test ecx, ecx                                # 00525213
    je.d8 L_0052521d                             # 00525215
    # block 0x00525217: entered by fall-through of je at 0x00525215, 3 instruction(s), calls indirect dword ptr [eax], falls into the block at 0x0052521d
    mov eax, dword ptr [ecx]                     # 00525217
    push 0x1                                     # 00525219
    call dword ptr [eax]                         # 0052521b
L_0052521d:
    # block 0x0052521d: entered by je at 0x00525215, 4 instruction(s), ends with je to 0x00525246 (forward)
    mov ecx, dword ptr [esi + field_106c]        # 0052521d
    lea edi, [esi + field_106c]                  # 00525223
    test ecx, ecx                                # 00525229
    je.d8 L_00525246                             # 0052522b
    # block 0x0052522d: entered by fall-through of je at 0x0052522b, 7 instruction(s), calls indirect dword ptr [eax + 0xc], ends with je to 0x00525246 (forward)
    mov eax, dword ptr [ecx]                     # 0052522d
    lea edx, [esi + field_1048]                  # 0052522f
    push edx                                     # 00525235
    call dword ptr [eax + field_c]               # 00525236
    mov ecx, dword ptr [edi]                     # 00525239
    test ecx, ecx                                # 0052523b
    je.d8 L_00525246                             # 0052523d
    # block 0x0052523f: entered by fall-through of je at 0x0052523d, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x00525246
    mov eax, dword ptr [ecx]                     # 0052523f
    push 0x1                                     # 00525241
    call dword ptr [eax + field_4]               # 00525243
L_00525246:
    # block 0x00525246: entered by je at 0x0052522b; je at 0x0052523d, 9 instruction(s), calls FUN_00525bb3, ends with ret
    and byte ptr [ebp - field_minus_4], 0x0      # 00525246
    lea ecx, [esi + field_1070]                  # 0052524a
    call FUN_00525bb3                            # 00525250
    mov ecx, dword ptr [ebp - field_minus_c]     # 00525255
    pop edi                                      # 00525258
    pop esi                                      # 00525259
    mov dword ptr fs:[0x0], ecx                  # 0052525a
    leave                                        # 00525261
    ret                                          # 00525262

