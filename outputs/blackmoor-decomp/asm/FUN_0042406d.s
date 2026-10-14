# FUN_0042406d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042406d
# extent:       0x0042406d-0x00424201 (404 code bytes)
# span:         0x0042406d-0x00424201 (code 404, tables 0, padding 0)
# sha256:       9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# name:         CDependency::reduce_branch_or_groups
# arguments:    thiscall: ecx=this (CDependency context, saved to a frame slot but never read); [ebp+8]=branch object (first-child pointer at +4, child count at +0x18, result word at +0, owning-node pointer at +0xc); callee pops 4 (ret 4); no return value
# locals:       frame 0x18 bytes: [ebp-4]=current sibling node; [ebp-8]=its previous sibling (node+0x34); [ebp-0xc]=count of siblings with nonzero state (count phase); [ebp-0x10]=its next sibling (node+0x38); [ebp-0x14]=number of state raises made in the current pass; [ebp-0x18]=saved ecx (this), unused
# fields:       branch+0x0 (int32 result, written 1 or 0); branch+0x4 (first child node); branch+0xc (owning node, may be null; its +4 state mirrors the result); branch+0x18 (child count, compared with the nonzero-child count); node+0x4 (int32 state, tested for zero and raised to 1); node+0x16 (int16 OR link, sign-extended, compared with 1); node+0x34 (previous sibling); node+0x38 (next sibling)
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/scene_dependencies.c:scene_dependencies_reduce
# unverified:   meaning of branch+0x18 as the child count and of branch+0xc as the owning node is taken from the loader pseudocode for 0x424aa8, not from instructions of this function; the null-first-child case is not guarded (dereferences null) and is not exercised; Track N scene_dependencies_reduce covers the sibling OR reduction and the final all-nonzero test but not the store to branch+0x0 or owning node +4 (those live in scene_condition_reduce_branch (static, singular)); whether this+0 context is ever used by this routine is not established (it is saved only)
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_cur, 0x4  # [ebp - 0x4]
.equ local_prev, 0x8  # [ebp - 0x8]
.equ local_nonzero_count, 0xc  # [ebp - 0xc]
.equ local_next, 0x10  # [ebp - 0x10]
.equ local_raised, 0x14  # [ebp - 0x14]
.equ local_saved_this, 0x18  # [ebp - 0x18]
.equ arg_branch, 0x8  # [ebp + 0x8]

.equ field_4, 0x4  # offset
.equ field_c, 0xc  # offset
.equ field_16, 0x16  # offset
.equ field_18, 0x18  # offset
.equ field_34, 0x34  # offset
.equ field_38, 0x38  # offset

# --- external targets -----------------------------------------------

.org 0x0042406d - 0x401000
.globl FUN_0042406d
FUN_0042406d:
    # block 0x0042406d: prologue; save ecx, cur = branch.first_child (+4), raised = 0
    push ebp                                     # 0042406d
    {load} mov ebp, esp                          # 0042406e
    sub esp, 0x18                                # 00424070
    mov dword ptr [ebp - local_saved_this], ecx          # 00424073
    mov eax, dword ptr [ebp + arg_branch]             # 00424076
    mov ecx, dword ptr [eax + field_4]               # 00424079
    mov dword ptr [ebp - local_cur], ecx           # 0042407c
    mov dword ptr [ebp - local_raised], 0x0          # 0042407f
L_visit_node:
    # block 0x00424086: per node: next = cur+0x38, prev = cur+0x34; skip the previous-link step when prev is null
    mov edx, dword ptr [ebp - local_cur]           # 00424086
    mov eax, dword ptr [edx + field_38]              # 00424089
    mov dword ptr [ebp - local_next], eax          # 0042408c
    mov ecx, dword ptr [ebp - local_cur]           # 0042408f
    mov edx, dword ptr [ecx + field_34]              # 00424092
    mov dword ptr [ebp - local_prev], edx           # 00424095
    cmp dword ptr [ebp - local_prev], 0x0           # 00424098
    je.d8 L_next_link_check                             # 0042409c
    # block 0x0042409e: prev link applies only if prev.link (prev+0x16, int16) == 1, else go to the next-link step
    mov eax, dword ptr [ebp - local_prev]           # 0042409e
    movsx ecx, word ptr [eax + field_16]             # 004240a1
    cmp ecx, 0x1                                 # 004240a5
    jne.d8 L_next_link_check                            # 004240a8
    # block 0x004240aa: if cur.state (+4) is nonzero go to the reverse test, else fall through (cur zero)
    mov edx, dword ptr [ebp - local_cur]           # 004240aa
    cmp dword ptr [edx + field_4], 0x0               # 004240ad
    jne.d8 L_prev_link_reverse_test                            # 004240b1
    # block 0x004240b3: cur zero: if prev.state is also zero jump to the reverse test (which then skips because cur is zero)
    mov eax, dword ptr [ebp - local_prev]           # 004240b3
    cmp dword ptr [eax + field_4], 0x0               # 004240b6
    je.d8 L_prev_link_reverse_test                             # 004240ba
    # block 0x004240bc: cur zero, prev nonzero: raise cur.state to 1, raised++
    mov ecx, dword ptr [ebp - local_cur]           # 004240bc
    mov dword ptr [ecx + field_4], 0x1               # 004240bf
    mov edx, dword ptr [ebp - local_raised]          # 004240c6
    add edx, 0x1                                 # 004240c9
    mov dword ptr [ebp - local_raised], edx          # 004240cc
    jmp.d8 L_next_link_check                            # 004240cf
