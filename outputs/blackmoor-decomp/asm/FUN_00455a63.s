# FUN_00455a63
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00455a63
# extent:       0x00455a63-0x00455ab8 (85 code bytes)
# span:         0x00455a63-0x00455ab8 (code 85, tables 0, padding 0)
# sha256:       80f6c371e12e7945a110617a07284c04d4d0e041b8674d51ace98cda8a3b8af2
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00455a63
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e; [ecx + n] field_7d0
# callees:      calls FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25a.c:m45565f_click_27c4_27c8 (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 28 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_7d0, 0x7d0  # offset +0x7d0

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00455a63 - 0x401000
.globl FUN_00455a63
FUN_00455a63:
    # block 0x00455a63: entry, 18 instruction(s), ends with je to 0x00455ab2 (forward)
    push ebp                                     # 00455a63
    {load} mov ebp, esp                          # 00455a64
    sub esp, 0x8                                 # 00455a66
    push esi                                     # 00455a69
    push edi                                     # 00455a6a
    mov dword ptr [ebp - local_8], ecx           # 00455a6b
    mov eax, dword ptr [ebp - local_8]           # 00455a6e
    movsx ecx, word ptr [eax + field_1e]         # 00455a71
    imul ecx, ecx, 0x8d                          # 00455a75
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00455a7b
    mov dword ptr [ebp - local_4], edx           # 00455a81
    mov edi, 0x54a044                            # 00455a84
    mov esi, dword ptr [ebp - local_4]           # 00455a89
    add esi, 0x7af                               # 00455a8c
    mov ecx, 0x9                                 # 00455a92
    {load} xor eax, eax                          # 00455a97
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00455a99
    je.d8 L_00455ab2                             # 00455a9b
    # block 0x00455a9d: entered by fall-through of je at 0x00455a9b, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00455ab2
    mov ecx, dword ptr [ebp - local_4]           # 00455a9d
    mov dx, word ptr [ecx + field_7d0]           # 00455aa0
    push edx                                     # 00455aa7
    mov ecx, 0x5c3a67                            # 00455aa8
    call FUN_004fb2e3                            # 00455aad
L_00455ab2:
    # block 0x00455ab2: entered by je at 0x00455a9b, 5 instruction(s), ends with ret
    pop edi                                      # 00455ab2
    pop esi                                      # 00455ab3
    {load} mov esp, ebp                          # 00455ab4
    pop ebp                                      # 00455ab6
    ret                                          # 00455ab7

