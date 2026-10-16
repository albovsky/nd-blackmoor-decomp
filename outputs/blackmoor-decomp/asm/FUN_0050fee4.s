# FUN_0050fee4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050fee4
# extent:       0x0050fee4-0x0050ff61 (125 code bytes)
# span:         0x0050fee4-0x0050ff61 (code 125, tables 0, padding 0)
# sha256:       5c1f6d33ff54902a27ecbdb12324c549f9174365e912633d0b3fcfcdb4be06c2
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050fee4
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_10, local_18
# fields:       [esi + n] field_48, field_4c
# callees:      calls KERNEL32.dll!TlsSetValue, FUN_0050e8ed, KERNEL32.dll!GetCurrentThreadId, FUN_0050ff80; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0050ff61
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_10, 0x10  # offset -0x10
.equ local_18, 0x18  # offset -0x18
.equ arg_8, 0x8  # offset +0x8
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c

# --- external targets -----------------------------------------------
.set FUN_0050e8ed, .text + (0x0050e8ed - 0x401000)
.set FUN_0050ff80, .text + (0x0050ff80 - 0x401000)

.org 0x0050fee4 - 0x401000
.globl FUN_0050fee4
FUN_0050fee4:
    # block 0x0050fee4: entry, 19 instruction(s), calls KERNEL32.dll!TlsSetValue, ends with jne to 0x0050ff26 (forward)
    push ebp                                     # 0050fee4
    {load} mov ebp, esp                          # 0050fee5
    push -0x1                                    # 0050fee7
    push 0x530290                                # 0050fee9
    push 0x511930                                # 0050feee
    mov eax, dword ptr fs:[0x0]                  # 0050fef3
    push eax                                     # 0050fef9
    mov dword ptr fs:[0x0], esp                  # 0050fefa
    sub esp, 0xc                                 # 0050ff01
    push ebx                                     # 0050ff04
    push esi                                     # 0050ff05
    push edi                                     # 0050ff06
    mov dword ptr [ebp - local_18], esp          # 0050ff07
    mov esi, dword ptr [ebp + arg_8]             # 0050ff0a
    push esi                                     # 0050ff0d
    push dword ptr [0x5681f0]                    # 0050ff0e
    call dword ptr [0x52a0d4]                    # 0050ff14
    test eax, eax                                # 0050ff1a
    jne.d8 L_0050ff26                            # 0050ff1c
    # block 0x0050ff1e: entered by fall-through of jne at 0x0050ff1c, 3 instruction(s), calls FUN_0050e8ed, falls into the block at 0x0050ff26
    push 0x10                                    # 0050ff1e
    call FUN_0050e8ed                            # 0050ff20
    pop ecx                                      # 0050ff25
L_0050ff26:
    # block 0x0050ff26: entered by jne at 0x0050ff1c, 5 instruction(s), calls KERNEL32.dll!GetCurrentThreadId, ends with je to 0x0050ff39 (forward)
    call dword ptr [0x52a2a0]                    # 0050ff26
    mov dword ptr [esi], eax                     # 0050ff2c
    mov eax, dword ptr [0x567e2c]                # 0050ff2e
    test eax, eax                                # 0050ff33
    je.d8 L_0050ff39                             # 0050ff35
    # block 0x0050ff37: entered by fall-through of je at 0x0050ff35, 1 instruction(s), calls indirect eax, falls into the block at 0x0050ff39
    call eax                                     # 0050ff37
L_0050ff39:
    # block 0x0050ff39: entered by je at 0x0050ff35, 15 instruction(s), calls indirect dword ptr [esi + 0x48], FUN_0050ff80, ends with ret 0x4
    and dword ptr [ebp - local_4], 0x0           # 0050ff39
    push dword ptr [esi + field_4c]              # 0050ff3d
    call dword ptr [esi + field_48]              # 0050ff40
    push eax                                     # 0050ff43
    call FUN_0050ff80                            # 0050ff44
    pop ecx                                      # 0050ff49
    or dword ptr [ebp - local_4], -0x1           # 0050ff4a
    {load} xor eax, eax                          # 0050ff4e
    mov ecx, dword ptr [ebp - local_10]          # 0050ff50
    mov dword ptr fs:[0x0], ecx                  # 0050ff53
    pop edi                                      # 0050ff5a
    pop esi                                      # 0050ff5b
    pop ebx                                      # 0050ff5c
    leave                                        # 0050ff5d
    ret 0x4                                      # 0050ff5e

