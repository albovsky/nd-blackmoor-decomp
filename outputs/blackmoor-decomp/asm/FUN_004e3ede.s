# FUN_004e3ede
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e3ede
# extent:       0x004e3ede-0x004e40a6 (456 code bytes)
# span:         0x004e3ede-0x004e40a6 (code 456, tables 0, padding 0)
# sha256:       94381b075a7044da91fd2028feae1cf850c3ba843f9dda924351de28f3326b75
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# name:         ScrollView::page_scroll
# arguments:    thiscall: ecx=this; one stack dword [ebp+8] of which only the low signed word is read (movsx word): the value 1 selects the first branch (decrease the first-position dword at this+0x53cb), any other value selects the second branch (increase the last-position dword at this+0x53d3); callers in the pseudocode pass 1 and 2; callee pops 4 (ret 4); no return value
# locals:       this_ptr = this spilled from ecx; step_extra = word, preset 0, replaced by the clamped word this+0x65d0 / 10 when the mode dword is 0xc or 0x10; step_base = word = w + w/4 with w the signed word at 0x005adb3c + [this+0x140c]*0x1d0 and w/4 the signed truncating quotient (cdq, and 3, add, sar 2); step_check = word, a copy of step_base unless the mode is 0xc or 0x10, then a copy of step_extra
# fields:       this+0x140c: signed word index into a table at 0x005adb3c with stride 0x1d0; this+0x4530: dword mode compared with 0xc and 0x10; this+0x53cb: dword first position, read and written; this+0x53d3: dword last position, written and read; this+0x53db and this+0x53e3: dword bounds whose difference (0x53e3 minus 0x53db) is the view span; this+0x65d0: signed word total, read; absolute global 0x005adb3c: table of words, stride 0x1d0, indexed by this+0x140c
# callees:      none
# track-n:      host-adapter: none
# unverified:   What the view is in game terms (a text or item list, a scroll bar, a pixel or an item position) is not established; the class and method names and the words first, last, span and total are labels from the arithmetic: last = first + span (recomputed in the decrease branch), and the increase branch clamps last to this+0x65d0 (a word) and recomputes first = last - span. The word at 0x5adb3c+index*0x1d0 and the mode values 0xc and 0x10 have no established meaning. The two branches are not symmetric: in the decrease branch the test (first < base + step_check) uses step_check but the subtraction uses step_extra, so outside modes 0xc and 0x10 the clamp test sees twice the base step while the subtraction removes the base step only; Ghidra's pseudocode shows the same shape (its local_8 and local_10 are my step_check and step_extra). That asymmetry is faithful to the bytes and I could not tell whether it was intended. The decrease branch does not look at the total or the span before moving; the increase branch moves only when total is greater than the span. The word additions (step_base + step_extra) are done on sign-extended words and the quotient /10 and the sum w + w/4 are truncated to 16 bits when stored; I did not check whether the values can reach that range. The division by 10 is a signed idiv of a sign-extended word (no divide-by-zero risk). The table index (this+0x140c) is not range checked.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ step_check, 0x4  # word: step used by the decrease branch test; copy of step_base, or of step_extra in modes 0xc and 0x10
.equ step_base, 0x8  # word: w + w/4 where w is the signed word at 0x005adb3c + [this+0x140c]*0x1d0
.equ step_extra, 0xc  # word: preset 0; this+0x65d0 / 10 clamped to span-0x1e in modes 0xc and 0x10
.equ this_ptr, 0x10  # this, spilled from ecx
.equ arg_direction, 0x8  # stack argument: signed word, 1 = decrease branch, anything else = increase branch
.equ this_table_index, 0x140c  # this+0x140c: signed word index into the table at 0x005adb3c (stride 0x1d0)
.equ this_mode, 0x4530  # this+0x4530: dword mode, special-cased when 0xc or 0x10
.equ this_first, 0x53cb  # this+0x53cb: dword first position (decreased or recomputed)
.equ this_last, 0x53d3  # this+0x53d3: dword last position (first + span, or increased and clamped to the total)
.equ this_bound_lo, 0x53db  # this+0x53db: dword bound subtracted from this+0x53e3 to give the span
.equ this_bound_hi, 0x53e3  # this+0x53e3: dword bound; span = this+0x53e3 - this+0x53db
.equ this_total, 0x65d0  # this+0x65d0: signed word total

# --- external targets -----------------------------------------------

