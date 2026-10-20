# FUN_004e075a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e075a
# extent:       0x004e075a-0x004e0978 (542 code bytes)
# span:         0x004e075a-0x004e0978 (code 542, tables 0, padding 0)
# sha256:       4b380b02675e5f614cefe32bd08b21d90b68f92afa77574805201cbc2cec2971
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_taskbar_hover_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/inventory_button_runtime.h:27 says "0x4e075a (needs object state +0xf2a == 1): when the cursor rectangle"; src/blackmoor_app.mm:8824 says "0x4d3073 -> 0x4e075a with the cursor rectangle of the last pointer position."
# name-note:    Task bar hover handler: checks the cursor rectangle against the bar bounds and sets the cursor.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_3d, field_757, field_f22, field_f2a, field_f32, field_f36; [ecx + n] field_35, field_41, field_757, field_f22, field_f36; [edi + n] field_minus_1; [edx + n] field_39, field_f26, field_f32, field_f36
# callees:      calls FUN_004e22fd, FUN_004e2967, FUN_0050ca3e, FUN_0044a2b7, FUN_00427a40
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 129 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_757, 0x757  # offset +0x757
.equ field_f22, 0xf22  # offset +0xf22
.equ field_f26, 0xf26  # offset +0xf26
.equ field_f2a, 0xf2a  # offset +0xf2a
.equ field_f32, 0xf32  # offset +0xf32
.equ field_f36, 0xf36  # offset +0xf36

