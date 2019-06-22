# ECV - A fancy curriculum vitae with LaTeX

This repository hosts the source code for the [CTAN](https://ctan.org/)package [ECV](https://ctan.org/pkg/ecv).

The package enhances a LaTeX installation with a LaTeX class for writing a curriculum vitae in a tabular form. With this class you can write a curriculum vitae in English or German language.

If you just want to extend you LaTeX installation please download the [ECV package from CTAN](https://ctan.org/pkg/ecv) and follow the installation instructions.

If you want to extend the package please follow this guideline.

## Building the package

To build the package from source clone this repository:

```bash
$ git clone https://github.com/poldi2015/ecv.git
```

and run `make`:

```bash
$ make dist
```

This will create the zip file `dist/ecv.zip` with the complete installation package as it can be downloaded from CTAN.

All build artifacts without the archive itself can be build with:

```bash
$ make compile
```

The repository can be cleaned up with:

```bash
$ make clean
```

## The source files

* `dependencies/` contains third party tools that are needed for compilation
* `doc/ecv.tex` The user documentation of the ECV class
* `patch/` Files needed for patching generated artifacts
* `src/ecv.cls` The LaTeX class of the package
* `src/ecvNLS.sty` Macros for the language selection
* `ecvEnglish.ldf` and `ecvGerman.ldf` Language support files with the translations
* `static` All files that will be added unchanged to the CTAN package like `README` and template sources

## Build artifacts

All build artifacts can be found in `build`. The `Makefile` builds the following artifacts:

* `ecv.ins` and `ecv.dtx` which contains the LaTeX installation package and the documentation source.
* `ecv.pdf` the documentation of the class
* `CV-template_*.pdf` PDF files of the ECV template documents

## Build dependencies

The build environment needs the following Unix tools to be installed:

* GNU make
* LaTeX (inclduding `latexmk`)
* perl
* Unix commandline: bash, echo, cp, mv, rm, ed, cut, mkdir, head

## Contributing

If you want to contribute fixes, improvements and new ideas please refer to [CONTRIBUTING.md](CONTRIBUTING.md) on how you can contribute.

## Contact

* [Bernd (Poldi) Haberstumpf <poldi@thatswing.de>](mailto:poldi@thatswing.de)
* [Christoph P. Neumann <c.p.neumann@gmail.com>](mailto:c.p.neumann@gmail.com)