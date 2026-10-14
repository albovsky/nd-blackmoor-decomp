# FUN_004daef1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daef1
# extent:       0x004daef1-0x004daf02 (17 code bytes)
# span:         0x004daef1-0x004daf02 (code 17, tables 0, padding 0)
# sha256:       a26cd3064709e57ee483cfbbb2753f8da501718ce4ced1e834a5123dd2fcaa3d
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# name:         Receiver::get_dword_0c
# arguments:    thiscall: ecx=this; no stack arguments; plain ret (callee pops nothing); returns the 32-bit value in eax
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot, mov overwrites it with ecx)
# fields:       this+0x0c: dword read and returned in eax unchanged; no stores, no globals touched
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/matching_s08_2.cpp:FUN_004daef1_receiver::get
# unverified:   Which object the receiver is: the bytes only show an unnamed this-pointer in ecx; the matching offsets in src/input_latch.c (it names only FIELD_0C, FIELD_10, MOVE_X and MOVE_Y) and the object at 0x5830a6 named in tasks/S08-4 suggest the input object, but no caller was traced for this function here. Field meaning is not asserted: only a 32-bit load/store at the stated offset is verified. Whether the stored dword is signed/unsigned is not determinable (plain mov). Spill of ecx to local_this is only a frame artefact (push ecx reserves the slot, mov overwrites it with ecx). Field symbol names are descriptive labels chosen from src/input_latch.c and src/input_consume.c offsets (and the neighbouring routines); they assert only the verified displacement, not the field's game meaning.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]

.equ recv_state_0c, 0xc  # Receiver+0x0c: dword (matches INPUT_LATCH_FIELD_0C; object not traced)

# --- external targets -----------------------------------------------

.org 0x004daef1 - 0x401000
.globl FUN_004daef1
FUN_004daef1:
    # block 0x004daef1: entry block, no branches: spill this, eax = dword [this+0x0c], restore the frame and return (plain ret)
    push ebp                                     # 004daef1
    {load} mov ebp, esp                          # 004daef2
    push ecx                                     # 004daef4
    mov dword ptr [ebp - local_this], ecx           # 004daef5
    mov eax, dword ptr [ebp - local_this]           # 004daef8
    mov eax, dword ptr [eax + recv_state_0c]               # 004daefb
    {load} mov esp, ebp                          # 004daefe
    pop ebp                                      # 004daf00
    ret                                          # 004daf01
