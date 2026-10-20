# FUN_004ee572
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee572
# extent:       0x004ee572-0x004ee598 (38 code bytes)
# span:         0x004ee572-0x004ee598 (code 38, tables 0, padding 0)
# sha256:       64850f32d69adc3de400654e028ca9e6d7ba2fd780bd93ef609ddad5504a80c2
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ee572
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004ee572 - 0x401000
.globl FUN_004ee572
FUN_004ee572:
    # block 0x004ee572: entry, 6 instruction(s), ends with je to 0x004ee58f (forward)
    push ebp                                     # 004ee572
    {load} mov ebp, esp                          # 004ee573
    push ecx                                     # 004ee575
    mov dword ptr [ebp - local_4], ecx           # 004ee576
    cmp dword ptr [0x55cd94], 0x0                # 004ee579
    je.d8 L_004ee58f                             # 004ee580
    # block 0x004ee582: entered by fall-through of je at 0x004ee580, 2 instruction(s), ends with jne to 0x004ee58f (forward)
    cmp dword ptr [0x63aa10], 0x0                # 004ee582
    jne.d8 L_004ee58f                            # 004ee589
    # block 0x004ee58b: entered by fall-through of jne at 0x004ee589, 2 instruction(s), ends with forward jump to 0x004ee594
    {load} xor eax, eax                          # 004ee58b
    jmp.d8 L_004ee594                            # 004ee58d
L_004ee58f:
    # block 0x004ee58f: entered by je at 0x004ee580; jne at 0x004ee589, 1 instruction(s), falls into the block at 0x004ee594
    mov eax, 0x1                                 # 004ee58f
L_004ee594:
    # block 0x004ee594: entered by jmp at 0x004ee58d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ee594
    pop ebp                                      # 004ee596
    ret                                          # 004ee597

