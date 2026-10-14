# FUN_004db000
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db000
# extent:       0x004db000-0x004db04f (79 code bytes)
# span:         0x004db000-0x004db04f (code 79, tables 0, padding 0)
# sha256:       8aab7f111dd59d365919ae80a2dd25a8d2cf25d5bbe12a26fcaf117e2e4966e5
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# name:         InputObject::latch_up
# arguments:    thiscall: ecx=this; two stack dwords at [ebp+8] and [ebp+0xc], neither read by this routine; callee pops 8 (ret 8); no meaningful return value (eax is left as scratch)
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot, mov overwrites it with ecx)
# fields:       this+0x08: dword read, non-zero skips every other effect; this+0x00: dword read, set to 1 only when it is 0 and global 0x005c39e5 != 0xffffffff (the global is compared as a dword with -1); this+0x0c: dword read, set to 2 only when it is exactly 1; this+0x10: dword set to 0 (only on the path where [this+8] was 0); absolute global 0x005c39e5: dword read only (sentinel compared with -1); no other stores
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/input_latch.c:input_latch_up
# unverified:   The receiver's identity (the input object at 0x5830a6 per tasks/S08-3 and S08-4) comes from those packets and the MFC wrappers' ECX setup, not from a caller trace redone here; semantic names of the fields are Track N's labels (input_latch.c / input_consume.c), not proven by these bytes. The global at 0x005c39e5 and the meaning of its -1 value are unnamed (tasks/S08-3 says no approved semantic name); who writes it is not traced here. The role name latch_up is the packet's 'up' role (no event source verified), and the contents of the two ignored stack dwords are unknown.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]

# --- external targets -----------------------------------------------

.org 0x004db000 - 0x401000
.globl FUN_004db000
FUN_004db000:
    # block 0x004db000: entry: spill this, compare dword [this+8] with 0; if equal jump to L_gate_open (je)
    push ebp                                     # 004db000
    {load} mov ebp, esp                          # 004db001
    push ecx                                     # 004db003
    mov dword ptr [ebp - local_this], ecx           # 004db004
    mov eax, dword ptr [ebp - local_this]           # 004db007
    cmp dword ptr [eax + 0x8], 0x0               # 004db00a
    je.d8 L_gate_open                             # 004db00e
    # block 0x004db010: [this+8] != 0: skip all effects, jump to the epilogue
    jmp.d8 L_epilogue                            # 004db010
L_gate_open:
    # block 0x004db012: gate open ([this+8] == 0): compare dword global [0x5c39e5] with -1; if equal skip the [this+0] update to L_check_state_0c
    cmp dword ptr [0x5c39e5], -0x1               # 004db012
    je.d8 L_check_state_0c                             # 004db019
    # block 0x004db01b: global != -1: load dword [this+0]; if it is non-zero skip the store to L_check_state_0c (jne)
    mov ecx, dword ptr [ebp - local_this]           # 004db01b
    cmp dword ptr [ecx], 0x0                     # 004db01e
    jne.d8 L_check_state_0c                            # 004db021
    # block 0x004db023: [this+0] == 0 and global != -1: store 1 to [this+0]
    mov edx, dword ptr [ebp - local_this]           # 004db023
    mov dword ptr [edx], 0x1                     # 004db026
L_check_state_0c:
    # block 0x004db02c: compare dword [this+0x0c] with 1; if not equal jump to L_clear_field_10 (jne)
    mov eax, dword ptr [ebp - local_this]           # 004db02c
    cmp dword ptr [eax + 0xc], 0x1               # 004db02f
    jne.d8 L_clear_field_10                            # 004db033
    # block 0x004db035: [this+0x0c] == 1: store 2 to [this+0x0c]
    mov ecx, dword ptr [ebp - local_this]           # 004db035
    mov dword ptr [ecx + 0xc], 0x2               # 004db038
L_clear_field_10:
    # block 0x004db03f: store 0 to [this+0x10] (reached from both the [this+0x0c] test and the store above)
    mov edx, dword ptr [ebp - local_this]           # 004db03f
    mov dword ptr [edx + 0x10], 0x0              # 004db042
L_epilogue:
    # block 0x004db049: epilogue: restore the frame and return popping 8 bytes (also the target of the [this+8] != 0 skip)
    {load} mov esp, ebp                          # 004db049
    pop ebp                                      # 004db04b
    ret 0x8                                      # 004db04c