.org 0x004e3ede - 0x401000
.globl FUN_004e3ede
FUN_004e3ede:
    # block 0x004e3ede: entry: step_extra = 0; step_base = w + w/4 (w = signed word at 0x5adb3c + this_table_index*0x1d0, w/4 signed truncating); step_check = step_base; if this_mode == 0xc go to mode_special
    push ebp                                     # 004e3ede
    {load} mov ebp, esp                          # 004e3edf
    sub esp, 0x10                                # 004e3ee1
    mov dword ptr [ebp - this_ptr], ecx          # 004e3ee4
    mov word ptr [ebp - step_extra], 0x0            # 004e3ee7
    mov eax, dword ptr [ebp - this_ptr]          # 004e3eed
    movsx ecx, word ptr [eax + this_table_index]       # 004e3ef0
    imul ecx, ecx, 0x1d0                         # 004e3ef7
    movsx ecx, word ptr [ecx + 0x5adb3c]         # 004e3efd
    mov edx, dword ptr [ebp - this_ptr]          # 004e3f04
    movsx eax, word ptr [edx + this_table_index]       # 004e3f07
    imul eax, eax, 0x1d0                         # 004e3f0e
    movsx eax, word ptr [eax + 0x5adb3c]         # 004e3f14
    cdq                                          # 004e3f1b
    and edx, 0x3                                 # 004e3f1c
    {load} add eax, edx                          # 004e3f1f
    sar eax, 0x2                                 # 004e3f21
    {load} add ecx, eax                          # 004e3f24
    mov word ptr [ebp - step_base], cx             # 004e3f26
    mov cx, word ptr [ebp - step_base]             # 004e3f2a
    mov word ptr [ebp - step_check], cx             # 004e3f2e
    mov edx, dword ptr [ebp - this_ptr]          # 004e3f32
    cmp dword ptr [edx + this_mode], 0xc        # 004e3f35
    je.d8 mode_special                             # 004e3f3c
    # block 0x004e3f3e: mode is not 0xc: if this_mode != 0x10 go to direction_test with the steps as set
    mov eax, dword ptr [ebp - this_ptr]          # 004e3f3e
    cmp dword ptr [eax + this_mode], 0x10       # 004e3f41
    jne.d8 direction_test                            # 004e3f48
mode_special:
    # block 0x004e3f4a: mode_special (0xc or 0x10): step_extra = this_total / 10 (signed idiv of the sign-extended word); if step_extra > span - 0x1e (span = this_bound_hi - this_bound_lo, signed compare) fall through to clamp, else go to extra_clamped
    mov ecx, dword ptr [ebp - this_ptr]          # 004e3f4a
    movsx eax, word ptr [ecx + this_total]       # 004e3f4d
    cdq                                          # 004e3f54
    mov ecx, 0xa                                 # 004e3f55
    idiv ecx                                     # 004e3f5a
    mov word ptr [ebp - step_extra], ax             # 004e3f5c
    movsx edx, word ptr [ebp - step_extra]          # 004e3f60
    mov eax, dword ptr [ebp - this_ptr]          # 004e3f64
    mov ecx, dword ptr [ebp - this_ptr]          # 004e3f67
    mov eax, dword ptr [eax + this_bound_hi]        # 004e3f6a
    sub eax, dword ptr [ecx + this_bound_lo]        # 004e3f70
    sub eax, 0x1e                                # 004e3f76
    {load} cmp edx, eax                          # 004e3f79
    jle.d8 extra_clamped                            # 004e3f7b
    # block 0x004e3f7d: clamp: step_extra = low word of (span - 0x1e)
    mov ecx, dword ptr [ebp - this_ptr]          # 004e3f7d
    mov edx, dword ptr [ebp - this_ptr]          # 004e3f80
    mov eax, dword ptr [ecx + this_bound_hi]        # 004e3f83
    sub eax, dword ptr [edx + this_bound_lo]        # 004e3f89
    sub eax, 0x1e                                # 004e3f8f
    mov word ptr [ebp - step_extra], ax             # 004e3f92
extra_clamped:
    # block 0x004e3f96: extra_clamped: step_check = step_extra
    mov cx, word ptr [ebp - step_extra]             # 004e3f96
    mov word ptr [ebp - step_check], cx             # 004e3f9a
direction_test:
    # block 0x004e3f9e: direction_test: if the signed word arg_direction is not 1 go to direction_increase
    movsx edx, word ptr [ebp + arg_direction]            # 004e3f9e
    cmp edx, 0x1                                 # 004e3fa2
    jne.d8 direction_increase                            # 004e3fa5
    # block 0x004e3fa7: direction 1: compute this_first - (step_base + step_check) with the two signed words; if negative go to first_to_zero
    movsx eax, word ptr [ebp - step_base]          # 004e3fa7
    movsx ecx, word ptr [ebp - step_check]          # 004e3fab
    {load} add eax, ecx                          # 004e3faf
    mov edx, dword ptr [ebp - this_ptr]          # 004e3fb1
    mov ecx, dword ptr [edx + this_first]        # 004e3fb4
    {load} sub ecx, eax                          # 004e3fba
    test ecx, ecx                                # 004e3fbc
    jl.d8 first_to_zero                             # 004e3fbe
    # block 0x004e3fc0: not negative: this_first = this_first - (step_base + step_extra), then go to recompute_last
    movsx edx, word ptr [ebp - step_base]          # 004e3fc0
    movsx eax, word ptr [ebp - step_extra]          # 004e3fc4
    {load} add edx, eax                          # 004e3fc8
    mov ecx, dword ptr [ebp - this_ptr]          # 004e3fca
    mov eax, dword ptr [ecx + this_first]        # 004e3fcd
    {load} sub eax, edx                          # 004e3fd3
    mov ecx, dword ptr [ebp - this_ptr]          # 004e3fd5
    mov dword ptr [ecx + this_first], eax        # 004e3fd8
    jmp.d8 recompute_last                            # 004e3fde
