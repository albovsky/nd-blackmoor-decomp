# FUN_004dafc3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dafc3
# extent:       0x004dafc3-0x004db000 (61 code bytes)
# span:         0x004dafc3-0x004db000 (code 61, tables 0, padding 0)
# sha256:       fac063aec02e8b4aab491f5a203e8f07f765eb6c3a6bef5a309583cd69381498
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# name:         InputObject::latch_down
# arguments:    thiscall: ecx=this; two stack dwords at [ebp+8] and [ebp+0xc], neither read by this routine; callee pops 8 (ret 8); no meaningful return value (eax is left as scratch)
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot, mov overwrites it with ecx)
# fields:       this+0x00: dword set to 0; this+0x08: dword set to 0; this+0x0c: dword read, set to 1 only when it was exactly 0 (other values, including 1, 2 and non-canonical ones, are left untouched); this+0x10: dword set to 0; no globals touched; the last move coordinates (+0x18/+0x1c) are not touched
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/input_latch.c:input_latch_down
# unverified:   The receiver's identity (the input object at 0x5830a6 per tasks/S08-3 and S08-4) comes from those packets and the MFC wrappers' ECX setup, not from a caller trace redone here; semantic names of the fields are Track N's labels (input_latch.c / input_consume.c), not proven by these bytes. The name latch_down is the packet's 'down' role (no event source verified) (tasks/S08-3: move/down/up methods); which physical event invokes it (MFC wrappers 0x43ec4a/0x43ec85/0x43ed71) is not verified here. The contents of the two ignored stack dwords are unknown.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]

# --- external targets -----------------------------------------------

.org 0x004dafc3 - 0x401000
.globl FUN_004dafc3
FUN_004dafc3:
    # block 0x004dafc3: entry: spill this, store 0 to [this+0] and [this+8], then load dword [this+0x0c]; if it is non-zero skip to L_clear_field_10 (jne)
    push ebp                                     # 004dafc3
    {load} mov ebp, esp                          # 004dafc4
    push ecx                                     # 004dafc6
    mov dword ptr [ebp - local_this], ecx           # 004dafc7
    mov eax, dword ptr [ebp - local_this]           # 004dafca
    mov dword ptr [eax], 0x0                     # 004dafcd
    mov ecx, dword ptr [ebp - local_this]           # 004dafd3
    mov dword ptr [ecx + 0x8], 0x0               # 004dafd6
    mov edx, dword ptr [ebp - local_this]           # 004dafdd
    cmp dword ptr [edx + 0xc], 0x0               # 004dafe0
    jne.d8 L_clear_field_10                            # 004dafe4
    # block 0x004dafe6: [this+0x0c] was 0: store 1 to [this+0x0c]
    mov eax, dword ptr [ebp - local_this]           # 004dafe6
    mov dword ptr [eax + 0xc], 0x1               # 004dafe9
L_clear_field_10:
    # block 0x004daff0: common tail (also the branch target when [this+0x0c] != 0): store 0 to [this+0x10], restore the frame and return popping 8 bytes
    mov ecx, dword ptr [ebp - local_this]           # 004daff0
    mov dword ptr [ecx + 0x10], 0x0              # 004daff3
    {load} mov esp, ebp                          # 004daffa
    pop ebp                                      # 004daffc
    ret 0x8                                      # 004daffd
