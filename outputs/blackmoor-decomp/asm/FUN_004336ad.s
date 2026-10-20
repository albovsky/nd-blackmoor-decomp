# FUN_004336ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004336ad
# extent:       0x004336ad-0x004338bb (526 code bytes)
# span:         0x004336ad-0x004338bb (code 526, tables 0, padding 0)
# sha256:       834d4b813977f7497ee821a55ef37857c29bed86bc34deddfce3b5a62327054b
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_raw_9a_sound_stop_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_9a_runtime.h:20 says "0x4336ad the handler."
# name-note:    Handler for raw 0x9a (and 0x9b) rows with a per-phase row state; stops sound channels.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_a, field_16, field_19; [ecx + n] field_2, field_8, field_12, field_18; [edx + n] field_2, field_6, field_e, field_16
# callees:      calls FUN_004fc878, FUN_004fc808
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 141 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ arg_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_16, 0x16  # offset +0x16
.equ field_18, 0x18  # offset +0x18
.equ field_19, 0x19  # offset +0x19

# --- external targets -----------------------------------------------
.set FUN_004fc808, .text + (0x004fc808 - 0x401000)
.set FUN_004fc878, .text + (0x004fc878 - 0x401000)

.org 0x004336ad - 0x401000
.globl FUN_004336ad
FUN_004336ad:
    # block 0x004336ad: entry, 13 instruction(s), ends with je to 0x004336ea (forward)
    push ebp                                     # 004336ad
    {load} mov ebp, esp                          # 004336ae
    sub esp, 0x10                                # 004336b0
    movsx eax, word ptr [ebp + arg_8]            # 004336b3
    imul eax, eax, 0x8d                          # 004336b7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004336bd
    mov dword ptr [ebp - local_c], ecx           # 004336c3
    movsx edx, word ptr [ebp + arg_8]            # 004336c6
    imul edx, edx, 0x8d                          # 004336ca
    mov eax, dword ptr [edx + 0x5bb632]          # 004336d0
    mov dword ptr [ebp - local_10], eax          # 004336d6
    cmp dword ptr [ebp - local_10], 0x0          # 004336d9
    je.d8 L_004336ea                             # 004336dd
    # block 0x004336df: entered by fall-through of je at 0x004336dd, 2 instruction(s), ends with je to 0x00433703 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 004336df
    je.d8 L_00433703                             # 004336e3
    # block 0x004336e5: entered by fall-through of je at 0x004336e3, 1 instruction(s), ends with forward jump to 0x004338b7
    jmp.d32 L_004338b7                           # 004336e5
L_004336ea:
    # block 0x004336ea: entered by je at 0x004336dd, 4 instruction(s), ends with forward jump to 0x004338b7
    movsx ecx, word ptr [ebp + arg_8]            # 004336ea
    imul ecx, ecx, 0x8d                          # 004336ee
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004336f4
    jmp.d32 L_004338b7                           # 004336fe
L_00433703:
    # block 0x00433703: entered by je at 0x004336e3, 4 instruction(s), ends with je to 0x00433719 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00433703
    movsx eax, word ptr [edx]                    # 00433706
    cmp eax, 0x14                                # 00433709
    je.d8 L_00433719                             # 0043370c
    # block 0x0043370e: entered by fall-through of je at 0x0043370c, 4 instruction(s), ends with jne to 0x00433764 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0043370e
    movsx edx, word ptr [ecx]                    # 00433711
    cmp edx, 0x15                                # 00433714
    jne.d8 L_00433764                            # 00433717
L_00433719:
    # block 0x00433719: entered by je at 0x0043370c; fall-through of jne at 0x00433717, 4 instruction(s), ends with jne to 0x0043372c (forward)
    mov eax, dword ptr [ebp - local_c]           # 00433719
    movsx ecx, word ptr [eax]                    # 0043371c
    cmp ecx, 0x14                                # 0043371f
    jne.d8 L_0043372c                            # 00433722
    # block 0x00433724: entered by fall-through of jne at 0x00433722, 2 instruction(s), ends with forward jump to 0x00433732
    mov word ptr [ebp - local_4], 0x0            # 00433724
    jmp.d8 L_00433732                            # 0043372a
L_0043372c:
    # block 0x0043372c: entered by jne at 0x00433722, 1 instruction(s), falls into the block at 0x00433732
    mov word ptr [ebp - local_4], 0x1            # 0043372c
L_00433732:
    # block 0x00433732: entered by jmp at 0x0043372a, 3 instruction(s), ends with forward jump to 0x00433748
    mov dx, word ptr [ebp - local_4]             # 00433732
    mov word ptr [ebp - local_8], dx             # 00433736
    jmp.d8 L_00433748                            # 0043373a
