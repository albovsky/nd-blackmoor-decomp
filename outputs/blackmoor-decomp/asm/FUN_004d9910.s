# FUN_004d9910
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d9910
# extent:       0x004d9910-0x004d999b (139 code bytes)
# span:         0x004d9910-0x004d999b (code 139, tables 0, padding 0)
# sha256:       e23d36db5ed72a34697b5001cb0647e96160985ba30dde1e5c5f53c1df0d0ebe
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d9910
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 45 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004d9910 - 0x401000
.globl FUN_004d9910
FUN_004d9910:
    # block 0x004d9910: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004d997c (forward)
    push ebp                                     # 004d9910
    {load} mov ebp, esp                          # 004d9911
    sub esp, 0x8                                 # 004d9913
    push edi                                     # 004d9916
    mov dword ptr [ebp - local_8], ecx           # 004d9917
    mov eax, dword ptr [ebp + arg_c]             # 004d991a
    push eax                                     # 004d991d
    call FUN_0051dc43                            # 004d991e
    add esp, 0x4                                 # 004d9923
    mov dword ptr [ebp - local_4], eax           # 004d9926
    mov ecx, dword ptr [ebp + arg_8]             # 004d9929
    mov edx, dword ptr [ebp - local_4]           # 004d992c
    mov dword ptr [ecx], edx                     # 004d992f
    cmp dword ptr [ebp - local_4], 0x0           # 004d9931
    jne.d8 L_004d997c                            # 004d9935
    # block 0x004d9937: entered by fall-through of jne at 0x004d9935, 10 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004d9970 (forward)
    push 0x55aa34                                # 004d9937
    push 0x63888b                                # 004d993c
    call FUN_0050ca3e                            # 004d9941
    add esp, 0x8                                 # 004d9946
    push 0x63888b                                # 004d9949
    mov ecx, 0x583979                            # 004d994e
    call FUN_004264e8                            # 004d9953
    movsx eax, word ptr [0x63a4cd]               # 004d9958
    test eax, eax                                # 004d995f
    je.d8 L_004d9970                             # 004d9961
    # block 0x004d9963: entered by fall-through of je at 0x004d9961, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004d9970
    push 0x63888b                                # 004d9963
    call FUN_0044a2b7                            # 004d9968
    add esp, 0x4                                 # 004d996d
L_004d9970:
    # block 0x004d9970: entered by je at 0x004d9961, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004d9994
    mov ecx, 0x5cf659                            # 004d9970
    call FUN_004c97b4                            # 004d9975
    jmp.d8 L_004d9994                            # 004d997a
L_004d997c:
    # block 0x004d997c: entered by jne at 0x004d9935, 10 instruction(s), falls into the block at 0x004d9994
    mov ecx, dword ptr [ebp + arg_c]             # 004d997c
    {load} xor eax, eax                          # 004d997f
    mov edx, dword ptr [ebp + arg_8]             # 004d9981
    mov edi, dword ptr [edx]                     # 004d9984
    {load} mov edx, ecx                          # 004d9986
    shr ecx, 0x2                                 # 004d9988
    rep stosd dword ptr es:[edi], eax            # 004d998b
    {load} mov ecx, edx                          # 004d998d
    and ecx, 0x3                                 # 004d998f
    rep stosb byte ptr es:[edi], al              # 004d9992
L_004d9994:
    # block 0x004d9994: entered by jmp at 0x004d997a, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 004d9994
    {load} mov esp, ebp                          # 004d9995
    pop ebp                                      # 004d9997
    ret 0x8                                      # 004d9998

