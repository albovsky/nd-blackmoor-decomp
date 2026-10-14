# FUN_004daf6e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daf6e
# extent:       0x004daf6e-0x004daf9f (49 code bytes)
# span:         0x004daf6e-0x004daf9f (code 49, tables 0, padding 0)
# sha256:       c9d366738b9dd578e5b9ba5ea0e3c507ef84d16e5bcb7f2838bc71082ebead67
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
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

# --- external targets -----------------------------------------------

.org 0x004daf6e - 0x401000
.globl FUN_004daf6e
FUN_004daf6e:
    # block 0x004daf6e: <unfilled>
    push ebp                                     # 004daf6e
    {load} mov ebp, esp                          # 004daf6f
    push ecx                                     # 004daf71
    mov dword ptr [ebp - local_4], ecx           # 004daf72
    mov eax, dword ptr [ebp - local_4]           # 004daf75
    cmp dword ptr [eax + 0x4], 0x0               # 004daf78
    je.d8 L_004daf99                             # 004daf7c
    # block 0x004daf7e: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004daf7e
    mov dword ptr [ecx + 0x4], 0x0               # 004daf81
    mov edx, dword ptr [ebp - local_4]           # 004daf88
    mov dword ptr [edx + 0x10], 0x0              # 004daf8b
    mov eax, 0x1                                 # 004daf92
    jmp.d8 L_004daf9b                            # 004daf97
L_004daf99:
    # block 0x004daf99: <unfilled>
    {load} xor eax, eax                          # 004daf99
L_004daf9b:
    # block 0x004daf9b: <unfilled>
    {load} mov esp, ebp                          # 004daf9b
    pop ebp                                      # 004daf9d
    ret                                          # 004daf9e
