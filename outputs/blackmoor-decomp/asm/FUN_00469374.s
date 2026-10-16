# FUN_00469374
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00469374
# extent:       0x00469374-0x00469505 (401 code bytes)
# span:         0x00469374-0x00469505 (code 401, tables 0, padding 0)
# sha256:       bb6e2e1a675eea98feb982694100a09c4442a02b5d4a30bde2dcb6f8b5bf8d80
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00469374
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_7e, field_48a, field_4fc, field_5a8; [ecx + n] field_4, field_7e, field_4fc, field_568, field_572; [edx + n] field_8, field_7e, field_56e
# callees:      calls FUN_0050ce04, FUN_004f6b74
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 91 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_7e, 0x7e  # offset +0x7e
.equ field_48a, 0x48a  # offset +0x48a
.equ field_4fc, 0x4fc  # offset +0x4fc
.equ field_568, 0x568  # offset +0x568
.equ field_56e, 0x56e  # offset +0x56e
.equ field_572, 0x572  # offset +0x572
.equ field_5a8, 0x5a8  # offset +0x5a8

# --- external targets -----------------------------------------------
.set FUN_004f6b74, .text + (0x004f6b74 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x00469374 - 0x401000
.globl FUN_00469374
FUN_00469374:
    # block 0x00469374: entry, 34 instruction(s), calls FUN_0050ce04, ends with jne to 0x004694cd (forward)
    push ebp                                     # 00469374
    {load} mov ebp, esp                          # 00469375
    sub esp, 0x10                                # 00469377
    mov dword ptr [ebp - local_c], ecx           # 0046937a
    mov ax, word ptr [ebp + arg_8]               # 0046937d
    mov word ptr [ebp - local_4], ax             # 00469381
    mov dword ptr [0x5919f8], 0x0                # 00469385
    movsx ecx, word ptr [ebp - local_4]          # 0046938f
    movsx edx, word ptr [ebp + arg_8]            # 00469393
    mov eax, dword ptr [ebp - local_c]           # 00469397
    fild dword ptr [eax + 4*edx + field_5a8]     # 0046939a
    fstp dword ptr [ebp - local_10]              # 004693a1
    fld dword ptr [ebp - local_10]               # 004693a4
    fmul dword ptr [4*ecx + 0x5919dc]            # 004693a7
    call FUN_0050ce04                            # 004693ae
    mov ecx, dword ptr [ebp - local_c]           # 004693b3
    movsx edx, word ptr [ecx + field_7e]         # 004693b6
    imul edx, edx, 0x8d                          # 004693ba
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 004693c0
    movsx edx, word ptr [0x58c94f]               # 004693c6
    imul edx, edx, 0x24                          # 004693cd
    lea ecx, [ecx + edx + field_4fc]             # 004693d0
    movsx edx, word ptr [ebp + arg_8]            # 004693d7
    imul edx, edx, 0xc                           # 004693db
    add eax, dword ptr [ecx + edx + field_4]     # 004693de
    mov dword ptr [ebp - local_8], eax           # 004693e2
    movsx eax, word ptr [ebp + arg_8]            # 004693e5
    mov ecx, dword ptr [ebp - local_c]           # 004693e9
    movsx edx, word ptr [ecx + field_7e]         # 004693ec
    imul edx, edx, 0x8d                          # 004693f0
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 004693f6
    movsx edx, word ptr [ecx + field_568]        # 004693fc
    {load} cmp eax, edx                          # 00469403
    jne.d32 L_004694cd                           # 00469405
    # block 0x0046940b: entered by fall-through of jne at 0x00469405, 9 instruction(s), ends with jl to 0x0046949b (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046940b
    movsx ecx, word ptr [eax + field_7e]         # 0046940e
    imul ecx, ecx, 0x8d                          # 00469412
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00469418
    movsx eax, word ptr [0x58c94f]               # 0046941e
    imul eax, eax, 0xc                           # 00469425
    mov ecx, dword ptr [ebp - local_8]           # 00469428
    cmp ecx, dword ptr [edx + eax + field_56e]   # 0046942b
    jl.d8 L_0046949b                             # 00469432
    # block 0x00469434: entered by fall-through of jl at 0x00469432, 9 instruction(s), ends with jg to 0x0046949b (forward)
    mov edx, dword ptr [ebp - local_c]           # 00469434
    movsx eax, word ptr [edx + field_7e]         # 00469437
    imul eax, eax, 0x8d                          # 0046943b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00469441
    movsx edx, word ptr [0x58c94f]               # 00469447
    imul edx, edx, 0xc                           # 0046944e
    mov eax, dword ptr [ebp - local_8]           # 00469451
    cmp eax, dword ptr [ecx + edx + field_572]   # 00469454
    jg.d8 L_0046949b                             # 0046945b
    # block 0x0046945d: entered by fall-through of jg at 0x0046945b, 13 instruction(s), ends with forward jump to 0x004694cd
    mov ecx, dword ptr [ebp - local_c]           # 0046945d
    movsx edx, word ptr [ecx + field_7e]         # 00469460
    imul edx, edx, 0x8d                          # 00469464
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046946a
    movsx ecx, word ptr [0x58c94f]               # 00469470
    imul ecx, ecx, 0x24                          # 00469477
    lea edx, [eax + ecx + field_4fc]             # 0046947a
    movsx eax, word ptr [ebp + arg_8]            # 00469481
    imul eax, eax, 0xc                           # 00469485
    mov ecx, dword ptr [edx + eax + field_8]     # 00469488
    mov dword ptr [ebp - local_8], ecx           # 0046948c
    mov dword ptr [0x5919f8], 0x1                # 0046948f
    jmp.d8 L_004694cd                            # 00469499
L_0046949b:
    # block 0x0046949b: entered by jl at 0x00469432; jg at 0x0046945b, 11 instruction(s), falls into the block at 0x004694cd
    mov edx, dword ptr [ebp - local_c]           # 0046949b
    movsx eax, word ptr [edx + field_7e]         # 0046949e
    imul eax, eax, 0x8d                          # 004694a2
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004694a8
    movsx edx, word ptr [0x58c94f]               # 004694ae
    imul edx, edx, 0x24                          # 004694b5
    lea eax, [ecx + edx + field_4fc]             # 004694b8
    movsx ecx, word ptr [ebp + arg_8]            # 004694bf
    imul ecx, ecx, 0xc                           # 004694c3
    mov edx, dword ptr [eax + ecx + field_4]     # 004694c6
    mov dword ptr [ebp - local_8], edx           # 004694ca
L_004694cd:
    # block 0x004694cd: entered by jne at 0x00469405; jmp at 0x00469499, 15 instruction(s), calls FUN_004f6b74, ends with ret 0x4
    mov ax, word ptr [ebp - local_8]             # 004694cd
    push eax                                     # 004694d1
    mov ecx, dword ptr [ebp - local_c]           # 004694d2
    movsx edx, word ptr [ecx + field_7e]         # 004694d5
    imul edx, edx, 0x8d                          # 004694d9
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004694df
    movsx ecx, word ptr [ebp + arg_8]            # 004694e5
    imul ecx, ecx, 0x31                          # 004694e9
    movsx edx, word ptr [eax + ecx + field_48a]  # 004694ec
    push edx                                     # 004694f4
    mov ecx, 0x5cf1eb                            # 004694f5
    call FUN_004f6b74                            # 004694fa
    {load} mov esp, ebp                          # 004694ff
    pop ebp                                      # 00469501
    ret 0x4                                      # 00469502

