# FUN_00424201
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00424201
# extent:       0x00424201-0x00424346 (325 code bytes)
# span:         0x00424201-0x00424346 (code 325, tables 0, padding 0)
# sha256:       b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# name:         CDependency::evaluate_branch_recursive
# arguments:    thiscall: ecx=this (CDependency context holding the 12-byte-entry evaluation stack; saved at [ebp-0x10]); [ebp+8]=branch object whose children are evaluated (rewritten in place with the popped parent after a nested branch); callee pops 4 (ret 4); no return value
# locals:       frame 0x10 bytes: [ebp-4]=stack entry pointer returned by the pop helper; [ebp-8]=current sibling node; [ebp-0xc]=done flag (0 keep looping, 1 leave); [ebp-0x10]=saved ecx (this)
# fields:       branch+0x4 (first child node); node+0x0 (kind, 2=leaf, 1=branch); node+0x4 (state); node+0x8 (saved copy of node+4 written before evaluation); node+0x38 (next sibling); node+0x44 (child branch object of a branch node); pop-entry+0x0 (saved parent branch) and pop-entry+0x8 (saved node); globals 0x0063888b (message buffer), 0x0063a4cd (int16 debug flag), 0x00544964 (error text "CDependency::EvaluateBranch() - ERROR - Tried to pop empty stack!", read from the owned GAME.EXE), 0x005cf659 (object passed in ecx to the shutdown call)
# callees:      FUN_00424346 = leaf evaluator (thiscall, 1 arg: leaf node); FUN_0042406d = branch reducer (thiscall, 1 arg: branch); FUN_0042356d = push (branch,node) on this evaluation stack (thiscall, 2 args, callee pops 8); FUN_004235fd = pop evaluation stack entry, null when empty (thiscall, no args); FUN_0050ca3e = sprintf-style formatter (cdecl, caller cleans); FUN_0052139c = error report taking (text,0,0), no caller cleanup after the call; FUN_0044a2b7 = debug log line writer (cdecl); FUN_004c97b4 = shutdown/quit helper called with ecx=0x5cf659; self = recursion on a child branch
# track-n:      outputs/blackmoor-decomp/src/scene_conditions.c:scene_condition_evaluate_branch
# unverified:   Track N recurses with a C call stack and an explicit depth limit; the original uses an explicit 0x80-entry stack plus real recursion, so the push/pop error path (pop returns null) is original-only and has no Track N counterpart; a node whose kind is neither 1 nor 2 makes the loop spin forever with no state change (verified in the control flow, unsafe original behaviour, Track N never builds such nodes); first child null dereferences null (callers guard the empty tree); what reads node+8 (the saved pre-evaluation state) is not found here and Track N does not model it; roles of 0x52139c (error report), 0x4c97b4 (quit) and 0x44a2b7 (log) come from pseudocode only; stack cleanup after 0x52139c is absent so its calling convention is not established here
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_popped, 0x4  # [ebp - 0x4]
.equ local_cur, 0x8  # [ebp - 0x8]
.equ local_done, 0xc  # [ebp - 0xc]
.equ local_saved_this, 0x10  # [ebp - 0x10]
.equ arg_branch, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_0042356d, .text + (0x0042356d - 0x401000)
.set FUN_004235fd, .text + (0x004235fd - 0x401000)
.set FUN_0042406d, .text + (0x0042406d - 0x401000)
.set FUN_00424346, .text + (0x00424346 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00424201 - 0x401000
.globl FUN_00424201
FUN_00424201:
L_evaluate_branch_entry:
    # block 0x00424201: prologue; save ecx (this), cur = arg_branch.first_child (+4), done = 0
    push ebp                                     # 00424201
    {load} mov ebp, esp                          # 00424202
    sub esp, 0x10                                # 00424204
    mov dword ptr [ebp - local_saved_this], ecx          # 00424207
    mov eax, dword ptr [ebp + arg_branch]             # 0042420a
    mov ecx, dword ptr [eax + 0x4]               # 0042420d
    mov dword ptr [ebp - local_cur], ecx           # 00424210
    mov dword ptr [ebp - local_done], 0x0           # 00424213
L_loop_head:
    # block 0x0042421a: loop head: if done != 0 leave the loop
    cmp dword ptr [ebp - local_done], 0x0           # 0042421a
    jne.d32 L_loop_done                           # 0042421e
    # block 0x00424224: if cur.kind (+0) != 2 (not a leaf) go to the branch-kind test
    mov edx, dword ptr [ebp - local_cur]           # 00424224
    cmp dword ptr [edx], 0x2                     # 00424227
    jne.d8 L_check_branch_kind                            # 0042422a
    # block 0x0042422c: leaf: cur.saved_state (+8) = cur.state (+4); call leaf evaluator 0x424346(this, cur); cur = cur.next (+0x38); if non-null go on to the next sibling
    mov eax, dword ptr [ebp - local_cur]           # 0042422c
    mov ecx, dword ptr [ebp - local_cur]           # 0042422f
    mov edx, dword ptr [ecx + 0x4]               # 00424232
    mov dword ptr [eax + 0x8], edx               # 00424235
    mov eax, dword ptr [ebp - local_cur]           # 00424238
    push eax                                     # 0042423b
    mov ecx, dword ptr [ebp - local_saved_this]          # 0042423c
    call FUN_00424346                            # 0042423f
    mov ecx, dword ptr [ebp - local_cur]           # 00424244
    mov edx, dword ptr [ecx + 0x38]              # 00424247
    mov dword ptr [ebp - local_cur], edx           # 0042424a
    cmp dword ptr [ebp - local_cur], 0x0           # 0042424d
    jne.d8 L_resume_loop_after_leaf                            # 00424251
    # block 0x00424253: cur was the last sibling: call reducer 0x42406d(this, arg_branch); done = 1
    mov eax, dword ptr [ebp + arg_branch]             # 00424253
    push eax                                     # 00424256
    mov ecx, dword ptr [ebp - local_saved_this]          # 00424257
    call FUN_0042406d                            # 0042425a
    mov dword ptr [ebp - local_done], 0x1           # 0042425f
L_resume_loop_after_leaf:
    # block 0x00424266: back to the loop head
    jmp.d32 L_resume_loop                           # 00424266
L_check_branch_kind:
    # block 0x0042426b: if cur.kind (+0) != 1 (neither leaf nor branch) jump straight back to the loop head, no progress made
    mov ecx, dword ptr [ebp - local_cur]           # 0042426b
    cmp dword ptr [ecx], 0x1                     # 0042426e
    jne.d32 L_resume_loop                           # 00424271
    # block 0x00424277: branch node: cur.saved_state (+8) = cur.state (+4); push (arg_branch, cur) with 0x42356d; recurse on cur.child_branch (+0x44); pop with 0x4235fd; null pop goes to the error path
    mov edx, dword ptr [ebp - local_cur]           # 00424277
    mov eax, dword ptr [ebp - local_cur]           # 0042427a
    mov ecx, dword ptr [eax + 0x4]               # 0042427d
    mov dword ptr [edx + 0x8], ecx               # 00424280
    mov edx, dword ptr [ebp - local_cur]           # 00424283
    push edx                                     # 00424286
    mov eax, dword ptr [ebp + arg_branch]             # 00424287
    push eax                                     # 0042428a
    mov ecx, dword ptr [ebp - local_saved_this]          # 0042428b
    call FUN_0042356d                            # 0042428e
    mov ecx, dword ptr [ebp - local_cur]           # 00424293
    mov edx, dword ptr [ecx + 0x44]              # 00424296
    push edx                                     # 00424299
    mov ecx, dword ptr [ebp - local_saved_this]          # 0042429a
    call L_evaluate_branch_entry                              # 0042429d
    mov ecx, dword ptr [ebp - local_saved_this]          # 004242a2
    call FUN_004235fd                            # 004242a5
    mov dword ptr [ebp - local_popped], eax           # 004242aa
    cmp dword ptr [ebp - local_popped], 0x0           # 004242ad
    je.d8 L_pop_failed                             # 004242b1
    # block 0x004242b3: pop ok: cur = entry.node (+8); arg_branch = entry.branch (+0); cur = cur.next (+0x38); if non-null go to the keep-looping case
    mov eax, dword ptr [ebp - local_popped]           # 004242b3
    mov ecx, dword ptr [eax + 0x8]               # 004242b6
    mov dword ptr [ebp - local_cur], ecx           # 004242b9
    mov edx, dword ptr [ebp - local_popped]           # 004242bc
    mov eax, dword ptr [edx]                     # 004242bf
    mov dword ptr [ebp + arg_branch], eax             # 004242c1
    mov ecx, dword ptr [ebp - local_cur]           # 004242c4
    mov edx, dword ptr [ecx + 0x38]              # 004242c7
    mov dword ptr [ebp - local_cur], edx           # 004242ca
    cmp dword ptr [ebp - local_cur], 0x0           # 004242cd
    jne.d8 L_branch_has_next                            # 004242d1
    # block 0x004242d3: no next sibling after the branch node: call reducer 0x42406d(this, arg_branch); done = 1
    mov eax, dword ptr [ebp + arg_branch]             # 004242d3
    push eax                                     # 004242d6
    mov ecx, dword ptr [ebp - local_saved_this]          # 004242d7
    call FUN_0042406d                            # 004242da
    mov dword ptr [ebp - local_done], 0x1           # 004242df
    jmp.d8 L_resume_loop_after_pop                            # 004242e6
L_branch_has_next:
    # block 0x004242e8: next sibling exists: done = 0
    mov dword ptr [ebp - local_done], 0x0           # 004242e8
L_resume_loop_after_pop:
    # block 0x004242ef: back to the loop head
    jmp.d8 L_resume_loop                            # 004242ef
L_pop_failed:
    # block 0x004242f1: pop returned null (empty stack): format the 0x544964 error text into 0x63888b, go to the error report
    push 0x544964                                # 004242f1
    push 0x63888b                                # 004242f6
    call FUN_0050ca3e                            # 004242fb
    add esp, 0x8                                 # 00424300
    jmp.d8 L_goto_error_report                            # 00424303
L_resume_loop:
    # block 0x00424305: back to the loop head
    jmp.d32 L_loop_head                           # 00424305
L_loop_done:
    # block 0x0042430a: loop finished: go to the epilogue
    jmp.d8 L_epilogue                            # 0042430a
L_error_report:
    # block 0x0042430c: error report: call 0x52139c(0x63888b, 0, 0); if the debug flag word 0x63a4cd is nonzero log the text
    push 0x0                                     # 0042430c
    push 0x0                                     # 0042430e
    push 0x63888b                                # 00424310
    call FUN_0052139c                            # 00424315
    movsx ecx, word ptr [0x63a4cd]               # 0042431a
    test ecx, ecx                                # 00424321
    je.d8 L_shutdown_call                             # 00424323
    # block 0x00424325: debug flag set: call 0x44a2b7(0x63888b), caller removes its 4-byte argument
    push 0x63888b                                # 00424325
    call FUN_0044a2b7                            # 0042432a
    add esp, 0x4                                 # 0042432f
L_shutdown_call:
    # block 0x00424332: call 0x4c97b4 with ecx=0x5cf659 (shutdown helper), then to the epilogue
    mov ecx, 0x5cf659                            # 00424332
    call FUN_004c97b4                            # 00424337
    jmp.d8 L_epilogue                            # 0042433c
L_goto_error_report:
    # block 0x0042433e: goto the error report
    jmp.d8 L_error_report                            # 0042433e
L_epilogue:
    # block 0x00424340: epilogue: restore frame, return popping 4
    {load} mov esp, ebp                          # 00424340
    pop ebp                                      # 00424342
    ret 0x4                                      # 00424343
