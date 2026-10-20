# FUN_0042fc70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042fc70
# extent:       0x0042fc70-0x00430b82 (3858 code bytes)
# span:         0x0042fc70-0x00430b9a (code 3858, tables 24, padding 0)
# sha256:       eb80214322e212824d261f231df247d0ad514ae0e2fc3378766404c197486385
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_password_puzzle_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_76_runtime.h:20 says "0x42fc70 the handler: a phase switch on the row phase dword"
# name-note:    Handler for raw 0x76 PASSWORD puzzle (phase switch on the row phase dword).
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       10 ebp-relative slot(s): local_4, local_8, local_6c, local_d0, local_d4, local_d8, local_dc, local_e0, local_e4, local_e8
# fields:       [eax + n] field_c, field_1c, field_36, field_dd, field_1bc, field_1cc, field_1ce, field_1d0, field_1d2, field_1d4, field_1d8, field_1dc and 4 more; [ecx + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c, field_20, field_24, field_28, field_2c, field_30 and 11 more; [edx + n] field_2, field_4, field_14, field_34, field_db, field_182, field_184, field_186, field_188, field_18a, field_18e, field_192 and 4 more
# callees:      calls FUN_004c924d, KERNEL32.dll!GetTickCount, FUN_0050d0bc, FUN_0050d8e0, FUN_004d3836, FUN_00430b9a, FUN_004fb77a, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_004c92c5, FUN_0042ba3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 847 instruction(s), 47 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_6c, 0x6c  # offset -0x6c
.equ local_d0, 0xd0  # offset -0xd0
.equ local_d4, 0xd4  # offset -0xd4
.equ local_d8, 0xd8  # offset -0xd8
.equ local_dc, 0xdc  # offset -0xdc
.equ local_e0, 0xe0  # offset -0xe0
.equ local_e4, 0xe4  # offset -0xe4
.equ local_e8, 0xe8  # offset -0xe8
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_36, 0x36  # offset +0x36
.equ field_db, 0xdb  # offset +0xdb
.equ field_dd, 0xdd  # offset +0xdd
.equ field_182, 0x182  # offset +0x182
.equ field_184, 0x184  # offset +0x184
.equ field_186, 0x186  # offset +0x186
.equ field_188, 0x188  # offset +0x188
.equ field_18a, 0x18a  # offset +0x18a
.equ field_18e, 0x18e  # offset +0x18e
.equ field_192, 0x192  # offset +0x192
.equ field_196, 0x196  # offset +0x196
.equ field_198, 0x198  # offset +0x198
.equ field_19a, 0x19a  # offset +0x19a
.equ field_1bc, 0x1bc  # offset +0x1bc
.equ field_1cc, 0x1cc  # offset +0x1cc
.equ field_1ce, 0x1ce  # offset +0x1ce
.equ field_1d0, 0x1d0  # offset +0x1d0
.equ field_1d2, 0x1d2  # offset +0x1d2
.equ field_1d4, 0x1d4  # offset +0x1d4
.equ field_1d8, 0x1d8  # offset +0x1d8
.equ field_1dc, 0x1dc  # offset +0x1dc
.equ field_1e0, 0x1e0  # offset +0x1e0
.equ field_1e2, 0x1e2  # offset +0x1e2
.equ field_1e4, 0x1e4  # offset +0x1e4
.equ field_206, 0x206  # offset +0x206
.equ field_216, 0x216  # offset +0x216
.equ field_218, 0x218  # offset +0x218
.equ field_21a, 0x21a  # offset +0x21a
.equ field_21c, 0x21c  # offset +0x21c
.equ field_21e, 0x21e  # offset +0x21e
.equ field_222, 0x222  # offset +0x222
.equ field_226, 0x226  # offset +0x226
.equ field_22a, 0x22a  # offset +0x22a
.equ field_22c, 0x22c  # offset +0x22c
.equ field_22e, 0x22e  # offset +0x22e

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00430b9a, .text + (0x00430b9a - 0x401000)
.set FUN_004c924d, .text + (0x004c924d - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)
.set FUN_0050d8e0, .text + (0x0050d8e0 - 0x401000)

.org 0x0042fc70 - 0x401000
.globl FUN_0042fc70
FUN_0042fc70:
    # block 0x0042fc70: entry, 11 instruction(s), ends with je to 0x0042fcb9 (forward)
    push ebp                                     # 0042fc70
    {load} mov ebp, esp                          # 0042fc71
    sub esp, 0xe8                                # 0042fc73
    push esi                                     # 0042fc79
    push edi                                     # 0042fc7a
    movsx eax, word ptr [ebp + arg_8]            # 0042fc7b
    imul eax, eax, 0x8d                          # 0042fc7f
    mov ecx, dword ptr [eax + 0x5bb632]          # 0042fc85
    mov dword ptr [ebp - local_dc], ecx          # 0042fc8b
    cmp dword ptr [ebp - local_dc], 0x0          # 0042fc91
    je.d8 L_0042fcb9                             # 0042fc98
    # block 0x0042fc9a: entered by fall-through of je at 0x0042fc98, 2 instruction(s), ends with je to 0x0042fef9 (forward)
    cmp dword ptr [ebp - local_dc], 0x1          # 0042fc9a
    je.d32 L_0042fef9                            # 0042fca1
    # block 0x0042fca7: entered by fall-through of je at 0x0042fca1, 2 instruction(s), ends with je to 0x00430691 (forward)
    cmp dword ptr [ebp - local_dc], 0x2          # 0042fca7
    je.d32 L_00430691                            # 0042fcae
    # block 0x0042fcb4: entered by fall-through of je at 0x0042fcae, 1 instruction(s), ends with forward jump to 0x00430b7c
    jmp.d32 L_00430b7c                           # 0042fcb4
