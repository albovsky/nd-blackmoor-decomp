# FUN_004ce8ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ce8ea
# extent:       0x004ce8ea-0x004ceb3b (593 code bytes)
# span:         0x004ce8ea-0x004ceb3b (code 593, tables 0, padding 0)
# sha256:       6a37c4f21041be9ea11ddeedd55c1f838c622fad3abafe1d90d6b97f2f43854f
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ce8ea_scan_step
# naming:       native port src/original_methods_fl28c.c:m4ce8ea_scan_step (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4ce8ea_scan_step (two-arm scan state machine). Oracle: 154/154 instructions of the 593 code bytes, 20/20 jcc directions, 174 scenarios. See tasks/fl28c-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_2d, field_2f, field_18e, field_206, field_232, field_246; [ecx + n] field_23, field_18e, field_1da, field_20a, field_212, field_232; [edx + n] field_23, field_2d, field_2f, field_18e, field_1de, field_206, field_212, field_226, field_232
# callees:      calls FUN_004bef85, FUN_004befc8, FUN_004bf098, FUN_004bee2c, FUN_004ceb8c, FUN_004bf10f, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/action_family_2d_runtime.c:step_bink (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 154 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_23, 0x23  # offset +0x23
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_18e, 0x18e  # offset +0x18e
.equ field_1da, 0x1da  # offset +0x1da
.equ field_1de, 0x1de  # offset +0x1de
.equ field_206, 0x206  # offset +0x206
.equ field_20a, 0x20a  # offset +0x20a
.equ field_212, 0x212  # offset +0x212
.equ field_226, 0x226  # offset +0x226
.equ field_232, 0x232  # offset +0x232
.equ field_246, 0x246  # offset +0x246

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004bee2c, .text + (0x004bee2c - 0x401000)
.set FUN_004bef85, .text + (0x004bef85 - 0x401000)
.set FUN_004befc8, .text + (0x004befc8 - 0x401000)
.set FUN_004bf098, .text + (0x004bf098 - 0x401000)
.set FUN_004bf10f, .text + (0x004bf10f - 0x401000)
.set FUN_004ceb8c, .text + (0x004ceb8c - 0x401000)

.org 0x004ce8ea - 0x401000
.globl FUN_004ce8ea
FUN_004ce8ea:
    # block 0x004ce8ea: entry, 16 instruction(s), ends with je to 0x004ce92e (forward)
    push ebp                                     # 004ce8ea
    {load} mov ebp, esp                          # 004ce8eb
    sub esp, 0xc                                 # 004ce8ed
    mov dword ptr [ebp - local_8], ecx           # 004ce8f0
    mov eax, dword ptr [ebp - local_8]           # 004ce8f3
    mov ecx, dword ptr [eax + field_246]         # 004ce8f6
    imul ecx, ecx, 0x35                          # 004ce8fc
    mov edx, dword ptr [ebp - local_8]           # 004ce8ff
    mov eax, dword ptr [edx + field_226]         # 004ce902
    {load} add eax, ecx                          # 004ce908
    mov dword ptr [ebp - local_4], eax           # 004ce90a
    mov ecx, dword ptr [ebp - local_8]           # 004ce90d
    mov edx, dword ptr [ecx + field_1da]         # 004ce910
    mov dword ptr [ebp - local_c], edx           # 004ce916
    cmp dword ptr [ebp - local_c], 0x0           # 004ce919
    je.d8 L_004ce92e                             # 004ce91d
    # block 0x004ce91f: entered by fall-through of je at 0x004ce91d, 2 instruction(s), ends with je to 0x004cea43 (forward)
    cmp dword ptr [ebp - local_c], 0x4           # 004ce91f
    je.d32 L_004cea43                            # 004ce923
    # block 0x004ce929: entered by fall-through of je at 0x004ce923, 1 instruction(s), ends with forward jump to 0x004ceb37
    jmp.d32 L_004ceb37                           # 004ce929
