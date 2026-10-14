# FUN_0044aff2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044aff2
# extent:       0x0044aff2-0x0044b05a (104 code bytes)
# span:         0x0044aff2-0x0044b05a (code 104, tables 0, padding 0)
# sha256:       f030cbb26d5dd17c35cc5f9cdc0ca2b8ca447ae2e0c387682b16d0c7fd6e0489
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
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

# --- external targets -----------------------------------------------

.org 0x0044aff2 - 0x401000
.globl FUN_0044aff2
FUN_0044aff2:
    # block 0x0044aff2: <unfilled>
    push ebp                                     # 0044aff2
    {load} mov ebp, esp                          # 0044aff3
    sub esp, 0x8                                 # 0044aff5
    mov dword ptr [ebp - local_8], ecx           # 0044aff8
    mov word ptr [ebp - local_4], 0x0            # 0044affb
    jmp.d8 L_0044b00f                            # 0044b001
L_0044b003:
    # block 0x0044b003: <unfilled>
    mov ax, word ptr [ebp - local_4]             # 0044b003
    .insn 0x66, 0x05, 0x0001{:u16}               # 0044b007
    mov word ptr [ebp - local_4], ax             # 0044b00b
L_0044b00f:
    # block 0x0044b00f: <unfilled>
    movsx ecx, word ptr [ebp - local_4]          # 0044b00f
    cmp ecx, 0x1d                                # 0044b013
    jg.d8 L_0044b028                             # 0044b016
    # block 0x0044b018: <unfilled>
    movsx edx, word ptr [ebp - local_4]          # 0044b018
    mov word ptr [2*edx + 0x58c959], 0x270f      # 0044b01c
    jmp.d8 L_0044b003                            # 0044b026
L_0044b028:
    # block 0x0044b028: <unfilled>
    mov word ptr [ebp - local_4], 0x1e           # 0044b028
    jmp.d8 L_0044b03c                            # 0044b02e
L_0044b030:
    # block 0x0044b030: <unfilled>
    mov ax, word ptr [ebp - local_4]             # 0044b030
    .insn 0x66, 0x05, 0x0001{:u16}               # 0044b034
    mov word ptr [ebp - local_4], ax             # 0044b038
L_0044b03c:
    # block 0x0044b03c: <unfilled>
    movsx ecx, word ptr [ebp - local_4]          # 0044b03c
    cmp ecx, 0x27                                # 0044b040
    jg.d8 L_0044b056                             # 0044b043
    # block 0x0044b045: <unfilled>
    movsx edx, word ptr [ebp - local_4]          # 0044b045
    mov dword ptr [4*edx + 0x58c91d], 0x461c3c00 # 0044b049
    jmp.d8 L_0044b030                            # 0044b054
L_0044b056:
    # block 0x0044b056: <unfilled>
    {load} mov esp, ebp                          # 0044b056
    pop ebp                                      # 0044b058
    ret                                          # 0044b059