L_0043373c:
    # block 0x0043373c: entered by jmp at 0x00433760, 3 instruction(s), falls into the block at 0x00433748
    mov ax, word ptr [ebp - local_8]             # 0043373c
    .insn 0x66, 0x05, 0x0001{:u16}               # 00433740
    mov word ptr [ebp - local_8], ax             # 00433744
L_00433748:
    # block 0x00433748: entered by jmp at 0x0043373a, 3 instruction(s), ends with jge to 0x00433762 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00433748
    cmp ecx, 0xe                                 # 0043374c
    jge.d8 L_00433762                            # 0043374f
    # block 0x00433751: entered by fall-through of jge at 0x0043374f, 5 instruction(s), calls FUN_004fc878, ends with backward jump to 0x0043373c
    mov dx, word ptr [ebp - local_8]             # 00433751
    push edx                                     # 00433755
    mov ecx, 0x5c3a67                            # 00433756
    call FUN_004fc878                            # 0043375b
    jmp.d8 L_0043373c                            # 00433760
L_00433762:
    # block 0x00433762: entered by jge at 0x0043374f, 1 instruction(s), ends with forward jump to 0x00433775
    jmp.d8 L_00433775                            # 00433762
L_00433764:
    # block 0x00433764: entered by jne at 0x00433717, 5 instruction(s), calls FUN_004fc878, falls into the block at 0x00433775
    mov eax, dword ptr [ebp - local_c]           # 00433764
    mov cx, word ptr [eax]                       # 00433767
    push ecx                                     # 0043376a
    mov ecx, 0x5c3a67                            # 0043376b
    call FUN_004fc878                            # 00433770
L_00433775:
    # block 0x00433775: entered by jmp at 0x00433762, 2 instruction(s), ends with je to 0x004337ed (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 00433775
    je.d8 L_004337ed                             # 00433779
    # block 0x0043377b: entered by fall-through of je at 0x00433779, 4 instruction(s), ends with je to 0x00433791 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0043377b
    movsx eax, word ptr [edx]                    # 0043377e
    cmp eax, 0x14                                # 00433781
    je.d8 L_00433791                             # 00433784
    # block 0x00433786: entered by fall-through of je at 0x00433784, 4 instruction(s), ends with jne to 0x004337dc (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00433786
    movsx edx, word ptr [ecx]                    # 00433789
    cmp edx, 0x15                                # 0043378c
    jne.d8 L_004337dc                            # 0043378f
L_00433791:
    # block 0x00433791: entered by je at 0x00433784; fall-through of jne at 0x0043378f, 4 instruction(s), ends with jne to 0x004337a4 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00433791
    movsx ecx, word ptr [eax]                    # 00433794
    cmp ecx, 0x14                                # 00433797
    jne.d8 L_004337a4                            # 0043379a
    # block 0x0043379c: entered by fall-through of jne at 0x0043379a, 2 instruction(s), ends with forward jump to 0x004337aa
    mov word ptr [ebp - local_4], 0x0            # 0043379c
    jmp.d8 L_004337aa                            # 004337a2
L_004337a4:
    # block 0x004337a4: entered by jne at 0x0043379a, 1 instruction(s), falls into the block at 0x004337aa
    mov word ptr [ebp - local_4], 0x1            # 004337a4
L_004337aa:
    # block 0x004337aa: entered by jmp at 0x004337a2, 3 instruction(s), ends with forward jump to 0x004337c0
    mov dx, word ptr [ebp - local_4]             # 004337aa
    mov word ptr [ebp - local_8], dx             # 004337ae
    jmp.d8 L_004337c0                            # 004337b2
L_004337b4:
    # block 0x004337b4: entered by jmp at 0x004337d8, 3 instruction(s), falls into the block at 0x004337c0
    mov ax, word ptr [ebp - local_8]             # 004337b4
    .insn 0x66, 0x05, 0x0001{:u16}               # 004337b8
    mov word ptr [ebp - local_8], ax             # 004337bc
L_004337c0:
    # block 0x004337c0: entered by jmp at 0x004337b2, 3 instruction(s), ends with jge to 0x004337da (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004337c0
    cmp ecx, 0xe                                 # 004337c4
    jge.d8 L_004337da                            # 004337c7
    # block 0x004337c9: entered by fall-through of jge at 0x004337c7, 5 instruction(s), calls FUN_004fc808, ends with backward jump to 0x004337b4
    mov dx, word ptr [ebp - local_8]             # 004337c9
    push edx                                     # 004337cd
    mov ecx, 0x5c3a67                            # 004337ce
    call FUN_004fc808                            # 004337d3
    jmp.d8 L_004337b4                            # 004337d8
