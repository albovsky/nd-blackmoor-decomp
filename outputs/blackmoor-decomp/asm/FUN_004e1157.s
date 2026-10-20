# FUN_004e1157
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e1157
# extent:       0x004e1157-0x004e119b (68 code bytes)
# span:         0x004e1157-0x004e119b (code 68, tables 0, padding 0)
# sha256:       3b547cf78a527ce2e25ec2c44b963e973be992122f771f3c45c8234234351d6a
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_taskbar_cc_text_box_restore
# naming:       INFERRED (lower confidence, not verified): the repository text src/caption_layout.h:157 says "0x4e1157 on 0x570508: CUITaskBar::RestoreCCTextBox, after a caption"
# name-note:    CUITaskBar::RestoreCCTextBox, run after a caption draw.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_74f; [ecx + n] field_74f
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_74f, 0x74f  # offset +0x74f

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004e1157 - 0x401000
.globl FUN_004e1157
FUN_004e1157:
    # block 0x004e1157: entry, 7 instruction(s), ends with je to 0x004e1197 (forward)
    push ebp                                     # 004e1157
    {load} mov ebp, esp                          # 004e1158
    push ecx                                     # 004e115a
    mov dword ptr [ebp - local_4], ecx           # 004e115b
    mov eax, dword ptr [ebp - local_4]           # 004e115e
    cmp dword ptr [eax + field_74f], 0x0         # 004e1161
    je.d8 L_004e1197                             # 004e1168
    # block 0x004e116a: entered by fall-through of je at 0x004e1168, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x004e1197
    push 0x55be54                                # 004e116a
    mov ecx, dword ptr [ebp - local_4]           # 004e116f
    add ecx, 0x55                                # 004e1172
    push ecx                                     # 004e1175
    mov edx, dword ptr [ebp - local_4]           # 004e1176
    add edx, 0x55                                # 004e1179
    push edx                                     # 004e117c
    mov eax, dword ptr [0x5cf665]                # 004e117d
    push eax                                     # 004e1182
    mov ecx, dword ptr [ebp - local_4]           # 004e1183
    mov edx, dword ptr [ecx + field_74f]         # 004e1186
    push edx                                     # 004e118c
    mov ecx, 0x5cf659                            # 004e118d
    call FUN_004c5377                            # 004e1192
L_004e1197:
    # block 0x004e1197: entered by je at 0x004e1168, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e1197
    pop ebp                                      # 004e1199
    ret                                          # 004e119a

