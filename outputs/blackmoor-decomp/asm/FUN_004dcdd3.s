# FUN_004dcdd3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dcdd3
# extent:       0x004dcdd3-0x004dd05a (647 code bytes)
# span:         0x004dcdd3-0x004dd05a (code 647, tables 0, padding 0)
# sha256:       31d3c6b130a7b85f4083cdb510c4110f6b02bdc05abc7e3f2a08dd9c8700ea17
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         partner_step
# naming:       native port src/avf_player.c:partner_step (port_acceptances, ledger class native_tests_only, reviewed 2026-10-16); the summary is the acceptance note
# summary:      Substates 0 and 4 match branch for branch. Seams: debug lines omitted; finish = +0x1c 3 plus the 0x4dad60 reset (caller does it); 0x4f6334 is gate.sound_busy; 0x4fb2e3 is the sound event. Oracle window is not executed whole.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4a, field_ee, field_102, field_172, field_1cc; [ecx + n] field_1c, field_4a, field_b7, field_de, field_ee, field_102, field_17a, field_18c, field_18e, field_1be, field_1c2; [edx + n] field_1c, field_de, field_ee, field_172, field_17a, field_1be, field_1cc
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004dd28d, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_004dad60
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:partner_step (function ledger class native_tests_only; also partner_step_index; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 151 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_4a, 0x4a  # offset +0x4a
.equ field_b7, 0xb7  # offset +0xb7
.equ field_de, 0xde  # offset +0xde
.equ field_ee, 0xee  # offset +0xee
.equ field_102, 0x102  # offset +0x102
.equ field_172, 0x172  # offset +0x172
.equ field_17a, 0x17a  # offset +0x17a
.equ field_18c, 0x18c  # offset +0x18c
.equ field_18e, 0x18e  # offset +0x18e
.equ field_1be, 0x1be  # offset +0x1be
.equ field_1c2, 0x1c2  # offset +0x1c2
.equ field_1cc, 0x1cc  # offset +0x1cc

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dd28d, .text + (0x004dd28d - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004dcdd3 - 0x401000
.globl FUN_004dcdd3
FUN_004dcdd3:
    # block 0x004dcdd3: entry, 8 instruction(s), ends with je to 0x004dcdf9 (forward)
    push ebp                                     # 004dcdd3
    {load} mov ebp, esp                          # 004dcdd4
    sub esp, 0xc                                 # 004dcdd6
    mov dword ptr [ebp - local_8], ecx           # 004dcdd9
    mov eax, dword ptr [0x6381a9]                # 004dcddc
    mov dword ptr [ebp - local_c], eax           # 004dcde1
    cmp dword ptr [ebp - local_c], 0x0           # 004dcde4
    je.d8 L_004dcdf9                             # 004dcde8
    # block 0x004dcdea: entered by fall-through of je at 0x004dcde8, 2 instruction(s), ends with je to 0x004dcef8 (forward)
    cmp dword ptr [ebp - local_c], 0x4           # 004dcdea
    je.d32 L_004dcef8                            # 004dcdee
    # block 0x004dcdf4: entered by fall-through of je at 0x004dcdee, 1 instruction(s), ends with forward jump to 0x004dd056
    jmp.d32 L_004dd056                           # 004dcdf4
L_004dcdf9:
    # block 0x004dcdf9: entered by je at 0x004dcde8, 3 instruction(s), ends with je to 0x004dce34 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004dcdf9
    test ecx, ecx                                # 004dce00
    je.d8 L_004dce34                             # 004dce02
    # block 0x004dce04: entered by fall-through of je at 0x004dce02, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004dce34
    mov edx, dword ptr [ebp - local_8]           # 004dce04
    mov eax, dword ptr [edx + field_ee]          # 004dce07
    movsx ecx, word ptr [eax + field_1cc]        # 004dce0d
    push ecx                                     # 004dce14
    push 0x55b4b0                                # 004dce15
    push 0x63888b                                # 004dce1a
    call FUN_0050ca3e                            # 004dce1f
    add esp, 0xc                                 # 004dce24
    push 0x63888b                                # 004dce27
    call FUN_0044a2b7                            # 004dce2c
    add esp, 0x4                                 # 004dce31
L_004dce34:
    # block 0x004dce34: entered by je at 0x004dce02, 5 instruction(s), ends with je to 0x004dcef3 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004dce34
    mov eax, dword ptr [edx + field_ee]          # 004dce37
    movsx ecx, word ptr [eax + field_1cc]        # 004dce3d
    test ecx, ecx                                # 004dce44
    je.d32 L_004dcef3                            # 004dce46
    # block 0x004dce4c: entered by fall-through of je at 0x004dce46, 4 instruction(s), ends with jne to 0x004dce7d (forward)
    mov edx, dword ptr [ebp - local_8]           # 004dce4c
    mov eax, dword ptr [edx + field_ee]          # 004dce4f
    cmp dword ptr [eax + field_172], 0x1         # 004dce55
    jne.d8 L_004dce7d                            # 004dce5c
    # block 0x004dce5e: entered by fall-through of jne at 0x004dce5c, 7 instruction(s), falls into the block at 0x004dce7d
    mov ecx, dword ptr [ebp - local_8]           # 004dce5e
    mov edx, dword ptr [ecx + field_ee]          # 004dce61
    movsx eax, word ptr [0x638161]               # 004dce67
    mov ecx, dword ptr [ebp - local_8]           # 004dce6e
    mov ecx, dword ptr [ecx + field_4a]          # 004dce71
    mov edx, dword ptr [edx + 4*eax + field_17a] # 004dce74
    mov dword ptr [ecx], edx                     # 004dce7b
L_004dce7d:
    # block 0x004dce7d: entered by jne at 0x004dce5c, 12 instruction(s), calls FUN_004dd28d, KERNEL32.dll!GetTickCount, ends with je to 0x004dcec7 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004dce7d
    call FUN_004dd28d                            # 004dce80
    call dword ptr [0x52a23c]                    # 004dce85
    mov ecx, dword ptr [ebp - local_8]           # 004dce8b
    mov edx, dword ptr [ecx + field_ee]          # 004dce8e
    add eax, dword ptr [edx + field_1c]          # 004dce94
    mov ecx, dword ptr [ebp - local_8]           # 004dce97
    mov edx, dword ptr [ecx + field_ee]          # 004dce9a
    mov dword ptr [edx + field_1be], eax         # 004dcea0
    mov eax, dword ptr [ebp - local_8]           # 004dcea6
    cmp dword ptr [eax + field_102], 0x0         # 004dcea9
    je.d8 L_004dcec7                             # 004dceb0
    # block 0x004dceb2: entered by fall-through of je at 0x004dceb0, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004dcec7
    mov ecx, dword ptr [ebp - local_8]           # 004dceb2
    mov dx, word ptr [ecx + field_de]            # 004dceb5
    push edx                                     # 004dcebc
    mov ecx, 0x5c3a67                            # 004dcebd
    call FUN_004fb2e3                            # 004dcec2
L_004dcec7:
    # block 0x004dcec7: entered by je at 0x004dceb0, 5 instruction(s), ends with je to 0x004dcef3 (forward)
    mov dword ptr [0x6381e5], 0x1                # 004dcec7
    mov dword ptr [0x6381a9], 0x4                # 004dced1
    movsx eax, word ptr [0x63a4cd]               # 004dcedb
    test eax, eax                                # 004dcee2
    je.d8 L_004dcef3                             # 004dcee4
    # block 0x004dcee6: entered by fall-through of je at 0x004dcee4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dcef3
    push 0x55b50c                                # 004dcee6
    call FUN_0044a2b7                            # 004dceeb
    add esp, 0x4                                 # 004dcef0
L_004dcef3:
    # block 0x004dcef3: entered by je at 0x004dce46; je at 0x004dcee4, 1 instruction(s), ends with forward jump to 0x004dd056
    jmp.d32 L_004dd056                           # 004dcef3
L_004dcef8:
    # block 0x004dcef8: entered by je at 0x004dcdee, 5 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004dd056 (forward)
    call dword ptr [0x52a23c]                    # 004dcef8
    mov ecx, dword ptr [ebp - local_8]           # 004dcefe
    mov edx, dword ptr [ecx + field_ee]          # 004dcf01
    cmp eax, dword ptr [edx + field_1be]         # 004dcf07
    jb.d32 L_004dd056                            # 004dcf0d
    # block 0x004dcf13: entered by fall-through of jb at 0x004dcf0d, 8 instruction(s), ends with jne to 0x004dcf46 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004dcf13
    mov ecx, dword ptr [eax + field_ee]          # 004dcf16
    movsx edx, word ptr [ecx + field_1c2]        # 004dcf1c
    mov eax, dword ptr [ebp - local_8]           # 004dcf23
    mov ecx, dword ptr [eax + field_ee]          # 004dcf26
    movsx eax, word ptr [ecx + field_18e]        # 004dcf2c
    {load} cmp edx, eax                          # 004dcf33
    jne.d8 L_004dcf46                            # 004dcf35
    # block 0x004dcf37: entered by fall-through of jne at 0x004dcf35, 4 instruction(s), ends with je to 0x004dcf79 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004dcf37
    movsx edx, word ptr [ecx + field_b7]         # 004dcf3a
    cmp edx, 0x1                                 # 004dcf41
    je.d8 L_004dcf79                             # 004dcf44
L_004dcf46:
    # block 0x004dcf46: entered by jne at 0x004dcf35; fall-through of je at 0x004dcf44, 8 instruction(s), ends with jne to 0x004dcfde (forward)
    mov eax, dword ptr [ebp - local_8]           # 004dcf46
    mov ecx, dword ptr [eax + field_ee]          # 004dcf49
    movsx edx, word ptr [ecx + field_1c2]        # 004dcf4f
    mov eax, dword ptr [ebp - local_8]           # 004dcf56
    mov ecx, dword ptr [eax + field_ee]          # 004dcf59
    movsx eax, word ptr [ecx + field_18c]        # 004dcf5f
    {load} cmp edx, eax                          # 004dcf66
    jne.d8 L_004dcfde                            # 004dcf68
    # block 0x004dcf6a: entered by fall-through of jne at 0x004dcf68, 4 instruction(s), ends with jne to 0x004dcfde (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004dcf6a
    movsx edx, word ptr [ecx + field_b7]         # 004dcf6d
    cmp edx, 0x2                                 # 004dcf74
    jne.d8 L_004dcfde                            # 004dcf77
L_004dcf79:
    # block 0x004dcf79: entered by je at 0x004dcf44; fall-through of jne at 0x004dcf77, 3 instruction(s), ends with je to 0x004dcfb0 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004dcf79
    cmp dword ptr [eax + field_102], 0x0         # 004dcf7c
    je.d8 L_004dcfb0                             # 004dcf83
    # block 0x004dcf85: entered by fall-through of je at 0x004dcf83, 3 instruction(s), ends with je to 0x004dcfde (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004dcf85
    cmp dword ptr [ecx + field_102], 0x0         # 004dcf88
    je.d8 L_004dcfde                             # 004dcf8f
    # block 0x004dcf91: entered by fall-through of je at 0x004dcf8f, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004dcfde (forward)
    mov edx, dword ptr [ebp - local_8]           # 004dcf91
    movsx eax, word ptr [edx + field_de]         # 004dcf94
    mov dword ptr [ebp - local_4], eax           # 004dcf9b
    mov ecx, dword ptr [ebp - local_4]           # 004dcf9e
    push ecx                                     # 004dcfa1
    mov ecx, 0x5cf1eb                            # 004dcfa2
    call FUN_004f6334                            # 004dcfa7
    test eax, eax                                # 004dcfac
    jne.d8 L_004dcfde                            # 004dcfae
L_004dcfb0:
    # block 0x004dcfb0: entered by je at 0x004dcf83; fall-through of jne at 0x004dcfae, 7 instruction(s), calls FUN_004dad60, ends with je to 0x004dcfdc (forward)
    mov edx, dword ptr [ebp - local_8]           # 004dcfb0
    mov dword ptr [edx + field_1c], 0x3          # 004dcfb3
    mov ecx, 0x5830a6                            # 004dcfba
    call FUN_004dad60                            # 004dcfbf
    movsx eax, word ptr [0x63a4cd]               # 004dcfc4
    test eax, eax                                # 004dcfcb
    je.d8 L_004dcfdc                             # 004dcfcd
    # block 0x004dcfcf: entered by fall-through of je at 0x004dcfcd, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dcfdc
    push 0x55b54c                                # 004dcfcf
    call FUN_0044a2b7                            # 004dcfd4
    add esp, 0x4                                 # 004dcfd9
L_004dcfdc:
    # block 0x004dcfdc: entered by je at 0x004dcfcd, 1 instruction(s), ends with forward jump to 0x004dd056
    jmp.d8 L_004dd056                            # 004dcfdc
L_004dcfde:
    # block 0x004dcfde: entered by jne at 0x004dcf68; jne at 0x004dcf77; je at 0x004dcf8f; jne at 0x004dcfae, 5 instruction(s), ends with je to 0x004dd056 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004dcfde
    mov edx, dword ptr [ecx + field_ee]          # 004dcfe1
    movsx eax, word ptr [edx + field_1cc]        # 004dcfe7
    test eax, eax                                # 004dcfee
    je.d8 L_004dd056                             # 004dcff0
    # block 0x004dcff2: entered by fall-through of je at 0x004dcff0, 4 instruction(s), ends with jne to 0x004dd023 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004dcff2
    mov edx, dword ptr [ecx + field_ee]          # 004dcff5
    cmp dword ptr [edx + field_172], 0x1         # 004dcffb
    jne.d8 L_004dd023                            # 004dd002
    # block 0x004dd004: entered by fall-through of jne at 0x004dd002, 7 instruction(s), falls into the block at 0x004dd023
    mov eax, dword ptr [ebp - local_8]           # 004dd004
    mov ecx, dword ptr [eax + field_ee]          # 004dd007
    movsx edx, word ptr [0x638161]               # 004dd00d
    mov eax, dword ptr [ebp - local_8]           # 004dd014
    mov eax, dword ptr [eax + field_4a]          # 004dd017
    mov ecx, dword ptr [ecx + 4*edx + field_17a] # 004dd01a
    mov dword ptr [eax], ecx                     # 004dd021
L_004dd023:
    # block 0x004dd023: entered by jne at 0x004dd002, 10 instruction(s), calls FUN_004dd28d, KERNEL32.dll!GetTickCount, falls into the block at 0x004dd056
    mov ecx, dword ptr [ebp - local_8]           # 004dd023
    call FUN_004dd28d                            # 004dd026
    call dword ptr [0x52a23c]                    # 004dd02b
    mov edx, dword ptr [ebp - local_8]           # 004dd031
    mov ecx, dword ptr [edx + field_ee]          # 004dd034
    add eax, dword ptr [ecx + field_1c]          # 004dd03a
    mov edx, dword ptr [ebp - local_8]           # 004dd03d
    mov ecx, dword ptr [edx + field_ee]          # 004dd040
    mov dword ptr [ecx + field_1be], eax         # 004dd046
    mov dword ptr [0x6381e5], 0x1                # 004dd04c
L_004dd056:
    # block 0x004dd056: entered by jmp at 0x004dcdf4; jmp at 0x004dcef3; jb at 0x004dcf0d; jmp at 0x004dcfdc; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004dd056
    pop ebp                                      # 004dd058
    ret                                          # 004dd059

