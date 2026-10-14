# FUN_004db000
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db000
# extent:       0x004db000-0x004db04f (79 code bytes)
# span:         0x004db000-0x004db04f (code 79, tables 0, padding 0)
# sha256:       8aab7f111dd59d365919ae80a2dd25a8d2cf25d5bbe12a26fcaf117e2e4966e5
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

.org 0x004db000 - 0x401000
.globl FUN_004db000
FUN_004db000:
    # block 0x004db000: <unfilled>
    push ebp                                     # 004db000
    {load} mov ebp, esp                          # 004db001
    push ecx                                     # 004db003
    mov dword ptr [ebp - local_4], ecx           # 004db004
    mov eax, dword ptr [ebp - local_4]           # 004db007
    cmp dword ptr [eax + 0x8], 0x0               # 004db00a
    je.d8 L_004db012                             # 004db00e
    # block 0x004db010: <unfilled>
    jmp.d8 L_004db049                            # 004db010
L_004db012:
    # block 0x004db012: <unfilled>
    cmp dword ptr [0x5c39e5], -0x1               # 004db012
    je.d8 L_004db02c                             # 004db019
    # block 0x004db01b: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004db01b
    cmp dword ptr [ecx], 0x0                     # 004db01e
    jne.d8 L_004db02c                            # 004db021
    # block 0x004db023: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004db023
    mov dword ptr [edx], 0x1                     # 004db026
L_004db02c:
    # block 0x004db02c: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 004db02c
    cmp dword ptr [eax + 0xc], 0x1               # 004db02f
    jne.d8 L_004db03f                            # 004db033
    # block 0x004db035: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004db035
    mov dword ptr [ecx + 0xc], 0x2               # 004db038
L_004db03f:
    # block 0x004db03f: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004db03f
    mov dword ptr [edx + 0x10], 0x0              # 004db042
L_004db049:
    # block 0x004db049: <unfilled>
    {load} mov esp, ebp                          # 004db049
    pop ebp                                      # 004db04b
    ret 0x8                                      # 004db04c
