# FUN_0051b720
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b720
# extent:       0x0051b720-0x0051b7b1 (145 code bytes)
# span:         0x0051b720-0x0051b7b1 (code 145, tables 0, padding 0)
# sha256:       333bd76a329929e2f247787fae94764e532c4ca2b4ee60b1cbf0d0fd9bbcc291
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b720
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_14, field_34; [ebp + n] field_8, field_a, field_b, field_minus_4, field_minus_c, field_minus_10, field_minus_38; [esi + n] field_10, field_24
# callees:      calls FUN_0050f978, USER32.dll!GetClassInfoA, USER32.dll!RegisterClassA, FUN_00525371, FUN_00525ffa, FUN_0052606a; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_38, 0x38  # offset -0x38
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_b, 0xb  # offset +0xb
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_24, 0x24  # offset +0x24
.equ field_34, 0x34  # offset +0x34

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525ffa, .text + (0x00525ffa - 0x401000)
.set FUN_0052606a, .text + (0x0052606a - 0x401000)

.org 0x0051b720 - 0x401000
.globl FUN_0051b720
FUN_0051b720:
    # block 0x0051b720: entry, 15 instruction(s), calls FUN_0050f978, USER32.dll!GetClassInfoA, ends with jne to 0x0051b79d (forward)
    mov eax, 0x528b80                            # 0051b720
    call FUN_0050f978                            # 0051b725
    sub esp, 0x30                                # 0051b72a
    push ebx                                     # 0051b72d
    push esi                                     # 0051b72e
    mov esi, dword ptr [ebp + field_8]           # 0051b72f
    push edi                                     # 0051b732
    lea eax, [ebp - field_minus_38]              # 0051b733
    mov dword ptr [ebp - field_minus_10], esp    # 0051b736
    push eax                                     # 0051b739
    push dword ptr [esi + field_24]              # 0051b73a
    push dword ptr [esi + field_10]              # 0051b73d
    call dword ptr [0x52a3ec]                    # 0051b740
    test eax, eax                                # 0051b746
    jne.d8 L_0051b79d                            # 0051b748
    # block 0x0051b74a: entered by fall-through of jne at 0x0051b748, 4 instruction(s), calls USER32.dll!RegisterClassA, ends with jne to 0x0051b75a (forward)
    push esi                                     # 0051b74a
    call dword ptr [0x52a3f0]                    # 0051b74b
    test ax, ax                                  # 0051b751
    jne.d8 L_0051b75a                            # 0051b754
    # block 0x0051b756: entered by fall-through of jne at 0x0051b754, 2 instruction(s), ends with forward jump to 0x0051b7a0
    {load} xor eax, eax                          # 0051b756
    jmp.d8 L_0051b7a0                            # 0051b758
L_0051b75a:
    # block 0x0051b75a: entered by jne at 0x0051b754, 4 instruction(s), calls FUN_00525371, ends with je to 0x0051b79d (forward)
    call FUN_00525371                            # 0051b75a
    {load} xor ebx, ebx                          # 0051b75f
    cmp byte ptr [eax + field_14], bl            # 0051b761
    je.d8 L_0051b79d                             # 0051b764
    # block 0x0051b766: entered by fall-through of je at 0x0051b764, 18 instruction(s), calls FUN_00525ffa, FUN_00525371, indirect esi, FUN_0052606a, falls into the block at 0x0051b79d
    push 0x1                                     # 0051b766
    call FUN_00525ffa                            # 0051b768
    mov dword ptr [ebp - field_minus_4], ebx     # 0051b76d
    call FUN_00525371                            # 0051b770
    push dword ptr [esi + field_24]              # 0051b775
    mov esi, dword ptr [0x52a228]                # 0051b778
    lea edi, [eax + field_34]                    # 0051b77e
    push edi                                     # 0051b781
    call esi                                     # 0051b782
    lea eax, [ebp + field_a]                     # 0051b784
    mov byte ptr [ebp + field_a], 0xa            # 0051b787
    push eax                                     # 0051b78b
    push edi                                     # 0051b78c
    mov byte ptr [ebp + field_b], bl             # 0051b78d
    call esi                                     # 0051b790
    or dword ptr [ebp - field_minus_4], -0x1     # 0051b792
    push 0x1                                     # 0051b796
    call FUN_0052606a                            # 0051b798
L_0051b79d:
    # block 0x0051b79d: entered by jne at 0x0051b748; je at 0x0051b764, 2 instruction(s), falls into the block at 0x0051b7a0
    push 0x1                                     # 0051b79d
    pop eax                                      # 0051b79f
L_0051b7a0:
    # block 0x0051b7a0: entered by jmp at 0x0051b758, 7 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051b7a0
    pop edi                                      # 0051b7a3
    pop esi                                      # 0051b7a4
    mov dword ptr fs:[0x0], ecx                  # 0051b7a5
    pop ebx                                      # 0051b7ac
    leave                                        # 0051b7ad
    ret 0x4                                      # 0051b7ae

