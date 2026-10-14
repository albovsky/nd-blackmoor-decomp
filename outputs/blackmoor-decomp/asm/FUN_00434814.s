# FUN_00434814
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00434814
# extent:       0x00434814-0x00434879 (101 code bytes)
# span:         0x00434814-0x00434880 (code 101, tables 0, padding 7)
# sha256:       24d15307938eee361cee2f2c48ae37053efa935dfc2e292fe2cd60e1bbb48acf
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
.equ local_8, 0x8  # [ebp - 0x8]
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------

.org 0x00434814 - 0x401000
.globl FUN_00434814
FUN_00434814:
    # block 0x00434814: <unfilled>
    push ebp                                     # 00434814
    {load} mov ebp, esp                          # 00434815
    sub esp, 0x8                                 # 00434817
    mov dword ptr [ebp - local_8], ecx           # 0043481a
    mov word ptr [ebp - local_4], 0x0            # 0043481d
    jmp.d8 L_00434831                            # 00434823
L_00434825:
    # block 0x00434825: <unfilled>
    mov ax, word ptr [ebp - local_4]             # 00434825
    .insn 0x66, 0x05, 0x0001{:u16}               # 00434829
    mov word ptr [ebp - local_4], ax             # 0043482d
L_00434831:
    # block 0x00434831: <unfilled>
    movsx ecx, word ptr [ebp - local_4]          # 00434831
    cmp ecx, 0x4                                 # 00434835
    jge.d8 L_00434863                            # 00434838
    # block 0x0043483a: <unfilled>
    movsx edx, word ptr [ebp - local_4]          # 0043483a
    mov eax, dword ptr [ebp + arg_8]             # 0043483e
    movsx ecx, byte ptr [eax + edx]              # 00434841
    test ecx, ecx                                # 00434845
    je.d8 L_0043485f                             # 00434847
    # block 0x00434849: <unfilled>
    movsx edx, word ptr [ebp - local_4]          # 00434849
    movsx eax, word ptr [ebp - local_4]          # 0043484d
    mov ecx, dword ptr [ebp + arg_8]             # 00434851
    mov dl, byte ptr [ecx + edx]                 # 00434854
    mov byte ptr [eax + 0x63a590], dl            # 00434857
    jmp.d8 L_00434861                            # 0043485d
L_0043485f:
    # block 0x0043485f: <unfilled>
    jmp.d8 L_00434863                            # 0043485f
L_00434861:
    # block 0x00434861: <unfilled>
    jmp.d8 L_00434825                            # 00434861
L_00434863:
    # block 0x00434863: <unfilled>
    movsx eax, word ptr [ebp - local_4]          # 00434863
    mov byte ptr [eax + 0x63a590], 0x0           # 00434867
    mov eax, 0x63a590                            # 0043486e
    {load} mov esp, ebp                          # 00434873
    pop ebp                                      # 00434875
    ret 0x4                                      # 00434876

# --- data items (not part of the function) -------------------------
.org 0x00434879 - 0x401000
PAD_00434879:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc
