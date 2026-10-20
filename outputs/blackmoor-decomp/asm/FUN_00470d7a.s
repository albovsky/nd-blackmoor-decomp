# FUN_00470d7a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470d7a
# extent:       0x00470d7a-0x00470ddc (98 code bytes)
# span:         0x00470d7a-0x00470ddc (code 98, tables 0, padding 0)
# sha256:       9eaed6aaa52a7e1c349026679058ce6e091d03fadbe1f740f062d2c321bd367c
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_keypad_puzzle_reset
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_e0_runtime.h:247 says "0x470ddc: release the surface and the slot, then the 0x470d7a reset."
# name-note:    Reset of the keypad puzzle object, run after the cleanup releases the surface and slot.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_d28, field_d3e, field_dff; [ecx + n] field_d38, field_d3c, field_d3f; [edx + n] field_d24, field_dfe
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_d24, 0xd24  # offset +0xd24
.equ field_d28, 0xd28  # offset +0xd28
.equ field_d38, 0xd38  # offset +0xd38
.equ field_d3c, 0xd3c  # offset +0xd3c
.equ field_d3e, 0xd3e  # offset +0xd3e
.equ field_d3f, 0xd3f  # offset +0xd3f
.equ field_dfe, 0xdfe  # offset +0xdfe
.equ field_dff, 0xdff  # offset +0xdff

# --- external targets -----------------------------------------------

.org 0x00470d7a - 0x401000
.globl FUN_00470d7a
FUN_00470d7a:
    # block 0x00470d7a: entry, 23 instruction(s), ends with ret
    push ebp                                     # 00470d7a
    {load} mov ebp, esp                          # 00470d7b
    push ecx                                     # 00470d7d
    mov dword ptr [ebp - local_4], ecx           # 00470d7e
    mov eax, dword ptr [ebp - local_4]           # 00470d81
    mov word ptr [eax + field_d28], 0xffff       # 00470d84
    mov ecx, dword ptr [ebp - local_4]           # 00470d8d
    mov word ptr [ecx + field_d38], 0xffff       # 00470d90
    mov edx, dword ptr [ebp - local_4]           # 00470d99
    mov dword ptr [edx + field_d24], 0x0         # 00470d9c
    mov eax, dword ptr [ebp - local_4]           # 00470da6
    mov byte ptr [eax + field_d3e], 0x0          # 00470da9
    mov ecx, dword ptr [ebp - local_4]           # 00470db0
    mov byte ptr [ecx + field_d3f], 0x0          # 00470db3
    mov edx, dword ptr [ebp - local_4]           # 00470dba
    mov byte ptr [edx + field_dfe], 0x0          # 00470dbd
    mov eax, dword ptr [ebp - local_4]           # 00470dc4
    mov byte ptr [eax + field_dff], 0x0          # 00470dc7
    mov ecx, dword ptr [ebp - local_4]           # 00470dce
    mov byte ptr [ecx + field_d3c], 0x0          # 00470dd1
    {load} mov esp, ebp                          # 00470dd8
    pop ebp                                      # 00470dda
    ret                                          # 00470ddb

