# FUN_004853b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004853b0
# extent:       0x004853b0-0x004854fb (331 code bytes)
# span:         0x004853b0-0x004854fb (code 331, tables 0, padding 0)
# sha256:       e0c5f1405c21fb9884ddb1c5e578ecea09bcea61b8e2f3a2348b982815d27ed3
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         rotate_piece
# naming:       native port src/action_family_ea_runtime.c:rotate_piece (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with rotate_piece (orientation wrap, centre, clamp). Aggregate-state oracle: all effects land in the compared object image.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_2, field_6, field_c, field_14, field_16, field_22, field_a9a; [ecx + n] field_2, field_4, field_6, field_8, field_a, field_c, field_10, field_24, field_28; [edx + n] field_4, field_6, field_8, field_c, field_e, field_14, field_16, field_22, field_24
# callees:      calls FUN_00484caf, FUN_004841cb
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.c:rotate_piece (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 113 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_a9a, 0xa9a  # offset +0xa9a

# --- external targets -----------------------------------------------
.set FUN_004841cb, .text + (0x004841cb - 0x401000)
.set FUN_00484caf, .text + (0x00484caf - 0x401000)

.org 0x004853b0 - 0x401000
.globl FUN_004853b0
FUN_004853b0:
    # block 0x004853b0: entry, 58 instruction(s), ends with jne to 0x00485467 (forward)
    push ebp                                     # 004853b0
    {load} mov ebp, esp                          # 004853b1
    sub esp, 0x14                                # 004853b3
    mov dword ptr [ebp - local_14], ecx          # 004853b6
    movsx eax, word ptr [ebp + arg_8]            # 004853b9
    imul eax, eax, 0x85                          # 004853bd
    mov ecx, dword ptr [ebp - local_14]          # 004853c3
    lea edx, [ecx + eax + field_28]              # 004853c6
    mov dword ptr [ebp - local_10], edx          # 004853ca
    mov eax, dword ptr [ebp - local_14]          # 004853cd
    mov dword ptr [eax + field_a9a], 0x1         # 004853d0
    mov ecx, dword ptr [ebp - local_10]          # 004853da
    add ecx, 0x2                                 # 004853dd
    mov edx, dword ptr [ebp - local_14]          # 004853e0
    add edx, 0xae0                               # 004853e3
    mov eax, dword ptr [ecx]                     # 004853e9
    mov dword ptr [edx], eax                     # 004853eb
    mov eax, dword ptr [ecx + field_4]           # 004853ed
    mov dword ptr [edx + field_4], eax           # 004853f0
    mov eax, dword ptr [ecx + field_8]           # 004853f3
    mov dword ptr [edx + field_8], eax           # 004853f6
    mov ecx, dword ptr [ecx + field_c]           # 004853f9
    mov dword ptr [edx + field_c], ecx           # 004853fc
    mov edx, dword ptr [ebp - local_10]          # 004853ff
    {load} xor eax, eax                          # 00485402
    mov al, byte ptr [edx + field_22]            # 00485404
    imul eax, eax, 0x18                          # 00485407
    mov ecx, dword ptr [ebp - local_10]          # 0048540a
    lea edx, [ecx + eax + field_24]              # 0048540d
    mov dword ptr [ebp - local_8], edx           # 00485411
    mov eax, dword ptr [ebp - local_8]           # 00485414
    movsx eax, word ptr [eax + field_14]         # 00485417
    cdq                                          # 0048541b
    {load} sub eax, edx                          # 0048541c
    sar eax                                      # 0048541e
    mov ecx, dword ptr [ebp - local_10]          # 00485420
    mov edx, dword ptr [ecx + field_2]           # 00485423
    {load} add edx, eax                          # 00485426
    mov word ptr [ebp - local_c], dx             # 00485428
    mov eax, dword ptr [ebp - local_8]           # 0048542c
    movsx eax, word ptr [eax + field_16]         # 0048542f
    cdq                                          # 00485433
    {load} sub eax, edx                          # 00485434
    sar eax                                      # 00485436
    mov ecx, dword ptr [ebp - local_10]          # 00485438
    mov edx, dword ptr [ecx + field_6]           # 0048543b
    {load} add edx, eax                          # 0048543e
    mov word ptr [ebp - local_4], dx             # 00485440
    mov eax, dword ptr [ebp - local_10]          # 00485444
    mov cl, byte ptr [eax + field_22]            # 00485447
    add cl, 0x1                                  # 0048544a
    mov edx, dword ptr [ebp - local_10]          # 0048544d
    mov byte ptr [edx + field_22], cl            # 00485450
    mov eax, dword ptr [ebp - local_10]          # 00485453
    {load} xor ecx, ecx                          # 00485456
    mov cl, byte ptr [eax + field_22]            # 00485458
    cmp ecx, 0x4                                 # 0048545b
    jne.d8 L_00485467                            # 0048545e
    # block 0x00485460: entered by fall-through of jne at 0x0048545e, 2 instruction(s), falls into the block at 0x00485467
    mov edx, dword ptr [ebp - local_10]          # 00485460
    mov byte ptr [edx + field_22], 0x0           # 00485463
L_00485467:
    # block 0x00485467: entered by jne at 0x0048545e, 53 instruction(s), calls FUN_00484caf, FUN_004841cb, ends with ret 0x4
    mov eax, dword ptr [ebp - local_10]          # 00485467
    {load} xor ecx, ecx                          # 0048546a
    mov cl, byte ptr [eax + field_22]            # 0048546c
    imul ecx, ecx, 0x18                          # 0048546f
    mov edx, dword ptr [ebp - local_10]          # 00485472
    lea eax, [edx + ecx + field_24]              # 00485475
    mov dword ptr [ebp - local_8], eax           # 00485479
    movsx ecx, word ptr [ebp - local_c]          # 0048547c
    mov edx, dword ptr [ebp - local_8]           # 00485480
    movsx eax, word ptr [edx + field_14]         # 00485483
    cdq                                          # 00485487
    {load} sub eax, edx                          # 00485488
    sar eax                                      # 0048548a
    {load} sub ecx, eax                          # 0048548c
    mov eax, dword ptr [ebp - local_10]          # 0048548e
    mov dword ptr [eax + field_2], ecx           # 00485491
    movsx ecx, word ptr [ebp - local_4]          # 00485494
    mov edx, dword ptr [ebp - local_8]           # 00485498
    movsx eax, word ptr [edx + field_16]         # 0048549b
    cdq                                          # 0048549f
    {load} sub eax, edx                          # 004854a0
    sar eax                                      # 004854a2
    {load} sub ecx, eax                          # 004854a4
    mov eax, dword ptr [ebp - local_10]          # 004854a6
    mov dword ptr [eax + field_6], ecx           # 004854a9
    mov ecx, dword ptr [ebp - local_10]          # 004854ac
    mov edx, dword ptr [ecx + field_2]           # 004854af
    mov eax, dword ptr [ebp - local_8]           # 004854b2
    add edx, dword ptr [eax + field_c]           # 004854b5
    mov ecx, dword ptr [ebp - local_10]          # 004854b8
    mov dword ptr [ecx + field_a], edx           # 004854bb
    mov edx, dword ptr [ebp - local_10]          # 004854be
    mov eax, dword ptr [edx + field_6]           # 004854c1
    mov ecx, dword ptr [ebp - local_8]           # 004854c4
    add eax, dword ptr [ecx + field_10]          # 004854c7
    mov edx, dword ptr [ebp - local_10]          # 004854ca
    mov dword ptr [edx + field_e], eax           # 004854cd
    mov eax, dword ptr [ebp - local_10]          # 004854d0
    add eax, 0x2                                 # 004854d3
    push eax                                     # 004854d6
    mov ecx, dword ptr [ebp - local_14]          # 004854d7
    call FUN_00484caf                            # 004854da
    mov ecx, dword ptr [ebp - local_10]          # 004854df
    add ecx, 0x12                                # 004854e2
    push ecx                                     # 004854e5
    mov edx, dword ptr [ebp - local_10]          # 004854e6
    add edx, 0x2                                 # 004854e9
    push edx                                     # 004854ec
    mov ecx, dword ptr [ebp - local_14]          # 004854ed
    call FUN_004841cb                            # 004854f0
    {load} mov esp, ebp                          # 004854f5
    pop ebp                                      # 004854f7
    ret 0x4                                      # 004854f8

