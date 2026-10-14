# FUN_00434773
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00434773
# extent:       0x00434773-0x004347b8 (69 code bytes)
# span:         0x00434773-0x004347b8 (code 69, tables 0, padding 0)
# sha256:       de3d170c384fb01b34ae6780aeeb5299e927e5d60330ef7c20a33819ede91ad1
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
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
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------

.org 0x00434773 - 0x401000
.globl FUN_00434773
FUN_00434773:
    # block 0x00434773: <unfilled>
    push ebp                                     # 00434773
    {load} mov ebp, esp                          # 00434774
    push ecx                                     # 00434776
    mov dword ptr [ebp - local_4], ecx           # 00434777
    mov eax, dword ptr [ebp + arg_8]             # 0043477a
    movsx ecx, byte ptr [eax]                    # 0043477d
    cmp ecx, 0x44                                # 00434780
    jne.d8 L_004347a9                            # 00434783
    # block 0x00434785: <unfilled>
    mov edx, dword ptr [ebp + arg_8]             # 00434785
    movsx eax, byte ptr [edx + 0x1]              # 00434788
    cmp eax, 0x41                                # 0043478c
    jne.d8 L_004347a9                            # 0043478f
    # block 0x00434791: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 00434791
    movsx edx, byte ptr [ecx + 0x2]              # 00434794
    cmp edx, 0x54                                # 00434798
    jne.d8 L_004347a9                            # 0043479b
    # block 0x0043479d: <unfilled>
    mov eax, dword ptr [ebp + arg_8]             # 0043479d
    movsx ecx, byte ptr [eax + 0x3]              # 004347a0
    cmp ecx, 0x41                                # 004347a4
    je.d8 L_004347ad                             # 004347a7
L_004347a9:
    # block 0x004347a9: <unfilled>
    {load} xor eax, eax                          # 004347a9
    jmp.d8 L_004347b2                            # 004347ab
L_004347ad:
    # block 0x004347ad: <unfilled>
    mov eax, 0x1                                 # 004347ad
L_004347b2:
    # block 0x004347b2: <unfilled>
    {load} mov esp, ebp                          # 004347b2
    pop ebp                                      # 004347b4
    ret 0x4                                      # 004347b5