# --- external targets -----------------------------------------------
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004e22fd, .text + (0x004e22fd - 0x401000)
.set FUN_004e2967, .text + (0x004e2967 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004e075a - 0x401000
.globl FUN_004e075a
FUN_004e075a:
    # block 0x004e075a: entry, 8 instruction(s), ends with jne to 0x004e0971 (forward)
    push ebp                                     # 004e075a
    {load} mov ebp, esp                          # 004e075b
    sub esp, 0xc                                 # 004e075d
    push edi                                     # 004e0760
    mov dword ptr [ebp - local_8], ecx           # 004e0761
    mov eax, dword ptr [ebp - local_8]           # 004e0764
    cmp dword ptr [eax + field_f2a], 0x1         # 004e0767
    jne.d32 L_004e0971                           # 004e076e
    # block 0x004e0774: entered by fall-through of jne at 0x004e076e, 4 instruction(s), ends with jl to 0x004e07f1 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e0774
    mov edx, dword ptr [0x583102]                # 004e0777
    cmp edx, dword ptr [ecx + field_35]          # 004e077d
    jl.d8 L_004e07f1                             # 004e0780
    # block 0x004e0782: entered by fall-through of jl at 0x004e0780, 4 instruction(s), ends with jg to 0x004e07f1 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e0782
    mov ecx, dword ptr [0x58310a]                # 004e0785
    cmp ecx, dword ptr [eax + field_3d]          # 004e078b
    jg.d8 L_004e07f1                             # 004e078e
    # block 0x004e0790: entered by fall-through of jg at 0x004e078e, 4 instruction(s), ends with jl to 0x004e07f1 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004e0790
    mov eax, dword ptr [0x583106]                # 004e0793
    cmp eax, dword ptr [edx + field_39]          # 004e0798
    jl.d8 L_004e07f1                             # 004e079b
    # block 0x004e079d: entered by fall-through of jl at 0x004e079b, 4 instruction(s), ends with jg to 0x004e07f1 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e079d
    mov edx, dword ptr [0x58310e]                # 004e07a0
    cmp edx, dword ptr [ecx + field_41]          # 004e07a6
    jg.d8 L_004e07f1                             # 004e07a9
    # block 0x004e07ab: entered by fall-through of jg at 0x004e07a9, 11 instruction(s), falls into the block at 0x004e07f1
    mov dword ptr [0x5b44f0], 0x4                # 004e07ab
    mov dword ptr [0x5b44f4], 0x0                # 004e07b5
    mov eax, dword ptr [0x5d0377]                # 004e07bf
    mov dword ptr [0x5d162d], eax                # 004e07c4
    mov ecx, dword ptr [0x5b44f0]                # 004e07c9
    shl ecx, 0x5                                 # 004e07cf
    mov edx, dword ptr [0x5b44f4]                # 004e07d2
    shl edx, 0x4                                 # 004e07d8
    lea eax, [ecx + edx + 0x5b160c]              # 004e07db
    mov dword ptr [0x5d1631], eax                # 004e07e2
    mov dword ptr [0x5d1639], 0x1                # 004e07e7
L_004e07f1:
    # block 0x004e07f1: entered by jl at 0x004e0780; jg at 0x004e078e; jl at 0x004e079b; jg at 0x004e07a9, 22 instruction(s), ends with forward jump to 0x004e0868
    mov ecx, dword ptr [0x5b44f0]                # 004e07f1
    shl ecx, 0x4                                 # 004e07f7
    mov edx, dword ptr [0x5b44f4]                # 004e07fa
    mov eax, dword ptr [0x583102]                # 004e0800
    add eax, dword ptr [ecx + 8*edx + 0x5b30cc]  # 004e0805
    mov ecx, dword ptr [ebp - local_8]           # 004e080c
    mov dword ptr [ecx + field_f22], eax         # 004e080f
    mov edx, dword ptr [0x5b44f0]                # 004e0815
    shl edx, 0x4                                 # 004e081b
    mov eax, dword ptr [0x5b44f4]                # 004e081e
    mov ecx, dword ptr [0x583106]                # 004e0823
    add ecx, dword ptr [edx + 8*eax + 0x5b30d0]  # 004e0829
    mov edx, dword ptr [ebp - local_8]           # 004e0830
    mov dword ptr [edx + field_f26], ecx         # 004e0833
    mov eax, dword ptr [ebp - local_8]           # 004e0839
    mov ecx, dword ptr [eax + field_f22]         # 004e083c
    mov dword ptr [0x5c3a5b], ecx                # 004e0842
    mov edx, dword ptr [ebp - local_8]           # 004e0848
    mov eax, dword ptr [edx + field_f26]         # 004e084b
    mov dword ptr [0x5c3a5f], eax                # 004e0851
    mov dword ptr [ebp - local_4], 0x0           # 004e0856
    jmp.d8 L_004e0868                            # 004e085d
L_004e085f:
    # block 0x004e085f: entered by jmp at 0x004e096c, 3 instruction(s), falls into the block at 0x004e0868
    mov ecx, dword ptr [ebp - local_4]           # 004e085f
    add ecx, 0x1                                 # 004e0862
    mov dword ptr [ebp - local_4], ecx           # 004e0865
L_004e0868:
    # block 0x004e0868: entered by jmp at 0x004e085d, 2 instruction(s), ends with jge to 0x004e0971 (forward)
    cmp dword ptr [ebp - local_4], 0x5           # 004e0868
    jge.d32 L_004e0971                           # 004e086c
    # block 0x004e0872: entered by fall-through of jge at 0x004e086c, 13 instruction(s), calls FUN_004e22fd, ends with je to 0x004e096c (forward)
    mov edx, dword ptr [ebp - local_8]           # 004e0872
    mov ax, word ptr [edx + field_f26]           # 004e0875
    push eax                                     # 004e087c
    mov ecx, dword ptr [ebp - local_8]           # 004e087d
    mov dx, word ptr [ecx + field_f22]           # 004e0880
    push edx                                     # 004e0887
    mov eax, dword ptr [ebp - local_4]           # 004e0888
    imul eax, eax, 0x18f                         # 004e088b
    mov ecx, dword ptr [ebp - local_8]           # 004e0891
    lea ecx, [ecx + eax + field_757]             # 004e0894
    call FUN_004e22fd                            # 004e089b
    test eax, eax                                # 004e08a0
    je.d32 L_004e096c                            # 004e08a2
    # block 0x004e08a8: entered by fall-through of je at 0x004e08a2, 12 instruction(s), calls FUN_004e2967, ends with je to 0x004e0965 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e08a8
    imul edx, edx, 0x18f                         # 004e08ab
    mov eax, dword ptr [ebp - local_8]           # 004e08b1
    lea ecx, [eax + edx + field_757]             # 004e08b4
    call FUN_004e2967                            # 004e08bb
    mov ecx, dword ptr [ebp - local_8]           # 004e08c0
    mov dword ptr [ecx + field_f36], eax         # 004e08c3
    mov edx, dword ptr [ebp - local_8]           # 004e08c9
    mov eax, dword ptr [ebp - local_8]           # 004e08cc
    mov ecx, dword ptr [edx + field_f36]         # 004e08cf
    cmp ecx, dword ptr [eax + field_f32]         # 004e08d5
    je.d32 L_004e0965                            # 004e08db
    # block 0x004e08e1: entered by fall-through of je at 0x004e08db, 3 instruction(s), ends with je to 0x004e0953 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004e08e1
    test edx, edx                                # 004e08e8
    je.d8 L_004e0953                             # 004e08ea
    # block 0x004e08ec: entered by fall-through of je at 0x004e08ea, 21 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x004e0943 (forward)
    mov eax, dword ptr [0x5bb57b]                # 004e08ec
    push eax                                     # 004e08f1
    mov ecx, dword ptr [ebp - local_8]           # 004e08f2
    mov edx, dword ptr [ecx + field_f36]         # 004e08f5
    push edx                                     # 004e08fb
    push 0x55bb54                                # 004e08fc
    push 0x63888b                                # 004e0901
    call FUN_0050ca3e                            # 004e0906
    add esp, 0x10                                # 004e090b
    push 0x63888b                                # 004e090e
    call FUN_0044a2b7                            # 004e0913
    add esp, 0x4                                 # 004e0918
    mov edi, 0x63888b                            # 004e091b
    or ecx, -0x1                                 # 004e0920
    {load} xor eax, eax                          # 004e0923
    repne scasb al, byte ptr es:[edi]            # 004e0925
    mov ax, word ptr [0x55bba4]                  # 004e0927
    mov word ptr [edi - field_minus_1], ax       # 004e092d
    mov ecx, 0x1                                 # 004e0931
    test ecx, ecx                                # 004e0936
    je.d8 L_004e0943                             # 004e0938
    # block 0x004e093a: entered by fall-through of je at 0x004e0938, 2 instruction(s), ends with forward jump to 0x004e0953
    mov dword ptr [ebp - local_c], 0x0           # 004e093a
    jmp.d8 L_004e0953                            # 004e0941
L_004e0943:
    # block 0x004e0943: entered by je at 0x004e0938, 4 instruction(s), calls FUN_00427a40, falls into the block at 0x004e0953
    push 0x63888b                                # 004e0943
    call FUN_00427a40                            # 004e0948
    add esp, 0x4                                 # 004e094d
    mov dword ptr [ebp - local_c], eax           # 004e0950
L_004e0953:
    # block 0x004e0953: entered by je at 0x004e08ea; jmp at 0x004e0941, 4 instruction(s), falls into the block at 0x004e0965
    mov edx, dword ptr [ebp - local_8]           # 004e0953
    mov eax, dword ptr [ebp - local_8]           # 004e0956
    mov ecx, dword ptr [eax + field_f36]         # 004e0959
    mov dword ptr [edx + field_f32], ecx         # 004e095f
L_004e0965:
    # block 0x004e0965: entered by je at 0x004e08db, 2 instruction(s), ends with forward jump to 0x004e0973
    mov eax, 0x1                                 # 004e0965
    jmp.d8 L_004e0973                            # 004e096a
L_004e096c:
    # block 0x004e096c: entered by je at 0x004e08a2, 1 instruction(s), ends with backward jump to 0x004e085f
    jmp.d32 L_004e085f                           # 004e096c
L_004e0971:
    # block 0x004e0971: entered by jne at 0x004e076e; jge at 0x004e086c, 1 instruction(s), falls into the block at 0x004e0973
    {load} xor eax, eax                          # 004e0971
L_004e0973:
    # block 0x004e0973: entered by jmp at 0x004e096a, 4 instruction(s), ends with ret
    pop edi                                      # 004e0973
    {load} mov esp, ebp                          # 004e0974
    pop ebp                                      # 004e0976
    ret                                          # 004e0977

