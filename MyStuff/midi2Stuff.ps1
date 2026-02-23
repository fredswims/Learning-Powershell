<# 
# Our intention is for developers to begin adopting Windows MIDI Services 
# in place of the older WinMM, WinRT, and (deprecated) DirectMusic APIs in their applications. 
# All new MIDI features, transports, and more will be implemented in Windows MIDI Services and the new API. 

# MIDI 2.0 Protocol (UMP) - Universal MIDI Packet
# https://midi.org/universal-midi-packet-ump-and-midi-2-0-protocol-specification

# github

KORG Keystage MIDI2 with polyphonic aftertouch
Korg Keystage MIDI 2.0: Raising the Bar for MIDI Controllers!
Yamaha Montage
Roland A8 MII ?

MIDI Polyphonic Expression (MPE) support allows for individual note control (pitch, timbre, pressure) 
within DAWs like Ableton Live, Logic Pro, Cubase, and Bitwig Studio. 
Key compatible instruments include the ROLI Seaboard, ASM Hydrasynth, and Haken Eaganmatrix. 
MPE is activated in software via settings menus, typically mapping each note to a unique MIDI channel for advanced expression.
{https://share.google/aimode/4NdzCnKPK1iAr8iG0}

Registry entries
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32
midi -> wdmaud.drv
midi1 -> wdmaud2.drv
#>
 # this is where all the midi2 information https://microsoft.github.io/MIDI/ 
#  This tool tells you if the new Windows MIDI Services is enabled on your PC.
invoke-expression (join-path -Resolve $home Downloads midicheckservice.exe)
# these three services should be running
get-service -name "midisrv", "audioendpointbuilder", "rpcss"