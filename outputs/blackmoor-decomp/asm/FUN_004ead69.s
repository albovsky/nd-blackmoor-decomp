# FUN_004ead69
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ead69
# extent:       0x004ead69-0x004eaf2a (449 code bytes)
# span:         0x004ead69-0x004eaf2a (code 449, tables 0, padding 0)
# sha256:       387fbcac1e51ab8506e15062e9d8317f0c4ffe1e8b8b7401ccedaec862a84d87
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# name:         CUIInventory::action_7c_set_entry_flag_and_value
# arguments:    thiscall: ecx=this (the object at 0x00571442 in the only call site 0x004294f1), one stack argument [esp+4] = action slot index (int16, read with movsx so only the low word counts), callee pops it (ret 4), no return value (eax is left as scratch)
# locals:       0x14 bytes reserved: [ebp-4] dword flag (1 if payload word +2 is non-zero else 0), [ebp-8] int16 loop index, [ebp-0xc] int16 selector copied from payload word +0, [ebp-0x10] this (spilled from ecx), [ebp-0x14] selector sign-extended to dword for the 0x64/0x65/0x66 compare chain
# fields:       slot table 0x005bb5e5 + slot*0x8d: dword pointer to the slot payload record (slot base 0x005bb5e3, payload pointer at slot+2 per s0-action-runtime-trace.md), payload+0 int16 selector, payload+2 int16 flag source, payload+4 int16 value source, this+0x77e+i*0x16d: int16 entry kind (compared with 3, read only), globals 0x00583ced[i] (dword per entry, written with the 0/1 flag) and 0x00583e05[i] (dword per entry, written with the sign-extended value), the two arrays are 0x118 = 70 dwords apart
# callees:      none
# track-n:      host-adapter: none
# unverified:   Class name is only my label: it comes from the string neighbourhood (CUIInventory::Create and AT_INVENTORY_SOUND_OVERRIDE texts sit in the surrounding routines) and from the single caller passing 0x571442, not from a vtable or RTTI. Action type 0x7c: I decoded the dispatcher byte table at 0x42aba4 (index 0x72 plus the 0xa bias) and the block at 0x4294c0 that calls this routine, but not what the game calls type 0x7c. What the two per-entry arrays mean in the game (0x00583ced flag, 0x00583e05 value) and what entry kind 3 is are not established, the neighbours 0x4eaca8 and 0x4e8e78 read the same arrays and the +0x77e kind word, which is the only basis for treating them as parallel per-entry tables. Selectors 0x64 (all 70 entries), 0x65 (kind == 3) and 0x66 (kind != 3) are read directly from the compares, the loop bound 0x46 is 70 entries as a signed compare of an int16 index. Any other selector value is used unchecked as an index into both arrays (a negative or above 69 selector overruns the arrays in the original): native code must reject it explicitly. The slot index argument is not bounds checked either. The routine re-reads the slot payload pointer on every loop iteration (no caching in a register or local), so a payload that changed mid-loop would be seen.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_flag_value, 0x4  # [ebp - 0x4]: dword 1 if payload word +2 is non-zero else 0, stored into the 0x583ced array
.equ local_entry_index, 0x8  # [ebp - 0x8]: int16 loop index over the 70 entries
.equ local_selector, 0xc  # [ebp - 0xc]: int16 selector read from payload word +0
.equ local_this, 0x10  # [ebp - 0x10]: this, spilled from ecx
.equ local_selector_dword, 0x14  # [ebp - 0x14]: selector sign-extended, compared with 0x64, 0x65 and 0x66
.equ payload_flag_word, 0x2  # slot payload record +2: int16, any non-zero value selects flag 1
.equ payload_value_word, 0x4  # slot payload record +4: int16 value copied (sign-extended) into the 0x583e05 array
.equ arg_slot_index, 0x8  # [ebp + 0x8]: int16 action slot index (0x8d-byte slots)
.equ entry_kind_word, 0x77e  # this+0x77e+i*0x16d: int16 entry kind, compared with 3

# --- external targets -----------------------------------------------

.org 0x004ead69 - 0x401000
.globl FUN_004ead69
FUN_004ead69:
    # block 0x004ead69: entry: open frame (0x14 bytes), spill this, read the slot payload pointer from 0x5bb5e5 + slot*0x8d, local_selector = payload word +0, then test payload word +2 (sign-extended) against 0 and branch to L_flag_zero when it is zero (je)
    push ebp                                     # 004ead69
    {load} mov ebp, esp                          # 004ead6a
    sub esp, 0x14                                # 004ead6c
    mov dword ptr [ebp - local_this], ecx          # 004ead6f
    movsx eax, word ptr [ebp + arg_slot_index]            # 004ead72
    imul eax, eax, 0x8d                          # 004ead76
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ead7c
    mov dx, word ptr [ecx]                       # 004ead82
    mov word ptr [ebp - local_selector], dx             # 004ead85
    movsx eax, word ptr [ebp + arg_slot_index]            # 004ead89
    imul eax, eax, 0x8d                          # 004ead8d
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ead93
    movsx edx, word ptr [ecx + payload_flag_word]          # 004ead99
    test edx, edx                                # 004ead9d
    je.d8 L_flag_zero                             # 004ead9f
    # block 0x004eada1: payload word +2 is non-zero: local_flag_value = 1, skip the zero case (jmp to L_dispatch_selector)
    mov dword ptr [ebp - local_flag_value], 0x1           # 004eada1
    jmp.d8 L_dispatch_selector                            # 004eada8
