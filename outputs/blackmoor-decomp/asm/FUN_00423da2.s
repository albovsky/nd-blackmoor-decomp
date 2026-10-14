# FUN_00423da2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423da2
# extent:       0x00423da2-0x00423f57 (437 code bytes)
# span:         0x00423da2-0x00423f57 (code 437, tables 0, padding 0)
# sha256:       10997b2179aee62e2f79f3530559b786410d092428fb6f394a856d77af1d2160
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# name:         CDependency::reset_branch_recursive
# arguments:    thiscall: ecx=this (CDependency context with the evaluation stack; saved at [ebp-0x10]); [ebp+8]=branch object to reset, may be null (returns at once); rewritten in place with the popped parent after a nested branch; callee pops 4 (ret 4); no return value
# locals:       frame 0x10 bytes: [ebp-4]=stack entry pointer returned by the pop helper; [ebp-8]=current sibling node; [ebp-0xc]=done flag (0 keep looping, 1 leave); [ebp-0x10]=saved ecx (this)
# fields:       branch+0x4 (first child node); branch+0x0 of a child branch (cleared); node+0x0 (kind, 2=leaf, 1=branch); node+0x4 (state, cleared); node+0x2c (leaf field, cleared to 0); node+0xc (node id, debug text only); node+0x38 (next sibling); node+0x44 (child branch object); child branch +0x8 (id, debug text only); pop-entry+0x0 and +0x8; globals 0x0063a4cd (int16 debug flag), 0x0063888b (message buffer), 0x005cf659, texts 0x005448bc, 0x005448e8, 0x00544924 (error text "CDependency::ResetBranch() - ERROR - Tried to pop empty stack!", read from the owned GAME.EXE)
# callees:      FUN_0042356d = push (branch,node) on this evaluation stack (thiscall, 2 args, callee pops 8); FUN_004235fd = pop entry, null when empty (thiscall, no args); FUN_0050ca3e = sprintf-style formatter (cdecl); FUN_0044a2b7 = debug log line writer (cdecl); FUN_0052139c = error report taking (text,0,0), no caller cleanup after the call; FUN_004c97b4 = shutdown/quit helper called with ecx=0x5cf659; self = recursion on a child branch
# track-n:      outputs/blackmoor-decomp/src/scene_conditions.c:scene_conditions_reset
# unverified:   Track N scene_conditions_reset clears every node status in a flat loop, so the explicit stack, recursion, debug text and error path have no counterpart; the cleared node+0x2c leaf field and its meaning are unidentified (Track N has no such field); a node whose kind is neither 1 nor 2 spins forever with no state change (verified in the control flow, unsafe original behaviour); the empty-stack error path was not exercised; roles of 0x52139c, 0x4c97b4 and 0x44a2b7 come from pseudocode only; stack cleanup after 0x52139c is absent so its calling convention is not established here
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_popped, 0x4  # [ebp - 0x4]
.equ local_cur, 0x8  # [ebp - 0x8]
.equ local_done, 0xc  # [ebp - 0xc]
.equ local_saved_this, 0x10  # [ebp - 0x10]
.equ arg_branch, 0x8  # [ebp + 0x8]

.equ field_4, 0x4  # offset
.equ field_8, 0x8  # offset
.equ field_c, 0xc  # offset
.equ field_2c, 0x2c  # offset
.equ field_38, 0x38  # offset
.equ field_44, 0x44  # offset

