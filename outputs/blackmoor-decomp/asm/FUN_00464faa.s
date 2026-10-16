# FUN_00464faa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00464faa
# extent:       0x00464faa-0x00464fff (85 code bytes)
# span:         0x00464faa-0x00464fff (code 85, tables 0, padding 0)
# sha256:       60c4e228995e368b30be9aebf90339f22b2da2c4fa36ea2ae1fe95832740fe73
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00464faa
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e; [ecx + n] field_3b6
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_3b6, 0x3b6  # offset +0x3b6

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00464faa - 0x401000
.globl FUN_00464faa
FUN_00464faa:
    # block 0x00464faa: entry, 18 instruction(s), ends with je to 0x00464ff9 (forward)
    push ebp                                     # 00464faa
    {load} mov ebp, esp                          # 00464fab
    sub esp, 0x8                                 # 00464fad
    push esi                                     # 00464fb0
    push edi                                     # 00464fb1
    mov dword ptr [ebp - local_8], ecx           # 00464fb2
    mov eax, dword ptr [ebp - local_8]           # 00464fb5
    movsx ecx, word ptr [eax + field_1e]         # 00464fb8
    imul ecx, ecx, 0x8d                          # 00464fbc
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00464fc2
    mov dword ptr [ebp - local_4], edx           # 00464fc8
    mov edi, 0x54b344                            # 00464fcb
    mov esi, dword ptr [ebp - local_4]           # 00464fd0
    add esi, 0x395                               # 00464fd3
    mov ecx, 0x9                                 # 00464fd9
    {load} xor eax, eax                          # 00464fde
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00464fe0
    je.d8 L_00464ff9                             # 00464fe2
    # block 0x00464fe4: entered by fall-through of je at 0x00464fe2, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00464ff9
    mov ecx, dword ptr [ebp - local_4]           # 00464fe4
    mov dx, word ptr [ecx + field_3b6]           # 00464fe7
    push edx                                     # 00464fee
    mov ecx, 0x5c3a67                            # 00464fef
    call FUN_004fb2e3                            # 00464ff4
L_00464ff9:
    # block 0x00464ff9: entered by je at 0x00464fe2, 5 instruction(s), ends with ret
    pop edi                                      # 00464ff9
    pop esi                                      # 00464ffa
    {load} mov esp, ebp                          # 00464ffb
    pop ebp                                      # 00464ffd
    ret                                          # 00464ffe

