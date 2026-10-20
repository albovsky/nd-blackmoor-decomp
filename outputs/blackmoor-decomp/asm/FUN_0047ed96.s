# FUN_0047ed96
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047ed96
# extent:       0x0047ed96-0x0047ef0f (377 code bytes)
# span:         0x0047ed96-0x0047ef0f (code 377, tables 0, padding 0)
# sha256:       ad11166fc338a5d8e9841a0fc95da1d92a9f235767d24c6f2a901534495e7083
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         set_layer
# naming:       native port src/action_family_eb_runtime.c:set_layer (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    Compared the original set_layer (collect overlapping pieces except itself in index order, take running max z into the piece word, add one) with the native set_layer; same call arguments and stores.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_ac, local_b0, local_b4, local_b6
# fields:       [eax + n] field_1e; [ecx + n] field_7b4; [edx + n] field_13a2
# callees:      calls FUN_0047ea73
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:set_layer (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 91 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_ac, 0xac  # offset -0xac
.equ local_b0, 0xb0  # offset -0xb0
.equ local_b4, 0xb4  # offset -0xb4
.equ local_b6, 0xb6  # offset -0xb6
.equ arg_8, 0x8  # offset +0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_7b4, 0x7b4  # offset +0x7b4
.equ field_13a2, 0x13a2  # offset +0x13a2

# --- external targets -----------------------------------------------
.set FUN_0047ea73, .text + (0x0047ea73 - 0x401000)

.org 0x0047ed96 - 0x401000
.globl FUN_0047ed96
FUN_0047ed96:
    # block 0x0047ed96: entry, 22 instruction(s), ends with forward jump to 0x0047ee03
    push ebp                                     # 0047ed96
    {load} mov ebp, esp                          # 0047ed97
    sub esp, 0xb8                                # 0047ed99
    push edi                                     # 0047ed9f
    mov dword ptr [ebp - local_b4], ecx          # 0047eda0
    mov word ptr [ebp - local_4], 0x0            # 0047eda6
    mov eax, dword ptr [ebp - local_b4]          # 0047edac
    movsx ecx, word ptr [eax + field_1e]         # 0047edb2
    imul ecx, ecx, 0x8d                          # 0047edb6
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0047edbc
    mov dword ptr [ebp - local_8], edx           # 0047edc2
    movsx eax, word ptr [ebp + arg_8]            # 0047edc5
    imul eax, eax, 0x25                          # 0047edc9
    mov ecx, dword ptr [ebp - local_b4]          # 0047edcc
    lea edx, [ecx + eax + field_7b4]             # 0047edd2
    mov dword ptr [ebp - local_b0], edx          # 0047edd9
    mov ecx, 0x28                                # 0047eddf
    or eax, -0x1                                 # 0047ede4
    lea edi, [ebp - local_ac]                    # 0047ede7
    rep stosd dword ptr es:[edi], eax            # 0047eded
    mov word ptr [ebp - local_c], 0x0            # 0047edef
    jmp.d8 L_0047ee03                            # 0047edf5
L_0047edf7:
    # block 0x0047edf7: entered by jmp at 0x0047ee24; jmp at 0x0047ee5b, 3 instruction(s), falls into the block at 0x0047ee03
    mov ax, word ptr [ebp - local_c]             # 0047edf7
    .insn 0x66, 0x05, 0x0001{:u16}               # 0047edfb
    mov word ptr [ebp - local_c], ax             # 0047edff
L_0047ee03:
    # block 0x0047ee03: entered by jmp at 0x0047edf5, 5 instruction(s), ends with jge to 0x0047ee5d (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0047ee03
    mov edx, dword ptr [ebp - local_b4]          # 0047ee07
    movsx eax, word ptr [edx + field_13a2]       # 0047ee0d
    {load} cmp ecx, eax                          # 0047ee14
    jge.d8 L_0047ee5d                            # 0047ee16
    # block 0x0047ee18: entered by fall-through of jge at 0x0047ee16, 4 instruction(s), ends with jne to 0x0047ee26 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0047ee18
    movsx edx, word ptr [ebp + arg_8]            # 0047ee1c
    {load} cmp ecx, edx                          # 0047ee20
    jne.d8 L_0047ee26                            # 0047ee22
    # block 0x0047ee24: entered by fall-through of jne at 0x0047ee22, 1 instruction(s), ends with backward jump to 0x0047edf7
    jmp.d8 L_0047edf7                            # 0047ee24
L_0047ee26:
    # block 0x0047ee26: entered by jne at 0x0047ee22, 8 instruction(s), calls FUN_0047ea73, ends with je to 0x0047ee5b (forward)
    movsx eax, word ptr [ebp - local_c]          # 0047ee26
    push eax                                     # 0047ee2a
    movsx ecx, word ptr [ebp + arg_8]            # 0047ee2b
    push ecx                                     # 0047ee2f
    mov ecx, dword ptr [ebp - local_b4]          # 0047ee30
    call FUN_0047ea73                            # 0047ee36
    test eax, eax                                # 0047ee3b
    je.d8 L_0047ee5b                             # 0047ee3d
    # block 0x0047ee3f: entered by fall-through of je at 0x0047ee3d, 6 instruction(s), falls into the block at 0x0047ee5b
    movsx edx, word ptr [ebp - local_4]          # 0047ee3f
    mov ax, word ptr [ebp - local_c]             # 0047ee43
    mov word ptr [ebp + 2*edx - local_ac], ax    # 0047ee47
    mov cx, word ptr [ebp - local_4]             # 0047ee4f
    add cx, 0x1                                  # 0047ee53
    mov word ptr [ebp - local_4], cx             # 0047ee57
L_0047ee5b:
    # block 0x0047ee5b: entered by je at 0x0047ee3d, 1 instruction(s), ends with backward jump to 0x0047edf7
    jmp.d8 L_0047edf7                            # 0047ee5b
L_0047ee5d:
    # block 0x0047ee5d: entered by jge at 0x0047ee16, 2 instruction(s), ends with forward jump to 0x0047ee71
    mov word ptr [ebp - local_c], 0x0            # 0047ee5d
    jmp.d8 L_0047ee71                            # 0047ee63
L_0047ee65:
    # block 0x0047ee65: entered by jmp at 0x0047eeed, 3 instruction(s), falls into the block at 0x0047ee71
    mov dx, word ptr [ebp - local_c]             # 0047ee65
    add dx, 0x1                                  # 0047ee69
    mov word ptr [ebp - local_c], dx             # 0047ee6d
L_0047ee71:
    # block 0x0047ee71: entered by jmp at 0x0047ee63, 4 instruction(s), ends with jge to 0x0047eef2 (forward)
    movsx eax, word ptr [ebp - local_c]          # 0047ee71
    movsx ecx, word ptr [ebp - local_4]          # 0047ee75
    {load} cmp eax, ecx                          # 0047ee79
    jge.d8 L_0047eef2                            # 0047ee7b
    # block 0x0047ee7d: entered by fall-through of jge at 0x0047ee7b, 9 instruction(s), ends with jle to 0x0047eeb9 (forward)
    mov edx, dword ptr [ebp - local_b0]          # 0047ee7d
    movsx eax, word ptr [edx]                    # 0047ee83
    movsx ecx, word ptr [ebp - local_c]          # 0047ee86
    movsx edx, word ptr [ebp + 2*ecx - local_ac] # 0047ee8a
    imul edx, edx, 0x25                          # 0047ee92
    mov ecx, dword ptr [ebp - local_b4]          # 0047ee95
    movsx edx, word ptr [ecx + edx + field_7b4]  # 0047ee9b
    {load} cmp eax, edx                          # 0047eea3
    jle.d8 L_0047eeb9                            # 0047eea5
    # block 0x0047eea7: entered by fall-through of jle at 0x0047eea5, 4 instruction(s), ends with forward jump to 0x0047eedd
    mov eax, dword ptr [ebp - local_b0]          # 0047eea7
    mov cx, word ptr [eax]                       # 0047eead
    mov word ptr [ebp - local_b6], cx            # 0047eeb0
    jmp.d8 L_0047eedd                            # 0047eeb7
L_0047eeb9:
    # block 0x0047eeb9: entered by jle at 0x0047eea5, 6 instruction(s), falls into the block at 0x0047eedd
    movsx edx, word ptr [ebp - local_c]          # 0047eeb9
    movsx eax, word ptr [ebp + 2*edx - local_ac] # 0047eebd
    imul eax, eax, 0x25                          # 0047eec5
    mov ecx, dword ptr [ebp - local_b4]          # 0047eec8
    mov dx, word ptr [ecx + eax + field_7b4]     # 0047eece
    mov word ptr [ebp - local_b6], dx            # 0047eed6
L_0047eedd:
    # block 0x0047eedd: entered by jmp at 0x0047eeb7, 4 instruction(s), ends with backward jump to 0x0047ee65
    mov eax, dword ptr [ebp - local_b0]          # 0047eedd
    mov cx, word ptr [ebp - local_b6]            # 0047eee3
    mov word ptr [eax], cx                       # 0047eeea
    jmp.d32 L_0047ee65                           # 0047eeed
L_0047eef2:
    # block 0x0047eef2: entered by jge at 0x0047ee7b, 9 instruction(s), ends with ret 0x4
    mov edx, dword ptr [ebp - local_b0]          # 0047eef2
    mov ax, word ptr [edx]                       # 0047eef8
    .insn 0x66, 0x05, 0x0001{:u16}               # 0047eefb
    mov ecx, dword ptr [ebp - local_b0]          # 0047eeff
    mov word ptr [ecx], ax                       # 0047ef05
    pop edi                                      # 0047ef08
    {load} mov esp, ebp                          # 0047ef09
    pop ebp                                      # 0047ef0b
    ret 0x4                                      # 0047ef0c

