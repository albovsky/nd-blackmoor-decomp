# FUN_004574e4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004574e4
# extent:       0x004574e4-0x0045764a (358 code bytes)
# span:         0x004574e4-0x0045764a (code 358, tables 0, padding 0)
# sha256:       0225ab2aa7114245eed06245911867bb28fece8e4fef1e1e0ddf3e2bf34a83a7
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4574e4_click_27bc_27be
# naming:       native port src/original_methods_fl23b.c:m4574e4_click_27bc_27be (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4574e4_click_27bc_27be (guards, record-state compare, selector arms, callees via host). Direct: matrix and arms. Unicorn differential and oracle: 224 fixtures, every instruction reached. See tasks/fl23b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_36, field_3e, field_42, field_197; [ecx + n] field_24, field_2a, field_2c, field_3a, field_42, field_1b8; [edx + n] field_1e, field_30, field_32, field_42, field_1b8
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23b.c:m4574e4_click_27bc_27be (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 89 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_3a, 0x3a  # offset +0x3a
.equ field_3e, 0x3e  # offset +0x3e
.equ field_42, 0x42  # offset +0x42
.equ field_197, 0x197  # offset +0x197
.equ field_1b8, 0x1b8  # offset +0x1b8

# --- external targets -----------------------------------------------
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004574e4 - 0x401000
.globl FUN_004574e4
FUN_004574e4:
    # block 0x004574e4: entry, 14 instruction(s), ends with je to 0x00457644 (forward)
    push ebp                                     # 004574e4
    {load} mov ebp, esp                          # 004574e5
    sub esp, 0xc                                 # 004574e7
    push esi                                     # 004574ea
    push edi                                     # 004574eb
    mov dword ptr [ebp - local_c], ecx           # 004574ec
    mov eax, dword ptr [ebp - local_c]           # 004574ef
    movsx ecx, word ptr [eax + field_1e]         # 004574f2
    imul ecx, ecx, 0x8d                          # 004574f6
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004574fc
    mov dword ptr [ebp - local_4], edx           # 00457502
    mov eax, dword ptr [ebp - local_c]           # 00457505
    cmp dword ptr [eax + field_3e], 0x0          # 00457508
    je.d32 L_00457644                            # 0045750c
    # block 0x00457512: entered by fall-through of je at 0x0045750c, 3 instruction(s), ends with jne to 0x00457644 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00457512
    cmp dword ptr [ecx + field_24], 0x0          # 00457515
    jne.d32 L_00457644                           # 00457519
    # block 0x0045751f: entered by fall-through of jne at 0x00457519, 5 instruction(s), ends with jne to 0x00457644 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0045751f
    movsx eax, word ptr [edx + field_1e]         # 00457522
    imul eax, eax, 0x8d                          # 00457526
    cmp dword ptr [eax + 0x5bb632], 0x1          # 0045752c
    jne.d32 L_00457644                           # 00457533
    # block 0x00457539: entered by fall-through of jne at 0x00457533, 2 instruction(s), ends with jne to 0x0045756b (forward)
    cmp dword ptr [0x5c39e5], 0x27bd             # 00457539
    jne.d8 L_0045756b                            # 00457543
    # block 0x00457545: entered by fall-through of jne at 0x00457543, 7 instruction(s), ends with forward jump to 0x00457644
    mov ecx, dword ptr [ebp - local_c]           # 00457545
    mov dword ptr [ecx + field_3a], 0x1          # 00457548
    mov edx, dword ptr [ebp - local_c]           # 0045754f
    movsx eax, word ptr [edx + field_1e]         # 00457552
    imul eax, eax, 0x8d                          # 00457556
    mov dword ptr [eax + 0x5bb632], 0x2          # 0045755c
    jmp.d32 L_00457644                           # 00457566
L_0045756b:
    # block 0x0045756b: entered by jne at 0x00457543, 2 instruction(s), ends with jne to 0x0045758a (forward)
    cmp dword ptr [0x5c39e5], 0x27be             # 0045756b
    jne.d8 L_0045758a                            # 00457575
    # block 0x00457577: entered by fall-through of jne at 0x00457575, 5 instruction(s), ends with forward jump to 0x00457644
    mov ecx, dword ptr [ebp - local_c]           # 00457577
    mov edx, dword ptr [ebp - local_c]           # 0045757a
    mov ax, word ptr [edx + field_42]            # 0045757d
    mov word ptr [ecx + field_2a], ax            # 00457581
    jmp.d32 L_00457644                           # 00457585
L_0045758a:
    # block 0x0045758a: entered by jne at 0x00457575, 2 instruction(s), ends with jne to 0x00457644 (forward)
    cmp dword ptr [0x5c39e5], 0x27bc             # 0045758a
    jne.d32 L_00457644                           # 00457594
    # block 0x0045759a: entered by fall-through of jne at 0x00457594, 14 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x00457644 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0045759a
    mov dword ptr [ecx + field_2c], 0x1          # 0045759d
    mov edx, dword ptr [ebp - local_c]           # 004575a4
    mov eax, dword ptr [ebp - local_c]           # 004575a7
    mov cx, word ptr [eax + field_42]            # 004575aa
    mov word ptr [edx + field_30], cx            # 004575ae
    call dword ptr [0x52a23c]                    # 004575b2
    add eax, 0xfa                                # 004575b8
    mov edx, dword ptr [ebp - local_c]           # 004575bd
    mov dword ptr [edx + field_32], eax          # 004575c0
    mov eax, dword ptr [ebp - local_c]           # 004575c3
    mov dword ptr [eax + field_36], 0x1          # 004575c6
    cmp dword ptr [0x5bb1ca], 0x0                # 004575cd
    je.d8 L_00457644                             # 004575d4
    # block 0x004575d6: entered by fall-through of je at 0x004575d4, 10 instruction(s), ends with je to 0x00457644 (forward)
    mov edi, 0x54a3a8                            # 004575d6
    mov ecx, dword ptr [ebp - local_c]           # 004575db
    movsx edx, word ptr [ecx + field_42]         # 004575de
    imul edx, edx, 0x31                          # 004575e2
    mov eax, dword ptr [ebp - local_4]           # 004575e5
    lea esi, [eax + edx + field_197]             # 004575e8
    mov ecx, 0x9                                 # 004575ef
    {load} xor edx, edx                          # 004575f4
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004575f6
    je.d8 L_00457644                             # 004575f8
    # block 0x004575fa: entered by fall-through of je at 0x004575f8, 12 instruction(s), calls FUN_004f6334, ends with jne to 0x00457644 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004575fa
    movsx ecx, word ptr [eax + field_42]         # 004575fd
    imul ecx, ecx, 0x31                          # 00457601
    mov edx, dword ptr [ebp - local_4]           # 00457604
    movsx eax, word ptr [edx + ecx + field_1b8]  # 00457607
    mov dword ptr [ebp - local_8], eax           # 0045760f
    mov ecx, dword ptr [ebp - local_8]           # 00457612
    push ecx                                     # 00457615
    mov ecx, 0x5cf1eb                            # 00457616
    call FUN_004f6334                            # 0045761b
    test eax, eax                                # 00457620
    jne.d8 L_00457644                            # 00457622
    # block 0x00457624: entered by fall-through of jne at 0x00457622, 8 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00457644
    mov edx, dword ptr [ebp - local_c]           # 00457624
    movsx eax, word ptr [edx + field_42]         # 00457627
    imul eax, eax, 0x31                          # 0045762b
    mov ecx, dword ptr [ebp - local_4]           # 0045762e
    mov dx, word ptr [ecx + eax + field_1b8]     # 00457631
    push edx                                     # 00457639
    mov ecx, 0x5c3a67                            # 0045763a
    call FUN_004fb2e3                            # 0045763f
L_00457644:
    # block 0x00457644: entered by je at 0x0045750c; jne at 0x00457519; jne at 0x00457533; jmp at 0x00457566; more, 5 instruction(s), ends with ret
    pop edi                                      # 00457644
    pop esi                                      # 00457645
    {load} mov esp, ebp                          # 00457646
    pop ebp                                      # 00457648
    ret                                          # 00457649