L_0042fcb9:
    # block 0x0042fcb9: entered by je at 0x0042fc98, 111 instruction(s), calls FUN_004c924d, KERNEL32.dll!GetTickCount, ends with forward jump to 0x00430b7c
    mov byte ptr [0x5b61af], 0x1                 # 0042fcb9
    mov byte ptr [0x5b61bc], 0x0                 # 0042fcc0
    mov dword ptr [0x5bb1ca], 0x1                # 0042fcc7
    mov dx, word ptr [ebp + arg_8]               # 0042fcd1
    mov word ptr [0x5b61b0], dx                  # 0042fcd5
    mov byte ptr [0x5b61b3], 0x0                 # 0042fcdc
    mov byte ptr [0x5b61b2], 0x0                 # 0042fce3
    mov byte ptr [0x5b616b], 0x0                 # 0042fcea
    movsx eax, word ptr [ebp + arg_8]            # 0042fcf1
    imul eax, eax, 0x8d                          # 0042fcf5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fcfb
    mov dx, word ptr [ecx]                       # 0042fd01
    push edx                                     # 0042fd04
    mov ecx, 0x5cf659                            # 0042fd05
    call FUN_004c924d                            # 0042fd0a
    movsx eax, word ptr [ebp + arg_8]            # 0042fd0f
    imul eax, eax, 0x8d                          # 0042fd13
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fd19
    mov edx, dword ptr [ecx + field_28]          # 0042fd1f
    add edx, dword ptr [0x58318a]                # 0042fd22
    mov dword ptr [0x5b61c5], edx                # 0042fd28
    movsx eax, word ptr [ebp + arg_8]            # 0042fd2e
    imul eax, eax, 0x8d                          # 0042fd32
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fd38
    mov edx, dword ptr [ecx + field_30]          # 0042fd3e
    add edx, dword ptr [0x58318a]                # 0042fd41
    mov dword ptr [0x5b61cd], edx                # 0042fd47
    movsx eax, word ptr [ebp + arg_8]            # 0042fd4d
    imul eax, eax, 0x8d                          # 0042fd51
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fd57
    mov edx, dword ptr [ecx + field_24]          # 0042fd5d
    add edx, dword ptr [0x583186]                # 0042fd60
    mov dword ptr [0x5b61c1], edx                # 0042fd66
    movsx eax, word ptr [ebp + arg_8]            # 0042fd6c
    imul eax, eax, 0x8d                          # 0042fd70
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fd76
    mov edx, dword ptr [ecx + field_2c]          # 0042fd7c
    add edx, dword ptr [0x583186]                # 0042fd7f
    mov dword ptr [0x5b61c9], edx                # 0042fd85
    movsx eax, word ptr [ebp + arg_8]            # 0042fd8b
    imul eax, eax, 0x8d                          # 0042fd8f
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fd95
    mov edx, dword ptr [ecx + field_8]           # 0042fd9b
    add edx, dword ptr [0x58318a]                # 0042fd9e
    mov dword ptr [0x5b61d5], edx                # 0042fda4
    movsx eax, word ptr [ebp + arg_8]            # 0042fdaa
    imul eax, eax, 0x8d                          # 0042fdae
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fdb4
    mov edx, dword ptr [ecx + field_10]          # 0042fdba
    add edx, dword ptr [0x58318a]                # 0042fdbd
    mov dword ptr [0x5b61dd], edx                # 0042fdc3
    movsx eax, word ptr [ebp + arg_8]            # 0042fdc9
    imul eax, eax, 0x8d                          # 0042fdcd
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fdd3
    mov edx, dword ptr [ecx + field_4]           # 0042fdd9
    add edx, dword ptr [0x583186]                # 0042fddc
    mov dword ptr [0x5b61d1], edx                # 0042fde2
    movsx eax, word ptr [ebp + arg_8]            # 0042fde8
    imul eax, eax, 0x8d                          # 0042fdec
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fdf2
    mov edx, dword ptr [ecx + field_c]           # 0042fdf8
    add edx, dword ptr [0x583186]                # 0042fdfb
    mov dword ptr [0x5b61d9], edx                # 0042fe01
    movsx eax, word ptr [ebp + arg_8]            # 0042fe07
    imul eax, eax, 0x8d                          # 0042fe0b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fe11
    mov edx, dword ptr [ecx + field_18]          # 0042fe17
    add edx, dword ptr [0x58318a]                # 0042fe1a
    mov dword ptr [0x5b61e5], edx                # 0042fe20
    movsx eax, word ptr [ebp + arg_8]            # 0042fe26
    imul eax, eax, 0x8d                          # 0042fe2a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fe30
    mov edx, dword ptr [ecx + field_20]          # 0042fe36
    add edx, dword ptr [0x58318a]                # 0042fe39
    mov dword ptr [0x5b61ed], edx                # 0042fe3f
    movsx eax, word ptr [ebp + arg_8]            # 0042fe45
    imul eax, eax, 0x8d                          # 0042fe49
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fe4f
    mov edx, dword ptr [ecx + field_14]          # 0042fe55
    add edx, dword ptr [0x583186]                # 0042fe58
    mov dword ptr [0x5b61e1], edx                # 0042fe5e
    movsx eax, word ptr [ebp + arg_8]            # 0042fe64
    imul eax, eax, 0x8d                          # 0042fe68
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042fe6e
    mov edx, dword ptr [ecx + field_1c]          # 0042fe74
    add edx, dword ptr [0x583186]                # 0042fe77
    mov dword ptr [0x5b61e9], edx                # 0042fe7d
    mov ecx, 0x8                                 # 0042fe83
    {load} xor eax, eax                          # 0042fe88
    mov edi, 0x5b616d                            # 0042fe8a
    rep stosd dword ptr es:[edi], eax            # 0042fe8f
    stosb byte ptr es:[edi], al                  # 0042fe91
    mov ecx, 0x8                                 # 0042fe92
    {load} xor eax, eax                          # 0042fe97
    mov edi, 0x5b618e                            # 0042fe99
    rep stosd dword ptr es:[edi], eax            # 0042fe9e
    stosb byte ptr es:[edi], al                  # 0042fea0
    mov dword ptr [0x5d1c01], 0x1                # 0042fea1
    call dword ptr [0x52a23c]                    # 0042feab
    movsx ecx, word ptr [ebp + arg_8]            # 0042feb1
    imul ecx, ecx, 0x8d                          # 0042feb5
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042febb
    movsx ecx, word ptr [edx + field_2]          # 0042fec1
    {load} add eax, ecx                          # 0042fec5
    mov dword ptr [0x5b61bd], eax                # 0042fec7
    mov dword ptr [0x5b61b4], 0x0                # 0042fecc
    mov dword ptr [0x5b61b8], 0x0                # 0042fed6
    movsx edx, word ptr [ebp + arg_8]            # 0042fee0
    imul edx, edx, 0x8d                          # 0042fee4
    mov dword ptr [edx + 0x5bb632], 0x1          # 0042feea
    jmp.d32 L_00430b7c                           # 0042fef4
L_0042fef9:
    # block 0x0042fef9: entered by je at 0x0042fca1, 4 instruction(s), ends with ja to 0x0043068c (forward)
    mov eax, dword ptr [0x5b61b4]                # 0042fef9
    mov dword ptr [ebp - local_e0], eax          # 0042fefe
    cmp dword ptr [ebp - local_e0], 0x5          # 0042ff04
    ja.d32 L_0043068c                            # 0042ff0b
    # block 0x0042ff11: entered by fall-through of ja at 0x0042ff0b, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x430b82]
    mov ecx, dword ptr [ebp - local_e0]          # 0042ff11
    jmp dword ptr [4*ecx + SWTAB_00430b82_VA]    # 0042ff17
L_0042ff1e:
    # block 0x0042ff1e: entered by switch case, 4 instruction(s), ends with je to 0x004301c2 (forward)
    {load} xor edx, edx                          # 0042ff1e
    mov dl, byte ptr [0x5b616b]                  # 0042ff20
    test edx, edx                                # 0042ff26
    je.d32 L_004301c2                            # 0042ff28
    # block 0x0042ff2e: entered by fall-through of je at 0x0042ff28, 8 instruction(s), ends with jbe to 0x0042ff72 (forward)
    mov edi, 0x5b616d                            # 0042ff2e
    or ecx, -0x1                                 # 0042ff33
    {load} xor eax, eax                          # 0042ff36
    repne scasb al, byte ptr es:[edi]            # 0042ff38
    not ecx                                      # 0042ff3a
    add ecx, -0x1                                # 0042ff3c
    test ecx, ecx                                # 0042ff3f
    jbe.d8 L_0042ff72                            # 0042ff41
    # block 0x0042ff43: entered by fall-through of jbe at 0x0042ff41, 8 instruction(s), ends with jne to 0x0042ff72 (forward)
    mov edi, 0x5b616d                            # 0042ff43
    or ecx, -0x1                                 # 0042ff48
    {load} xor eax, eax                          # 0042ff4b
    repne scasb al, byte ptr es:[edi]            # 0042ff4d
    not ecx                                      # 0042ff4f
    movsx eax, byte ptr [ecx + 0x5b616b]         # 0042ff51
    cmp eax, 0x2d                                # 0042ff58
    jne.d8 L_0042ff72                            # 0042ff5b
    # block 0x0042ff5d: entered by fall-through of jne at 0x0042ff5b, 6 instruction(s), falls into the block at 0x0042ff72
    mov edi, 0x5b616d                            # 0042ff5d
    or ecx, -0x1                                 # 0042ff62
    {load} xor eax, eax                          # 0042ff65
    repne scasb al, byte ptr es:[edi]            # 0042ff67
    not ecx                                      # 0042ff69
    mov byte ptr [ecx + 0x5b616b], 0x0           # 0042ff6b
L_0042ff72:
    # block 0x0042ff72: entered by jbe at 0x0042ff41; jne at 0x0042ff5b, 4 instruction(s), ends with je to 0x0042ff95 (forward)
    mov cl, byte ptr [0x5b616c]                  # 0042ff72
    mov byte ptr [ebp - local_e4], cl            # 0042ff78
    cmp byte ptr [ebp - local_e4], 0x8           # 0042ff7e
    je.d8 L_0042ff95                             # 0042ff85
    # block 0x0042ff87: entered by fall-through of je at 0x0042ff85, 2 instruction(s), ends with je to 0x0042ffc4 (forward)
    cmp byte ptr [ebp - local_e4], 0xd           # 0042ff87
    je.d8 L_0042ffc4                             # 0042ff8e
    # block 0x0042ff90: entered by fall-through of je at 0x0042ff8e, 1 instruction(s), ends with forward jump to 0x0043010e
    jmp.d32 L_0043010e                           # 0042ff90
