# FUN_004d42e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d42e0
# extent:       0x004d42e0-0x004d435f (127 code bytes)
# span:         0x004d42e0-0x004d4377 (code 127, tables 24, padding 0)
# sha256:       68d3062755baad19761e2b93cafeaef6632b41f6f1eedfb4d11cf20a6d70df0b
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d42e0_lifted
# naming:       native port src/original_methods_fl41.c:m4d42e0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 7 seeds; oracle: 30/30 instructions, 2/2 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d4377, FUN_004fc05d, FUN_004fbaaf, FUN_004d4410, FUN_004fbd7e, FUN_004d4645
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4d42e0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004d4377, .text + (0x004d4377 - 0x401000)
.set FUN_004d4410, .text + (0x004d4410 - 0x401000)
.set FUN_004d4645, .text + (0x004d4645 - 0x401000)
.set FUN_004fbaaf, .text + (0x004fbaaf - 0x401000)
.set FUN_004fbd7e, .text + (0x004fbd7e - 0x401000)
.set FUN_004fc05d, .text + (0x004fc05d - 0x401000)

.org 0x004d42e0 - 0x401000
.globl FUN_004d42e0
FUN_004d42e0:
    # block 0x004d42e0: entry, 7 instruction(s), ends with ja to 0x004d435b (forward)
    push ebp                                     # 004d42e0
    {load} mov ebp, esp                          # 004d42e1
    push ecx                                     # 004d42e3
    mov eax, dword ptr [0x583991]                # 004d42e4
    mov dword ptr [ebp - local_4], eax           # 004d42e9
    cmp dword ptr [ebp - local_4], 0x5           # 004d42ec
    ja.d8 L_004d435b                             # 004d42f0
    # block 0x004d42f2: entered by fall-through of ja at 0x004d42f0, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4d435f]
    mov ecx, dword ptr [ebp - local_4]           # 004d42f2
    jmp dword ptr [4*ecx + SWTAB_004d435f_VA]    # 004d42f5
L_004d42fc:
    # block 0x004d42fc: entered by switch case, 3 instruction(s), calls FUN_004d4377, ends with forward jump to 0x004d435b
    call FUN_004d4377                            # 004d42fc
    mov dword ptr [0x583991], 0x1                # 004d4301
    jmp.d8 L_004d435b                            # 004d430b
L_004d430d:
    # block 0x004d430d: entered by switch case, 4 instruction(s), calls FUN_004fc05d, ends with forward jump to 0x004d435b
    mov ecx, 0x5c3a67                            # 004d430d
    call FUN_004fc05d                            # 004d4312
    mov dword ptr [0x583991], 0x2                # 004d4317
    jmp.d8 L_004d435b                            # 004d4321
L_004d4323:
    # block 0x004d4323: entered by switch case, 4 instruction(s), calls FUN_004fbaaf, ends with forward jump to 0x004d435b
    mov ecx, 0x5c3a67                            # 004d4323
    call FUN_004fbaaf                            # 004d4328
    mov dword ptr [0x583991], 0x3                # 004d432d
    jmp.d8 L_004d435b                            # 004d4337
L_004d4339:
    # block 0x004d4339: entered by switch case, 2 instruction(s), calls FUN_004d4410, ends with forward jump to 0x004d435b
    call FUN_004d4410                            # 004d4339
    jmp.d8 L_004d435b                            # 004d433e
L_004d4340:
    # block 0x004d4340: entered by switch case, 4 instruction(s), calls FUN_004fbd7e, ends with forward jump to 0x004d435b
    mov ecx, 0x5c3a67                            # 004d4340
    call FUN_004fbd7e                            # 004d4345
    mov dword ptr [0x583991], 0x5                # 004d434a
    jmp.d8 L_004d435b                            # 004d4354
L_004d4356:
    # block 0x004d4356: entered by switch case, 1 instruction(s), calls FUN_004d4645, falls into the block at 0x004d435b
    call FUN_004d4645                            # 004d4356
L_004d435b:
    # block 0x004d435b: entered by ja at 0x004d42f0; jmp at 0x004d430b; jmp at 0x004d4321; jmp at 0x004d4337; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d435b
    pop ebp                                      # 004d435d
    ret                                          # 004d435e

# --- data items (not part of the function) -------------------------
.org 0x004d435f - 0x401000
SWTAB_004d435f:  # 6 case address(es)
    .long L_004d42fc - .text + 0x401000
    .long L_004d430d - .text + 0x401000
    .long L_004d4323 - .text + 0x401000
    .long L_004d4339 - .text + 0x401000
    .long L_004d4340 - .text + 0x401000
    .long L_004d4356 - .text + 0x401000
.set SWTAB_004d435f_VA, SWTAB_004d435f - .text + 0x401000

