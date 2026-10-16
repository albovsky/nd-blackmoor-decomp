# FUN_004205c1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004205c1
# extent:       0x004205c1-0x00420737 (374 code bytes)
# span:         0x004205c1-0x00420737 (code 374, tables 0, padding 0)
# sha256:       f9f9d1981494a2a4f8a4b7dc665a723f3a642728e0f601b8df2ce9fd1b7c1044
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004205c1
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1b7, field_77a, field_795, field_f23; [ecx + n] field_2, field_779, field_77a, field_793; [edx + n] field_779, field_795, field_f4b
# callees:      calls FUN_00420737, FUN_0041fa11, FUN_0041fd08, FUN_0042028e; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:phase0 (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 101 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
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
.equ field_1b7, 0x1b7  # offset +0x1b7
.equ field_779, 0x779  # offset +0x779
.equ field_77a, 0x77a  # offset +0x77a
.equ field_793, 0x793  # offset +0x793
.equ field_795, 0x795  # offset +0x795
.equ field_f23, 0xf23  # offset +0xf23
.equ field_f4b, 0xf4b  # offset +0xf4b

# --- external targets -----------------------------------------------
.set FUN_0041fa11, .text + (0x0041fa11 - 0x401000)
.set FUN_0041fd08, .text + (0x0041fd08 - 0x401000)
.set FUN_0042028e, .text + (0x0042028e - 0x401000)
.set FUN_00420737, .text + (0x00420737 - 0x401000)

.org 0x004205c1 - 0x401000
.globl FUN_004205c1
FUN_004205c1:
    # block 0x004205c1: entry, 10 instruction(s), ends with forward jump to 0x004205f1
    push ebp                                     # 004205c1
    {load} mov ebp, esp                          # 004205c2
    sub esp, 0x10                                # 004205c4
    mov dword ptr [ebp - local_c], ecx           # 004205c7
    movsx eax, word ptr [ebp + arg_8]            # 004205ca
    imul eax, eax, 0x8d                          # 004205ce
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004205d4
    mov dword ptr [ebp - local_8], ecx           # 004205da
    mov word ptr [ebp - local_4], 0x0            # 004205dd
    jmp.d8 L_004205f1                            # 004205e3
L_004205e5:
    # block 0x004205e5: entered by jmp at 0x004206e2, 3 instruction(s), falls into the block at 0x004205f1
    mov dx, word ptr [ebp - local_4]             # 004205e5
    add dx, 0x1                                  # 004205e9
    mov word ptr [ebp - local_4], dx             # 004205ed
L_004205f1:
    # block 0x004205f1: entered by jmp at 0x004205e3, 5 instruction(s), ends with jge to 0x004206e7 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004205f1
    mov ecx, dword ptr [ebp - local_8]           # 004205f5
    movsx edx, word ptr [ecx + field_793]        # 004205f8
    {load} cmp eax, edx                          # 004205ff
    jge.d32 L_004206e7                           # 00420601
    # block 0x00420607: entered by fall-through of jge at 0x00420601, 20 instruction(s), calls FUN_00420737, ends with je to 0x004206e2 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00420607
    add eax, 0x78e                               # 0042060a
    push eax                                     # 0042060f
    movsx ecx, word ptr [ebp - local_4]          # 00420610
    imul ecx, ecx, 0x1d1                         # 00420614
    mov edx, dword ptr [ebp - local_8]           # 0042061a
    mov eax, dword ptr [edx + field_795]         # 0042061d
    mov cx, word ptr [eax + ecx]                 # 00420623
    push ecx                                     # 00420627
    movsx edx, word ptr [ebp - local_4]          # 00420628
    imul edx, edx, 0x1d1                         # 0042062c
    mov eax, dword ptr [ebp - local_8]           # 00420632
    mov ecx, dword ptr [eax + field_795]         # 00420635
    mov edx, dword ptr [ecx + edx + field_2]     # 0042063b
    push edx                                     # 0042063f
    mov ecx, dword ptr [ebp - local_c]           # 00420640
    call FUN_00420737                            # 00420643
    movsx eax, ax                                # 00420648
    test eax, eax                                # 0042064b
    je.d32 L_004206e2                            # 0042064d
    # block 0x00420653: entered by fall-through of je at 0x0042064d, 8 instruction(s), ends with je to 0x00420684 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00420653
    imul ecx, ecx, 0x1d1                         # 00420657
    mov edx, dword ptr [ebp - local_8]           # 0042065d
    mov eax, dword ptr [edx + field_795]         # 00420660
    mov cl, byte ptr [eax + ecx + field_1b7]     # 00420666
    mov byte ptr [ebp - local_10], cl            # 0042066d
    cmp byte ptr [ebp - local_10], 0x0           # 00420670
    je.d8 L_00420684                             # 00420674
    # block 0x00420676: entered by fall-through of je at 0x00420674, 2 instruction(s), ends with je to 0x004206a4 (forward)
    cmp byte ptr [ebp - local_10], 0x1           # 00420676
    je.d8 L_004206a4                             # 0042067a
    # block 0x0042067c: entered by fall-through of je at 0x0042067a, 2 instruction(s), ends with je to 0x004206c4 (forward)
    cmp byte ptr [ebp - local_10], 0x2           # 0042067c
    je.d8 L_004206c4                             # 00420680
    # block 0x00420682: entered by fall-through of je at 0x00420680, 1 instruction(s), ends with forward jump to 0x004206e2
    jmp.d8 L_004206e2                            # 00420682