L_0042ff95:
    # block 0x0042ff95: entered by je at 0x0042ff85, 8 instruction(s), ends with jbe to 0x0042ffbf (forward)
    mov edi, 0x5b616d                            # 0042ff95
    or ecx, -0x1                                 # 0042ff9a
    {load} xor eax, eax                          # 0042ff9d
    repne scasb al, byte ptr es:[edi]            # 0042ff9f
    not ecx                                      # 0042ffa1
    add ecx, -0x1                                # 0042ffa3
    test ecx, ecx                                # 0042ffa6
    jbe.d8 L_0042ffbf                            # 0042ffa8
    # block 0x0042ffaa: entered by fall-through of jbe at 0x0042ffa8, 6 instruction(s), falls into the block at 0x0042ffbf
    mov edi, 0x5b616d                            # 0042ffaa
    or ecx, -0x1                                 # 0042ffaf
    {load} xor eax, eax                          # 0042ffb2
    repne scasb al, byte ptr es:[edi]            # 0042ffb4
    not ecx                                      # 0042ffb6
    mov byte ptr [ecx + 0x5b616b], 0x0           # 0042ffb8
L_0042ffbf:
    # block 0x0042ffbf: entered by jbe at 0x0042ffa8, 1 instruction(s), ends with forward jump to 0x004301bb
    jmp.d32 L_004301bb                           # 0042ffbf
L_0042ffc4:
    # block 0x0042ffc4: entered by je at 0x0042ff8e, 22 instruction(s), calls FUN_0050d0bc, ends with forward jump to 0x00430010
    mov edi, 0x5b616d                            # 0042ffc4
    lea edx, [ebp - local_6c]                    # 0042ffc9
    or ecx, -0x1                                 # 0042ffcc
    {load} xor eax, eax                          # 0042ffcf
    repne scasb al, byte ptr es:[edi]            # 0042ffd1
    not ecx                                      # 0042ffd3
    {load} sub edi, ecx                          # 0042ffd5
    {load} mov esi, edi                          # 0042ffd7
    {load} mov eax, ecx                          # 0042ffd9
    {load} mov edi, edx                          # 0042ffdb
    shr ecx, 0x2                                 # 0042ffdd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0042ffe0
    {load} mov ecx, eax                          # 0042ffe2
    and ecx, 0x3                                 # 0042ffe4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0042ffe7
    lea ecx, [ebp - local_6c]                    # 0042ffe9
    push ecx                                     # 0042ffec
    call FUN_0050d0bc                            # 0042ffed
    add esp, 0x4                                 # 0042fff2
    mov dword ptr [ebp - local_8], 0x0           # 0042fff5
    mov word ptr [ebp - local_4], 0x0            # 0042fffc
    jmp.d8 L_00430010                            # 00430002
L_00430004:
    # block 0x00430004: entered by jmp at 0x004300ed, 3 instruction(s), falls into the block at 0x00430010
    mov dx, word ptr [ebp - local_4]             # 00430004
    add dx, 0x1                                  # 00430008
    mov word ptr [ebp - local_4], dx             # 0043000c
L_00430010:
    # block 0x00430010: entered by jmp at 0x00430002, 7 instruction(s), ends with jge to 0x004300f2 (forward)
    movsx eax, word ptr [ebp - local_4]          # 00430010
    movsx ecx, word ptr [ebp + arg_8]            # 00430014
    imul ecx, ecx, 0x8d                          # 00430018
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043001e
    movsx ecx, word ptr [edx + field_34]         # 00430024
    {load} cmp eax, ecx                          # 00430028
    jge.d32 L_004300f2                           # 0043002a
    # block 0x00430030: entered by fall-through of jge at 0x0043002a, 33 instruction(s), calls FUN_0050d0bc, FUN_0050d8e0, ends with je to 0x004300ed (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00430030
    imul edx, edx, 0x8d                          # 00430034
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043003a
    movsx ecx, word ptr [ebp - local_4]          # 00430040
    imul ecx, ecx, 0x21                          # 00430044
    lea edx, [eax + ecx + field_36]              # 00430047
    {load} mov edi, edx                          # 0043004b
    lea edx, [ebp - local_d0]                    # 0043004d
    or ecx, -0x1                                 # 00430053
    {load} xor eax, eax                          # 00430056
    repne scasb al, byte ptr es:[edi]            # 00430058
    not ecx                                      # 0043005a
    {load} sub edi, ecx                          # 0043005c
    {load} mov esi, edi                          # 0043005e
    {load} mov eax, ecx                          # 00430060
    {load} mov edi, edx                          # 00430062
    shr ecx, 0x2                                 # 00430064
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00430067
    {load} mov ecx, eax                          # 00430069
    and ecx, 0x3                                 # 0043006b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043006e
    lea ecx, [ebp - local_d0]                    # 00430070
    push ecx                                     # 00430076
    call FUN_0050d0bc                            # 00430077
    add esp, 0x4                                 # 0043007c
    lea edx, [ebp - local_d0]                    # 0043007f
    push edx                                     # 00430085
    lea eax, [ebp - local_6c]                    # 00430086
    push eax                                     # 00430089
    call FUN_0050d8e0                            # 0043008a
    add esp, 0x8                                 # 0043008f
    test eax, eax                                # 00430092
    je.d8 L_004300ed                             # 00430094
    # block 0x00430096: entered by fall-through of je at 0x00430094, 7 instruction(s), ends with jne to 0x004300cb (forward)
    mov dword ptr [ebp - local_8], 0x1           # 00430096
    movsx ecx, word ptr [ebp + arg_8]            # 0043009d
    imul ecx, ecx, 0x8d                          # 004300a1
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004300a7
    movsx eax, word ptr [edx + field_db]         # 004300ad
    test eax, eax                                # 004300b4
    jne.d8 L_004300cb                            # 004300b6
    # block 0x004300b8: entered by fall-through of jne at 0x004300b6, 3 instruction(s), ends with forward jump to 0x004300d5
    mov byte ptr [0x5b61bc], 0x1                 # 004300b8
    mov dword ptr [0x5b61b4], 0x5                # 004300bf
    jmp.d8 L_004300d5                            # 004300c9
L_004300cb:
    # block 0x004300cb: entered by jne at 0x004300b6, 1 instruction(s), falls into the block at 0x004300d5
    mov dword ptr [0x5b61b4], 0x1                # 004300cb
L_004300d5:
    # block 0x004300d5: entered by jmp at 0x004300c9, 5 instruction(s), falls into the block at 0x004300ed
    movsx ecx, word ptr [ebp + arg_8]            # 004300d5
    imul ecx, ecx, 0x8d                          # 004300d9
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004300df
    mov ax, word ptr [edx + field_34]            # 004300e5
    mov word ptr [ebp - local_4], ax             # 004300e9
L_004300ed:
    # block 0x004300ed: entered by je at 0x00430094, 1 instruction(s), ends with backward jump to 0x00430004
    jmp.d32 L_00430004                           # 004300ed
L_004300f2:
    # block 0x004300f2: entered by jge at 0x0043002a, 2 instruction(s), ends with jne to 0x00430109 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004300f2
    jne.d8 L_00430109                            # 004300f6
    # block 0x004300f8: entered by fall-through of jne at 0x004300f6, 2 instruction(s), falls into the block at 0x00430109
    mov byte ptr [0x5b61b3], 0x1                 # 004300f8
    mov dword ptr [0x5b61b4], 0x2                # 004300ff
L_00430109:
    # block 0x00430109: entered by jne at 0x004300f6, 1 instruction(s), ends with forward jump to 0x004301bb
    jmp.d32 L_004301bb                           # 00430109
