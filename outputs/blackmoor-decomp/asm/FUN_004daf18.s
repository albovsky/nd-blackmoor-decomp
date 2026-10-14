# FUN_004daf18
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daf18
# extent:       0x004daf18-0x004daf29 (17 code bytes)
# span:         0x004daf18-0x004daf29 (code 17, tables 0, padding 0)
# sha256:       d500a64daa2531474397cfd9958b6e1b88fc9b0b86d04aa2ea4015b50431bc91
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

.org 0x004daf18 - 0x401000
.globl FUN_004daf18
FUN_004daf18:
    # block 0x004daf18: <unfilled>
    push ebp                                     # 004daf18
    {load} mov ebp, esp                          # 004daf19
    push ecx                                     # 004daf1b
    mov dword ptr [ebp - local_4], ecx           # 004daf1c
    mov eax, dword ptr [ebp - local_4]           # 004daf1f
    mov eax, dword ptr [eax + 0x10]              # 004daf22
    {load} mov esp, ebp                          # 004daf25
    pop ebp                                      # 004daf27
    ret                                          # 004daf28
