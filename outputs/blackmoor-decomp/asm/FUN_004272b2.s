# FUN_004272b2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004272b2
# extent:       0x004272b2-0x004273c1 (271 code bytes)
# span:         0x004272b2-0x004273c1 (code 271, tables 0, padding 0)
# sha256:       fc10906ba5dee89d71d752a4f0495128f2912a69902b673a37f56f45bdbb264b
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004272b2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_135f5; [ecx + n] field_135f9; [edx + n] field_5c, field_60, field_64, field_68
# callees:      calls USER32.dll!PeekMessageA, FUN_00426148; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 91 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_135f5, 0x135f5  # offset +0x135f5
.equ field_135f9, 0x135f9  # offset +0x135f9

# --- external targets -----------------------------------------------
.set FUN_00426148, .text + (0x00426148 - 0x401000)

.org 0x004272b2 - 0x401000
.globl FUN_004272b2
FUN_004272b2:
    # block 0x004272b2: entry, 6 instruction(s), falls into the block at 0x004272c9
    push ebp                                     # 004272b2
    {load} mov ebp, esp                          # 004272b3
    sub esp, 0x14                                # 004272b5
    mov dword ptr [ebp - local_10], ecx          # 004272b8
    mov dword ptr [ebp - local_8], 0x1           # 004272bb
    mov dword ptr [ebp - local_4], 0x0           # 004272c2
L_004272c9:
    # block 0x004272c9: entered by jmp at 0x004273b8, 10 instruction(s), calls USER32.dll!PeekMessageA, falls into the block at 0x004272e8
    mov dword ptr [ebp - local_4], 0x0           # 004272c9
    push 0x0                                     # 004272d0
    push 0x0                                     # 004272d2
    push 0x0                                     # 004272d4
    push 0x0                                     # 004272d6
    mov eax, dword ptr [ebp - local_10]          # 004272d8
    add eax, 0x30                                # 004272db
    push eax                                     # 004272de
    call dword ptr [0x52a4c0]                    # 004272df
    mov dword ptr [ebp - local_c], eax           # 004272e5
L_004272e8:
    # block 0x004272e8: entered by jmp at 0x00427352, 2 instruction(s), ends with jne to 0x00427354 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004272e8
    jne.d8 L_00427354                            # 004272ec
    # block 0x004272ee: entered by fall-through of jne at 0x004272ec, 2 instruction(s), ends with je to 0x0042731d (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004272ee
    je.d8 L_0042731d                             # 004272f2
    # block 0x004272f4: entered by fall-through of je at 0x004272f2, 13 instruction(s), calls indirect dword ptr [edx + 0x60], ends with jne to 0x0042731d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004272f4
    mov dword ptr [ebp - local_14], ecx          # 004272f7
    mov edx, dword ptr [ebp - local_14]          # 004272fa
    push edx                                     # 004272fd
    mov eax, dword ptr [ebp - local_4]           # 004272fe
    add eax, 0x1                                 # 00427301
    mov dword ptr [ebp - local_4], eax           # 00427304
    mov ecx, dword ptr [ebp - local_10]          # 00427307
    mov edx, dword ptr [ecx]                     # 0042730a
    mov ecx, dword ptr [ebp - local_10]          # 0042730c
    call dword ptr [edx + field_60]              # 0042730f
    test eax, eax                                # 00427312
    jne.d8 L_0042731d                            # 00427314
    # block 0x00427316: entered by fall-through of jne at 0x00427314, 1 instruction(s), falls into the block at 0x0042731d
    mov dword ptr [ebp - local_8], 0x0           # 00427316
L_0042731d:
    # block 0x0042731d: entered by je at 0x004272f2; jne at 0x00427314, 3 instruction(s), ends with jne to 0x0042733a (forward)
    mov eax, dword ptr [ebp - local_10]          # 0042731d
    cmp dword ptr [eax + field_135f5], 0x1       # 00427320
    jne.d8 L_0042733a                            # 00427327
    # block 0x00427329: entered by fall-through of jne at 0x00427327, 3 instruction(s), ends with je to 0x0042733a (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00427329
    cmp dword ptr [ecx + field_135f9], 0x0       # 0042732c
    je.d8 L_0042733a                             # 00427333
    # block 0x00427335: entered by fall-through of je at 0x00427333, 1 instruction(s), calls FUN_00426148, falls into the block at 0x0042733a
    call FUN_00426148                            # 00427335
