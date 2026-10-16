# FUN_004d39f9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d39f9
# extent:       0x004d39f9-0x004d3a52 (89 code bytes)
# span:         0x004d39f9-0x004d3a52 (code 89, tables 0, padding 0)
# sha256:       48d316b205db4a871706a7ceb32a0262cda3309557aa02e312f0690376e8fa0b
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d39f9
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0052139c, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:native_ad9_alloc_slot (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 28 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004d39f9 - 0x401000
.globl FUN_004d39f9
FUN_004d39f9:
    # block 0x004d39f9: entry, 5 instruction(s), ends with forward jump to 0x004d3a11
    push ebp                                     # 004d39f9
    {load} mov ebp, esp                          # 004d39fa
    push ecx                                     # 004d39fc
    mov word ptr [ebp - local_4], 0x18           # 004d39fd
    jmp.d8 L_004d3a11                            # 004d3a03
L_004d3a05:
    # block 0x004d3a05: entered by jmp at 0x004d3a30, 3 instruction(s), falls into the block at 0x004d3a11
    mov ax, word ptr [ebp - local_4]             # 004d3a05
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d3a09
    mov word ptr [ebp - local_4], ax             # 004d3a0d
L_004d3a11:
    # block 0x004d3a11: entered by jmp at 0x004d3a03, 3 instruction(s), ends with jg to 0x004d3a32 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004d3a11
    cmp ecx, 0x3f                                # 004d3a15
    jg.d8 L_004d3a32                             # 004d3a18
    # block 0x004d3a1a: entered by fall-through of jg at 0x004d3a18, 4 instruction(s), ends with jne to 0x004d3a30 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004d3a1a
    imul edx, edx, 0x4a                          # 004d3a1e
    cmp dword ptr [edx + 0x5d15a9], 0x0          # 004d3a21
    jne.d8 L_004d3a30                            # 004d3a28
    # block 0x004d3a2a: entered by fall-through of jne at 0x004d3a28, 2 instruction(s), ends with forward jump to 0x004d3a4e
    mov ax, word ptr [ebp - local_4]             # 004d3a2a
    jmp.d8 L_004d3a4e                            # 004d3a2e
L_004d3a30:
    # block 0x004d3a30: entered by jne at 0x004d3a28, 1 instruction(s), ends with backward jump to 0x004d3a05
    jmp.d8 L_004d3a05                            # 004d3a30
L_004d3a32:
    # block 0x004d3a32: entered by jg at 0x004d3a18, 7 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004d3a4e
    push 0x0                                     # 004d3a32
    push 0x0                                     # 004d3a34
    push 0x55a448                                # 004d3a36
    call FUN_0052139c                            # 004d3a3b
    mov ecx, 0x5cf659                            # 004d3a40
    call FUN_004c97b4                            # 004d3a45
    .insn 0x66, 0x0d, 0xffff{:u16}               # 004d3a4a
L_004d3a4e:
    # block 0x004d3a4e: entered by jmp at 0x004d3a2e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d3a4e
    pop ebp                                      # 004d3a50
    ret                                          # 004d3a51

