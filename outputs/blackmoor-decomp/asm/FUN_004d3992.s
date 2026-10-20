# FUN_004d3992
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3992
# extent:       0x004d3992-0x004d39f9 (103 code bytes)
# span:         0x004d3992-0x004d39f9 (code 103, tables 0, padding 0)
# sha256:       b2d0e64f368b9b18845ea3662148cc164a98741a3e04938719adbc0efa5c00f9
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3992_clear_entry
# naming:       native port src/original_methods_fl29a.c:m4d3992_clear_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    Range check of the signed word index (0 to 0x57) with the three reporting calls, then the two dword clears of the record, also after a report; every instruction and jump direction executed. See tasks/fl29a-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl29a.c:m4d3992_clear_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 28 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004d3992 - 0x401000
.globl FUN_004d3992
FUN_004d3992:
    # block 0x004d3992: entry, 5 instruction(s), ends with jl to 0x004d39a6 (forward)
    push ebp                                     # 004d3992
    {load} mov ebp, esp                          # 004d3993
    movsx eax, word ptr [ebp + arg_8]            # 004d3995
    test eax, eax                                # 004d3999
    jl.d8 L_004d39a6                             # 004d399b
    # block 0x004d399d: entered by fall-through of jl at 0x004d399b, 3 instruction(s), ends with jl to 0x004d39d5 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004d399d
    cmp ecx, 0x58                                # 004d39a1
    jl.d8 L_004d39d5                             # 004d39a4
L_004d39a6:
    # block 0x004d39a6: entered by jl at 0x004d399b; fall-through of jl at 0x004d39a4, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x004d39d5
    movsx edx, word ptr [ebp + arg_8]            # 004d39a6
    push edx                                     # 004d39aa
    push 0x55a400                                # 004d39ab
    push 0x63888b                                # 004d39b0
    call FUN_0050ca3e                            # 004d39b5
    add esp, 0xc                                 # 004d39ba
    push 0x0                                     # 004d39bd
    push 0x0                                     # 004d39bf
    push 0x63888b                                # 004d39c1
    call FUN_0052139c                            # 004d39c6
    mov ecx, 0x5cf659                            # 004d39cb
    call FUN_004c97b4                            # 004d39d0
L_004d39d5:
    # block 0x004d39d5: entered by jl at 0x004d39a4, 8 instruction(s), ends with ret
    movsx eax, word ptr [ebp + arg_8]            # 004d39d5
    imul eax, eax, 0x4a                          # 004d39d9
    mov dword ptr [eax + 0x5d15a5], 0x0          # 004d39dc
    movsx ecx, word ptr [ebp + arg_8]            # 004d39e6
    imul ecx, ecx, 0x4a                          # 004d39ea
    mov dword ptr [ecx + 0x5d15a9], 0x0          # 004d39ed
    pop ebp                                      # 004d39f7
    ret                                          # 004d39f8

