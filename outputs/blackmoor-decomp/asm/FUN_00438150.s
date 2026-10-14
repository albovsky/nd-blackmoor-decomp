# FUN_00438150
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00438150
# extent:       0x00438150-0x004381e0 (144 code bytes)
# span:         0x00438150-0x004381f4 (code 144, tables 20, padding 0)
# sha256:       2a676f49a62264a9c24d55b9e8628c4927a44609b9fedb9407b9389001f21a94
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# name:         boot_state_dispatch
# arguments:    cdecl, no arguments; plain ret
# locals:       local_state (ebp-4): copy of the dispatch state word at 0x00583999
# fields:       0x00583999: boot/new-game state (0..4); 0x005c39ff: signed 16-bit flag (0 selects state 2, nonzero state 3); 0x006198f3: byte flag; 0x005839a9: set to 1 when 0x006198f3 is nonzero
# callees:      FUN_004381f4 (state 0: full world initializer); FUN_00439822 (state 1, called after the state update); FUN_004fb018 and FUN_004fc341 (state 2, called with ecx=0x005c3a67); FUN_0043a7ca (state 3); FUN_0043d227 (state 4)
# track-n:      host-adapter: none
# unverified:   the compare of the state word is unsigned (ja against 4) and the store to 0x5839a9 is a dword; Roles of the callees other than FUN_004381f4 (see boot-world-inputs-recovery.md and world-init-recovery.md) are not established here; the meaning of states 2 to 4 and of the flags at 0x005c39ff and 0x006198f3 is unverified. No Track N source implements this dispatcher.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_state, 0x4  # [ebp - 0x4]: copy of the state word

# --- external targets -----------------------------------------------
.set FUN_004381f4, .text + (0x004381f4 - 0x401000)
.set FUN_00439822, .text + (0x00439822 - 0x401000)
.set FUN_0043a7ca, .text + (0x0043a7ca - 0x401000)
.set FUN_0043d227, .text + (0x0043d227 - 0x401000)
.set FUN_004fb018, .text + (0x004fb018 - 0x401000)
.set FUN_004fc341, .text + (0x004fc341 - 0x401000)

.org 0x00438150 - 0x401000
.globl FUN_00438150
FUN_00438150:
    # entry: save the state word 0x583999 in a local; states above 4 skip to the return
    push ebp                                     # 00438150
    {load} mov ebp, esp                          # 00438151
    push ecx                                     # 00438153
    mov eax, dword ptr [0x583999]                # 00438154
    mov dword ptr [ebp - local_state], eax           # 00438159
    cmp dword ptr [ebp - local_state], 0x4           # 0043815c
    ja.d8 L_return                             # 00438160
    # state is 0..4: dispatch through the five-entry case table
    mov ecx, dword ptr [ebp - local_state]           # 00438162
    jmp dword ptr [4*ecx + SWTAB_004381e0_VA]    # 00438165
L_state0_init:
    # state 0: run the full world initializer FUN_004381f4
    call FUN_004381f4                            # 0043816c
    jmp.d8 L_return                            # 00438171
L_state1:
    # state 1: test the signed 16-bit flag at 0x5c39ff
    movsx edx, word ptr [0x5c39ff]               # 00438173
    test edx, edx                                # 0043817a
    jne.d8 L_state1_flag_set                            # 0043817c
    # flag clear: set the state word to 2
    mov dword ptr [0x583999], 0x2                # 0043817e
    jmp.d8 L_state1_after_state                            # 00438188
L_state1_flag_set:
    # flag set: set the state word to 3
    mov dword ptr [0x583999], 0x3                # 0043818a
L_state1_after_state:
    # state 1 common path: call FUN_00439822, then test the byte flag at 0x6198f3
    call FUN_00439822                            # 00438194
    {load} xor eax, eax                          # 00438199
    mov al, byte ptr [0x6198f3]                  # 0043819b
    test eax, eax                                # 004381a0
    je.d8 L_state1_done                             # 004381a2
    # byte flag nonzero: set 0x5839a9 to 1
    mov dword ptr [0x5839a9], 0x1                # 004381a4
L_state1_done:
    # state 1 finished: jump to the return
    jmp.d8 L_return                            # 004381ae
L_state2:
    # state 2: call FUN_004fb018 and FUN_004fc341 on the object at 0x5c3a67, then set the state word to 3
    mov ecx, 0x5c3a67                            # 004381b0
    call FUN_004fb018                            # 004381b5
    mov ecx, 0x5c3a67                            # 004381ba
    call FUN_004fc341                            # 004381bf
    mov dword ptr [0x583999], 0x3                # 004381c4
    jmp.d8 L_return                            # 004381ce
L_state3:
    # state 3: call FUN_0043a7ca
    call FUN_0043a7ca                            # 004381d0
    jmp.d8 L_return                            # 004381d5
L_state4:
    # state 4: call FUN_0043d227
    call FUN_0043d227                            # 004381d7
L_return:
    # common return: restore the frame and return
    {load} mov esp, ebp                          # 004381dc
    pop ebp                                      # 004381de
    ret                                          # 004381df

# --- data items (not part of the function) -------------------------
.org 0x004381e0 - 0x401000
SWTAB_004381e0:  # 5 case address(es)
    .long L_state0_init - .text + 0x401000
    .long L_state1 - .text + 0x401000
    .long L_state2 - .text + 0x401000
    .long L_state3 - .text + 0x401000
    .long L_state4 - .text + 0x401000
.set SWTAB_004381e0_VA, SWTAB_004381e0 - .text + 0x401000
