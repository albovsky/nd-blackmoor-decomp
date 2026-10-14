# FUN_004462d3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004462d3
# extent:       0x004462d3-0x00446532 (607 code bytes)
# span:         0x004462d3-0x00446532 (code 607, tables 0, padding 0)
# sha256:       d92ec6be39e659ace36761b5a6d2e5a8e3a7f48cf24fd1019921b77eff6f37e8
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# name:         TimeDisplay::init_from_descriptor
# arguments:    thiscall: ecx=this (both call sites, 0x4532c8 and 0x4b92e0, load ecx = 0x638603, a fixed global object); one stack argument arg_descriptor at [ebp+8] = pointer to a 200-byte (0x32 dwords) descriptor block, copied into this+0x174; callee pops 4 (ret 4); no result
# locals:       frame 4 bytes plus saved esi and edi: [ebp-0x4] = this, spilled from ecx; esi/edi are the copy source and destination of the rep movs and repne scasb sequences
# fields:       this+0x174..0x23b: overwritten by the 200-byte descriptor copy; inside it: ten 16-byte records at this+0x174 + i*0x10 (+0 left, +4 top, +8 right, +0xc bottom as compared by the +1 width arithmetic), a further 16-byte record at this+0x214 (+0x214 left, +0x218 top, +0x21c right, +0x220 bottom), and the dwords this+0x230, this+0x234 (registry slot index) and this+0x238; this+0x284: loop counter i (dword, i < 10); this+0x64 + 4*i: dword = right - left + 1 of record i; this+0x8c + 4*i: dword = bottom - top + 1 of record i; this+0xb4: dword = this+0x21c - this+0x214 + 1; this+0xb8: dword = this+0x220 - this+0x218 + 1; this+0x240, this+0x244: dword = 0; this+0x248, +0x252, +0x266, +0x270: byte = 0; this+0x08: dword = 0; this+0x10: dword = 1; global table of 0x4a-byte entries based at 0x005d1591, entry index = this+0x234: +0x00 dword = this+0x238, +0x04 dword = 0x4468fe (a code address in .text), +0x08 dword = this+0x230, +0x0c dword = 0, +0x10 dword = 0, +0x14 dword = 1, +0x18 dword = 1, +0x1c word = 0, +0x22 (0x005d15b3 + index*0x4a) the NUL-terminated string at 0x00548228 (text "TIME DISPLAY", 13 bytes with the NUL) copied by length found with repne scasb
# callees:      none
# track-n:      host-adapter: none
# unverified:   The name TimeDisplay::init_from_descriptor is my label: the evidence is the default string "TIME DISPLAY" at 0x548228 copied into the registry entry, and that the function 0x4468fe stored in the entry first compares the dword at 0x63860b (= 0x638603 + 8, the dword this function clears) with 0 (verified in the bytes at 0x446906) and then the one at 0x638613 (= this+0x10); the bytes do not say what the object is. The descriptor field names (left/top/right/bottom, registry slot) are role labels from the arithmetic (+1 widths), not proven. That the 0x4a-byte table at 0x5d1591 is a registry of widgets and that the stored code address 0x4468fe is a draw or update callback is not established here; the entry index this+0x234 is taken from the descriptor with no range check (an index beyond the table writes outside it: unsafe original behaviour on a bad descriptor). The effect of this+0x08 = 0 and this+0x10 = 1 beyond the flag read by 0x4468fe is not established. The 0x4468fe, 0x446548 and 0x446598 neighbours were not reconstructed here. The two callers (0x4532c8 in 0x452576, 0x4b92e0 in 0x4b8e92) were read from pseudocode and call-site bytes only.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]: this, spilled from ecx
.equ arg_descriptor, 0x8  # [ebp + 0x8]: stack argument, pointer to the 200-byte descriptor copied to this+0x174

