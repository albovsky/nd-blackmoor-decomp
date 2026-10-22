# FUN_0051d48c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d48c
# extent:       0x0051d48c-0x0051d4c4 (56 code bytes)
# span:         0x0051d48c-0x0051d4c4 (code 56, tables 0, padding 0)
# sha256:       c1aa5c66b7e0ba5313cf1d000b32e67e58ced4567b66aa5c627d8e0260d7da26
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d48c
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [ecx + n] field_1c, field_34; [edx + n] field_7c
# callees:      calls USER32.dll!SendDlgItemMessageA; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_34, 0x34  # offset +0x34
.equ field_7c, 0x7c  # offset +0x7c

# --- external targets -----------------------------------------------

.org 0x0051d48c - 0x401000
.globl FUN_0051d48c
FUN_0051d48c:
    # block 0x0051d48c: entry, 5 instruction(s), ends with jne to 0x0051d4ad (forward)
    push ebp                                     # 0051d48c
    {load} mov ebp, esp                          # 0051d48d
    mov eax, dword ptr [ecx + field_34]          # 0051d48f
    test eax, eax                                # 0051d492
    jne.d8 L_0051d4ad                            # 0051d494
    # block 0x0051d496: entered by fall-through of jne at 0x0051d494, 7 instruction(s), calls USER32.dll!SendDlgItemMessageA, ends with forward jump to 0x0051d4c0
    push dword ptr [ebp + arg_14]                # 0051d496
    push dword ptr [ebp + arg_10]                # 0051d499
    push dword ptr [ebp + arg_c]                 # 0051d49c
    push dword ptr [ebp + arg_8]                 # 0051d49f
    push dword ptr [ecx + field_1c]              # 0051d4a2
    call dword ptr [0x52a318]                    # 0051d4a5
    jmp.d8 L_0051d4c0                            # 0051d4ab
L_0051d4ad:
    # block 0x0051d4ad: entered by jne at 0x0051d494, 7 instruction(s), calls indirect dword ptr [edx + 0x7c], falls into the block at 0x0051d4c0
    push dword ptr [ebp + arg_14]                # 0051d4ad
    mov edx, dword ptr [eax]                     # 0051d4b0
    {load} mov ecx, eax                          # 0051d4b2
    push dword ptr [ebp + arg_10]                # 0051d4b4
    push dword ptr [ebp + arg_c]                 # 0051d4b7
    push dword ptr [ebp + arg_8]                 # 0051d4ba
    call dword ptr [edx + field_7c]              # 0051d4bd
L_0051d4c0:
    # block 0x0051d4c0: entered by jmp at 0x0051d4ab, 2 instruction(s), ends with ret 0x10
    pop ebp                                      # 0051d4c0
    ret 0x10                                     # 0051d4c1

