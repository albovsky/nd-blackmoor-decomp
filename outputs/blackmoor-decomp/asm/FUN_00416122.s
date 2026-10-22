# FUN_00416122
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00416122
# extent:       0x00416122-0x004161d1 (175 code bytes)
# span:         0x00416122-0x004161d1 (code 175, tables 0, padding 0)
# sha256:       4d8bafb7681bb327e7b36faa3e2afb350c052898befed0463e5041d1f7762c09
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m416122_lifted
# naming:       native port src/original_methods_fl40.c:m416122_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 4 seeds; oracle: 46/46 instructions executed, 4/4 conditional-jump directions taken, callees as recording stubs.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_172, field_210, field_2a4; [ecx + n] field_212
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m416122_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 46 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_172, 0x172  # offset +0x172
.equ field_210, 0x210  # offset +0x210
.equ field_212, 0x212  # offset +0x212
.equ field_2a4, 0x2a4  # offset +0x2a4

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00416122 - 0x401000
.globl FUN_00416122
FUN_00416122:
    # block 0x00416122: entry, 8 instruction(s), ends with forward jump to 0x00416147
    push ebp                                     # 00416122
    {load} mov ebp, esp                          # 00416123
    sub esp, 0xc                                 # 00416125
    mov dword ptr [ebp - local_c], ecx           # 00416128
    mov eax, dword ptr [ebp + arg_8]             # 0041612b
    mov cx, word ptr [eax + field_210]           # 0041612e
    mov word ptr [ebp - local_4], cx             # 00416135
    jmp.d8 L_00416147                            # 00416139
L_0041613b:
    # block 0x0041613b: entered by jmp at 0x004161c6, 3 instruction(s), falls into the block at 0x00416147
    mov dx, word ptr [ebp - local_4]             # 0041613b
    add dx, 0x1                                  # 0041613f
    mov word ptr [ebp - local_4], dx             # 00416143
L_00416147:
    # block 0x00416147: entered by jmp at 0x00416139, 5 instruction(s), ends with jg to 0x004161cb (forward)
    movsx eax, word ptr [ebp - local_4]          # 00416147
    mov ecx, dword ptr [ebp + arg_8]             # 0041614b
    movsx edx, word ptr [ecx + field_212]        # 0041614e
    {load} cmp eax, edx                          # 00416155
    jg.d8 L_004161cb                             # 00416157
    # block 0x00416159: entered by fall-through of jg at 0x00416157, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x004161c6 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00416159
    mov ecx, dword ptr [eax + field_2a4]         # 0041615c
    push ecx                                     # 00416162
    call FUN_0051dc43                            # 00416163
    add esp, 0x4                                 # 00416168
    mov dword ptr [ebp - local_8], eax           # 0041616b
    movsx edx, word ptr [ebp - local_4]          # 0041616e
    mov eax, dword ptr [ebp + arg_8]             # 00416172
    mov ecx, dword ptr [ebp - local_8]           # 00416175
    mov dword ptr [eax + 4*edx + field_172], ecx # 00416178
    cmp dword ptr [ebp - local_8], 0x0           # 0041617f
    jne.d8 L_004161c6                            # 00416183
    # block 0x00416185: entered by fall-through of jne at 0x00416183, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004161cb
    movsx edx, word ptr [ebp - local_4]          # 00416185
    push edx                                     # 00416189
    push 0x541e38                                # 0041618a
    push 0x63888b                                # 0041618f
    call FUN_0050ca3e                            # 00416194
    add esp, 0xc                                 # 00416199
    push 0x63888b                                # 0041619c
    push 0x541e60                                # 004161a1
    mov ecx, 0x583979                            # 004161a6
    call FUN_0042639d                            # 004161ab
    mov dword ptr [0x63a58a], 0x4                # 004161b0
    mov ecx, 0x5cf659                            # 004161ba
    call FUN_004c97b4                            # 004161bf
    jmp.d8 L_004161cb                            # 004161c4
L_004161c6:
    # block 0x004161c6: entered by jne at 0x00416183, 1 instruction(s), ends with backward jump to 0x0041613b
    jmp.d32 L_0041613b                           # 004161c6
L_004161cb:
    # block 0x004161cb: entered by jg at 0x00416157; jmp at 0x004161c4, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004161cb
    pop ebp                                      # 004161cd
    ret 0x4                                      # 004161ce

