# FUN_00455a0e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00455a0e
# extent:       0x00455a0e-0x00455a63 (85 code bytes)
# span:         0x00455a0e-0x00455a63 (code 85, tables 0, padding 0)
# sha256:       de08e5e3801abc2b9e6c89b3c7271fe26027ab675b1d4482d8391fe48b78637f
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00455a0e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e; [ecx + n] field_79f
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
.equ field_79f, 0x79f  # offset +0x79f

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00455a0e - 0x401000
.globl FUN_00455a0e
FUN_00455a0e:
    # block 0x00455a0e: entry, 18 instruction(s), ends with je to 0x00455a5d (forward)
    push ebp                                     # 00455a0e
    {load} mov ebp, esp                          # 00455a0f
    sub esp, 0x8                                 # 00455a11
    push esi                                     # 00455a14
    push edi                                     # 00455a15
    mov dword ptr [ebp - local_8], ecx           # 00455a16
    mov eax, dword ptr [ebp - local_8]           # 00455a19
    movsx ecx, word ptr [eax + field_1e]         # 00455a1c
    imul ecx, ecx, 0x8d                          # 00455a20
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00455a26
    mov dword ptr [ebp - local_4], edx           # 00455a2c
    mov edi, 0x54a038                            # 00455a2f
    mov esi, dword ptr [ebp - local_4]           # 00455a34
    add esi, 0x77e                               # 00455a37
    mov ecx, 0x9                                 # 00455a3d
    {load} xor eax, eax                          # 00455a42
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00455a44
    je.d8 L_00455a5d                             # 00455a46
    # block 0x00455a48: entered by fall-through of je at 0x00455a46, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00455a5d
    mov ecx, dword ptr [ebp - local_4]           # 00455a48
    mov dx, word ptr [ecx + field_79f]           # 00455a4b
    push edx                                     # 00455a52
    mov ecx, 0x5c3a67                            # 00455a53
    call FUN_004fb2e3                            # 00455a58
L_00455a5d:
    # block 0x00455a5d: entered by je at 0x00455a46, 5 instruction(s), ends with ret
    pop edi                                      # 00455a5d
    pop esi                                      # 00455a5e
    {load} mov esp, ebp                          # 00455a5f
    pop ebp                                      # 00455a61
    ret                                          # 00455a62

