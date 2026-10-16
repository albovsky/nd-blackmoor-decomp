# FUN_00414537
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00414537
# extent:       0x00414537-0x0041458b (84 code bytes)
# span:         0x00414537-0x0041458b (code 84, tables 0, padding 0)
# sha256:       02eae63c59dcf316ca7ae929206d8943f1dd481ba17cf34c084a3df7aedcd50c
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00414537
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004145a7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004145a7, .text + (0x004145a7 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00414537 - 0x401000
.globl FUN_00414537
FUN_00414537:
    # block 0x00414537: entry, 23 instruction(s), calls FUN_0051d716, FUN_004145a7, ends with ret
    push ebp                                     # 00414537
    {load} mov ebp, esp                          # 00414538
    push -0x1                                    # 0041453a
    push 0x52729d                                # 0041453c
    mov eax, dword ptr fs:[0x0]                  # 00414541
    push eax                                     # 00414547
    mov dword ptr fs:[0x0], esp                  # 00414548
    push ecx                                     # 0041454f
    mov dword ptr [ebp - local_10], ecx          # 00414550
    mov ecx, dword ptr [ebp - local_10]          # 00414553
    call FUN_0051d716                            # 00414556
    mov dword ptr [ebp - local_4], 0x0           # 0041455b
    mov eax, dword ptr [ebp - local_10]          # 00414562
    mov dword ptr [eax], 0x52c4f0                # 00414565
    mov ecx, dword ptr [ebp - local_10]          # 0041456b
    call FUN_004145a7                            # 0041456e
    mov dword ptr [ebp - local_4], 0xffffffff    # 00414573
    mov eax, dword ptr [ebp - local_10]          # 0041457a
    mov ecx, dword ptr [ebp - local_c]           # 0041457d
    mov dword ptr fs:[0x0], ecx                  # 00414580
    {load} mov esp, ebp                          # 00414587
    pop ebp                                      # 00414589
    ret                                          # 0041458a

