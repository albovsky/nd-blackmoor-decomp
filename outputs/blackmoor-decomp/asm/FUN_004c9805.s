# FUN_004c9805
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c9805
# extent:       0x004c9805-0x004c98b5 (176 code bytes)
# span:         0x004c9805-0x004c98b5 (code 176, tables 0, padding 0)
# sha256:       1e9c027bfde9765445bd6baca88f330ee01270a8bbc07f91f64e9fafb4876de4
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c9805
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4; [edx + n] field_4, field_68
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, KERNEL32.dll!Sleep, FUN_0042639d, FUN_004c97b4; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ field_68, 0x68  # offset +0x68

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004c9805 - 0x401000
.globl FUN_004c9805
FUN_004c9805:
    # block 0x004c9805: entry, 8 instruction(s), ends with forward jump to 0x004c982f
    push ebp                                     # 004c9805
    {load} mov ebp, esp                          # 004c9806
    sub esp, 0x14                                # 004c9808
    mov dword ptr [ebp - local_14], ecx          # 004c980b
    mov word ptr [ebp - local_8], 0x32           # 004c980e
    mov dword ptr [ebp - local_10], 0x64         # 004c9814
    mov word ptr [ebp - local_c], 0x0            # 004c981b
    jmp.d8 L_004c982f                            # 004c9821
L_004c9823:
    # block 0x004c9823: entered by jmp at 0x004c9893, 3 instruction(s), falls into the block at 0x004c982f
    mov ax, word ptr [ebp - local_c]             # 004c9823
    .insn 0x66, 0x05, 0x0001{:u16}               # 004c9827
    mov word ptr [ebp - local_c], ax             # 004c982b
L_004c982f:
    # block 0x004c982f: entered by jmp at 0x004c9821, 4 instruction(s), ends with jge to 0x004c9895 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004c982f
    movsx edx, word ptr [ebp - local_8]          # 004c9833
    {load} cmp ecx, edx                          # 004c9837
    jge.d8 L_004c9895                            # 004c9839
    # block 0x004c983b: entered by fall-through of jge at 0x004c9839, 10 instruction(s), calls indirect dword ptr [edx + 0x68], ends with je to 0x004c9891 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004c983b
    mov ecx, dword ptr [eax + field_4]           # 004c983e
    mov edx, dword ptr [ebp - local_14]          # 004c9841
    mov eax, dword ptr [edx + field_4]           # 004c9844
    mov edx, dword ptr [eax]                     # 004c9847
    push ecx                                     # 004c9849
    call dword ptr [edx + field_68]              # 004c984a
    mov dword ptr [ebp - local_4], eax           # 004c984d
    cmp dword ptr [ebp - local_4], 0x0           # 004c9850
    je.d8 L_004c9891                             # 004c9854
    # block 0x004c9856: entered by fall-through of je at 0x004c9854, 3 instruction(s), ends with je to 0x004c9885 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c9856
    test eax, eax                                # 004c985d
    je.d8 L_004c9885                             # 004c985f
    # block 0x004c9861: entered by fall-through of je at 0x004c985f, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004c9885
    movsx ecx, word ptr [ebp - local_c]          # 004c9861
    push ecx                                     # 004c9865
    push 0x557bac                                # 004c9866
    push 0x63888b                                # 004c986b
    call FUN_0050ca3e                            # 004c9870
    add esp, 0xc                                 # 004c9875
    push 0x63888b                                # 004c9878
    call FUN_0044a2b7                            # 004c987d
    add esp, 0x4                                 # 004c9882
L_004c9885:
    # block 0x004c9885: entered by je at 0x004c985f, 4 instruction(s), calls KERNEL32.dll!Sleep, ends with forward jump to 0x004c9893
    mov edx, dword ptr [ebp - local_10]          # 004c9885
    push edx                                     # 004c9888
    call dword ptr [0x52a2b0]                    # 004c9889
    jmp.d8 L_004c9893                            # 004c988f
L_004c9891:
    # block 0x004c9891: entered by je at 0x004c9854, 1 instruction(s), ends with forward jump to 0x004c98b1
    jmp.d8 L_004c98b1                            # 004c9891
L_004c9893:
    # block 0x004c9893: entered by jmp at 0x004c988f, 1 instruction(s), ends with backward jump to 0x004c9823
    jmp.d8 L_004c9823                            # 004c9893
L_004c9895:
    # block 0x004c9895: entered by jge at 0x004c9839, 6 instruction(s), calls FUN_0042639d, FUN_004c97b4, falls into the block at 0x004c98b1
    push 0x557be0                                # 004c9895
    push 0x557c10                                # 004c989a
    mov ecx, 0x583979                            # 004c989f
    call FUN_0042639d                            # 004c98a4
    mov ecx, dword ptr [ebp - local_14]          # 004c98a9
    call FUN_004c97b4                            # 004c98ac
L_004c98b1:
    # block 0x004c98b1: entered by jmp at 0x004c9891, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004c98b1
    pop ebp                                      # 004c98b3
    ret                                          # 004c98b4

