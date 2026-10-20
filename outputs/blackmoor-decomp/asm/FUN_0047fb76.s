# FUN_0047fb76
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047fb76
# extent:       0x0047fb76-0x0047fd65 (495 code bytes)
# span:         0x0047fb76-0x0047fd65 (code 495, tables 0, padding 0)
# sha256:       a355c8c074dcf77e64eb218f2713d37fef4ecdeb1d63de05c3280d9f911aaa6c
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         multi_pick
# naming:       native port src/action_family_eb_runtime.c:multi_pick (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with multi_pick (E rect valid or D-rect recentre, clamp). Oracle compares aggregate object image and host log; native returns a host-failure status.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_2, field_4, field_6, field_8, field_c, field_14, field_16, field_1e, field_23, field_7d7, field_134c; [ecx + n] field_2, field_4, field_6, field_8, field_c, field_22, field_d9, field_7b4; [edx + n] field_2, field_4, field_6, field_8, field_a, field_c, field_e, field_20, field_c9, field_d9, field_7d7
# callees:      calls FUN_0047e99e, FUN_0047e52f, FUN_0047f19d
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:multi_pick (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 160 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_c9, 0xc9  # offset +0xc9
.equ field_d9, 0xd9  # offset +0xd9
.equ field_7b4, 0x7b4  # offset +0x7b4
.equ field_7d7, 0x7d7  # offset +0x7d7
.equ field_134c, 0x134c  # offset +0x134c

# --- external targets -----------------------------------------------
.set FUN_0047e52f, .text + (0x0047e52f - 0x401000)
.set FUN_0047e99e, .text + (0x0047e99e - 0x401000)
.set FUN_0047f19d, .text + (0x0047f19d - 0x401000)

.org 0x0047fb76 - 0x401000
.globl FUN_0047fb76
FUN_0047fb76:
    # block 0x0047fb76: entry, 41 instruction(s), calls FUN_0047e99e, ends with je to 0x0047fc5f (forward)
    push ebp                                     # 0047fb76
    {load} mov ebp, esp                          # 0047fb77
    sub esp, 0x28                                # 0047fb79
    mov dword ptr [ebp - local_28], ecx          # 0047fb7c
    mov eax, dword ptr [ebp - local_28]          # 0047fb7f
    movsx ecx, word ptr [eax + field_1e]         # 0047fb82
    imul ecx, ecx, 0x8d                          # 0047fb86
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0047fb8c
    mov dword ptr [ebp - local_c], edx           # 0047fb92
    movsx eax, word ptr [ebp + arg_8]            # 0047fb95
    imul eax, eax, 0x25                          # 0047fb99
    mov ecx, dword ptr [ebp - local_28]          # 0047fb9c
    lea edx, [ecx + eax + field_7b4]             # 0047fb9f
    mov dword ptr [ebp - local_24], edx          # 0047fba6
    mov eax, dword ptr [ebp - local_28]          # 0047fba9
    mov dword ptr [eax + field_134c], 0x1        # 0047fbac
    mov ecx, dword ptr [ebp - local_24]          # 0047fbb6
    add ecx, 0x2                                 # 0047fbb9
    mov edx, dword ptr [ebp - local_28]          # 0047fbbc
    add edx, 0x1392                              # 0047fbbf
    mov eax, dword ptr [ecx]                     # 0047fbc5
    mov dword ptr [edx], eax                     # 0047fbc7
    mov eax, dword ptr [ecx + field_4]           # 0047fbc9
    mov dword ptr [edx + field_4], eax           # 0047fbcc
    mov eax, dword ptr [ecx + field_8]           # 0047fbcf
    mov dword ptr [edx + field_8], eax           # 0047fbd2
    mov ecx, dword ptr [ecx + field_c]           # 0047fbd5
    mov dword ptr [edx + field_c], ecx           # 0047fbd8
    movsx edx, word ptr [ebp + arg_8]            # 0047fbdb
    imul edx, edx, 0x25                          # 0047fbdf
    mov eax, dword ptr [ebp - local_28]          # 0047fbe2
    {load} xor ecx, ecx                          # 0047fbe5
    mov cl, byte ptr [eax + edx + field_7d7]     # 0047fbe7
    imul ecx, ecx, 0x53                          # 0047fbee
    mov edx, dword ptr [ebp - local_c]           # 0047fbf1
    lea eax, [edx + ecx + field_d9]              # 0047fbf4
    push eax                                     # 0047fbfb
    mov ecx, dword ptr [ebp - local_28]          # 0047fbfc
    call FUN_0047e99e                            # 0047fbff
    test eax, eax                                # 0047fc04
    je.d8 L_0047fc5f                             # 0047fc06
    # block 0x0047fc08: entered by fall-through of je at 0x0047fc06, 27 instruction(s), calls FUN_0047e52f, ends with forward jump to 0x0047fd5f
    movsx ecx, word ptr [ebp + arg_8]            # 0047fc08
    imul ecx, ecx, 0x25                          # 0047fc0c
    mov edx, dword ptr [ebp - local_28]          # 0047fc0f
    {load} xor eax, eax                          # 0047fc12
    mov al, byte ptr [edx + ecx + field_7d7]     # 0047fc14
    imul eax, eax, 0x53                          # 0047fc1b
    mov ecx, dword ptr [ebp - local_c]           # 0047fc1e
    lea edx, [ecx + eax + field_d9]              # 0047fc21
    mov eax, dword ptr [ebp - local_24]          # 0047fc28
    add eax, 0x2                                 # 0047fc2b
    mov ecx, dword ptr [edx]                     # 0047fc2e
    mov dword ptr [eax], ecx                     # 0047fc30
    mov ecx, dword ptr [edx + field_4]           # 0047fc32
    mov dword ptr [eax + field_4], ecx           # 0047fc35
    mov ecx, dword ptr [edx + field_8]           # 0047fc38
    mov dword ptr [eax + field_8], ecx           # 0047fc3b
    mov edx, dword ptr [edx + field_c]           # 0047fc3e
    mov dword ptr [eax + field_c], edx           # 0047fc41
    mov eax, dword ptr [ebp - local_24]          # 0047fc44
    add eax, 0x12                                # 0047fc47
    push eax                                     # 0047fc4a
    mov ecx, dword ptr [ebp - local_24]          # 0047fc4b
    add ecx, 0x2                                 # 0047fc4e
    push ecx                                     # 0047fc51
    mov ecx, dword ptr [ebp - local_28]          # 0047fc52
    call FUN_0047e52f                            # 0047fc55
    jmp.d32 L_0047fd5f                           # 0047fc5a
L_0047fc5f:
    # block 0x0047fc5f: entered by je at 0x0047fc06, 89 instruction(s), calls FUN_0047f19d, FUN_0047e52f, falls into the block at 0x0047fd5f
    movsx edx, word ptr [ebp + arg_8]            # 0047fc5f
    imul edx, edx, 0x25                          # 0047fc63
    mov eax, dword ptr [ebp - local_28]          # 0047fc66
    {load} xor ecx, ecx                          # 0047fc69
    mov cl, byte ptr [eax + edx + field_7d7]     # 0047fc6b
    imul ecx, ecx, 0x53                          # 0047fc72
    mov edx, dword ptr [ebp - local_c]           # 0047fc75
    lea eax, [edx + ecx + field_c9]              # 0047fc78
    mov ecx, dword ptr [eax]                     # 0047fc7f
    mov dword ptr [ebp - local_1c], ecx          # 0047fc81
    mov edx, dword ptr [eax + field_4]           # 0047fc84
    mov dword ptr [ebp - local_18], edx          # 0047fc87
    mov ecx, dword ptr [eax + field_8]           # 0047fc8a
    mov dword ptr [ebp - local_14], ecx          # 0047fc8d
    mov edx, dword ptr [eax + field_c]           # 0047fc90
    mov dword ptr [ebp - local_10], edx          # 0047fc93
    mov eax, dword ptr [ebp - local_24]          # 0047fc96
    {load} xor ecx, ecx                          # 0047fc99
    mov cl, byte ptr [eax + field_23]            # 0047fc9b
    imul ecx, ecx, 0x60                          # 0047fc9e
    mov edx, dword ptr [ebp - local_28]          # 0047fca1
    lea eax, [edx + ecx + field_20]              # 0047fca4
    mov ecx, dword ptr [ebp - local_24]          # 0047fca8
    {load} xor edx, edx                          # 0047fcab
    mov dl, byte ptr [ecx + field_22]            # 0047fcad
    imul edx, edx, 0x18                          # 0047fcb0
    {load} add eax, edx                          # 0047fcb3
    mov dword ptr [ebp - local_8], eax           # 0047fcb5
    mov eax, dword ptr [ebp - local_8]           # 0047fcb8
    movsx eax, word ptr [eax + field_14]         # 0047fcbb
    cdq                                          # 0047fcbf
    {load} sub eax, edx                          # 0047fcc0
    sar eax                                      # 0047fcc2
    mov ecx, dword ptr [ebp - local_24]          # 0047fcc4
    mov edx, dword ptr [ecx + field_2]           # 0047fcc7
    {load} add edx, eax                          # 0047fcca
    mov word ptr [ebp - local_20], dx            # 0047fccc
    mov eax, dword ptr [ebp - local_8]           # 0047fcd0
    movsx eax, word ptr [eax + field_16]         # 0047fcd3
    cdq                                          # 0047fcd7
    {load} sub eax, edx                          # 0047fcd8
    sar eax                                      # 0047fcda
    mov ecx, dword ptr [ebp - local_24]          # 0047fcdc
    mov edx, dword ptr [ecx + field_6]           # 0047fcdf
    {load} add edx, eax                          # 0047fce2
    mov word ptr [ebp - local_4], dx             # 0047fce4
    movsx ecx, word ptr [ebp - local_20]         # 0047fce8
    mov eax, dword ptr [ebp - local_14]          # 0047fcec
    sub eax, dword ptr [ebp - local_1c]          # 0047fcef
    cdq                                          # 0047fcf2
    {load} sub eax, edx                          # 0047fcf3
    sar eax                                      # 0047fcf5
    {load} sub ecx, eax                          # 0047fcf7
    mov edx, dword ptr [ebp - local_24]          # 0047fcf9
    mov dword ptr [edx + field_2], ecx           # 0047fcfc
    movsx ecx, word ptr [ebp - local_4]          # 0047fcff
    mov eax, dword ptr [ebp - local_10]          # 0047fd03
    sub eax, dword ptr [ebp - local_18]          # 0047fd06
    cdq                                          # 0047fd09
    {load} sub eax, edx                          # 0047fd0a
    sar eax                                      # 0047fd0c
    {load} sub ecx, eax                          # 0047fd0e
    mov edx, dword ptr [ebp - local_24]          # 0047fd10
    mov dword ptr [edx + field_6], ecx           # 0047fd13
    mov eax, dword ptr [ebp - local_24]          # 0047fd16
    mov ecx, dword ptr [eax + field_2]           # 0047fd19
    add ecx, dword ptr [ebp - local_14]          # 0047fd1c
    sub ecx, dword ptr [ebp - local_1c]          # 0047fd1f
    mov edx, dword ptr [ebp - local_24]          # 0047fd22
    mov dword ptr [edx + field_a], ecx           # 0047fd25
    mov eax, dword ptr [ebp - local_24]          # 0047fd28
    mov ecx, dword ptr [eax + field_6]           # 0047fd2b
    add ecx, dword ptr [ebp - local_10]          # 0047fd2e
    sub ecx, dword ptr [ebp - local_18]          # 0047fd31
    mov edx, dword ptr [ebp - local_24]          # 0047fd34
    mov dword ptr [edx + field_e], ecx           # 0047fd37
    mov eax, dword ptr [ebp - local_24]          # 0047fd3a
    add eax, 0x2                                 # 0047fd3d
    push eax                                     # 0047fd40
    mov ecx, dword ptr [ebp - local_28]          # 0047fd41
    call FUN_0047f19d                            # 0047fd44
    mov ecx, dword ptr [ebp - local_24]          # 0047fd49
    add ecx, 0x12                                # 0047fd4c
    push ecx                                     # 0047fd4f
    mov edx, dword ptr [ebp - local_24]          # 0047fd50
    add edx, 0x2                                 # 0047fd53
    push edx                                     # 0047fd56
    mov ecx, dword ptr [ebp - local_28]          # 0047fd57
    call FUN_0047e52f                            # 0047fd5a
L_0047fd5f:
    # block 0x0047fd5f: entered by jmp at 0x0047fc5a, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0047fd5f
    pop ebp                                      # 0047fd61
    ret 0x4                                      # 0047fd62

