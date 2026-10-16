# FUN_0047fa11
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047fa11
# extent:       0x0047fa11-0x0047fb76 (357 code bytes)
# span:         0x0047fa11-0x0047fb76 (code 357, tables 0, padding 0)
# sha256:       730d152a958cda5bfee277d5f80305e3fa6b59677176a2e7b3e7c79e1f3092d0
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047fa11
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_2, field_6, field_c, field_16, field_22, field_23, field_134c; [ecx + n] field_2, field_4, field_6, field_8, field_a, field_c, field_10, field_20, field_22, field_7b4; [edx + n] field_4, field_6, field_8, field_c, field_e, field_14, field_16, field_20, field_22, field_23
# callees:      calls FUN_0047f19d, FUN_0047e52f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 123 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_20, 0x20  # offset +0x20
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_7b4, 0x7b4  # offset +0x7b4
.equ field_134c, 0x134c  # offset +0x134c

# --- external targets -----------------------------------------------
.set FUN_0047e52f, .text + (0x0047e52f - 0x401000)
.set FUN_0047f19d, .text + (0x0047f19d - 0x401000)

.org 0x0047fa11 - 0x401000
.globl FUN_0047fa11
FUN_0047fa11:
    # block 0x0047fa11: entry, 63 instruction(s), ends with jne to 0x0047fad5 (forward)
    push ebp                                     # 0047fa11
    {load} mov ebp, esp                          # 0047fa12
    sub esp, 0x14                                # 0047fa14
    mov dword ptr [ebp - local_14], ecx          # 0047fa17
    movsx eax, word ptr [ebp + arg_8]            # 0047fa1a
    imul eax, eax, 0x25                          # 0047fa1e
    mov ecx, dword ptr [ebp - local_14]          # 0047fa21
    lea edx, [ecx + eax + field_7b4]             # 0047fa24
    mov dword ptr [ebp - local_10], edx          # 0047fa2b
    mov eax, dword ptr [ebp - local_14]          # 0047fa2e
    mov dword ptr [eax + field_134c], 0x1        # 0047fa31
    mov ecx, dword ptr [ebp - local_10]          # 0047fa3b
    add ecx, 0x2                                 # 0047fa3e
    mov edx, dword ptr [ebp - local_14]          # 0047fa41
    add edx, 0x1392                              # 0047fa44
    mov eax, dword ptr [ecx]                     # 0047fa4a
    mov dword ptr [edx], eax                     # 0047fa4c
    mov eax, dword ptr [ecx + field_4]           # 0047fa4e
    mov dword ptr [edx + field_4], eax           # 0047fa51
    mov eax, dword ptr [ecx + field_8]           # 0047fa54
    mov dword ptr [edx + field_8], eax           # 0047fa57
    mov ecx, dword ptr [ecx + field_c]           # 0047fa5a
    mov dword ptr [edx + field_c], ecx           # 0047fa5d
    mov edx, dword ptr [ebp - local_10]          # 0047fa60
    {load} xor eax, eax                          # 0047fa63
    mov al, byte ptr [edx + field_23]            # 0047fa65
    imul eax, eax, 0x60                          # 0047fa68
    mov ecx, dword ptr [ebp - local_14]          # 0047fa6b
    lea edx, [ecx + eax + field_20]              # 0047fa6e
    mov eax, dword ptr [ebp - local_10]          # 0047fa72
    {load} xor ecx, ecx                          # 0047fa75
    mov cl, byte ptr [eax + field_22]            # 0047fa77
    imul ecx, ecx, 0x18                          # 0047fa7a
    {load} add edx, ecx                          # 0047fa7d
    mov dword ptr [ebp - local_8], edx           # 0047fa7f
    mov edx, dword ptr [ebp - local_8]           # 0047fa82
    movsx eax, word ptr [edx + field_14]         # 0047fa85
    cdq                                          # 0047fa89
    {load} sub eax, edx                          # 0047fa8a
    sar eax                                      # 0047fa8c
    mov ecx, dword ptr [ebp - local_10]          # 0047fa8e
    mov edx, dword ptr [ecx + field_2]           # 0047fa91
    {load} add edx, eax                          # 0047fa94
    mov word ptr [ebp - local_c], dx             # 0047fa96
    mov eax, dword ptr [ebp - local_8]           # 0047fa9a
    movsx eax, word ptr [eax + field_16]         # 0047fa9d
    cdq                                          # 0047faa1
    {load} sub eax, edx                          # 0047faa2
    sar eax                                      # 0047faa4
    mov ecx, dword ptr [ebp - local_10]          # 0047faa6
    mov edx, dword ptr [ecx + field_6]           # 0047faa9
    {load} add edx, eax                          # 0047faac
    mov word ptr [ebp - local_4], dx             # 0047faae
    mov eax, dword ptr [ebp - local_10]          # 0047fab2
    mov cl, byte ptr [eax + field_22]            # 0047fab5
    add cl, 0x1                                  # 0047fab8
    mov edx, dword ptr [ebp - local_10]          # 0047fabb
    mov byte ptr [edx + field_22], cl            # 0047fabe
    mov eax, dword ptr [ebp - local_10]          # 0047fac1
    {load} xor ecx, ecx                          # 0047fac4
    mov cl, byte ptr [eax + field_22]            # 0047fac6
    cmp ecx, 0x4                                 # 0047fac9
    jne.d8 L_0047fad5                            # 0047facc
    # block 0x0047face: entered by fall-through of jne at 0x0047facc, 2 instruction(s), falls into the block at 0x0047fad5
    mov edx, dword ptr [ebp - local_10]          # 0047face
    mov byte ptr [edx + field_22], 0x0           # 0047fad1
