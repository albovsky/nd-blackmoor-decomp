# FUN_004e0e2b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e0e2b
# extent:       0x004e0e2b-0x004e10ff (724 code bytes)
# span:         0x004e0e2b-0x004e1113 (code 724, tables 20, padding 0)
# sha256:       ba59dcceb0c9905743782c49af31ed2f6844594bc09533f86d8ce353340de066
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_taskbar_tick_process
# naming:       INFERRED (lower confidence, not verified): the repository text src/inventory_button_runtime.h:188 says "0x4e0e2b (with 0x4e18e5 first)."; src/blackmoor_app.mm:8867 says "End of a tick (0x43cf9c): 0x4e0e2b while 0x583204 is 0."
# name-note:    Per-tick task bar processing, run after applying the lock table with 0x4e18e5.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_74f, field_757, field_f2a; [ecx + n] field_f2a; [edi + n] field_minus_1; [edx + n] field_74f
# callees:      calls FUN_004e18e5, FUN_004c2790, FUN_004e29ec, FUN_004e2913, FUN_0050ca3e, FUN_0044a2b7, FUN_00427a40
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 178 instruction(s), 17 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_74f, 0x74f  # offset +0x74f
.equ field_757, 0x757  # offset +0x757
.equ field_f2a, 0xf2a  # offset +0xf2a

