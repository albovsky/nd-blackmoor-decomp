# FUN_00467651
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00467651
# extent:       0x00467651-0x00467688 (55 code bytes)
# span:         0x00467651-0x00467688 (code 55, tables 0, padding 0)
# sha256:       d35414fda861901099d9e8d556d03bf91479b5b389b3f35a59348f2315b95115
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00467651
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_10, field_1ae; [ecx + n] field_10
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_10, 0x10  # offset +0x10
.equ field_1ae, 0x1ae  # offset +0x1ae

# --- external targets -----------------------------------------------

.org 0x00467651 - 0x401000
.globl FUN_00467651
FUN_00467651:
    # block 0x00467651: entry, 7 instruction(s), ends with je to 0x00467684 (forward)
    push ebp                                     # 00467651
    {load} mov ebp, esp                          # 00467652
    push ecx                                     # 00467654
    mov dword ptr [ebp - local_4], ecx           # 00467655
    mov eax, dword ptr [ebp - local_4]           # 00467658
    cmp dword ptr [eax + field_1ae], 0x0         # 0046765b
    je.d8 L_00467684                             # 00467662
    # block 0x00467664: entered by fall-through of je at 0x00467662, 4 instruction(s), ends with je to 0x00467684 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00467664
    movsx edx, word ptr [ecx + field_10]         # 00467667
    cmp edx, -0x1                                # 0046766b
    je.d8 L_00467684                             # 0046766e
    # block 0x00467670: entered by fall-through of je at 0x0046766e, 4 instruction(s), falls into the block at 0x00467684
    mov eax, dword ptr [ebp - local_4]           # 00467670
    movsx ecx, word ptr [eax + field_10]         # 00467673
    imul ecx, ecx, 0x4a                          # 00467677
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0046767a
L_00467684:
    # block 0x00467684: entered by je at 0x00467662; je at 0x0046766e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00467684
    pop ebp                                      # 00467686
    ret                                          # 00467687