first_to_zero:
    # block 0x004e3fe0: first_to_zero: this_first = 0
    mov edx, dword ptr [ebp - this_ptr]          # 004e3fe0
    mov dword ptr [edx + this_first], 0x0        # 004e3fe3
recompute_last:
    # block 0x004e3fed: recompute_last: this_last = this_first + this_bound_hi - this_bound_lo, then go to the epilogue
    mov eax, dword ptr [ebp - this_ptr]          # 004e3fed
    mov ecx, dword ptr [eax + this_first]        # 004e3ff0
    mov edx, dword ptr [ebp - this_ptr]          # 004e3ff6
    add ecx, dword ptr [edx + this_bound_hi]        # 004e3ff9
    mov eax, dword ptr [ebp - this_ptr]          # 004e3fff
    sub ecx, dword ptr [eax + this_bound_lo]        # 004e4002
    mov edx, dword ptr [ebp - this_ptr]          # 004e4008
    mov dword ptr [edx + this_last], ecx        # 004e400b
    jmp.d32 epilogue                           # 004e4011
direction_increase:
    # block 0x004e4016: direction_increase: if the signed word this_total <= span (this_bound_hi - this_bound_lo) there is nothing to scroll, go to the epilogue
    mov eax, dword ptr [ebp - this_ptr]          # 004e4016
    movsx ecx, word ptr [eax + this_total]       # 004e4019
    mov edx, dword ptr [ebp - this_ptr]          # 004e4020
    mov eax, dword ptr [ebp - this_ptr]          # 004e4023
    mov edx, dword ptr [edx + this_bound_hi]        # 004e4026
    sub edx, dword ptr [eax + this_bound_lo]        # 004e402c
    {load} cmp ecx, edx                          # 004e4032
    jle.d8 epilogue                            # 004e4034
    # block 0x004e4036: this_last = this_last + (step_base + step_extra); if this_last <= this_total (signed word compare) go to recompute_first
    movsx eax, word ptr [ebp - step_base]          # 004e4036
    movsx ecx, word ptr [ebp - step_extra]          # 004e403a
    {load} add eax, ecx                          # 004e403e
    mov edx, dword ptr [ebp - this_ptr]          # 004e4040
    mov ecx, dword ptr [edx + this_last]        # 004e4043
    {load} add ecx, eax                          # 004e4049
    mov edx, dword ptr [ebp - this_ptr]          # 004e404b
    mov dword ptr [edx + this_last], ecx        # 004e404e
    mov eax, dword ptr [ebp - this_ptr]          # 004e4054
    movsx ecx, word ptr [eax + this_total]       # 004e4057
    mov edx, dword ptr [ebp - this_ptr]          # 004e405e
    cmp dword ptr [edx + this_last], ecx        # 004e4061
    jle.d8 recompute_first                            # 004e4067
    # block 0x004e4069: this_last above the total: this_last = this_total (sign-extended word)
    mov eax, dword ptr [ebp - this_ptr]          # 004e4069
    movsx ecx, word ptr [eax + this_total]       # 004e406c
    mov edx, dword ptr [ebp - this_ptr]          # 004e4073
    mov dword ptr [edx + this_last], ecx        # 004e4076
recompute_first:
    # block 0x004e407c: recompute_first: this_first = this_last - this_bound_hi + this_bound_lo
    mov eax, dword ptr [ebp - this_ptr]          # 004e407c
    mov ecx, dword ptr [ebp - this_ptr]          # 004e407f
    mov edx, dword ptr [eax + this_last]        # 004e4082
    sub edx, dword ptr [ecx + this_bound_hi]        # 004e4088
    mov eax, dword ptr [ebp - this_ptr]          # 004e408e
    add edx, dword ptr [eax + this_bound_lo]        # 004e4091
    mov ecx, dword ptr [ebp - this_ptr]          # 004e4097
    mov dword ptr [ecx + this_first], edx        # 004e409a
epilogue:
    # block 0x004e40a0: epilogue: restore the frame and return, popping the one stack argument (ret 4)
    {load} mov esp, ebp                          # 004e40a0
    pop ebp                                      # 004e40a2
    ret 0x4                                      # 004e40a3