.equ panel_active_flag, 0x8  # this+0x08: dword set to 0 (the flag 0x4468fe tests as 0x63860b when this = 0x638603)
.equ panel_ready_flag, 0x10  # this+0x10: dword set to 1
.equ rect_width_arr, 0x64  # this+0x64: array of 10 dwords, right - left + 1 of record i
.equ rect_height_arr, 0x8c  # this+0x8c: array of 10 dwords, bottom - top + 1 of record i
.equ extra_width, 0xb4  # this+0xb4: dword, extra_right - extra_left + 1
.equ extra_height, 0xb8  # this+0xb8: dword, extra_bottom - extra_top + 1
.equ rect_left, 0x174  # this+0x174 + i*0x10: record i, first dword (left, descriptor copy)
.equ rect_top, 0x178  # this+0x174 + i*0x10 + 4: record i, second dword (top)
.equ rect_right, 0x17c  # this+0x174 + i*0x10 + 8: record i, third dword (right)
.equ rect_bottom, 0x180  # this+0x174 + i*0x10 + 0xc: record i, fourth dword (bottom)
.equ extra_left, 0x214  # this+0x214: first dword of the extra record (left)
.equ extra_top, 0x218  # this+0x218: second dword of the extra record (top)
.equ extra_right, 0x21c  # this+0x21c: third dword of the extra record (right)
.equ extra_bottom, 0x220  # this+0x220: fourth dword of the extra record (bottom)
.equ desc_registry_arg, 0x230  # this+0x230: dword from the descriptor, stored to registry entry +0x08
.equ desc_registry_index, 0x234  # this+0x234: dword from the descriptor, index of the 0x4a-byte registry entry written
.equ desc_registry_value, 0x238  # this+0x238: dword from the descriptor, stored to registry entry +0x00
.equ panel_cleared_240, 0x240  # this+0x240: dword set to 0 (role not established)
.equ panel_cleared_244, 0x244  # this+0x244: dword set to 0 (role not established)
.equ panel_byte_248, 0x248  # this+0x248: byte set to 0 (role not established)
.equ panel_byte_252, 0x252  # this+0x252: byte set to 0 (role not established)
.equ panel_byte_266, 0x266  # this+0x266: byte set to 0 (role not established)
.equ panel_byte_270, 0x270  # this+0x270: byte set to 0 (role not established)
.equ panel_loop_counter, 0x284  # this+0x284: dword loop counter i of the width/height loop (ends at 10)

# --- external targets -----------------------------------------------

.org 0x004462d3 - 0x401000
.globl FUN_004462d3
FUN_004462d3:
    # block 0x004462d3: entry: spill this; copy 0x32 dwords (200 bytes) from the descriptor argument to this+0x174; loop counter = 0, jump to the loop test
    push ebp                                     # 004462d3
    {load} mov ebp, esp                          # 004462d4
    push ecx                                     # 004462d6
    push esi                                     # 004462d7
    push edi                                     # 004462d8
    mov dword ptr [ebp - local_this], ecx           # 004462d9
    mov edi, dword ptr [ebp - local_this]           # 004462dc
    add edi, 0x174                               # 004462df
    mov ecx, 0x32                                # 004462e5
    mov esi, dword ptr [ebp + arg_descriptor]             # 004462ea
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004462ed
    mov eax, dword ptr [ebp - local_this]           # 004462ef
    mov dword ptr [eax + panel_loop_counter], 0x0         # 004462f2
    jmp.d8 L_record_loop_test                            # 004462fc
L_next_record:
    # block 0x004462fe: record loop increment: counter = counter + 1
    mov ecx, dword ptr [ebp - local_this]           # 004462fe
    mov edx, dword ptr [ecx + panel_loop_counter]         # 00446301
    add edx, 0x1                                 # 00446307
    mov eax, dword ptr [ebp - local_this]           # 0044630a
    mov dword ptr [eax + panel_loop_counter], edx         # 0044630d
