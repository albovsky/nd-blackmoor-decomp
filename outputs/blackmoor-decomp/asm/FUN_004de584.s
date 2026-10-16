# FUN_004de584
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de584
# extent:       0x004de584-0x004de5b1 (45 code bytes)
# span:         0x004de584-0x004de5c0 (code 45, tables 0, padding 15)
# sha256:       be84ecfc974a400d5d26e5b8e30a9a062ce2dc38f10e0a8b5c2c2eb524c37ea8
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de584
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_991; [ecx + n] field_991
# callees:      calls FUN_004ee86f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------
.set FUN_004ee86f, .text + (0x004ee86f - 0x401000)

.org 0x004de584 - 0x401000
.globl FUN_004de584
FUN_004de584:
    # block 0x004de584: entry, 7 instruction(s), ends with je to 0x004de5a3 (forward)
    push ebp                                     # 004de584
    {load} mov ebp, esp                          # 004de585
    push ecx                                     # 004de587
    mov dword ptr [ebp - local_4], ecx           # 004de588
    mov eax, dword ptr [ebp - local_4]           # 004de58b
    cmp dword ptr [eax + field_991], 0x0         # 004de58e
    je.d8 L_004de5a3                             # 004de595
    # block 0x004de597: entered by fall-through of je at 0x004de595, 3 instruction(s), ends with jne to 0x004de5a5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004de597
    cmp dword ptr [ecx + field_991], 0x1         # 004de59a
    jne.d8 L_004de5a5                            # 004de5a1
L_004de5a3:
    # block 0x004de5a3: entered by je at 0x004de595; fall-through of jne at 0x004de5a1, 1 instruction(s), ends with forward jump to 0x004de5ad
    jmp.d8 L_004de5ad                            # 004de5a3
L_004de5a5:
    # block 0x004de5a5: entered by jne at 0x004de5a1, 2 instruction(s), calls FUN_004ee86f, falls into the block at 0x004de5ad
    mov ecx, dword ptr [ebp - local_4]           # 004de5a5
    call FUN_004ee86f                            # 004de5a8
L_004de5ad:
    # block 0x004de5ad: entered by jmp at 0x004de5a3, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004de5ad
    pop ebp                                      # 004de5af
    ret                                          # 004de5b0

# --- data items (not part of the function) -------------------------
.org 0x004de5b1 - 0x401000
PAD_004de5b1:  # 15 byte(s) of int3 padding
    .fill 15, 1, 0xcc

