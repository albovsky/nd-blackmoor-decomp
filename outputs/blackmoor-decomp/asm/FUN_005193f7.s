# FUN_005193f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005193f7
# extent:       0x005193f7-0x00519453 (92 code bytes)
# span:         0x005193f7-0x00519453 (code 92, tables 0, padding 0)
# sha256:       54f936226be9f51f7f9ab44240f5dbece70134c0aa2cd2fcbf98441ee7e33527
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005193f7
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------

.org 0x005193f7 - 0x401000
.globl FUN_005193f7
FUN_005193f7:
    # block 0x005193f7: entry, 8 instruction(s), ends with je to 0x00519411 (forward)
    push ebp                                     # 005193f7
    {load} mov ebp, esp                          # 005193f8
    cmp dword ptr [ebp + arg_14], 0x0            # 005193fa
    mov ecx, dword ptr [ebp + arg_c]             # 005193fe
    push ebx                                     # 00519401
    push esi                                     # 00519402
    push edi                                     # 00519403
    je.d8 L_00519411                             # 00519404
    # block 0x00519406: entered by fall-through of je at 0x00519404, 5 instruction(s), ends with forward jump to 0x00519414
    mov esi, dword ptr [ebp + arg_8]             # 00519406
    mov byte ptr [ecx], 0x2d                     # 00519409
    inc ecx                                      # 0051940c
    neg esi                                      # 0051940d
    jmp.d8 L_00519414                            # 0051940f
L_00519411:
    # block 0x00519411: entered by je at 0x00519404, 1 instruction(s), falls into the block at 0x00519414
    mov esi, dword ptr [ebp + arg_8]             # 00519411
L_00519414:
    # block 0x00519414: entered by jmp at 0x0051940f, 1 instruction(s), falls into the block at 0x00519416
    {load} mov edi, ecx                          # 00519414
L_00519416:
    # block 0x00519416: entered by ja at 0x0051943a, 10 instruction(s), ends with jbe to 0x00519432 (forward)
    {load} mov eax, esi                          # 00519416
    {load} xor edx, edx                          # 00519418
    div dword ptr [ebp + arg_10]                 # 0051941a
    {load} mov eax, esi                          # 0051941d
    {load} mov ebx, edx                          # 0051941f
    {load} xor edx, edx                          # 00519421
    div dword ptr [ebp + arg_10]                 # 00519423
    cmp ebx, 0x9                                 # 00519426
    {load} mov esi, eax                          # 00519429
    jbe.d8 L_00519432                            # 0051942b
    # block 0x0051942d: entered by fall-through of jbe at 0x0051942b, 2 instruction(s), ends with forward jump to 0x00519435
    add bl, 0x57                                 # 0051942d
    jmp.d8 L_00519435                            # 00519430
L_00519432:
    # block 0x00519432: entered by jbe at 0x0051942b, 1 instruction(s), falls into the block at 0x00519435
    add bl, 0x30                                 # 00519432
L_00519435:
    # block 0x00519435: entered by jmp at 0x00519430, 4 instruction(s), ends with ja to 0x00519416 (backward)
    mov byte ptr [ecx], bl                       # 00519435
    inc ecx                                      # 00519437
    test esi, esi                                # 00519438
    ja.d8 L_00519416                             # 0051943a
    # block 0x0051943c: entered by fall-through of ja at 0x0051943a, 2 instruction(s), falls into the block at 0x00519440
    and byte ptr [ecx], 0x0                      # 0051943c
    dec ecx                                      # 0051943f
L_00519440:
    # block 0x00519440: entered by jb at 0x0051944c, 8 instruction(s), ends with jb to 0x00519440 (backward)
    mov dl, byte ptr [edi]                       # 00519440
    mov al, byte ptr [ecx]                       # 00519442
    mov byte ptr [ecx], dl                       # 00519444
    mov byte ptr [edi], al                       # 00519446
    dec ecx                                      # 00519448
    inc edi                                      # 00519449
    {load} cmp edi, ecx                          # 0051944a
    jb.d8 L_00519440                             # 0051944c
    # block 0x0051944e: entered by fall-through of jb at 0x0051944c, 5 instruction(s), ends with ret
    pop edi                                      # 0051944e
    pop esi                                      # 0051944f
    pop ebx                                      # 00519450
    pop ebp                                      # 00519451
    ret                                          # 00519452

