# FUN_004cc70f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cc70f
# extent:       0x004cc70f-0x004cc79a (139 code bytes)
# span:         0x004cc70f-0x004cc79a (code 139, tables 0, padding 0)
# sha256:       f4b42b91311bbc621df2b790920c1bf9ebb32fa1d90b45d9dfe4872e6af88100
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_zero_filling_allocator
# naming:       INFERRED (lower confidence, not verified): the repository text COORDINATION-STATUS.md:576 says "over the zero-filling allocator 0x4cc70f"; src/action_family_1c.h:44 says "FUN_004cc70f(slot, 0x69) mallocs 0x69 bytes"
# name-note:    Zero-filling allocator used by the 0x1c constructor to allocate its 0x69-byte block.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/action_family_1c.c:action_family_1c_construct (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004cc70f - 0x401000
.globl FUN_004cc70f
FUN_004cc70f:
    # block 0x004cc70f: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004cc77b (forward)
    push ebp                                     # 004cc70f
    {load} mov ebp, esp                          # 004cc710
    sub esp, 0x8                                 # 004cc712
    push edi                                     # 004cc715
    mov dword ptr [ebp - local_8], ecx           # 004cc716
    mov eax, dword ptr [ebp + arg_c]             # 004cc719
    push eax                                     # 004cc71c
    call FUN_0051dc43                            # 004cc71d
    add esp, 0x4                                 # 004cc722
    mov dword ptr [ebp - local_4], eax           # 004cc725
    mov ecx, dword ptr [ebp + arg_8]             # 004cc728
    mov edx, dword ptr [ebp - local_4]           # 004cc72b
    mov dword ptr [ecx], edx                     # 004cc72e
    cmp dword ptr [ebp - local_4], 0x0           # 004cc730
    jne.d8 L_004cc77b                            # 004cc734
    # block 0x004cc736: entered by fall-through of jne at 0x004cc734, 10 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004cc76f (forward)
    push 0x559038                                # 004cc736
    push 0x63888b                                # 004cc73b
    call FUN_0050ca3e                            # 004cc740
    add esp, 0x8                                 # 004cc745
    push 0x63888b                                # 004cc748
    mov ecx, 0x583979                            # 004cc74d
    call FUN_004264e8                            # 004cc752
    movsx eax, word ptr [0x63a4cd]               # 004cc757
    test eax, eax                                # 004cc75e
    je.d8 L_004cc76f                             # 004cc760
    # block 0x004cc762: entered by fall-through of je at 0x004cc760, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cc76f
    push 0x63888b                                # 004cc762
    call FUN_0044a2b7                            # 004cc767
    add esp, 0x4                                 # 004cc76c
L_004cc76f:
    # block 0x004cc76f: entered by je at 0x004cc760, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004cc793
    mov ecx, 0x5cf659                            # 004cc76f
    call FUN_004c97b4                            # 004cc774
    jmp.d8 L_004cc793                            # 004cc779
L_004cc77b:
    # block 0x004cc77b: entered by jne at 0x004cc734, 10 instruction(s), falls into the block at 0x004cc793
    mov ecx, dword ptr [ebp + arg_c]             # 004cc77b
    {load} xor eax, eax                          # 004cc77e
    mov edx, dword ptr [ebp + arg_8]             # 004cc780
    mov edi, dword ptr [edx]                     # 004cc783
    {load} mov edx, ecx                          # 004cc785
    shr ecx, 0x2                                 # 004cc787
    rep stosd dword ptr es:[edi], eax            # 004cc78a
    {load} mov ecx, edx                          # 004cc78c
    and ecx, 0x3                                 # 004cc78e
    rep stosb byte ptr es:[edi], al              # 004cc791
L_004cc793:
    # block 0x004cc793: entered by jmp at 0x004cc779, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 004cc793
    {load} mov esp, ebp                          # 004cc794
    pop ebp                                      # 004cc796
    ret 0x8                                      # 004cc797