# --- external targets -----------------------------------------------
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004e18e5, .text + (0x004e18e5 - 0x401000)
.set FUN_004e2913, .text + (0x004e2913 - 0x401000)
.set FUN_004e29ec, .text + (0x004e29ec - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004e0e2b - 0x401000
.globl FUN_004e0e2b
FUN_004e0e2b:
    # block 0x004e0e2b: entry, 14 instruction(s), calls FUN_004e18e5, ends with je to 0x004e0e6b (forward)
    push ebp                                     # 004e0e2b
    {load} mov ebp, esp                          # 004e0e2c
    sub esp, 0x14                                # 004e0e2e
    push edi                                     # 004e0e31
    mov dword ptr [ebp - local_8], ecx           # 004e0e32
    mov ax, word ptr [0x5bb57b]                  # 004e0e35
    push eax                                     # 004e0e3b
    mov ecx, dword ptr [ebp - local_8]           # 004e0e3c
    call FUN_004e18e5                            # 004e0e3f
    mov ecx, dword ptr [ebp - local_8]           # 004e0e44
    mov edx, dword ptr [ecx + field_f2a]         # 004e0e47
    mov dword ptr [ebp - local_c], edx           # 004e0e4d
    cmp dword ptr [ebp - local_c], 0x0           # 004e0e50
    je.d8 L_004e0e6b                             # 004e0e54
    # block 0x004e0e56: entered by fall-through of je at 0x004e0e54, 2 instruction(s), ends with je to 0x004e0eaf (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 004e0e56
    je.d8 L_004e0eaf                             # 004e0e5a
    # block 0x004e0e5c: entered by fall-through of je at 0x004e0e5a, 2 instruction(s), ends with je to 0x004e10d7 (forward)
    cmp dword ptr [ebp - local_c], 0x2           # 004e0e5c
    je.d32 L_004e10d7                            # 004e0e60
    # block 0x004e0e66: entered by fall-through of je at 0x004e0e60, 1 instruction(s), ends with forward jump to 0x004e10fa
    jmp.d32 L_004e10fa                           # 004e0e66
L_004e0e6b:
    # block 0x004e0e6b: entered by je at 0x004e0e54, 3 instruction(s), ends with jne to 0x004e0e9d (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e0e6b
    cmp dword ptr [eax + field_74f], 0x0         # 004e0e6e
    jne.d8 L_004e0e9d                            # 004e0e75
    # block 0x004e0e77: entered by fall-through of jne at 0x004e0e75, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004e0e9d
    push 0x55bc38                                # 004e0e77
    push 0x6                                     # 004e0e7c
    mov ecx, dword ptr [ebp - local_8]           # 004e0e7e
    add ecx, 0x4                                 # 004e0e81
    push ecx                                     # 004e0e84
    push 0x55bc44                                # 004e0e85
    mov ecx, 0x5cf659                            # 004e0e8a
    call FUN_004c2790                            # 004e0e8f
    mov edx, dword ptr [ebp - local_8]           # 004e0e94
    mov dword ptr [edx + field_74f], eax         # 004e0e97
L_004e0e9d:
    # block 0x004e0e9d: entered by jne at 0x004e0e75, 3 instruction(s), ends with forward jump to 0x004e10fa
    mov eax, dword ptr [ebp - local_8]           # 004e0e9d
    mov dword ptr [eax + field_f2a], 0x1         # 004e0ea0
    jmp.d32 L_004e10fa                           # 004e0eaa
L_004e0eaf:
    # block 0x004e0eaf: entered by je at 0x004e0e5a, 2 instruction(s), ends with forward jump to 0x004e0ec1
    mov dword ptr [ebp - local_4], 0x0           # 004e0eaf
    jmp.d8 L_004e0ec1                            # 004e0eb6
L_004e0eb8:
    # block 0x004e0eb8: entered by jmp at 0x004e0edf, 3 instruction(s), falls into the block at 0x004e0ec1
    mov ecx, dword ptr [ebp - local_4]           # 004e0eb8
    add ecx, 0x1                                 # 004e0ebb
    mov dword ptr [ebp - local_4], ecx           # 004e0ebe
L_004e0ec1:
    # block 0x004e0ec1: entered by jmp at 0x004e0eb6, 2 instruction(s), ends with jge to 0x004e0ee1 (forward)
    cmp dword ptr [ebp - local_4], 0x5           # 004e0ec1
    jge.d8 L_004e0ee1                            # 004e0ec5
    # block 0x004e0ec7: entered by fall-through of jge at 0x004e0ec5, 6 instruction(s), calls FUN_004e29ec, ends with backward jump to 0x004e0eb8
    mov edx, dword ptr [ebp - local_4]           # 004e0ec7
    imul edx, edx, 0x18f                         # 004e0eca
    mov eax, dword ptr [ebp - local_8]           # 004e0ed0
    lea ecx, [eax + edx + field_757]             # 004e0ed3
    call FUN_004e29ec                            # 004e0eda
    jmp.d8 L_004e0eb8                            # 004e0edf
L_004e0ee1:
    # block 0x004e0ee1: entered by jge at 0x004e0ec5, 7 instruction(s), ends with forward jump to 0x004e0f16
    mov byte ptr [0x583220], 0x0                 # 004e0ee1
    mov byte ptr [0x583232], 0x0                 # 004e0ee8
    mov byte ptr [0x583233], 0x0                 # 004e0eef
    mov byte ptr [0x583234], 0x0                 # 004e0ef6
    mov byte ptr [0x58321f], 0x0                 # 004e0efd
    mov dword ptr [ebp - local_4], 0x0           # 004e0f04
    jmp.d8 L_004e0f16                            # 004e0f0b
L_004e0f0d:
    # block 0x004e0f0d: entered by jmp at 0x004e10d0, 3 instruction(s), falls into the block at 0x004e0f16
    mov ecx, dword ptr [ebp - local_4]           # 004e0f0d
    add ecx, 0x1                                 # 004e0f10
    mov dword ptr [ebp - local_4], ecx           # 004e0f13
L_004e0f16:
    # block 0x004e0f16: entered by jmp at 0x004e0f0b, 2 instruction(s), ends with jge to 0x004e10d5 (forward)
    cmp dword ptr [ebp - local_4], 0x5           # 004e0f16
    jge.d32 L_004e10d5                           # 004e0f1a
    # block 0x004e0f20: entered by fall-through of jge at 0x004e0f1a, 7 instruction(s), calls FUN_004e2913, ends with je to 0x004e10d0 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e0f20
    imul edx, edx, 0x18f                         # 004e0f23
    mov eax, dword ptr [ebp - local_8]           # 004e0f29
    lea ecx, [eax + edx + field_757]             # 004e0f2c
    call FUN_004e2913                            # 004e0f33
    test eax, eax                                # 004e0f38
    je.d32 L_004e10d0                            # 004e0f3a
    # block 0x004e0f40: entered by fall-through of je at 0x004e0f3a, 5 instruction(s), ends with ja to 0x004e1046 (forward)
    mov byte ptr [0x63888b], 0x0                 # 004e0f40
    mov ecx, dword ptr [ebp - local_4]           # 004e0f47
    mov dword ptr [ebp - local_10], ecx          # 004e0f4a
    cmp dword ptr [ebp - local_10], 0x4          # 004e0f4d
    ja.d32 L_004e1046                            # 004e0f51
    # block 0x004e0f57: entered by fall-through of ja at 0x004e0f51, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4e10ff]
    mov edx, dword ptr [ebp - local_10]          # 004e0f57
    jmp dword ptr [4*edx + SWTAB_004e10ff_VA]    # 004e0f5a
L_004e0f61:
    # block 0x004e0f61: entered by switch case, 4 instruction(s), ends with je to 0x004e0f8c (forward)
    mov byte ptr [0x583220], 0x1                 # 004e0f61
    movsx eax, word ptr [0x63a4cd]               # 004e0f68
    test eax, eax                                # 004e0f6f
    je.d8 L_004e0f8c                             # 004e0f71
    # block 0x004e0f73: entered by fall-through of je at 0x004e0f71, 6 instruction(s), calls FUN_0050ca3e, falls into the block at 0x004e0f8c
    mov ecx, dword ptr [0x5bb57b]                # 004e0f73
    push ecx                                     # 004e0f79
    push 0x55bc4c                                # 004e0f7a
    push 0x63888b                                # 004e0f7f
    call FUN_0050ca3e                            # 004e0f84
    add esp, 0xc                                 # 004e0f89
L_004e0f8c:
    # block 0x004e0f8c: entered by je at 0x004e0f71, 1 instruction(s), ends with forward jump to 0x004e106a
    jmp.d32 L_004e106a                           # 004e0f8c
L_004e0f91:
    # block 0x004e0f91: entered by switch case, 4 instruction(s), ends with je to 0x004e0fbb (forward)
    mov byte ptr [0x583232], 0x1                 # 004e0f91
    movsx edx, word ptr [0x63a4cd]               # 004e0f98
    test edx, edx                                # 004e0f9f
    je.d8 L_004e0fbb                             # 004e0fa1
    # block 0x004e0fa3: entered by fall-through of je at 0x004e0fa1, 6 instruction(s), calls FUN_0050ca3e, falls into the block at 0x004e0fbb
    mov eax, dword ptr [0x5bb57b]                # 004e0fa3
    push eax                                     # 004e0fa8
    push 0x55bc94                                # 004e0fa9
    push 0x63888b                                # 004e0fae
    call FUN_0050ca3e                            # 004e0fb3
    add esp, 0xc                                 # 004e0fb8
L_004e0fbb:
    # block 0x004e0fbb: entered by je at 0x004e0fa1, 1 instruction(s), ends with forward jump to 0x004e106a
    jmp.d32 L_004e106a                           # 004e0fbb
L_004e0fc0:
    # block 0x004e0fc0: entered by switch case, 4 instruction(s), ends with je to 0x004e0feb (forward)
    mov byte ptr [0x583233], 0x1                 # 004e0fc0
    movsx ecx, word ptr [0x63a4cd]               # 004e0fc7
    test ecx, ecx                                # 004e0fce
    je.d8 L_004e0feb                             # 004e0fd0
    # block 0x004e0fd2: entered by fall-through of je at 0x004e0fd0, 6 instruction(s), calls FUN_0050ca3e, falls into the block at 0x004e0feb
    mov edx, dword ptr [0x5bb57b]                # 004e0fd2
    push edx                                     # 004e0fd8
    push 0x55bce0                                # 004e0fd9
    push 0x63888b                                # 004e0fde
    call FUN_0050ca3e                            # 004e0fe3
    add esp, 0xc                                 # 004e0fe8
L_004e0feb:
    # block 0x004e0feb: entered by je at 0x004e0fd0, 1 instruction(s), ends with forward jump to 0x004e106a
    jmp.d8 L_004e106a                            # 004e0feb
L_004e0fed:
    # block 0x004e0fed: entered by switch case, 4 instruction(s), ends with je to 0x004e1018 (forward)
    mov byte ptr [0x583234], 0x1                 # 004e0fed
    movsx eax, word ptr [0x63a4cd]               # 004e0ff4
    test eax, eax                                # 004e0ffb
    je.d8 L_004e1018                             # 004e0ffd
    # block 0x004e0fff: entered by fall-through of je at 0x004e0ffd, 6 instruction(s), calls FUN_0050ca3e, falls into the block at 0x004e1018
    mov ecx, dword ptr [0x5bb57b]                # 004e0fff
    push ecx                                     # 004e1005
    push 0x55bd2c                                # 004e1006
    push 0x63888b                                # 004e100b
    call FUN_0050ca3e                            # 004e1010
    add esp, 0xc                                 # 004e1015
L_004e1018:
    # block 0x004e1018: entered by je at 0x004e0ffd, 1 instruction(s), ends with forward jump to 0x004e106a
    jmp.d8 L_004e106a                            # 004e1018
L_004e101a:
    # block 0x004e101a: entered by switch case, 4 instruction(s), ends with je to 0x004e1044 (forward)
    mov byte ptr [0x58321f], 0x1                 # 004e101a
    movsx edx, word ptr [0x63a4cd]               # 004e1021
    test edx, edx                                # 004e1028
    je.d8 L_004e1044                             # 004e102a
    # block 0x004e102c: entered by fall-through of je at 0x004e102a, 6 instruction(s), calls FUN_0050ca3e, falls into the block at 0x004e1044
    mov eax, dword ptr [0x5bb57b]                # 004e102c
    push eax                                     # 004e1031
    push 0x55bd78                                # 004e1032
    push 0x63888b                                # 004e1037
    call FUN_0050ca3e                            # 004e103c
    add esp, 0xc                                 # 004e1041
L_004e1044:
    # block 0x004e1044: entered by je at 0x004e102a, 1 instruction(s), ends with forward jump to 0x004e106a
    jmp.d8 L_004e106a                            # 004e1044
L_004e1046:
    # block 0x004e1046: entered by ja at 0x004e0f51, 3 instruction(s), ends with je to 0x004e106a (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004e1046
    test ecx, ecx                                # 004e104d
    je.d8 L_004e106a                             # 004e104f
    # block 0x004e1051: entered by fall-through of je at 0x004e104f, 6 instruction(s), calls FUN_0050ca3e, falls into the block at 0x004e106a
    mov edx, dword ptr [0x5bb57b]                # 004e1051
    push edx                                     # 004e1057
    push 0x55bdbc                                # 004e1058
    push 0x63888b                                # 004e105d
    call FUN_0050ca3e                            # 004e1062
    add esp, 0xc                                 # 004e1067
L_004e106a:
    # block 0x004e106a: entered by jmp at 0x004e0f8c; jmp at 0x004e0fbb; jmp at 0x004e0feb; jmp at 0x004e1018; more, 3 instruction(s), ends with je to 0x004e10d0 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004e106a
    test eax, eax                                # 004e1071
    je.d8 L_004e10d0                             # 004e1073
    # block 0x004e1075: entered by fall-through of je at 0x004e1073, 8 instruction(s), ends with je to 0x004e10d0 (forward)
    mov edi, 0x63888b                            # 004e1075
    or ecx, -0x1                                 # 004e107a
    {load} xor eax, eax                          # 004e107d
    repne scasb al, byte ptr es:[edi]            # 004e107f
    not ecx                                      # 004e1081
    add ecx, -0x1                                # 004e1083
    test ecx, ecx                                # 004e1086
    je.d8 L_004e10d0                             # 004e1088
    # block 0x004e108a: entered by fall-through of je at 0x004e1088, 12 instruction(s), calls FUN_0044a2b7, ends with je to 0x004e10c0 (forward)
    push 0x63888b                                # 004e108a
    call FUN_0044a2b7                            # 004e108f
    add esp, 0x4                                 # 004e1094
    mov edi, 0x63888b                            # 004e1097
    or ecx, -0x1                                 # 004e109c
    {load} xor eax, eax                          # 004e109f
    repne scasb al, byte ptr es:[edi]            # 004e10a1
    mov cx, word ptr [0x55be08]                  # 004e10a3
    mov word ptr [edi - field_minus_1], cx       # 004e10aa
    mov edx, 0x1                                 # 004e10ae
    test edx, edx                                # 004e10b3
    je.d8 L_004e10c0                             # 004e10b5
    # block 0x004e10b7: entered by fall-through of je at 0x004e10b5, 2 instruction(s), ends with forward jump to 0x004e10d0
    mov dword ptr [ebp - local_14], 0x0          # 004e10b7
    jmp.d8 L_004e10d0                            # 004e10be
L_004e10c0:
    # block 0x004e10c0: entered by je at 0x004e10b5, 4 instruction(s), calls FUN_00427a40, falls into the block at 0x004e10d0
    push 0x63888b                                # 004e10c0
    call FUN_00427a40                            # 004e10c5
    add esp, 0x4                                 # 004e10ca
    mov dword ptr [ebp - local_14], eax          # 004e10cd
L_004e10d0:
    # block 0x004e10d0: entered by je at 0x004e0f3a; je at 0x004e1073; je at 0x004e1088; jmp at 0x004e10be, 1 instruction(s), ends with backward jump to 0x004e0f0d
    jmp.d32 L_004e0f0d                           # 004e10d0
L_004e10d5:
    # block 0x004e10d5: entered by jge at 0x004e0f1a, 1 instruction(s), ends with forward jump to 0x004e10fa
    jmp.d8 L_004e10fa                            # 004e10d5
L_004e10d7:
    # block 0x004e10d7: entered by je at 0x004e0e60, 5 instruction(s), falls into the block at 0x004e10fa
    mov byte ptr [0x583220], 0x0                 # 004e10d7
    mov byte ptr [0x583232], 0x0                 # 004e10de
    mov byte ptr [0x583233], 0x0                 # 004e10e5
    mov byte ptr [0x583234], 0x0                 # 004e10ec
    mov byte ptr [0x58321f], 0x0                 # 004e10f3
L_004e10fa:
    # block 0x004e10fa: entered by jmp at 0x004e0e66; jmp at 0x004e0eaa; jmp at 0x004e10d5, 4 instruction(s), ends with ret
    pop edi                                      # 004e10fa
    {load} mov esp, ebp                          # 004e10fb
    pop ebp                                      # 004e10fd
    ret                                          # 004e10fe

# --- data items (not part of the function) -------------------------
.org 0x004e10ff - 0x401000
SWTAB_004e10ff:  # 5 case address(es)
    .long L_004e0f61 - .text + 0x401000
    .long L_004e0f91 - .text + 0x401000
    .long L_004e0fc0 - .text + 0x401000
    .long L_004e0fed - .text + 0x401000
    .long L_004e101a - .text + 0x401000
.set SWTAB_004e10ff_VA, SWTAB_004e10ff - .text + 0x401000

