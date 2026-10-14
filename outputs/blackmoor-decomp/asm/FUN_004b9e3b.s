# FUN_004b9e3b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b9e3b
# extent:       0x004b9e3b-0x004ba07f (580 code bytes)
# span:         0x004b9e3b-0x004ba07f (code 580, tables 0, padding 0)
# sha256:       ca265743a503c513dadf5142a69a99f2e0d896ccad2974c5bb40f6f06e819673
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# name:         Obj52e200::reset_fields
# arguments:    thiscall: ecx=this; no stack arguments; plain ret (caller pops nothing); no return value (eax is left as the last value written by the fill sequence and is not a result); preserves edi (pushed/popped), clobbers eax, ecx, edx
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot, mov overwrites it with ecx); edi is saved with push edi and restored before the epilogue
# fields:       this+0x04 word = 0xffff; this+0x06 word = 0xffff; this+0x08/0x0c/0x10/0x14/0x18 dwords = 0; this+0x34/0x38/0x3c/0x44/0x40/0x48 dwords = 0; this+0x4c/0x50 dwords = 0 (via a 2-dword block at this+0x4c); this+0x58..0x67 (4 dwords) = 0; this+0x184/0x188/0x18c/0x190/0x194 dwords = 0; this+0x1b0/0x1b4 dwords = 0; this+0x1bc..0x1cb, 0x1cc..0x1db, 0x1dc..0x1eb (three 4-dword blocks) = 0; this+0x1f4..0x20b (6 dwords) = 0; this+0x20c..0x2c3 (0x2e dwords) = 0, then this+0x2bc dword = 0xffffffff (the later store overwrites one dword of the fill); this+0x2c4/0x2cc/0x2d8/0x2dc/0x2e0/0x2e4/0x2e8/0x2ec/0x2f0/0x2f8/0x2fc/0x300/0x304/0x308 dwords = 0; this+0x3e0..0x40f (12 dwords) = 0 and this+0x410 byte = 0; this+0x00 (vtable slot) is not touched; no globals touched
# callees:      none
# track-n:      host-adapter: none
# unverified:   The object type is not named in the bytes: 0x52e200 is the vtable that the constructor FUN_004b9e00 stores at this+0 (read from the unverified pseudocode of 0x4b9e00, not re-derived here), so Obj52e200 is only my label. FUN_004b9e00 (constructor) and FUN_004ba07f (releases this+8/0xc/0x10/0x14 with FUN_004c2dfb, runs FUN_004be18b over the list at this+0x4c/0x50, frees the render-struct slots named by the words at this+4 and this+0x2bc with FUN_004d3992, then calls this routine) call it; those roles come from their Ghidra pseudocode only, not from a byte-level review, so the meaning given to this+4/+0x2bc (render-struct index, -1 = none), this+8..0x14 (owned pointers) and this+0x4c/0x50 (list head and tail, node next link at node+0x150) is inferred from those callers. All other cleared offsets are only known to be zeroed here, their meaning is not established. The 0xffff written to this+6 is only known as a word set to -1. Whether the 0x20c fill range deliberately covers this+0x2bc before it is set to -1 is not known; it is an effect-order fact of the bytes.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]: this, spilled from ecx

