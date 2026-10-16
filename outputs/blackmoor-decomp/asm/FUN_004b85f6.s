# FUN_004b85f6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b85f6
# extent:       0x004b85f6-0x004b866e (120 code bytes)
# span:         0x004b85f6-0x004b866e (code 120, tables 0, padding 0)
# sha256:       5beed41b496466f2141b722d7c843cd02b107f5ae03a21e2c966c2954a5e9eab
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b85f6
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_8; [ecx + n] field_432, field_63b; [edx + n] field_63b
# callees:      calls FUN_0050cd50, FUN_004b8520
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_8, 0x8  # offset +0x8
.equ field_432, 0x432  # offset +0x432
.equ field_63b, 0x63b  # offset +0x63b

# --- external targets -----------------------------------------------
.set FUN_004b8520, .text + (0x004b8520 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004b85f6 - 0x401000
.globl FUN_004b85f6
FUN_004b85f6:
    # block 0x004b85f6: entry, 5 instruction(s), falls into the block at 0x004b8606
    push ebp                                     # 004b85f6
    {load} mov ebp, esp                          # 004b85f7
    sub esp, 0xc                                 # 004b85f9
    mov dword ptr [ebp - local_c], ecx           # 004b85fc
    mov dword ptr [ebp - local_4], 0x0           # 004b85ff
L_004b8606:
    # block 0x004b8606: entered by jmp at 0x004b8665, 2 instruction(s), ends with jne to 0x004b8667 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004b8606
    jne.d8 L_004b8667                            # 004b860a
    # block 0x004b860c: entered by fall-through of jne at 0x004b860a, 6 instruction(s), ends with je to 0x004b863b (forward)
    mov eax, dword ptr [ebp - local_c]           # 004b860c
    mov ecx, dword ptr [eax + field_8]           # 004b860f
    {load} xor edx, edx                          # 004b8612
    mov dl, byte ptr [ecx + field_432]           # 004b8614
    test edx, edx                                # 004b861a
    je.d8 L_004b863b                             # 004b861c
    # block 0x004b861e: entered by fall-through of je at 0x004b861c, 9 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x004b8656
    call FUN_0050cd50                            # 004b861e
    mov ecx, dword ptr [ebp - local_c]           # 004b8623
    movsx ecx, word ptr [ecx + field_63b]        # 004b8626
    sub ecx, 0x30                                # 004b862d
    cdq                                          # 004b8630
    idiv ecx                                     # 004b8631
    add edx, 0x30                                # 004b8633
    mov byte ptr [ebp - local_8], dl             # 004b8636
    jmp.d8 L_004b8656                            # 004b8639
L_004b863b:
    # block 0x004b863b: entered by je at 0x004b861c, 8 instruction(s), calls FUN_0050cd50, falls into the block at 0x004b8656
    call FUN_0050cd50                            # 004b863b
    mov edx, dword ptr [ebp - local_c]           # 004b8640
    movsx ecx, word ptr [edx + field_63b]        # 004b8643
    sub ecx, 0x41                                # 004b864a
    cdq                                          # 004b864d
    idiv ecx                                     # 004b864e
    add edx, 0x41                                # 004b8650
    mov byte ptr [ebp - local_8], dl             # 004b8653
L_004b8656:
    # block 0x004b8656: entered by jmp at 0x004b8639, 6 instruction(s), calls FUN_004b8520, ends with backward jump to 0x004b8606
    mov dl, byte ptr [ebp - local_8]             # 004b8656
    push edx                                     # 004b8659
    mov ecx, dword ptr [ebp - local_c]           # 004b865a
    call FUN_004b8520                            # 004b865d
    mov dword ptr [ebp - local_4], eax           # 004b8662
    jmp.d8 L_004b8606                            # 004b8665
L_004b8667:
    # block 0x004b8667: entered by jne at 0x004b860a, 4 instruction(s), ends with ret
    mov al, byte ptr [ebp - local_8]             # 004b8667
    {load} mov esp, ebp                          # 004b866a
    pop ebp                                      # 004b866c
    ret                                          # 004b866d

