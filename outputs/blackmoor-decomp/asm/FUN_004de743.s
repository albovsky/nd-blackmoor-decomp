# FUN_004de743
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de743
# extent:       0x004de743-0x004de7b0 (109 code bytes)
# span:         0x004de743-0x004de7c4 (code 109, tables 20, padding 0)
# sha256:       444db73c012ba7d9d1f67379e121d433a3c491beba05ed45c83dd6398be99842
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4de743_lifted
# naming:       native port src/original_methods_fl41.c:m4de743_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 9 seeds; oracle: 29/29 instructions, 2/2 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004de7c4, FUN_004fb397, FUN_004deed7, FUN_004fb737, FUN_004dfdc9
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4de743_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_004de7c4, .text + (0x004de7c4 - 0x401000)
.set FUN_004deed7, .text + (0x004deed7 - 0x401000)
.set FUN_004dfdc9, .text + (0x004dfdc9 - 0x401000)
.set FUN_004fb397, .text + (0x004fb397 - 0x401000)
.set FUN_004fb737, .text + (0x004fb737 - 0x401000)

.org 0x004de743 - 0x401000
.globl FUN_004de743
FUN_004de743:
    # block 0x004de743: entry, 8 instruction(s), ends with ja to 0x004de7ac (forward)
    push ebp                                     # 004de743
    {load} mov ebp, esp                          # 004de744
    sub esp, 0x8                                 # 004de746
    mov dword ptr [ebp - local_4], ecx           # 004de749
    mov eax, dword ptr [0x583995]                # 004de74c
    mov dword ptr [ebp - local_8], eax           # 004de751
    cmp dword ptr [ebp - local_8], 0x4           # 004de754
    ja.d8 L_004de7ac                             # 004de758
    # block 0x004de75a: entered by fall-through of ja at 0x004de758, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4de7b0]
    mov ecx, dword ptr [ebp - local_8]           # 004de75a
    jmp dword ptr [4*ecx + SWTAB_004de7b0_VA]    # 004de75d
L_004de764:
    # block 0x004de764: entered by switch case, 3 instruction(s), calls FUN_004de7c4, ends with forward jump to 0x004de7ac
    mov ecx, dword ptr [ebp - local_4]           # 004de764
    call FUN_004de7c4                            # 004de767
    jmp.d8 L_004de7ac                            # 004de76c
L_004de76e:
    # block 0x004de76e: entered by switch case, 4 instruction(s), calls FUN_004fb397, ends with forward jump to 0x004de7ac
    mov ecx, 0x5c3a67                            # 004de76e
    call FUN_004fb397                            # 004de773
    mov dword ptr [0x583995], 0x3                # 004de778
    jmp.d8 L_004de7ac                            # 004de782
L_004de784:
    # block 0x004de784: entered by switch case, 3 instruction(s), calls FUN_004deed7, ends with forward jump to 0x004de7ac
    mov ecx, dword ptr [ebp - local_4]           # 004de784
    call FUN_004deed7                            # 004de787
    jmp.d8 L_004de7ac                            # 004de78c
L_004de78e:
    # block 0x004de78e: entered by switch case, 4 instruction(s), calls FUN_004fb737, ends with forward jump to 0x004de7ac
    mov ecx, 0x5c3a67                            # 004de78e
    call FUN_004fb737                            # 004de793
    mov dword ptr [0x583995], 0x4                # 004de798
    jmp.d8 L_004de7ac                            # 004de7a2
L_004de7a4:
    # block 0x004de7a4: entered by switch case, 2 instruction(s), calls FUN_004dfdc9, falls into the block at 0x004de7ac
    mov ecx, dword ptr [ebp - local_4]           # 004de7a4
    call FUN_004dfdc9                            # 004de7a7
L_004de7ac:
    # block 0x004de7ac: entered by ja at 0x004de758; jmp at 0x004de76c; jmp at 0x004de782; jmp at 0x004de78c; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004de7ac
    pop ebp                                      # 004de7ae
    ret                                          # 004de7af

# --- data items (not part of the function) -------------------------
.org 0x004de7b0 - 0x401000
SWTAB_004de7b0:  # 5 case address(es)
    .long L_004de764 - .text + 0x401000
    .long L_004de76e - .text + 0x401000
    .long L_004de78e - .text + 0x401000
    .long L_004de784 - .text + 0x401000
    .long L_004de7a4 - .text + 0x401000
.set SWTAB_004de7b0_VA, SWTAB_004de7b0 - .text + 0x401000