# --- fields of this (ecx), in ascending offset order -----------------
.equ zrender_idx_4, 0x4  # this+0x4: word index (0xffff = none); FUN_004ba07f passes it to FUN_004d3992 when != -1
.equ aux_idx_6, 0x6  # this+0x6: word set to 0xffff; use not established
.equ owned_ptr_8, 0x8  # this+0x8: dword zeroed; FUN_004ba07f releases it with FUN_004c2dfb(this+8)
.equ owned_ptr_c, 0xc  # this+0xc: dword zeroed; released like owned_ptr_8
.equ owned_ptr_10, 0x10  # this+0x10: dword zeroed; released like owned_ptr_8
.equ owned_ptr_14, 0x14  # this+0x14: dword zeroed; released like owned_ptr_8
.equ clr_dword_18, 0x18  # this+0x18: dword zeroed; meaning not established
.equ clr_dword_34, 0x34  # this+0x34: dword zeroed; meaning not established
.equ clr_dword_38, 0x38  # this+0x38: dword zeroed; meaning not established
.equ clr_dword_3c, 0x3c  # this+0x3c: dword zeroed; meaning not established
.equ clr_dword_40, 0x40  # this+0x40: dword zeroed; meaning not established
.equ clr_dword_44, 0x44  # this+0x44: dword zeroed; meaning not established
.equ clr_dword_48, 0x48  # this+0x48: dword zeroed; meaning not established
.equ clr_dword_184, 0x184  # this+0x184: dword zeroed; meaning not established
.equ clr_dword_188, 0x188  # this+0x188: dword zeroed; meaning not established
.equ clr_dword_18c, 0x18c  # this+0x18c: dword zeroed; meaning not established
.equ clr_dword_190, 0x190  # this+0x190: dword zeroed; meaning not established
.equ clr_dword_194, 0x194  # this+0x194: dword zeroed; meaning not established
.equ clr_dword_1b0, 0x1b0  # this+0x1b0: dword zeroed; meaning not established
.equ clr_dword_1b4, 0x1b4  # this+0x1b4: dword zeroed; meaning not established
.equ zrender_idx_2bc, 0x2bc  # this+0x2bc: dword set to 0xffffffff last (after the 0x20c fill); FUN_004ba07f passes its low word to FUN_004d3992 when != -1
.equ clr_dword_2c4, 0x2c4  # this+0x2c4: dword zeroed; meaning not established
.equ clr_dword_2cc, 0x2cc  # this+0x2cc: dword zeroed; meaning not established
.equ clr_dword_2d8, 0x2d8  # this+0x2d8: dword zeroed; meaning not established
.equ clr_dword_2dc, 0x2dc  # this+0x2dc: dword zeroed; meaning not established
.equ clr_dword_2e0, 0x2e0  # this+0x2e0: dword zeroed; meaning not established
.equ clr_dword_2e4, 0x2e4  # this+0x2e4: dword zeroed; meaning not established
.equ clr_dword_2e8, 0x2e8  # this+0x2e8: dword zeroed; meaning not established
.equ clr_dword_2ec, 0x2ec  # this+0x2ec: dword zeroed; meaning not established
.equ clr_dword_2f0, 0x2f0  # this+0x2f0: dword zeroed; meaning not established
.equ clr_dword_2f8, 0x2f8  # this+0x2f8: dword zeroed; meaning not established
.equ clr_dword_2fc, 0x2fc  # this+0x2fc: dword zeroed; meaning not established
.equ clr_dword_300, 0x300  # this+0x300: dword zeroed; meaning not established
.equ clr_dword_304, 0x304  # this+0x304: dword zeroed; meaning not established
.equ clr_dword_308, 0x308  # this+0x308: dword zeroed; meaning not established

# --- elements of the 4-dword clear blocks (base register = this+0x1bc, +0x1cc, +0x58, +0x1dc; also the 2-dword block at this+0x4c) ---
.equ blk_dword1, 0x4  # block+0x4: second dword of a block cleared through a base pointer (value copied from a zeroed register)
.equ blk_dword2, 0x8  # block+0x8: third dword of a cleared block
.equ blk_dword3, 0xc  # block+0xc: fourth dword of a cleared block

# --- external targets -----------------------------------------------

