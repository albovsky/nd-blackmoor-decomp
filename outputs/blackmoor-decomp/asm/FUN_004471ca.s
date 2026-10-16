# FUN_004471ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004471ca
# extent:       0x004471ca-0x0044727a (176 code bytes)
# span:         0x004471ca-0x0044727a (code 176, tables 0, padding 0)
# sha256:       8b0f82614a0e63fc5a928bd26bd1711cdc038eed361aaaa96fb9d11cb3dda307
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004471ca
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004471ca - 0x401000
.globl FUN_004471ca
FUN_004471ca:
    # block 0x004471ca: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0044722e (forward)
    push ebp                                     # 004471ca
    {load} mov ebp, esp                          # 004471cb
    sub esp, 0x8                                 # 004471cd
    push esi                                     # 004471d0
    push edi                                     # 004471d1
    mov dword ptr [ebp - local_8], ecx           # 004471d2
    push 0x15                                    # 004471d5
    call FUN_0051dc43                            # 004471d7
    add esp, 0x4                                 # 004471dc
    mov dword ptr [ebp - local_4], eax           # 004471df
    mov eax, dword ptr [ebp + arg_8]             # 004471e2
    mov ecx, dword ptr [ebp - local_4]           # 004471e5
    mov dword ptr [eax], ecx                     # 004471e8
    cmp dword ptr [ebp - local_4], 0x0           # 004471ea
    jne.d8 L_0044722e                            # 004471ee
    # block 0x004471f0: entered by fall-through of jne at 0x004471ee, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0044722e
    movsx edx, word ptr [0x5c39e3]               # 004471f0
    push edx                                     # 004471f7
    mov eax, dword ptr [0x5bb57b]                # 004471f8
    push eax                                     # 004471fd
    push 0x548450                                # 004471fe
    push 0x63888b                                # 00447203
    call FUN_0050ca3e                            # 00447208
    add esp, 0x10                                # 0044720d
    push 0x63888b                                # 00447210
    push 0x54847c                                # 00447215
    mov ecx, 0x583979                            # 0044721a
    call FUN_0042639d                            # 0044721f
    mov ecx, 0x5cf659                            # 00447224
    call FUN_004c97b4                            # 00447229
L_0044722e:
    # block 0x0044722e: entered by jne at 0x004471ee, 20 instruction(s), ends with je to 0x00447272 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0044722e
    mov esi, dword ptr [ecx]                     # 00447231
    mov edx, dword ptr [ebp + arg_8]             # 00447233
    mov edi, dword ptr [edx]                     # 00447236
    mov ecx, 0x5                                 # 00447238
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044723d
    movsb byte ptr es:[edi], byte ptr [esi]      # 0044723f
    mov eax, dword ptr [ebp + arg_10]            # 00447240
    mov ecx, dword ptr [eax]                     # 00447243
    add ecx, 0x15                                # 00447245
    mov edx, dword ptr [ebp + arg_10]            # 00447248
    mov dword ptr [edx], ecx                     # 0044724b
    mov eax, dword ptr [ebp + arg_c]             # 0044724d
    mov ecx, dword ptr [eax]                     # 00447250
    add ecx, 0x15                                # 00447252
    mov edx, dword ptr [ebp + arg_c]             # 00447255
    mov dword ptr [edx], ecx                     # 00447258
    movsx eax, word ptr [0x63a4cd]               # 0044725a
    test eax, eax                                # 00447261
    je.d8 L_00447272                             # 00447263
    # block 0x00447265: entered by fall-through of je at 0x00447263, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00447272
    push 0x548498                                # 00447265
    call FUN_0044a2b7                            # 0044726a
    add esp, 0x4                                 # 0044726f
L_00447272:
    # block 0x00447272: entered by je at 0x00447263, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00447272
    pop esi                                      # 00447273
    {load} mov esp, ebp                          # 00447274
    pop ebp                                      # 00447276
    ret 0xc                                      # 00447277

