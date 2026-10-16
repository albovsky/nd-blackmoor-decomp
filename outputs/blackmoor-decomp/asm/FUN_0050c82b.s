# FUN_0050c82b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c82b
# extent:       0x0050c82b-0x0050c8a0 (117 code bytes)
# span:         0x0050c82b-0x0050c8a0 (code 117, tables 0, padding 0)
# sha256:       ff55eff23255bb538cc8daf2bd104cea7983469b14c5511653a2bdd1f349bc68
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c82b
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_24; [ebx + n] field_18, field_1c, field_20
# callees:      calls FUN_00510516, FUN_0050c677
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         unreachable_code_entry:0x0050c898
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ arg_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_0050c677, .text + (0x0050c677 - 0x401000)
.set FUN_00510516, .text + (0x00510516 - 0x401000)

.org 0x0050c82b - 0x401000
.globl FUN_0050c82b
FUN_0050c82b:
    # block 0x0050c82b: entry, 11 instruction(s), ends with je to 0x0050c84e (forward)
    push ebp                                     # 0050c82b
    {load} mov ebp, esp                          # 0050c82c
    push ebx                                     # 0050c82e
    push esi                                     # 0050c82f
    push edi                                     # 0050c830
    cld                                          # 0050c831
    mov eax, dword ptr [ebp + arg_8]             # 0050c832
    mov eax, dword ptr [eax + field_4]           # 0050c835
    and eax, 0x66                                # 0050c838
    test eax, eax                                # 0050c83b
    je.d8 L_0050c84e                             # 0050c83d
    # block 0x0050c83f: entered by fall-through of je at 0x0050c83d, 5 instruction(s), ends with forward jump to 0x0050c89b
    mov eax, dword ptr [ebp + arg_c]             # 0050c83f
    mov dword ptr [eax + field_24], 0x1          # 0050c842
    push 0x1                                     # 0050c849
    pop eax                                      # 0050c84b
    jmp.d8 L_0050c89b                            # 0050c84c
L_0050c84e:
    # block 0x0050c84e: entered by je at 0x0050c83d, 17 instruction(s), calls FUN_00510516, ends with jne to 0x0050c88c (forward)
    push 0x1                                     # 0050c84e
    mov eax, dword ptr [ebp + arg_c]             # 0050c850
    push dword ptr [eax + field_14]              # 0050c853
    mov eax, dword ptr [ebp + arg_c]             # 0050c856
    push dword ptr [eax + field_10]              # 0050c859
    mov eax, dword ptr [ebp + arg_c]             # 0050c85c
    push dword ptr [eax + field_8]               # 0050c85f
    push 0x0                                     # 0050c862
    push dword ptr [ebp + arg_10]                # 0050c864
    mov eax, dword ptr [ebp + arg_c]             # 0050c867
    push dword ptr [eax + field_c]               # 0050c86a
    push dword ptr [ebp + arg_8]                 # 0050c86d
    call FUN_00510516                            # 0050c870
    add esp, 0x20                                # 0050c875
    mov eax, dword ptr [ebp + arg_c]             # 0050c878
    cmp dword ptr [eax + field_24], 0x0          # 0050c87b
    jne.d8 L_0050c88c                            # 0050c87f
    # block 0x0050c881: entered by fall-through of jne at 0x0050c87f, 3 instruction(s), calls FUN_0050c677, falls into the block at 0x0050c88c
    push dword ptr [ebp + arg_8]                 # 0050c881
    push dword ptr [ebp + arg_c]                 # 0050c884
    call FUN_0050c677                            # 0050c887
L_0050c88c:
    # block 0x0050c88c: entered by jne at 0x0050c87f, 4 instruction(s), ends with indirect jump dword ptr [ebx + 0x18]
    mov ebx, dword ptr [ebp + arg_c]             # 0050c88c
    mov esp, dword ptr [ebx + field_1c]          # 0050c88f
    mov ebp, dword ptr [ebx + field_20]          # 0050c892
    jmp dword ptr [ebx + field_18]               # 0050c895
    # block 0x0050c898: entered by follows jmp at 0x0050c895, 2 instruction(s), falls into the block at 0x0050c89b
    push 0x1                                     # 0050c898
    pop eax                                      # 0050c89a
L_0050c89b:
    # block 0x0050c89b: entered by jmp at 0x0050c84c, 5 instruction(s), ends with ret
    pop edi                                      # 0050c89b
    pop esi                                      # 0050c89c
    pop ebx                                      # 0050c89d
    pop ebp                                      # 0050c89e
    ret                                          # 0050c89f