# --- external targets -----------------------------------------------
.set FUN_0042356d, .text + (0x0042356d - 0x401000)
.set FUN_004235fd, .text + (0x004235fd - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00423da2 - 0x401000
.globl FUN_00423da2
FUN_00423da2:
L_reset_branch_entry:
    # block 0x00423da2: prologue; save ecx (this); if arg_branch is non-null go on
    push ebp                                     # 00423da2
    {load} mov ebp, esp                          # 00423da3
    sub esp, 0x10                                # 00423da5
    mov dword ptr [ebp - local_saved_this], ecx          # 00423da8
    cmp dword ptr [ebp + arg_branch], 0x0             # 00423dab
    jne.d8 L_have_branch                            # 00423daf
    # block 0x00423db1: arg_branch is null: jump to the epilogue
    jmp.d32 L_epilogue                           # 00423db1
L_have_branch:
    # block 0x00423db6: cur = arg_branch.first_child (+4); if non-null go on
    mov eax, dword ptr [ebp + arg_branch]             # 00423db6
    mov ecx, dword ptr [eax + field_4]               # 00423db9
    mov dword ptr [ebp - local_cur], ecx           # 00423dbc
    cmp dword ptr [ebp - local_cur], 0x0           # 00423dbf
    jne.d8 L_have_first_child                            # 00423dc3
    # block 0x00423dc5: no children: jump to the epilogue
    jmp.d32 L_epilogue                           # 00423dc5
L_have_first_child:
    # block 0x00423dca: done = 0
    mov dword ptr [ebp - local_done], 0x0           # 00423dca
L_loop_head:
    # block 0x00423dd1: loop head: if done != 0 leave the loop
    cmp dword ptr [ebp - local_done], 0x0           # 00423dd1
    jne.d32 L_loop_done                           # 00423dd5
    # block 0x00423ddb: if cur.kind (+0) != 2 (not a leaf) go to the branch-kind test
    mov edx, dword ptr [ebp - local_cur]           # 00423ddb
    cmp dword ptr [edx], 0x2                     # 00423dde
    jne.d8 L_check_branch_kind                            # 00423de1
    # block 0x00423de3: leaf: cur.state (+4) = 0; cur+0x2c = 0; if the debug flag word 0x63a4cd is zero skip the log
    mov eax, dword ptr [ebp - local_cur]           # 00423de3
    mov dword ptr [eax + field_4], 0x0               # 00423de6
    mov ecx, dword ptr [ebp - local_cur]           # 00423ded
    mov dword ptr [ecx + field_2c], 0x0              # 00423df0
    movsx edx, word ptr [0x63a4cd]               # 00423df7
    test edx, edx                                # 00423dfe
    je.d8 L_leaf_advance                             # 00423e00
    # block 0x00423e02: debug on: sprintf(0x63888b, 0x5448bc, cur.id (+0xc)) then log it, caller cleans up both calls
    mov eax, dword ptr [ebp - local_cur]           # 00423e02
    mov ecx, dword ptr [eax + field_c]               # 00423e05
    push ecx                                     # 00423e08
    push 0x5448bc                                # 00423e09
    push 0x63888b                                # 00423e0e
    call FUN_0050ca3e                            # 00423e13
    add esp, 0xc                                 # 00423e18
    push 0x63888b                                # 00423e1b
    call FUN_0044a2b7                            # 00423e20
    add esp, 0x4                                 # 00423e25
L_leaf_advance:
    # block 0x00423e28: cur = cur.next (+0x38); if non-null keep looping
    mov edx, dword ptr [ebp - local_cur]           # 00423e28
    mov eax, dword ptr [edx + field_38]              # 00423e2b
    mov dword ptr [ebp - local_cur], eax           # 00423e2e
    cmp dword ptr [ebp - local_cur], 0x0           # 00423e31
    jne.d8 L_resume_after_leaf                            # 00423e35
    # block 0x00423e37: last sibling: done = 1
    mov dword ptr [ebp - local_done], 0x1           # 00423e37
L_resume_after_leaf:
    # block 0x00423e3e: back to the loop head
    jmp.d32 L_resume_loop                           # 00423e3e
L_check_branch_kind:
    # block 0x00423e43: if cur.kind (+0) != 1 (neither leaf nor branch) jump straight back to the loop head, no progress made
    mov ecx, dword ptr [ebp - local_cur]           # 00423e43
    cmp dword ptr [ecx], 0x1                     # 00423e46
    jne.d32 L_resume_loop                           # 00423e49
    # block 0x00423e4f: branch node: cur.state (+4) = 0; cur.child_branch (+0x44).result (+0) = 0; if the debug flag word is zero skip the log
    mov edx, dword ptr [ebp - local_cur]           # 00423e4f
    mov dword ptr [edx + field_4], 0x0               # 00423e52
    mov eax, dword ptr [ebp - local_cur]           # 00423e59
    mov ecx, dword ptr [eax + field_44]              # 00423e5c
    mov dword ptr [ecx], 0x0                     # 00423e5f
    movsx edx, word ptr [0x63a4cd]               # 00423e65
    test edx, edx                                # 00423e6c
    je.d8 L_branch_recurse                             # 00423e6e
    # block 0x00423e70: debug on: sprintf(0x63888b, 0x5448e8, cur.id (+0xc), child_branch.id (+8)) then log it, caller cleans up both calls
    mov eax, dword ptr [ebp - local_cur]           # 00423e70
    mov ecx, dword ptr [eax + field_44]              # 00423e73
    mov edx, dword ptr [ecx + field_8]               # 00423e76
    push edx                                     # 00423e79
    mov eax, dword ptr [ebp - local_cur]           # 00423e7a
    mov ecx, dword ptr [eax + field_c]               # 00423e7d
    push ecx                                     # 00423e80
    push 0x5448e8                                # 00423e81
    push 0x63888b                                # 00423e86
    call FUN_0050ca3e                            # 00423e8b
    add esp, 0x10                                # 00423e90
    push 0x63888b                                # 00423e93
    call FUN_0044a2b7                            # 00423e98
    add esp, 0x4                                 # 00423e9d
L_branch_recurse:
    # block 0x00423ea0: push (arg_branch, cur) with 0x42356d; recurse on cur.child_branch (+0x44); pop with 0x4235fd; null pop goes to the error path
    mov edx, dword ptr [ebp - local_cur]           # 00423ea0
    push edx                                     # 00423ea3
    mov eax, dword ptr [ebp + arg_branch]             # 00423ea4
    push eax                                     # 00423ea7
    mov ecx, dword ptr [ebp - local_saved_this]          # 00423ea8
    call FUN_0042356d                            # 00423eab
    mov ecx, dword ptr [ebp - local_cur]           # 00423eb0
    mov edx, dword ptr [ecx + field_44]              # 00423eb3
    push edx                                     # 00423eb6
    mov ecx, dword ptr [ebp - local_saved_this]          # 00423eb7
    call L_reset_branch_entry                              # 00423eba
    mov ecx, dword ptr [ebp - local_saved_this]          # 00423ebf
    call FUN_004235fd                            # 00423ec2
    mov dword ptr [ebp - local_popped], eax           # 00423ec7
    cmp dword ptr [ebp - local_popped], 0x0           # 00423eca
    je.d8 L_pop_failed                             # 00423ece
    # block 0x00423ed0: pop ok: cur = entry.node (+8); arg_branch = entry.branch (+0); cur = cur.next (+0x38); if non-null go to the keep-looping case
    mov eax, dword ptr [ebp - local_popped]           # 00423ed0
    mov ecx, dword ptr [eax + field_8]               # 00423ed3
    mov dword ptr [ebp - local_cur], ecx           # 00423ed6
    mov edx, dword ptr [ebp - local_popped]           # 00423ed9
    mov eax, dword ptr [edx]                     # 00423edc
    mov dword ptr [ebp + arg_branch], eax             # 00423ede
    mov ecx, dword ptr [ebp - local_cur]           # 00423ee1
    mov edx, dword ptr [ecx + field_38]              # 00423ee4
    mov dword ptr [ebp - local_cur], edx           # 00423ee7
    cmp dword ptr [ebp - local_cur], 0x0           # 00423eea
    jne.d8 L_branch_has_next                            # 00423eee
    # block 0x00423ef0: no next sibling: done = 1, resume loop
    mov dword ptr [ebp - local_done], 0x1           # 00423ef0
    jmp.d8 L_resume_after_pop                            # 00423ef7
L_branch_has_next:
    # block 0x00423ef9: next sibling exists: done = 0
    mov dword ptr [ebp - local_done], 0x0           # 00423ef9
L_resume_after_pop:
    # block 0x00423f00: back to the loop head
    jmp.d8 L_resume_loop                            # 00423f00
L_pop_failed:
    # block 0x00423f02: pop returned null (empty stack): format the 0x544924 error text into 0x63888b, go to the error report
    push 0x544924                                # 00423f02
    push 0x63888b                                # 00423f07
    call FUN_0050ca3e                            # 00423f0c
    add esp, 0x8                                 # 00423f11
    jmp.d8 L_goto_error_report                            # 00423f14
L_resume_loop:
    # block 0x00423f16: back to the loop head
    jmp.d32 L_loop_head                           # 00423f16
L_loop_done:
    # block 0x00423f1b: loop finished: jump to the epilogue
    jmp.d8 L_epilogue                            # 00423f1b
L_error_report:
    # block 0x00423f1d: error report: call 0x52139c(0x63888b, 0, 0); if the debug flag word 0x63a4cd is nonzero log the text
    push 0x0                                     # 00423f1d
    push 0x0                                     # 00423f1f
    push 0x63888b                                # 00423f21
    call FUN_0052139c                            # 00423f26
    movsx eax, word ptr [0x63a4cd]               # 00423f2b
    test eax, eax                                # 00423f32
    je.d8 L_shutdown_call                             # 00423f34
    # block 0x00423f36: debug flag set: call 0x44a2b7(0x63888b), caller removes its 4-byte argument
    push 0x63888b                                # 00423f36
    call FUN_0044a2b7                            # 00423f3b
    add esp, 0x4                                 # 00423f40
L_shutdown_call:
    # block 0x00423f43: call 0x4c97b4 with ecx=0x5cf659 (shutdown helper), then to the epilogue
    mov ecx, 0x5cf659                            # 00423f43
    call FUN_004c97b4                            # 00423f48
    jmp.d8 L_epilogue                            # 00423f4d
L_goto_error_report:
    # block 0x00423f4f: goto the error report
    jmp.d8 L_error_report                            # 00423f4f
L_epilogue:
    # block 0x00423f51: epilogue: restore frame, return popping 4
    {load} mov esp, ebp                          # 00423f51
    pop ebp                                      # 00423f53
    ret 0x4                                      # 00423f54