.org 0x004b9e3b - 0x401000
.globl FUN_004b9e3b
FUN_004b9e3b:
    # block 0x004b9e3b: the whole routine is one straight-line basic block (no branches). It spills this, then in this order: sets the words this+4 and this+6 to 0xffff (6 first); zeroes the individual dwords listed in the header (+0x18, +0x34/38/3c, +0x44, +0x40, +0x48, +0x184/188, +0x1b0/1b4, +0x2cc, +0x18c/190/194, +0x2dc..0x2f0, +0x2d8, +0x2f8..0x308, +0x8/0xc/0x10/0x14, +0x2c4); clears four 4-dword blocks at this+0x1bc, 0x1cc, 0x58, 0x1dc by loading the block address into a register and storing a zeroed register to [reg], [reg+4], [reg+8], [reg+0xc]; fills 12 dwords at this+0x3e0 with rep stosd plus one stosb (byte at +0x410); fills 6 dwords at this+0x1f4; clears the two dwords at this+0x4c and +0x50; fills 0x2e dwords at this+0x20c (covers +0x2bc); stores 0xffffffff to this+0x2bc; restores edi and returns
    push ebp                                     # 004b9e3b
    {load} mov ebp, esp                          # 004b9e3c
    push ecx                                     # 004b9e3e
    push edi                                     # 004b9e3f
    mov dword ptr [ebp - local_this], ecx           # 004b9e40
    mov eax, dword ptr [ebp - local_this]           # 004b9e43
    mov word ptr [eax + aux_idx_6], 0xffff         # 004b9e46
    mov ecx, dword ptr [ebp - local_this]           # 004b9e4c
    mov word ptr [ecx + zrender_idx_4], 0xffff         # 004b9e4f
    mov edx, dword ptr [ebp - local_this]           # 004b9e55
    mov dword ptr [edx + clr_dword_18], 0x0          # 004b9e58
    mov eax, dword ptr [ebp - local_this]           # 004b9e5f
    mov dword ptr [eax + clr_dword_34], 0x0          # 004b9e62
    mov ecx, dword ptr [ebp - local_this]           # 004b9e69
    mov dword ptr [ecx + clr_dword_38], 0x0          # 004b9e6c
    mov edx, dword ptr [ebp - local_this]           # 004b9e73
    mov dword ptr [edx + clr_dword_3c], 0x0          # 004b9e76
    mov eax, dword ptr [ebp - local_this]           # 004b9e7d
    mov dword ptr [eax + clr_dword_44], 0x0          # 004b9e80
    mov ecx, dword ptr [ebp - local_this]           # 004b9e87
    mov dword ptr [ecx + clr_dword_40], 0x0          # 004b9e8a
    mov edx, dword ptr [ebp - local_this]           # 004b9e91
    mov dword ptr [edx + clr_dword_48], 0x0          # 004b9e94
    mov eax, dword ptr [ebp - local_this]           # 004b9e9b
    mov dword ptr [eax + clr_dword_184], 0x0         # 004b9e9e
    mov ecx, dword ptr [ebp - local_this]           # 004b9ea8
    mov dword ptr [ecx + clr_dword_188], 0x0         # 004b9eab
    mov edx, dword ptr [ebp - local_this]           # 004b9eb5
    mov dword ptr [edx + clr_dword_1b0], 0x0         # 004b9eb8
    mov eax, dword ptr [ebp - local_this]           # 004b9ec2
    mov dword ptr [eax + clr_dword_1b4], 0x0         # 004b9ec5
    mov ecx, dword ptr [ebp - local_this]           # 004b9ecf
    mov dword ptr [ecx + clr_dword_2cc], 0x0         # 004b9ed2
    mov edx, dword ptr [ebp - local_this]           # 004b9edc
    mov dword ptr [edx + clr_dword_18c], 0x0         # 004b9edf
    mov eax, dword ptr [ebp - local_this]           # 004b9ee9
    mov dword ptr [eax + clr_dword_190], 0x0         # 004b9eec
    mov ecx, dword ptr [ebp - local_this]           # 004b9ef6
    mov dword ptr [ecx + clr_dword_194], 0x0         # 004b9ef9
    mov edx, dword ptr [ebp - local_this]           # 004b9f03
    mov dword ptr [edx + clr_dword_2dc], 0x0         # 004b9f06
    mov eax, dword ptr [ebp - local_this]           # 004b9f10
    mov dword ptr [eax + clr_dword_2e0], 0x0         # 004b9f13
    mov ecx, dword ptr [ebp - local_this]           # 004b9f1d
    mov dword ptr [ecx + clr_dword_2e4], 0x0         # 004b9f20
    mov edx, dword ptr [ebp - local_this]           # 004b9f2a
    mov dword ptr [edx + clr_dword_2e8], 0x0         # 004b9f2d
    mov eax, dword ptr [ebp - local_this]           # 004b9f37
    mov dword ptr [eax + clr_dword_2ec], 0x0         # 004b9f3a
    mov ecx, dword ptr [ebp - local_this]           # 004b9f44
    mov dword ptr [ecx + clr_dword_2f0], 0x0         # 004b9f47
    mov edx, dword ptr [ebp - local_this]           # 004b9f51
    mov dword ptr [edx + clr_dword_2d8], 0x0         # 004b9f54
    mov eax, dword ptr [ebp - local_this]           # 004b9f5e
    mov dword ptr [eax + clr_dword_2f8], 0x0         # 004b9f61
    mov ecx, dword ptr [ebp - local_this]           # 004b9f6b
    mov dword ptr [ecx + clr_dword_2fc], 0x0         # 004b9f6e
    mov edx, dword ptr [ebp - local_this]           # 004b9f78
    mov dword ptr [edx + clr_dword_300], 0x0         # 004b9f7b
    mov eax, dword ptr [ebp - local_this]           # 004b9f85
    mov dword ptr [eax + clr_dword_304], 0x0         # 004b9f88
    mov ecx, dword ptr [ebp - local_this]           # 004b9f92
    mov dword ptr [ecx + clr_dword_308], 0x0         # 004b9f95
    mov edx, dword ptr [ebp - local_this]           # 004b9f9f
    mov dword ptr [edx + owned_ptr_8], 0x0           # 004b9fa2
    mov eax, dword ptr [ebp - local_this]           # 004b9fa9
    mov dword ptr [eax + owned_ptr_c], 0x0           # 004b9fac
    mov ecx, dword ptr [ebp - local_this]           # 004b9fb3
    mov dword ptr [ecx + owned_ptr_10], 0x0          # 004b9fb6
    mov edx, dword ptr [ebp - local_this]           # 004b9fbd
    mov dword ptr [edx + owned_ptr_14], 0x0          # 004b9fc0
    mov eax, dword ptr [ebp - local_this]           # 004b9fc7
    mov dword ptr [eax + clr_dword_2c4], 0x0         # 004b9fca
    {load} xor ecx, ecx                          # 004b9fd4
    mov edx, dword ptr [ebp - local_this]           # 004b9fd6
    add edx, 0x1bc                               # 004b9fd9
    mov dword ptr [edx], ecx                     # 004b9fdf
    mov dword ptr [edx + blk_dword1], ecx           # 004b9fe1
    mov dword ptr [edx + blk_dword2], ecx           # 004b9fe4
    mov dword ptr [edx + blk_dword3], ecx           # 004b9fe7
    {load} xor eax, eax                          # 004b9fea
    mov ecx, dword ptr [ebp - local_this]           # 004b9fec
    add ecx, 0x1cc                               # 004b9fef
    mov dword ptr [ecx], eax                     # 004b9ff5
    mov dword ptr [ecx + blk_dword1], eax           # 004b9ff7
    mov dword ptr [ecx + blk_dword2], eax           # 004b9ffa
    mov dword ptr [ecx + blk_dword3], eax           # 004b9ffd
    {load} xor edx, edx                          # 004ba000
    mov eax, dword ptr [ebp - local_this]           # 004ba002
    add eax, 0x58                                # 004ba005
    mov dword ptr [eax], edx                     # 004ba008
    mov dword ptr [eax + blk_dword1], edx           # 004ba00a
    mov dword ptr [eax + blk_dword2], edx           # 004ba00d
    mov dword ptr [eax + blk_dword3], edx           # 004ba010
    {load} xor ecx, ecx                          # 004ba013
    mov edx, dword ptr [ebp - local_this]           # 004ba015
    add edx, 0x1dc                               # 004ba018
    mov dword ptr [edx], ecx                     # 004ba01e
    mov dword ptr [edx + blk_dword1], ecx           # 004ba020
    mov dword ptr [edx + blk_dword2], ecx           # 004ba023
    mov dword ptr [edx + blk_dword3], ecx           # 004ba026
    mov ecx, 0xc                                 # 004ba029
    {load} xor eax, eax                          # 004ba02e
    mov edi, dword ptr [ebp - local_this]           # 004ba030
    add edi, 0x3e0                               # 004ba033
    rep stosd dword ptr es:[edi], eax            # 004ba039
    stosb byte ptr es:[edi], al                  # 004ba03b
    mov ecx, 0x6                                 # 004ba03c
    {load} xor eax, eax                          # 004ba041
    mov edi, dword ptr [ebp - local_this]           # 004ba043
    add edi, 0x1f4                               # 004ba046
    rep stosd dword ptr es:[edi], eax            # 004ba04c
    {load} xor eax, eax                          # 004ba04e
    mov ecx, dword ptr [ebp - local_this]           # 004ba050
    add ecx, 0x4c                                # 004ba053
    mov dword ptr [ecx], eax                     # 004ba056
    mov dword ptr [ecx + blk_dword1], eax           # 004ba058
    mov ecx, 0x2e                                # 004ba05b
    {load} xor eax, eax                          # 004ba060
    mov edi, dword ptr [ebp - local_this]           # 004ba062
    add edi, 0x20c                               # 004ba065
    rep stosd dword ptr es:[edi], eax            # 004ba06b
    mov edx, dword ptr [ebp - local_this]           # 004ba06d
    mov dword ptr [edx + zrender_idx_2bc], 0xffffffff  # 004ba070
    pop edi                                      # 004ba07a
    {load} mov esp, ebp                          # 004ba07b
    pop ebp                                      # 004ba07d
    ret                                          # 004ba07e