L_0043010e:
    # block 0x0043010e: entered by jmp at 0x0042ff90, 8 instruction(s), ends with jae to 0x004301bb (forward)
    mov edi, 0x5b616d                            # 0043010e
    or ecx, -0x1                                 # 00430113
    {load} xor eax, eax                          # 00430116
    repne scasb al, byte ptr es:[edi]            # 00430118
    not ecx                                      # 0043011a
    inc ecx                                      # 0043011c
    cmp ecx, 0x21                                # 0043011d
    jae.d32 L_004301bb                           # 00430120
    # block 0x00430126: entered by fall-through of jae at 0x00430120, 29 instruction(s), calls FUN_004d3836, ends with jge to 0x004301bb (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00430126
    imul ecx, ecx, 0x8d                          # 0043012a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430130
    movsx eax, word ptr [edx]                    # 00430136
    imul eax, eax, 0x1d0                         # 00430139
    add eax, 0x5adb3a                            # 0043013f
    push eax                                     # 00430144
    movsx ecx, word ptr [ebp + arg_8]            # 00430145
    imul ecx, ecx, 0x8d                          # 00430149
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043014f
    movsx eax, word ptr [edx]                    # 00430155
    imul eax, eax, 0x7f3                         # 00430158
    add eax, 0x5a4c24                            # 0043015e
    push eax                                     # 00430163
    push 0x5b616d                                # 00430164
    call FUN_004d3836                            # 00430169
    add esp, 0xc                                 # 0043016e
    movsx ecx, ax                                # 00430171
    movsx edx, word ptr [ebp + arg_8]            # 00430174
    imul edx, edx, 0x8d                          # 00430178
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043017e
    movsx edx, word ptr [ebp + arg_8]            # 00430184
    imul edx, edx, 0x8d                          # 00430188
    mov edx, dword ptr [edx + 0x5bb5e5]          # 0043018e
    mov eax, dword ptr [eax + field_c]           # 00430194
    sub eax, dword ptr [edx + field_4]           # 00430197
    sub eax, 0x14                                # 0043019a
    {load} cmp ecx, eax                          # 0043019d
    jge.d8 L_004301bb                            # 0043019f
    # block 0x004301a1: entered by fall-through of jge at 0x0043019f, 7 instruction(s), falls into the block at 0x004301bb
    mov edi, 0x5b616d                            # 004301a1
    or ecx, -0x1                                 # 004301a6
    {load} xor eax, eax                          # 004301a9
    repne scasb al, byte ptr es:[edi]            # 004301ab
    not ecx                                      # 004301ad
    mov dl, byte ptr [0x5b616c]                  # 004301af
    mov byte ptr [ecx + 0x5b616c], dl            # 004301b5
L_004301bb:
    # block 0x004301bb: entered by jmp at 0x0042ffbf; jmp at 0x00430109; jae at 0x00430120; jge at 0x0043019f, 1 instruction(s), falls into the block at 0x004301c2
    mov byte ptr [0x5b616b], 0x0                 # 004301bb
L_004301c2:
    # block 0x004301c2: entered by je at 0x0042ff28, 4 instruction(s), ends with jne to 0x004301e8 (forward)
    {load} xor eax, eax                          # 004301c2
    mov al, byte ptr [0x5b61b3]                  # 004301c4
    test eax, eax                                # 004301c9
    jne.d8 L_004301e8                            # 004301cb
    # block 0x004301cd: entered by fall-through of jne at 0x004301cb, 2 instruction(s), ends with je to 0x004301e8 (forward)
    cmp dword ptr [0x5b61b4], 0x1                # 004301cd
    je.d8 L_004301e8                             # 004301d4
    # block 0x004301d6: entered by fall-through of je at 0x004301d4, 5 instruction(s), calls FUN_00430b9a, falls into the block at 0x004301e8
    push 0x5b616d                                # 004301d6
    mov cx, word ptr [ebp + arg_8]               # 004301db
    push ecx                                     # 004301df
    call FUN_00430b9a                            # 004301e0
    add esp, 0x8                                 # 004301e5
L_004301e8:
    # block 0x004301e8: entered by jne at 0x004301cb; je at 0x004301d4, 1 instruction(s), ends with forward jump to 0x0043068c
    jmp.d32 L_0043068c                           # 004301e8
L_004301ed:
    # block 0x004301ed: entered by switch case, 4 instruction(s), ends with je to 0x00430473 (forward)
    {load} xor edx, edx                          # 004301ed
    mov dl, byte ptr [0x5b616b]                  # 004301ef
    test edx, edx                                # 004301f5
    je.d32 L_00430473                            # 004301f7
    # block 0x004301fd: entered by fall-through of je at 0x004301f7, 8 instruction(s), ends with jbe to 0x00430241 (forward)
    mov edi, 0x5b618e                            # 004301fd
    or ecx, -0x1                                 # 00430202
    {load} xor eax, eax                          # 00430205
    repne scasb al, byte ptr es:[edi]            # 00430207
    not ecx                                      # 00430209
    add ecx, -0x1                                # 0043020b
    test ecx, ecx                                # 0043020e
    jbe.d8 L_00430241                            # 00430210
    # block 0x00430212: entered by fall-through of jbe at 0x00430210, 8 instruction(s), ends with jne to 0x00430241 (forward)
    mov edi, 0x5b618e                            # 00430212
    or ecx, -0x1                                 # 00430217
    {load} xor eax, eax                          # 0043021a
    repne scasb al, byte ptr es:[edi]            # 0043021c
    not ecx                                      # 0043021e
    movsx eax, byte ptr [ecx + 0x5b618c]         # 00430220
    cmp eax, 0x2d                                # 00430227
    jne.d8 L_00430241                            # 0043022a
    # block 0x0043022c: entered by fall-through of jne at 0x0043022a, 6 instruction(s), falls into the block at 0x00430241
    mov edi, 0x5b618e                            # 0043022c
    or ecx, -0x1                                 # 00430231
    {load} xor eax, eax                          # 00430234
    repne scasb al, byte ptr es:[edi]            # 00430236
    not ecx                                      # 00430238
    mov byte ptr [ecx + 0x5b618c], 0x0           # 0043023a
L_00430241:
    # block 0x00430241: entered by jbe at 0x00430210; jne at 0x0043022a, 4 instruction(s), ends with je to 0x00430264 (forward)
    mov cl, byte ptr [0x5b616c]                  # 00430241
    mov byte ptr [ebp - local_e8], cl            # 00430247
    cmp byte ptr [ebp - local_e8], 0x8           # 0043024d
    je.d8 L_00430264                             # 00430254
    # block 0x00430256: entered by fall-through of je at 0x00430254, 2 instruction(s), ends with je to 0x00430293 (forward)
    cmp byte ptr [ebp - local_e8], 0xd           # 00430256
    je.d8 L_00430293                             # 0043025d
    # block 0x0043025f: entered by fall-through of je at 0x0043025d, 1 instruction(s), ends with forward jump to 0x004303bf
    jmp.d32 L_004303bf                           # 0043025f
L_00430264:
    # block 0x00430264: entered by je at 0x00430254, 8 instruction(s), ends with jbe to 0x0043028e (forward)
    mov edi, 0x5b618e                            # 00430264
    or ecx, -0x1                                 # 00430269
    {load} xor eax, eax                          # 0043026c
    repne scasb al, byte ptr es:[edi]            # 0043026e
    not ecx                                      # 00430270
    add ecx, -0x1                                # 00430272
    test ecx, ecx                                # 00430275
    jbe.d8 L_0043028e                            # 00430277
    # block 0x00430279: entered by fall-through of jbe at 0x00430277, 6 instruction(s), falls into the block at 0x0043028e
    mov edi, 0x5b618e                            # 00430279
    or ecx, -0x1                                 # 0043027e
    {load} xor eax, eax                          # 00430281
    repne scasb al, byte ptr es:[edi]            # 00430283
    not ecx                                      # 00430285
    mov byte ptr [ecx + 0x5b618c], 0x0           # 00430287
L_0043028e:
    # block 0x0043028e: entered by jbe at 0x00430277, 1 instruction(s), ends with forward jump to 0x0043046c
    jmp.d32 L_0043046c                           # 0043028e
