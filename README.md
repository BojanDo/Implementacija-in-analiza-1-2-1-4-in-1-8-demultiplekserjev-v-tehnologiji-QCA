# Implementation and analysis of 1:2, 1:4 and 1:8 QCA demultiplexers

We tested the circuits with the Coherence Vector model in QCADesigner-E 2.2, based on QCADesigner 2.0.3.

## circuits/

1. 1:2 demultiplexer — `demux12.qca`
2. 1:4 demultiplexer — `demux14.qca`
3. 1:8 demultiplexer — `demux18_original.qca` (original) and `demux18.qca` (corrected)

## screenshots/

The `layouts/` and `waveforms/` folders contain circuit layouts and simulation waveforms, respectively. Both include PNG and EPS files for these designs.

1. 1:2 — `demux12`
2. 1:4 — `demux14`
3. 1:8 — `demux18_original` and `demux18`

## demux18/

The [original 1:8 truth table](demux18/demux18_original-truth.csv) shows correct outputs for 7 of 16 input combinations.
The [corrected 1:8 truth table](demux18/demux18-truth.csv) passes all 16.

To regenerate both CSVs, you need Python 3, and a locally built copy of the [QCADesigner-E source code](https://github.com/FSillT/QCADesigner-E).
Run the following command from the repository root.

```sh
./demux18/reproduce.sh /path/to/QCADesigner-E
```
