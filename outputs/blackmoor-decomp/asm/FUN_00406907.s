# FUN_00406907
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406907
# extent:       0x00406907-0x0040694e (71 code bytes)
# span:         0x00406907-0x0040694e (code 71, tables 0, padding 0)
# sha256:       5c15800c8c7bbef02721cfc235e77fdd87518005e4c91e998cde03045ad7965f
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00406907
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406907 - 0x401000
.globl FUN_00406907
FUN_00406907:
    # block 0x00406907: entry, 6 instruction(s), ends with jne to 0x00406923 (forward)
    push ebp                                     # 00406907
    {load} mov ebp, esp                          # 00406908
    push ecx                                     # 0040690a
    mov dword ptr [ebp - local_4], ecx           # 0040690b
    cmp dword ptr [0x5e351e], 0x1                # 0040690e
    jne.d8 L_00406923                            # 00406915
    # block 0x00406917: entered by fall-through of jne at 0x00406915, 2 instruction(s), ends with forward jump to 0x00406942
    mov dword ptr [0x5e351e], 0x0                # 00406917
    jmp.d8 L_00406942                            # 00406921
L_00406923:
    # block 0x00406923: entered by jne at 0x00406915, 4 instruction(s), ends with jne to 0x00406942 (forward)
    mov dword ptr [0x5e351e], 0x1                # 00406923
    movsx eax, word ptr [0x5e335e]               # 0040692d
    cmp eax, 0x5                                 # 00406934
    jne.d8 L_00406942                            # 00406937
    # block 0x00406939: entered by fall-through of jne at 0x00406937, 1 instruction(s), falls into the block at 0x00406942
    mov word ptr [0x5e335e], 0xffff              # 00406939
L_00406942:
    # block 0x00406942: entered by jmp at 0x00406921; jne at 0x00406937, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406942
    call FUN_00404be1                            # 00406945
    {load} mov esp, ebp                          # 0040694a
    pop ebp                                      # 0040694c
    ret                                          # 0040694d

