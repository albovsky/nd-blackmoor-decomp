# FUN_004daf02
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daf02
# extent:       0x004daf02-0x004daf18 (22 code bytes)
# span:         0x004daf02-0x004daf18 (code 22, tables 0, padding 0)
# sha256:       440ce1a4265fcbbe20bc6bf4b0ac22ad781ce98929626468e21a5e7175448719
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# name:         Receiver::set_dword_0c
# arguments:    thiscall: ecx=this; [ebp+8]=value (32-bit, stored unmodified); callee pops 4 (ret 4); no meaningful return value (eax is left holding this as scratch)
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot, mov overwrites it with ecx)
# fields:       this+0x0c: dword written with arg_value; nothing else stored, no globals touched
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/matching_s08_2.cpp:FUN_004daf02_receiver::set
# unverified:   Which object the receiver is: the bytes only show an unnamed this-pointer in ecx; the matching offsets in src/input_latch.c (it names only FIELD_0C, FIELD_10, MOVE_X and MOVE_Y) and the object at 0x5830a6 named in tasks/S08-4 suggest the input object, but no caller was traced for this function here. Field meaning is not asserted: only a 32-bit load/store at the stated offset is verified. Whether the stored dword is signed/unsigned is not determinable (plain mov). Spill of ecx to local_this is only a frame artefact (push ecx reserves the slot, mov overwrites it with ecx). The routine leaves a scratch value in eax (this) on return; whether callers treat the method as void is not verified here.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]
.equ arg_value, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------

.org 0x004daf02 - 0x401000
.globl FUN_004daf02
FUN_004daf02:
    # block 0x004daf02: entry block, no branches: spill this, eax = this, ecx = arg_value, dword [this+0x0c] = ecx, restore the frame and return popping 4 bytes
    push ebp                                     # 004daf02
    {load} mov ebp, esp                          # 004daf03
    push ecx                                     # 004daf05
    mov dword ptr [ebp - local_this], ecx           # 004daf06
    mov eax, dword ptr [ebp - local_this]           # 004daf09
    mov ecx, dword ptr [ebp + arg_value]             # 004daf0c
    mov dword ptr [eax + 0xc], ecx               # 004daf0f
    {load} mov esp, ebp                          # 004daf12
    pop ebp                                      # 004daf14
    ret 0x4                                      # 004daf15