L_prev_link_reverse_test:
    # block 0x004240d1: reverse test: if cur.state is zero go to the next-link step, else test prev
    mov eax, dword ptr [ebp - local_cur]           # 004240d1
    cmp dword ptr [eax + field_4], 0x0               # 004240d4
    je.d8 L_next_link_check                             # 004240d8
    # block 0x004240da: cur nonzero: if prev.state is also nonzero nothing to do, go to next-link step
    mov ecx, dword ptr [ebp - local_prev]           # 004240da
    cmp dword ptr [ecx + field_4], 0x0               # 004240dd
    jne.d8 L_next_link_check                            # 004240e1
    # block 0x004240e3: cur nonzero, prev zero: raise prev.state to 1, raised++
    mov edx, dword ptr [ebp - local_prev]           # 004240e3
    mov dword ptr [edx + field_4], 0x1               # 004240e6
    mov eax, dword ptr [ebp - local_raised]          # 004240ed
    add eax, 0x1                                 # 004240f0
    mov dword ptr [ebp - local_raised], eax          # 004240f3
L_next_link_check:
    # block 0x004240f6: if next is null go to end of pass, else test the next link
    cmp dword ptr [ebp - local_next], 0x0          # 004240f6
    je.d8 L_end_of_pass                             # 004240fa
    # block 0x004240fc: next link applies only if cur.link (+0x16, int16) == 1, else advance
    mov ecx, dword ptr [ebp - local_cur]           # 004240fc
    movsx edx, word ptr [ecx + field_16]             # 004240ff
    cmp edx, 0x1                                 # 00424103
    jne.d8 L_advance_to_next                            # 00424106
    # block 0x00424108: if cur.state is nonzero go to the reverse test, else fall through (cur zero)
    mov eax, dword ptr [ebp - local_cur]           # 00424108
    cmp dword ptr [eax + field_4], 0x0               # 0042410b
    jne.d8 L_next_link_reverse_test                            # 0042410f
    # block 0x00424111: cur zero: if next.state is also zero jump to the reverse test (which then advances because cur is zero)
    mov ecx, dword ptr [ebp - local_next]          # 00424111
    cmp dword ptr [ecx + field_4], 0x0               # 00424114
    je.d8 L_next_link_reverse_test                             # 00424118
    # block 0x0042411a: cur zero, next nonzero: raise cur.state to 1, raised++
    mov edx, dword ptr [ebp - local_cur]           # 0042411a
    mov dword ptr [edx + field_4], 0x1               # 0042411d
    mov eax, dword ptr [ebp - local_raised]          # 00424124
    add eax, 0x1                                 # 00424127
    mov dword ptr [ebp - local_raised], eax          # 0042412a
    jmp.d8 L_advance_to_next                            # 0042412d
L_next_link_reverse_test:
    # block 0x0042412f: reverse test: if cur.state is zero advance, else test next
    mov ecx, dword ptr [ebp - local_cur]           # 0042412f
    cmp dword ptr [ecx + field_4], 0x0               # 00424132
    je.d8 L_advance_to_next                             # 00424136
    # block 0x00424138: cur nonzero: if next.state is also nonzero nothing to do, advance
    mov edx, dword ptr [ebp - local_next]          # 00424138
    cmp dword ptr [edx + field_4], 0x0               # 0042413b
    jne.d8 L_advance_to_next                            # 0042413f
    # block 0x00424141: cur nonzero, next zero: raise next.state to 1, raised++
    mov eax, dword ptr [ebp - local_next]          # 00424141
    mov dword ptr [eax + field_4], 0x1               # 00424144
    mov ecx, dword ptr [ebp - local_raised]          # 0042414b
    add ecx, 0x1                                 # 0042414e
    mov dword ptr [ebp - local_raised], ecx          # 00424151
L_advance_to_next:
    # block 0x00424154: advance: cur = next, continue the pass
    mov edx, dword ptr [ebp - local_next]          # 00424154
    mov dword ptr [ebp - local_cur], edx           # 00424157
    jmp.d8 L_repeat_loop                            # 0042415a
