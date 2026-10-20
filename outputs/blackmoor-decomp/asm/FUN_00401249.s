# FUN_00401249
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401249
# extent:       0x00401249-0x004013cc (387 code bytes)
# span:         0x00401249-0x004013cc (code 387, tables 0, padding 0)
# sha256:       e44d5cfc4ec7ce1dfc85acb80de8a44bff7e2fb38901431437c874530f5de5f1
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_cheat_sheet_property_sheet_runner
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/401249.c.txt, not original source) refers to the data labelled s_Nancy_Drew_Mystery___Cheat_Sheet_005370b0
# name-note:    Builds a property sheet captioned with the Nancy Drew Mystery Cheat Sheet string from five page objects, runs it and acts when the result equals 1.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       9 ebp-relative slot(s): local_4, local_c, local_998, local_e4c, local_e50, local_ed8, local_1964, local_2744, local_27d0
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050c920, FUN_00521ef1, FUN_00407bba, FUN_00404aca, FUN_004030ba, FUN_0040149a, FUN_00408a2a, FUN_0052233d, FUN_00522135, FUN_004d940a, FUN_00408d49, FUN_004014f5, FUN_00403229, FUN_00404af0, FUN_00407c29, FUN_00521fa5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 85 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_998, 0x998  # offset -0x998
.equ local_e4c, 0xe4c  # offset -0xe4c
.equ local_e50, 0xe50  # offset -0xe50
.equ local_ed8, 0xed8  # offset -0xed8
.equ local_1964, 0x1964  # offset -0x1964
.equ local_2744, 0x2744  # offset -0x2744
.equ local_27d0, 0x27d0  # offset -0x27d0

