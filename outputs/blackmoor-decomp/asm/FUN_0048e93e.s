# FUN_0048e93e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e93e
# extent:       0x0048e93e-0x0048e9bf (129 code bytes)
# span:         0x0048e93e-0x0048e9bf (code 129, tables 0, padding 0)
# sha256:       1f47fff2a43d9c0a14681327f9051c22c54092776721a12d13c4d552a5787477
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048e93e
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_452, field_462; [ecx + n] field_45a, field_45d; [edx + n] field_1e, field_461
# callees:      calls FUN_00437ea1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_452, 0x452  # offset +0x452
.equ field_45a, 0x45a  # offset +0x45a
.equ field_45d, 0x45d  # offset +0x45d
.equ field_461, 0x461  # offset +0x461
.equ field_462, 0x462  # offset +0x462

# --- external targets -----------------------------------------------
.set FUN_00437ea1, .text + (0x00437ea1 - 0x401000)

.org 0x0048e93e - 0x401000
.globl FUN_0048e93e
FUN_0048e93e:
    # block 0x0048e93e: entry, 7 instruction(s), ends with je to 0x0048e9b9 (forward)
    push ebp                                     # 0048e93e
    {load} mov ebp, esp                          # 0048e93f
    push ecx                                     # 0048e941
    mov dword ptr [ebp - local_4], ecx           # 0048e942
    mov eax, dword ptr [ebp - local_4]           # 0048e945
    cmp dword ptr [eax + field_462], 0x0         # 0048e948
    je.d8 L_0048e9b9                             # 0048e94f
    # block 0x0048e951: entered by fall-through of je at 0x0048e94f, 5 instruction(s), ends with jne to 0x0048e9b9 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048e951
    {load} xor edx, edx                          # 0048e954
    mov dl, byte ptr [ecx + field_45a]           # 0048e956
    test edx, edx                                # 0048e95c
    jne.d8 L_0048e9b9                            # 0048e95e
    # block 0x0048e960: entered by fall-through of jne at 0x0048e95e, 3 instruction(s), ends with jne to 0x0048e9b9 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048e960
    cmp dword ptr [eax + field_452], 0x0         # 0048e963
    jne.d8 L_0048e9b9                            # 0048e96a
    # block 0x0048e96c: entered by fall-through of jne at 0x0048e96a, 3 instruction(s), ends with jne to 0x0048e9b9 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048e96c
    cmp dword ptr [ecx + field_45d], 0x0         # 0048e96f
    jne.d8 L_0048e9b9                            # 0048e976
    # block 0x0048e978: entered by fall-through of jne at 0x0048e976, 5 instruction(s), ends with jne to 0x0048e9b9 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048e978
    movsx eax, word ptr [edx + field_1e]         # 0048e97b
    imul eax, eax, 0x8d                          # 0048e97f
    cmp dword ptr [eax + 0x5bb632], 0x1          # 0048e985
    jne.d8 L_0048e9b9                            # 0048e98c
    # block 0x0048e98e: entered by fall-through of jne at 0x0048e98c, 6 instruction(s), calls FUN_00437ea1, ends with je to 0x0048e9b9 (forward)
    mov cl, byte ptr [ebp + arg_8]               # 0048e98e
    push ecx                                     # 0048e991
    mov ecx, 0x583208                            # 0048e992
    call FUN_00437ea1                            # 0048e997
    test eax, eax                                # 0048e99c
    je.d8 L_0048e9b9                             # 0048e99e
    # block 0x0048e9a0: entered by fall-through of je at 0x0048e99e, 5 instruction(s), falls into the block at 0x0048e9b9
    mov edx, dword ptr [ebp - local_4]           # 0048e9a0
    mov al, byte ptr [ebp + arg_8]               # 0048e9a3
    mov byte ptr [edx + field_461], al           # 0048e9a6
    mov ecx, dword ptr [ebp - local_4]           # 0048e9ac
    mov dword ptr [ecx + field_45d], 0x1         # 0048e9af
L_0048e9b9:
    # block 0x0048e9b9: entered by je at 0x0048e94f; jne at 0x0048e95e; jne at 0x0048e96a; jne at 0x0048e976; more, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0048e9b9
    pop ebp                                      # 0048e9bb
    ret 0x4                                      # 0048e9bc