L_004337da:
    # block 0x004337da: entered by jge at 0x004337c7, 1 instruction(s), ends with forward jump to 0x004337ed
    jmp.d8 L_004337ed                            # 004337da
L_004337dc:
    # block 0x004337dc: entered by jne at 0x0043378f, 5 instruction(s), calls FUN_004fc808, falls into the block at 0x004337ed
    mov eax, dword ptr [ebp - local_c]           # 004337dc
    mov cx, word ptr [eax]                       # 004337df
    push ecx                                     # 004337e2
    mov ecx, 0x5c3a67                            # 004337e3
    call FUN_004fc808                            # 004337e8
L_004337ed:
    # block 0x004337ed: entered by je at 0x00433779; jmp at 0x004337da, 4 instruction(s), ends with je to 0x00433884 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004337ed
    movsx eax, word ptr [edx + field_2]          # 004337f0
    cmp eax, 0x270f                              # 004337f4
    je.d32 L_00433884                            # 004337f9
    # block 0x004337ff: entered by fall-through of je at 0x004337f9, 25 instruction(s), ends with jne to 0x00433870 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004337ff
    movsx edx, word ptr [ecx + field_2]          # 00433802
    mov dword ptr [0x5bb57b], edx                # 00433806
    mov eax, dword ptr [ebp - local_c]           # 0043380c
    mov cx, word ptr [eax + field_4]             # 0043380f
    mov word ptr [0x5bb599], cx                  # 00433813
    mov edx, dword ptr [ebp - local_c]           # 0043381a
    mov ax, word ptr [edx + field_6]             # 0043381d
    mov word ptr [0x5bb595], ax                  # 00433821
    mov ecx, dword ptr [ebp - local_c]           # 00433827
    mov dx, word ptr [ecx + field_8]             # 0043382a
    mov word ptr [0x5c39ff], dx                  # 0043382e
    mov eax, dword ptr [ebp - local_c]           # 00433835
    mov ecx, dword ptr [eax + field_a]           # 00433838
    mov dword ptr [0x5bb59b], ecx                # 0043383b
    mov edx, dword ptr [ebp - local_c]           # 00433841
    mov eax, dword ptr [edx + field_e]           # 00433844
    mov dword ptr [0x5bb59f], eax                # 00433847
    mov ecx, dword ptr [ebp - local_c]           # 0043384c
    mov edx, dword ptr [ecx + field_12]          # 0043384f
    mov dword ptr [0x5bb5a3], edx                # 00433852
    mov eax, dword ptr [ebp - local_c]           # 00433858
    movsx ecx, word ptr [eax + field_19]         # 0043385b
    cmp ecx, 0x1                                 # 0043385f
    jne.d8 L_00433870                            # 00433862
    # block 0x00433864: entered by fall-through of jne at 0x00433862, 2 instruction(s), ends with forward jump to 0x0043387a
    mov dword ptr [0x5bb1ca], 0x0                # 00433864
    jmp.d8 L_0043387a                            # 0043386e
L_00433870:
    # block 0x00433870: entered by jne at 0x00433862, 1 instruction(s), falls into the block at 0x0043387a
    mov dword ptr [0x5bb1ca], 0x1                # 00433870
L_0043387a:
    # block 0x0043387a: entered by jmp at 0x0043386e, 1 instruction(s), falls into the block at 0x00433884
    mov dword ptr [0x583999], 0x4                # 0043387a
L_00433884:
    # block 0x00433884: entered by je at 0x004337f9, 4 instruction(s), ends with je to 0x004338a6 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00433884
    movsx eax, word ptr [edx + field_16]         # 00433887
    cmp eax, -0x1                                # 0043388b
    je.d8 L_004338a6                             # 0043388e
    # block 0x00433890: entered by fall-through of je at 0x0043388e, 6 instruction(s), falls into the block at 0x004338a6
    mov ecx, dword ptr [ebp - local_c]           # 00433890
    {load} xor edx, edx                          # 00433893
    mov dl, byte ptr [ecx + field_18]            # 00433895
    mov eax, dword ptr [ebp - local_c]           # 00433898
    movsx ecx, word ptr [eax + field_16]         # 0043389b
    mov dword ptr [4*ecx + 0x585801], edx        # 0043389f
L_004338a6:
    # block 0x004338a6: entered by je at 0x0043388e, 3 instruction(s), falls into the block at 0x004338b7
    movsx edx, word ptr [ebp + arg_8]            # 004338a6
    imul edx, edx, 0x8d                          # 004338aa
    mov byte ptr [edx + 0x5bb625], 0x1           # 004338b0
L_004338b7:
    # block 0x004338b7: entered by jmp at 0x004336e5; jmp at 0x004336fe, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004338b7
    pop ebp                                      # 004338b9
    ret                                          # 004338ba

