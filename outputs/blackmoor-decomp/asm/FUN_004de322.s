# FUN_004de322
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de322
# extent:       0x004de322-0x004de394 (114 code bytes)
# span:         0x004de322-0x004de394 (code 114, tables 0, padding 0)
# sha256:       8ffa86011a164c5261dc6d8791603ec2e895ddcb8121f915ec7900a837175985
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de322
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_20, local_24
# fields:       [eax + n] field_4, field_8, field_c, field_991; [ecx + n] field_991
# callees:      calls FUN_004ee644, FUN_004d57e8, FUN_004ee2a9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------
.set FUN_004d57e8, .text + (0x004d57e8 - 0x401000)
.set FUN_004ee2a9, .text + (0x004ee2a9 - 0x401000)
.set FUN_004ee644, .text + (0x004ee644 - 0x401000)

.org 0x004de322 - 0x401000
.globl FUN_004de322
FUN_004de322:
    # block 0x004de322: entry, 7 instruction(s), ends with je to 0x004de343 (forward)
    push ebp                                     # 004de322
    {load} mov ebp, esp                          # 004de323
    sub esp, 0x24                                # 004de325
    mov dword ptr [ebp - local_24], ecx          # 004de328
    mov eax, dword ptr [ebp - local_24]          # 004de32b
    cmp dword ptr [eax + field_991], 0x0         # 004de32e
    je.d8 L_004de343                             # 004de335
    # block 0x004de337: entered by fall-through of je at 0x004de335, 3 instruction(s), ends with jne to 0x004de345 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004de337
    cmp dword ptr [ecx + field_991], 0x1         # 004de33a
    jne.d8 L_004de345                            # 004de341
L_004de343:
    # block 0x004de343: entered by je at 0x004de335; fall-through of jne at 0x004de341, 1 instruction(s), ends with forward jump to 0x004de390
    jmp.d8 L_004de390                            # 004de343
L_004de345:
    # block 0x004de345: entered by jne at 0x004de341, 14 instruction(s), calls FUN_004ee644, ends with jne to 0x004de390 (forward)
    lea edx, [ebp - local_20]                    # 004de345
    push edx                                     # 004de348
    mov ecx, dword ptr [ebp - local_24]          # 004de349
    call FUN_004ee644                            # 004de34c
    mov ecx, dword ptr [eax]                     # 004de351
    mov dword ptr [ebp - local_10], ecx          # 004de353
    mov edx, dword ptr [eax + field_4]           # 004de356
    mov dword ptr [ebp - local_c], edx           # 004de359
    mov ecx, dword ptr [eax + field_8]           # 004de35c
    mov dword ptr [ebp - local_8], ecx           # 004de35f
    mov edx, dword ptr [eax + field_c]           # 004de362
    mov dword ptr [ebp - local_4], edx           # 004de365
    cmp dword ptr [0x5839a9], 0x0                # 004de368
    jne.d8 L_004de390                            # 004de36f
    # block 0x004de371: entered by fall-through of jne at 0x004de36f, 7 instruction(s), calls FUN_004d57e8, ends with je to 0x004de390 (forward)
    lea eax, [ebp - local_10]                    # 004de371
    push eax                                     # 004de374
    push 0x583102                                # 004de375
    mov ecx, 0x570450                            # 004de37a
    call FUN_004d57e8                            # 004de37f
    test eax, eax                                # 004de384
    je.d8 L_004de390                             # 004de386
    # block 0x004de388: entered by fall-through of je at 0x004de386, 2 instruction(s), calls FUN_004ee2a9, falls into the block at 0x004de390
    mov ecx, dword ptr [ebp - local_24]          # 004de388
    call FUN_004ee2a9                            # 004de38b
L_004de390:
    # block 0x004de390: entered by jmp at 0x004de343; jne at 0x004de36f; je at 0x004de386, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004de390
    pop ebp                                      # 004de392
    ret                                          # 004de393

