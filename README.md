# tiara-entheome

`tiara-entheome` is a fork of [Tiara](https://github.com/ibe-uw/tiara) (Karlicki et al. 2022), a deep-learning-based classifier that identifies eukaryotic and organellar sequences in metagenomic data, powered by [PyTorch](https://pytorch.org).

This fork exists for one reason: dependency compatibility. Upstream `tiara=1.0.3` pins `numpy==1.19.2`, `numba==0.52.0`, `torch==1.7.1`, and `skorch==0.10.0`. Those 2021-era pins conflict with the `libzlib` and `python_abi` requirements of the current bioconda toolchain (samtools, kraken2, bbmap, flye), so the solver fails when a single environment needs both Tiara and modern tools. `tiara-entheome` bumps those pins so the package installs cleanly alongside the modern toolchain.

The model weights, the classification logic, and the algorithm are unchanged from upstream `tiara=1.0.3`. The only differences are the dependency pins, the package and command name, and packaging metadata. This package is consumed by the [EGAP](https://github.com/iPsychonaut/EGAP) genome assembly pipeline for kingdom-aware contig decontamination.

## Relationship to upstream Tiara

- Upstream project: https://github.com/ibe-uw/tiara
- Original authors: Michał Karlicki, Stanisław Antonowicz, Anna Karnkowska
- Original paper: Karlicki M., Antonowicz S., Karnkowska A. Tiara: deep learning-based classification system for eukaryotic sequences. *Bioinformatics* 38(2), 344-350 (2022). https://doi.org/10.1093/bioinformatics/btab672

The full original upstream README is preserved in [README_UPSTREAM.md](README_UPSTREAM.md).

## What changed versus upstream

| | upstream `tiara` 1.0.3 | `tiara-entheome` 1.0.0 |
| --- | --- | --- |
| numpy | `==1.19.2` | `>=1.21` |
| numba | `==0.52.0` | `>=0.56` |
| pytorch | `==1.7.1` | `>=1.10,<3` |
| skorch | `==0.10.0` | `>=0.11` |
| python | `>=3.7,<3.10` | `>=3.8,<3.13` |
| import name | `tiara` | `tiara_entheome` |
| CLI command | `tiara` | `tiara-entheome` |

No model files, weights, or classification code were modified.

## Requirements

- `Python >= 3.8, < 3.13`
- `numpy, biopython, torch, skorch, tqdm, joblib, numba`

## Installation

### Using conda (once the bioconda recipe is accepted)

```bash
conda install -c bioconda tiara-entheome
```

### Using pip (once published)

```bash
pip install tiara-entheome
```

### From source

```bash
git clone https://github.com/iPsychonaut/tiara-entheome.git
cd tiara-entheome
pip install -e .
```

### Testing the installation

After installing, run the bundled self-test, which classifies the packaged fixtures and compares them against the expected upstream outputs:

```bash
tiara-entheome-test
```

## Usage

Usage is identical to upstream Tiara. Substitute `tiara-entheome` wherever you would have called `tiara`.

### Basic usage

```bash
tiara-entheome -i sample_input.fasta -o out.txt
```

Sequences in the fasta file should be at least 3000 bases long (the default). We do not recommend classifying sequences shorter than 1000 base pairs.

It creates two files:

- `out.txt`, a tab-separated file with the header `sequence id, first stage classification result, second stage classification result`.
- `log_out.txt`, containing model parameters and a classification summary.

### Advanced

```bash
tiara-entheome -i sample_input.fasta -o out.txt --tf mit pla pro -t 4 -p 0.65 0.60 --probabilities
```

This also writes three fasta files containing the sequences classified as mitochondria, plastid, and prokarya (`--tf mit pla pro`), sets the thread count to 4 (`-t 4`), sets the first and second stage probability cutoffs to 0.65 and 0.60, and writes per-class probabilities to `out.txt` (`--probabilities`).

For more usage examples, see the upstream docs under [docs/usage.md](docs/usage.md).

## Citation

If you use `tiara-entheome`, please cite the original Tiara paper:

Michał Karlicki, Stanisław Antonowicz, Anna Karnkowska, Tiara: deep learning-based classification system for eukaryotic sequences, *Bioinformatics*, Volume 38, Issue 2, 15 January 2022, Pages 344-350, https://doi.org/10.1093/bioinformatics/btab672

## License

`tiara-entheome` is released under the MIT license, the same license as upstream Tiara. See [LICENSE](LICENSE). Original copyright belongs to the Institute of Evolutionary Biology, University of Warsaw.
