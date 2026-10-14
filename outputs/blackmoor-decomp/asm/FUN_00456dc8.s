# FUN_00456dc8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456dc8
# extent:       0x00456dc8-0x00456fa6 (478 code bytes)
# span:         0x00456dc8-0x00456fb6 (code 478, tables 16, padding 0)
# sha256:       9a8c80e14a5bc4b8e2187043d488f972648bfd21372b5cb7925212e33e3b372c
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# name:         UiRecordOwner::advance_event_flag_cycle
# arguments:    thiscall: ecx=this (saved at [ebp-local_this]), no stack arguments, plain ret, no defined return value
# locals:       frame 0xc bytes: [ebp-4]=record pointer (the dword at 0x5bb5e5 + word(this+0x1e)*0x8d), [ebp-8]=this (spilled from ecx), [ebp-0xc]=switch index (the signed word counter 0x5957c3 after the update, compared unsigned against 3 and used to index SWTAB_00456fa6)
# fields:       this+0x1e: signed word record index (times 0x8d into the pointer table at 0x5bb5e5), record+0x240, +0x242, +0x244, +0x246: four signed words, each an index into the event flag table, record+0x248, +0x24a, +0x24c, +0x24e: four signed words, each an index into the event flag table, globals 0x005bb5e5 (table of dword record pointers, stride 0x8d), 0x00585801 (event flag table, dwords indexed by flag id per boot-world-inputs-recovery.md, read at the id in record+0x246 and written at all eight ids), 0x005957c3 (signed word cycle counter, read, incremented or reset and written)
# callees:      none (the indirect jump through SWTAB_00456fa6 stays inside this function)
# track-n:      host-adapter: none
# unverified:   The name and the field names are role labels, not original symbols. What the eight event flag ids in the record mean (the four at +0x240..+0x246 are cleared on every call, the four at +0x248..+0x24e form a one-hot cycle) and which game object owns the record are not established, so no claim is made that this is a highlight, animation or input handler. Observed behaviour only: if flag[id(+0x246)] is zero the first cycle flag is set, the other three cleared and the counter reset to 0, otherwise all four cycle flags are cleared, the counter becomes counter+1 when it was below 4 and 0 otherwise, and the flag for counter 0, 1, 2 or 3 is set (counter 4 sets none), then the four trigger flags are cleared on both paths. The original never checks that the record index or any of the eight flag ids is inside their tables (a negative or large id writes outside the event flag array), so the native port must reject bad ids explicitly. The counter 0x5957c3 is shared by every record, not per record. No Track N source corresponds.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_record, 0x4  # [ebp - 0x4]: record pointer loaded from the 0x5bb5e5 table
.equ local_this, 0x8  # [ebp - 0x8]: this, spilled from ecx
.equ local_counter, 0xc  # [ebp - 0xc]: cycle counter after the update, the switch index
.equ this_record_index, 0x1e  # this+0x1e: signed word index into the 0x5bb5e5 record table
.equ rec_clear_id_0, 0x240  # record+0x240: signed word event flag id, cleared at the end of every call
.equ rec_clear_id_1, 0x242  # record+0x242: signed word event flag id, cleared at the end of every call
.equ rec_clear_id_2, 0x244  # record+0x244: signed word event flag id, cleared at the end of every call
.equ rec_trigger_id, 0x246  # record+0x246: signed word event flag id, tested at the start (zero selects the reset path) and cleared at the end
.equ rec_cycle_id_0, 0x248  # record+0x248: signed word event flag id, cycle position 0
.equ rec_cycle_id_1, 0x24a  # record+0x24a: signed word event flag id, cycle position 1
.equ rec_cycle_id_2, 0x24c  # record+0x24c: signed word event flag id, cycle position 2
.equ rec_cycle_id_3, 0x24e  # record+0x24e: signed word event flag id, cycle position 3

# --- external targets -----------------------------------------------

