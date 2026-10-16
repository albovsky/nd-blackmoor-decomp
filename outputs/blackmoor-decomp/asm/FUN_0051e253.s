# FUN_0051e253
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e253
# extent:       0x0051e253-0x0051e2a0 (77 code bytes)
# span:         0x0051e253-0x0051e2a0 (code 77, tables 0, padding 0)
# sha256:       1007a673eea7c7eee1901bb5d24501e5126ae6dcbe1ce2f1a883151c5b41ee41
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e253
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_58; [ebp + n] field_minus_4, field_minus_c, field_minus_14, field_minus_20; [esi + n] field_1c, field_2c
# callees:      calls USER32.dll!EnableWindow, USER32.dll!GetActiveWindow, USER32.dll!SetActiveWindow, FUN_0051e0fe; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_20, 0x20  # offset -0x20
.equ field_1c, 0x1c  # offset +0x1c
.equ field_2c, 0x2c  # offset +0x2c
.equ field_58, 0x58  # offset +0x58

# --- external targets -----------------------------------------------
.set FUN_0051e0fe, .text + (0x0051e0fe - 0x401000)

.org 0x0051e253 - 0x401000
.globl FUN_0051e253
FUN_0051e253:
    # block 0x0051e253: entry, 3 instruction(s), ends with je to 0x0051e267 (forward)
    or dword ptr [ebp - field_minus_4], -0x1     # 0051e253
    cmp dword ptr [ebp - field_minus_20], edi    # 0051e257
    je.d8 L_0051e267                             # 0051e25a
    # block 0x0051e25c: entered by fall-through of je at 0x0051e25a, 3 instruction(s), calls USER32.dll!EnableWindow, falls into the block at 0x0051e267
    push 0x1                                     # 0051e25c
    push dword ptr [ebp - field_minus_14]        # 0051e25e
    call dword ptr [0x52a4d0]                    # 0051e261
L_0051e267:
    # block 0x0051e267: entered by je at 0x0051e25a, 2 instruction(s), ends with je to 0x0051e280 (forward)
    cmp dword ptr [ebp - field_minus_14], edi    # 0051e267
    je.d8 L_0051e280                             # 0051e26a
    # block 0x0051e26c: entered by fall-through of je at 0x0051e26a, 3 instruction(s), calls USER32.dll!GetActiveWindow, ends with jne to 0x0051e280 (forward)
    call dword ptr [0x52a354]                    # 0051e26c
    cmp eax, dword ptr [esi + field_1c]          # 0051e272
    jne.d8 L_0051e280                            # 0051e275
    # block 0x0051e277: entered by fall-through of jne at 0x0051e275, 2 instruction(s), calls USER32.dll!SetActiveWindow, falls into the block at 0x0051e280
    push dword ptr [ebp - field_minus_14]        # 0051e277
    call dword ptr [0x52a304]                    # 0051e27a
L_0051e280:
    # block 0x0051e280: entered by je at 0x0051e26a; jne at 0x0051e275, 13 instruction(s), calls indirect dword ptr [eax + 0x58], FUN_0051e0fe, ends with ret
    mov eax, dword ptr [esi]                     # 0051e280
    {load} mov ecx, esi                          # 0051e282
    call dword ptr [eax + field_58]              # 0051e284
    {load} mov ecx, esi                          # 0051e287
    call FUN_0051e0fe                            # 0051e289
    mov eax, dword ptr [esi + field_2c]          # 0051e28e
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051e291
    pop edi                                      # 0051e294
    pop esi                                      # 0051e295
    mov dword ptr fs:[0x0], ecx                  # 0051e296
    pop ebx                                      # 0051e29d
    leave                                        # 0051e29e
    ret                                          # 0051e29f

