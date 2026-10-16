# FUN_004ccd40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccd40
# extent:       0x004ccd40-0x004ccd6e (46 code bytes)
# span:         0x004ccd40-0x004ccd70 (code 46, tables 0, padding 2)
# sha256:       86d0fb4e4c79ef26b365741faa9d950c2671a96b5e437f57080e7a61510ad253
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ccd40
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004cc946, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004cc946, .text + (0x004cc946 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004ccd40 - 0x401000
.globl FUN_004ccd40
FUN_004ccd40:
    # block 0x004ccd40: entry, 10 instruction(s), calls FUN_004cc946, ends with je to 0x004ccd65 (forward)
    push ebp                                     # 004ccd40
    {load} mov ebp, esp                          # 004ccd41
    push ecx                                     # 004ccd43
    mov dword ptr [ebp - local_4], ecx           # 004ccd44
    mov ecx, dword ptr [ebp - local_4]           # 004ccd47
    call FUN_004cc946                            # 004ccd4a
    mov eax, dword ptr [ebp + arg_8]             # 004ccd4f
    and eax, 0x1                                 # 004ccd52
    test eax, eax                                # 004ccd55
    je.d8 L_004ccd65                             # 004ccd57
    # block 0x004ccd59: entered by fall-through of je at 0x004ccd57, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004ccd65
    mov ecx, dword ptr [ebp - local_4]           # 004ccd59
    push ecx                                     # 004ccd5c
    call FUN_0051dc6c                            # 004ccd5d
    add esp, 0x4                                 # 004ccd62
L_004ccd65:
    # block 0x004ccd65: entered by je at 0x004ccd57, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004ccd65
    {load} mov esp, ebp                          # 004ccd68
    pop ebp                                      # 004ccd6a
    ret 0x4                                      # 004ccd6b

# --- data items (not part of the function) -------------------------
.org 0x004ccd6e - 0x401000
PAD_004ccd6e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