L_flag_zero:
    # block 0x004eadaa: payload word +2 is zero: local_flag_value = 0
    mov dword ptr [ebp - local_flag_value], 0x0           # 004eadaa
L_dispatch_selector:
    # block 0x004eadb1: dispatch: sign-extend local_selector into local_selector_dword and compare with 0x64, equal goes to L_all_init (je)
    movsx eax, word ptr [ebp - local_selector]          # 004eadb1
    mov dword ptr [ebp - local_selector_dword], eax          # 004eadb5
    cmp dword ptr [ebp - local_selector_dword], 0x64         # 004eadb8
    je.d8 L_all_init                             # 004eadbc
    # block 0x004eadbe: compare local_selector_dword with 0x65, equal goes to L_kind3_init (je)
    cmp dword ptr [ebp - local_selector_dword], 0x65         # 004eadbe
    je.d8 L_kind3_init                             # 004eadc2
    # block 0x004eadc4: compare local_selector_dword with 0x66, equal goes to L_other_init (je, 32-bit displacement)
    cmp dword ptr [ebp - local_selector_dword], 0x66         # 004eadc4
    je.d32 L_other_init                            # 004eadc8
    # block 0x004eadce: selector is none of 0x64, 0x65, 0x66: jump to L_single_entry
    jmp.d32 L_single_entry                           # 004eadce
L_all_init:
    # block 0x004eadd3: selector 0x64 (all entries): loop index = 0, jump to the loop test
    mov word ptr [ebp - local_entry_index], 0x0            # 004eadd3
    jmp.d8 L_all_test                            # 004eadd9
L_all_next:
    # block 0x004eaddb: selector 0x64 loop step: loop index (int16) += 1 using cx
    mov cx, word ptr [ebp - local_entry_index]             # 004eaddb
    add cx, 0x1                                  # 004eaddf
    mov word ptr [ebp - local_entry_index], cx             # 004eade3
L_all_test:
    # block 0x004eade7: selector 0x64 loop test: sign-extended loop index >= 0x46 (70) ends the loop (jge to L_all_done)
    movsx edx, word ptr [ebp - local_entry_index]          # 004eade7
    cmp edx, 0x46                                # 004eadeb
    jge.d8 L_all_done                            # 004eadee
    # block 0x004eadf0: selector 0x64 loop body: 0x583ced[index] = local_flag_value, 0x583e05[index] = sign-extended payload word +4 (payload pointer re-read from the slot table), then back to L_all_next
    movsx eax, word ptr [ebp - local_entry_index]          # 004eadf0
    mov ecx, dword ptr [ebp - local_flag_value]           # 004eadf4
    mov dword ptr [4*eax + 0x583ced], ecx        # 004eadf7
    movsx edx, word ptr [ebp + arg_slot_index]            # 004eadfe
    imul edx, edx, 0x8d                          # 004eae02
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004eae08
    movsx ecx, word ptr [eax + payload_value_word]          # 004eae0e
    movsx edx, word ptr [ebp - local_entry_index]          # 004eae12
    mov dword ptr [4*edx + 0x583e05], ecx        # 004eae16
    jmp.d8 L_all_next                            # 004eae1d
L_all_done:
    # block 0x004eae1f: selector 0x64 finished: jump to the epilogue
    jmp.d32 L_epilogue                           # 004eae1f
L_kind3_init:
    # block 0x004eae24: selector 0x65 (entries of kind 3): loop index = 0, jump to the loop test
    mov word ptr [ebp - local_entry_index], 0x0            # 004eae24
    jmp.d8 L_kind3_test                            # 004eae2a
L_kind3_next:
    # block 0x004eae2c: selector 0x65 loop step: loop index (int16) += 1 using ax and the 66 05 imm16 form of add ax, 1
    mov ax, word ptr [ebp - local_entry_index]             # 004eae2c
    .insn 0x66, 0x05, 0x0001{:u16}               # 004eae30
    mov word ptr [ebp - local_entry_index], ax             # 004eae34
