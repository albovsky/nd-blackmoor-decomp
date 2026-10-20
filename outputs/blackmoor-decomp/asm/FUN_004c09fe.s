# FUN_004c09fe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c09fe
# extent:       0x004c09fe-0x004c0ab1 (179 code bytes)
# span:         0x004c09fe-0x004c0ab1 (code 179, tables 0, padding 0)
# sha256:       91d91ddad45a55e3b991ebc1058e7fee6602afe8378b05f286b942bedf3af841
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         movie_step_index
# naming:       native port src/avf_player.c:movie_step_index (port_acceptances, ledger class native_tests_only, reviewed 2026-10-16); the note is the acceptance note, a statement about the native port
# name-note:    Direction 1 steps up and clamps at last; otherwise steps down and clamps at first. The new test covers both clamps with first 0 and last 3. No oracle executes it whole.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2d, field_1ca, field_22a; [ecx + n] field_29, field_2b, field_2d, field_1ca, field_22a; [edx + n] field_2b, field_1ca, field_22a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:movie_step_index (function ledger class native_tests_only; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 47 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_1ca, 0x1ca  # offset +0x1ca
.equ field_22a, 0x22a  # offset +0x22a

# --- external targets -----------------------------------------------

.org 0x004c09fe - 0x401000
.globl FUN_004c09fe
FUN_004c09fe:
    # block 0x004c09fe: entry, 9 instruction(s), ends with jne to 0x004c0a63 (forward)
    push ebp                                     # 004c09fe
    {load} mov ebp, esp                          # 004c09ff
    push ecx                                     # 004c0a01
    mov dword ptr [ebp - local_4], ecx           # 004c0a02
    mov eax, dword ptr [ebp - local_4]           # 004c0a05
    mov ecx, dword ptr [eax + field_22a]         # 004c0a08
    movsx edx, word ptr [ecx + field_29]         # 004c0a0e
    cmp edx, 0x1                                 # 004c0a12
    jne.d8 L_004c0a63                            # 004c0a15
    # block 0x004c0a17: entered by fall-through of jne at 0x004c0a15, 12 instruction(s), ends with jle to 0x004c0a61 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c0a17
    mov cx, word ptr [eax + field_1ca]           # 004c0a1a
    add cx, 0x1                                  # 004c0a21
    mov edx, dword ptr [ebp - local_4]           # 004c0a25
    mov word ptr [edx + field_1ca], cx           # 004c0a28
    mov eax, dword ptr [ebp - local_4]           # 004c0a2f
    movsx ecx, word ptr [eax + field_1ca]        # 004c0a32
    mov edx, dword ptr [ebp - local_4]           # 004c0a39
    mov eax, dword ptr [edx + field_22a]         # 004c0a3c
    movsx edx, word ptr [eax + field_2d]         # 004c0a42
    {load} cmp ecx, edx                          # 004c0a46
    jle.d8 L_004c0a61                            # 004c0a48
    # block 0x004c0a4a: entered by fall-through of jle at 0x004c0a48, 5 instruction(s), falls into the block at 0x004c0a61
    mov eax, dword ptr [ebp - local_4]           # 004c0a4a
    mov ecx, dword ptr [eax + field_22a]         # 004c0a4d
    mov edx, dword ptr [ebp - local_4]           # 004c0a53
    mov ax, word ptr [ecx + field_2d]            # 004c0a56
    mov word ptr [edx + field_1ca], ax           # 004c0a5a
L_004c0a61:
    # block 0x004c0a61: entered by jle at 0x004c0a48, 1 instruction(s), ends with forward jump to 0x004c0aad
    jmp.d8 L_004c0aad                            # 004c0a61
L_004c0a63:
    # block 0x004c0a63: entered by jne at 0x004c0a15, 12 instruction(s), ends with jge to 0x004c0aad (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004c0a63
    mov dx, word ptr [ecx + field_1ca]           # 004c0a66
    sub dx, 0x1                                  # 004c0a6d
    mov eax, dword ptr [ebp - local_4]           # 004c0a71
    mov word ptr [eax + field_1ca], dx           # 004c0a74
    mov ecx, dword ptr [ebp - local_4]           # 004c0a7b
    movsx edx, word ptr [ecx + field_1ca]        # 004c0a7e
    mov eax, dword ptr [ebp - local_4]           # 004c0a85
    mov ecx, dword ptr [eax + field_22a]         # 004c0a88
    movsx eax, word ptr [ecx + field_2b]         # 004c0a8e
    {load} cmp edx, eax                          # 004c0a92
    jge.d8 L_004c0aad                            # 004c0a94
    # block 0x004c0a96: entered by fall-through of jge at 0x004c0a94, 5 instruction(s), falls into the block at 0x004c0aad
    mov ecx, dword ptr [ebp - local_4]           # 004c0a96
    mov edx, dword ptr [ecx + field_22a]         # 004c0a99
    mov eax, dword ptr [ebp - local_4]           # 004c0a9f
    mov cx, word ptr [edx + field_2b]            # 004c0aa2
    mov word ptr [eax + field_1ca], cx           # 004c0aa6
L_004c0aad:
    # block 0x004c0aad: entered by jmp at 0x004c0a61; jge at 0x004c0a94, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004c0aad
    pop ebp                                      # 004c0aaf
    ret                                          # 004c0ab0

