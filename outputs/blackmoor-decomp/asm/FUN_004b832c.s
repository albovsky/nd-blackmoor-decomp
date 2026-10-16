# FUN_004b832c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b832c
# extent:       0x004b832c-0x004b844d (289 code bytes)
# span:         0x004b832c-0x004b844d (code 289, tables 0, padding 0)
# sha256:       a2743220601f298aba5cece95185d5133c4fc84ac2718f6beeaed29c58efa2eb
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b832c
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_8, field_626; [ecx + n] field_45a, field_626, field_62a, field_62e; [edx + n] field_626, field_62a, field_632
# callees:      calls KERNEL32.dll!GetTickCount, FUN_00446598
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 82 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_8, 0x8  # offset +0x8
.equ field_45a, 0x45a  # offset +0x45a
.equ field_626, 0x626  # offset +0x626
.equ field_62a, 0x62a  # offset +0x62a
.equ field_62e, 0x62e  # offset +0x62e
.equ field_632, 0x632  # offset +0x632

# --- external targets -----------------------------------------------
.set FUN_00446598, .text + (0x00446598 - 0x401000)

.org 0x004b832c - 0x401000
.globl FUN_004b832c
FUN_004b832c:
    # block 0x004b832c: entry, 27 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jge to 0x004b838e (forward)
    push ebp                                     # 004b832c
    {load} mov ebp, esp                          # 004b832d
    sub esp, 0x18                                # 004b832f
    push esi                                     # 004b8332
    mov dword ptr [ebp - local_10], ecx          # 004b8333
    call dword ptr [0x52a23c]                    # 004b8336
    mov ecx, dword ptr [ebp - local_10]          # 004b833c
    sub eax, dword ptr [ecx + field_62e]         # 004b833f
    mov edx, dword ptr [ebp - local_10]          # 004b8345
    mov dword ptr [edx + field_632], eax         # 004b8348
    mov eax, dword ptr [ebp - local_10]          # 004b834e
    mov ecx, dword ptr [eax + field_8]           # 004b8351
    movsx ecx, word ptr [ecx + field_45a]        # 004b8354
    mov edx, dword ptr [ebp - local_10]          # 004b835b
    mov eax, dword ptr [edx + field_632]         # 004b835e
    {load} xor edx, edx                          # 004b8364
    mov esi, 0x3e8                               # 004b8366
    div esi                                      # 004b836b
    {load} sub ecx, eax                          # 004b836d
    mov dword ptr [ebp - local_8], ecx           # 004b836f
    mov eax, dword ptr [ebp - local_8]           # 004b8372
    cdq                                          # 004b8375
    mov ecx, 0x3c                                # 004b8376
    idiv ecx                                     # 004b837b
    mov dword ptr [ebp - local_c], eax           # 004b837d
    cmp dword ptr [ebp - local_c], 0x3b          # 004b8380
    jge.d8 L_004b838e                            # 004b8384
    # block 0x004b8386: entered by fall-through of jge at 0x004b8384, 3 instruction(s), ends with forward jump to 0x004b8395
    mov edx, dword ptr [ebp - local_c]           # 004b8386
    mov dword ptr [ebp - local_14], edx          # 004b8389
    jmp.d8 L_004b8395                            # 004b838c
L_004b838e:
    # block 0x004b838e: entered by jge at 0x004b8384, 1 instruction(s), falls into the block at 0x004b8395
    mov dword ptr [ebp - local_14], 0x3b         # 004b838e
L_004b8395:
    # block 0x004b8395: entered by jmp at 0x004b838c, 9 instruction(s), ends with jge to 0x004b83b7 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004b8395
    mov dword ptr [ebp - local_c], eax           # 004b8398
    mov ecx, dword ptr [ebp - local_c]           # 004b839b
    imul ecx, ecx, 0x3c                          # 004b839e
    mov edx, dword ptr [ebp - local_8]           # 004b83a1
    {load} sub edx, ecx                          # 004b83a4
    mov dword ptr [ebp - local_4], edx           # 004b83a6
    cmp dword ptr [ebp - local_4], 0x3b          # 004b83a9
    jge.d8 L_004b83b7                            # 004b83ad
    # block 0x004b83af: entered by fall-through of jge at 0x004b83ad, 3 instruction(s), ends with forward jump to 0x004b83be
    mov eax, dword ptr [ebp - local_4]           # 004b83af
    mov dword ptr [ebp - local_18], eax          # 004b83b2
    jmp.d8 L_004b83be                            # 004b83b5