L_record_loop_test:
    # block 0x00446313: record loop test: if counter >= 10 (signed) leave the loop
    mov ecx, dword ptr [ebp - local_this]           # 00446313
    cmp dword ptr [ecx + panel_loop_counter], 0xa         # 00446316
    jge.d32 L_after_records                           # 0044631d
    # block 0x00446323: record i: rect_width_arr[i] = right - left + 1 and rect_height_arr[i] = bottom - top + 1 from the 16-byte record at this+0x174 + i*0x10; back to the increment
    mov edx, dword ptr [ebp - local_this]           # 00446323
    mov eax, dword ptr [edx + panel_loop_counter]         # 00446326
    shl eax, 0x4                                 # 0044632c
    mov ecx, dword ptr [ebp - local_this]           # 0044632f
    mov edx, dword ptr [ecx + panel_loop_counter]         # 00446332
    shl edx, 0x4                                 # 00446338
    mov ecx, dword ptr [ebp - local_this]           # 0044633b
    mov esi, dword ptr [ebp - local_this]           # 0044633e
    mov eax, dword ptr [ecx + eax + rect_right]   # 00446341
    sub eax, dword ptr [esi + edx + rect_left]   # 00446348
    add eax, 0x1                                 # 0044634f
    mov ecx, dword ptr [ebp - local_this]           # 00446352
    mov edx, dword ptr [ecx + panel_loop_counter]         # 00446355
    mov ecx, dword ptr [ebp - local_this]           # 0044635b
    mov dword ptr [ecx + 4*edx + rect_width_arr], eax  # 0044635e
    mov edx, dword ptr [ebp - local_this]           # 00446362
    mov eax, dword ptr [edx + panel_loop_counter]         # 00446365
    shl eax, 0x4                                 # 0044636b
    mov ecx, dword ptr [ebp - local_this]           # 0044636e
    mov edx, dword ptr [ecx + panel_loop_counter]         # 00446371
    shl edx, 0x4                                 # 00446377
    mov ecx, dword ptr [ebp - local_this]           # 0044637a
    mov esi, dword ptr [ebp - local_this]           # 0044637d
    mov eax, dword ptr [ecx + eax + rect_bottom]   # 00446380
    sub eax, dword ptr [esi + edx + rect_top]   # 00446387
    add eax, 0x1                                 # 0044638e
    mov ecx, dword ptr [ebp - local_this]           # 00446391
    mov edx, dword ptr [ecx + panel_loop_counter]         # 00446394
    mov ecx, dword ptr [ebp - local_this]           # 0044639a
    mov dword ptr [ecx + 4*edx + rect_height_arr], eax  # 0044639d
    jmp.d32 L_next_record                           # 004463a4
