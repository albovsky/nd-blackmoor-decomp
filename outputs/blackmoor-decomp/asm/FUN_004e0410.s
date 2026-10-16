# FUN_004e0410
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e0410
# extent:       0x004e0410-0x004e048f (127 code bytes)
# span:         0x004e0410-0x004e048f (code 127, tables 0, padding 0)
# sha256:       0e235cefd3ebd682ad1e64a5c249a0b15c52f14c1682f354f4df080dcdb3fdee
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e0410
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cb26, FUN_004e04f3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e04f3, .text + (0x004e04f3 - 0x401000)
.set FUN_0050cb26, .text + (0x0050cb26 - 0x401000)

.org 0x004e0410 - 0x401000
.globl FUN_004e0410
FUN_004e0410:
    # block 0x004e0410: entry, 38 instruction(s), calls FUN_0050cb26, FUN_004e04f3, ends with ret
    push ebp                                     # 004e0410
    {load} mov ebp, esp                          # 004e0411
    push -0x1                                    # 004e0413
    push 0x52896b                                # 004e0415
    mov eax, dword ptr fs:[0x0]                  # 004e041a
    push eax                                     # 004e0420
    mov dword ptr fs:[0x0], esp                  # 004e0421
    push ecx                                     # 004e0428
    push edi                                     # 004e0429
    mov dword ptr [ebp - local_10], ecx          # 004e042a
    push 0x4e1c83                                # 004e042d
    push 0x4e1c50                                # 004e0432
    push 0x5                                     # 004e0437
    push 0x18f                                   # 004e0439
    mov eax, dword ptr [ebp - local_10]          # 004e043e
    add eax, 0x757                               # 004e0441
    push eax                                     # 004e0446
    call FUN_0050cb26                            # 004e0447
    mov dword ptr [ebp - local_4], 0x0           # 004e044c
    mov ecx, dword ptr [ebp - local_10]          # 004e0453
    mov dword ptr [ecx], 0x52e4e4                # 004e0456
    mov ecx, 0x1d2                               # 004e045c
    {load} xor eax, eax                          # 004e0461
    mov edi, dword ptr [ebp - local_10]          # 004e0463
    add edi, 0x4                                 # 004e0466
    rep stosd dword ptr es:[edi], eax            # 004e0469
    stosw word ptr es:[edi], ax                  # 004e046b
    stosb byte ptr es:[edi], al                  # 004e046d
    mov ecx, dword ptr [ebp - local_10]          # 004e046e
    call FUN_004e04f3                            # 004e0471
    mov dword ptr [ebp - local_4], 0xffffffff    # 004e0476
    mov eax, dword ptr [ebp - local_10]          # 004e047d
    mov ecx, dword ptr [ebp - local_c]           # 004e0480
    mov dword ptr fs:[0x0], ecx                  # 004e0483
    pop edi                                      # 004e048a
    {load} mov esp, ebp                          # 004e048b
    pop ebp                                      # 004e048d
    ret                                          # 004e048e

