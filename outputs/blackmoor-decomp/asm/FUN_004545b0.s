# FUN_004545b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004545b0
# extent:       0x004545b0-0x0045468e (222 code bytes)
# span:         0x004545b0-0x0045468e (code 222, tables 0, padding 0)
# sha256:       c4d3fb4344b3ea2a5110163e802bfbea88c85327a755faada3ab6d51f5ecd41a
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004545b0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_33c, field_348; [ecx + n] field_340, field_344; [edx + n] field_33c, field_340, field_348
# callees:      calls KERNEL32.dll!GetTickCount, FUN_00446598
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4545b0_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 66 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_33c, 0x33c  # offset +0x33c
.equ field_340, 0x340  # offset +0x340
.equ field_344, 0x344  # offset +0x344
.equ field_348, 0x348  # offset +0x348

# --- external targets -----------------------------------------------
.set FUN_00446598, .text + (0x00446598 - 0x401000)

.org 0x004545b0 - 0x401000
.globl FUN_004545b0
FUN_004545b0:
    # block 0x004545b0: entry, 22 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jge to 0x00454602 (forward)
    push ebp                                     # 004545b0
    {load} mov ebp, esp                          # 004545b1
    sub esp, 0x18                                # 004545b3
    mov dword ptr [ebp - local_10], ecx          # 004545b6
    call dword ptr [0x52a23c]                    # 004545b9
    mov ecx, dword ptr [ebp - local_10]          # 004545bf
    sub eax, dword ptr [ecx + field_344]         # 004545c2
    mov edx, dword ptr [ebp - local_10]          # 004545c8
    mov dword ptr [edx + field_348], eax         # 004545cb
    mov eax, dword ptr [ebp - local_10]          # 004545d1
    mov eax, dword ptr [eax + field_348]         # 004545d4
    {load} xor edx, edx                          # 004545da
    mov ecx, 0x3e8                               # 004545dc
    div ecx                                      # 004545e1
    mov dword ptr [ebp - local_8], eax           # 004545e3
    mov eax, dword ptr [ebp - local_8]           # 004545e6
    cdq                                          # 004545e9
    mov ecx, 0x3c                                # 004545ea
    idiv ecx                                     # 004545ef
    mov dword ptr [ebp - local_c], eax           # 004545f1
    cmp dword ptr [ebp - local_c], 0x3b          # 004545f4
    jge.d8 L_00454602                            # 004545f8
    # block 0x004545fa: entered by fall-through of jge at 0x004545f8, 3 instruction(s), ends with forward jump to 0x00454609
    mov edx, dword ptr [ebp - local_c]           # 004545fa
    mov dword ptr [ebp - local_14], edx          # 004545fd
    jmp.d8 L_00454609                            # 00454600
L_00454602:
    # block 0x00454602: entered by jge at 0x004545f8, 1 instruction(s), falls into the block at 0x00454609
    mov dword ptr [ebp - local_14], 0x3b         # 00454602
L_00454609:
    # block 0x00454609: entered by jmp at 0x00454600, 9 instruction(s), ends with jge to 0x0045462b (forward)
    mov eax, dword ptr [ebp - local_14]          # 00454609
    mov dword ptr [ebp - local_c], eax           # 0045460c
    mov ecx, dword ptr [ebp - local_c]           # 0045460f
    imul ecx, ecx, 0x3c                          # 00454612
    mov edx, dword ptr [ebp - local_8]           # 00454615
    {load} sub edx, ecx                          # 00454618
    mov dword ptr [ebp - local_4], edx           # 0045461a
    cmp dword ptr [ebp - local_4], 0x3b          # 0045461d
    jge.d8 L_0045462b                            # 00454621
    # block 0x00454623: entered by fall-through of jge at 0x00454621, 3 instruction(s), ends with forward jump to 0x00454632
    mov eax, dword ptr [ebp - local_4]           # 00454623
    mov dword ptr [ebp - local_18], eax          # 00454626
    jmp.d8 L_00454632                            # 00454629
L_0045462b:
    # block 0x0045462b: entered by jge at 0x00454621, 1 instruction(s), falls into the block at 0x00454632
    mov dword ptr [ebp - local_18], 0x3b         # 0045462b
L_00454632:
    # block 0x00454632: entered by jmp at 0x00454629, 6 instruction(s), ends with jne to 0x00454654 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 00454632
    mov dword ptr [ebp - local_4], ecx           # 00454635
    mov edx, dword ptr [ebp - local_10]          # 00454638
    mov eax, dword ptr [ebp - local_c]           # 0045463b
    cmp eax, dword ptr [edx + field_33c]         # 0045463e
    jne.d8 L_00454654                            # 00454644
    # block 0x00454646: entered by fall-through of jne at 0x00454644, 4 instruction(s), ends with je to 0x0045468a (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00454646
    mov edx, dword ptr [ebp - local_4]           # 00454649
    cmp edx, dword ptr [ecx + field_340]         # 0045464c
    je.d8 L_0045468a                             # 00454652
L_00454654:
    # block 0x00454654: entered by jne at 0x00454644; fall-through of je at 0x00454652, 14 instruction(s), calls FUN_00446598, falls into the block at 0x0045468a
    mov eax, dword ptr [ebp - local_10]          # 00454654
    mov ecx, dword ptr [ebp - local_c]           # 00454657
    mov dword ptr [eax + field_33c], ecx         # 0045465a
    mov edx, dword ptr [ebp - local_10]          # 00454660
    mov eax, dword ptr [ebp - local_4]           # 00454663
    mov dword ptr [edx + field_340], eax         # 00454666
    mov ecx, dword ptr [ebp - local_10]          # 0045466c
    mov edx, dword ptr [ecx + field_340]         # 0045466f
    push edx                                     # 00454675
    mov eax, dword ptr [ebp - local_10]          # 00454676
    mov ecx, dword ptr [eax + field_33c]         # 00454679
    push ecx                                     # 0045467f
    mov ecx, 0x638603                            # 00454680
    call FUN_00446598                            # 00454685
L_0045468a:
    # block 0x0045468a: entered by je at 0x00454652, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0045468a
    pop ebp                                      # 0045468c
    ret                                          # 0045468d

