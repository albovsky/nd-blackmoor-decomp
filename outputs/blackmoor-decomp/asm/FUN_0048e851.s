# FUN_0048e851
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e851
# extent:       0x0048e851-0x0048e93e (237 code bytes)
# span:         0x0048e851-0x0048e93e (code 237, tables 0, padding 0)
# sha256:       6cfc40b56e91d0ad63aea3f570a56afdb5b27386d4738b0276607df56b0864d1
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48e851_click_27b8_27b9
# naming:       native port src/original_methods_fl23b.c:m48e851_click_27b8_27b9 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m48e851_click_27b8_27b9 (guards, record-state compare, selector arms, callees via host). Direct: matrix and arms. Unicorn differential and oracle: 224 fixtures, every instruction reached. See tasks/fl23b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_200, field_3fe, field_431, field_451, field_452, field_462; [ecx + n] field_4, field_8, field_c, field_10, field_1e, field_200, field_452, field_45a; [edx + n] field_3fe
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23b.c:m48e851_click_27b8_27b9 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 61 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_200, 0x200  # offset +0x200
.equ field_3fe, 0x3fe  # offset +0x3fe
.equ field_431, 0x431  # offset +0x431
.equ field_451, 0x451  # offset +0x451
.equ field_452, 0x452  # offset +0x452
.equ field_45a, 0x45a  # offset +0x45a
.equ field_462, 0x462  # offset +0x462

# --- external targets -----------------------------------------------

.org 0x0048e851 - 0x401000
.globl FUN_0048e851
FUN_0048e851:
    # block 0x0048e851: entry, 8 instruction(s), ends with je to 0x0048e939 (forward)
    push ebp                                     # 0048e851
    {load} mov ebp, esp                          # 0048e852
    push ecx                                     # 0048e854
    push edi                                     # 0048e855
    mov dword ptr [ebp - local_4], ecx           # 0048e856
    mov eax, dword ptr [ebp - local_4]           # 0048e859
    cmp dword ptr [eax + field_462], 0x0         # 0048e85c
    je.d32 L_0048e939                            # 0048e863
    # block 0x0048e869: entered by fall-through of je at 0x0048e863, 5 instruction(s), ends with jne to 0x0048e939 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048e869
    {load} xor edx, edx                          # 0048e86c
    mov dl, byte ptr [ecx + field_45a]           # 0048e86e
    test edx, edx                                # 0048e874
    jne.d32 L_0048e939                           # 0048e876
    # block 0x0048e87c: entered by fall-through of jne at 0x0048e876, 3 instruction(s), ends with jne to 0x0048e939 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048e87c
    cmp dword ptr [eax + field_452], 0x0         # 0048e87f
    jne.d32 L_0048e939                           # 0048e886
    # block 0x0048e88c: entered by fall-through of jne at 0x0048e886, 5 instruction(s), ends with jne to 0x0048e939 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048e88c
    movsx edx, word ptr [ecx + field_1e]         # 0048e88f
    imul edx, edx, 0x8d                          # 0048e893
    cmp dword ptr [edx + 0x5bb632], 0x1          # 0048e899
    jne.d32 L_0048e939                           # 0048e8a0
    # block 0x0048e8a6: entered by fall-through of jne at 0x0048e8a0, 2 instruction(s), ends with jne to 0x0048e8cb (forward)
    cmp dword ptr [0x5c39e5], 0x27b9             # 0048e8a6
    jne.d8 L_0048e8cb                            # 0048e8b0
    # block 0x0048e8b2: entered by fall-through of jne at 0x0048e8b0, 5 instruction(s), ends with forward jump to 0x0048e939
    mov eax, dword ptr [ebp - local_4]           # 0048e8b2
    mov byte ptr [eax + field_451], 0x1          # 0048e8b5
    mov ecx, dword ptr [ebp - local_4]           # 0048e8bc
    mov dword ptr [ecx + field_452], 0x8         # 0048e8bf
    jmp.d8 L_0048e939                            # 0048e8c9
L_0048e8cb:
    # block 0x0048e8cb: entered by jne at 0x0048e8b0, 2 instruction(s), ends with jne to 0x0048e939 (forward)
    cmp dword ptr [0x5c39e5], 0x27b8             # 0048e8cb
    jne.d8 L_0048e939                            # 0048e8d5
    # block 0x0048e8d7: entered by fall-through of jne at 0x0048e8d5, 12 instruction(s), ends with je to 0x0048e925 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048e8d7
    movsx eax, word ptr [edx + field_3fe]        # 0048e8da
    imul eax, eax, 0x11                          # 0048e8e1
    mov ecx, dword ptr [ebp - local_4]           # 0048e8e4
    lea edi, [ecx + eax + field_200]             # 0048e8e7
    or ecx, -0x1                                 # 0048e8ee
    {load} xor eax, eax                          # 0048e8f1
    repne scasb al, byte ptr es:[edi]            # 0048e8f3
    not ecx                                      # 0048e8f5
    add ecx, -0x1                                # 0048e8f7
    test ecx, ecx                                # 0048e8fa
    je.d8 L_0048e925                             # 0048e8fc
    # block 0x0048e8fe: entered by fall-through of je at 0x0048e8fc, 11 instruction(s), falls into the block at 0x0048e925
    {load} xor edx, edx                          # 0048e8fe
    mov eax, dword ptr [ebp - local_4]           # 0048e900
    movsx ecx, word ptr [eax + field_3fe]        # 0048e903
    imul ecx, ecx, 0x11                          # 0048e90a
    mov eax, dword ptr [ebp - local_4]           # 0048e90d
    lea ecx, [eax + ecx + field_200]             # 0048e910
    mov dword ptr [ecx], edx                     # 0048e917
    mov dword ptr [ecx + field_4], edx           # 0048e919
    mov dword ptr [ecx + field_8], edx           # 0048e91c
    mov dword ptr [ecx + field_c], edx           # 0048e91f
    mov byte ptr [ecx + field_10], dl            # 0048e922
L_0048e925:
    # block 0x0048e925: entered by je at 0x0048e8fc, 4 instruction(s), falls into the block at 0x0048e939
    mov edx, dword ptr [ebp - local_4]           # 0048e925
    mov eax, dword ptr [ebp - local_4]           # 0048e928
    mov cx, word ptr [eax + field_431]           # 0048e92b
    mov word ptr [edx + field_3fe], cx           # 0048e932
L_0048e939:
    # block 0x0048e939: entered by je at 0x0048e863; jne at 0x0048e876; jne at 0x0048e886; jne at 0x0048e8a0; more, 4 instruction(s), ends with ret
    pop edi                                      # 0048e939
    {load} mov esp, ebp                          # 0048e93a
    pop ebp                                      # 0048e93c
    ret                                          # 0048e93d

