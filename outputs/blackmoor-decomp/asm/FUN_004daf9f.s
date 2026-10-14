# FUN_004daf9f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daf9f
# extent:       0x004daf9f-0x004dafc3 (36 code bytes)
# span:         0x004daf9f-0x004dafc3 (code 36, tables 0, padding 0)
# sha256:       f443aaff08be83a4918c28dca4648dc31659f730c9d6b22fa596627a776d29d0
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
.equ arg_c, 0xc  # [ebp + 0xc]

# --- external targets -----------------------------------------------

.org 0x004daf9f - 0x401000
.globl FUN_004daf9f
FUN_004daf9f:
    # block 0x004daf9f: <unfilled>
    push ebp                                     # 004daf9f
    {load} mov ebp, esp                          # 004dafa0
    push ecx                                     # 004dafa2
    mov dword ptr [ebp - local_4], ecx           # 004dafa3
    mov eax, dword ptr [ebp - local_4]           # 004dafa6
    mov ecx, dword ptr [ebp + arg_c]             # 004dafa9
    mov edx, dword ptr [ecx]                     # 004dafac
    mov dword ptr [eax + 0x18], edx              # 004dafae
    mov eax, dword ptr [ebp - local_4]           # 004dafb1
    mov ecx, dword ptr [ebp + arg_c]             # 004dafb4
    mov edx, dword ptr [ecx + 0x4]               # 004dafb7
    mov dword ptr [eax + 0x1c], edx              # 004dafba
    {load} mov esp, ebp                          # 004dafbd
    pop ebp                                      # 004dafbf
    ret 0x8                                      # 004dafc0