L_kind3_test:
    # block 0x004eae38: selector 0x65 loop test: loop index >= 0x46 ends the loop (jge to L_kind3_done)
    movsx ecx, word ptr [ebp - local_entry_index]          # 004eae38
    cmp ecx, 0x46                                # 004eae3c
    jge.d8 L_kind3_done                            # 004eae3f
    # block 0x004eae41: selector 0x65 loop body, entry check: load int16 kind at this+0x77e+index*0x16d, skip the entry unless it equals 3 (jne to L_kind3_continue)
    movsx edx, word ptr [ebp - local_entry_index]          # 004eae41
    imul edx, edx, 0x16d                         # 004eae45
    mov eax, dword ptr [ebp - local_this]          # 004eae4b
    movsx ecx, word ptr [eax + edx + entry_kind_word]  # 004eae4e
    cmp ecx, 0x3                                 # 004eae56
    jne.d8 L_kind3_continue                            # 004eae59
    # block 0x004eae5b: selector 0x65 matching entry (kind == 3): 0x583ced[index] = local_flag_value, 0x583e05[index] = sign-extended payload word +4
    movsx edx, word ptr [ebp - local_entry_index]          # 004eae5b
    mov eax, dword ptr [ebp - local_flag_value]           # 004eae5f
    mov dword ptr [4*edx + 0x583ced], eax        # 004eae62
    movsx ecx, word ptr [ebp + arg_slot_index]            # 004eae69
    imul ecx, ecx, 0x8d                          # 004eae6d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004eae73
    movsx eax, word ptr [edx + payload_value_word]          # 004eae79
    movsx ecx, word ptr [ebp - local_entry_index]          # 004eae7d
    mov dword ptr [4*ecx + 0x583e05], eax        # 004eae81
L_kind3_continue:
    # block 0x004eae88: selector 0x65 loop continue: back to the step block
    jmp.d8 L_kind3_next                            # 004eae88
L_kind3_done:
    # block 0x004eae8a: selector 0x65 finished: jump to the epilogue
    jmp.d32 L_epilogue                           # 004eae8a
L_other_init:
    # block 0x004eae8f: selector 0x66 (entries of kind other than 3): loop index = 0, jump to the loop test
    mov word ptr [ebp - local_entry_index], 0x0            # 004eae8f
    jmp.d8 L_other_test                            # 004eae95
L_other_next:
    # block 0x004eae97: selector 0x66 loop step: loop index (int16) += 1 using dx
    mov dx, word ptr [ebp - local_entry_index]             # 004eae97
    add dx, 0x1                                  # 004eae9b
    mov word ptr [ebp - local_entry_index], dx             # 004eae9f
L_other_test:
    # block 0x004eaea3: selector 0x66 loop test: loop index >= 0x46 ends the loop (jge to L_other_done)
    movsx eax, word ptr [ebp - local_entry_index]          # 004eaea3
    cmp eax, 0x46                                # 004eaea7
    jge.d8 L_other_done                            # 004eaeaa
    # block 0x004eaeac: selector 0x66 loop body, entry check: load int16 kind at this+0x77e+index*0x16d, skip the entry when it equals 3 (je to L_other_continue)
    movsx ecx, word ptr [ebp - local_entry_index]          # 004eaeac
    imul ecx, ecx, 0x16d                         # 004eaeb0
    mov edx, dword ptr [ebp - local_this]          # 004eaeb6
    movsx eax, word ptr [edx + ecx + entry_kind_word]  # 004eaeb9
    cmp eax, 0x3                                 # 004eaec1
    je.d8 L_other_continue                             # 004eaec4
    # block 0x004eaec6: selector 0x66 matching entry (kind != 3): 0x583ced[index] = local_flag_value, 0x583e05[index] = sign-extended payload word +4
    movsx ecx, word ptr [ebp - local_entry_index]          # 004eaec6
    mov edx, dword ptr [ebp - local_flag_value]           # 004eaeca
    mov dword ptr [4*ecx + 0x583ced], edx        # 004eaecd
    movsx eax, word ptr [ebp + arg_slot_index]            # 004eaed4
    imul eax, eax, 0x8d                          # 004eaed8
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004eaede
    movsx edx, word ptr [ecx + payload_value_word]          # 004eaee4
    movsx eax, word ptr [ebp - local_entry_index]          # 004eaee8
    mov dword ptr [4*eax + 0x583e05], edx        # 004eaeec
L_other_continue:
    # block 0x004eaef3: selector 0x66 loop continue: back to the step block
    jmp.d8 L_other_next                            # 004eaef3
L_other_done:
    # block 0x004eaef5: selector 0x66 finished: jump to the epilogue
    jmp.d8 L_epilogue                            # 004eaef5
L_single_entry:
    # block 0x004eaef7: any other selector: use the sign-extended selector itself as the index (no bounds check): 0x583ced[selector] = local_flag_value, 0x583e05[selector] = sign-extended payload word +4
    movsx ecx, word ptr [ebp - local_selector]          # 004eaef7
    mov edx, dword ptr [ebp - local_flag_value]           # 004eaefb
    mov dword ptr [4*ecx + 0x583ced], edx        # 004eaefe
    movsx eax, word ptr [ebp + arg_slot_index]            # 004eaf05
    imul eax, eax, 0x8d                          # 004eaf09
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004eaf0f
    movsx edx, word ptr [ecx + payload_value_word]          # 004eaf15
    movsx eax, word ptr [ebp - local_selector]          # 004eaf19
    mov dword ptr [4*eax + 0x583e05], edx        # 004eaf1d
L_epilogue:
    # block 0x004eaf24: epilogue: restore the frame and return, popping the one stack argument (ret 4)
    {load} mov esp, ebp                          # 004eaf24
    pop ebp                                      # 004eaf26
    ret 0x4                                      # 004eaf27