L_00430293:
    # block 0x00430293: entered by je at 0x0043025d, 22 instruction(s), calls FUN_0050d0bc, ends with forward jump to 0x004302df
    mov dword ptr [ebp - local_8], 0x0           # 00430293
    mov edi, 0x5b618e                            # 0043029a
    lea edx, [ebp - local_6c]                    # 0043029f
    or ecx, -0x1                                 # 004302a2
    {load} xor eax, eax                          # 004302a5
    repne scasb al, byte ptr es:[edi]            # 004302a7
    not ecx                                      # 004302a9
    {load} sub edi, ecx                          # 004302ab
    {load} mov esi, edi                          # 004302ad
    {load} mov eax, ecx                          # 004302af
    {load} mov edi, edx                          # 004302b1
    shr ecx, 0x2                                 # 004302b3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004302b6
    {load} mov ecx, eax                          # 004302b8
    and ecx, 0x3                                 # 004302ba
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004302bd
    lea ecx, [ebp - local_6c]                    # 004302bf
    push ecx                                     # 004302c2
    call FUN_0050d0bc                            # 004302c3
    add esp, 0x4                                 # 004302c8
    mov word ptr [ebp - local_4], 0x0            # 004302cb
    jmp.d8 L_004302df                            # 004302d1
L_004302d3:
    # block 0x004302d3: entered by jmp at 0x004303b5, 3 instruction(s), falls into the block at 0x004302df
    mov dx, word ptr [ebp - local_4]             # 004302d3
    add dx, 0x1                                  # 004302d7
    mov word ptr [ebp - local_4], dx             # 004302db
L_004302df:
    # block 0x004302df: entered by jmp at 0x004302d1, 7 instruction(s), ends with jge to 0x004303ba (forward)
    movsx eax, word ptr [ebp - local_4]          # 004302df
    movsx ecx, word ptr [ebp + arg_8]            # 004302e3
    imul ecx, ecx, 0x8d                          # 004302e7
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004302ed
    movsx ecx, word ptr [edx + field_db]         # 004302f3
    {load} cmp eax, ecx                          # 004302fa
    jge.d32 L_004303ba                           # 004302fc
    # block 0x00430302: entered by fall-through of jge at 0x004302fc, 33 instruction(s), calls FUN_0050d0bc, FUN_0050d8e0, ends with je to 0x0043039e (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00430302
    imul edx, edx, 0x8d                          # 00430306
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043030c
    movsx ecx, word ptr [ebp - local_4]          # 00430312
    imul ecx, ecx, 0x21                          # 00430316
    lea edx, [eax + ecx + field_dd]              # 00430319
    {load} mov edi, edx                          # 00430320
    lea edx, [ebp - local_d0]                    # 00430322
    or ecx, -0x1                                 # 00430328
    {load} xor eax, eax                          # 0043032b
    repne scasb al, byte ptr es:[edi]            # 0043032d
    not ecx                                      # 0043032f
    {load} sub edi, ecx                          # 00430331
    {load} mov esi, edi                          # 00430333
    {load} mov eax, ecx                          # 00430335
    {load} mov edi, edx                          # 00430337
    shr ecx, 0x2                                 # 00430339
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043033c
    {load} mov ecx, eax                          # 0043033e
    and ecx, 0x3                                 # 00430340
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00430343
    lea ecx, [ebp - local_d0]                    # 00430345
    push ecx                                     # 0043034b
    call FUN_0050d0bc                            # 0043034c
    add esp, 0x4                                 # 00430351
    lea edx, [ebp - local_d0]                    # 00430354
    push edx                                     # 0043035a
    lea eax, [ebp - local_6c]                    # 0043035b
    push eax                                     # 0043035e
    call FUN_0050d8e0                            # 0043035f
    add esp, 0x8                                 # 00430364
    test eax, eax                                # 00430367
    je.d8 L_0043039e                             # 00430369
    # block 0x0043036b: entered by fall-through of je at 0x00430369, 8 instruction(s), falls into the block at 0x0043039e
    mov dword ptr [ebp - local_8], 0x1           # 0043036b
    mov byte ptr [0x5b61bc], 0x1                 # 00430372
    mov dword ptr [0x5b61b4], 0x5                # 00430379
    movsx ecx, word ptr [ebp + arg_8]            # 00430383
    imul ecx, ecx, 0x8d                          # 00430387
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043038d
    mov ax, word ptr [edx + field_db]            # 00430393
    mov word ptr [ebp - local_4], ax             # 0043039a
L_0043039e:
    # block 0x0043039e: entered by je at 0x00430369, 2 instruction(s), ends with jne to 0x004303b5 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0043039e
    jne.d8 L_004303b5                            # 004303a2
    # block 0x004303a4: entered by fall-through of jne at 0x004303a2, 2 instruction(s), falls into the block at 0x004303b5
    mov byte ptr [0x5b61b3], 0x1                 # 004303a4
    mov dword ptr [0x5b61b4], 0x2                # 004303ab
L_004303b5:
    # block 0x004303b5: entered by jne at 0x004303a2, 1 instruction(s), ends with backward jump to 0x004302d3
    jmp.d32 L_004302d3                           # 004303b5
L_004303ba:
    # block 0x004303ba: entered by jge at 0x004302fc, 1 instruction(s), ends with forward jump to 0x0043046c
    jmp.d32 L_0043046c                           # 004303ba
L_004303bf:
    # block 0x004303bf: entered by jmp at 0x0043025f, 8 instruction(s), ends with jae to 0x0043046c (forward)
    mov edi, 0x5b618e                            # 004303bf
    or ecx, -0x1                                 # 004303c4
    {load} xor eax, eax                          # 004303c7
    repne scasb al, byte ptr es:[edi]            # 004303c9
    not ecx                                      # 004303cb
    inc ecx                                      # 004303cd
    cmp ecx, 0x21                                # 004303ce
    jae.d32 L_0043046c                           # 004303d1
    # block 0x004303d7: entered by fall-through of jae at 0x004303d1, 29 instruction(s), calls FUN_004d3836, ends with jge to 0x0043046c (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004303d7
    imul ecx, ecx, 0x8d                          # 004303db
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004303e1
    movsx eax, word ptr [edx]                    # 004303e7
    imul eax, eax, 0x1d0                         # 004303ea
    add eax, 0x5adb3a                            # 004303f0
    push eax                                     # 004303f5
    movsx ecx, word ptr [ebp + arg_8]            # 004303f6
    imul ecx, ecx, 0x8d                          # 004303fa
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430400
    movsx eax, word ptr [edx]                    # 00430406
    imul eax, eax, 0x7f3                         # 00430409
    add eax, 0x5a4c24                            # 0043040f
    push eax                                     # 00430414
    push 0x5b618e                                # 00430415
    call FUN_004d3836                            # 0043041a
    add esp, 0xc                                 # 0043041f
    movsx ecx, ax                                # 00430422
    movsx edx, word ptr [ebp + arg_8]            # 00430425
    imul edx, edx, 0x8d                          # 00430429
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043042f
    movsx edx, word ptr [ebp + arg_8]            # 00430435
    imul edx, edx, 0x8d                          # 00430439
    mov edx, dword ptr [edx + 0x5bb5e5]          # 0043043f
    mov eax, dword ptr [eax + field_1c]          # 00430445
    sub eax, dword ptr [edx + field_14]          # 00430448
    sub eax, 0x14                                # 0043044b
    {load} cmp ecx, eax                          # 0043044e
    jge.d8 L_0043046c                            # 00430450
    # block 0x00430452: entered by fall-through of jge at 0x00430450, 7 instruction(s), falls into the block at 0x0043046c
    mov edi, 0x5b618e                            # 00430452
    or ecx, -0x1                                 # 00430457
    {load} xor eax, eax                          # 0043045a
    repne scasb al, byte ptr es:[edi]            # 0043045c
    not ecx                                      # 0043045e
    mov dl, byte ptr [0x5b616c]                  # 00430460
    mov byte ptr [ecx + 0x5b618d], dl            # 00430466
L_0043046c:
    # block 0x0043046c: entered by jmp at 0x0043028e; jmp at 0x004303ba; jae at 0x004303d1; jge at 0x00430450, 1 instruction(s), falls into the block at 0x00430473
    mov byte ptr [0x5b616b], 0x0                 # 0043046c