.org 0x00456dc8 - 0x401000
.globl FUN_00456dc8
FUN_00456dc8:
    # block 0x00456dc8: entry: save this, record = pointer at 0x5bb5e5 + word(this+0x1e)*0x8d, read event flag [0x585801 + 4*word(record+0x246)] and if it is non-zero jump to L_trigger_set_path (jne)
    push ebp                                     # 00456dc8
    {load} mov ebp, esp                          # 00456dc9
    sub esp, 0xc                                 # 00456dcb
    mov dword ptr [ebp - local_this], ecx           # 00456dce
    mov eax, dword ptr [ebp - local_this]           # 00456dd1
    movsx ecx, word ptr [eax + this_record_index]         # 00456dd4
    imul ecx, ecx, 0x8d                          # 00456dd8
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00456dde
    mov dword ptr [ebp - local_record], edx           # 00456de4
    mov eax, dword ptr [ebp - local_record]           # 00456de7
    movsx ecx, word ptr [eax + rec_trigger_id]        # 00456dea
    cmp dword ptr [4*ecx + 0x585801], 0x0        # 00456df1
    jne.d8 L_trigger_set_path                            # 00456df9
    # block 0x00456dfb: trigger flag is zero (reset path): event flag at record+0x248 = 1, flags at record+0x24a, +0x24c, +0x24e = 0, counter word 0x5957c3 = 0, jump to L_clear_trigger_flags
    mov edx, dword ptr [ebp - local_record]           # 00456dfb
    movsx eax, word ptr [edx + rec_cycle_id_0]        # 00456dfe
    mov dword ptr [4*eax + 0x585801], 0x1        # 00456e05
    mov ecx, dword ptr [ebp - local_record]           # 00456e10
    movsx edx, word ptr [ecx + rec_cycle_id_1]        # 00456e13
    mov dword ptr [4*edx + 0x585801], 0x0        # 00456e1a
    mov eax, dword ptr [ebp - local_record]           # 00456e25
    movsx ecx, word ptr [eax + rec_cycle_id_2]        # 00456e28
    mov dword ptr [4*ecx + 0x585801], 0x0        # 00456e2f
    mov edx, dword ptr [ebp - local_record]           # 00456e3a
    movsx eax, word ptr [edx + rec_cycle_id_3]        # 00456e3d
    mov dword ptr [4*eax + 0x585801], 0x0        # 00456e44
    mov word ptr [0x5957c3], 0x0                 # 00456e4f
    jmp.d32 L_clear_trigger_flags                           # 00456e58
L_trigger_set_path:
    # block 0x00456e5d: trigger flag is set: clear the four event flags at record+0x248, +0x24a, +0x24c, +0x24e, then compare the signed word counter 0x5957c3 with 4, if it is 4 or more jump to L_wrap_counter (jge)
    mov ecx, dword ptr [ebp - local_record]           # 00456e5d
    movsx edx, word ptr [ecx + rec_cycle_id_0]        # 00456e60
    mov dword ptr [4*edx + 0x585801], 0x0        # 00456e67
    mov eax, dword ptr [ebp - local_record]           # 00456e72
    movsx ecx, word ptr [eax + rec_cycle_id_1]        # 00456e75
    mov dword ptr [4*ecx + 0x585801], 0x0        # 00456e7c
    mov edx, dword ptr [ebp - local_record]           # 00456e87
    movsx eax, word ptr [edx + rec_cycle_id_2]        # 00456e8a
    mov dword ptr [4*eax + 0x585801], 0x0        # 00456e91
    mov ecx, dword ptr [ebp - local_record]           # 00456e9c
    movsx edx, word ptr [ecx + rec_cycle_id_3]        # 00456e9f
    mov dword ptr [4*edx + 0x585801], 0x0        # 00456ea6
    movsx eax, word ptr [0x5957c3]               # 00456eb1
    cmp eax, 0x4                                 # 00456eb8
    jge.d8 L_wrap_counter                            # 00456ebb
    # block 0x00456ebd: counter below 4: counter = counter + 1, jump to L_dispatch_counter
    mov cx, word ptr [0x5957c3]                  # 00456ebd
    add cx, 0x1                                  # 00456ec4
    mov word ptr [0x5957c3], cx                  # 00456ec8
    jmp.d8 L_dispatch_counter                            # 00456ecf
L_wrap_counter:
    # block 0x00456ed1: counter 4 or more: counter = 0
    mov word ptr [0x5957c3], 0x0                 # 00456ed1
