# FUN_004dae66
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dae66
# extent:       0x004dae66-0x004dae77 (17 code bytes)
# span:         0x004dae66-0x004dae77 (code 17, tables 0, padding 0)
# sha256:       56d9b148637ae04caedf51e503d219b7095a00c85651b319bb6b5e8bb60546cb
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# name:         Receiver::get_dword_18
# arguments:    thiscall: ecx=this; no stack arguments; plain ret (callee pops nothing); returns the 32-bit value in eax
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot, mov overwrites it with ecx)
# fields:       this+0x18: dword read and returned in eax unchanged; no stores, no globals touched
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/matching_s08_2.cpp:FUN_004dae66_receiver::get
# unverified:   Which object the receiver is: the bytes only show an unnamed this-pointer in ecx; the matching offsets in src/input_latch.c (it names only FIELD_0C, FIELD_10, MOVE_X and MOVE_Y) and the object at 0x5830a6 named in tasks/S08-4 suggest the input object, but no caller was traced for this function here. Field meaning is not asserted: only a 32-bit load/store at the stated offset is verified. Whether the stored dword is signed/unsigned is not determinable (plain mov). Spill of ecx to local_this is only a frame artefact (push ecx reserves the slot, mov overwrites it with ecx). Field symbol names are descriptive labels chosen from src/input_latch.c and src/input_consume.c offsets (and the neighbouring routines); they assert only the verified displacement, not the field's game meaning.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]

.equ recv_move_x, 0x18  # Receiver+0x18: dword read (matches INPUT_LATCH_MOVE_X; object not traced)

# --- external targets -----------------------------------------------

.org 0x004dae66 - 0x401000
.globl FUN_004dae66
FUN_004dae66:
    # block 0x004dae66: entry block, no branches: spill this, eax = dword [this+0x18], restore the frame and return (plain ret)
    push ebp                                     # 004dae66
    {load} mov ebp, esp                          # 004dae67
    push ecx                                     # 004dae69
    mov dword ptr [ebp - local_this], ecx           # 004dae6a
    mov eax, dword ptr [ebp - local_this]           # 004dae6d
    mov eax, dword ptr [eax + recv_move_x]              # 004dae70
    {load} mov esp, ebp                          # 004dae73
    pop ebp                                      # 004dae75
    ret                                          # 004dae76
