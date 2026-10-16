# FUN_004a3947
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a3947
# extent:       0x004a3947-0x004a39c4 (125 code bytes)
# span:         0x004a3947-0x004a39c4 (code 125, tables 0, padding 0)
# sha256:       ef8cc3c465eb194cf0918b71ee18547f3f67f57d379cfcc56645b89f28df7bdb
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a3947
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------

.org 0x004a3947 - 0x401000
.globl FUN_004a3947
FUN_004a3947:
    # block 0x004a3947: entry, 7 instruction(s), ends with forward jump to 0x004a3965
    push ebp                                     # 004a3947
    {load} mov ebp, esp                          # 004a3948
    sub esp, 0x8                                 # 004a394a
    push edi                                     # 004a394d
    mov dword ptr [ebp - local_8], ecx           # 004a394e
    mov word ptr [ebp - local_4], 0x0            # 004a3951
    jmp.d8 L_004a3965                            # 004a3957
L_004a3959:
    # block 0x004a3959: entered by jmp at 0x004a39bd, 3 instruction(s), falls into the block at 0x004a3965
    mov ax, word ptr [ebp - local_4]             # 004a3959
    .insn 0x66, 0x05, 0x0001{:u16}               # 004a395d
    mov word ptr [ebp - local_4], ax             # 004a3961
L_004a3965:
    # block 0x004a3965: entered by jmp at 0x004a3957, 3 instruction(s), ends with jge to 0x004a39bf (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004a3965
    cmp ecx, 0x2                                 # 004a3969
    jge.d8 L_004a39bf                            # 004a396c
    # block 0x004a396e: entered by fall-through of jge at 0x004a396c, 19 instruction(s), ends with backward jump to 0x004a3959
    movsx edx, word ptr [ebp - local_4]          # 004a396e
    imul edx, edx, 0x7c                          # 004a3972
    mov word ptr [edx + 0x591a24], 0x0           # 004a3975
    movsx eax, word ptr [ebp - local_4]          # 004a397e
    imul eax, eax, 0x7c                          # 004a3982
    mov word ptr [eax + 0x591a26], 0x270f        # 004a3985
    mov ecx, 0xf                                 # 004a398e
    mov eax, 0xf6f6f6f6                          # 004a3993
    movsx edi, word ptr [ebp - local_4]          # 004a3998
    imul edi, edi, 0x7c                          # 004a399c
    add edi, 0x591a28                            # 004a399f
    rep stosd dword ptr es:[edi], eax            # 004a39a5
    mov ecx, 0xf                                 # 004a39a7
    {load} xor eax, eax                          # 004a39ac
    movsx edi, word ptr [ebp - local_4]          # 004a39ae
    imul edi, edi, 0x7c                          # 004a39b2
    add edi, 0x591a64                            # 004a39b5
    rep stosd dword ptr es:[edi], eax            # 004a39bb
    jmp.d8 L_004a3959                            # 004a39bd
L_004a39bf:
    # block 0x004a39bf: entered by jge at 0x004a396c, 4 instruction(s), ends with ret
    pop edi                                      # 004a39bf
    {load} mov esp, ebp                          # 004a39c0
    pop ebp                                      # 004a39c2
    ret                                          # 004a39c3

