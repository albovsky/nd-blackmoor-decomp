# FUN_004b72cf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b72cf
# extent:       0x004b72cf-0x004b7389 (186 code bytes)
# span:         0x004b72cf-0x004b7389 (code 186, tables 0, padding 0)
# sha256:       c520faf6e6d67fb08608790f2bbdee3bdf993f936eb5782b8b0b90c1b96a9534
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b72cf
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x004b72cf - 0x401000
.globl FUN_004b72cf
FUN_004b72cf:
    # block 0x004b72cf: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004b7336 (forward)
    push ebp                                     # 004b72cf
    {load} mov ebp, esp                          # 004b72d0
    sub esp, 0x8                                 # 004b72d2
    push esi                                     # 004b72d5
    push edi                                     # 004b72d6
    mov dword ptr [ebp - local_8], ecx           # 004b72d7
    push 0x3c6                                   # 004b72da
    call FUN_0051dc43                            # 004b72df
    add esp, 0x4                                 # 004b72e4
    mov dword ptr [ebp - local_4], eax           # 004b72e7
    mov eax, dword ptr [ebp + arg_8]             # 004b72ea
    mov ecx, dword ptr [ebp - local_4]           # 004b72ed
    mov dword ptr [eax], ecx                     # 004b72f0
    cmp dword ptr [ebp - local_4], 0x0           # 004b72f2
    jne.d8 L_004b7336                            # 004b72f6
    # block 0x004b72f8: entered by fall-through of jne at 0x004b72f6, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004b7336
    movsx edx, word ptr [0x5c39e3]               # 004b72f8
    push edx                                     # 004b72ff
    mov eax, dword ptr [0x5bb57b]                # 004b7300
    push eax                                     # 004b7305
    push 0x551bd8                                # 004b7306
    push 0x63888b                                # 004b730b
    call FUN_0050ca3e                            # 004b7310
    add esp, 0x10                                # 004b7315
    push 0x63888b                                # 004b7318
    push 0x551c04                                # 004b731d
    mov ecx, 0x583979                            # 004b7322
    call FUN_0042639d                            # 004b7327
    mov ecx, 0x5cf659                            # 004b732c
    call FUN_004c97b4                            # 004b7331
L_004b7336:
    # block 0x004b7336: entered by jne at 0x004b72f6, 20 instruction(s), ends with je to 0x004b7381 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004b7336
    mov esi, dword ptr [ecx]                     # 004b7339
    mov edx, dword ptr [ebp + arg_8]             # 004b733b
    mov edi, dword ptr [edx]                     # 004b733e
    mov ecx, 0xf1                                # 004b7340
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004b7345
    movsw word ptr es:[edi], word ptr [esi]      # 004b7347
    mov eax, dword ptr [ebp + arg_10]            # 004b7349
    mov ecx, dword ptr [eax]                     # 004b734c
    add ecx, 0x3c6                               # 004b734e
    mov edx, dword ptr [ebp + arg_10]            # 004b7354
    mov dword ptr [edx], ecx                     # 004b7357
    mov eax, dword ptr [ebp + arg_c]             # 004b7359
    mov ecx, dword ptr [eax]                     # 004b735c
    add ecx, 0x3c6                               # 004b735e
    mov edx, dword ptr [ebp + arg_c]             # 004b7364
    mov dword ptr [edx], ecx                     # 004b7367
    movsx eax, word ptr [0x63a4cd]               # 004b7369
    test eax, eax                                # 004b7370
    je.d8 L_004b7381                             # 004b7372
    # block 0x004b7374: entered by fall-through of je at 0x004b7372, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004b7381
    push 0x551c20                                # 004b7374
    call FUN_0044a2b7                            # 004b7379
    add esp, 0x4                                 # 004b737e
L_004b7381:
    # block 0x004b7381: entered by je at 0x004b7372, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004b7381
    pop esi                                      # 004b7382
    {load} mov esp, ebp                          # 004b7383
    pop ebp                                      # 004b7385
    ret 0xc                                      # 004b7386

