# FUN_004754a1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004754a1
# extent:       0x004754a1-0x004754d2 (49 code bytes)
# span:         0x004754a1-0x004754d2 (code 49, tables 0, padding 0)
# sha256:       4f33e8a413757784f37baa8af4eb4c8eb0ca61bb6939b2a3d3c86f938cf53a46
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004754a1
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_359; [ecx + n] field_76; [edx + n] field_47a
# callees:      calls FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4740e5_lifted (function ledger class candidate_port; also m4754a1_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_76, 0x76  # offset +0x76
.equ field_359, 0x359  # offset +0x359
.equ field_47a, 0x47a  # offset +0x47a

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004754a1 - 0x401000
.globl FUN_004754a1
FUN_004754a1:
    # block 0x004754a1: entry, 7 instruction(s), ends with jne to 0x004754b6 (forward)
    push ebp                                     # 004754a1
    {load} mov ebp, esp                          # 004754a2
    push ecx                                     # 004754a4
    mov dword ptr [ebp - local_4], ecx           # 004754a5
    mov eax, dword ptr [ebp - local_4]           # 004754a8
    cmp dword ptr [eax + field_359], 0x0         # 004754ab
    jne.d8 L_004754b6                            # 004754b2
    # block 0x004754b4: entered by fall-through of jne at 0x004754b2, 1 instruction(s), ends with forward jump to 0x004754ce
    jmp.d8 L_004754ce                            # 004754b4
L_004754b6:
    # block 0x004754b6: entered by jne at 0x004754b2, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004754ce
    mov ecx, dword ptr [ebp - local_4]           # 004754b6
    mov edx, dword ptr [ecx + field_76]          # 004754b9
    mov ax, word ptr [edx + field_47a]           # 004754bc
    push eax                                     # 004754c3
    mov ecx, 0x5c3a67                            # 004754c4
    call FUN_004fb2e3                            # 004754c9
L_004754ce:
    # block 0x004754ce: entered by jmp at 0x004754b4, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004754ce
    pop ebp                                      # 004754d0
    ret                                          # 004754d1