# --- external targets -----------------------------------------------
.set FUN_0040149a, .text + (0x0040149a - 0x401000)
.set FUN_004014f5, .text + (0x004014f5 - 0x401000)
.set FUN_004030ba, .text + (0x004030ba - 0x401000)
.set FUN_00403229, .text + (0x00403229 - 0x401000)
.set FUN_00404aca, .text + (0x00404aca - 0x401000)
.set FUN_00404af0, .text + (0x00404af0 - 0x401000)
.set FUN_00407bba, .text + (0x00407bba - 0x401000)
.set FUN_00407c29, .text + (0x00407c29 - 0x401000)
.set FUN_00408a2a, .text + (0x00408a2a - 0x401000)
.set FUN_00408d49, .text + (0x00408d49 - 0x401000)
.set FUN_004d940a, .text + (0x004d940a - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_00521ef1, .text + (0x00521ef1 - 0x401000)
.set FUN_00521fa5, .text + (0x00521fa5 - 0x401000)
.set FUN_00522135, .text + (0x00522135 - 0x401000)
.set FUN_0052233d, .text + (0x0052233d - 0x401000)

.org 0x00401249 - 0x401000
.globl FUN_00401249
FUN_00401249:
    # block 0x00401249: entry, 59 instruction(s), calls FUN_0050c920, FUN_00521ef1, FUN_00407bba, FUN_00404aca, FUN_004030ba, FUN_0040149a, FUN_00408a2a,..., ends with je to 0x00401357 (forward)
    push ebp                                     # 00401249
    {load} mov ebp, esp                          # 0040124a
    push -0x1                                    # 0040124c
    push 0x526aa8                                # 0040124e
    mov eax, dword ptr fs:[0x0]                  # 00401253
    push eax                                     # 00401259
    mov dword ptr fs:[0x0], esp                  # 0040125a
    mov eax, 0x27c4                              # 00401261
    call FUN_0050c920                            # 00401266
    push 0x0                                     # 0040126b
    push 0x0                                     # 0040126d
    push 0x5370b0                                # 0040126f
    lea ecx, [ebp - local_ed8]                   # 00401274
    call FUN_00521ef1                            # 0040127a
    mov dword ptr [ebp - local_4], 0x0           # 0040127f
    lea ecx, [ebp - local_998]                   # 00401286
    call FUN_00407bba                            # 0040128c
    mov byte ptr [ebp - local_4], 0x1            # 00401291
    lea ecx, [ebp - local_2744]                  # 00401295
    call FUN_00404aca                            # 0040129b
    mov byte ptr [ebp - local_4], 0x2            # 004012a0
    lea ecx, [ebp - local_e4c]                   # 004012a4
    call FUN_004030ba                            # 004012aa
    mov byte ptr [ebp - local_4], 0x3            # 004012af
    lea ecx, [ebp - local_27d0]                  # 004012b3
    call FUN_0040149a                            # 004012b9
    mov byte ptr [ebp - local_4], 0x4            # 004012be
    lea ecx, [ebp - local_1964]                  # 004012c2
    call FUN_00408a2a                            # 004012c8
    mov byte ptr [ebp - local_4], 0x5            # 004012cd
    lea eax, [ebp - local_e4c]                   # 004012d1
    push eax                                     # 004012d7
    lea ecx, [ebp - local_ed8]                   # 004012d8
    call FUN_0052233d                            # 004012de
    lea ecx, [ebp - local_2744]                  # 004012e3
    push ecx                                     # 004012e9
    lea ecx, [ebp - local_ed8]                   # 004012ea
    call FUN_0052233d                            # 004012f0
    lea edx, [ebp - local_27d0]                  # 004012f5
    push edx                                     # 004012fb
    lea ecx, [ebp - local_ed8]                   # 004012fc
    call FUN_0052233d                            # 00401302
    lea eax, [ebp - local_998]                   # 00401307
    push eax                                     # 0040130d
    lea ecx, [ebp - local_ed8]                   # 0040130e
    call FUN_0052233d                            # 00401314
    lea ecx, [ebp - local_1964]                  # 00401319
    push ecx                                     # 0040131f
    lea ecx, [ebp - local_ed8]                   # 00401320
    call FUN_0052233d                            # 00401326
    lea ecx, [ebp - local_ed8]                   # 0040132b
    call FUN_00522135                            # 00401331
    sub eax, 0x1                                 # 00401336
    neg eax                                      # 00401339
    {load} sbb eax, eax                          # 0040133b
    inc eax                                      # 0040133d
    mov dword ptr [ebp - local_e50], eax         # 0040133e
    cmp dword ptr [ebp - local_e50], 0x0         # 00401344
    je.d8 L_00401357                             # 0040134b
    # block 0x0040134d: entered by fall-through of je at 0x0040134b, 2 instruction(s), calls FUN_004d940a, falls into the block at 0x00401357
    mov ecx, 0x5e2e70                            # 0040134d
    call FUN_004d940a                            # 00401352
L_00401357:
    # block 0x00401357: entered by je at 0x0040134b, 24 instruction(s), calls FUN_00408d49, FUN_004014f5, FUN_00403229, FUN_00404af0, FUN_00407c29, FUN_00521fa5, ends with ret
    mov dword ptr [0x5839ad], 0x2                # 00401357
    mov byte ptr [ebp - local_4], 0x4            # 00401361
    lea ecx, [ebp - local_1964]                  # 00401365
    call FUN_00408d49                            # 0040136b
    mov byte ptr [ebp - local_4], 0x3            # 00401370
    lea ecx, [ebp - local_27d0]                  # 00401374
    call FUN_004014f5                            # 0040137a
    mov byte ptr [ebp - local_4], 0x2            # 0040137f
    lea ecx, [ebp - local_e4c]                   # 00401383
    call FUN_00403229                            # 00401389
    mov byte ptr [ebp - local_4], 0x1            # 0040138e
    lea ecx, [ebp - local_2744]                  # 00401392
    call FUN_00404af0                            # 00401398
    mov byte ptr [ebp - local_4], 0x0            # 0040139d
    lea ecx, [ebp - local_998]                   # 004013a1
    call FUN_00407c29                            # 004013a7
    mov dword ptr [ebp - local_4], 0xffffffff    # 004013ac
    lea ecx, [ebp - local_ed8]                   # 004013b3
    call FUN_00521fa5                            # 004013b9
    mov ecx, dword ptr [ebp - local_c]           # 004013be
    mov dword ptr fs:[0x0], ecx                  # 004013c1
    {load} mov esp, ebp                          # 004013c8
    pop ebp                                      # 004013ca
    ret                                          # 004013cb

