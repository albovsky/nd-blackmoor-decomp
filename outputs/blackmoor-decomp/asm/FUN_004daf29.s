# FUN_004daf29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daf29
# extent:       0x004daf29-0x004daf3f (22 code bytes)
# span:         0x004daf29-0x004daf3f (code 22, tables 0, padding 0)
# sha256:       e7c806708bab2ad8df826d25bf5a7db32c74e0439276e644978409f12ada7d4d
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

.org 0x004daf29 - 0x401000
.globl FUN_004daf29
FUN_004daf29:
    # block 0x004daf29: <unfilled>
    push ebp                                     # 004daf29
    {load} mov ebp, esp                          # 004daf2a
    push ecx                                     # 004daf2c
    mov dword ptr [ebp - local_4], ecx           # 004daf2d
    mov eax, dword ptr [ebp - local_4]           # 004daf30
    mov ecx, dword ptr [ebp + arg_8]             # 004daf33
    mov dword ptr [eax + 0x10], ecx              # 004daf36
    {load} mov esp, ebp                          # 004daf39
    pop ebp                                      # 004daf3b
    ret 0x4                                      # 004daf3c
