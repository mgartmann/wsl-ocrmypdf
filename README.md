# WSL-OCR Script

This simple script can be used to invoke `ocrmypdf` in WSL on a Windows computer. 
It does OCR on *all* PDF files found in a given path and saves the OCRd files as a copy.

**Note that this script is far from being polished or "production ready".**
I was simply tired of entering these commands manually every time I wanted to OCR my PDFs.

## Prerequisites

- installed WSL with a configured default distribution
- `ocrmypdf` installed in your WSL default distribution (see [ocrmypdf docs](https://ocrmypdf.readthedocs.io/en/latest/installation.html))
- installed tesseract language pack for German (`deu`) (see [ocrmypdf docs](https://ocrmypdf.readthedocs.io/en/latest/languages.html))

## Usage

- either simply download and run the `exe` file
- or run using PowerShell: `.\wsl-ocr.ps1`

## Build

- install `PS2EXE` ([https://github.com/MScholtes/PS2EXE](https://github.com/MScholtes/PS2EXE))
- build the `exe` file:

```shell
Invoke-ps2exe ".\wsl-ocr.ps1" "wsl-ocr.exe"
```
