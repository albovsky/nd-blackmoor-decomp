# FUN_004c9428
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c9428
# extent:       0x004c9428-0x004c946b (67 code bytes)
# span:         0x004c9428-0x004c946b (code 67, tables 0, padding 0)
# sha256:       e6a70edecbb924e46d52bcfd7c6c1e06b2c3a1ad0a9062e8a4049f957bd4c276
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c9428
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_c72
# callees:      calls FUN_004c2dfb
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4c9428_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_c72, 0xc72  # offset +0xc72

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)

.org 0x004c9428 - 0x401000
.globl FUN_004c9428
FUN_004c9428:
    # block 0x004c9428: entry, 6 instruction(s), ends with forward jump to 0x004c9445
    push ebp                                     # 004c9428
    {load} mov ebp, esp                          # 004c9429
    sub esp, 0x8                                 # 004c942b
    mov dword ptr [ebp - local_8], ecx           # 004c942e
    mov word ptr [ebp - local_4], 0x0            # 004c9431
    jmp.d8 L_004c9445                            # 004c9437
L_004c9439:
    # block 0x004c9439: entered by jmp at 0x004c9465, 3 instruction(s), falls into the block at 0x004c9445
    mov ax, word ptr [ebp - local_4]             # 004c9439
    .insn 0x66, 0x05, 0x0001{:u16}               # 004c943d
    mov word ptr [ebp - local_4], ax             # 004c9441
L_004c9445:
    # block 0x004c9445: entered by jmp at 0x004c9437, 3 instruction(s), ends with jge to 0x004c9467 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c9445
    cmp ecx, 0x18                                # 004c9449
    jge.d8 L_004c9467                            # 004c944c
    # block 0x004c944e: entered by fall-through of jge at 0x004c944c, 7 instruction(s), calls FUN_004c2dfb, ends with backward jump to 0x004c9439
    movsx edx, word ptr [ebp - local_4]          # 004c944e
    mov eax, dword ptr [ebp - local_8]           # 004c9452
    lea ecx, [eax + 4*edx + field_c72]           # 004c9455
    push ecx                                     # 004c945c
    mov ecx, dword ptr [ebp - local_8]           # 004c945d
    call FUN_004c2dfb                            # 004c9460
    jmp.d8 L_004c9439                            # 004c9465
L_004c9467:
    # block 0x004c9467: entered by jge at 0x004c944c, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004c9467
    pop ebp                                      # 004c9469
    ret                                          # 004c946a

