# FUN_0041fa11
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041fa11
# extent:       0x0041fa11-0x0041fd08 (759 code bytes)
# span:         0x0041fa11-0x0041fd08 (code 759, tables 0, padding 0)
# sha256:       f809abda9a9f9d10ce6ac69ad5244e04b5811b6e8a8c1167ca43a3d83deceba9
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041fa11
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1b8, field_1c4, field_1cf, field_7fc, field_800, field_80a, field_80e, field_ea5, field_f21; [ecx + n] field_1ba, field_1be, field_1c8, field_1cc, field_7fe, field_802, field_810, field_ea5, field_f21; [edx + n] field_1bc, field_1c0, field_1ce, field_7d9, field_7fa, field_806, field_811, field_f21
# callees:      calls FUN_0050ca3e, FUN_004264e8, FUN_0051ea75, FUN_0050d550, FUN_0051eac4
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:add_response (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 188 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_1b8, 0x1b8  # offset +0x1b8
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_1bc, 0x1bc  # offset +0x1bc
.equ field_1be, 0x1be  # offset +0x1be
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_1c8, 0x1c8  # offset +0x1c8
.equ field_1cc, 0x1cc  # offset +0x1cc
.equ field_1ce, 0x1ce  # offset +0x1ce
.equ field_1cf, 0x1cf  # offset +0x1cf
.equ field_7d9, 0x7d9  # offset +0x7d9
.equ field_7fa, 0x7fa  # offset +0x7fa
.equ field_7fc, 0x7fc  # offset +0x7fc
.equ field_7fe, 0x7fe  # offset +0x7fe
.equ field_800, 0x800  # offset +0x800
.equ field_802, 0x802  # offset +0x802
.equ field_806, 0x806  # offset +0x806
.equ field_80a, 0x80a  # offset +0x80a
.equ field_80e, 0x80e  # offset +0x80e
.equ field_810, 0x810  # offset +0x810
.equ field_811, 0x811  # offset +0x811
.equ field_ea5, 0xea5  # offset +0xea5
.equ field_f21, 0xf21  # offset +0xf21

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050d550, .text + (0x0050d550 - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)

.org 0x0041fa11 - 0x401000
.globl FUN_0041fa11
FUN_0041fa11:
    # block 0x0041fa11: entry, 9 instruction(s), ends with je to 0x0041fa68 (forward)
    push ebp                                     # 0041fa11
    {load} mov ebp, esp                          # 0041fa12
    sub esp, 0xc                                 # 0041fa14
    push esi                                     # 0041fa17
    push edi                                     # 0041fa18
    mov dword ptr [ebp - local_c], ecx           # 0041fa19
    movsx eax, word ptr [0x63a4cd]               # 0041fa1c
    test eax, eax                                # 0041fa23
    je.d8 L_0041fa68                             # 0041fa25
    # block 0x0041fa27: entered by fall-through of je at 0x0041fa25, 5 instruction(s), ends with jle to 0x0041fa68 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0041fa27
    movsx edx, word ptr [ecx + field_f21]        # 0041fa2a
    add edx, 0x1                                 # 0041fa31
    cmp edx, 0x1e                                # 0041fa34
    jle.d8 L_0041fa68                            # 0041fa37
    # block 0x0041fa39: entered by fall-through of jle at 0x0041fa37, 11 instruction(s), calls FUN_0050ca3e, FUN_004264e8, falls into the block at 0x0041fa68
    mov eax, dword ptr [ebp - local_c]           # 0041fa39
    movsx ecx, word ptr [eax + field_f21]        # 0041fa3c
    add ecx, 0x1                                 # 0041fa43
    push ecx                                     # 0041fa46
    push 0x543a58                                # 0041fa47
    push 0x63888b                                # 0041fa4c
    call FUN_0050ca3e                            # 0041fa51
    add esp, 0xc                                 # 0041fa56
    push 0x63888b                                # 0041fa59
    mov ecx, 0x583979                            # 0041fa5e
    call FUN_004264e8                            # 0041fa63
L_0041fa68:
    # block 0x0041fa68: entered by je at 0x0041fa25; jle at 0x0041fa37, 5 instruction(s), ends with jg to 0x0041fd00 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0041fa68
    movsx eax, word ptr [edx + field_f21]        # 0041fa6b
    add eax, 0x1                                 # 0041fa72
    cmp eax, 0x1e                                # 0041fa75
    jg.d32 L_0041fd00                            # 0041fa78
    # block 0x0041fa7e: entered by fall-through of jg at 0x0041fa78, 2 instruction(s), ends with forward jump to 0x0041fa92
    mov word ptr [ebp - local_4], 0x0            # 0041fa7e
    jmp.d8 L_0041fa92                            # 0041fa84
L_0041fa86:
    # block 0x0041fa86: entered by jmp at 0x0041fb0a, 3 instruction(s), falls into the block at 0x0041fa92
    mov cx, word ptr [ebp - local_4]             # 0041fa86
    add cx, 0x1                                  # 0041fa8a
    mov word ptr [ebp - local_4], cx             # 0041fa8e
L_0041fa92:
    # block 0x0041fa92: entered by jmp at 0x0041fa84, 5 instruction(s), ends with jge to 0x0041fb0f (forward)
    movsx edx, word ptr [ebp - local_4]          # 0041fa92
    mov eax, dword ptr [ebp - local_c]           # 0041fa96
    movsx ecx, word ptr [eax + field_f21]        # 0041fa99
    {load} cmp edx, ecx                          # 0041faa0
    jge.d8 L_0041fb0f                            # 0041faa2
    # block 0x0041faa4: entered by fall-through of jge at 0x0041faa2, 16 instruction(s), calls FUN_0051ea75, FUN_0050d550, ends with jne to 0x0041faf5 (forward)
    push 0x190                                   # 0041faa4
    movsx edx, word ptr [ebp - local_4]          # 0041faa9
    mov eax, dword ptr [ebp - local_c]           # 0041faad
    lea ecx, [eax + 4*edx + field_ea5]           # 0041fab0
    call FUN_0051ea75                            # 0041fab7
    mov dword ptr [ebp - local_8], eax           # 0041fabc
    push 0x190                                   # 0041fabf
    mov ecx, dword ptr [ebp + arg_8]             # 0041fac4
    add ecx, 0x6                                 # 0041fac7
    push ecx                                     # 0041faca
    mov edx, dword ptr [ebp - local_8]           # 0041facb
    push edx                                     # 0041face
    call FUN_0050d550                            # 0041facf
    add esp, 0xc                                 # 0041fad4
    test eax, eax                                # 0041fad7
    jne.d8 L_0041faf5                            # 0041fad9
    # block 0x0041fadb: entered by fall-through of jne at 0x0041fad9, 6 instruction(s), calls FUN_0051eac4, ends with forward jump to 0x0041fd00
    push -0x1                                    # 0041fadb
    movsx eax, word ptr [ebp - local_4]          # 0041fadd
    mov ecx, dword ptr [ebp - local_c]           # 0041fae1
    lea ecx, [ecx + 4*eax + field_ea5]           # 0041fae4
    call FUN_0051eac4                            # 0041faeb
    jmp.d32 L_0041fd00                           # 0041faf0
L_0041faf5:
    # block 0x0041faf5: entered by jne at 0x0041fad9, 6 instruction(s), calls FUN_0051eac4, ends with backward jump to 0x0041fa86
    push -0x1                                    # 0041faf5
    movsx edx, word ptr [ebp - local_4]          # 0041faf7
    mov eax, dword ptr [ebp - local_c]           # 0041fafb
    lea ecx, [eax + 4*edx + field_ea5]           # 0041fafe
    call FUN_0051eac4                            # 0041fb05
    jmp.d32 L_0041fa86                           # 0041fb0a
L_0041fb0f:
    # block 0x0041fb0f: entered by jge at 0x0041faa2, 115 instruction(s), calls FUN_0051ea75, FUN_0051eac4, falls into the block at 0x0041fd00
    push 0x190                                   # 0041fb0f
    mov ecx, dword ptr [ebp - local_c]           # 0041fb14
    movsx edx, word ptr [ecx + field_f21]        # 0041fb17
    mov eax, dword ptr [ebp - local_c]           # 0041fb1e
    lea ecx, [eax + 4*edx + field_ea5]           # 0041fb21
    call FUN_0051ea75                            # 0041fb28
    mov dword ptr [ebp - local_8], eax           # 0041fb2d
    mov esi, dword ptr [ebp + arg_8]             # 0041fb30
    add esi, 0x6                                 # 0041fb33
    mov ecx, 0x64                                # 0041fb36
    mov edi, dword ptr [ebp - local_8]           # 0041fb3b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041fb3e
    push -0x1                                    # 0041fb40
    mov ecx, dword ptr [ebp - local_c]           # 0041fb42
    movsx edx, word ptr [ecx + field_f21]        # 0041fb45
    mov eax, dword ptr [ebp - local_c]           # 0041fb4c
    lea ecx, [eax + 4*edx + field_ea5]           # 0041fb4f
    call FUN_0051eac4                            # 0041fb56
    mov ecx, dword ptr [ebp - local_c]           # 0041fb5b
    movsx edx, word ptr [ecx + field_f21]        # 0041fb5e
    imul edx, edx, 0x3a                          # 0041fb65
    mov eax, dword ptr [ebp - local_c]           # 0041fb68
    mov ecx, dword ptr [ebp + arg_8]             # 0041fb6b
    mov cx, word ptr [ecx + field_1be]           # 0041fb6e
    mov word ptr [eax + edx + field_800], cx     # 0041fb75
    mov edx, dword ptr [ebp - local_c]           # 0041fb7d
    movsx eax, word ptr [edx + field_f21]        # 0041fb80
    imul eax, eax, 0x3a                          # 0041fb87
    mov ecx, dword ptr [ebp - local_c]           # 0041fb8a
    mov edx, dword ptr [ebp + arg_8]             # 0041fb8d
    mov dx, word ptr [edx + field_1bc]           # 0041fb90
    mov word ptr [ecx + eax + field_7fe], dx     # 0041fb97
    mov eax, dword ptr [ebp - local_c]           # 0041fb9f
    movsx ecx, word ptr [eax + field_f21]        # 0041fba2
    imul ecx, ecx, 0x3a                          # 0041fba9
    mov edx, dword ptr [ebp - local_c]           # 0041fbac
    mov eax, dword ptr [ebp + arg_8]             # 0041fbaf
    mov ax, word ptr [eax + field_1b8]           # 0041fbb2
    mov word ptr [edx + ecx + field_7fa], ax     # 0041fbb9
    mov ecx, dword ptr [ebp - local_c]           # 0041fbc1
    movsx edx, word ptr [ecx + field_f21]        # 0041fbc4
    imul edx, edx, 0x3a                          # 0041fbcb
    mov eax, dword ptr [ebp - local_c]           # 0041fbce
    mov ecx, dword ptr [ebp + arg_8]             # 0041fbd1
    mov cx, word ptr [ecx + field_1ba]           # 0041fbd4
    mov word ptr [eax + edx + field_7fc], cx     # 0041fbdb
    mov edx, dword ptr [ebp - local_c]           # 0041fbe3
    movsx eax, word ptr [edx + field_f21]        # 0041fbe6
    imul eax, eax, 0x3a                          # 0041fbed
    mov ecx, dword ptr [ebp - local_c]           # 0041fbf0
    mov edx, dword ptr [ebp + arg_8]             # 0041fbf3
    mov edx, dword ptr [edx + field_1c0]         # 0041fbf6
    mov dword ptr [ecx + eax + field_802], edx   # 0041fbfc
    mov eax, dword ptr [ebp - local_c]           # 0041fc03
    movsx ecx, word ptr [eax + field_f21]        # 0041fc06
    imul ecx, ecx, 0x3a                          # 0041fc0d
    mov edx, dword ptr [ebp - local_c]           # 0041fc10
    mov eax, dword ptr [ebp + arg_8]             # 0041fc13
    mov eax, dword ptr [eax + field_1c4]         # 0041fc16
    mov dword ptr [edx + ecx + field_806], eax   # 0041fc1c
    mov ecx, dword ptr [ebp - local_c]           # 0041fc23
    movsx edx, word ptr [ecx + field_f21]        # 0041fc26
    imul edx, edx, 0x3a                          # 0041fc2d
    mov eax, dword ptr [ebp - local_c]           # 0041fc30
    mov ecx, dword ptr [ebp + arg_8]             # 0041fc33
    mov ecx, dword ptr [ecx + field_1c8]         # 0041fc36
    mov dword ptr [eax + edx + field_80a], ecx   # 0041fc3c
    mov edx, dword ptr [ebp + arg_8]             # 0041fc43
    add edx, 0x196                               # 0041fc46
    {load} mov edi, edx                          # 0041fc4c
    mov eax, dword ptr [ebp - local_c]           # 0041fc4e
    movsx ecx, word ptr [eax + field_f21]        # 0041fc51
    imul ecx, ecx, 0x3a                          # 0041fc58
    mov edx, dword ptr [ebp - local_c]           # 0041fc5b
    lea eax, [edx + ecx + field_7d9]             # 0041fc5e
    {load} mov edx, eax                          # 0041fc65
    or ecx, -0x1                                 # 0041fc67
    {load} xor eax, eax                          # 0041fc6a
    repne scasb al, byte ptr es:[edi]            # 0041fc6c
    not ecx                                      # 0041fc6e
    {load} sub edi, ecx                          # 0041fc70
    {load} mov esi, edi                          # 0041fc72
    {load} mov eax, ecx                          # 0041fc74
    {load} mov edi, edx                          # 0041fc76
    shr ecx, 0x2                                 # 0041fc78
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041fc7b
    {load} mov ecx, eax                          # 0041fc7d
    and ecx, 0x3                                 # 0041fc7f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041fc82
    mov ecx, dword ptr [ebp - local_c]           # 0041fc84
    movsx edx, word ptr [ecx + field_f21]        # 0041fc87
    imul edx, edx, 0x3a                          # 0041fc8e
    mov eax, dword ptr [ebp - local_c]           # 0041fc91
    mov ecx, dword ptr [ebp + arg_8]             # 0041fc94
    mov cx, word ptr [ecx + field_1cc]           # 0041fc97
    mov word ptr [eax + edx + field_80e], cx     # 0041fc9e
    mov edx, dword ptr [ebp - local_c]           # 0041fca6
    movsx eax, word ptr [edx + field_f21]        # 0041fca9
    imul eax, eax, 0x3a                          # 0041fcb0
    mov ecx, dword ptr [ebp - local_c]           # 0041fcb3
    mov edx, dword ptr [ebp + arg_8]             # 0041fcb6
    mov dl, byte ptr [edx + field_1ce]           # 0041fcb9
    mov byte ptr [ecx + eax + field_810], dl     # 0041fcbf
    mov eax, dword ptr [ebp - local_c]           # 0041fcc6
    movsx ecx, word ptr [eax + field_f21]        # 0041fcc9
    imul ecx, ecx, 0x3a                          # 0041fcd0
    mov edx, dword ptr [ebp - local_c]           # 0041fcd3
    mov eax, dword ptr [ebp + arg_8]             # 0041fcd6
    mov ax, word ptr [eax + field_1cf]           # 0041fcd9
    mov word ptr [edx + ecx + field_811], ax     # 0041fce0
    mov ecx, dword ptr [ebp - local_c]           # 0041fce8
    mov dx, word ptr [ecx + field_f21]           # 0041fceb
    add dx, 0x1                                  # 0041fcf2
    mov eax, dword ptr [ebp - local_c]           # 0041fcf6
    mov word ptr [eax + field_f21], dx           # 0041fcf9
L_0041fd00:
    # block 0x0041fd00: entered by jg at 0x0041fa78; jmp at 0x0041faf0, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0041fd00
    pop esi                                      # 0041fd01
    {load} mov esp, ebp                          # 0041fd02
    pop ebp                                      # 0041fd04
    ret 0x4                                      # 0041fd05

