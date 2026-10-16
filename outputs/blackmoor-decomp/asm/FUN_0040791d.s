# FUN_0040791d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040791d
# extent:       0x0040791d-0x00407964 (71 code bytes)
# span:         0x0040791d-0x00407964 (code 71, tables 0, padding 0)
# sha256:       8001d9f611eb515970c4b6eff4fbd37a26ea32466f372c19498b4fb5770d1a5e
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040791d
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

.org 0x0040791d - 0x401000
.globl FUN_0040791d
FUN_0040791d:
    # block 0x0040791d: entry, 6 instruction(s), ends with jne to 0x00407939 (forward)
    push ebp                                     # 0040791d
    {load} mov ebp, esp                          # 0040791e
    push ecx                                     # 00407920
    mov dword ptr [ebp - local_4], ecx           # 00407921
    cmp dword ptr [0x5e3606], 0x1                # 00407924
    jne.d8 L_00407939                            # 0040792b
    # block 0x0040792d: entered by fall-through of jne at 0x0040792b, 2 instruction(s), ends with forward jump to 0x00407958
    mov dword ptr [0x5e3606], 0x0                # 0040792d
    jmp.d8 L_00407958                            # 00407937
L_00407939:
    # block 0x00407939: entered by jne at 0x0040792b, 4 instruction(s), ends with jne to 0x00407958 (forward)
    mov dword ptr [0x5e3606], 0x1                # 00407939
    movsx eax, word ptr [0x5e335e]               # 00407943
    cmp eax, 0x3f                                # 0040794a
    jne.d8 L_00407958                            # 0040794d
    # block 0x0040794f: entered by fall-through of jne at 0x0040794d, 1 instruction(s), falls into the block at 0x00407958
    mov word ptr [0x5e335e], 0xffff              # 0040794f
L_00407958:
    # block 0x00407958: entered by jmp at 0x00407937; jne at 0x0040794d, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407958
    call FUN_00404be1                            # 0040795b
    {load} mov esp, ebp                          # 00407960
    pop ebp                                      # 00407962
    ret                                          # 00407963

