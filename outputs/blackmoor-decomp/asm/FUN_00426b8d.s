# FUN_00426b8d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426b8d
# extent:       0x00426b8d-0x00426c51 (196 code bytes)
# span:         0x00426b8d-0x00426c51 (code 196, tables 0, padding 0)
# sha256:       15c3fab9d15d1f262bfe488d973f29e888df84736db10f98aaf812ede014d434
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m426b8d_lifted
# naming:       native port src/original_methods_fl40.c:m426b8d_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 5 seeds; oracle 54/54 instructions, 6/6 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [ecx + n] field_ca202
# callees:      calls KERNEL32.dll!GetCurrentThreadId, USER32.dll!GetKeyboardLayout, FUN_0051d97f, FUN_00524da3, FUN_00524fe7, FUN_00435015, FUN_0043f0fb, FUN_004c1572, FUN_004264e8, FUN_0042639d, FUN_00426d0f
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m426b8d_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 54 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_ca202, 0xca202  # offset +0xca202

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_00426d0f, .text + (0x00426d0f - 0x401000)
.set FUN_00435015, .text + (0x00435015 - 0x401000)
.set FUN_0043f0fb, .text + (0x0043f0fb - 0x401000)
.set FUN_004c1572, .text + (0x004c1572 - 0x401000)
.set FUN_0051d97f, .text + (0x0051d97f - 0x401000)
.set FUN_00524da3, .text + (0x00524da3 - 0x401000)
.set FUN_00524fe7, .text + (0x00524fe7 - 0x401000)

.org 0x00426b8d - 0x401000
.globl FUN_00426b8d
FUN_00426b8d:
    # block 0x00426b8d: entry, 25 instruction(s), calls KERNEL32.dll!GetCurrentThreadId, USER32.dll!GetKeyboardLayout, FUN_0051d97f, FUN_00524da3, FUN_00..., ends with jne to 0x00426bea (forward)
    push ebp                                     # 00426b8d
    {load} mov ebp, esp                          # 00426b8e
    sub esp, 0xc                                 # 00426b90
    mov dword ptr [ebp - local_c], ecx           # 00426b93
    call dword ptr [0x52a2a0]                    # 00426b96
    mov dword ptr [ebp - local_8], eax           # 00426b9c
    mov eax, dword ptr [ebp - local_8]           # 00426b9f
    push eax                                     # 00426ba2
    call dword ptr [0x52a4c4]                    # 00426ba3
    mov dword ptr [ebp - local_4], eax           # 00426ba9
    mov ecx, dword ptr [ebp - local_c]           # 00426bac
    call FUN_0051d97f                            # 00426baf
    push 0x4                                     # 00426bb4
    mov ecx, dword ptr [ebp - local_c]           # 00426bb6
    call FUN_00524da3                            # 00426bb9
    push 0xc0c0c0                                # 00426bbe
    push 0x0                                     # 00426bc3
    mov ecx, dword ptr [ebp - local_c]           # 00426bc5
    call FUN_00524fe7                            # 00426bc8
    mov ecx, dword ptr [ebp - local_c]           # 00426bcd
    mov dword ptr [ecx + field_ca202], 0x0       # 00426bd0
    call FUN_00435015                            # 00426bda
    movsx edx, ax                                # 00426bdf
    test edx, edx                                # 00426be2
    jne.d8 L_00426bea                            # 00426be4
    # block 0x00426be6: entered by fall-through of jne at 0x00426be4, 2 instruction(s), ends with forward jump to 0x00426c4d
    {load} xor eax, eax                          # 00426be6
    jmp.d8 L_00426c4d                            # 00426be8
L_00426bea:
    # block 0x00426bea: entered by jne at 0x00426be4, 7 instruction(s), calls FUN_0043f0fb, FUN_004c1572, ends with jne to 0x00426c40 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00426bea
    add ecx, 0x62ba5                             # 00426bed
    call FUN_0043f0fb                            # 00426bf3
    mov ecx, 0x5cf659                            # 00426bf8
    call FUN_004c1572                            # 00426bfd
    test eax, eax                                # 00426c02
    jne.d8 L_00426c40                            # 00426c04
    # block 0x00426c06: entered by fall-through of jne at 0x00426c04, 2 instruction(s), ends with je to 0x00426c24 (forward)
    cmp dword ptr [0x63a561], 0x0                # 00426c06
    je.d8 L_00426c24                             # 00426c0d
    # block 0x00426c0f: entered by fall-through of je at 0x00426c0d, 5 instruction(s), calls FUN_004264e8, ends with forward jump to 0x00426c3c
    push 0x545468                                # 00426c0f
    mov ecx, dword ptr [ebp - local_c]           # 00426c14
    add ecx, 0x135f1                             # 00426c17
    call FUN_004264e8                            # 00426c1d
    jmp.d8 L_00426c3c                            # 00426c22
L_00426c24:
    # block 0x00426c24: entered by je at 0x00426c0d, 5 instruction(s), calls FUN_0042639d, falls into the block at 0x00426c3c
    push 0x5454a8                                # 00426c24
    push 0x5454d4                                # 00426c29
    mov ecx, dword ptr [ebp - local_c]           # 00426c2e
    add ecx, 0x135f1                             # 00426c31
    call FUN_0042639d                            # 00426c37
L_00426c3c:
    # block 0x00426c3c: entered by jmp at 0x00426c22, 2 instruction(s), ends with forward jump to 0x00426c4d
    {load} xor eax, eax                          # 00426c3c
    jmp.d8 L_00426c4d                            # 00426c3e
L_00426c40:
    # block 0x00426c40: entered by jne at 0x00426c04, 3 instruction(s), calls FUN_00426d0f, falls into the block at 0x00426c4d
    mov ecx, dword ptr [ebp - local_c]           # 00426c40
    call FUN_00426d0f                            # 00426c43
    mov eax, 0x1                                 # 00426c48
L_00426c4d:
    # block 0x00426c4d: entered by jmp at 0x00426be8; jmp at 0x00426c3e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00426c4d
    pop ebp                                      # 00426c4f
    ret                                          # 00426c50

