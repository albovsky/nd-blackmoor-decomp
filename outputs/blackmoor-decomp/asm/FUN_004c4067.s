# FUN_004c4067
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c4067
# extent:       0x004c4067-0x004c4202 (411 code bytes)
# span:         0x004c4067-0x004c4202 (code 411, tables 0, padding 0)
# sha256:       c3d39e5d72ef0f3d77a8eeac83b406cebd9049de3eec1ea559386293f0651df1
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_surface_lock_descriptor
# naming:       INFERRED (lower confidence, not verified): the repository text src/original_methods_fl27b.h:92 says "0x4c4067(this self, idx, r2, &desc, arg, 0x20) fills the local descriptor desc"; tasks/RT-32-screen-file-94-runtime.md:11 says "the front-buffer lock `0x4c4067`"
# name-note:    Surface lock: fills a local surface descriptor (destination stride and base address); the front-buffer lock.
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_1c, field_64; [ecx + n] field_4, field_8, field_c, field_1c, field_20, field_42; [edx + n] field_4, field_14, field_18, field_1a, field_24, field_64
# callees:      calls FUN_004c4dc3, FUN_004c88c7, FUN_0050ca3e, FUN_004264e8; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27b.c:m4c5377_blit_rows (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 137 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ arg_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ arg_18, 0x18  # offset +0x18
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_42, 0x42  # offset +0x42
.equ field_64, 0x64  # offset +0x64

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004c4dc3, .text + (0x004c4dc3 - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004c4067 - 0x401000
.globl FUN_004c4067
FUN_004c4067:
    # block 0x004c4067: entry, 10 instruction(s), ends with jne to 0x004c4143 (forward)
    push ebp                                     # 004c4067
    {load} mov ebp, esp                          # 004c4068
    sub esp, 0x8                                 # 004c406a
    push esi                                     # 004c406d
    push edi                                     # 004c406e
    mov dword ptr [ebp - local_8], ecx           # 004c406f
    mov eax, dword ptr [ebp - local_8]           # 004c4072
    mov ecx, dword ptr [ebp + arg_8]             # 004c4075
    cmp ecx, dword ptr [eax + field_c]           # 004c4078
    jne.d32 L_004c4143                           # 004c407b
    # block 0x004c4081: entered by fall-through of jne at 0x004c407b, 2 instruction(s), ends with je to 0x004c408d (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c4081
    je.d8 L_004c408d                             # 004c4085
    # block 0x004c4087: entered by fall-through of je at 0x004c4085, 2 instruction(s), ends with jne to 0x004c40b5 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c4087
    jne.d8 L_004c40b5                            # 004c408b
L_004c408d:
    # block 0x004c408d: entered by je at 0x004c4085; fall-through of jne at 0x004c408b, 13 instruction(s), ends with forward jump to 0x004c410a
    mov edx, dword ptr [ebp + arg_10]            # 004c408d
    mov eax, dword ptr [ebp - local_8]           # 004c4090
    mov ecx, dword ptr [eax + field_14]          # 004c4093
    mov dword ptr [edx + field_24], ecx          # 004c4096
    mov edx, dword ptr [ebp - local_8]           # 004c4099
    movsx eax, word ptr [edx + field_1a]         # 004c409c
    mov ecx, dword ptr [ebp + arg_10]            # 004c40a0
    mov dword ptr [ecx + field_8], eax           # 004c40a3
    mov edx, dword ptr [ebp - local_8]           # 004c40a6
    movsx eax, word ptr [edx + field_18]         # 004c40a9
    mov ecx, dword ptr [ebp + arg_10]            # 004c40ad
    mov dword ptr [ecx + field_c], eax           # 004c40b0
    jmp.d8 L_004c410a                            # 004c40b3
L_004c40b5:
    # block 0x004c40b5: entered by jne at 0x004c408b, 29 instruction(s), falls into the block at 0x004c410a
    mov edx, dword ptr [ebp + arg_c]             # 004c40b5
    mov eax, dword ptr [ebp - local_8]           # 004c40b8
    mov ecx, dword ptr [edx + field_4]           # 004c40bb
    imul ecx, dword ptr [eax + field_1c]         # 004c40be
    mov edx, dword ptr [ebp - local_8]           # 004c40c2
    mov eax, dword ptr [edx + field_14]          # 004c40c5
    {load} add eax, ecx                          # 004c40c8
    mov ecx, dword ptr [ebp - local_8]           # 004c40ca
    movsx edx, word ptr [ecx + field_20]         # 004c40cd
    mov ecx, dword ptr [ebp + arg_c]             # 004c40d1
    mov ecx, dword ptr [ecx]                     # 004c40d4
    imul ecx, edx                                # 004c40d6
    {load} add eax, ecx                          # 004c40d9
    mov edx, dword ptr [ebp + arg_10]            # 004c40db
    mov dword ptr [edx + field_24], eax          # 004c40de
    mov eax, dword ptr [ebp + arg_c]             # 004c40e1
    mov ecx, dword ptr [ebp + arg_c]             # 004c40e4
    mov edx, dword ptr [eax + field_c]           # 004c40e7
    sub edx, dword ptr [ecx + field_4]           # 004c40ea
    add edx, 0x1                                 # 004c40ed
    mov eax, dword ptr [ebp + arg_10]            # 004c40f0
    mov dword ptr [eax + field_8], edx           # 004c40f3
    mov ecx, dword ptr [ebp + arg_c]             # 004c40f6
    mov edx, dword ptr [ebp + arg_c]             # 004c40f9
    mov eax, dword ptr [ecx + field_8]           # 004c40fc
    sub eax, dword ptr [edx]                     # 004c40ff
    add eax, 0x1                                 # 004c4101
    mov ecx, dword ptr [ebp + arg_10]            # 004c4104
    mov dword ptr [ecx + field_c], eax           # 004c4107
L_004c410a:
    # block 0x004c410a: entered by jmp at 0x004c40b3, 17 instruction(s), ends with forward jump to 0x004c41fa
    mov edx, dword ptr [ebp + arg_10]            # 004c410a
    mov dword ptr [edx], 0x6c                    # 004c410d
    mov eax, dword ptr [ebp + arg_10]            # 004c4113
    mov ecx, dword ptr [ebp - local_8]           # 004c4116
    mov edx, dword ptr [ecx + field_42]          # 004c4119
    mov dword ptr [eax + field_4], edx           # 004c411c
    mov eax, dword ptr [ebp + arg_10]            # 004c411f
    mov ecx, dword ptr [ebp - local_8]           # 004c4122
    mov edx, dword ptr [ecx + field_1c]          # 004c4125
    mov dword ptr [eax + field_10], edx          # 004c4128
    mov esi, dword ptr [ebp - local_8]           # 004c412b
    add esi, 0x22                                # 004c412e
    mov edi, dword ptr [ebp + arg_10]            # 004c4131
    add edi, 0x48                                # 004c4134
    mov ecx, 0x8                                 # 004c4137
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c413c
    jmp.d32 L_004c41fa                           # 004c413e
L_004c4143:
    # block 0x004c4143: entered by jne at 0x004c407b, 2 instruction(s), falls into the block at 0x004c414c
    mov eax, dword ptr [ebp + arg_10]            # 004c4143
    mov dword ptr [eax], 0x6c                    # 004c4146
L_004c414c:
    # block 0x004c414c: entered by jmp at 0x004c41f5, 3 instruction(s), ends with je to 0x004c41fa (forward)
    mov ecx, 0x1                                 # 004c414c
    test ecx, ecx                                # 004c4151
    je.d32 L_004c41fa                            # 004c4153
    # block 0x004c4159: entered by fall-through of je at 0x004c4153, 2 instruction(s), ends with je to 0x004c4181 (forward)
    cmp dword ptr [ebp + arg_18], 0x0            # 004c4159
    je.d8 L_004c4181                             # 004c415d
    # block 0x004c415f: entered by fall-through of je at 0x004c415d, 15 instruction(s), calls indirect dword ptr [eax + 0x64], ends with forward jump to 0x004c419f
    push 0x0                                     # 004c415f
    mov edx, dword ptr [ebp + arg_18]            # 004c4161
    or dh, 0x8                                   # 004c4164
    push edx                                     # 004c4167
    mov eax, dword ptr [ebp + arg_10]            # 004c4168
    push eax                                     # 004c416b
    mov ecx, dword ptr [ebp + arg_c]             # 004c416c
    push ecx                                     # 004c416f
    mov edx, dword ptr [ebp + arg_8]             # 004c4170
    mov eax, dword ptr [edx]                     # 004c4173
    mov ecx, dword ptr [ebp + arg_8]             # 004c4175
    push ecx                                     # 004c4178
    call dword ptr [eax + field_64]              # 004c4179
    mov dword ptr [ebp - local_4], eax           # 004c417c
    jmp.d8 L_004c419f                            # 004c417f
L_004c4181:
    # block 0x004c4181: entered by je at 0x004c415d, 12 instruction(s), calls indirect dword ptr [edx + 0x64], falls into the block at 0x004c419f
    push 0x0                                     # 004c4181
    push 0x800                                   # 004c4183
    mov edx, dword ptr [ebp + arg_10]            # 004c4188
    push edx                                     # 004c418b
    mov eax, dword ptr [ebp + arg_c]             # 004c418c
    push eax                                     # 004c418f
    mov ecx, dword ptr [ebp + arg_8]             # 004c4190
    mov edx, dword ptr [ecx]                     # 004c4193
    mov eax, dword ptr [ebp + arg_8]             # 004c4195
    push eax                                     # 004c4198
    call dword ptr [edx + field_64]              # 004c4199
    mov dword ptr [ebp - local_4], eax           # 004c419c
L_004c419f:
    # block 0x004c419f: entered by jmp at 0x004c417f, 2 instruction(s), ends with jne to 0x004c41a7 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004c419f
    jne.d8 L_004c41a7                            # 004c41a3
    # block 0x004c41a5: entered by fall-through of jne at 0x004c41a3, 1 instruction(s), ends with forward jump to 0x004c41fa
    jmp.d8 L_004c41fa                            # 004c41a5
L_004c41a7:
    # block 0x004c41a7: entered by jne at 0x004c41a3, 2 instruction(s), ends with jne to 0x004c41ba (forward)
    cmp dword ptr [ebp - local_4], 0x887601c2    # 004c41a7
    jne.d8 L_004c41ba                            # 004c41ae
    # block 0x004c41b0: entered by fall-through of jne at 0x004c41ae, 3 instruction(s), calls FUN_004c4dc3, ends with forward jump to 0x004c41f5
    mov ecx, dword ptr [ebp - local_8]           # 004c41b0
    call FUN_004c4dc3                            # 004c41b3
    jmp.d8 L_004c41f5                            # 004c41b8
L_004c41ba:
    # block 0x004c41ba: entered by jne at 0x004c41ae, 2 instruction(s), ends with je to 0x004c41f5 (forward)
    cmp dword ptr [ebp - local_4], 0x8876021c    # 004c41ba
    je.d8 L_004c41f5                             # 004c41c1
    # block 0x004c41c3: entered by fall-through of je at 0x004c41c1, 14 instruction(s), calls FUN_004c88c7, FUN_0050ca3e, FUN_004264e8, falls into the block at 0x004c41f5
    mov ecx, dword ptr [ebp - local_4]           # 004c41c3
    push ecx                                     # 004c41c6
    mov ecx, dword ptr [ebp - local_8]           # 004c41c7
    call FUN_004c88c7                            # 004c41ca
    push eax                                     # 004c41cf
    mov edx, dword ptr [ebp + arg_14]            # 004c41d0
    push edx                                     # 004c41d3
    push 0x5543ac                                # 004c41d4
    push 0x63888b                                # 004c41d9
    call FUN_0050ca3e                            # 004c41de
    add esp, 0x10                                # 004c41e3
    push 0x63888b                                # 004c41e6
    mov ecx, 0x583979                            # 004c41eb
    call FUN_004264e8                            # 004c41f0
L_004c41f5:
    # block 0x004c41f5: entered by jmp at 0x004c41b8; je at 0x004c41c1, 1 instruction(s), ends with backward jump to 0x004c414c
    jmp.d32 L_004c414c                           # 004c41f5
L_004c41fa:
    # block 0x004c41fa: entered by jmp at 0x004c413e; je at 0x004c4153; jmp at 0x004c41a5, 5 instruction(s), ends with ret 0x14
    pop edi                                      # 004c41fa
    pop esi                                      # 004c41fb
    {load} mov esp, ebp                          # 004c41fc
    pop ebp                                      # 004c41fe
    ret 0x14                                     # 004c41ff