L_after_records:
    # block 0x004463a9: after the loop: extra_width and extra_height from the record at this+0x214; fill the 0x4a-byte registry entry at 0x5d1591 + this+0x234 * 0x4a with the descriptor values, callback address 0x4468fe, constants and the "TIME DISPLAY" text; clear this+0x240/0x244, the four bytes, this+0x08 and set this+0x10 = 1; restore registers, ret 4
    mov edx, dword ptr [ebp - local_this]           # 004463a9
    mov eax, dword ptr [ebp - local_this]           # 004463ac
    mov ecx, dword ptr [edx + extra_right]         # 004463af
    sub ecx, dword ptr [eax + extra_left]         # 004463b5
    add ecx, 0x1                                 # 004463bb
    mov edx, dword ptr [ebp - local_this]           # 004463be
    mov dword ptr [edx + extra_width], ecx          # 004463c1
    mov eax, dword ptr [ebp - local_this]           # 004463c7
    mov ecx, dword ptr [ebp - local_this]           # 004463ca
    mov edx, dword ptr [eax + extra_bottom]         # 004463cd
    sub edx, dword ptr [ecx + extra_top]         # 004463d3
    add edx, 0x1                                 # 004463d9
    mov eax, dword ptr [ebp - local_this]           # 004463dc
    mov dword ptr [eax + extra_height], edx          # 004463df
    # registry entry (base 0x5d1591 + index*0x4a): +0x00 = this+0x238, +0x04 = 0x4468fe (code address), +0x08 = this+0x230, +0x0c = 0, +0x10 = 0, +0x14 = 1, +0x18 = 1, +0x1c word = 0
    mov ecx, dword ptr [ebp - local_this]           # 004463e5
    mov edx, dword ptr [ecx + desc_registry_index]         # 004463e8
    imul edx, edx, 0x4a                          # 004463ee
    mov eax, dword ptr [ebp - local_this]           # 004463f1
    mov ecx, dword ptr [eax + desc_registry_value]         # 004463f4
    mov dword ptr [edx + 0x5d1591], ecx          # 004463fa
    mov edx, dword ptr [ebp - local_this]           # 00446400
    mov eax, dword ptr [edx + desc_registry_index]         # 00446403
    imul eax, eax, 0x4a                          # 00446409
    mov dword ptr [eax + 0x5d1595], 0x4468fe     # 0044640c
    mov ecx, dword ptr [ebp - local_this]           # 00446416
    mov edx, dword ptr [ecx + desc_registry_index]         # 00446419
    imul edx, edx, 0x4a                          # 0044641f
    mov eax, dword ptr [ebp - local_this]           # 00446422
    mov ecx, dword ptr [eax + desc_registry_arg]         # 00446425
    mov dword ptr [edx + 0x5d1599], ecx          # 0044642b
    mov edx, dword ptr [ebp - local_this]           # 00446431
    mov eax, dword ptr [edx + desc_registry_index]         # 00446434
    imul eax, eax, 0x4a                          # 0044643a
    mov dword ptr [eax + 0x5d159d], 0x0          # 0044643d
    mov ecx, dword ptr [ebp - local_this]           # 00446447
    mov edx, dword ptr [ecx + desc_registry_index]         # 0044644a
    imul edx, edx, 0x4a                          # 00446450
    mov dword ptr [edx + 0x5d15a1], 0x0          # 00446453
    mov eax, dword ptr [ebp - local_this]           # 0044645d
    mov ecx, dword ptr [eax + desc_registry_index]         # 00446460
    imul ecx, ecx, 0x4a                          # 00446466
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00446469
    mov edx, dword ptr [ebp - local_this]           # 00446473
    mov eax, dword ptr [edx + desc_registry_index]         # 00446476
    imul eax, eax, 0x4a                          # 0044647c
    mov dword ptr [eax + 0x5d15a9], 0x1          # 0044647f
    mov ecx, dword ptr [ebp - local_this]           # 00446489
    mov edx, dword ptr [ecx + desc_registry_index]         # 0044648c
    imul edx, edx, 0x4a                          # 00446492
    mov word ptr [edx + 0x5d15ad], 0x0           # 00446495
    # text copy: repne scasb finds the length (including the NUL) of the string at 0x548228, then the bytes are copied by rep movsd and rep movsb to registry entry + 0x22 (0x5d15b3 + index*0x4a)
    mov edi, 0x548228                            # 0044649e
    mov eax, dword ptr [ebp - local_this]           # 004464a3
    mov ecx, dword ptr [eax + desc_registry_index]         # 004464a6
    imul ecx, ecx, 0x4a                          # 004464ac
    add ecx, 0x5d15b3                            # 004464af
    {load} mov edx, ecx                          # 004464b5
    or ecx, -0x1                                 # 004464b7
    {load} xor eax, eax                          # 004464ba
    repne scasb al, byte ptr es:[edi]            # 004464bc
    not ecx                                      # 004464be
    {load} sub edi, ecx                          # 004464c0
    {load} mov esi, edi                          # 004464c2
    {load} mov eax, ecx                          # 004464c4
    {load} mov edi, edx                          # 004464c6
    shr ecx, 0x2                                 # 004464c8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004464cb
    {load} mov ecx, eax                          # 004464cd
    and ecx, 0x3                                 # 004464cf
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004464d2
    # clear the state fields: this+0x240 = 0, this+0x244 = 0, bytes at +0x248, +0x252, +0x266, +0x270 = 0, this+0x08 = 0, this+0x10 = 1
    mov ecx, dword ptr [ebp - local_this]           # 004464d4
    mov dword ptr [ecx + panel_cleared_240], 0x0         # 004464d7
    mov edx, dword ptr [ebp - local_this]           # 004464e1
    mov dword ptr [edx + panel_cleared_244], 0x0         # 004464e4
    mov eax, dword ptr [ebp - local_this]           # 004464ee
    mov byte ptr [eax + panel_byte_248], 0x0          # 004464f1
    mov ecx, dword ptr [ebp - local_this]           # 004464f8
    mov byte ptr [ecx + panel_byte_252], 0x0          # 004464fb
    mov edx, dword ptr [ebp - local_this]           # 00446502
    mov byte ptr [edx + panel_byte_266], 0x0          # 00446505
    mov eax, dword ptr [ebp - local_this]           # 0044650c
    mov byte ptr [eax + panel_byte_270], 0x0          # 0044650f
    mov ecx, dword ptr [ebp - local_this]           # 00446516
    mov dword ptr [ecx + panel_active_flag], 0x0           # 00446519
    mov edx, dword ptr [ebp - local_this]           # 00446520
    mov dword ptr [edx + panel_ready_flag], 0x1          # 00446523
    pop edi                                      # 0044652a
    pop esi                                      # 0044652b
    {load} mov esp, ebp                          # 0044652c
    pop ebp                                      # 0044652e
    ret 0x4                                      # 0044652f
