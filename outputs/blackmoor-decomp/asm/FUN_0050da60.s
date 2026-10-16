# FUN_0050da60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050da60
# extent:       0x0050da60-0x0050da98 (56 code bytes)
# span:         0x0050da60-0x0050da98 (code 56, tables 0, padding 0)
# sha256:       e2f944563c7483cd4085f1878325de050424e2b192c3220c5e73a802f698e0da
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050da60
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [edi + n] field_minus_1; [esi + n] field_minus_1
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0050da60 - 0x401000
.globl FUN_0050da60
FUN_0050da60:
    # block 0x0050da60: entry, 7 instruction(s), ends with jecxz to 0x0050da91 (forward)
    push ebp                                     # 0050da60
    {load} mov ebp, esp                          # 0050da61
    push edi                                     # 0050da63
    push esi                                     # 0050da64
    push ebx                                     # 0050da65
    mov ecx, dword ptr [ebp + arg_10]            # 0050da66
    jecxz L_0050da91                             # 0050da69
    # block 0x0050da6b: entered by fall-through of jecxz at 0x0050da69, 14 instruction(s), ends with ja to 0x0050da8f (forward)
    {load} mov ebx, ecx                          # 0050da6b
    mov edi, dword ptr [ebp + arg_8]             # 0050da6d
    {load} mov esi, edi                          # 0050da70
    {load} xor eax, eax                          # 0050da72
    repne scasb al, byte ptr es:[edi]            # 0050da74
    neg ecx                                      # 0050da76
    {load} add ecx, ebx                          # 0050da78
    {load} mov edi, esi                          # 0050da7a
    mov esi, dword ptr [ebp + arg_c]             # 0050da7c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0050da7f
    mov al, byte ptr [esi - field_minus_1]       # 0050da81
    {load} xor ecx, ecx                          # 0050da84
    cmp al, byte ptr [edi - field_minus_1]       # 0050da86
    ja.d8 L_0050da8f                             # 0050da89
    # block 0x0050da8b: entered by fall-through of ja at 0x0050da89, 1 instruction(s), ends with je to 0x0050da91 (forward)
    je.d8 L_0050da91                             # 0050da8b
    # block 0x0050da8d: entered by fall-through of je at 0x0050da8b, 2 instruction(s), falls into the block at 0x0050da8f
    dec ecx                                      # 0050da8d
    dec ecx                                      # 0050da8e
L_0050da8f:
    # block 0x0050da8f: entered by ja at 0x0050da89, 1 instruction(s), falls into the block at 0x0050da91
    not ecx                                      # 0050da8f
L_0050da91:
    # block 0x0050da91: entered by jecxz at 0x0050da69; je at 0x0050da8b, 6 instruction(s), ends with ret
    {load} mov eax, ecx                          # 0050da91
    pop ebx                                      # 0050da93
    pop esi                                      # 0050da94
    pop edi                                      # 0050da95
    leave                                        # 0050da96
    ret                                          # 0050da97

