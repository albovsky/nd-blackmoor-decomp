# FUN_004b45ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b45ed
# extent:       0x004b45ed-0x004b4676 (137 code bytes)
# span:         0x004b45ed-0x004b4676 (code 137, tables 0, padding 0)
# sha256:       cdcd926c8596d2ac7759765cd0e1813ebd35172a4e6a7a7ff6d6f30fbda7fc9a
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b45ed
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_728, field_76e; [ecx + n] field_77a, field_77e; [edx + n] field_728, field_750, field_772
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_728, 0x728  # offset +0x728
.equ field_750, 0x750  # offset +0x750
.equ field_76e, 0x76e  # offset +0x76e
.equ field_772, 0x772  # offset +0x772
.equ field_77a, 0x77a  # offset +0x77a
.equ field_77e, 0x77e  # offset +0x77e

# --- external targets -----------------------------------------------

.org 0x004b45ed - 0x401000
.globl FUN_004b45ed
FUN_004b45ed:
    # block 0x004b45ed: entry, 7 instruction(s), ends with je to 0x004b4672 (forward)
    push ebp                                     # 004b45ed
    {load} mov ebp, esp                          # 004b45ee
    push ecx                                     # 004b45f0
    mov dword ptr [ebp - local_4], ecx           # 004b45f1
    mov eax, dword ptr [ebp - local_4]           # 004b45f4
    cmp dword ptr [eax + field_76e], 0x0         # 004b45f7
    je.d8 L_004b4672                             # 004b45fe
    # block 0x004b4600: entered by fall-through of je at 0x004b45fe, 3 instruction(s), ends with jne to 0x004b4672 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b4600
    cmp dword ptr [ecx + field_77a], 0x0         # 004b4603
    jne.d8 L_004b4672                            # 004b460a
    # block 0x004b460c: entered by fall-through of jne at 0x004b460a, 3 instruction(s), ends with jne to 0x004b4672 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b460c
    cmp dword ptr [edx + field_772], 0x0         # 004b460f
    jne.d8 L_004b4672                            # 004b4616
    # block 0x004b4618: entered by fall-through of jne at 0x004b4616, 5 instruction(s), ends with jne to 0x004b4672 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b4618
    movsx ecx, word ptr [eax + field_728]        # 004b461b
    imul ecx, ecx, 0x8d                          # 004b4622
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 004b4628
    jne.d8 L_004b4672                            # 004b462f
    # block 0x004b4631: entered by fall-through of jne at 0x004b462f, 2 instruction(s), ends with jne to 0x004b4672 (forward)
    cmp dword ptr [0x5c39e5], 0x2739             # 004b4631
    jne.d8 L_004b4672                            # 004b463b
    # block 0x004b463d: entered by fall-through of jne at 0x004b463b, 4 instruction(s), ends with jne to 0x004b4672 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b463d
    movsx eax, word ptr [edx + field_750]        # 004b4640
    test eax, eax                                # 004b4647
    jne.d8 L_004b4672                            # 004b4649
    # block 0x004b464b: entered by fall-through of jne at 0x004b4649, 6 instruction(s), falls into the block at 0x004b4672
    mov ecx, dword ptr [ebp - local_4]           # 004b464b
    mov dword ptr [ecx + field_77e], 0x1         # 004b464e
    mov edx, dword ptr [ebp - local_4]           # 004b4658
    movsx eax, word ptr [edx + field_728]        # 004b465b
    imul eax, eax, 0x8d                          # 004b4662
    mov dword ptr [eax + 0x5bb632], 0x2          # 004b4668
L_004b4672:
    # block 0x004b4672: entered by je at 0x004b45fe; jne at 0x004b460a; jne at 0x004b4616; jne at 0x004b462f; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b4672
    pop ebp                                      # 004b4674
    ret                                          # 004b4675

