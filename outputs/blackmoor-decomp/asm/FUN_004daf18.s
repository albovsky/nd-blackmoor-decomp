# FUN_004daf18
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daf18
# extent:       0x004daf18-0x004daf29 (17 code bytes)
# span:         0x004daf18-0x004daf29 (code 17, tables 0, padding 0)
# sha256:       d500a64daa2531474397cfd9958b6e1b88fc9b0b86d04aa2ea4015b50431bc91
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# name:         Receiver::get_dword_10
# arguments:    thiscall: ecx=this; no stack arguments; plain ret (callee pops nothing); returns the 32-bit value in eax
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot, mov overwrites it with ecx)
# fields:       this+0x10: dword read and returned in eax unchanged; no stores, no globals touched
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/matching_s08_2.cpp:FUN_004daf18_receiver::get
# unverified:   Which object the receiver is: the bytes only show an unnamed this-pointer in ecx; the matching offsets in src/input_latch.c (+0x0c state, +0x10 flag, +0x18/+0x1c move x/y) and the object at 0x5830a6 named in tasks/S08-4 suggest the input object, but no caller was traced for this function here. Field meaning is not asserted: only a 32-bit load/store at the stated offset is verified. Whether the stored dword is signed/unsigned is not determinable (plain mov). Spill of ecx to local_this is only a frame artefact (push ecx reserves the slot, mov overwrites it with ecx).
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]

# --- external targets -----------------------------------------------

.org 0x004daf18 - 0x401000
.globl FUN_004daf18
FUN_004daf18:
    # block 0x004daf18: entry block, no branches: spill this, eax = dword [this+0x10], restore the frame and return (plain ret)
    push ebp                                     # 004daf18
    {load} mov ebp, esp                          # 004daf19
    push ecx                                     # 004daf1b
    mov dword ptr [ebp - local_this], ecx           # 004daf1c
    mov eax, dword ptr [ebp - local_this]           # 004daf1f
    mov eax, dword ptr [eax + 0x10]              # 004daf22
    {load} mov esp, ebp                          # 004daf25
    pop ebp                                      # 004daf27
    ret                                          # 004daf28
