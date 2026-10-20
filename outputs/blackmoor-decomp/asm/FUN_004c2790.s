# FUN_004c2790
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c2790
# extent:       0x004c2790-0x004c2898 (264 code bytes)
# span:         0x004c2790-0x004c2898 (code 264, tables 0, padding 0)
# sha256:       7348763ea143298d0d536527aaa4800658c28dc84560003f3f6b534a268e23cf
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c2790
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_21, field_55; [ecx + n] field_4, field_33; [edx + n] field_18
# callees:      calls FUN_0051dc43, FUN_0042639d, FUN_004c97b4, FUN_004181c6
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:load_native_raw555_image (function ledger class candidate_port; also native_a36_load_surface, native_a77_random, native_aaa_alloc_slot, native_ad0_alloc_slot, native_ad1_alloc_slot, native_ad3_alloc_slot, native_ad9_alloc_slot, native_ada_alloc_slot, native_ae0_alloc_slot, native_ae4_alloc_slot, native_aea_image, native_aeb_view, native_aee_view, native_af6_alloc_slot; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 91 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_21, 0x21  # offset +0x21
.equ field_33, 0x33  # offset +0x33
.equ field_55, 0x55  # offset +0x55

# --- external targets -----------------------------------------------
.set FUN_004181c6, .text + (0x004181c6 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004c2790 - 0x401000
.globl FUN_004c2790
FUN_004c2790:
    # block 0x004c2790: entry, 14 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c27d6 (forward)
    push ebp                                     # 004c2790
    {load} mov ebp, esp                          # 004c2791
    sub esp, 0xc                                 # 004c2793
    push esi                                     # 004c2796
    push edi                                     # 004c2797
    mov dword ptr [ebp - local_c], ecx           # 004c2798
    push 0x59                                    # 004c279b
    call FUN_0051dc43                            # 004c279d
    add esp, 0x4                                 # 004c27a2
    mov dword ptr [ebp - local_8], eax           # 004c27a5
    mov eax, dword ptr [ebp - local_8]           # 004c27a8
    mov dword ptr [ebp - local_4], eax           # 004c27ab
    cmp dword ptr [ebp - local_4], 0x0           # 004c27ae
    jne.d8 L_004c27d6                            # 004c27b2
    # block 0x004c27b4: entered by fall-through of jne at 0x004c27b2, 9 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2890
    mov ecx, dword ptr [ebp + arg_c]             # 004c27b4
    push ecx                                     # 004c27b7
    push 0x553be8                                # 004c27b8
    mov ecx, 0x583979                            # 004c27bd
    call FUN_0042639d                            # 004c27c2
    mov ecx, dword ptr [ebp - local_c]           # 004c27c7
    call FUN_004c97b4                            # 004c27ca
    {load} xor eax, eax                          # 004c27cf
    jmp.d32 L_004c2890                           # 004c27d1
L_004c27d6:
    # block 0x004c27d6: entered by jne at 0x004c27b2, 13 instruction(s), ends with jb to 0x004c27fe (forward)
    mov ecx, 0x16                                # 004c27d6
    {load} xor eax, eax                          # 004c27db
    mov edi, dword ptr [ebp - local_4]           # 004c27dd
    rep stosd dword ptr es:[edi], eax            # 004c27e0
    stosb byte ptr es:[edi], al                  # 004c27e2
    mov edi, dword ptr [ebp + arg_14]            # 004c27e3
    or ecx, -0x1                                 # 004c27e6
    {load} xor eax, eax                          # 004c27e9
    repne scasb al, byte ptr es:[edi]            # 004c27eb
    not ecx                                      # 004c27ed
    add ecx, -0x1                                # 004c27ef
    cmp ecx, 0x19                                # 004c27f2
    jb.d8 L_004c27fe                             # 004c27f5
    # block 0x004c27f7: entered by fall-through of jb at 0x004c27f5, 2 instruction(s), falls into the block at 0x004c27fe
    mov edx, dword ptr [ebp + arg_14]            # 004c27f7
    mov byte ptr [edx + field_18], 0x0           # 004c27fa
L_004c27fe:
    # block 0x004c27fe: entered by jb at 0x004c27f5, 38 instruction(s), calls FUN_004181c6, ends with jne to 0x004c288d (forward)
    mov edi, dword ptr [ebp + arg_14]            # 004c27fe
    mov eax, dword ptr [ebp - local_4]           # 004c2801
    add eax, 0x8                                 # 004c2804
    {load} mov edx, eax                          # 004c2807
    or ecx, -0x1                                 # 004c2809
    {load} xor eax, eax                          # 004c280c
    repne scasb al, byte ptr es:[edi]            # 004c280e
    not ecx                                      # 004c2810
    {load} sub edi, ecx                          # 004c2812
    {load} mov esi, edi                          # 004c2814
    {load} mov eax, ecx                          # 004c2816
    {load} mov edi, edx                          # 004c2818
    shr ecx, 0x2                                 # 004c281a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c281d
    {load} mov ecx, eax                          # 004c281f
    and ecx, 0x3                                 # 004c2821
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c2824
    mov ecx, dword ptr [ebp - local_4]           # 004c2826
    mov edx, dword ptr [ebp + arg_10]            # 004c2829
    mov dword ptr [ecx + field_4], edx           # 004c282c
    mov eax, dword ptr [ebp - local_4]           # 004c282f
    mov word ptr [eax + field_21], 0x59          # 004c2832
    mov ecx, dword ptr [ebp - local_4]           # 004c2838
    mov dx, word ptr [0x639893]                  # 004c283b
    mov word ptr [ecx + field_33], dx            # 004c2842
    mov eax, dword ptr [ebp - local_4]           # 004c2846
    mov dword ptr [eax + field_55], 0x0          # 004c2849
    mov ecx, dword ptr [ebp - local_4]           # 004c2850
    push ecx                                     # 004c2853
    mov edx, dword ptr [ebp + arg_c]             # 004c2854
    push edx                                     # 004c2857
    mov eax, dword ptr [ebp + arg_8]             # 004c2858
    push eax                                     # 004c285b
    mov ecx, 0x5d2f31                            # 004c285c
    call FUN_004181c6                            # 004c2861
    mov ecx, dword ptr [ebp - local_4]           # 004c2866
    cmp dword ptr [ecx], 0x0                     # 004c2869
    jne.d8 L_004c288d                            # 004c286c
    # block 0x004c286e: entered by fall-through of jne at 0x004c286c, 9 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2890
    mov edx, dword ptr [ebp + arg_c]             # 004c286e
    push edx                                     # 004c2871
    push 0x553c40                                # 004c2872
    mov ecx, 0x583979                            # 004c2877
    call FUN_0042639d                            # 004c287c
    mov ecx, dword ptr [ebp - local_c]           # 004c2881
    call FUN_004c97b4                            # 004c2884
    {load} xor eax, eax                          # 004c2889
    jmp.d8 L_004c2890                            # 004c288b
L_004c288d:
    # block 0x004c288d: entered by jne at 0x004c286c, 1 instruction(s), falls into the block at 0x004c2890
    mov eax, dword ptr [ebp - local_4]           # 004c288d
L_004c2890:
    # block 0x004c2890: entered by jmp at 0x004c27d1; jmp at 0x004c288b, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 004c2890
    pop esi                                      # 004c2891
    {load} mov esp, ebp                          # 004c2892
    pop ebp                                      # 004c2894
    ret 0x10                                     # 004c2895

