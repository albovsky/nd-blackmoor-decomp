# FUN_00483fb5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00483fb5
# extent:       0x00483fb5-0x004840d9 (292 code bytes)
# span:         0x00483fb5-0x004840d9 (code 292, tables 0, padding 0)
# sha256:       711a0b51a366e8e3159629aa7186ac2d530bf8f385202de40b8657b0c9bf9413
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m483fb5_release_all
# naming:       native port src/original_methods_fl20a.c:m483fb5_release_all (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m483fb5_release_all. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 292 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_22, field_24, field_28; [ecx + n] field_1c, field_24; [edx + n] field_1c, field_1e, field_22, field_28
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_00483f6a
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.h:ea_cleanup (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 81 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_00483f6a, .text + (0x00483f6a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00483fb5 - 0x401000
.globl FUN_00483fb5
FUN_00483fb5:
    # block 0x00483fb5: entry, 7 instruction(s), ends with je to 0x00483fe2 (forward)
    push ebp                                     # 00483fb5
    {load} mov ebp, esp                          # 00483fb6
    sub esp, 0xc                                 # 00483fb8
    mov dword ptr [ebp - local_c], ecx           # 00483fbb
    mov eax, dword ptr [ebp - local_c]           # 00483fbe
    cmp dword ptr [eax + field_1e], 0x0          # 00483fc1
    je.d8 L_00483fe2                             # 00483fc5
    # block 0x00483fc7: entered by fall-through of je at 0x00483fc5, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00483fe2
    mov ecx, dword ptr [ebp - local_c]           # 00483fc7
    add ecx, 0x1e                                # 00483fca
    push ecx                                     # 00483fcd
    mov ecx, 0x5cf659                            # 00483fce
    call FUN_004c2dfb                            # 00483fd3
    mov edx, dword ptr [ebp - local_c]           # 00483fd8
    mov dword ptr [edx + field_1e], 0x0          # 00483fdb
L_00483fe2:
    # block 0x00483fe2: entered by je at 0x00483fc5, 3 instruction(s), ends with je to 0x00484006 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00483fe2
    cmp dword ptr [eax + field_22], 0x0          # 00483fe5
    je.d8 L_00484006                             # 00483fe9
    # block 0x00483feb: entered by fall-through of je at 0x00483fe9, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00484006
    mov ecx, dword ptr [ebp - local_c]           # 00483feb
    add ecx, 0x22                                # 00483fee
    push ecx                                     # 00483ff1
    mov ecx, 0x5cf659                            # 00483ff2
    call FUN_004c2dfb                            # 00483ff7
    mov edx, dword ptr [ebp - local_c]           # 00483ffc
    mov dword ptr [edx + field_22], 0x0          # 00483fff
L_00484006:
    # block 0x00484006: entered by je at 0x00483fe9, 2 instruction(s), ends with forward jump to 0x0048401a
    mov word ptr [ebp - local_8], 0x0            # 00484006
    jmp.d8 L_0048401a                            # 0048400c
L_0048400e:
    # block 0x0048400e: entered by jmp at 0x004840ac, 3 instruction(s), falls into the block at 0x0048401a
    mov ax, word ptr [ebp - local_8]             # 0048400e
    .insn 0x66, 0x05, 0x0001{:u16}               # 00484012
    mov word ptr [ebp - local_8], ax             # 00484016
L_0048401a:
    # block 0x0048401a: entered by jmp at 0x0048400c, 3 instruction(s), ends with jge to 0x004840b1 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0048401a
    cmp ecx, 0x14                                # 0048401e
    jge.d32 L_004840b1                           # 00484021
    # block 0x00484027: entered by fall-through of jge at 0x00484021, 2 instruction(s), ends with forward jump to 0x0048403b
    mov word ptr [ebp - local_4], 0x0            # 00484027
    jmp.d8 L_0048403b                            # 0048402d
L_0048402f:
    # block 0x0048402f: entered by jmp at 0x004840aa, 3 instruction(s), falls into the block at 0x0048403b
    mov dx, word ptr [ebp - local_4]             # 0048402f
    add dx, 0x1                                  # 00484033
    mov word ptr [ebp - local_4], dx             # 00484037
L_0048403b:
    # block 0x0048403b: entered by jmp at 0x0048402d, 3 instruction(s), ends with jge to 0x004840ac (forward)
    movsx eax, word ptr [ebp - local_4]          # 0048403b
    cmp eax, 0x4                                 # 0048403f
    jge.d8 L_004840ac                            # 00484042
    # block 0x00484044: entered by fall-through of jge at 0x00484042, 8 instruction(s), ends with je to 0x004840aa (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00484044
    imul ecx, ecx, 0x85                          # 00484048
    mov edx, dword ptr [ebp - local_c]           # 0048404e
    lea eax, [edx + ecx + field_28]              # 00484051
    movsx ecx, word ptr [ebp - local_4]          # 00484055
    imul ecx, ecx, 0x18                          # 00484059
    cmp dword ptr [eax + ecx + field_24], 0x0    # 0048405c
    je.d8 L_004840aa                             # 00484061
    # block 0x00484063: entered by fall-through of je at 0x00484061, 17 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004840aa
    movsx edx, word ptr [ebp - local_8]          # 00484063
    imul edx, edx, 0x85                          # 00484067
    mov eax, dword ptr [ebp - local_c]           # 0048406d
    lea ecx, [eax + edx + field_28]              # 00484070
    movsx edx, word ptr [ebp - local_4]          # 00484074
    imul edx, edx, 0x18                          # 00484078
    lea eax, [ecx + edx + field_24]              # 0048407b
    push eax                                     # 0048407f
    mov ecx, 0x5cf659                            # 00484080
    call FUN_004c2dfb                            # 00484085
    movsx ecx, word ptr [ebp - local_8]          # 0048408a
    imul ecx, ecx, 0x85                          # 0048408e
    mov edx, dword ptr [ebp - local_c]           # 00484094
    lea eax, [edx + ecx + field_28]              # 00484097
    movsx ecx, word ptr [ebp - local_4]          # 0048409b
    imul ecx, ecx, 0x18                          # 0048409f
    mov dword ptr [eax + ecx + field_24], 0x0    # 004840a2
L_004840aa:
    # block 0x004840aa: entered by je at 0x00484061, 1 instruction(s), ends with backward jump to 0x0048402f
    jmp.d8 L_0048402f                            # 004840aa
L_004840ac:
    # block 0x004840ac: entered by jge at 0x00484042, 1 instruction(s), ends with backward jump to 0x0048400e
    jmp.d32 L_0048400e                           # 004840ac
L_004840b1:
    # block 0x004840b1: entered by jge at 0x00484021, 4 instruction(s), ends with je to 0x004840cd (forward)
    mov edx, dword ptr [ebp - local_c]           # 004840b1
    movsx eax, word ptr [edx + field_1c]         # 004840b4
    cmp eax, -0x1                                # 004840b8
    je.d8 L_004840cd                             # 004840bb
    # block 0x004840bd: entered by fall-through of je at 0x004840bb, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004840cd
    mov ecx, dword ptr [ebp - local_c]           # 004840bd
    mov dx, word ptr [ecx + field_1c]            # 004840c0
    push edx                                     # 004840c4
    call FUN_004d3992                            # 004840c5
    add esp, 0x4                                 # 004840ca
L_004840cd:
    # block 0x004840cd: entered by je at 0x004840bb, 5 instruction(s), calls FUN_00483f6a, ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 004840cd
    call FUN_00483f6a                            # 004840d0
    {load} mov esp, ebp                          # 004840d5
    pop ebp                                      # 004840d7
    ret                                          # 004840d8