L_00430473:
    # block 0x00430473: entered by je at 0x004301f7, 4 instruction(s), ends with jne to 0x0043049c (forward)
    {load} xor eax, eax                          # 00430473
    mov al, byte ptr [0x5b61b3]                  # 00430475
    test eax, eax                                # 0043047a
    jne.d8 L_0043049c                            # 0043047c
    # block 0x0043047e: entered by fall-through of jne at 0x0043047c, 4 instruction(s), ends with jne to 0x0043049c (forward)
    {load} xor ecx, ecx                          # 0043047e
    mov cl, byte ptr [0x5b61bc]                  # 00430480
    test ecx, ecx                                # 00430486
    jne.d8 L_0043049c                            # 00430488
    # block 0x0043048a: entered by fall-through of jne at 0x00430488, 5 instruction(s), calls FUN_00430b9a, falls into the block at 0x0043049c
    push 0x5b618e                                # 0043048a
    mov dx, word ptr [ebp + arg_8]               # 0043048f
    push edx                                     # 00430493
    call FUN_00430b9a                            # 00430494
    add esp, 0x8                                 # 00430499
L_0043049c:
    # block 0x0043049c: entered by jne at 0x0043047c; jne at 0x00430488, 1 instruction(s), ends with forward jump to 0x0043068c
    jmp.d32 L_0043068c                           # 0043049c
L_004304a1:
    # block 0x004304a1: entered by switch case, 9 instruction(s), ends with je to 0x00430516 (forward)
    mov edi, 0x545c38                            # 004304a1
    movsx eax, word ptr [ebp + arg_8]            # 004304a6
    imul eax, eax, 0x8d                          # 004304aa
    mov esi, dword ptr [eax + 0x5bb5e5]          # 004304b0
    add esi, 0x19b                               # 004304b6
    mov ecx, 0x9                                 # 004304bc
    {load} xor edx, edx                          # 004304c1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004304c3
    je.d8 L_00430516                             # 004304c5
    # block 0x004304c7: entered by fall-through of je at 0x004304c5, 16 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x0043052a
    movsx eax, word ptr [ebp + arg_8]            # 004304c7
    imul eax, eax, 0x8d                          # 004304cb
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004304d1
    add ecx, 0x19b                               # 004304d7
    push ecx                                     # 004304dd
    mov ecx, 0x5c3a67                            # 004304de
    call FUN_004fb77a                            # 004304e3
    movsx edx, word ptr [ebp + arg_8]            # 004304e8
    imul edx, edx, 0x8d                          # 004304ec
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004304f2
    mov cx, word ptr [eax + field_1bc]           # 004304f8
    push ecx                                     # 004304ff
    mov ecx, 0x5c3a67                            # 00430500
    call FUN_004fb2e3                            # 00430505
    mov dword ptr [0x5b61b4], 0x3                # 0043050a
    jmp.d8 L_0043052a                            # 00430514
L_00430516:
    # block 0x00430516: entered by je at 0x004304c5, 3 instruction(s), falls into the block at 0x0043052a
    movsx edx, word ptr [ebp + arg_8]            # 00430516
    imul edx, edx, 0x8d                          # 0043051a
    mov dword ptr [edx + 0x5bb632], 0x2          # 00430520
L_0043052a:
    # block 0x0043052a: entered by jmp at 0x00430514, 1 instruction(s), ends with forward jump to 0x0043068c
    jmp.d32 L_0043068c                           # 0043052a
L_0043052f:
    # block 0x0043052f: entered by switch case, 9 instruction(s), ends with je to 0x004305a4 (forward)
    mov edi, 0x545c44                            # 0043052f
    movsx eax, word ptr [ebp + arg_8]            # 00430534
    imul eax, eax, 0x8d                          # 00430538
    mov esi, dword ptr [eax + 0x5bb5e5]          # 0043053e
    add esi, 0x1e5                               # 00430544
    mov ecx, 0x9                                 # 0043054a
    {load} xor edx, edx                          # 0043054f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00430551
    je.d8 L_004305a4                             # 00430553
    # block 0x00430555: entered by fall-through of je at 0x00430553, 16 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004305b8
    movsx eax, word ptr [ebp + arg_8]            # 00430555
    imul eax, eax, 0x8d                          # 00430559
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043055f
    add ecx, 0x1e5                               # 00430565
    push ecx                                     # 0043056b
    mov ecx, 0x5c3a67                            # 0043056c
    call FUN_004fb77a                            # 00430571
    movsx edx, word ptr [ebp + arg_8]            # 00430576
    imul edx, edx, 0x8d                          # 0043057a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00430580
    mov cx, word ptr [eax + field_206]           # 00430586
    push ecx                                     # 0043058d
    mov ecx, 0x5c3a67                            # 0043058e
    call FUN_004fb2e3                            # 00430593
    mov dword ptr [0x5b61b4], 0x4                # 00430598
    jmp.d8 L_004305b8                            # 004305a2
L_004305a4:
    # block 0x004305a4: entered by je at 0x00430553, 3 instruction(s), falls into the block at 0x004305b8
    movsx edx, word ptr [ebp + arg_8]            # 004305a4
    imul edx, edx, 0x8d                          # 004305a8
    mov dword ptr [edx + 0x5bb632], 0x2          # 004305ae
L_004305b8:
    # block 0x004305b8: entered by jmp at 0x004305a2, 1 instruction(s), ends with forward jump to 0x0043068c
    jmp.d32 L_0043068c                           # 004305b8
L_004305bd:
    # block 0x004305bd: entered by switch case, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x00430624 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004305bd
    imul eax, eax, 0x8d                          # 004305c1
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004305c7
    movsx edx, word ptr [ecx + field_206]        # 004305cd
    mov dword ptr [ebp - local_d4], edx          # 004305d4
    mov eax, dword ptr [ebp - local_d4]          # 004305da
    push eax                                     # 004305e0
    mov ecx, 0x5cf1eb                            # 004305e1
    call FUN_004f6334                            # 004305e6
    test eax, eax                                # 004305eb
    jne.d8 L_00430624                            # 004305ed
    # block 0x004305ef: entered by fall-through of jne at 0x004305ed, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x00430624
    movsx ecx, word ptr [ebp + arg_8]            # 004305ef
    imul ecx, ecx, 0x8d                          # 004305f3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004305f9
    add edx, 0x1e5                               # 004305ff
    push edx                                     # 00430605
    mov ecx, 0x5c3a67                            # 00430606
    call FUN_004fba69                            # 0043060b
    movsx eax, word ptr [ebp + arg_8]            # 00430610
    imul eax, eax, 0x8d                          # 00430614
    mov dword ptr [eax + 0x5bb632], 0x2          # 0043061a
L_00430624:
    # block 0x00430624: entered by jne at 0x004305ed, 1 instruction(s), ends with forward jump to 0x0043068c
    jmp.d8 L_0043068c                            # 00430624
L_00430626:
    # block 0x00430626: entered by switch case, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x0043068c (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00430626
    imul ecx, ecx, 0x8d                          # 0043062a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430630
    movsx eax, word ptr [edx + field_1bc]        # 00430636
    mov dword ptr [ebp - local_d8], eax          # 0043063d
    mov ecx, dword ptr [ebp - local_d8]          # 00430643
    push ecx                                     # 00430649
    mov ecx, 0x5cf1eb                            # 0043064a
    call FUN_004f6334                            # 0043064f
    test eax, eax                                # 00430654
    jne.d8 L_0043068c                            # 00430656
    # block 0x00430658: entered by fall-through of jne at 0x00430656, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x0043068c
    movsx edx, word ptr [ebp + arg_8]            # 00430658
    imul edx, edx, 0x8d                          # 0043065c
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00430662
    add eax, 0x19b                               # 00430668
    push eax                                     # 0043066d
    mov ecx, 0x5c3a67                            # 0043066e
    call FUN_004fba69                            # 00430673
    movsx ecx, word ptr [ebp + arg_8]            # 00430678
    imul ecx, ecx, 0x8d                          # 0043067c
    mov dword ptr [ecx + 0x5bb632], 0x2          # 00430682
L_0043068c:
    # block 0x0043068c: entered by ja at 0x0042ff0b; jmp at 0x004301e8; jmp at 0x0043049c; jmp at 0x0043052a; more, 1 instruction(s), ends with forward jump to 0x00430b7c
    jmp.d32 L_00430b7c                           # 0043068c