L_00420684:
    # block 0x00420684: entered by je at 0x00420674, 9 instruction(s), calls FUN_0041fa11, ends with forward jump to 0x004206e2
    movsx edx, word ptr [ebp - local_4]          # 00420684
    imul edx, edx, 0x1d1                         # 00420688
    mov eax, dword ptr [ebp - local_8]           # 0042068e
    mov ecx, dword ptr [eax + field_795]         # 00420691
    {load} add ecx, edx                          # 00420697
    push ecx                                     # 00420699
    mov ecx, dword ptr [ebp - local_c]           # 0042069a
    call FUN_0041fa11                            # 0042069d
    jmp.d8 L_004206e2                            # 004206a2
L_004206a4:
    # block 0x004206a4: entered by je at 0x0042067a, 9 instruction(s), calls FUN_0041fd08, ends with forward jump to 0x004206e2
    movsx edx, word ptr [ebp - local_4]          # 004206a4
    imul edx, edx, 0x1d1                         # 004206a8
    mov eax, dword ptr [ebp - local_8]           # 004206ae
    mov ecx, dword ptr [eax + field_795]         # 004206b1
    {load} add ecx, edx                          # 004206b7
    push ecx                                     # 004206b9
    mov ecx, dword ptr [ebp - local_c]           # 004206ba
    call FUN_0041fd08                            # 004206bd
    jmp.d8 L_004206e2                            # 004206c2
L_004206c4:
    # block 0x004206c4: entered by je at 0x00420680, 8 instruction(s), calls FUN_0042028e, falls into the block at 0x004206e2
    movsx edx, word ptr [ebp - local_4]          # 004206c4
    imul edx, edx, 0x1d1                         # 004206c8
    mov eax, dword ptr [ebp - local_8]           # 004206ce
    mov ecx, dword ptr [eax + field_795]         # 004206d1
    {load} add ecx, edx                          # 004206d7
    push ecx                                     # 004206d9
    mov ecx, dword ptr [ebp - local_c]           # 004206da
    call FUN_0042028e                            # 004206dd
L_004206e2:
    # block 0x004206e2: entered by je at 0x0042064d; jmp at 0x00420682; jmp at 0x004206a2; jmp at 0x004206c2, 1 instruction(s), ends with backward jump to 0x004205e5
    jmp.d32 L_004205e5                           # 004206e2
L_004206e7:
    # block 0x004206e7: entered by jge at 0x00420601, 5 instruction(s), ends with je to 0x0042070c (forward)
    mov edx, dword ptr [ebp - local_8]           # 004206e7
    {load} xor eax, eax                          # 004206ea
    mov al, byte ptr [edx + field_779]           # 004206ec
    cmp eax, 0x14                                # 004206f2
    je.d8 L_0042070c                             # 004206f5
    # block 0x004206f7: entered by fall-through of je at 0x004206f5, 5 instruction(s), calls indirect dword ptr [eax + 4*edx + 0xf23], falls into the block at 0x0042070c
    mov ecx, dword ptr [ebp - local_8]           # 004206f7
    {load} xor edx, edx                          # 004206fa
    mov dl, byte ptr [ecx + field_779]           # 004206fc
    mov eax, dword ptr [ebp - local_c]           # 00420702
    call dword ptr [eax + 4*edx + field_f23]     # 00420705
L_0042070c:
    # block 0x0042070c: entered by je at 0x004206f5, 5 instruction(s), ends with je to 0x00420731 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0042070c
    {load} xor edx, edx                          # 0042070f
    mov dl, byte ptr [ecx + field_77a]           # 00420711
    cmp edx, 0x14                                # 00420717
    je.d8 L_00420731                             # 0042071a
    # block 0x0042071c: entered by fall-through of je at 0x0042071a, 5 instruction(s), calls indirect dword ptr [edx + 4*ecx + 0xf4b], falls into the block at 0x00420731
    mov eax, dword ptr [ebp - local_8]           # 0042071c
    {load} xor ecx, ecx                          # 0042071f
    mov cl, byte ptr [eax + field_77a]           # 00420721
    mov edx, dword ptr [ebp - local_c]           # 00420727
    call dword ptr [edx + 4*ecx + field_f4b]     # 0042072a
L_00420731:
    # block 0x00420731: entered by je at 0x0042071a, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00420731
    pop ebp                                      # 00420733
    ret 0x4                                      # 00420734

