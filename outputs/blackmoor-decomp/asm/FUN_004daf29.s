# FUN_004daf29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daf29
# extent:       0x004daf29-0x004daf3f (22 code bytes)
# span:         0x004daf29-0x004daf3f (code 22, tables 0, padding 0)
# sha256:       e7c806708bab2ad8df826d25bf5a7db32c74e0439276e644978409f12ada7d4d
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# name:         Receiver::set_dword_10
# arguments:    thiscall: ecx=this; [ebp+8]=value (32-bit, stored unmodified); callee pops 4 (ret 4); no meaningful return value (eax is left holding this as scratch)
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot, mov overwrites it with ecx)
# fields:       this+0x10: dword written with arg_value; nothing else stored, no globals touched
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/matching_s08_2.cpp:FUN_004daf29_receiver::set
# unverified:   Which object the receiver is: the bytes only show an unnamed this-pointer in ecx; the matching offsets in src/input_latch.c (it names only FIELD_0C, FIELD_10, MOVE_X and MOVE_Y) and the object at 0x5830a6 named in tasks/S08-4 suggest the input object, but no caller was traced for this function here. Field meaning is not asserted: only a 32-bit load/store at the stated offset is verified. Whether the stored dword is signed/unsigned is not determinable (plain mov). Spill of ecx to local_this is only a frame artefact (push ecx reserves the slot, mov overwrites it with ecx). The routine leaves a scratch value in eax (this) on return; whether callers treat the method as void is not verified here. Field symbol names are descriptive labels chosen from src/input_latch.c and src/input_consume.c offsets (and the neighbouring routines); they assert only the verified displacement, not the field's game meaning.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]
.equ arg_value, 0x8  # [ebp + 0x8]

.equ recv_state_10, 0x10  # Receiver+0x10: dword (matches INPUT_LATCH_FIELD_10; object not traced)

# --- external targets -----------------------------------------------

.org 0x004daf29 - 0x401000
.globl FUN_004daf29
FUN_004daf29:
    # block 0x004daf29: entry block, no branches: spill this, eax = this, ecx = arg_value, dword [this+0x10] = ecx, restore the frame and return popping 4 bytes
    push ebp                                     # 004daf29
    {load} mov ebp, esp                          # 004daf2a
    push ecx                                     # 004daf2c
    mov dword ptr [ebp - local_this], ecx           # 004daf2d
    mov eax, dword ptr [ebp - local_this]           # 004daf30
    mov ecx, dword ptr [ebp + arg_value]             # 004daf33
    mov dword ptr [eax + recv_state_10], ecx              # 004daf36
    {load} mov esp, ebp                          # 004daf39
    pop ebp                                      # 004daf3b
    ret 0x4                                      # 004daf3c
