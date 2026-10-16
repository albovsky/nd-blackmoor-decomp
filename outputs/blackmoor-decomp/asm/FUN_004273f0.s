# FUN_004273f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004273f0
# extent:       0x004273f0-0x0042741e (46 code bytes)
# span:         0x004273f0-0x00427420 (code 46, tables 0, padding 2)
# sha256:       256e618b4da49b71eb0a03751d71cddd7636682a8084b17a4eacab11206e96ce
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004273f0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00427420, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00427420, .text + (0x00427420 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004273f0 - 0x401000
.globl FUN_004273f0
FUN_004273f0:
    # block 0x004273f0: entry, 10 instruction(s), calls FUN_00427420, ends with je to 0x00427415 (forward)
    push ebp                                     # 004273f0
    {load} mov ebp, esp                          # 004273f1
    push ecx                                     # 004273f3
    mov dword ptr [ebp - local_4], ecx           # 004273f4
    mov ecx, dword ptr [ebp - local_4]           # 004273f7
    call FUN_00427420                            # 004273fa
    mov eax, dword ptr [ebp + arg_8]             # 004273ff
    and eax, 0x1                                 # 00427402
    test eax, eax                                # 00427405
    je.d8 L_00427415                             # 00427407
    # block 0x00427409: entered by fall-through of je at 0x00427407, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00427415
    mov ecx, dword ptr [ebp - local_4]           # 00427409
    push ecx                                     # 0042740c
    call FUN_0051dc6c                            # 0042740d
    add esp, 0x4                                 # 00427412
L_00427415:
    # block 0x00427415: entered by je at 0x00427407, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00427415
    {load} mov esp, ebp                          # 00427418
    pop ebp                                      # 0042741a
    ret 0x4                                      # 0042741b

# --- data items (not part of the function) -------------------------
.org 0x0042741e - 0x401000
PAD_0042741e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

