# FUN_004daef1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daef1
# extent:       0x004daef1-0x004daf02 (17 code bytes)
# span:         0x004daef1-0x004daf02 (code 17, tables 0, padding 0)
# sha256:       a26cd3064709e57ee483cfbbb2753f8da501718ce4ced1e834a5123dd2fcaa3d
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

.org 0x004daef1 - 0x401000
.globl FUN_004daef1
FUN_004daef1:
    # block 0x004daef1: <unfilled>
    push ebp                                     # 004daef1
    {load} mov ebp, esp                          # 004daef2
    push ecx                                     # 004daef4
    mov dword ptr [ebp - local_4], ecx           # 004daef5
    mov eax, dword ptr [ebp - local_4]           # 004daef8
    mov eax, dword ptr [eax + 0xc]               # 004daefb
    {load} mov esp, ebp                          # 004daefe
    pop ebp                                      # 004daf00
    ret                                          # 004daf01