L_end_of_pass:
    # block 0x0042415c: end of pass (cur was last): if raised == 0 the fixpoint is reached
    cmp dword ptr [ebp - local_raised], 0x0          # 0042415c
    je.d8 L_fixpoint_reached                             # 00424160
    # block 0x00424162: something changed: raised = 0, cur = branch.first_child, run another pass
    mov dword ptr [ebp - local_raised], 0x0          # 00424162
    mov eax, dword ptr [ebp + arg_branch]             # 00424169
    mov ecx, dword ptr [eax + field_4]               # 0042416c
    mov dword ptr [ebp - local_cur], ecx           # 0042416f
    jmp.d8 L_repeat_loop                            # 00424172
L_fixpoint_reached:
    # block 0x00424174: fixpoint reached: leave the reduction loop for the count phase
    jmp.d8 L_count_phase                            # 00424174
L_repeat_loop:
    # block 0x00424176: jump back to the top of the pass loop
    jmp.d32 L_visit_node                           # 00424176
L_count_phase:
    # block 0x0042417b: count phase: nonzero_count = 0, cur = branch.first_child
    mov dword ptr [ebp - local_nonzero_count], 0x0           # 0042417b
    mov edx, dword ptr [ebp + arg_branch]             # 00424182
    mov eax, dword ptr [edx + field_4]               # 00424185
    mov dword ptr [ebp - local_cur], eax           # 00424188
L_count_loop:
    # block 0x0042418b: count loop: if cur.state (+4) != 0 then nonzero_count++ (next block)
    mov ecx, dword ptr [ebp - local_cur]           # 0042418b
    cmp dword ptr [ecx + field_4], 0x0               # 0042418e
    je.d8 L_count_advance                             # 00424192
    # block 0x00424194: increment nonzero_count
    mov edx, dword ptr [ebp - local_nonzero_count]           # 00424194
    add edx, 0x1                                 # 00424197
    mov dword ptr [ebp - local_nonzero_count], edx           # 0042419a
L_count_advance:
    # block 0x0042419d: cur = cur.next (+0x38); loop while cur is not null
    mov eax, dword ptr [ebp - local_cur]           # 0042419d
    mov ecx, dword ptr [eax + field_38]              # 004241a0
    mov dword ptr [ebp - local_cur], ecx           # 004241a3
    cmp dword ptr [ebp - local_cur], 0x0           # 004241a6
    jne.d8 L_count_again                            # 004241aa
    # block 0x004241ac: cur null: leave the count loop
    jmp.d8 L_compare_total                            # 004241ac
L_count_again:
    # block 0x004241ae: cur not null: count the next node
    jmp.d8 L_count_loop                            # 004241ae
L_compare_total:
    # block 0x004241b0: compare branch.child_count (+0x18) with nonzero_count; unequal goes to the not-satisfied case
    mov edx, dword ptr [ebp + arg_branch]             # 004241b0
    mov eax, dword ptr [edx + field_18]              # 004241b3
    cmp eax, dword ptr [ebp - local_nonzero_count]           # 004241b6
    jne.d8 L_not_all_satisfied                            # 004241b9
    # block 0x004241bb: all children nonzero: branch.result (+0) = 1; if branch.owner (+0xc) is non-null go on
    mov ecx, dword ptr [ebp + arg_branch]             # 004241bb
    mov dword ptr [ecx], 0x1                     # 004241be
    mov edx, dword ptr [ebp + arg_branch]             # 004241c4
    cmp dword ptr [edx + field_c], 0x0               # 004241c7
    je.d8 L_store_done                             # 004241cb
    # block 0x004241cd: owner.state (+4) = 1
    mov eax, dword ptr [ebp + arg_branch]             # 004241cd
    mov ecx, dword ptr [eax + field_c]               # 004241d0
    mov dword ptr [ecx + field_4], 0x1               # 004241d3
L_store_done:
    # block 0x004241da: done with the satisfied case, go to the epilogue
    jmp.d8 L_epilogue                            # 004241da
L_not_all_satisfied:
    # block 0x004241dc: not all children nonzero: branch.result = 0; if branch.owner (+0xc) is non-null go on
    mov edx, dword ptr [ebp + arg_branch]             # 004241dc
    mov dword ptr [edx], 0x0                     # 004241df
    mov eax, dword ptr [ebp + arg_branch]             # 004241e5
    cmp dword ptr [eax + field_c], 0x0               # 004241e8
    je.d8 L_epilogue                             # 004241ec
    # block 0x004241ee: owner.state (+4) = 0
    mov ecx, dword ptr [ebp + arg_branch]             # 004241ee
    mov edx, dword ptr [ecx + field_c]               # 004241f1
    mov dword ptr [edx + field_4], 0x0               # 004241f4
L_epilogue:
    # block 0x004241fb: epilogue: restore frame, return popping 4
    {load} mov esp, ebp                          # 004241fb
    pop ebp                                      # 004241fd
    ret 0x4                                      # 004241fe
