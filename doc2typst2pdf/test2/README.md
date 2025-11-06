# DOCX to Typst Converter

Convert Microsoft Word documents (DOCX) to Typst format with automatic image optimization and post-processing to fix Pandoc formatting errors.

## Features

- **DOCX to Typst conversion** using Pandoc
- **Automatic image extraction** to `media/` folder
- **Image optimization** (typically 50%+ size reduction)
  - Converts PNG to JPG when beneficial
  - Resizes large images
  - Compresses without visible quality loss
  - Automatic path updates in Typst code
- **Post-processing** to fix Pandoc errors:
  - Fixes `#figure(#image())` → `#figure(image())` syntax
  - Removes excessive `#emph[]` and `#strong[]` wrappers
  - Normalizes image paths (`./media/` → `media/`)
  - Converts math notation (`#sub[]` → `_`, `#super[]` → `^`)
  - Removes Pandoc-generated TOC, adds Typst `#outline()`
  - Adds proper document metadata and French formatting
- **Optional PDF compilation** with Typst (if installed)

## Requirements

### Required Dependencies

1. **Python 3.x** with Pillow library:
   ```bash
   pip install Pillow
   ```

2. **Pandoc** (version 3.1+ with Typst support):
   - Ubuntu/Debian: `sudo apt-get install pandoc`
   - macOS: `brew install pandoc`
   - Windows: Download from https://pandoc.org/installing.html

### Optional Dependencies

3. **Typst compiler** (for automatic PDF generation):
   - Download from https://github.com/typst/typst
   - Or install via: `cargo install typst-cli`

## Installation

```bash
# 1. Clone the repository
git clone <your-repo-url>
cd doc2typst2pdf/test2/

# 2. Install Python dependencies
pip install Pillow

# 3. Install Pandoc (Ubuntu/Debian)
sudo apt-get install pandoc

# 4. (Optional) Install Typst for PDF generation
# See: https://github.com/typst/typst
```

## Usage

### Basic Usage

```bash
# Convert DOCX to Typst (auto-generates output filename)
python3 convert_docx_to_typst.py document.docx

# Specify custom output filename
python3 convert_docx_to_typst.py document.docx output.typ

# Interactive mode (prompts for file)
python3 convert_docx_to_typst.py
```

### Example Output

```
Converting: 24Mauzac_DIAG_Pile-RG.docx
Output: 24Mauzac_DIAG_Pile-RG.typ
============================================================

1. Preparing document...
   [OK] Using document: 24Mauzac_DIAG_Pile-RG.docx

2. Converting to Typst format...
   [OK] Typst file created: 24Mauzac_DIAG_Pile-RG.typ

3. Optimizing images...
   [OK] Optimized 49 image(s)
      Original size: 16853.8 KB
      Optimized size: 8092.8 KB
      Reduction: 52.0%
      Top reductions:
         image5.jpg: 92.6% smaller
         image4.jpg: 87.2% smaller
         image7.jpg: 85.2% smaller

4. Post-processing Typst file...
      Fixed math notation (#sub[] to _, #super[] to ^)
      Updated 11 PNG to JPG path(s)
   [OK] Post-processing complete

6. Compiling to PDF...
   [OK] PDF created: 24Mauzac_DIAG_Pile-RG.pdf
```

## What Gets Fixed

### Image Syntax

**Before (Pandoc output):**
```typst
#figure(#image("./media/image1.jpeg", height: 3.5in, width: 4.2in))
```

**After (corrected):**
```typst
#figure(image("media/image1.jpeg", width: 80%))
```

### Excessive Formatting

**Before:**
```typst
table.cell([#emph[Signatures];])
```

**After:**
```typst
table.cell([Signatures])
```

### Math Notation

**Before:**
```typst
H#sub[2]O   E = mc#super[2]
```

**After:**
```typst
H_2O   E = mc^2
```

## Workflow

1. **Convert** your DOCX file using the script
2. **Review** the generated `.typ` file
3. **Edit** manually if needed (fix tables, adjust formatting)
4. **Compile** to PDF:
   ```bash
   typst compile document.typ
   ```

## Advanced Options

### Custom Template

Place a Typst template file named `article-from-docx.typ` in the same directory as your DOCX file. The script will automatically use it.

### Image Optimization Settings

Edit the script to adjust optimization parameters:

```python
# In convert_docx_to_typst.py, line ~310
stats = optimize_images(
    media_path,
    quality=85,        # JPEG quality (1-100)
    max_width=2000,    # Maximum width in pixels
    create_backup=True # Backup originals to media/originals/
)
```

## File Structure

```
doc2typst2pdf/test2/
├── convert_docx_to_typst.py    # Main conversion script
├── README.md                    # This file
├── .gitignore                   # Excludes test artifacts
├── 24Mauzac_DIAG_Pile-RG.docx  # Example input file
├── 24Mauzac_DIAG_Pile-RG.typ   # Generated Typst file
└── media/                       # Extracted and optimized images
    ├── image1.jpeg
    ├── image2.jpg
    └── originals/               # Backup of original images (optional)
```

## Troubleshooting

### Pandoc Not Found

```
[ERROR] Conversion failed: [Errno 2] No such file or directory: 'pandoc'
```

**Solution:** Install Pandoc (see Requirements section)

### PIL/Pillow Not Found

```
ModuleNotFoundError: No module named 'PIL'
```

**Solution:** Install Pillow:
```bash
pip install Pillow
```

### Typst Compiler Not Found

```
[ERROR] Typst compiler not found
```

**Solution:** Either:
- Install Typst (see Requirements section), or
- Manually compile the `.typ` file later when Typst is available

### Image Format Issues

If some images don't display correctly, check:
1. EMF/WMF images are converted to PNG by Pandoc
2. The script automatically updates paths
3. Original images are backed up to `media/originals/`

## Known Limitations

- **EMF/WMF images**: Converted to PNG by Pandoc (may need manual adjustment)
- **Complex tables**: May require manual formatting fixes
- **Math equations**: Simple sub/superscripts are fixed, complex equations may need review
- **Custom Word styles**: Some custom styling may not transfer perfectly

## Contributing

If you find bugs or want to improve the script, please:
1. Create an issue describing the problem
2. Submit a pull request with fixes
3. Include example files that demonstrate the issue

## License

[Add your license here]

## Support

For issues or questions:
- Check the Troubleshooting section above
- Review Typst documentation: https://typst.app/docs
- Check Pandoc documentation: https://pandoc.org/MANUAL.html
