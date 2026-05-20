# nGIST v7.6.8 MAUVE Setonix setup

This repository contains the MAUVE configuration setup files used to generate
nGIST/GIST YAML configuration files for the v7.6.8 Setonix runs.

The repository is intended to keep the master configuration, target input
tables, generated galaxy YAML files, and older setup references together in one
version-controlled place.

## Repository layout

```text
config_setup/
  MAUVE_MasterConfig_v7.6.8_setonix.yaml       # master nGIST/GIST config
  make_gist_config.py                          # standard config generator
  make_gist_config_try.py                      # local-validation generator
  GIST_setupinput_v1.fits                      # pointer to setup FITS table
  cube_centers_v3tk.csv                        # cube centers for v3tk cubes
  *_MAUVE_MasterConfig_v7.6.8_setonix.yaml     # generated galaxy configs
  input_tables/                                # MAUVE input tables and redshifts
  old/                                         # older config/script versions

config_setup.zip                               # archived copy of setup folder
```

## Main configuration

The active master config is:

```text
config_setup/MAUVE_MasterConfig_v7.6.8_setonix.yaml
```

Important current settings include:

- Wavelength range: `4800-9100 Angstrom`
- Voronoi target S/N: `40`
- Velocity scale: `41 km/s`
- Stellar/SFH mask: `specMask_KIN_narrow10`
- Gas mask: `specMask_GAS_narrow10`
- Gas fitting level: `BOTH`
- Setonix cube path: `/scratch/pawsey1308/mauve/cubes/v3tk/`
- Setonix product path: `/scratch/pawsey1308/mauve/products/v3tk_v7.6.8/`

## Creating a galaxy YAML file

Run the generator from inside `config_setup`:

```bash
cd config_setup
python make_gist_config.py IC3392 -cpu 128 -center 219,219
```

This creates:

```text
IC3392_MAUVE_MasterConfig_v7.6.8_setonix.yaml
```

The script fills galaxy-specific values from the setup input table:

- `GENERAL.RUN_ID`
- `GENERAL.INPUT`
- `GENERAL.OUTPUT`
- `GENERAL.REDSHIFT`
- `GENERAL.NCPU`
- `READ_DATA.ORIGIN`
- `READ_DATA.EBmV`
- `SPATIAL_MASKING.MASK`
- `KIN.SIGMA`
- `CONT.SIGMA`

## Local validation variant

`make_gist_config_try.py` is a local-validation version of the generator. It
adds two conveniences:

- It can resolve `GIST_setupinput_v1.fits` when that file is a text pointer to a
  FITS file under `input_tables/`.
- If `-center` is not supplied, it reads the cube center from
  `cube_centers_v3tk.csv`.

Example:

```bash
cd config_setup
python make_gist_config_try.py IC3392
```

Manual center override:

```bash
python make_gist_config_try.py IC3392 -cpu 128 -center 219,219
```

## Current generated configs

The repository currently includes generated v7.6.8 Setonix configs for:

- `IC3392`
- `NGC4383`
- `NGC4396`
- `NGC4419`
- `NGC4501`
- `NGC4698`

## Required Python packages

The generator scripts require:

```bash
python
astropy
numpy
pyyaml
```

On an existing science environment, the usual check is:

```bash
python -c "import astropy, numpy, yaml"
```

## Notes before running nGIST/GIST

This repository does not contain the full MUSE datacubes, masks, nGIST
`configFiles`, stellar templates, or output products. The generated YAML files
expect those resources to exist on Setonix at the configured paths.

Before launching a production run, check:

- The generated galaxy YAML has the intended `REDSHIFT`, `EBmV`, `SIGMA`, and
  `ORIGIN`.
- The input cube exists under `/scratch/pawsey1308/mauve/cubes/v3tk/`.
- The galaxy mask file, for example `IC3392_mask.fits`, is available where
  nGIST/GIST expects it.
- The nGIST `configFiles` directory contains the referenced masks, LSF files,
  emission-line config, and template definitions.
- The required stellar population templates are available under
  `spectralTemplates`.

## Version-control notes

The authoritative editable setup files are in `config_setup/`. Older files are
kept under `config_setup/old/` for provenance.

When changing the master config or setup tables, make a new commit that clearly
states what changed, for example:

```bash
git add README.md config_setup/
git commit -m "Document nGIST v7.6.8 Setonix setup"
```
