# FUN_004c7623
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c7623
# extent:       0x004c7623-0x004c7770 (333 code bytes)
# span:         0x004c7623-0x004c7770 (code 333, tables 0, padding 0)
# sha256:       66033d073d90ecf2ce92fdffa33eae3c9e2c461165de31c20e691c8c4897b11f
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c7623
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_5c, local_70, local_80, local_84, local_88
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      calls FUN_004c4067, FUN_004c808f, FUN_004c4202, FUN_004c952f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 115 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_5c, 0x5c  # offset -0x5c
.equ local_70, 0x70  # offset -0x70
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_004c4067, .text + (0x004c4067 - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004c808f, .text + (0x004c808f - 0x401000)
.set FUN_004c952f, .text + (0x004c952f - 0x401000)

.org 0x004c7623 - 0x401000
.globl FUN_004c7623
FUN_004c7623:
    # block 0x004c7623: entry, 108 instruction(s), calls FUN_004c4067, FUN_004c808f, FUN_004c4202, ends with jne to 0x004c776a (forward)
    push ebp                                     # 004c7623
    {load} mov ebp, esp                          # 004c7624
    sub esp, 0x88                                # 004c7626
    mov dword ptr [ebp - local_88], ecx          # 004c762c
    push 0x20                                    # 004c7632
    push 0x5553a8                                # 004c7634
    lea eax, [ebp - local_80]                    # 004c7639
    push eax                                     # 004c763c
    push 0x0                                     # 004c763d
    mov ecx, dword ptr [ebp + arg_8]             # 004c763f
    push ecx                                     # 004c7642
    mov ecx, dword ptr [ebp - local_88]          # 004c7643
    call FUN_004c4067                            # 004c7649
    mov edx, dword ptr [ebp - local_70]          # 004c764e
    mov dword ptr [ebp - local_84], edx          # 004c7651
    mov eax, dword ptr [ebp - local_5c]          # 004c7657
    mov dword ptr [ebp - local_4], eax           # 004c765a
    mov cx, word ptr [ebp + arg_10]              # 004c765d
    push ecx                                     # 004c7661
    mov edx, dword ptr [ebp + arg_c]             # 004c7662
    mov eax, dword ptr [edx + field_4]           # 004c7665
    push eax                                     # 004c7668
    mov ecx, dword ptr [ebp + arg_c]             # 004c7669
    mov edx, dword ptr [ecx + field_8]           # 004c766c
    push edx                                     # 004c766f
    mov eax, dword ptr [ebp + arg_c]             # 004c7670
    mov ecx, dword ptr [eax + field_4]           # 004c7673
    push ecx                                     # 004c7676
    mov edx, dword ptr [ebp + arg_c]             # 004c7677
    mov eax, dword ptr [edx]                     # 004c767a
    push eax                                     # 004c767c
    mov ecx, dword ptr [ebp - local_84]          # 004c767d
    push ecx                                     # 004c7683
    mov edx, dword ptr [ebp - local_4]           # 004c7684
    push edx                                     # 004c7687
    mov ecx, dword ptr [ebp - local_88]          # 004c7688
    call FUN_004c808f                            # 004c768e
    mov ax, word ptr [ebp + arg_10]              # 004c7693
    push eax                                     # 004c7697
    mov ecx, dword ptr [ebp + arg_c]             # 004c7698
    mov edx, dword ptr [ecx + field_c]           # 004c769b
    push edx                                     # 004c769e
    mov eax, dword ptr [ebp + arg_c]             # 004c769f
    mov ecx, dword ptr [eax + field_8]           # 004c76a2
    push ecx                                     # 004c76a5
    mov edx, dword ptr [ebp + arg_c]             # 004c76a6
    mov eax, dword ptr [edx + field_c]           # 004c76a9
    push eax                                     # 004c76ac
    mov ecx, dword ptr [ebp + arg_c]             # 004c76ad
    mov edx, dword ptr [ecx]                     # 004c76b0
    push edx                                     # 004c76b2
    mov eax, dword ptr [ebp - local_84]          # 004c76b3
    push eax                                     # 004c76b9
    mov ecx, dword ptr [ebp - local_4]           # 004c76ba
    push ecx                                     # 004c76bd
    mov ecx, dword ptr [ebp - local_88]          # 004c76be
    call FUN_004c808f                            # 004c76c4
    mov dx, word ptr [ebp + arg_10]              # 004c76c9
    push edx                                     # 004c76cd
    mov eax, dword ptr [ebp + arg_c]             # 004c76ce
    mov ecx, dword ptr [eax + field_c]           # 004c76d1
    push ecx                                     # 004c76d4
    mov edx, dword ptr [ebp + arg_c]             # 004c76d5
    mov eax, dword ptr [edx]                     # 004c76d8
    push eax                                     # 004c76da
    mov ecx, dword ptr [ebp + arg_c]             # 004c76db
    mov edx, dword ptr [ecx + field_4]           # 004c76de
    push edx                                     # 004c76e1
    mov eax, dword ptr [ebp + arg_c]             # 004c76e2
    mov ecx, dword ptr [eax]                     # 004c76e5
    push ecx                                     # 004c76e7
    mov edx, dword ptr [ebp - local_84]          # 004c76e8
    push edx                                     # 004c76ee
    mov eax, dword ptr [ebp - local_4]           # 004c76ef
    push eax                                     # 004c76f2
    mov ecx, dword ptr [ebp - local_88]          # 004c76f3
    call FUN_004c808f                            # 004c76f9
    mov cx, word ptr [ebp + arg_10]              # 004c76fe
    push ecx                                     # 004c7702
    mov edx, dword ptr [ebp + arg_c]             # 004c7703
    mov eax, dword ptr [edx + field_c]           # 004c7706
    push eax                                     # 004c7709
    mov ecx, dword ptr [ebp + arg_c]             # 004c770a
    mov edx, dword ptr [ecx + field_8]           # 004c770d
    push edx                                     # 004c7710
    mov eax, dword ptr [ebp + arg_c]             # 004c7711
    mov ecx, dword ptr [eax + field_4]           # 004c7714
    push ecx                                     # 004c7717
    mov edx, dword ptr [ebp + arg_c]             # 004c7718
    mov eax, dword ptr [edx + field_8]           # 004c771b
    push eax                                     # 004c771e
    mov ecx, dword ptr [ebp - local_84]          # 004c771f
    push ecx                                     # 004c7725
    mov edx, dword ptr [ebp - local_4]           # 004c7726
    push edx                                     # 004c7729
    mov ecx, dword ptr [ebp - local_88]          # 004c772a
    call FUN_004c808f                            # 004c7730
    push 0x5553d0                                # 004c7735
    mov eax, dword ptr [ebp + arg_c]             # 004c773a
    push eax                                     # 004c773d
    mov ecx, dword ptr [ebp + arg_8]             # 004c773e
    push ecx                                     # 004c7741
    mov ecx, dword ptr [ebp - local_88]          # 004c7742
    call FUN_004c4202                            # 004c7748
    mov edx, dword ptr [ebp - local_88]          # 004c774d
    mov eax, dword ptr [ebp + arg_8]             # 004c7753
    cmp eax, dword ptr [edx + field_c]           # 004c7756
    jne.d8 L_004c776a                            # 004c7759
    # block 0x004c775b: entered by fall-through of jne at 0x004c7759, 4 instruction(s), calls FUN_004c952f, falls into the block at 0x004c776a
    mov ecx, dword ptr [ebp + arg_c]             # 004c775b
    push ecx                                     # 004c775e
    mov ecx, dword ptr [ebp - local_88]          # 004c775f
    call FUN_004c952f                            # 004c7765
L_004c776a:
    # block 0x004c776a: entered by jne at 0x004c7759, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004c776a
    pop ebp                                      # 004c776c
    ret 0xc                                      # 004c776d

