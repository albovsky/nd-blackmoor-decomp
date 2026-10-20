# FUN_0047d4f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d4f7
# extent:       0x0047d4f7-0x0047d59b (164 code bytes)
# span:         0x0047d4f7-0x0047d59b (code 164, tables 0, padding 0)
# sha256:       295bb44405bcc175b4ed581b988a811feccc35173d60bef91f7a1d2ddad68985
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_d9_puzzle_object_reset
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_d9_runtime.c:229 says "0x47d4f7 resets the cursor, window and buffers"
# name-note:    Reset of the raw 0xd9 puzzle object: resets cursor, window and buffers.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1d, field_25, field_2d, field_3d, field_41, field_51; [ecx + n] field_23, field_31, field_45, field_49, field_57; [edx + n] field_27, field_29, field_35, field_39, field_4d
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d9_runtime.c:d9_cleanup (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 39 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1d, 0x1d  # offset +0x1d
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_51, 0x51  # offset +0x51
.equ field_57, 0x57  # offset +0x57

# --- external targets -----------------------------------------------

.org 0x0047d4f7 - 0x401000
.globl FUN_0047d4f7
FUN_0047d4f7:
    # block 0x0047d4f7: entry, 39 instruction(s), ends with ret
    push ebp                                     # 0047d4f7
    {load} mov ebp, esp                          # 0047d4f8
    push ecx                                     # 0047d4fa
    mov dword ptr [ebp - local_4], ecx           # 0047d4fb
    mov eax, dword ptr [ebp - local_4]           # 0047d4fe
    mov word ptr [eax + field_1d], 0xffff        # 0047d501
    mov ecx, dword ptr [ebp - local_4]           # 0047d507
    mov word ptr [ecx + field_23], 0xffff        # 0047d50a
    mov edx, dword ptr [ebp - local_4]           # 0047d510
    mov word ptr [edx + field_27], 0xfe0c        # 0047d513
    mov eax, dword ptr [ebp - local_4]           # 0047d519
    mov word ptr [eax + field_25], 0xfe0c        # 0047d51c
    mov ecx, dword ptr [ebp - local_4]           # 0047d522
    mov byte ptr [ecx + field_57], 0x0           # 0047d525
    mov edx, dword ptr [ebp - local_4]           # 0047d529
    mov dword ptr [edx + field_29], 0x0          # 0047d52c
    mov eax, dword ptr [ebp - local_4]           # 0047d533
    mov dword ptr [eax + field_41], 0x0          # 0047d536
    mov ecx, dword ptr [ebp - local_4]           # 0047d53d
    mov dword ptr [ecx + field_31], 0x0          # 0047d540
    mov edx, dword ptr [ebp - local_4]           # 0047d547
    mov dword ptr [edx + field_39], 0x0          # 0047d54a
    mov eax, dword ptr [ebp - local_4]           # 0047d551
    mov dword ptr [eax + field_2d], 0x0          # 0047d554
    mov ecx, dword ptr [ebp - local_4]           # 0047d55b
    mov dword ptr [ecx + field_45], 0x0          # 0047d55e
    mov edx, dword ptr [ebp - local_4]           # 0047d565
    mov dword ptr [edx + field_35], 0x0          # 0047d568
    mov eax, dword ptr [ebp - local_4]           # 0047d56f
    mov dword ptr [eax + field_3d], 0x0          # 0047d572
    mov ecx, dword ptr [ebp - local_4]           # 0047d579
    mov dword ptr [ecx + field_49], 0x0          # 0047d57c
    mov edx, dword ptr [ebp - local_4]           # 0047d583
    mov dword ptr [edx + field_4d], 0x0          # 0047d586
    mov eax, dword ptr [ebp - local_4]           # 0047d58d
    mov dword ptr [eax + field_51], 0x0          # 0047d590
    {load} mov esp, ebp                          # 0047d597
    pop ebp                                      # 0047d599
    ret                                          # 0047d59a

