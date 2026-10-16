# FUN_0045eadc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045eadc
# extent:       0x0045eadc-0x0045eb76 (154 code bytes)
# span:         0x0045eadc-0x0045eb76 (code 154, tables 0, padding 0)
# sha256:       18d6b7065bbd4aff8d8395e01aac6b06092134f8b12346c4360776bc6f7d90e4
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045eadc
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_25; [ecx + n] field_24; [edx + n] field_d0, field_142, field_31d
# callees:      calls FUN_0045de8a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_d0, 0xd0  # offset +0xd0
.equ field_142, 0x142  # offset +0x142
.equ field_31d, 0x31d  # offset +0x31d

# --- external targets -----------------------------------------------
.set FUN_0045de8a, .text + (0x0045de8a - 0x401000)

.org 0x0045eadc - 0x401000
.globl FUN_0045eadc
FUN_0045eadc:
    # block 0x0045eadc: entry, 7 instruction(s), ends with forward jump to 0x0045eaff
    push ebp                                     # 0045eadc
    {load} mov ebp, esp                          # 0045eadd
    sub esp, 0xc                                 # 0045eadf
    mov dword ptr [ebp - local_c], ecx           # 0045eae2
    mov word ptr [ebp - local_4], 0x0            # 0045eae5
    mov word ptr [ebp - local_8], 0x0            # 0045eaeb
    jmp.d8 L_0045eaff                            # 0045eaf1
L_0045eaf3:
    # block 0x0045eaf3: entered by jmp at 0x0045eb39, 3 instruction(s), falls into the block at 0x0045eaff
    mov ax, word ptr [ebp - local_8]             # 0045eaf3
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045eaf7
    mov word ptr [ebp - local_8], ax             # 0045eafb
L_0045eaff:
    # block 0x0045eaff: entered by jmp at 0x0045eaf1, 6 instruction(s), ends with jge to 0x0045eb3b (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0045eaff
    mov edx, dword ptr [ebp - local_c]           # 0045eb03
    mov eax, dword ptr [edx + field_31d]         # 0045eb06
    movsx edx, word ptr [eax + field_25]         # 0045eb0c
    {load} cmp ecx, edx                          # 0045eb10
    jge.d8 L_0045eb3b                            # 0045eb12
    # block 0x0045eb14: entered by fall-through of jge at 0x0045eb12, 9 instruction(s), ends with backward jump to 0x0045eaf3
    movsx eax, word ptr [ebp + arg_8]            # 0045eb14
    imul eax, eax, 0x120                         # 0045eb18
    mov ecx, dword ptr [ebp - local_c]           # 0045eb1e
    lea edx, [ecx + eax + field_24]              # 0045eb21
    movsx eax, word ptr [ebp - local_8]          # 0045eb25
    mov cx, word ptr [ebp - local_4]             # 0045eb29
    add cx, word ptr [edx + 2*eax + field_d0]    # 0045eb2d
    mov word ptr [ebp - local_4], cx             # 0045eb35
    jmp.d8 L_0045eaf3                            # 0045eb39
L_0045eb3b:
    # block 0x0045eb3b: entered by jge at 0x0045eb12, 3 instruction(s), ends with je to 0x0045eb63 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0045eb3b
    test edx, edx                                # 0045eb3f
    je.d8 L_0045eb63                             # 0045eb41
    # block 0x0045eb43: entered by fall-through of je at 0x0045eb41, 8 instruction(s), ends with jne to 0x0045eb70 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0045eb43
    movsx ecx, word ptr [ebp + arg_8]            # 0045eb47
    imul ecx, ecx, 0x120                         # 0045eb4b
    mov edx, dword ptr [ebp - local_c]           # 0045eb51
    movsx ecx, word ptr [edx + ecx + field_142]  # 0045eb54
    imul ecx, ecx, 0x3                           # 0045eb5c
    {load} cmp eax, ecx                          # 0045eb5f
    jne.d8 L_0045eb70                            # 0045eb61
L_0045eb63:
    # block 0x0045eb63: entered by je at 0x0045eb41; fall-through of jne at 0x0045eb61, 4 instruction(s), calls FUN_0045de8a, falls into the block at 0x0045eb70
    mov dx, word ptr [ebp + arg_8]               # 0045eb63
    push edx                                     # 0045eb67
    mov ecx, dword ptr [ebp - local_c]           # 0045eb68
    call FUN_0045de8a                            # 0045eb6b
L_0045eb70:
    # block 0x0045eb70: entered by jne at 0x0045eb61, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0045eb70
    pop ebp                                      # 0045eb72
    ret 0x4                                      # 0045eb73

