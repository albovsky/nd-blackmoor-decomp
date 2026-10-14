# FUN_004dae77
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dae77
# extent:       0x004dae77-0x004dae88 (17 code bytes)
# span:         0x004dae77-0x004dae88 (code 17, tables 0, padding 0)
# sha256:       55b6e58404a3e0e3a48be30a93afd471c029dbaec0b52893db79c4f37241b821
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

.org 0x004dae77 - 0x401000
.globl FUN_004dae77
FUN_004dae77:
    # block 0x004dae77: <unfilled>
    push ebp                                     # 004dae77
    {load} mov ebp, esp                          # 004dae78
    push ecx                                     # 004dae7a
    mov dword ptr [ebp - local_4], ecx           # 004dae7b
    mov eax, dword ptr [ebp - local_4]           # 004dae7e
    mov eax, dword ptr [eax + 0x1c]              # 004dae81
    {load} mov esp, ebp                          # 004dae84
    pop ebp                                      # 004dae86
    ret                                          # 004dae87
