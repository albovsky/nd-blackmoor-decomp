# FUN_004daf9f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daf9f
# extent:       0x004daf9f-0x004dafc3 (36 code bytes)
# span:         0x004daf9f-0x004dafc3 (code 36, tables 0, padding 0)
# sha256:       f443aaff08be83a4918c28dca4648dc31659f730c9d6b22fa596627a776d29d0
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# name:         InputObject::store_move_point
# arguments:    thiscall: ecx=this; [ebp+8]=first stack dword, never read by this routine; [ebp+0xc]=pointer to two consecutive dwords (x at +0, y at +4); callee pops 8 (ret 8); no meaningful return value (eax is left as scratch)
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot, mov overwrites it with ecx)
# fields:       this+0x18: dword written with *(arg_point_ptr+0); this+0x1c: dword written with *(arg_point_ptr+4), after the first store (instruction order: read x, store, reload this and the pointer, read y, store); the point memory is only read; no globals touched
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/input_latch.c:input_latch_move
# unverified:   The receiver's identity (the input object at 0x5830a6 per tasks/S08-3 and S08-4) comes from those packets and the MFC wrappers' ECX setup, not from a caller trace redone here; semantic names of the fields are Track N's labels (input_latch.c / input_consume.c), not proven by these bytes. The ignored first stack dword ([ebp+8]) and what it carries in the callers (MFC wrappers 0x43ec4a/0x43ec85/0x43ed71 per tasks/S08-3) is not verified; the point is assumed readable by callers (no validation in the original). y is read after the x store: if arg_point_ptr+4 aliases this+0x18, y observes the newly stored x; the unchanged instruction order preserves this.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]
.equ arg_point_ptr, 0xc  # [ebp + 0xc]

.equ field_4, 0x4  # offset
.equ field_18, 0x18  # offset
.equ field_1c, 0x1c  # offset

# --- external targets -----------------------------------------------

.org 0x004daf9f - 0x401000
.globl FUN_004daf9f
FUN_004daf9f:
    # block 0x004daf9f: entry, no branches: spill this; copy dword *(arg_point_ptr) to [this+0x18], then dword *(arg_point_ptr+4) to [this+0x1c]; restore the frame and return popping 8 bytes
    push ebp                                     # 004daf9f
    {load} mov ebp, esp                          # 004dafa0
    push ecx                                     # 004dafa2
    mov dword ptr [ebp - local_this], ecx           # 004dafa3
    mov eax, dword ptr [ebp - local_this]           # 004dafa6
    mov ecx, dword ptr [ebp + arg_point_ptr]             # 004dafa9
    mov edx, dword ptr [ecx]                     # 004dafac
    mov dword ptr [eax + field_18], edx              # 004dafae
    mov eax, dword ptr [ebp - local_this]           # 004dafb1
    mov ecx, dword ptr [ebp + arg_point_ptr]             # 004dafb4
    mov edx, dword ptr [ecx + field_4]               # 004dafb7
    mov dword ptr [eax + field_1c], edx              # 004dafba
    {load} mov esp, ebp                          # 004dafbd
    pop ebp                                      # 004dafbf
    ret 0x8                                      # 004dafc0
