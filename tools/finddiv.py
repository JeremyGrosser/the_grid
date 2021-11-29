from collections import defaultdict

clk_sys = 125e6


def try_divider(div, notes):
    clk_pwm = clk_sys / div
    total_error = 0.0
    for note in notes:
        period = int(clk_pwm / note)
        if period > 65536.0:
            total_error += clk_sys
        else:
            f = clk_pwm / float(period)
            total_error += abs(f - note)
    return total_error

def best_divider(notes):
    div_step = 1.0 / 2 ** 4
    div = 256.0 - div_step

    best_div = None
    best_error = None
    while div >= 1.0:
        error = try_divider(div, notes)
        if best_error is None or error < best_error:
            best_error = error
            best_div = div
        div -= div_step
    return best_div, best_error

interval = 100  # cents
root = 27.5     # A0

note_name = ['C', 'Cs', 'D', 'Ds', 'E', 'F', 'Fs', 'G', 'Gs', 'A', 'As', 'B']

for octave in range(0, 12):
    notes = [root] * 12
    for i in range(1, 12):
        notes[i] = notes[i - 1] * 2 ** (interval / 1200)

    div, error = best_divider(notes)
    #print('%.04f' % div, end=', ')
    #print(octave, div, error)
    print('%i => (' % octave, end='')
    for i in range(0, 12):
        period = int(clk_sys / div / notes[i])
        print(period, end=', ')
        #print((octave * 12) + i, div, period)
    print('),')

    root = root * 2.0
print()
