# FUN_004dafc3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dafc3
# extent:       0x004dafc3-0x004db000 (61 code bytes)
# span:         0x004dafc3-0x004db000 (code 61, tables 0, padding 0)
# sha256:       fac063aec02e8b4aab491f5a203e8f07f765eb6c3a6bef5a309583cd69381498
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

.org 0x004dafc3 - 0x401000
.globl FUN_004dafc3
FUN_004dafc3:
    # block 0x004dafc3: <unfilled>
    push ebp                                     # 004dafc3
    {load} mov ebp, esp                          # 004dafc4
    push ecx                                     # 004dafc6
    mov dword ptr [ebp - local_4], ecx           # 004dafc7
    mov eax, dword ptr [ebp - local_4]           # 004dafca
    mov dword ptr [eax], 0x0                     # 004dafcd
    mov ecx, dword ptr [ebp - local_4]           # 004dafd3
    mov dword ptr [ecx + 0x8], 0x0               # 004dafd6
    mov edx, dword ptr [ebp - local_4]           # 004dafdd
    cmp dword ptr [edx + 0xc], 0x0               # 004dafe0
    jne.d8 L_004daff0                            # 004dafe4
    # block 0x004dafe6: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 004dafe6
    mov dword ptr [eax + 0xc], 0x1               # 004dafe9
L_004daff0:
    # block 0x004daff0: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004daff0
    mov dword ptr [ecx + 0x10], 0x0              # 004daff3
    {load} mov esp, ebp                          # 004daffa
    pop ebp                                      # 004daffc
    ret 0x8                                      # 004daffd
