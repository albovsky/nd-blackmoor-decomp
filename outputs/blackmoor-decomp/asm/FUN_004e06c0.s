# FUN_004e06c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e06c0
# extent:       0x004e06c0-0x004e0742 (130 code bytes)
# span:         0x004e06c0-0x004e0742 (code 130, tables 0, padding 0)
# sha256:       eb66c4c08b523987314f702abe292650aca746fa29522ab08bb3a3584634644f
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_taskbar_object_init
# naming:       INFERRED (lower confidence, not verified): the repository text src/inventory_button_runtime.h:146 says "Power-on state of the bar object after 0x4e06c0"
# name-note:    Initialiser of the task bar object: object state 0, buttons in record state, lock table filled by 0x4e1a7e.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_753; [ecx + n] field_65, field_753; [edx + n] field_753, field_757
# callees:      calls FUN_004e04f3, FUN_004e1db3, FUN_004e1a7e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_65, 0x65  # offset +0x65
.equ field_753, 0x753  # offset +0x753
.equ field_757, 0x757  # offset +0x757

# --- external targets -----------------------------------------------
.set FUN_004e04f3, .text + (0x004e04f3 - 0x401000)
.set FUN_004e1a7e, .text + (0x004e1a7e - 0x401000)
.set FUN_004e1db3, .text + (0x004e1db3 - 0x401000)

.org 0x004e06c0 - 0x401000
.globl FUN_004e06c0
FUN_004e06c0:
    # block 0x004e06c0: entry, 9 instruction(s), calls FUN_004e04f3, ends with forward jump to 0x004e06f3
    push ebp                                     # 004e06c0
    {load} mov ebp, esp                          # 004e06c1
    push ecx                                     # 004e06c3
    mov dword ptr [ebp - local_4], ecx           # 004e06c4
    mov ecx, dword ptr [ebp - local_4]           # 004e06c7
    call FUN_004e04f3                            # 004e06ca
    mov eax, dword ptr [ebp - local_4]           # 004e06cf
    mov dword ptr [eax + field_753], 0x0         # 004e06d2
    jmp.d8 L_004e06f3                            # 004e06dc
L_004e06de:
    # block 0x004e06de: entered by jmp at 0x004e0734, 5 instruction(s), falls into the block at 0x004e06f3
    mov ecx, dword ptr [ebp - local_4]           # 004e06de
    mov edx, dword ptr [ecx + field_753]         # 004e06e1
    add edx, 0x1                                 # 004e06e7
    mov eax, dword ptr [ebp - local_4]           # 004e06ea
    mov dword ptr [eax + field_753], edx         # 004e06ed
L_004e06f3:
    # block 0x004e06f3: entered by jmp at 0x004e06dc, 3 instruction(s), ends with jge to 0x004e0736 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e06f3
    cmp dword ptr [ecx + field_753], 0x5         # 004e06f6
    jge.d8 L_004e0736                            # 004e06fd
    # block 0x004e06ff: entered by fall-through of jge at 0x004e06fd, 13 instruction(s), calls FUN_004e1db3, ends with backward jump to 0x004e06de
    mov edx, dword ptr [ebp - local_4]           # 004e06ff
    mov eax, dword ptr [edx + field_753]         # 004e0702
    imul eax, eax, 0x162                         # 004e0708
    mov ecx, dword ptr [ebp - local_4]           # 004e070e
    lea edx, [ecx + eax + field_65]              # 004e0711
    push edx                                     # 004e0715
    mov eax, dword ptr [ebp - local_4]           # 004e0716
    mov ecx, dword ptr [eax + field_753]         # 004e0719
    imul ecx, ecx, 0x18f                         # 004e071f
    mov edx, dword ptr [ebp - local_4]           # 004e0725
    lea ecx, [edx + ecx + field_757]             # 004e0728
    call FUN_004e1db3                            # 004e072f
    jmp.d8 L_004e06de                            # 004e0734
L_004e0736:
    # block 0x004e0736: entered by jge at 0x004e06fd, 5 instruction(s), calls FUN_004e1a7e, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004e0736
    call FUN_004e1a7e                            # 004e0739
    {load} mov esp, ebp                          # 004e073e
    pop ebp                                      # 004e0740
    ret                                          # 004e0741