L_0047fad5:
    # block 0x0047fad5: entered by jne at 0x0047facc, 58 instruction(s), calls FUN_0047f19d, FUN_0047e52f, ends with ret 0x4
    mov eax, dword ptr [ebp - local_10]          # 0047fad5
    {load} xor ecx, ecx                          # 0047fad8
    mov cl, byte ptr [eax + field_23]            # 0047fada
    imul ecx, ecx, 0x60                          # 0047fadd
    mov edx, dword ptr [ebp - local_14]          # 0047fae0
    lea eax, [edx + ecx + field_20]              # 0047fae3
    mov ecx, dword ptr [ebp - local_10]          # 0047fae7
    {load} xor edx, edx                          # 0047faea
    mov dl, byte ptr [ecx + field_22]            # 0047faec
    imul edx, edx, 0x18                          # 0047faef
    {load} add eax, edx                          # 0047faf2
    mov dword ptr [ebp - local_8], eax           # 0047faf4
    movsx ecx, word ptr [ebp - local_c]          # 0047faf7
    mov edx, dword ptr [ebp - local_8]           # 0047fafb
    movsx eax, word ptr [edx + field_14]         # 0047fafe
    cdq                                          # 0047fb02
    {load} sub eax, edx                          # 0047fb03
    sar eax                                      # 0047fb05
    {load} sub ecx, eax                          # 0047fb07
    mov eax, dword ptr [ebp - local_10]          # 0047fb09
    mov dword ptr [eax + field_2], ecx           # 0047fb0c
    movsx ecx, word ptr [ebp - local_4]          # 0047fb0f
    mov edx, dword ptr [ebp - local_8]           # 0047fb13
    movsx eax, word ptr [edx + field_16]         # 0047fb16
    cdq                                          # 0047fb1a
    {load} sub eax, edx                          # 0047fb1b
    sar eax                                      # 0047fb1d
    {load} sub ecx, eax                          # 0047fb1f
    mov eax, dword ptr [ebp - local_10]          # 0047fb21
    mov dword ptr [eax + field_6], ecx           # 0047fb24
    mov ecx, dword ptr [ebp - local_10]          # 0047fb27
    mov edx, dword ptr [ecx + field_2]           # 0047fb2a
    mov eax, dword ptr [ebp - local_8]           # 0047fb2d
    add edx, dword ptr [eax + field_c]           # 0047fb30
    mov ecx, dword ptr [ebp - local_10]          # 0047fb33
    mov dword ptr [ecx + field_a], edx           # 0047fb36
    mov edx, dword ptr [ebp - local_10]          # 0047fb39
    mov eax, dword ptr [edx + field_6]           # 0047fb3c
    mov ecx, dword ptr [ebp - local_8]           # 0047fb3f
    add eax, dword ptr [ecx + field_10]          # 0047fb42
    mov edx, dword ptr [ebp - local_10]          # 0047fb45
    mov dword ptr [edx + field_e], eax           # 0047fb48
    mov eax, dword ptr [ebp - local_10]          # 0047fb4b
    add eax, 0x2                                 # 0047fb4e
    push eax                                     # 0047fb51
    mov ecx, dword ptr [ebp - local_14]          # 0047fb52
    call FUN_0047f19d                            # 0047fb55
    mov ecx, dword ptr [ebp - local_10]          # 0047fb5a
    add ecx, 0x12                                # 0047fb5d
    push ecx                                     # 0047fb60
    mov edx, dword ptr [ebp - local_10]          # 0047fb61
    add edx, 0x2                                 # 0047fb64
    push edx                                     # 0047fb67
    mov ecx, dword ptr [ebp - local_14]          # 0047fb68
    call FUN_0047e52f                            # 0047fb6b
    {load} mov esp, ebp                          # 0047fb70
    pop ebp                                      # 0047fb72
    ret 0x4                                      # 0047fb73