L_0042733a:
    # block 0x0042733a: entered by jne at 0x00427327; je at 0x00427333, 10 instruction(s), calls USER32.dll!PeekMessageA, ends with backward jump to 0x004272e8
    push 0x0                                     # 0042733a
    push 0x0                                     # 0042733c
    push 0x0                                     # 0042733e
    push 0x0                                     # 00427340
    mov edx, dword ptr [ebp - local_10]          # 00427342
    add edx, 0x30                                # 00427345
    push edx                                     # 00427348
    call dword ptr [0x52a4c0]                    # 00427349
    mov dword ptr [ebp - local_c], eax           # 0042734f
    jmp.d8 L_004272e8                            # 00427352
L_00427354:
    # block 0x00427354: entered by jne at 0x004272ec; je at 0x0042739d; jne at 0x004273b6, 6 instruction(s), calls indirect dword ptr [edx + 0x5c], ends with jne to 0x00427370 (forward)
    mov eax, dword ptr [ebp - local_10]          # 00427354
    mov edx, dword ptr [eax]                     # 00427357
    mov ecx, dword ptr [ebp - local_10]          # 00427359
    call dword ptr [edx + field_5c]              # 0042735c
    test eax, eax                                # 0042735f
    jne.d8 L_00427370                            # 00427361
    # block 0x00427363: entered by fall-through of jne at 0x00427361, 5 instruction(s), calls indirect dword ptr [edx + 0x68], ends with forward jump to 0x004273bd
    mov eax, dword ptr [ebp - local_10]          # 00427363
    mov edx, dword ptr [eax]                     # 00427366
    mov ecx, dword ptr [ebp - local_10]          # 00427368
    call dword ptr [edx + field_68]              # 0042736b
    jmp.d8 L_004273bd                            # 0042736e
L_00427370:
    # block 0x00427370: entered by jne at 0x00427361, 2 instruction(s), ends with jne to 0x00427393 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 00427370
    jne.d8 L_00427393                            # 00427374
    # block 0x00427376: entered by fall-through of jne at 0x00427374, 9 instruction(s), calls indirect dword ptr [edx + 0x64], ends with je to 0x00427393 (forward)
    mov eax, dword ptr [ebp - local_10]          # 00427376
    add eax, 0x30                                # 00427379
    push eax                                     # 0042737c
    mov ecx, dword ptr [ebp - local_10]          # 0042737d
    mov edx, dword ptr [ecx]                     # 00427380
    mov ecx, dword ptr [ebp - local_10]          # 00427382
    call dword ptr [edx + field_64]              # 00427385
    test eax, eax                                # 00427388
    je.d8 L_00427393                             # 0042738a
    # block 0x0042738c: entered by fall-through of je at 0x0042738a, 1 instruction(s), falls into the block at 0x00427393
    mov dword ptr [ebp - local_8], 0x1           # 0042738c
L_00427393:
    # block 0x00427393: entered by jne at 0x00427374; je at 0x0042738a, 3 instruction(s), ends with je to 0x00427354 (backward)
    mov eax, dword ptr [ebp - local_10]          # 00427393
    cmp dword ptr [eax + field_135f5], 0x2       # 00427396
    je.d8 L_00427354                             # 0042739d
    # block 0x0042739f: entered by fall-through of je at 0x0042739d, 10 instruction(s), calls USER32.dll!PeekMessageA, ends with jne to 0x00427354 (backward)
    push 0x0                                     # 0042739f
    push 0x0                                     # 004273a1
    push 0x0                                     # 004273a3
    push 0x0                                     # 004273a5
    mov ecx, dword ptr [ebp - local_10]          # 004273a7
    add ecx, 0x30                                # 004273aa
    push ecx                                     # 004273ad
    call dword ptr [0x52a4c0]                    # 004273ae
    test eax, eax                                # 004273b4
    jne.d8 L_00427354                            # 004273b6
    # block 0x004273b8: entered by fall-through of jne at 0x004273b6, 1 instruction(s), ends with backward jump to 0x004272c9
    jmp.d32 L_004272c9                           # 004273b8
L_004273bd:
    # block 0x004273bd: entered by jmp at 0x0042736e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004273bd
    pop ebp                                      # 004273bf
    ret                                          # 004273c0

