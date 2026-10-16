# FUN_005227c6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005227c6
# extent:       0x005227c6-0x00522888 (194 code bytes)
# span:         0x005227c6-0x00522888 (code 194, tables 0, padding 0)
# sha256:       6fc633f929872b0f9f04bb81de20c370e186f85fb77086931f04611b470fe9ac
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005227c6
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_3c, field_40, field_44, field_48, field_4c, field_50, field_54, field_58, field_68, field_6c, field_88, field_8c and 11 more
# callees:      calls FUN_0050f978, FUN_0051a7c3, FUN_0051a28e, USER32.dll!SetRectEmpty, FUN_0052290b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_9c, 0x9c  # offset +0x9c
.equ field_a0, 0xa0  # offset +0xa0
.equ field_a4, 0xa4  # offset +0xa4
.equ field_a8, 0xa8  # offset +0xa8
.equ field_ac, 0xac  # offset +0xac
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b4, 0xb4  # offset +0xb4
.equ field_b8, 0xb8  # offset +0xb8

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a28e, .text + (0x0051a28e - 0x401000)
.set FUN_0051a7c3, .text + (0x0051a7c3 - 0x401000)
.set FUN_0052290b, .text + (0x0052290b - 0x401000)

.org 0x005227c6 - 0x401000
.globl FUN_005227c6
FUN_005227c6:
    # block 0x005227c6: entry, 49 instruction(s), calls FUN_0050f978, FUN_0051a7c3, FUN_0051a28e, USER32.dll!SetRectEmpty, FUN_0052290b, ends with ret
    mov eax, 0x528f05                            # 005227c6
    call FUN_0050f978                            # 005227cb
    push ecx                                     # 005227d0
    push esi                                     # 005227d1
    {load} mov esi, ecx                          # 005227d2
    push edi                                     # 005227d4
    mov dword ptr [ebp - field_minus_10], esi    # 005227d5
    call FUN_0051a7c3                            # 005227d8
    {load} xor edi, edi                          # 005227dd
    push 0xa                                     # 005227df
    lea ecx, [esi + field_6c]                    # 005227e1
    mov dword ptr [ebp - field_minus_4], edi     # 005227e4
    call FUN_0051a28e                            # 005227e7
    mov eax, dword ptr [0x5679b0]                # 005227ec
    mov dword ptr [esi + field_ac], eax          # 005227f1
    or dword ptr [esi + field_40], -0x1          # 005227f7
    lea eax, [esi + field_58]                    # 005227fb
    push eax                                     # 005227fe
    mov byte ptr [ebp - field_minus_4], 0x2      # 005227ff
    mov dword ptr [esi], 0x52fa5c                # 00522803
    mov dword ptr [esi + field_3c], 0x1          # 00522809
    mov dword ptr [esi + field_9c], edi          # 00522810
    mov dword ptr [esi + field_44], edi          # 00522816
    mov dword ptr [esi + field_48], edi          # 00522819
    mov dword ptr [esi + field_8c], edi          # 0052281c
    mov dword ptr [esi + field_90], edi          # 00522822
    mov dword ptr [esi + field_94], edi          # 00522828
    mov dword ptr [esi + field_98], edi          # 0052282e
    mov dword ptr [esi + field_a0], edi          # 00522834
    mov dword ptr [esi + field_a4], edi          # 0052283a
    mov dword ptr [esi + field_68], edi          # 00522840
    mov dword ptr [esi + field_a8], edi          # 00522843
    mov dword ptr [esi + field_b8], edi          # 00522849
    call dword ptr [0x52a374]                    # 0052284f
    or dword ptr [esi + field_88], -0x1          # 00522855
    {load} mov ecx, esi                          # 0052285c
    mov dword ptr [esi + field_50], edi          # 0052285e
    mov dword ptr [esi + field_4c], edi          # 00522861
    mov dword ptr [esi + field_54], edi          # 00522864
    mov dword ptr [esi + field_b0], edi          # 00522867
    mov dword ptr [esi + field_b4], edi          # 0052286d
    call FUN_0052290b                            # 00522873
    mov ecx, dword ptr [ebp - field_minus_c]     # 00522878
    {load} mov eax, esi                          # 0052287b
    pop edi                                      # 0052287d
    pop esi                                      # 0052287e
    mov dword ptr fs:[0x0], ecx                  # 0052287f
    leave                                        # 00522886
    ret                                          # 00522887

