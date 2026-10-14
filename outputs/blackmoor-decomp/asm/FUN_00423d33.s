# FUN_00423d33
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423d33
# extent:       0x00423d33-0x00423da2 (111 code bytes)
# span:         0x00423d33-0x00423da2 (code 111, tables 0, padding 0)
# sha256:       b9d41f8f47db076f8a2c7eb1d5cc5e9bb66c8f1ba46e523063ad29f8f201f29e
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# name:         CDependency::reset_all
# arguments:    thiscall: ecx=this (CDependency context, saved at [ebp-4]); [ebp+8]=trunk branch object to reset; callee pops 4 (ret 4); no return value
# locals:       [ebp-4]=saved ecx (this), reserved with push ecx; no other locals
# fields:       trunk branch +0x0 (int32 result word, written 1 or 0); +0x8 (branch id, only formatted into the debug text); +0x34 (read, zero or nonzero selects the path; the loader at 0x424aa8 stores the source record count here per its pseudocode); globals 0x0063a4cd (int16 debug flag), 0x0063888b (message buffer), 0x0054488c (format text)
# callees:      FUN_004234c8 = clear the evaluation-stack depth (this+4 = 0) (thiscall, no args); FUN_00423da2 = reset branch and leaf states recursively (thiscall, 1 arg); FUN_0050ca3e = sprintf-style formatter (cdecl); FUN_0044a2b7 = debug log line writer (cdecl)
# track-n:      outputs/blackmoor-decomp/src/scene_conditions.c:scene_conditions_reset
# unverified:   meaning of branch+0x34 as the dependency record count comes from the loader pseudocode, not from this function (Track N maps the zero case to record_count == 0, which is its reading, not proven by these bytes alone); when branch+0x34 is zero the original sets the root result to 1 and does not call 0x423da2, leaving node states untouched, whereas Track N clears all nodes and then sets the root; Track N clears every node status in one pass while the original clears per-kind fields through 0x423da2 and does not touch the +0x2c leaf field here; the debug text is not modelled by Track N; roles of 0x44a2b7 and 0x4234c8 come from pseudocode
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_saved_this, 0x4  # [ebp - 0x4]
.equ arg_trunk_branch, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_004234c8, .text + (0x004234c8 - 0x401000)
.set FUN_00423da2, .text + (0x00423da2 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x00423d33 - 0x401000
.globl FUN_00423d33
FUN_00423d33:
    # block 0x00423d33: prologue; save ecx (this); if trunk.+0x34 (record count) is nonzero go to the has-records case
    push ebp                                     # 00423d33
    {load} mov ebp, esp                          # 00423d34
    push ecx                                     # 00423d36
    mov dword ptr [ebp - local_saved_this], ecx           # 00423d37
    mov eax, dword ptr [ebp + arg_trunk_branch]             # 00423d3a
    cmp dword ptr [eax + 0x34], 0x0              # 00423d3d
    jne.d8 L_has_records                            # 00423d41
    # block 0x00423d43: +0x34 is zero (no dependency records): trunk.result (+0) = 1, jump to the epilogue
    mov ecx, dword ptr [ebp + arg_trunk_branch]             # 00423d43
    mov dword ptr [ecx], 0x1                     # 00423d46
    jmp.d8 L_epilogue                            # 00423d4c
L_has_records:
    # block 0x00423d4e: records present: trunk.result (+0) = 0; if the debug flag word 0x63a4cd is zero skip the log
    mov edx, dword ptr [ebp + arg_trunk_branch]             # 00423d4e
    mov dword ptr [edx], 0x0                     # 00423d51
    movsx eax, word ptr [0x63a4cd]               # 00423d57
    test eax, eax                                # 00423d5e
    je.d8 L_reset_tree                             # 00423d60
    # block 0x00423d62: debug on: sprintf(0x63888b, 0x54488c, trunk.id (+8)) then log it with 0x44a2b7, caller cleans up both calls
    mov ecx, dword ptr [ebp + arg_trunk_branch]             # 00423d62
    mov edx, dword ptr [ecx + 0x8]               # 00423d65
    push edx                                     # 00423d68
    push 0x54488c                                # 00423d69
    push 0x63888b                                # 00423d6e
    call FUN_0050ca3e                            # 00423d73
    add esp, 0xc                                 # 00423d78
    push 0x63888b                                # 00423d7b
    call FUN_0044a2b7                            # 00423d80
    add esp, 0x4                                 # 00423d85
L_reset_tree:
    # block 0x00423d88: call 0x4234c8(this) to clear the evaluation stack depth, then call 0x423da2(this, trunk) to reset the tree
    mov ecx, dword ptr [ebp - local_saved_this]           # 00423d88
    call FUN_004234c8                            # 00423d8b
    mov eax, dword ptr [ebp + arg_trunk_branch]             # 00423d90
    push eax                                     # 00423d93
    mov ecx, dword ptr [ebp - local_saved_this]           # 00423d94
    call FUN_00423da2                            # 00423d97
L_epilogue:
    # block 0x00423d9c: epilogue: restore frame, return popping 4
    {load} mov esp, ebp                          # 00423d9c
    pop ebp                                      # 00423d9e
    ret 0x4                                      # 00423d9f