L_00430691:
    # block 0x00430691: entered by je at 0x0042fcae, 14 instruction(s), calls FUN_004c92c5, ends with je to 0x0043085b (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 00430691
    mov byte ptr [0x5b61af], 0x0                 # 0043069b
    movsx edx, word ptr [ebp + arg_8]            # 004306a2
    imul edx, edx, 0x8d                          # 004306a6
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004306ac
    mov cx, word ptr [eax]                       # 004306b2
    push ecx                                     # 004306b5
    mov ecx, 0x5cf659                            # 004306b6
    call FUN_004c92c5                            # 004306bb
    mov dword ptr [0x5d1c01], 0x0                # 004306c0
    {load} xor edx, edx                          # 004306ca
    mov dl, byte ptr [0x5b61b2]                  # 004306cc
    test edx, edx                                # 004306d2
    je.d32 L_0043085b                            # 004306d4
    # block 0x004306da: entered by fall-through of je at 0x004306d4, 6 instruction(s), ends with je to 0x00430804 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004306da
    imul eax, eax, 0x8d                          # 004306de
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004306e4
    movsx edx, word ptr [ecx + field_216]        # 004306ea
    cmp edx, 0x270f                              # 004306f1
    je.d32 L_00430804                            # 004306f7
    # block 0x004306fd: entered by fall-through of je at 0x004306f7, 41 instruction(s), ends with jne to 0x004307f0 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004306fd
    imul eax, eax, 0x8d                          # 00430701
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00430707
    movsx edx, word ptr [ecx + field_216]        # 0043070d
    mov dword ptr [0x5bb57b], edx                # 00430714
    movsx eax, word ptr [ebp + arg_8]            # 0043071a
    imul eax, eax, 0x8d                          # 0043071e
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00430724
    mov dx, word ptr [ecx + field_218]           # 0043072a
    mov word ptr [0x5bb599], dx                  # 00430731
    movsx eax, word ptr [ebp + arg_8]            # 00430738
    imul eax, eax, 0x8d                          # 0043073c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00430742
    mov dx, word ptr [ecx + field_21a]           # 00430748
    mov word ptr [0x5bb595], dx                  # 0043074f
    movsx eax, word ptr [ebp + arg_8]            # 00430756
    imul eax, eax, 0x8d                          # 0043075a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00430760
    mov dx, word ptr [ecx + field_21c]           # 00430766
    mov word ptr [0x5c39ff], dx                  # 0043076d
    movsx eax, word ptr [ebp + arg_8]            # 00430774
    imul eax, eax, 0x8d                          # 00430778
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043077e
    mov edx, dword ptr [ecx + field_21e]         # 00430784
    mov dword ptr [0x5bb59b], edx                # 0043078a
    movsx eax, word ptr [ebp + arg_8]            # 00430790
    imul eax, eax, 0x8d                          # 00430794
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043079a
    mov edx, dword ptr [ecx + field_222]         # 004307a0
    mov dword ptr [0x5bb59f], edx                # 004307a6
    movsx eax, word ptr [ebp + arg_8]            # 004307ac
    imul eax, eax, 0x8d                          # 004307b0
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004307b6
    mov edx, dword ptr [ecx + field_226]         # 004307bc
    mov dword ptr [0x5bb5a3], edx                # 004307c2
    movsx eax, word ptr [ebp + arg_8]            # 004307c8
    imul eax, eax, 0x8d                          # 004307cc
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004307d2
    movsx edx, word ptr [ecx + field_22a]        # 004307d8
    cmp edx, 0x1                                 # 004307df
    jne.d8 L_004307f0                            # 004307e2
    # block 0x004307e4: entered by fall-through of jne at 0x004307e2, 2 instruction(s), ends with forward jump to 0x004307fa
    mov dword ptr [0x5bb1ca], 0x0                # 004307e4
    jmp.d8 L_004307fa                            # 004307ee
L_004307f0:
    # block 0x004307f0: entered by jne at 0x004307e2, 1 instruction(s), falls into the block at 0x004307fa
    mov dword ptr [0x5bb1ca], 0x1                # 004307f0
L_004307fa:
    # block 0x004307fa: entered by jmp at 0x004307ee, 1 instruction(s), falls into the block at 0x00430804
    mov dword ptr [0x583999], 0x4                # 004307fa
L_00430804:
    # block 0x00430804: entered by je at 0x004306f7, 6 instruction(s), ends with je to 0x00430856 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00430804
    imul eax, eax, 0x8d                          # 00430808
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043080e
    movsx edx, word ptr [ecx + field_22c]        # 00430814
    cmp edx, -0x1                                # 0043081b
    je.d8 L_00430856                             # 0043081e
    # block 0x00430820: entered by fall-through of je at 0x0043081e, 10 instruction(s), falls into the block at 0x00430856
    movsx eax, word ptr [ebp + arg_8]            # 00430820
    imul eax, eax, 0x8d                          # 00430824
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043082a
    {load} xor edx, edx                          # 00430830
    mov dl, byte ptr [ecx + field_22e]           # 00430832
    movsx eax, word ptr [ebp + arg_8]            # 00430838
    imul eax, eax, 0x8d                          # 0043083c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00430842
    movsx eax, word ptr [ecx + field_22c]        # 00430848
    mov dword ptr [4*eax + 0x585801], edx        # 0043084f
L_00430856:
    # block 0x00430856: entered by je at 0x0043081e, 1 instruction(s), ends with forward jump to 0x00430b6f
    jmp.d32 L_00430b6f                           # 00430856
L_0043085b:
    # block 0x0043085b: entered by je at 0x004306d4, 4 instruction(s), ends with je to 0x004309ec (forward)
    {load} xor ecx, ecx                          # 0043085b
    mov cl, byte ptr [0x5b61b3]                  # 0043085d
    test ecx, ecx                                # 00430863
    je.d32 L_004309ec                            # 00430865
    # block 0x0043086b: entered by fall-through of je at 0x00430865, 6 instruction(s), ends with je to 0x00430995 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0043086b
    imul edx, edx, 0x8d                          # 0043086f
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00430875
    movsx ecx, word ptr [eax + field_1cc]        # 0043087b
    cmp ecx, 0x270f                              # 00430882
    je.d32 L_00430995                            # 00430888
    # block 0x0043088e: entered by fall-through of je at 0x00430888, 41 instruction(s), ends with jne to 0x00430981 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0043088e
    imul edx, edx, 0x8d                          # 00430892
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00430898
    movsx ecx, word ptr [eax + field_1cc]        # 0043089e
    mov dword ptr [0x5bb57b], ecx                # 004308a5
    movsx edx, word ptr [ebp + arg_8]            # 004308ab
    imul edx, edx, 0x8d                          # 004308af
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004308b5
    mov cx, word ptr [eax + field_1ce]           # 004308bb
    mov word ptr [0x5bb599], cx                  # 004308c2
    movsx edx, word ptr [ebp + arg_8]            # 004308c9
    imul edx, edx, 0x8d                          # 004308cd
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004308d3
    mov cx, word ptr [eax + field_1d0]           # 004308d9
    mov word ptr [0x5bb595], cx                  # 004308e0
    movsx edx, word ptr [ebp + arg_8]            # 004308e7
    imul edx, edx, 0x8d                          # 004308eb
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004308f1
    mov cx, word ptr [eax + field_1d2]           # 004308f7
    mov word ptr [0x5c39ff], cx                  # 004308fe
    movsx edx, word ptr [ebp + arg_8]            # 00430905
    imul edx, edx, 0x8d                          # 00430909
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043090f
    mov ecx, dword ptr [eax + field_1d4]         # 00430915
    mov dword ptr [0x5bb59b], ecx                # 0043091b
    movsx edx, word ptr [ebp + arg_8]            # 00430921
    imul edx, edx, 0x8d                          # 00430925
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043092b
    mov ecx, dword ptr [eax + field_1d8]         # 00430931
    mov dword ptr [0x5bb59f], ecx                # 00430937
    movsx edx, word ptr [ebp + arg_8]            # 0043093d
    imul edx, edx, 0x8d                          # 00430941
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00430947
    mov ecx, dword ptr [eax + field_1dc]         # 0043094d
    mov dword ptr [0x5bb5a3], ecx                # 00430953
    movsx edx, word ptr [ebp + arg_8]            # 00430959
    imul edx, edx, 0x8d                          # 0043095d
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00430963
    movsx ecx, word ptr [eax + field_1e0]        # 00430969
    cmp ecx, 0x1                                 # 00430970
    jne.d8 L_00430981                            # 00430973
    # block 0x00430975: entered by fall-through of jne at 0x00430973, 2 instruction(s), ends with forward jump to 0x0043098b
    mov dword ptr [0x5bb1ca], 0x0                # 00430975
    jmp.d8 L_0043098b                            # 0043097f
