# FUN_004e94c1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e94c1
# extent:       0x004e94c1-0x004e9795 (724 code bytes)
# span:         0x004e94c1-0x004e97ad (code 724, tables 24, padding 0)
# sha256:       825f49bbaf12bc9ff9dfc163de37a6f2bda228e2d4af5edf89185810cd2ef628
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_inventory_view_mode_machine
# naming:       INFERRED (lower confidence, not verified): the repository text src/inventory_view_runtime.h:22 says "mode machine 0x4e94c1"; src/blackmoor_app.mm:3434 says "the open transition (0x4e94c1 modes 0/4/5)"
# name-note:    Mode machine of the inventory view including the open transition for modes 0/4/5.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_7016, field_764c, field_822e, field_8236; [ecx + n] field_7012, field_764c, field_7654, field_822e, field_8232; [edx + n] field_7012, field_7016, field_7650, field_7654, field_822e, field_8232, field_8236
# callees:      calls FUN_004e0559, FUN_004ee5cd, FUN_004ee5f2, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4, FUN_0043dbd5, FUN_004d36ed, FUN_004e29ec, FUN_004e2913, FUN_004e29b7, FUN_004ee673, FUN_004ee6c7, FUN_004e7d04, FUN_004e812f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 170 instruction(s), 13 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_7012, 0x7012  # offset +0x7012
.equ field_7016, 0x7016  # offset +0x7016
.equ field_764c, 0x764c  # offset +0x764c
.equ field_7650, 0x7650  # offset +0x7650
.equ field_7654, 0x7654  # offset +0x7654
.equ field_822e, 0x822e  # offset +0x822e
.equ field_8232, 0x8232  # offset +0x8232
.equ field_8236, 0x8236  # offset +0x8236

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004e0559, .text + (0x004e0559 - 0x401000)
.set FUN_004e2913, .text + (0x004e2913 - 0x401000)
.set FUN_004e29b7, .text + (0x004e29b7 - 0x401000)
.set FUN_004e29ec, .text + (0x004e29ec - 0x401000)
.set FUN_004e7d04, .text + (0x004e7d04 - 0x401000)
.set FUN_004e812f, .text + (0x004e812f - 0x401000)
.set FUN_004ee5cd, .text + (0x004ee5cd - 0x401000)
.set FUN_004ee5f2, .text + (0x004ee5f2 - 0x401000)
.set FUN_004ee673, .text + (0x004ee673 - 0x401000)
.set FUN_004ee6c7, .text + (0x004ee6c7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004e94c1 - 0x401000
.globl FUN_004e94c1
FUN_004e94c1:
    # block 0x004e94c1: entry, 9 instruction(s), ends with ja to 0x004e9791 (forward)
    push ebp                                     # 004e94c1
    {load} mov ebp, esp                          # 004e94c2
    sub esp, 0xc                                 # 004e94c4
    mov dword ptr [ebp - local_4], ecx           # 004e94c7
    mov eax, dword ptr [ebp - local_4]           # 004e94ca
    mov ecx, dword ptr [eax + field_764c]        # 004e94cd
    mov dword ptr [ebp - local_8], ecx           # 004e94d3
    cmp dword ptr [ebp - local_8], 0x5           # 004e94d6
    ja.d32 L_004e9791                            # 004e94da
    # block 0x004e94e0: entered by fall-through of ja at 0x004e94da, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4e9795]
    mov edx, dword ptr [ebp - local_8]           # 004e94e0
    jmp dword ptr [4*edx + SWTAB_004e9795_VA]    # 004e94e3
L_004e94ea:
    # block 0x004e94ea: entered by switch case, 9 instruction(s), calls FUN_004e0559, FUN_004ee5cd, ends with jne to 0x004e9515 (forward)
    push 0x0                                     # 004e94ea
    push 0x0                                     # 004e94ec
    push 0x1                                     # 004e94ee
    mov ecx, 0x570508                            # 004e94f0
    call FUN_004e0559                            # 004e94f5
    mov ecx, dword ptr [ebp - local_4]           # 004e94fa
    call FUN_004ee5cd                            # 004e94fd
    test eax, eax                                # 004e9502
    jne.d8 L_004e9515                            # 004e9504
    # block 0x004e9506: entered by fall-through of jne at 0x004e9504, 3 instruction(s), ends with forward jump to 0x004e9522
    mov eax, dword ptr [ebp - local_4]           # 004e9506
    mov dword ptr [eax + field_764c], 0x4        # 004e9509
    jmp.d8 L_004e9522                            # 004e9513
L_004e9515:
    # block 0x004e9515: entered by jne at 0x004e9504, 2 instruction(s), falls into the block at 0x004e9522
    mov ecx, dword ptr [ebp - local_4]           # 004e9515
    mov dword ptr [ecx + field_764c], 0x5        # 004e9518
L_004e9522:
    # block 0x004e9522: entered by jmp at 0x004e9513, 1 instruction(s), ends with forward jump to 0x004e9791
    jmp.d32 L_004e9791                           # 004e9522
L_004e9527:
    # block 0x004e9527: entered by switch case, 4 instruction(s), calls FUN_004ee5cd, ends with je to 0x004e959e (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e9527
    call FUN_004ee5cd                            # 004e952a
    test eax, eax                                # 004e952f
    je.d8 L_004e959e                             # 004e9531
    # block 0x004e9533: entered by fall-through of je at 0x004e9531, 4 instruction(s), calls FUN_004ee5f2, ends with je to 0x004e9591 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e9533
    call FUN_004ee5f2                            # 004e9536
    cmp eax, 0x2                                 # 004e953b
    je.d8 L_004e9591                             # 004e953e
    # block 0x004e9540: entered by fall-through of je at 0x004e953e, 13 instruction(s), calls FUN_004ee5f2, FUN_0050ca3e, FUN_004264e8, ends with je to 0x004e9582 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e9540
    call FUN_004ee5f2                            # 004e9543
    push eax                                     # 004e9548
    push 0x55c664                                # 004e9549
    push 0x63888b                                # 004e954e
    call FUN_0050ca3e                            # 004e9553
    add esp, 0xc                                 # 004e9558
    push 0x63888b                                # 004e955b
    mov ecx, 0x583979                            # 004e9560
    call FUN_004264e8                            # 004e9565
    movsx edx, word ptr [0x63a4cd]               # 004e956a
    test edx, edx                                # 004e9571
    je.d8 L_004e9582                             # 004e9573
    # block 0x004e9575: entered by fall-through of je at 0x004e9573, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004e9582
    push 0x63888b                                # 004e9575
    call FUN_0044a2b7                            # 004e957a
    add esp, 0x4                                 # 004e957f
L_004e9582:
    # block 0x004e9582: entered by je at 0x004e9573, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004e9791
    mov ecx, 0x5cf659                            # 004e9582
    call FUN_004c97b4                            # 004e9587
    jmp.d32 L_004e9791                           # 004e958c
L_004e9591:
    # block 0x004e9591: entered by je at 0x004e953e, 2 instruction(s), falls into the block at 0x004e959e
    mov eax, dword ptr [ebp - local_4]           # 004e9591
    mov dword ptr [eax + field_764c], 0x5        # 004e9594
L_004e959e:
    # block 0x004e959e: entered by je at 0x004e9531, 1 instruction(s), ends with forward jump to 0x004e9791
    jmp.d32 L_004e9791                           # 004e959e
L_004e95a3:
    # block 0x004e95a3: entered by switch case, 9 instruction(s), calls FUN_0043dbd5, FUN_004d36ed, falls into the block at 0x004e95cb
    mov ecx, dword ptr [ebp - local_4]           # 004e95a3
    mov edx, dword ptr [ebp - local_4]           # 004e95a6
    mov eax, dword ptr [edx + field_7650]        # 004e95a9
    mov dword ptr [ecx + field_764c], eax        # 004e95af
    call FUN_0043dbd5                            # 004e95b5
    call FUN_004d36ed                            # 004e95ba
    mov ecx, dword ptr [ebp - local_4]           # 004e95bf
    mov edx, dword ptr [ecx + field_764c]        # 004e95c2
    mov dword ptr [ebp - local_c], edx           # 004e95c8
L_004e95cb:
    # block 0x004e95cb: entered by switch case, 3 instruction(s), ends with forward jump to 0x004e95ef
    mov eax, dword ptr [ebp - local_4]           # 004e95cb
    mov dword ptr [eax + field_822e], 0x0        # 004e95ce
    jmp.d8 L_004e95ef                            # 004e95d8
L_004e95da:
    # block 0x004e95da: entered by jmp at 0x004e967d, 5 instruction(s), falls into the block at 0x004e95ef
    mov ecx, dword ptr [ebp - local_4]           # 004e95da
    mov edx, dword ptr [ecx + field_822e]        # 004e95dd
    add edx, 0x1                                 # 004e95e3
    mov eax, dword ptr [ebp - local_4]           # 004e95e6
    mov dword ptr [eax + field_822e], edx        # 004e95e9
L_004e95ef:
    # block 0x004e95ef: entered by jmp at 0x004e95d8, 3 instruction(s), ends with jge to 0x004e9682 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e95ef
    cmp dword ptr [ecx + field_822e], 0x6        # 004e95f2
    jge.d32 L_004e9682                           # 004e95f9
    # block 0x004e95ff: entered by fall-through of jge at 0x004e95f9, 6 instruction(s), ends with je to 0x004e967d (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e95ff
    mov eax, dword ptr [edx + field_822e]        # 004e9602
    imul eax, eax, 0xf7                          # 004e9608
    mov ecx, dword ptr [ebp - local_4]           # 004e960e
    cmp dword ptr [ecx + eax + field_7012], 0x0  # 004e9611
    je.d8 L_004e967d                             # 004e9619
    # block 0x004e961b: entered by fall-through of je at 0x004e9619, 14 instruction(s), calls FUN_004e29ec, FUN_004e2913, ends with je to 0x004e967d (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e961b
    mov eax, dword ptr [edx + field_822e]        # 004e961e
    imul eax, eax, 0x18f                         # 004e9624
    mov ecx, dword ptr [ebp - local_4]           # 004e962a
    lea ecx, [ecx + eax + field_7654]            # 004e962d
    call FUN_004e29ec                            # 004e9634
    mov edx, dword ptr [ebp - local_4]           # 004e9639
    mov eax, dword ptr [edx + field_822e]        # 004e963c
    imul eax, eax, 0x18f                         # 004e9642
    mov ecx, dword ptr [ebp - local_4]           # 004e9648
    lea ecx, [ecx + eax + field_7654]            # 004e964b
    call FUN_004e2913                            # 004e9652
    test eax, eax                                # 004e9657
    je.d8 L_004e967d                             # 004e9659
    # block 0x004e965b: entered by fall-through of je at 0x004e9659, 7 instruction(s), falls into the block at 0x004e967d
    mov edx, dword ptr [ebp - local_4]           # 004e965b
    mov eax, dword ptr [edx + field_822e]        # 004e965e
    imul eax, eax, 0xf7                          # 004e9664
    mov ecx, dword ptr [ebp - local_4]           # 004e966a
    mov edx, dword ptr [ebp - local_4]           # 004e966d
    mov eax, dword ptr [edx + eax + field_7016]  # 004e9670
    mov dword ptr [ecx + field_8232], eax        # 004e9677
L_004e967d:
    # block 0x004e967d: entered by je at 0x004e9619; je at 0x004e9659, 1 instruction(s), ends with backward jump to 0x004e95da
    jmp.d32 L_004e95da                           # 004e967d
L_004e9682:
    # block 0x004e9682: entered by jge at 0x004e95f9, 5 instruction(s), ends with je to 0x004e9771 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e9682
    mov edx, dword ptr [ebp - local_4]           # 004e9685
    mov eax, dword ptr [ecx + field_8232]        # 004e9688
    cmp eax, dword ptr [edx + field_8236]        # 004e968e
    je.d32 L_004e9771                            # 004e9694
    # block 0x004e969a: entered by fall-through of je at 0x004e9694, 3 instruction(s), ends with forward jump to 0x004e96be
    mov ecx, dword ptr [ebp - local_4]           # 004e969a
    mov dword ptr [ecx + field_822e], 0x0        # 004e969d
    jmp.d8 L_004e96be                            # 004e96a7
L_004e96a9:
    # block 0x004e96a9: entered by jmp at 0x004e9750, 5 instruction(s), falls into the block at 0x004e96be
    mov edx, dword ptr [ebp - local_4]           # 004e96a9
    mov eax, dword ptr [edx + field_822e]        # 004e96ac
    add eax, 0x1                                 # 004e96b2
    mov ecx, dword ptr [ebp - local_4]           # 004e96b5
    mov dword ptr [ecx + field_822e], eax        # 004e96b8
L_004e96be:
    # block 0x004e96be: entered by jmp at 0x004e96a7, 3 instruction(s), ends with jge to 0x004e9755 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e96be
    cmp dword ptr [edx + field_822e], 0x6        # 004e96c1
    jge.d32 L_004e9755                           # 004e96c8
    # block 0x004e96ce: entered by fall-through of jge at 0x004e96c8, 6 instruction(s), ends with je to 0x004e9750 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e96ce
    mov ecx, dword ptr [eax + field_822e]        # 004e96d1
    imul ecx, ecx, 0xf7                          # 004e96d7
    mov edx, dword ptr [ebp - local_4]           # 004e96dd
    cmp dword ptr [edx + ecx + field_7012], 0x0  # 004e96e0
    je.d8 L_004e9750                             # 004e96e8
    # block 0x004e96ea: entered by fall-through of je at 0x004e96e8, 8 instruction(s), ends with jne to 0x004e9730 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e96ea
    mov ecx, dword ptr [eax + field_822e]        # 004e96ed
    imul ecx, ecx, 0xf7                          # 004e96f3
    mov edx, dword ptr [ebp - local_4]           # 004e96f9
    mov eax, dword ptr [ebp - local_4]           # 004e96fc
    mov edx, dword ptr [edx + field_8232]        # 004e96ff
    cmp edx, dword ptr [eax + ecx + field_7016]  # 004e9705
    jne.d8 L_004e9730                            # 004e970c
    # block 0x004e970e: entered by fall-through of jne at 0x004e970c, 8 instruction(s), calls FUN_004e29b7, ends with forward jump to 0x004e9750
    push 0x1                                     # 004e970e
    mov eax, dword ptr [ebp - local_4]           # 004e9710
    mov ecx, dword ptr [eax + field_822e]        # 004e9713
    imul ecx, ecx, 0x18f                         # 004e9719
    mov edx, dword ptr [ebp - local_4]           # 004e971f
    lea ecx, [edx + ecx + field_7654]            # 004e9722
    call FUN_004e29b7                            # 004e9729
    jmp.d8 L_004e9750                            # 004e972e
L_004e9730:
    # block 0x004e9730: entered by jne at 0x004e970c, 7 instruction(s), calls FUN_004e29b7, falls into the block at 0x004e9750
    push 0x0                                     # 004e9730
    mov eax, dword ptr [ebp - local_4]           # 004e9732
    mov ecx, dword ptr [eax + field_822e]        # 004e9735
    imul ecx, ecx, 0x18f                         # 004e973b
    mov edx, dword ptr [ebp - local_4]           # 004e9741
    lea ecx, [edx + ecx + field_7654]            # 004e9744
    call FUN_004e29b7                            # 004e974b
L_004e9750:
    # block 0x004e9750: entered by je at 0x004e96e8; jmp at 0x004e972e, 1 instruction(s), ends with backward jump to 0x004e96a9
    jmp.d32 L_004e96a9                           # 004e9750
L_004e9755:
    # block 0x004e9755: entered by jge at 0x004e96c8, 7 instruction(s), calls FUN_004ee673, falls into the block at 0x004e9771
    mov eax, dword ptr [ebp - local_4]           # 004e9755
    mov ecx, dword ptr [ebp - local_4]           # 004e9758
    mov edx, dword ptr [ecx + field_8232]        # 004e975b
    mov dword ptr [eax + field_8236], edx        # 004e9761
    push 0x0                                     # 004e9767
    mov ecx, dword ptr [ebp - local_4]           # 004e9769
    call FUN_004ee673                            # 004e976c
L_004e9771:
    # block 0x004e9771: entered by je at 0x004e9694, 5 instruction(s), calls FUN_004ee6c7, ends with jne to 0x004e9789 (forward)
    push 0x1                                     # 004e9771
    mov ecx, dword ptr [ebp - local_4]           # 004e9773
    call FUN_004ee6c7                            # 004e9776
    test eax, eax                                # 004e977b
    jne.d8 L_004e9789                            # 004e977d
    # block 0x004e977f: entered by fall-through of jne at 0x004e977d, 3 instruction(s), calls FUN_004e7d04, ends with forward jump to 0x004e9791
    mov ecx, dword ptr [ebp - local_4]           # 004e977f
    call FUN_004e7d04                            # 004e9782
    jmp.d8 L_004e9791                            # 004e9787
L_004e9789:
    # block 0x004e9789: entered by jne at 0x004e977d, 2 instruction(s), calls FUN_004e812f, falls into the block at 0x004e9791
    mov ecx, dword ptr [ebp - local_4]           # 004e9789
    call FUN_004e812f                            # 004e978c
L_004e9791:
    # block 0x004e9791: entered by ja at 0x004e94da; jmp at 0x004e9522; jmp at 0x004e958c; jmp at 0x004e959e; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e9791
    pop ebp                                      # 004e9793
    ret                                          # 004e9794

# --- data items (not part of the function) -------------------------
.org 0x004e9795 - 0x401000
SWTAB_004e9795:  # 6 case address(es)
    .long L_004e94ea - .text + 0x401000
    .long L_004e9791 - .text + 0x401000
    .long L_004e95cb - .text + 0x401000
    .long L_004e95cb - .text + 0x401000
    .long L_004e9527 - .text + 0x401000
    .long L_004e95a3 - .text + 0x401000
.set SWTAB_004e9795_VA, SWTAB_004e9795 - .text + 0x401000

