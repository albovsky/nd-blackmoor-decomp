# FUN_004dae77
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dae77
# extent:       0x004dae77-0x004dae88 (17 code bytes)
# span:         0x004dae77-0x004dae88 (code 17, tables 0, padding 0)
# sha256:       55b6e58404a3e0e3a48be30a93afd471c029dbaec0b52893db79c4f37241b821
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# name:         Receiver::get_dword_1c
# arguments:    thiscall: ecx=this; no stack arguments; plain ret (callee pops nothing); returns the 32-bit value in eax
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot, mov overwrites it with ecx)
# fields:       this+0x1c: dword read and returned in eax unchanged; no stores, no globals touched
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/matching_s08_2.cpp:FUN_004dae77_receiver::get
# unverified:   Which object the receiver is: the bytes only show an unnamed this-pointer in ecx; the matching offsets in src/input_latch.c (it names only FIELD_0C, FIELD_10, MOVE_X and MOVE_Y) and the object at 0x5830a6 named in tasks/S08-4 suggest the input object, but no caller was traced for this function here. Field meaning is not asserted: only a 32-bit load/store at the stated offset is verified. Whether the stored dword is signed/unsigned is not determinable (plain mov). Spill of ecx to local_this is only a frame artefact (push ecx reserves the slot, mov overwrites it with ecx).
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]

# --- external targets -----------------------------------------------

.org 0x004dae77 - 0x401000
.globl FUN_004dae77
FUN_004dae77:
    # block 0x004dae77: entry block, no branches: spill this, eax = dword [this+0x1c], restore the frame and return (plain ret)
    push ebp                                     # 004dae77
    {load} mov ebp, esp                          # 004dae78
    push ecx                                     # 004dae7a
    mov dword ptr [ebp - local_this], ecx           # 004dae7b
    mov eax, dword ptr [ebp - local_this]           # 004dae7e
    mov eax, dword ptr [eax + 0x1c]              # 004dae81
    {load} mov esp, ebp                          # 004dae84
    pop ebp                                      # 004dae86
    ret                                          # 004dae87
