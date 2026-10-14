# FUN_004daf02
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daf02
# extent:       0x004daf02-0x004daf18 (22 code bytes)
# span:         0x004daf02-0x004daf18 (code 22, tables 0, padding 0)
# sha256:       440ce1a4265fcbbe20bc6bf4b0ac22ad781ce98929626468e21a5e7175448719
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
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------

.org 0x004daf02 - 0x401000
.globl FUN_004daf02
FUN_004daf02:
    # block 0x004daf02: <unfilled>
    push ebp                                     # 004daf02
    {load} mov ebp, esp                          # 004daf03
    push ecx                                     # 004daf05
    mov dword ptr [ebp - local_4], ecx           # 004daf06
    mov eax, dword ptr [ebp - local_4]           # 004daf09
    mov ecx, dword ptr [ebp + arg_8]             # 004daf0c
    mov dword ptr [eax + 0xc], ecx               # 004daf0f
    {load} mov esp, ebp                          # 004daf12
    pop ebp                                      # 004daf14
    ret 0x4                                      # 004daf15
