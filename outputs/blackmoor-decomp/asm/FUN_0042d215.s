# FUN_0042d215
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042d215
# extent:       0x0042d215-0x0042d34a (309 code bytes)
# span:         0x0042d215-0x0042d35a (code 309, tables 16, padding 0)
# sha256:       817d5b8b99584248fc719be750f9ba367d653b9a7feeb1505f6d096b4090f6ad
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042d215
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4c, field_52, field_56; [ecx + n] field_4c, field_4e, field_52, field_56
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:secondary_step_index (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 66 instruction(s), 7 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4c, 0x4c  # offset +0x4c
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52
.equ field_56, 0x56  # offset +0x56

# --- external targets -----------------------------------------------

.org 0x0042d215 - 0x401000
.globl FUN_0042d215
FUN_0042d215:
    # block 0x0042d215: entry, 7 instruction(s), ends with ja to 0x0042d324 (forward)
    push ebp                                     # 0042d215
    {load} mov ebp, esp                          # 0042d216
    push ecx                                     # 0042d218
    mov eax, dword ptr [0x5b4e14]                # 0042d219
    mov dword ptr [ebp - local_4], eax           # 0042d21e
    cmp dword ptr [ebp - local_4], 0x3           # 0042d221
    ja.d32 L_0042d324                            # 0042d225
    # block 0x0042d22b: entered by fall-through of ja at 0x0042d225, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x42d34a]
    mov ecx, dword ptr [ebp - local_4]           # 0042d22b
    jmp dword ptr [4*ecx + SWTAB_0042d34a_VA]    # 0042d22e
L_0042d235:
    # block 0x0042d235: entered by switch case, 8 instruction(s), ends with jle to 0x0042d26c (forward)
    mov dx, word ptr [0x5b4e00]                  # 0042d235
    add dx, 0x1                                  # 0042d23c
    mov word ptr [0x5b4e00], dx                  # 0042d240
    movsx eax, word ptr [0x5b4e00]               # 0042d247
    mov ecx, dword ptr [0x5b4ead]                # 0042d24e
    movsx edx, word ptr [ecx + field_4e]         # 0042d254
    {load} cmp eax, edx                          # 0042d258
    jle.d8 L_0042d26c                            # 0042d25a
    # block 0x0042d25c: entered by fall-through of jle at 0x0042d25a, 3 instruction(s), falls into the block at 0x0042d26c
    mov eax, dword ptr [0x5b4ead]                # 0042d25c
    mov cx, word ptr [eax + field_4c]            # 0042d261
    mov word ptr [0x5b4e00], cx                  # 0042d265
L_0042d26c:
    # block 0x0042d26c: entered by jle at 0x0042d25a, 1 instruction(s), ends with forward jump to 0x0042d324
    jmp.d32 L_0042d324                           # 0042d26c
L_0042d271:
    # block 0x0042d271: entered by switch case, 8 instruction(s), ends with jle to 0x0042d2a8 (forward)
    mov dx, word ptr [0x5b4e00]                  # 0042d271
    add dx, 0x1                                  # 0042d278
    mov word ptr [0x5b4e00], dx                  # 0042d27c
    movsx eax, word ptr [0x5b4e00]               # 0042d283
    mov ecx, dword ptr [0x5b4ead]                # 0042d28a
    movsx edx, word ptr [ecx + field_52]         # 0042d290
    {load} cmp eax, edx                          # 0042d294
    jle.d8 L_0042d2a8                            # 0042d296
    # block 0x0042d298: entered by fall-through of jle at 0x0042d296, 3 instruction(s), falls into the block at 0x0042d2a8
    mov eax, dword ptr [0x5b4ead]                # 0042d298
    mov cx, word ptr [eax + field_52]            # 0042d29d
    mov word ptr [0x5b4e00], cx                  # 0042d2a1
L_0042d2a8:
    # block 0x0042d2a8: entered by jle at 0x0042d296, 1 instruction(s), ends with forward jump to 0x0042d324
    jmp.d8 L_0042d324                            # 0042d2a8
L_0042d2aa:
    # block 0x0042d2aa: entered by switch case, 8 instruction(s), ends with jge to 0x0042d2eb (forward)
    mov dx, word ptr [0x5b4e00]                  # 0042d2aa
    sub dx, 0x1                                  # 0042d2b1
    mov word ptr [0x5b4e00], dx                  # 0042d2b5
    movsx eax, word ptr [0x5b4e00]               # 0042d2bc
    mov ecx, dword ptr [0x5b4ead]                # 0042d2c3
    movsx edx, word ptr [ecx + field_4c]         # 0042d2c9
    {load} cmp eax, edx                          # 0042d2cd
    jge.d8 L_0042d2eb                            # 0042d2cf
    # block 0x0042d2d1: entered by fall-through of jge at 0x0042d2cf, 4 instruction(s), falls into the block at 0x0042d2eb
    mov eax, dword ptr [0x5b4ead]                # 0042d2d1
    mov cx, word ptr [eax + field_4c]            # 0042d2d6
    mov word ptr [0x5b4e00], cx                  # 0042d2da
    mov dword ptr [0x5b4e14], 0x0                # 0042d2e1
L_0042d2eb:
    # block 0x0042d2eb: entered by jge at 0x0042d2cf, 1 instruction(s), ends with forward jump to 0x0042d324
    jmp.d8 L_0042d324                            # 0042d2eb
L_0042d2ed:
    # block 0x0042d2ed: entered by switch case, 8 instruction(s), ends with jle to 0x0042d324 (forward)
    mov dx, word ptr [0x5b4e00]                  # 0042d2ed
    add dx, 0x1                                  # 0042d2f4
    mov word ptr [0x5b4e00], dx                  # 0042d2f8
    movsx eax, word ptr [0x5b4e00]               # 0042d2ff
    mov ecx, dword ptr [0x5b4ead]                # 0042d306
    movsx edx, word ptr [ecx + field_56]         # 0042d30c
    {load} cmp eax, edx                          # 0042d310
    jle.d8 L_0042d324                            # 0042d312
    # block 0x0042d314: entered by fall-through of jle at 0x0042d312, 3 instruction(s), falls into the block at 0x0042d324
    mov eax, dword ptr [0x5b4ead]                # 0042d314
    mov cx, word ptr [eax + field_56]            # 0042d319
    mov word ptr [0x5b4e00], cx                  # 0042d31d
L_0042d324:
    # block 0x0042d324: entered by ja at 0x0042d225; jmp at 0x0042d26c; jmp at 0x0042d2a8; jmp at 0x0042d2eb; more, 2 instruction(s), ends with jne to 0x0042d346 (forward)
    cmp dword ptr [0x5b4e14], 0x1                # 0042d324
    jne.d8 L_0042d346                            # 0042d32b
    # block 0x0042d32d: entered by fall-through of jne at 0x0042d32b, 3 instruction(s), ends with je to 0x0042d346 (forward)
    movsx edx, word ptr [0x5b4e89]               # 0042d32d
    cmp dword ptr [0x5c39e5], edx                # 0042d334
    je.d8 L_0042d346                             # 0042d33a
    # block 0x0042d33c: entered by fall-through of je at 0x0042d33a, 1 instruction(s), falls into the block at 0x0042d346
    mov dword ptr [0x5b4e14], 0x2                # 0042d33c
L_0042d346:
    # block 0x0042d346: entered by jne at 0x0042d32b; je at 0x0042d33a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0042d346
    pop ebp                                      # 0042d348
    ret                                          # 0042d349

# --- data items (not part of the function) -------------------------
.org 0x0042d34a - 0x401000
SWTAB_0042d34a:  # 4 case address(es)
    .long L_0042d235 - .text + 0x401000
    .long L_0042d271 - .text + 0x401000
    .long L_0042d2aa - .text + 0x401000
    .long L_0042d2ed - .text + 0x401000
.set SWTAB_0042d34a_VA, SWTAB_0042d34a - .text + 0x401000

