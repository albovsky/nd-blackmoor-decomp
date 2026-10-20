# FUN_004d3836
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3836
# extent:       0x004d3836-0x004d3992 (348 code bytes)
# span:         0x004d3836-0x004d3992 (code 348, tables 0, padding 0)
# sha256:       94e748ee1e867cf096786147be464ad56573cdc6c3dd273ae6900d6ac8d27775
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3836_text_width
# naming:       native port src/original_methods_fl19b.c:m4d3836_text_width (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4d3836_text_width. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 348 bytes.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4f, field_55, field_57, field_minus_41; [ecx + n] field_53; [edx + n] field_51, field_minus_30, field_minus_61
# callees:      calls FUN_004d214b, FUN_0050d651, FUN_0050d67f, FUN_0050d6a7, FUN_0050d6cf
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl19b.c:m4d3836_text_width (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 116 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_minus_30, 0x30  # offset -0x30
.equ field_minus_41, 0x41  # offset -0x41
.equ field_minus_61, 0x61  # offset -0x61
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_4f, 0x4f  # offset +0x4f
.equ field_51, 0x51  # offset +0x51
.equ field_53, 0x53  # offset +0x53
.equ field_55, 0x55  # offset +0x55
.equ field_57, 0x57  # offset +0x57

# --- external targets -----------------------------------------------
.set FUN_004d214b, .text + (0x004d214b - 0x401000)
.set FUN_0050d651, .text + (0x0050d651 - 0x401000)
.set FUN_0050d67f, .text + (0x0050d67f - 0x401000)
.set FUN_0050d6a7, .text + (0x0050d6a7 - 0x401000)
.set FUN_0050d6cf, .text + (0x0050d6cf - 0x401000)

.org 0x004d3836 - 0x401000
.globl FUN_004d3836
FUN_004d3836:
    # block 0x004d3836: entry, 7 instruction(s), ends with forward jump to 0x004d3853
    push ebp                                     # 004d3836
    {load} mov ebp, esp                          # 004d3837
    sub esp, 0xc                                 # 004d3839
    mov word ptr [ebp - local_4], 0x0            # 004d383c
    mov eax, dword ptr [ebp + arg_8]             # 004d3842
    mov dword ptr [ebp - local_c], eax           # 004d3845
    jmp.d8 L_004d3853                            # 004d3848
L_004d384a:
    # block 0x004d384a: entered by jmp at 0x004d3961; jmp at 0x004d3985, 3 instruction(s), falls into the block at 0x004d3853
    mov ecx, dword ptr [ebp + arg_8]             # 004d384a
    add ecx, 0x1                                 # 004d384d
    mov dword ptr [ebp + arg_8], ecx             # 004d3850
L_004d3853:
    # block 0x004d3853: entered by jmp at 0x004d3848, 4 instruction(s), ends with je to 0x004d398a (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004d3853
    movsx eax, byte ptr [edx]                    # 004d3856
    test eax, eax                                # 004d3859
    je.d32 L_004d398a                            # 004d385b
    # block 0x004d3861: entered by fall-through of je at 0x004d385b, 11 instruction(s), calls FUN_004d214b, ends with je to 0x004d3880 (forward)
    lea ecx, [ebp - local_8]                     # 004d3861
    push ecx                                     # 004d3864
    mov edx, dword ptr [ebp + arg_c]             # 004d3865
    push edx                                     # 004d3868
    mov eax, dword ptr [ebp + arg_8]             # 004d3869
    mov cl, byte ptr [eax]                       # 004d386c
    push ecx                                     # 004d386e
    call FUN_004d214b                            # 004d386f
    add esp, 0xc                                 # 004d3874
    test eax, eax                                # 004d3877
    je.d8 L_004d3880                             # 004d3879
    # block 0x004d387b: entered by fall-through of je at 0x004d3879, 1 instruction(s), ends with forward jump to 0x004d3966
    jmp.d32 L_004d3966                           # 004d387b
L_004d3880:
    # block 0x004d3880: entered by je at 0x004d3879, 7 instruction(s), calls FUN_0050d651, ends with je to 0x004d38cf (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004d3880
    movsx eax, byte ptr [edx]                    # 004d3883
    push eax                                     # 004d3886
    call FUN_0050d651                            # 004d3887
    add esp, 0x4                                 # 004d388c
    test eax, eax                                # 004d388f
    je.d8 L_004d38cf                             # 004d3891
    # block 0x004d3893: entered by fall-through of je at 0x004d3891, 7 instruction(s), calls FUN_0050d67f, ends with je to 0x004d38cf (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004d3893
    movsx edx, byte ptr [ecx]                    # 004d3896
    push edx                                     # 004d3899
    call FUN_0050d67f                            # 004d389a
    add esp, 0x4                                 # 004d389f
    test eax, eax                                # 004d38a2
    je.d8 L_004d38cf                             # 004d38a4
    # block 0x004d38a6: entered by fall-through of je at 0x004d38a4, 5 instruction(s), ends with jge to 0x004d38cf (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d38a6
    {load} xor ecx, ecx                          # 004d38a9
    mov cl, byte ptr [eax]                       # 004d38ab
    cmp ecx, 0x80                                # 004d38ad
    jge.d8 L_004d38cf                            # 004d38b3
    # block 0x004d38b5: entered by fall-through of jge at 0x004d38b3, 7 instruction(s), ends with forward jump to 0x004d3966
    mov edx, dword ptr [ebp + arg_8]             # 004d38b5
    movsx eax, byte ptr [edx]                    # 004d38b8
    mov ecx, dword ptr [ebp + arg_c]             # 004d38bb
    movsx edx, word ptr [ecx + field_53]         # 004d38be
    lea eax, [eax + edx - field_minus_41]        # 004d38c2
    mov word ptr [ebp - local_8], ax             # 004d38c6
    jmp.d32 L_004d3966                           # 004d38ca
L_004d38cf:
    # block 0x004d38cf: entered by je at 0x004d3891; je at 0x004d38a4; jge at 0x004d38b3, 7 instruction(s), calls FUN_0050d651, ends with je to 0x004d391a (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004d38cf
    movsx edx, byte ptr [ecx]                    # 004d38d2
    push edx                                     # 004d38d5
    call FUN_0050d651                            # 004d38d6
    add esp, 0x4                                 # 004d38db
    test eax, eax                                # 004d38de
    je.d8 L_004d391a                             # 004d38e0
    # block 0x004d38e2: entered by fall-through of je at 0x004d38e0, 7 instruction(s), calls FUN_0050d6a7, ends with je to 0x004d391a (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d38e2
    movsx ecx, byte ptr [eax]                    # 004d38e5
    push ecx                                     # 004d38e8
    call FUN_0050d6a7                            # 004d38e9
    add esp, 0x4                                 # 004d38ee
    test eax, eax                                # 004d38f1
    je.d8 L_004d391a                             # 004d38f3
    # block 0x004d38f5: entered by fall-through of je at 0x004d38f3, 5 instruction(s), ends with jge to 0x004d391a (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004d38f5
    {load} xor eax, eax                          # 004d38f8
    mov al, byte ptr [edx]                       # 004d38fa
    cmp eax, 0x80                                # 004d38fc
    jge.d8 L_004d391a                            # 004d3901
    # block 0x004d3903: entered by fall-through of jge at 0x004d3901, 7 instruction(s), ends with forward jump to 0x004d3966
    mov ecx, dword ptr [ebp + arg_8]             # 004d3903
    movsx edx, byte ptr [ecx]                    # 004d3906
    mov eax, dword ptr [ebp + arg_c]             # 004d3909
    movsx ecx, word ptr [eax + field_55]         # 004d390c
    lea edx, [edx + ecx - field_minus_61]        # 004d3910
    mov word ptr [ebp - local_8], dx             # 004d3914
    jmp.d8 L_004d3966                            # 004d3918
L_004d391a:
    # block 0x004d391a: entered by je at 0x004d38e0; je at 0x004d38f3; jge at 0x004d3901, 7 instruction(s), calls FUN_0050d6cf, ends with je to 0x004d3952 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d391a
    movsx ecx, byte ptr [eax]                    # 004d391d
    push ecx                                     # 004d3920
    call FUN_0050d6cf                            # 004d3921
    add esp, 0x4                                 # 004d3926
    test eax, eax                                # 004d3929
    je.d8 L_004d3952                             # 004d392b
    # block 0x004d392d: entered by fall-through of je at 0x004d392b, 5 instruction(s), ends with jge to 0x004d3952 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004d392d
    {load} xor eax, eax                          # 004d3930
    mov al, byte ptr [edx]                       # 004d3932
    cmp eax, 0x80                                # 004d3934
    jge.d8 L_004d3952                            # 004d3939
    # block 0x004d393b: entered by fall-through of jge at 0x004d3939, 7 instruction(s), ends with forward jump to 0x004d3966
    mov ecx, dword ptr [ebp + arg_8]             # 004d393b
    movsx edx, byte ptr [ecx]                    # 004d393e
    mov eax, dword ptr [ebp + arg_c]             # 004d3941
    movsx ecx, word ptr [eax + field_57]         # 004d3944
    lea edx, [edx + ecx - field_minus_30]        # 004d3948
    mov word ptr [ebp - local_8], dx             # 004d394c
    jmp.d8 L_004d3966                            # 004d3950
L_004d3952:
    # block 0x004d3952: entered by je at 0x004d392b; jge at 0x004d3939, 5 instruction(s), ends with backward jump to 0x004d384a
    mov eax, dword ptr [ebp + arg_c]             # 004d3952
    mov cx, word ptr [ebp - local_4]             # 004d3955
    add cx, word ptr [eax + field_4f]            # 004d3959
    mov word ptr [ebp - local_4], cx             # 004d395d
    jmp.d32 L_004d384a                           # 004d3961
L_004d3966:
    # block 0x004d3966: entered by jmp at 0x004d387b; jmp at 0x004d38ca; jmp at 0x004d3918; jmp at 0x004d3950, 10 instruction(s), ends with backward jump to 0x004d384a
    movsx edx, word ptr [ebp - local_8]          # 004d3966
    mov eax, dword ptr [ebp + arg_10]            # 004d396a
    movsx ecx, word ptr [eax + 4*edx]            # 004d396d
    mov edx, dword ptr [ebp + arg_c]             # 004d3971
    movsx eax, word ptr [edx + field_51]         # 004d3974
    {load} add ecx, eax                          # 004d3978
    mov dx, word ptr [ebp - local_4]             # 004d397a
    {load} add dx, cx                            # 004d397e
    mov word ptr [ebp - local_4], dx             # 004d3981
    jmp.d32 L_004d384a                           # 004d3985
L_004d398a:
    # block 0x004d398a: entered by je at 0x004d385b, 4 instruction(s), ends with ret
    mov ax, word ptr [ebp - local_4]             # 004d398a
    {load} mov esp, ebp                          # 004d398e
    pop ebp                                      # 004d3990
    ret                                          # 004d3991

