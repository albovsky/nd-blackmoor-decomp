# FUN_004f6059
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f6059
# extent:       0x004f6059-0x004f61e7 (398 code bytes)
# span:         0x004f6059-0x004f61e7 (code 398, tables 0, padding 0)
# sha256:       f4096a7793dfdd7cfb28a8603c92c3a7a83836ecc1e3367b42c6b63ad52f106f
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # [ebp - 0x4]
.equ local_8, 0x8  # [ebp - 0x8]
.equ local_c, 0xc  # [ebp - 0xc]
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_004f80d3, .text + (0x004f80d3 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f6059 - 0x401000
.globl FUN_004f6059
FUN_004f6059:
    # block 0x004f6059: <unfilled>
    push ebp                                     # 004f6059
    {load} mov ebp, esp                          # 004f605a
    sub esp, 0xc                                 # 004f605c
    mov dword ptr [ebp - local_c], ecx           # 004f605f
    mov eax, dword ptr [ebp - local_c]           # 004f6062
    mov dword ptr [eax + 0x3c2], 0x3e8           # 004f6065
    mov ecx, dword ptr [ebp + arg_8]             # 004f606f
    imul ecx, ecx, 0x5bb                         # 004f6072
    mov edx, dword ptr [ebp - local_c]           # 004f6078
    mov eax, dword ptr [edx + 0x3ce]             # 004f607b
    {load} add eax, ecx                          # 004f6081
    mov dword ptr [ebp - local_4], eax           # 004f6083
    mov dword ptr [ebp - local_8], 0x0           # 004f6086
    mov ecx, dword ptr [ebp - local_c]           # 004f608d
    mov dword ptr [ecx + 0x3be], 0x1             # 004f6090
    mov ecx, dword ptr [ebp - local_c]           # 004f609a
    call FUN_004f709c                            # 004f609d
    test eax, eax                                # 004f60a2
    jne.d8 L_004f60ce                            # 004f60a4
    # block 0x004f60a6: <unfilled>
    mov edx, dword ptr [ebp - local_c]           # 004f60a6
    mov dword ptr [edx + 0x3c2], 0x3ea           # 004f60a9
    mov eax, dword ptr [ebp - local_c]           # 004f60b3
    mov dword ptr [eax + 0x3be], 0x0             # 004f60b6
    mov ecx, dword ptr [ebp - local_c]           # 004f60c0
    mov eax, dword ptr [ecx + 0x3be]             # 004f60c3
    jmp.d32 L_004f61e1                           # 004f60c9
L_004f60ce:
    # block 0x004f60ce: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004f60ce
    cmp dword ptr [edx + 0x162], 0x0             # 004f60d1
    je.d8 L_004f60e6                             # 004f60d8
    # block 0x004f60da: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 004f60da
    cmp dword ptr [eax + 0x28f], 0x0             # 004f60dd
    jne.d8 L_004f610e                            # 004f60e4
L_004f60e6:
    # block 0x004f60e6: <unfilled>
    mov ecx, dword ptr [ebp - local_c]           # 004f60e6
    mov dword ptr [ecx + 0x3c2], 0x3ef           # 004f60e9
    mov edx, dword ptr [ebp - local_c]           # 004f60f3
    mov dword ptr [edx + 0x3be], 0x0             # 004f60f6
    mov eax, dword ptr [ebp - local_c]           # 004f6100
    mov eax, dword ptr [eax + 0x3be]             # 004f6103
    jmp.d32 L_004f61e1                           # 004f6109
L_004f610e:
    # block 0x004f610e: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004f610e
    cmp dword ptr [ecx + 0x130], 0x0             # 004f6111
    jne.d8 L_004f612d                            # 004f6118
    # block 0x004f611a: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004f611a
    {load} xor eax, eax                          # 004f611d
    mov ax, word ptr [edx + 0x12c]               # 004f611f
    and eax, 0x1                                 # 004f6126
    test eax, eax                                # 004f6129
    jne.d8 L_004f614e                            # 004f612b
L_004f612d:
    # block 0x004f612d: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004f612d
    cmp dword ptr [ecx + 0x166], 0x0             # 004f6130
    jne.d8 L_004f614e                            # 004f6137
    # block 0x004f6139: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004f6139
    {load} xor eax, eax                          # 004f613c
    mov ax, word ptr [edx + 0x12c]               # 004f613e
    and eax, 0x100                               # 004f6145
    test eax, eax                                # 004f614a
    je.d8 L_004f6157                             # 004f614c
L_004f614e:
    # block 0x004f614e: <unfilled>
    mov ecx, dword ptr [ebp - local_8]           # 004f614e
    or ecx, 0x1                                  # 004f6151
    mov dword ptr [ebp - local_8], ecx           # 004f6154
L_004f6157:
    # block 0x004f6157: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004f6157
    mov dword ptr [edx + 0x287], 0x0             # 004f615a
    mov eax, dword ptr [ebp - local_8]           # 004f6164
    push eax                                     # 004f6167
    mov ecx, dword ptr [ebp - local_4]           # 004f6168
    mov edx, dword ptr [ecx + 0x28f]             # 004f616b
    push edx                                     # 004f6171
    mov ecx, dword ptr [ebp - local_c]           # 004f6172
    call FUN_004f80d3                            # 004f6175
    test eax, eax                                # 004f617a
    jne.d8 L_004f61a3                            # 004f617c
    # block 0x004f617e: <unfilled>
    mov eax, dword ptr [ebp - local_c]           # 004f617e
    mov dword ptr [eax + 0x3c2], 0x403           # 004f6181
    mov ecx, dword ptr [ebp - local_c]           # 004f618b
    mov dword ptr [ecx + 0x3be], 0x0             # 004f618e
    mov edx, dword ptr [ebp - local_c]           # 004f6198
    mov eax, dword ptr [edx + 0x3be]             # 004f619b
    jmp.d8 L_004f61e1                            # 004f61a1
L_004f61a3:
    # block 0x004f61a3: <unfilled>
    movsx eax, word ptr [0x63a4cd]               # 004f61a3
    test eax, eax                                # 004f61aa
    je.d8 L_004f61d8                             # 004f61ac
    # block 0x004f61ae: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004f61ae
    add ecx, 0x4                                 # 004f61b1
    push ecx                                     # 004f61b4
    mov edx, dword ptr [ebp + arg_8]             # 004f61b5
    push edx                                     # 004f61b8
    push 0x55e78c                                # 004f61b9
    push 0x63888b                                # 004f61be
    call FUN_0050ca3e                            # 004f61c3
    add esp, 0x10                                # 004f61c8
    push 0x63888b                                # 004f61cb
    call FUN_0044a2b7                            # 004f61d0
    add esp, 0x4                                 # 004f61d5
L_004f61d8:
    # block 0x004f61d8: <unfilled>
    mov eax, dword ptr [ebp - local_c]           # 004f61d8
    mov eax, dword ptr [eax + 0x3be]             # 004f61db
L_004f61e1:
    # block 0x004f61e1: <unfilled>
    {load} mov esp, ebp                          # 004f61e1
    pop ebp                                      # 004f61e3
    ret 0x4                                      # 004f61e4
