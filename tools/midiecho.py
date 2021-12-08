import mido

print('outputs')
print(mido.get_output_names())

print('inputs')
print(mido.get_input_names())

with mido.open_input('nanoKEY2:nanoKEY2 MIDI 1') as midi_in:
    with mido.open_output('Picosystem:Picosystem MIDI 1') as midi_out:
        for msg in midi_in:
            print(msg)
            midi_out.send(msg)