L_00430981:
    # block 0x00430981: entered by jne at 0x00430973, 1 instruction(s), falls into the block at 0x0043098b
    mov dword ptr [0x5bb1ca], 0x1                # 00430981
L_0043098b:
    # block 0x0043098b: entered by jmp at 0x0043097f, 1 instruction(s), falls into the block at 0x00430995
    mov dword ptr [0x583999], 0x4                # 0043098b
L_00430995:
    # block 0x00430995: entered by je at 0x00430888, 6 instruction(s), ends with je to 0x004309e7 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00430995
    imul edx, edx, 0x8d                          # 00430999
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043099f
    movsx ecx, word ptr [eax + field_1e2]        # 004309a5
    cmp ecx, -0x1                                # 004309ac
    je.d8 L_004309e7                             # 004309af
    # block 0x004309b1: entered by fall-through of je at 0x004309af, 10 instruction(s), falls into the block at 0x004309e7
    movsx edx, word ptr [ebp + arg_8]            # 004309b1
    imul edx, edx, 0x8d                          # 004309b5
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004309bb
    {load} xor ecx, ecx                          # 004309c1
    mov cl, byte ptr [eax + field_1e4]           # 004309c3
    movsx edx, word ptr [ebp + arg_8]            # 004309c9
    imul edx, edx, 0x8d                          # 004309cd
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004309d3
    movsx edx, word ptr [eax + field_1e2]        # 004309d9
    mov dword ptr [4*edx + 0x585801], ecx        # 004309e0
L_004309e7:
    # block 0x004309e7: entered by je at 0x004309af, 1 instruction(s), ends with forward jump to 0x00430b6f
    jmp.d32 L_00430b6f                           # 004309e7
L_004309ec:
    # block 0x004309ec: entered by je at 0x00430865, 4 instruction(s), ends with je to 0x00430b6f (forward)
    {load} xor eax, eax                          # 004309ec
    mov al, byte ptr [0x5b61bc]                  # 004309ee
    test eax, eax                                # 004309f3
    je.d32 L_00430b6f                            # 004309f5
    # block 0x004309fb: entered by fall-through of je at 0x004309f5, 6 instruction(s), ends with je to 0x00430b1d (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004309fb
    imul ecx, ecx, 0x8d                          # 004309ff
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430a05
    movsx eax, word ptr [edx + field_182]        # 00430a0b
    cmp eax, 0x270f                              # 00430a12
    je.d32 L_00430b1d                            # 00430a17
    # block 0x00430a1d: entered by fall-through of je at 0x00430a17, 41 instruction(s), ends with jne to 0x00430b09 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00430a1d
    imul ecx, ecx, 0x8d                          # 00430a21
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430a27
    movsx eax, word ptr [edx + field_182]        # 00430a2d
    mov dword ptr [0x5bb57b], eax                # 00430a34
    movsx ecx, word ptr [ebp + arg_8]            # 00430a39
    imul ecx, ecx, 0x8d                          # 00430a3d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430a43
    mov ax, word ptr [edx + field_184]           # 00430a49
    mov word ptr [0x5bb599], ax                  # 00430a50
    movsx ecx, word ptr [ebp + arg_8]            # 00430a56
    imul ecx, ecx, 0x8d                          # 00430a5a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430a60
    mov ax, word ptr [edx + field_186]           # 00430a66
    mov word ptr [0x5bb595], ax                  # 00430a6d
    movsx ecx, word ptr [ebp + arg_8]            # 00430a73
    imul ecx, ecx, 0x8d                          # 00430a77
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430a7d
    mov ax, word ptr [edx + field_188]           # 00430a83
    mov word ptr [0x5c39ff], ax                  # 00430a8a
    movsx ecx, word ptr [ebp + arg_8]            # 00430a90
    imul ecx, ecx, 0x8d                          # 00430a94
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430a9a
    mov eax, dword ptr [edx + field_18a]         # 00430aa0
    mov dword ptr [0x5bb59b], eax                # 00430aa6
    movsx ecx, word ptr [ebp + arg_8]            # 00430aab
    imul ecx, ecx, 0x8d                          # 00430aaf
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430ab5
    mov eax, dword ptr [edx + field_18e]         # 00430abb
    mov dword ptr [0x5bb59f], eax                # 00430ac1
    movsx ecx, word ptr [ebp + arg_8]            # 00430ac6
    imul ecx, ecx, 0x8d                          # 00430aca
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430ad0
    mov eax, dword ptr [edx + field_192]         # 00430ad6
    mov dword ptr [0x5bb5a3], eax                # 00430adc
    movsx ecx, word ptr [ebp + arg_8]            # 00430ae1
    imul ecx, ecx, 0x8d                          # 00430ae5
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430aeb
    movsx eax, word ptr [edx + field_196]        # 00430af1
    cmp eax, 0x1                                 # 00430af8
    jne.d8 L_00430b09                            # 00430afb
    # block 0x00430afd: entered by fall-through of jne at 0x00430afb, 2 instruction(s), ends with forward jump to 0x00430b13
    mov dword ptr [0x5bb1ca], 0x0                # 00430afd
    jmp.d8 L_00430b13                            # 00430b07
L_00430b09:
    # block 0x00430b09: entered by jne at 0x00430afb, 1 instruction(s), falls into the block at 0x00430b13
    mov dword ptr [0x5bb1ca], 0x1                # 00430b09
L_00430b13:
    # block 0x00430b13: entered by jmp at 0x00430b07, 1 instruction(s), falls into the block at 0x00430b1d
    mov dword ptr [0x583999], 0x4                # 00430b13
L_00430b1d:
    # block 0x00430b1d: entered by je at 0x00430a17, 6 instruction(s), ends with je to 0x00430b6f (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00430b1d
    imul ecx, ecx, 0x8d                          # 00430b21
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430b27
    movsx eax, word ptr [edx + field_198]        # 00430b2d
    cmp eax, -0x1                                # 00430b34
    je.d8 L_00430b6f                             # 00430b37
    # block 0x00430b39: entered by fall-through of je at 0x00430b37, 10 instruction(s), falls into the block at 0x00430b6f
    movsx ecx, word ptr [ebp + arg_8]            # 00430b39
    imul ecx, ecx, 0x8d                          # 00430b3d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430b43
    {load} xor eax, eax                          # 00430b49
    mov al, byte ptr [edx + field_19a]           # 00430b4b
    movsx ecx, word ptr [ebp + arg_8]            # 00430b51
    imul ecx, ecx, 0x8d                          # 00430b55
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430b5b
    movsx ecx, word ptr [edx + field_198]        # 00430b61
    mov dword ptr [4*ecx + 0x585801], eax        # 00430b68
L_00430b6f:
    # block 0x00430b6f: entered by jmp at 0x00430856; jmp at 0x004309e7; je at 0x004309f5; je at 0x00430b37, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x00430b7c
    mov dx, word ptr [ebp + arg_8]               # 00430b6f
    push edx                                     # 00430b73
    call FUN_0042ba3a                            # 00430b74
    add esp, 0x4                                 # 00430b79
L_00430b7c:
    # block 0x00430b7c: entered by jmp at 0x0042fcb4; jmp at 0x0042fef4; jmp at 0x0043068c, 5 instruction(s), ends with ret
    pop edi                                      # 00430b7c
    pop esi                                      # 00430b7d
    {load} mov esp, ebp                          # 00430b7e
    pop ebp                                      # 00430b80
    ret                                          # 00430b81

# --- data items (not part of the function) -------------------------
.org 0x00430b82 - 0x401000
SWTAB_00430b82:  # 6 case address(es)
    .long L_0042ff1e - .text + 0x401000
    .long L_004301ed - .text + 0x401000
    .long L_0043052f - .text + 0x401000
    .long L_00430626 - .text + 0x401000
    .long L_004305bd - .text + 0x401000
    .long L_004304a1 - .text + 0x401000
.set SWTAB_00430b82_VA, SWTAB_00430b82 - .text + 0x401000

