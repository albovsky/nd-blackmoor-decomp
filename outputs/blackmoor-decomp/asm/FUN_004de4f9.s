# FUN_004de4f9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de4f9
# extent:       0x004de4f9-0x004de53e (69 code bytes)
# span:         0x004de4f9-0x004de53e (code 69, tables 0, padding 0)
# sha256:       37cb3ecfce129ef651e9b18e72d84277181432e473eaf29adb87d048071d8921
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de4f9
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_991
# callees:      calls FUN_004ee6c7, FUN_004de2d8, FUN_004de440
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------
.set FUN_004de2d8, .text + (0x004de2d8 - 0x401000)
.set FUN_004de440, .text + (0x004de440 - 0x401000)
.set FUN_004ee6c7, .text + (0x004ee6c7 - 0x401000)

.org 0x004de4f9 - 0x401000
.globl FUN_004de4f9
FUN_004de4f9:
    # block 0x004de4f9: entry, 9 instruction(s), ends with jl to 0x004de53a (forward)
    push ebp                                     # 004de4f9
    {load} mov ebp, esp                          # 004de4fa
    sub esp, 0x8                                 # 004de4fc
    mov dword ptr [ebp - local_4], ecx           # 004de4ff
    mov eax, dword ptr [ebp - local_4]           # 004de502
    mov ecx, dword ptr [eax + field_991]         # 004de505
    mov dword ptr [ebp - local_8], ecx           # 004de50b
    cmp dword ptr [ebp - local_8], 0x2           # 004de50e
    jl.d8 L_004de53a                             # 004de512
    # block 0x004de514: entered by fall-through of jl at 0x004de512, 2 instruction(s), ends with jle to 0x004de51c (forward)
    cmp dword ptr [ebp - local_8], 0x3           # 004de514
    jle.d8 L_004de51c                            # 004de518
    # block 0x004de51a: entered by fall-through of jle at 0x004de518, 1 instruction(s), ends with forward jump to 0x004de53a
    jmp.d8 L_004de53a                            # 004de51a
L_004de51c:
    # block 0x004de51c: entered by jle at 0x004de518, 5 instruction(s), calls FUN_004ee6c7, ends with jne to 0x004de532 (forward)
    push 0x0                                     # 004de51c
    mov ecx, dword ptr [ebp - local_4]           # 004de51e
    call FUN_004ee6c7                            # 004de521
    test eax, eax                                # 004de526
    jne.d8 L_004de532                            # 004de528
    # block 0x004de52a: entered by fall-through of jne at 0x004de528, 2 instruction(s), calls FUN_004de2d8, falls into the block at 0x004de532
    mov ecx, dword ptr [ebp - local_4]           # 004de52a
    call FUN_004de2d8                            # 004de52d
L_004de532:
    # block 0x004de532: entered by jne at 0x004de528, 2 instruction(s), calls FUN_004de440, falls into the block at 0x004de53a
    mov ecx, dword ptr [ebp - local_4]           # 004de532
    call FUN_004de440                            # 004de535
L_004de53a:
    # block 0x004de53a: entered by jl at 0x004de512; jmp at 0x004de51a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004de53a
    pop ebp                                      # 004de53c
    ret                                          # 004de53d

