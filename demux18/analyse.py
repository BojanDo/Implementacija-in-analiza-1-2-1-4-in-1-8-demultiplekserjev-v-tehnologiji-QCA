import csv
import sys
from pathlib import Path

inputs = ["S2", "S1", "S0", "D"]
outputs = [f"Y{i}" for i in range(8)]
# Default exhaustive CV run: 700000 steps, 32 cycles, one sample per 234 steps.
samples_per_cycle = 700000 / 32 / 234
delay = 3


def write_truth_table(trace_path, output_path):
    with trace_path.open(newline="") as source:
        trace = list(csv.DictReader(source))

    patterns = {}
    with output_path.open("w", newline="") as target:
        writer = csv.writer(target)
        writer.writerow(["launch_cycle", *inputs, "expected_high", "observed_high", "bits_correct", *outputs])
        for cycle in range(32 - delay):
            launch = trace[round((cycle + 0.25) * samples_per_cycle)]
            hold = trace[round((cycle + delay + 0.25) * samples_per_cycle)]
            bits = tuple(int(float(launch[name]) > 0) for name in inputs)
            s2, s1, s0, data = bits
            selected = outputs[4 * s2 + 2 * s1 + s0] if data else "-"
            values = [float(hold[name]) for name in outputs]
            if not all(abs(value) > 0.9 for value in values):
                raise ValueError(f"Unsettled output for input {bits} at launch cycle {cycle}")
            highs = [name for name, value in zip(outputs, values) if value > 0.9]
            correct = sum((name == selected) == (name in highs) for name in outputs)
            writer.writerow([cycle, *bits, selected, " ".join(highs) or "-", correct, *values])
            patterns[bits] = patterns.get(bits, True) and correct == len(outputs)

    if len(patterns) != 16:
        raise ValueError(f"Expected 16 distinct input combinations, found {len(patterns)}")
    print(f"{output_path.name}: {sum(patterns.values())}/16 input combinations passed")


if __name__ == "__main__":
    write_truth_table(Path(sys.argv[1]), Path(sys.argv[2]))
