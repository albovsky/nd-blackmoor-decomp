# FUN_004cd645
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cd645
# extent:       0x004cd645-0x004cd6ff (186 code bytes)
# span:         0x004cd645-0x004cd6ff (code 186, tables 0, padding 0)
# sha256:       0f0161224236457434b4c1668f0ca708e6ab408374ae437ada9dfb76c0f74309
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cd645_lifted
# naming:       native port src/original_methods_fl39d.c:m4cd645_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (23 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_e; [ecx + n] field_4, field_8, field_c, field_e
# callees:      calls FUN_004cf1e4, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4cd645_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 59 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004cf1e4, .text + (0x004cf1e4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004cd645 - 0x401000
.globl FUN_004cd645
FUN_004cd645:
    # block 0x004cd645: entry, 11 instruction(s), calls FUN_004cf1e4, ends with jne to 0x004cd69f (forward)
    push ebp                                     # 004cd645
    {load} mov ebp, esp                          # 004cd646
    push ecx                                     # 004cd648
    mov dword ptr [ebp - local_4], ecx           # 004cd649
    push 0xf                                     # 004cd64c
    mov eax, dword ptr [ebp + arg_8]             # 004cd64e
    push eax                                     # 004cd651
    mov ecx, dword ptr [ebp - local_4]           # 004cd652
    call FUN_004cf1e4                            # 004cd655
    test eax, eax                                # 004cd65a
    jne.d8 L_004cd69f                            # 004cd65c
    # block 0x004cd65e: entered by fall-through of jne at 0x004cd65c, 15 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004cd6f9
    movsx ecx, word ptr [0x5c39e3]               # 004cd65e
    push ecx                                     # 004cd665
    mov edx, dword ptr [0x5bb57b]                # 004cd666
    push edx                                     # 004cd66c
    push 0x559290                                # 004cd66d
    push 0x63888b                                # 004cd672
    call FUN_0050ca3e                            # 004cd677
    add esp, 0x10                                # 004cd67c
    push 0x63888b                                # 004cd67f
    push 0x5592bc                                # 004cd684
    mov ecx, 0x583979                            # 004cd689
    call FUN_0042639d                            # 004cd68e
    mov ecx, 0x5cf659                            # 004cd693
    call FUN_004c97b4                            # 004cd698
    jmp.d8 L_004cd6f9                            # 004cd69d
L_004cd69f:
    # block 0x004cd69f: entered by jne at 0x004cd65c, 27 instruction(s), ends with je to 0x004cd6f9 (forward)
    mov eax, dword ptr [ebp + arg_c]             # 004cd69f
    mov ecx, dword ptr [eax]                     # 004cd6a2
    mov edx, dword ptr [ebp + arg_8]             # 004cd6a4
    mov eax, dword ptr [edx]                     # 004cd6a7
    mov edx, dword ptr [ecx]                     # 004cd6a9
    mov dword ptr [eax], edx                     # 004cd6ab
    mov edx, dword ptr [ecx + field_4]           # 004cd6ad
    mov dword ptr [eax + field_4], edx           # 004cd6b0
    mov edx, dword ptr [ecx + field_8]           # 004cd6b3
    mov dword ptr [eax + field_8], edx           # 004cd6b6
    mov dx, word ptr [ecx + field_c]             # 004cd6b9
    mov word ptr [eax + field_c], dx             # 004cd6bd
    mov cl, byte ptr [ecx + field_e]             # 004cd6c1
    mov byte ptr [eax + field_e], cl             # 004cd6c4
    mov edx, dword ptr [ebp + arg_10]            # 004cd6c7
    mov eax, dword ptr [edx]                     # 004cd6ca
    add eax, 0xf                                 # 004cd6cc
    mov ecx, dword ptr [ebp + arg_10]            # 004cd6cf
    mov dword ptr [ecx], eax                     # 004cd6d2
    mov edx, dword ptr [ebp + arg_c]             # 004cd6d4
    mov eax, dword ptr [edx]                     # 004cd6d7
    add eax, 0xf                                 # 004cd6d9
    mov ecx, dword ptr [ebp + arg_c]             # 004cd6dc
    mov dword ptr [ecx], eax                     # 004cd6df
    movsx edx, word ptr [0x63a4cd]               # 004cd6e1
    test edx, edx                                # 004cd6e8
    je.d8 L_004cd6f9                             # 004cd6ea
    # block 0x004cd6ec: entered by fall-through of je at 0x004cd6ea, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cd6f9
    push 0x5592d8                                # 004cd6ec
    call FUN_0044a2b7                            # 004cd6f1
    add esp, 0x4                                 # 004cd6f6
L_004cd6f9:
    # block 0x004cd6f9: entered by jmp at 0x004cd69d; je at 0x004cd6ea, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004cd6f9
    pop ebp                                      # 004cd6fb
    ret 0xc                                      # 004cd6fc

