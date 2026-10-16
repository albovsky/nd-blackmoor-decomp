# FUN_00411215
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00411215
# extent:       0x00411215-0x0041137f (362 code bytes)
# span:         0x00411215-0x0041137f (code 362, tables 0, padding 0)
# sha256:       48b6322b9914f05c5898e14d070f08bdec68e253039ca25ef20bbe5a9e757c74
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00411215
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       12 ebp-relative slot(s): local_4, local_c, local_30, local_34, local_9c74, local_eac0, local_fbe0, local_fbe4, local_fbe8, local_fbec, local_fbf0, local_fbf4
# fields:       [ecx + n] field_21, field_23; [edx + n] field_23
# callees:      calls FUN_0050c920, FUN_00433c60, FUN_004343a2, FUN_00423142, FUN_00433e63
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 86 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_9c74, 0x9c74  # offset -0x9c74
.equ local_eac0, 0xeac0  # offset -0xeac0
.equ local_fbe0, 0xfbe0  # offset -0xfbe0
.equ local_fbe4, 0xfbe4  # offset -0xfbe4
.equ local_fbe8, 0xfbe8  # offset -0xfbe8
.equ local_fbec, 0xfbec  # offset -0xfbec
.equ local_fbf0, 0xfbf0  # offset -0xfbf0
.equ local_fbf4, 0xfbf4  # offset -0xfbf4
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23

# --- external targets -----------------------------------------------
.set FUN_00423142, .text + (0x00423142 - 0x401000)
.set FUN_00433c60, .text + (0x00433c60 - 0x401000)
.set FUN_00433e63, .text + (0x00433e63 - 0x401000)
.set FUN_004343a2, .text + (0x004343a2 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)

.org 0x00411215 - 0x401000
.globl FUN_00411215
FUN_00411215:
    # block 0x00411215: entry, 28 instruction(s), calls FUN_0050c920, FUN_00433c60, FUN_004343a2, ends with forward jump to 0x004112b2
    push ebp                                     # 00411215
    {load} mov ebp, esp                          # 00411216
    push -0x1                                    # 00411218
    push 0x527272                                # 0041121a
    mov eax, dword ptr fs:[0x0]                  # 0041121f
    push eax                                     # 00411225
    mov dword ptr fs:[0x0], esp                  # 00411226
    mov eax, 0xfbe8                              # 0041122d
    call FUN_0050c920                            # 00411232
    push esi                                     # 00411237
    push edi                                     # 00411238
    mov dword ptr [ebp - local_fbf4], ecx        # 00411239
    push 0x5b01cf                                # 0041123f
    lea ecx, [ebp - local_fbe0]                  # 00411244
    call FUN_00433c60                            # 0041124a
    mov dword ptr [ebp - local_4], 0x0           # 0041124f
    mov dword ptr [ebp - local_34], 0x2          # 00411256
    mov dword ptr [ebp - local_fbe8], 0x0        # 0041125d
    mov dword ptr [ebp - local_fbf0], 0x0        # 00411267
    push 0x541034                                # 00411271
    lea ecx, [ebp - local_fbe0]                  # 00411276
    call FUN_004343a2                            # 0041127c
    mov dword ptr [ebp - local_fbec], eax        # 00411281
    mov eax, dword ptr [ebp - local_eac0]        # 00411287
    mov cx, word ptr [eax]                       # 0041128d
    mov word ptr [ebp - local_fbf0], cx          # 00411290
    mov dword ptr [ebp - local_fbe4], 0x0        # 00411297
    jmp.d8 L_004112b2                            # 004112a1
L_004112a3:
    # block 0x004112a3: entered by jmp at 0x00411358, 3 instruction(s), falls into the block at 0x004112b2
    mov edx, dword ptr [ebp - local_fbe4]        # 004112a3
    add edx, 0x1                                 # 004112a9
    mov dword ptr [ebp - local_fbe4], edx        # 004112ac
L_004112b2:
    # block 0x004112b2: entered by jmp at 0x004112a1, 3 instruction(s), ends with jge to 0x0041135d (forward)
    mov eax, dword ptr [ebp - local_fbe4]        # 004112b2
    cmp eax, dword ptr [ebp - local_fbf0]        # 004112b8
    jge.d32 L_0041135d                           # 004112be
    # block 0x004112c4: entered by fall-through of jge at 0x004112be, 42 instruction(s), calls FUN_00423142, ends with backward jump to 0x004112a3
    mov ecx, 0x8                                 # 004112c4
    {load} xor eax, eax                          # 004112c9
    lea edi, [ebp - local_30]                    # 004112cb
    rep stosd dword ptr es:[edi], eax            # 004112ce
    stosb byte ptr es:[edi], al                  # 004112d0
    mov ecx, 0x2710                              # 004112d1
    {load} xor eax, eax                          # 004112d6
    lea edi, [ebp - local_9c74]                  # 004112d8
    rep stosd dword ptr es:[edi], eax            # 004112de
    mov esi, dword ptr [ebp - local_eac0]        # 004112e0
    add esi, dword ptr [ebp - local_34]          # 004112e6
    mov ecx, 0x8                                 # 004112e9
    lea edi, [ebp - local_30]                    # 004112ee
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004112f1
    movsb byte ptr es:[edi], byte ptr [esi]      # 004112f3
    mov ecx, dword ptr [ebp - local_eac0]        # 004112f4
    add ecx, dword ptr [ebp - local_34]          # 004112fa
    mov dx, word ptr [ecx + field_21]            # 004112fd
    mov word ptr [ebp - local_fbe8], dx          # 00411301
    mov ecx, dword ptr [ebp - local_fbe8]        # 00411308
    mov eax, dword ptr [ebp - local_34]          # 0041130e
    mov edx, dword ptr [ebp - local_eac0]        # 00411311
    lea esi, [edx + eax + field_23]              # 00411317
    lea edi, [ebp - local_9c74]                  # 0041131b
    {load} mov eax, ecx                          # 00411321
    shr ecx, 0x2                                 # 00411323
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00411326
    {load} mov ecx, eax                          # 00411328
    and ecx, 0x3                                 # 0041132a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041132d
    lea ecx, [ebp - local_9c74]                  # 0041132f
    push ecx                                     # 00411335
    lea edx, [ebp - local_30]                    # 00411336
    push edx                                     # 00411339
    mov ecx, dword ptr [ebp - local_fbf4]        # 0041133a
    add ecx, 0x2a                                # 00411340
    call FUN_00423142                            # 00411343
    mov eax, dword ptr [ebp - local_fbe8]        # 00411348
    mov ecx, dword ptr [ebp - local_34]          # 0041134e
    lea edx, [ecx + eax + field_23]              # 00411351
    mov dword ptr [ebp - local_34], edx          # 00411355
    jmp.d32 L_004112a3                           # 00411358
L_0041135d:
    # block 0x0041135d: entered by jge at 0x004112be, 10 instruction(s), calls FUN_00433e63, ends with ret
    mov dword ptr [ebp - local_4], 0xffffffff    # 0041135d
    lea ecx, [ebp - local_fbe0]                  # 00411364
    call FUN_00433e63                            # 0041136a
    mov ecx, dword ptr [ebp - local_c]           # 0041136f
    mov dword ptr fs:[0x0], ecx                  # 00411372
    pop edi                                      # 00411379
    pop esi                                      # 0041137a
    {load} mov esp, ebp                          # 0041137b
    pop ebp                                      # 0041137d
    ret                                          # 0041137e