L_dispatch_counter:
    # block 0x00456eda: switch on the counter: copy it to local_counter, if it is above 3 (unsigned ja, so counter 4 sets nothing) jump to L_clear_trigger_flags
    movsx edx, word ptr [0x5957c3]               # 00456eda
    mov dword ptr [ebp - local_counter], edx           # 00456ee1
    cmp dword ptr [ebp - local_counter], 0x3           # 00456ee4
    ja.d8 L_clear_trigger_flags                             # 00456ee8
    # block 0x00456eea: counter 0..3: indirect jump through SWTAB_00456fa6 indexed by the counter
    mov eax, dword ptr [ebp - local_counter]           # 00456eea
    jmp dword ptr [4*eax + SWTAB_00456fa6_VA]    # 00456eed
L_set_cycle_0:
    # block 0x00456ef4: counter 0: event flag at record+0x248 = 1, jump to L_clear_trigger_flags
    mov ecx, dword ptr [ebp - local_record]           # 00456ef4
    movsx edx, word ptr [ecx + rec_cycle_id_0]        # 00456ef7
    mov dword ptr [4*edx + 0x585801], 0x1        # 00456efe
    jmp.d8 L_clear_trigger_flags                            # 00456f09
L_set_cycle_1:
    # block 0x00456f0b: counter 1: event flag at record+0x24a = 1, jump to L_clear_trigger_flags
    mov eax, dword ptr [ebp - local_record]           # 00456f0b
    movsx ecx, word ptr [eax + rec_cycle_id_1]        # 00456f0e
    mov dword ptr [4*ecx + 0x585801], 0x1        # 00456f15
    jmp.d8 L_clear_trigger_flags                            # 00456f20
L_set_cycle_2:
    # block 0x00456f22: counter 2: event flag at record+0x24c = 1, jump to L_clear_trigger_flags
    mov edx, dword ptr [ebp - local_record]           # 00456f22
    movsx eax, word ptr [edx + rec_cycle_id_2]        # 00456f25
    mov dword ptr [4*eax + 0x585801], 0x1        # 00456f2c
    jmp.d8 L_clear_trigger_flags                            # 00456f37
L_set_cycle_3:
    # block 0x00456f39: counter 3: event flag at record+0x24e = 1, falls into L_clear_trigger_flags
    mov ecx, dword ptr [ebp - local_record]           # 00456f39
    movsx edx, word ptr [ecx + rec_cycle_id_3]        # 00456f3c
    mov dword ptr [4*edx + 0x585801], 0x1        # 00456f43
L_clear_trigger_flags:
    # block 0x00456f4e: common tail: clear the four event flags at record+0x240, +0x242, +0x244, +0x246, restore the frame and return
    mov eax, dword ptr [ebp - local_record]           # 00456f4e
    movsx ecx, word ptr [eax + rec_clear_id_0]        # 00456f51
    mov dword ptr [4*ecx + 0x585801], 0x0        # 00456f58
    mov edx, dword ptr [ebp - local_record]           # 00456f63
    movsx eax, word ptr [edx + rec_clear_id_1]        # 00456f66
    mov dword ptr [4*eax + 0x585801], 0x0        # 00456f6d
    mov ecx, dword ptr [ebp - local_record]           # 00456f78
    movsx edx, word ptr [ecx + rec_clear_id_2]        # 00456f7b
    mov dword ptr [4*edx + 0x585801], 0x0        # 00456f82
    mov eax, dword ptr [ebp - local_record]           # 00456f8d
    movsx ecx, word ptr [eax + rec_trigger_id]        # 00456f90
    mov dword ptr [4*ecx + 0x585801], 0x0        # 00456f97
    {load} mov esp, ebp                          # 00456fa2
    pop ebp                                      # 00456fa4
    ret                                          # 00456fa5

# --- data items (not part of the function) -------------------------
.org 0x00456fa6 - 0x401000
SWTAB_00456fa6:  # 4 case address(es)
    .long L_set_cycle_0 - .text + 0x401000
    .long L_set_cycle_1 - .text + 0x401000
    .long L_set_cycle_2 - .text + 0x401000
    .long L_set_cycle_3 - .text + 0x401000
.set SWTAB_00456fa6_VA, SWTAB_00456fa6 - .text + 0x401000
