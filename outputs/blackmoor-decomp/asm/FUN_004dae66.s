# FUN_004dae66
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dae66
# extent:       0x004dae66-0x004dae77 (17 code bytes)
# span:         0x004dae66-0x004dae77 (code 17, tables 0, padding 0)
# sha256:       56d9b148637ae04caedf51e503d219b7095a00c85651b319bb6b5e8bb60546cb
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

.org 0x004dae66 - 0x401000
.globl FUN_004dae66
FUN_004dae66:
    # block 0x004dae66: <unfilled>
    push ebp                                     # 004dae66
    {load} mov ebp, esp                          # 004dae67
    push ecx                                     # 004dae69
    mov dword ptr [ebp - local_4], ecx           # 004dae6a
    mov eax, dword ptr [ebp - local_4]           # 004dae6d
    mov eax, dword ptr [eax + 0x18]              # 004dae70
    {load} mov esp, ebp                          # 004dae73
    pop ebp                                      # 004dae75
    ret                                          # 004dae76
