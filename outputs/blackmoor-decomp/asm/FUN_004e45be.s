# FUN_004e45be
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e45be
# extent:       0x004e45be-0x004e467f (193 code bytes)
# span:         0x004e45be-0x004e467f (code 193, tables 0, padding 0)
# sha256:       666ee5d2803bd9d84b7e290d5cb2dc1824a702df473f216f71894b640fbc8ab8
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_phone_contact_row_lookup
# naming:       INFERRED (lower confidence, not verified): the repository text s0-interaction-recovery.md:22 says "calls 0x4e45be with body+2 and length 11. Lookup compares exactly those 11 bytes to row offset +2."
# name-note:    Looks up a contact row by comparing 11 bytes against row offset +2 in the global contact table.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 59 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------

.org 0x004e45be - 0x401000
.globl FUN_004e45be
FUN_004e45be:
    # block 0x004e45be: entry, 8 instruction(s), ends with jne to 0x004e45d7 (forward)
    push ebp                                     # 004e45be
    {load} mov ebp, esp                          # 004e45bf
    sub esp, 0x10                                # 004e45c1
    push ebx                                     # 004e45c4
    mov dword ptr [ebp - local_10], ecx          # 004e45c5
    movsx eax, word ptr [ebp + arg_14]           # 004e45c8
    test eax, eax                                # 004e45cc
    jne.d8 L_004e45d7                            # 004e45ce
    # block 0x004e45d0: entered by fall-through of jne at 0x004e45ce, 2 instruction(s), ends with forward jump to 0x004e4678
    {load} xor eax, eax                          # 004e45d0
    jmp.d32 L_004e4678                           # 004e45d2
L_004e45d7:
    # block 0x004e45d7: entered by jne at 0x004e45ce, 4 instruction(s), ends with forward jump to 0x004e45f3
    mov ecx, dword ptr [ebp + arg_8]             # 004e45d7
    mov word ptr [ecx], 0x0                      # 004e45da
    mov word ptr [ebp - local_8], 0x0            # 004e45df
    jmp.d8 L_004e45f3                            # 004e45e5
L_004e45e7:
    # block 0x004e45e7: entered by jmp at 0x004e466a, 3 instruction(s), falls into the block at 0x004e45f3
    mov dx, word ptr [ebp - local_8]             # 004e45e7
    add dx, 0x1                                  # 004e45eb
    mov word ptr [ebp - local_8], dx             # 004e45ef
L_004e45f3:
    # block 0x004e45f3: entered by jmp at 0x004e45e5, 4 instruction(s), ends with jge to 0x004e466f (forward)
    movsx eax, word ptr [ebp - local_8]          # 004e45f3
    movsx ecx, word ptr [0x5a1e5c]               # 004e45f7
    {load} cmp eax, ecx                          # 004e45fe
    jge.d8 L_004e466f                            # 004e4600
    # block 0x004e4602: entered by fall-through of jge at 0x004e4600, 3 instruction(s), ends with forward jump to 0x004e461d
    mov dword ptr [ebp - local_c], 0x0           # 004e4602
    mov word ptr [ebp - local_4], 0x0            # 004e4609
    jmp.d8 L_004e461d                            # 004e460f
L_004e4611:
    # block 0x004e4611: entered by jmp at 0x004e4656, 3 instruction(s), falls into the block at 0x004e461d
    mov dx, word ptr [ebp - local_4]             # 004e4611
    add dx, 0x1                                  # 004e4615
    mov word ptr [ebp - local_4], dx             # 004e4619
L_004e461d:
    # block 0x004e461d: entered by jmp at 0x004e460f, 4 instruction(s), ends with jge to 0x004e4658 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004e461d
    movsx ecx, word ptr [ebp + arg_14]           # 004e4621
    {load} cmp eax, ecx                          # 004e4625
    jge.d8 L_004e4658                            # 004e4627
    # block 0x004e4629: entered by fall-through of jge at 0x004e4627, 11 instruction(s), ends with je to 0x004e4656 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004e4629
    imul edx, edx, 0x29                          # 004e462d
    movsx eax, word ptr [ebp - local_4]          # 004e4630
    {load} xor ecx, ecx                          # 004e4634
    mov cl, byte ptr [edx + eax + 0x5a1e64]      # 004e4636
    movsx edx, word ptr [ebp - local_4]          # 004e463d
    mov eax, dword ptr [ebp + arg_c]             # 004e4641
    {load} xor ebx, ebx                          # 004e4644
    mov bl, byte ptr [eax + edx]                 # 004e4646
    {load} cmp ecx, ebx                          # 004e4649
    je.d8 L_004e4656                             # 004e464b
    # block 0x004e464d: entered by fall-through of je at 0x004e464b, 2 instruction(s), ends with forward jump to 0x004e4658
    mov dword ptr [ebp - local_c], 0x1           # 004e464d
    jmp.d8 L_004e4658                            # 004e4654
L_004e4656:
    # block 0x004e4656: entered by je at 0x004e464b, 1 instruction(s), ends with backward jump to 0x004e4611
    jmp.d8 L_004e4611                            # 004e4656
L_004e4658:
    # block 0x004e4658: entered by jge at 0x004e4627; jmp at 0x004e4654, 2 instruction(s), ends with jne to 0x004e466a (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004e4658
    jne.d8 L_004e466a                            # 004e465c
    # block 0x004e465e: entered by fall-through of jne at 0x004e465c, 4 instruction(s), ends with forward jump to 0x004e466f
    mov ecx, dword ptr [ebp + arg_8]             # 004e465e
    mov dx, word ptr [ebp - local_8]             # 004e4661
    mov word ptr [ecx], dx                       # 004e4665
    jmp.d8 L_004e466f                            # 004e4668
L_004e466a:
    # block 0x004e466a: entered by jne at 0x004e465c, 1 instruction(s), ends with backward jump to 0x004e45e7
    jmp.d32 L_004e45e7                           # 004e466a
L_004e466f:
    # block 0x004e466f: entered by jge at 0x004e4600; jmp at 0x004e4668, 3 instruction(s), falls into the block at 0x004e4678
    {load} xor eax, eax                          # 004e466f
    cmp dword ptr [ebp - local_c], 0x0           # 004e4671
    sete al                                      # 004e4675
L_004e4678:
    # block 0x004e4678: entered by jmp at 0x004e45d2, 4 instruction(s), ends with ret 0x10
    pop ebx                                      # 004e4678
    {load} mov esp, ebp                          # 004e4679
    pop ebp                                      # 004e467b
    ret 0x10                                     # 004e467c

