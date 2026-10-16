# FUN_004145d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004145d0
# extent:       0x004145d0-0x00414692 (194 code bytes)
# span:         0x004145d0-0x00414692 (code 194, tables 0, padding 0)
# sha256:       ba453a3a15f52595096d9bb222a65e2f716beea739240bca8d19e612e903320c
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004145d0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_2, field_1c, field_1e; [ecx + n] field_2, field_1c; [edx + n] field_1c, field_1e
# callees:      calls FUN_0051dc6c, FUN_004145a7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 55 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e

# --- external targets -----------------------------------------------
.set FUN_004145a7, .text + (0x004145a7 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004145d0 - 0x401000
.globl FUN_004145d0
FUN_004145d0:
    # block 0x004145d0: entry, 13 instruction(s), ends with je to 0x00414620 (forward)
    push ebp                                     # 004145d0
    {load} mov ebp, esp                          # 004145d1
    sub esp, 0x10                                # 004145d3
    mov dword ptr [ebp - local_10], ecx          # 004145d6
    movsx eax, word ptr [ebp + arg_8]            # 004145d9
    imul eax, eax, 0x8d                          # 004145dd
    mov ecx, dword ptr [ebp - local_10]          # 004145e3
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004145e6
    mov dword ptr [ecx + field_1c], edx          # 004145ec
    mov eax, dword ptr [ebp - local_10]          # 004145ef
    mov ecx, dword ptr [eax + field_1c]          # 004145f2
    cmp dword ptr [ecx + field_2], 0x0           # 004145f5
    je.d8 L_00414620                             # 004145f9
    # block 0x004145fb: entered by fall-through of je at 0x004145f9, 11 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00414620
    mov edx, dword ptr [ebp - local_10]          # 004145fb
    mov eax, dword ptr [edx + field_1c]          # 004145fe
    mov ecx, dword ptr [eax + field_2]           # 00414601
    mov dword ptr [ebp - local_4], ecx           # 00414604
    mov edx, dword ptr [ebp - local_4]           # 00414607
    push edx                                     # 0041460a
    call FUN_0051dc6c                            # 0041460b
    add esp, 0x4                                 # 00414610
    mov eax, dword ptr [ebp - local_10]          # 00414613
    mov ecx, dword ptr [eax + field_1c]          # 00414616
    mov dword ptr [ecx + field_2], 0x0           # 00414619
L_00414620:
    # block 0x00414620: entered by je at 0x004145f9, 4 instruction(s), ends with je to 0x00414651 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00414620
    mov eax, dword ptr [edx + field_1c]          # 00414623
    cmp dword ptr [eax + field_1e], 0x0          # 00414626
    je.d8 L_00414651                             # 0041462a
    # block 0x0041462c: entered by fall-through of je at 0x0041462a, 11 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00414651
    mov ecx, dword ptr [ebp - local_10]          # 0041462c
    mov edx, dword ptr [ecx + field_1c]          # 0041462f
    mov eax, dword ptr [edx + field_1e]          # 00414632
    mov dword ptr [ebp - local_8], eax           # 00414635
    mov ecx, dword ptr [ebp - local_8]           # 00414638
    push ecx                                     # 0041463b
    call FUN_0051dc6c                            # 0041463c
    add esp, 0x4                                 # 00414641
    mov edx, dword ptr [ebp - local_10]          # 00414644
    mov eax, dword ptr [edx + field_1c]          # 00414647
    mov dword ptr [eax + field_1e], 0x0          # 0041464a
L_00414651:
    # block 0x00414651: entered by je at 0x0041462a, 16 instruction(s), calls FUN_0051dc6c, FUN_004145a7, ends with ret 0x4
    movsx ecx, word ptr [ebp + arg_8]            # 00414651
    imul ecx, ecx, 0x8d                          # 00414655
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0041465b
    mov dword ptr [ebp - local_c], edx           # 00414661
    mov eax, dword ptr [ebp - local_c]           # 00414664
    push eax                                     # 00414667
    call FUN_0051dc6c                            # 00414668
    add esp, 0x4                                 # 0041466d
    movsx ecx, word ptr [ebp + arg_8]            # 00414670
    imul ecx, ecx, 0x8d                          # 00414674
    mov dword ptr [ecx + 0x5bb5e5], 0x0          # 0041467a
    mov ecx, dword ptr [ebp - local_10]          # 00414684
    call FUN_004145a7                            # 00414687
    {load} mov esp, ebp                          # 0041468c
    pop ebp                                      # 0041468e
    ret 0x4                                      # 0041468f

