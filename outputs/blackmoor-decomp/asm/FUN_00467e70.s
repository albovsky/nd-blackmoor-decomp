# FUN_00467e70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00467e70
# extent:       0x00467e70-0x00467eb0 (64 code bytes)
# span:         0x00467e70-0x00467eb0 (code 64, tables 0, padding 0)
# sha256:       8ef27037c2287a4aab9400af4688f763bb64f542532c6ae8ce25158b28e44745
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00467e70
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_25c, field_352; [ecx + n] field_240; [edx + n] field_1aa
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_240, 0x240  # offset +0x240
.equ field_25c, 0x25c  # offset +0x25c
.equ field_352, 0x352  # offset +0x352

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00467e70 - 0x401000
.globl FUN_00467e70
FUN_00467e70:
    # block 0x00467e70: entry, 7 instruction(s), ends with jne to 0x00467e85 (forward)
    push ebp                                     # 00467e70
    {load} mov ebp, esp                          # 00467e71
    push ecx                                     # 00467e73
    mov dword ptr [ebp - local_4], ecx           # 00467e74
    mov eax, dword ptr [ebp - local_4]           # 00467e77
    cmp dword ptr [eax + field_25c], 0x0         # 00467e7a
    jne.d8 L_00467e85                            # 00467e81
    # block 0x00467e83: entered by fall-through of jne at 0x00467e81, 1 instruction(s), ends with forward jump to 0x00467eac
    jmp.d8 L_00467eac                            # 00467e83
L_00467e85:
    # block 0x00467e85: entered by jne at 0x00467e81, 3 instruction(s), ends with jne to 0x00467eac (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00467e85
    cmp dword ptr [ecx + field_240], 0x10        # 00467e88
    jne.d8 L_00467eac                            # 00467e8f
    # block 0x00467e91: entered by fall-through of jne at 0x00467e8f, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00467eac
    mov edx, dword ptr [ebp - local_4]           # 00467e91
    mov eax, dword ptr [edx + field_1aa]         # 00467e94
    mov cx, word ptr [eax + field_352]           # 00467e9a
    push ecx                                     # 00467ea1
    mov ecx, 0x5c3a67                            # 00467ea2
    call FUN_004fb2e3                            # 00467ea7
L_00467eac:
    # block 0x00467eac: entered by jmp at 0x00467e83; jne at 0x00467e8f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00467eac
    pop ebp                                      # 00467eae
    ret                                          # 00467eaf