L_004b83b7:
    # block 0x004b83b7: entered by jge at 0x004b83ad, 1 instruction(s), falls into the block at 0x004b83be
    mov dword ptr [ebp - local_18], 0x3b         # 004b83b7
L_004b83be:
    # block 0x004b83be: entered by jmp at 0x004b83b5, 6 instruction(s), ends with jne to 0x004b83e0 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004b83be
    mov dword ptr [ebp - local_4], ecx           # 004b83c1
    mov edx, dword ptr [ebp - local_10]          # 004b83c4
    mov eax, dword ptr [ebp - local_c]           # 004b83c7
    cmp eax, dword ptr [edx + field_626]         # 004b83ca
    jne.d8 L_004b83e0                            # 004b83d0
    # block 0x004b83d2: entered by fall-through of jne at 0x004b83d0, 4 instruction(s), ends with je to 0x004b8448 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004b83d2
    mov edx, dword ptr [ebp - local_4]           # 004b83d5
    cmp edx, dword ptr [ecx + field_62a]         # 004b83d8
    je.d8 L_004b8448                             # 004b83de
L_004b83e0:
    # block 0x004b83e0: entered by jne at 0x004b83d0; fall-through of je at 0x004b83de, 9 instruction(s), ends with jge to 0x004b8411 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004b83e0
    mov ecx, dword ptr [ebp - local_c]           # 004b83e3
    mov dword ptr [eax + field_626], ecx         # 004b83e6
    mov edx, dword ptr [ebp - local_10]          # 004b83ec
    mov eax, dword ptr [ebp - local_4]           # 004b83ef
    mov dword ptr [edx + field_62a], eax         # 004b83f2
    mov ecx, dword ptr [ebp - local_10]          # 004b83f8
    cmp dword ptr [ecx + field_62a], 0x0         # 004b83fb
    jge.d8 L_004b8411                            # 004b8402
    # block 0x004b8404: entered by fall-through of jge at 0x004b8402, 2 instruction(s), falls into the block at 0x004b8411
    mov edx, dword ptr [ebp - local_10]          # 004b8404
    mov dword ptr [edx + field_62a], 0x0         # 004b8407
L_004b8411:
    # block 0x004b8411: entered by jge at 0x004b8402, 3 instruction(s), ends with jge to 0x004b842a (forward)
    mov eax, dword ptr [ebp - local_10]          # 004b8411
    cmp dword ptr [eax + field_626], 0x0         # 004b8414
    jge.d8 L_004b842a                            # 004b841b
    # block 0x004b841d: entered by fall-through of jge at 0x004b841b, 2 instruction(s), falls into the block at 0x004b842a
    mov ecx, dword ptr [ebp - local_10]          # 004b841d
    mov dword ptr [ecx + field_626], 0x0         # 004b8420
L_004b842a:
    # block 0x004b842a: entered by jge at 0x004b841b, 8 instruction(s), calls FUN_00446598, falls into the block at 0x004b8448
    mov edx, dword ptr [ebp - local_10]          # 004b842a
    mov eax, dword ptr [edx + field_62a]         # 004b842d
    push eax                                     # 004b8433
    mov ecx, dword ptr [ebp - local_10]          # 004b8434
    mov edx, dword ptr [ecx + field_626]         # 004b8437
    push edx                                     # 004b843d
    mov ecx, 0x638603                            # 004b843e
    call FUN_00446598                            # 004b8443
L_004b8448:
    # block 0x004b8448: entered by je at 0x004b83de, 4 instruction(s), ends with ret
    pop esi                                      # 004b8448
    {load} mov esp, ebp                          # 004b8449
    pop ebp                                      # 004b844b
    ret                                          # 004b844c

