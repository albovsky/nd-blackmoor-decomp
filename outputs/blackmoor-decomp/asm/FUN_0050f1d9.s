# FUN_0050f1d9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f1d9
# extent:       0x0050f1d9-0x0050f227 (78 code bytes)
# span:         0x0050f1d9-0x0050f227 (code 78, tables 0, padding 0)
# sha256:       e9602fb435ba6e492a49997a9809e95763bc31dcb8f36acdd7a1bdd6620b72de
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f1d9
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050f227; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050f227, .text + (0x0050f227 - 0x401000)

.org 0x0050f1d9 - 0x401000
.globl FUN_0050f1d9
FUN_0050f1d9:
    # block 0x0050f1d9: entry, 7 instruction(s), ends with jbe to 0x0050f224 (forward)
    push ebp                                     # 0050f1d9
    {load} mov ebp, esp                          # 0050f1da
    mov eax, dword ptr [ebp + arg_8]             # 0050f1dc
    push edi                                     # 0050f1df
    mov edi, dword ptr [ebp + arg_c]             # 0050f1e0
    {load} cmp edi, eax                          # 0050f1e3
    jbe.d8 L_0050f224                            # 0050f1e5
    # block 0x0050f1e7: entered by fall-through of jbe at 0x0050f1e5, 5 instruction(s), falls into the block at 0x0050f1f1
    mov ecx, dword ptr [ebp + arg_10]            # 0050f1e7
    push ebx                                     # 0050f1ea
    {load} add eax, ecx                          # 0050f1eb
    push esi                                     # 0050f1ed
    mov dword ptr [ebp + arg_c], eax             # 0050f1ee
L_0050f1f1:
    # block 0x0050f1f1: entered by ja at 0x0050f220, 2 instruction(s), falls into the block at 0x0050f1f7
    mov ebx, dword ptr [ebp + arg_8]             # 0050f1f1
    mov esi, dword ptr [ebp + arg_c]             # 0050f1f4
L_0050f1f7:
    # block 0x0050f1f7: entered by jmp at 0x0050f20b, 2 instruction(s), ends with ja to 0x0050f20d (forward)
    {load} cmp esi, edi                          # 0050f1f7
    ja.d8 L_0050f20d                             # 0050f1f9
    # block 0x0050f1fb: entered by fall-through of ja at 0x0050f1f9, 7 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with jle to 0x0050f208 (forward)
    push ebx                                     # 0050f1fb
    push esi                                     # 0050f1fc
    call dword ptr [ebp + arg_14]                # 0050f1fd
    pop ecx                                      # 0050f200
    test eax, eax                                # 0050f201
    pop ecx                                      # 0050f203
    jle.d8 L_0050f208                            # 0050f204
    # block 0x0050f206: entered by fall-through of jle at 0x0050f204, 1 instruction(s), falls into the block at 0x0050f208
    {load} mov ebx, esi                          # 0050f206
L_0050f208:
    # block 0x0050f208: entered by jle at 0x0050f204, 2 instruction(s), ends with backward jump to 0x0050f1f7
    add esi, dword ptr [ebp + arg_10]            # 0050f208
    jmp.d8 L_0050f1f7                            # 0050f20b
L_0050f20d:
    # block 0x0050f20d: entered by ja at 0x0050f1f9, 8 instruction(s), calls FUN_0050f227, ends with ja to 0x0050f1f1 (backward)
    push dword ptr [ebp + arg_10]                # 0050f20d
    push edi                                     # 0050f210
    push ebx                                     # 0050f211
    call FUN_0050f227                            # 0050f212
    sub edi, dword ptr [ebp + arg_10]            # 0050f217
    add esp, 0xc                                 # 0050f21a
    cmp edi, dword ptr [ebp + arg_8]             # 0050f21d
    ja.d8 L_0050f1f1                             # 0050f220
    # block 0x0050f222: entered by fall-through of ja at 0x0050f220, 2 instruction(s), falls into the block at 0x0050f224
    pop esi                                      # 0050f222
    pop ebx                                      # 0050f223
L_0050f224:
    # block 0x0050f224: entered by jbe at 0x0050f1e5, 3 instruction(s), ends with ret
    pop edi                                      # 0050f224
    pop ebp                                      # 0050f225
    ret                                          # 0050f226