L_004ce92e:
    # block 0x004ce92e: entered by je at 0x004ce91d, 7 instruction(s), calls FUN_004bef85, ends with je to 0x004cea3e (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ce92e
    mov ecx, dword ptr [eax + field_18e]         # 004ce931
    push ecx                                     # 004ce937
    mov ecx, 0x6201f9                            # 004ce938
    call FUN_004bef85                            # 004ce93d
    test eax, eax                                # 004ce942
    je.d32 L_004cea3e                            # 004ce944
    # block 0x004ce94a: entered by fall-through of je at 0x004ce944, 45 instruction(s), calls FUN_004befc8, FUN_004bf098, FUN_004bee2c, FUN_004ceb8c, FUN_004bf10f, ends with je to 0x004cea19 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ce94a
    mov eax, dword ptr [edx + field_18e]         # 004ce94d
    push eax                                     # 004ce953
    mov ecx, 0x6201f9                            # 004ce954
    call FUN_004befc8                            # 004ce959
    push 0x0                                     # 004ce95e
    push 0x0                                     # 004ce960
    mov ecx, dword ptr [ebp - local_8]           # 004ce962
    mov edx, dword ptr [ecx + field_212]         # 004ce965
    movsx eax, word ptr [edx + field_2d]         # 004ce96b
    push eax                                     # 004ce96f
    mov ecx, dword ptr [ebp - local_8]           # 004ce970
    mov edx, dword ptr [ecx + field_212]         # 004ce973
    movsx eax, word ptr [edx + field_2f]         # 004ce979
    push eax                                     # 004ce97d
    mov ecx, dword ptr [ebp - local_8]           # 004ce97e
    mov edx, dword ptr [ecx + field_212]         # 004ce981
    mov eax, dword ptr [edx]                     # 004ce987
    push eax                                     # 004ce989
    mov ecx, dword ptr [ebp - local_8]           # 004ce98a
    mov edx, dword ptr [ecx + field_18e]         # 004ce98d
    push edx                                     # 004ce993
    mov ecx, 0x6201f9                            # 004ce994
    call FUN_004bf098                            # 004ce999
    mov eax, dword ptr [ebp - local_8]           # 004ce99e
    mov ecx, dword ptr [eax + field_18e]         # 004ce9a1
    push ecx                                     # 004ce9a7
    mov ecx, 0x6201f9                            # 004ce9a8
    call FUN_004bee2c                            # 004ce9ad
    sub eax, 0x1                                 # 004ce9b2
    mov edx, dword ptr [ebp - local_8]           # 004ce9b5
    mov dword ptr [edx + field_232], eax         # 004ce9b8
    mov eax, dword ptr [ebp - local_8]           # 004ce9be
    mov dword ptr [eax + field_206], 0x1         # 004ce9c1
    mov ecx, dword ptr [ebp - local_8]           # 004ce9cb
    mov dword ptr [ecx + field_20a], 0x1         # 004ce9ce
    mov ecx, dword ptr [ebp - local_8]           # 004ce9d8
    call FUN_004ceb8c                            # 004ce9db
    mov edx, dword ptr [ebp - local_8]           # 004ce9e0
    mov eax, dword ptr [edx + field_18e]         # 004ce9e3
    push eax                                     # 004ce9e9
    mov ecx, 0x6201f9                            # 004ce9ea
    call FUN_004bf10f                            # 004ce9ef
    test eax, eax                                # 004ce9f4
    je.d8 L_004cea19                             # 004ce9f6
    # block 0x004ce9f8: entered by fall-through of je at 0x004ce9f6, 5 instruction(s), ends with je to 0x004cea19 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ce9f8
    movsx edx, word ptr [ecx + field_23]         # 004ce9fb
    mov eax, dword ptr [ebp - local_8]           # 004ce9ff
    cmp dword ptr [eax + field_232], edx         # 004cea02
    je.d8 L_004cea19                             # 004cea08
    # block 0x004cea0a: entered by fall-through of je at 0x004cea08, 3 instruction(s), ends with forward jump to 0x004cea3e
    mov ecx, dword ptr [ebp - local_8]           # 004cea0a
    mov dword ptr [ecx + field_1da], 0x4         # 004cea0d
    jmp.d8 L_004cea3e                            # 004cea17
L_004cea19:
    # block 0x004cea19: entered by je at 0x004ce9f6; je at 0x004cea08, 5 instruction(s), ends with je to 0x004cea3e (forward)
    mov edx, dword ptr [ebp - local_8]           # 004cea19
    mov dword ptr [edx + field_1de], 0x3         # 004cea1c
    movsx eax, word ptr [0x63a4cd]               # 004cea26
    test eax, eax                                # 004cea2d
    je.d8 L_004cea3e                             # 004cea2f
    # block 0x004cea31: entered by fall-through of je at 0x004cea2f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cea3e
    push 0x559a28                                # 004cea31
    call FUN_0044a2b7                            # 004cea36
    add esp, 0x4                                 # 004cea3b
L_004cea3e:
    # block 0x004cea3e: entered by je at 0x004ce944; jmp at 0x004cea17; je at 0x004cea2f, 1 instruction(s), ends with forward jump to 0x004ceb37
    jmp.d32 L_004ceb37                           # 004cea3e
