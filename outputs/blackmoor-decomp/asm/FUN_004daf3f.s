# FUN_004daf3f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daf3f
# extent:       0x004daf3f-0x004daf6e (47 code bytes)
# span:         0x004daf3f-0x004daf6e (code 47, tables 0, padding 0)
# sha256:       d14f2737a806fb01ffd15002d2d0d291d9bff0f9c77849a4524bc55567db6fcc
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

.org 0x004daf3f - 0x401000
.globl FUN_004daf3f
FUN_004daf3f:
    # block 0x004daf3f: <unfilled>
    push ebp                                     # 004daf3f
    {load} mov ebp, esp                          # 004daf40
    push ecx                                     # 004daf42
    mov dword ptr [ebp - local_4], ecx           # 004daf43
    mov eax, dword ptr [ebp - local_4]           # 004daf46
    cmp dword ptr [eax], 0x0                     # 004daf49
    je.d8 L_004daf68                             # 004daf4c
    # block 0x004daf4e: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004daf4e
    mov dword ptr [ecx], 0x0                     # 004daf51
    mov edx, dword ptr [ebp - local_4]           # 004daf57
    mov dword ptr [edx + 0xc], 0x0               # 004daf5a
    mov eax, 0x1                                 # 004daf61
    jmp.d8 L_004daf6a                            # 004daf66
L_004daf68:
    # block 0x004daf68: <unfilled>
    {load} xor eax, eax                          # 004daf68
L_004daf6a:
    # block 0x004daf6a: <unfilled>
    {load} mov esp, ebp                          # 004daf6a
    pop ebp                                      # 004daf6c
    ret                                          # 004daf6d
