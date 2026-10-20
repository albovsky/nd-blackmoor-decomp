# FUN_004e77b8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e77b8
# extent:       0x004e77b8-0x004e7843 (139 code bytes)
# span:         0x004e77b8-0x004e7843 (code 139, tables 0, padding 0)
# sha256:       15865ae087b43058082c131fe351f01d2fb4364e990ee0873fc293bb4d8eb3d8
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e77b8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_991; [ecx + n] field_991
# callees:      calls FUN_004ee2a9, FUN_004d341d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------
.set FUN_004d341d, .text + (0x004d341d - 0x401000)
.set FUN_004ee2a9, .text + (0x004ee2a9 - 0x401000)

.org 0x004e77b8 - 0x401000
.globl FUN_004e77b8
FUN_004e77b8:
    # block 0x004e77b8: entry, 7 instruction(s), ends with je to 0x004e77d7 (forward)
    push ebp                                     # 004e77b8
    {load} mov ebp, esp                          # 004e77b9
    push ecx                                     # 004e77bb
    mov dword ptr [ebp - local_4], ecx           # 004e77bc
    mov eax, dword ptr [ebp - local_4]           # 004e77bf
    cmp dword ptr [eax + field_991], 0x0         # 004e77c2
    je.d8 L_004e77d7                             # 004e77c9
    # block 0x004e77cb: entered by fall-through of je at 0x004e77c9, 3 instruction(s), ends with jne to 0x004e77d9 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e77cb
    cmp dword ptr [ecx + field_991], 0x1         # 004e77ce
    jne.d8 L_004e77d9                            # 004e77d5
L_004e77d7:
    # block 0x004e77d7: entered by je at 0x004e77c9; fall-through of jne at 0x004e77d5, 1 instruction(s), ends with forward jump to 0x004e783f
    jmp.d8 L_004e783f                            # 004e77d7
L_004e77d9:
    # block 0x004e77d9: entered by jne at 0x004e77d5, 4 instruction(s), calls FUN_004ee2a9, ends with je to 0x004e77e7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e77d9
    call FUN_004ee2a9                            # 004e77dc
    test eax, eax                                # 004e77e1
    je.d8 L_004e77e7                             # 004e77e3
    # block 0x004e77e5: entered by fall-through of je at 0x004e77e3, 1 instruction(s), ends with forward jump to 0x004e783f
    jmp.d8 L_004e783f                            # 004e77e5
L_004e77e7:
    # block 0x004e77e7: entered by je at 0x004e77e3, 2 instruction(s), ends with jne to 0x004e77f9 (forward)
    cmp dword ptr [0x5b15d6], 0x0                # 004e77e7
    jne.d8 L_004e77f9                            # 004e77ee
    # block 0x004e77f0: entered by fall-through of jne at 0x004e77ee, 2 instruction(s), ends with je to 0x004e783f (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 004e77f0
    je.d8 L_004e783f                             # 004e77f7
L_004e77f9:
    # block 0x004e77f9: entered by jne at 0x004e77ee; fall-through of je at 0x004e77f7, 3 instruction(s), ends with jl to 0x004e783f (forward)
    mov edx, dword ptr [0x58316a]                # 004e77f9
    cmp edx, dword ptr [0x5b022b]                # 004e77ff
    jl.d8 L_004e783f                             # 004e7805
    # block 0x004e7807: entered by fall-through of jl at 0x004e7805, 3 instruction(s), ends with jg to 0x004e783f (forward)
    mov eax, dword ptr [0x58316a]                # 004e7807
    cmp eax, dword ptr [0x5b0233]                # 004e780c
    jg.d8 L_004e783f                             # 004e7812
    # block 0x004e7814: entered by fall-through of jg at 0x004e7812, 3 instruction(s), ends with jl to 0x004e783f (forward)
    mov ecx, dword ptr [0x58316e]                # 004e7814
    cmp ecx, dword ptr [0x5b0227]                # 004e781a
    jl.d8 L_004e783f                             # 004e7820
    # block 0x004e7822: entered by fall-through of jl at 0x004e7820, 3 instruction(s), ends with jg to 0x004e783f (forward)
    mov edx, dword ptr [0x58316e]                # 004e7822
    cmp edx, dword ptr [0x5b022f]                # 004e7828
    jg.d8 L_004e783f                             # 004e782e
    # block 0x004e7830: entered by fall-through of jg at 0x004e782e, 2 instruction(s), calls FUN_004d341d, falls into the block at 0x004e783f
    mov dword ptr [0x5c39e5], 0x2712             # 004e7830
    call FUN_004d341d                            # 004e783a
L_004e783f:
    # block 0x004e783f: entered by jmp at 0x004e77d7; jmp at 0x004e77e5; je at 0x004e77f7; jl at 0x004e7805; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e783f
    pop ebp                                      # 004e7841
    ret                                          # 004e7842

