# FUN_00426148
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426148
# extent:       0x00426148-0x00426264 (284 code bytes)
# span:         0x00426148-0x004262ac (code 284, tables 72, padding 0)
# sha256:       5364e81197a02cf06ddb54e19b75bcbe623af79d34ecec2820e96cdf0d006725
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m426148_lifted
# naming:       native port src/original_methods_fl40.c:m426148_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 20 seeds; oracle 69/69 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00426063, FUN_004dc182, FUN_004dbcd0, FUN_004d9d70, FUN_004de743, FUN_004d47b0, FUN_004d6705, FUN_004dd409, FUN_00438150, FUN_004011c0, FUN_004d42e0, FUN_004262ac, FUN_0042639d, FUN_004c97b4, FUN_004f52a9
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m426148_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 69 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004011c0, .text + (0x004011c0 - 0x401000)
.set FUN_00426063, .text + (0x00426063 - 0x401000)
.set FUN_004262ac, .text + (0x004262ac - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_00438150, .text + (0x00438150 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d42e0, .text + (0x004d42e0 - 0x401000)
.set FUN_004d47b0, .text + (0x004d47b0 - 0x401000)
.set FUN_004d6705, .text + (0x004d6705 - 0x401000)
.set FUN_004d9d70, .text + (0x004d9d70 - 0x401000)
.set FUN_004dbcd0, .text + (0x004dbcd0 - 0x401000)
.set FUN_004dc182, .text + (0x004dc182 - 0x401000)
.set FUN_004dd409, .text + (0x004dd409 - 0x401000)
.set FUN_004de743, .text + (0x004de743 - 0x401000)
.set FUN_004f52a9, .text + (0x004f52a9 - 0x401000)

.org 0x00426148 - 0x401000
.globl FUN_00426148
FUN_00426148:
    # block 0x00426148: entry, 10 instruction(s), ends with ja to 0x0042622e (forward)
    push ebp                                     # 00426148
    {load} mov ebp, esp                          # 00426149
    push ecx                                     # 0042614b
    mov eax, dword ptr [0x583981]                # 0042614c
    mov dword ptr [ebp - local_4], eax           # 00426151
    mov ecx, dword ptr [ebp - local_4]           # 00426154
    sub ecx, 0x1                                 # 00426157
    mov dword ptr [ebp - local_4], ecx           # 0042615a
    cmp dword ptr [ebp - local_4], 0x11          # 0042615d
    ja.d32 L_0042622e                            # 00426161
    # block 0x00426167: entered by fall-through of ja at 0x00426161, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x426264]
    mov edx, dword ptr [ebp - local_4]           # 00426167
    jmp dword ptr [4*edx + SWTAB_00426264_VA]    # 0042616a
L_00426171:
    # block 0x00426171: entered by switch case, 2 instruction(s), calls FUN_00426063, ends with forward jump to 0x00426256
    call FUN_00426063                            # 00426171
    jmp.d32 L_00426256                           # 00426176
L_0042617b:
    # block 0x0042617b: entered by switch case, 3 instruction(s), calls FUN_004dc182, ends with forward jump to 0x00426256
    mov ecx, 0x637e85                            # 0042617b
    call FUN_004dc182                            # 00426180
    jmp.d32 L_00426256                           # 00426185
L_0042618a:
    # block 0x0042618a: entered by switch case, 2 instruction(s), calls FUN_004dbcd0, ends with forward jump to 0x00426256
    call FUN_004dbcd0                            # 0042618a
    jmp.d32 L_00426256                           # 0042618f
L_00426194:
    # block 0x00426194: entered by switch case, 2 instruction(s), calls FUN_004d9d70, ends with forward jump to 0x00426256
    call FUN_004d9d70                            # 00426194
    jmp.d32 L_00426256                           # 00426199
L_0042619e:
    # block 0x0042619e: entered by switch case, 3 instruction(s), calls FUN_004de743, ends with forward jump to 0x00426256
    mov ecx, 0x583235                            # 0042619e
    call FUN_004de743                            # 004261a3
    jmp.d32 L_00426256                           # 004261a8
L_004261ad:
    # block 0x004261ad: entered by switch case, 2 instruction(s), calls FUN_004d47b0, ends with forward jump to 0x00426256
    call FUN_004d47b0                            # 004261ad
    jmp.d32 L_00426256                           # 004261b2
L_004261b7:
    # block 0x004261b7: entered by switch case, 3 instruction(s), calls FUN_004d6705, ends with forward jump to 0x00426256
    mov ecx, 0x5e2e70                            # 004261b7
    call FUN_004d6705                            # 004261bc
    jmp.d32 L_00426256                           # 004261c1
L_004261c6:
    # block 0x004261c6: entered by switch case, 5 instruction(s), calls FUN_004dd409, ends with forward jump to 0x00426256
    push 0xc                                     # 004261c6
    push 0x6169a1                                # 004261c8
    mov ecx, 0x61677f                            # 004261cd
    call FUN_004dd409                            # 004261d2
    jmp.d8 L_00426256                            # 004261d7
L_004261d9:
    # block 0x004261d9: entered by switch case, 5 instruction(s), calls FUN_004dd409, ends with forward jump to 0x00426256
    push 0xd                                     # 004261d9
    push 0x616894                                # 004261db
    mov ecx, 0x61677f                            # 004261e0
    call FUN_004dd409                            # 004261e5
    jmp.d8 L_00426256                            # 004261ea
L_004261ec:
    # block 0x004261ec: entered by switch case, 5 instruction(s), calls FUN_004dd409, ends with forward jump to 0x00426256
    push 0xb                                     # 004261ec
    push 0x616787                                # 004261ee
    mov ecx, 0x61677f                            # 004261f3
    call FUN_004dd409                            # 004261f8
    jmp.d8 L_00426256                            # 004261fd
L_004261ff:
    # block 0x004261ff: entered by switch case, 2 instruction(s), calls FUN_00438150, ends with forward jump to 0x00426256
    call FUN_00438150                            # 004261ff
    jmp.d8 L_00426256                            # 00426204
L_00426206:
    # block 0x00426206: entered by switch case, 2 instruction(s), calls FUN_004011c0, ends with forward jump to 0x00426256
    call FUN_004011c0                            # 00426206
    jmp.d8 L_00426256                            # 0042620b
L_0042620d:
    # block 0x0042620d: entered by switch case, 2 instruction(s), calls FUN_004d42e0, ends with forward jump to 0x00426256
    call FUN_004d42e0                            # 0042620d
    jmp.d8 L_00426256                            # 00426212
L_00426214:
    # block 0x00426214: entered by switch case, 2 instruction(s), calls FUN_004262ac, ends with forward jump to 0x00426256
    call FUN_004262ac                            # 00426214
    jmp.d8 L_00426256                            # 00426219
L_0042621b:
    # block 0x0042621b: entered by switch case, 5 instruction(s), calls FUN_004dd409, ends with forward jump to 0x00426256
    push 0x11                                    # 0042621b
    push 0x6169a1                                # 0042621d
    mov ecx, 0x61677f                            # 00426222
    call FUN_004dd409                            # 00426227
    jmp.d8 L_00426256                            # 0042622c
L_0042622e:
    # block 0x0042622e: entered by ja at 0x00426161; switch case, 7 instruction(s), calls FUN_0042639d, FUN_004c97b4, falls into the block at 0x00426256
    push 0x570380                                # 0042622e
    push 0x5453ac                                # 00426233
    mov ecx, 0x583979                            # 00426238
    call FUN_0042639d                            # 0042623d
    mov dword ptr [0x5bb20c], 0x1                # 00426242
    mov ecx, 0x5cf659                            # 0042624c
    call FUN_004c97b4                            # 00426251
L_00426256:
    # block 0x00426256: entered by jmp at 0x00426176; jmp at 0x00426185; jmp at 0x0042618f; jmp at 0x00426199; more, 5 instruction(s), calls FUN_004f52a9, ends with ret
    mov ecx, 0x5cf1eb                            # 00426256
    call FUN_004f52a9                            # 0042625b
    {load} mov esp, ebp                          # 00426260
    pop ebp                                      # 00426262
    ret                                          # 00426263

# --- data items (not part of the function) -------------------------
.org 0x00426264 - 0x401000
SWTAB_00426264:  # 18 case address(es)
    .long L_00426171 - .text + 0x401000
    .long L_0042617b - .text + 0x401000
    .long L_0042618a - .text + 0x401000
    .long L_0042622e - .text + 0x401000
    .long L_0042620d - .text + 0x401000
    .long L_00426194 - .text + 0x401000
    .long L_004261b7 - .text + 0x401000
    .long L_0042619e - .text + 0x401000
    .long L_0042622e - .text + 0x401000
    .long L_004261ad - .text + 0x401000
    .long L_004261ec - .text + 0x401000
    .long L_004261c6 - .text + 0x401000
    .long L_004261d9 - .text + 0x401000
    .long L_004261ff - .text + 0x401000
    .long L_0042622e - .text + 0x401000
    .long L_00426206 - .text + 0x401000
    .long L_0042621b - .text + 0x401000
    .long L_00426214 - .text + 0x401000
.set SWTAB_00426264_VA, SWTAB_00426264 - .text + 0x401000