L_004cea43:
    # block 0x004cea43: entered by je at 0x004ce923, 7 instruction(s), calls FUN_004bef85, ends with je to 0x004ceb37 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004cea43
    mov edx, dword ptr [ecx + field_18e]         # 004cea46
    push edx                                     # 004cea4c
    mov ecx, 0x6201f9                            # 004cea4d
    call FUN_004bef85                            # 004cea52
    test eax, eax                                # 004cea57
    je.d32 L_004ceb37                            # 004cea59
    # block 0x004cea5f: entered by fall-through of je at 0x004cea59, 43 instruction(s), calls FUN_004befc8, FUN_004bf098, FUN_004bee2c, FUN_004ceb8c, FUN_004bf10f, ends with je to 0x004ceb12 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004cea5f
    mov ecx, dword ptr [eax + field_18e]         # 004cea62
    push ecx                                     # 004cea68
    mov ecx, 0x6201f9                            # 004cea69
    call FUN_004befc8                            # 004cea6e
    push 0x0                                     # 004cea73
    push 0x0                                     # 004cea75
    mov edx, dword ptr [ebp - local_8]           # 004cea77
    mov eax, dword ptr [edx + field_212]         # 004cea7a
    movsx ecx, word ptr [eax + field_2d]         # 004cea80
    push ecx                                     # 004cea84
    mov edx, dword ptr [ebp - local_8]           # 004cea85
    mov eax, dword ptr [edx + field_212]         # 004cea88
    movsx ecx, word ptr [eax + field_2f]         # 004cea8e
    push ecx                                     # 004cea92
    mov edx, dword ptr [ebp - local_8]           # 004cea93
    mov eax, dword ptr [edx + field_212]         # 004cea96
    mov ecx, dword ptr [eax]                     # 004cea9c
    push ecx                                     # 004cea9e
    mov edx, dword ptr [ebp - local_8]           # 004cea9f
    mov eax, dword ptr [edx + field_18e]         # 004ceaa2
    push eax                                     # 004ceaa8
    mov ecx, 0x6201f9                            # 004ceaa9
    call FUN_004bf098                            # 004ceaae
    mov ecx, dword ptr [ebp - local_8]           # 004ceab3
    mov edx, dword ptr [ecx + field_18e]         # 004ceab6
    push edx                                     # 004ceabc
    mov ecx, 0x6201f9                            # 004ceabd
    call FUN_004bee2c                            # 004ceac2
    sub eax, 0x1                                 # 004ceac7
    mov ecx, dword ptr [ebp - local_8]           # 004ceaca
    mov dword ptr [ecx + field_232], eax         # 004ceacd
    mov edx, dword ptr [ebp - local_8]           # 004cead3
    mov dword ptr [edx + field_206], 0x1         # 004cead6
    mov ecx, dword ptr [ebp - local_8]           # 004ceae0
    call FUN_004ceb8c                            # 004ceae3
    mov eax, dword ptr [ebp - local_8]           # 004ceae8
    mov ecx, dword ptr [eax + field_18e]         # 004ceaeb
    push ecx                                     # 004ceaf1
    mov ecx, 0x6201f9                            # 004ceaf2
    call FUN_004bf10f                            # 004ceaf7
    test eax, eax                                # 004ceafc
    je.d8 L_004ceb12                             # 004ceafe
    # block 0x004ceb00: entered by fall-through of je at 0x004ceafe, 5 instruction(s), ends with jne to 0x004ceb37 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ceb00
    movsx eax, word ptr [edx + field_23]         # 004ceb03
    mov ecx, dword ptr [ebp - local_8]           # 004ceb07
    cmp dword ptr [ecx + field_232], eax         # 004ceb0a
    jne.d8 L_004ceb37                            # 004ceb10
L_004ceb12:
    # block 0x004ceb12: entered by je at 0x004ceafe; fall-through of jne at 0x004ceb10, 5 instruction(s), ends with je to 0x004ceb37 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ceb12
    mov dword ptr [edx + field_1de], 0x3         # 004ceb15
    movsx eax, word ptr [0x63a4cd]               # 004ceb1f
    test eax, eax                                # 004ceb26
    je.d8 L_004ceb37                             # 004ceb28
    # block 0x004ceb2a: entered by fall-through of je at 0x004ceb28, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ceb37
    push 0x559aa8                                # 004ceb2a
    call FUN_0044a2b7                            # 004ceb2f
    add esp, 0x4                                 # 004ceb34
L_004ceb37:
    # block 0x004ceb37: entered by jmp at 0x004ce929; jmp at 0x004cea3e; je at 0x004cea59; jne at 0x004ceb10; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ceb37
    pop ebp                                      # 004ceb39
    ret                                          # 004ceb3a

